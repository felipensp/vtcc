@[translated]
module main

fn C.dlsym(voidptr, &char) voidptr
fn C.dlclose(int)
fn C.unlink(&char)
fn C.strtol(&char, &&char, int) u64

@[export: 'shf_RELRO']
const shf_RELRO = (1 << 1) | (1 << 0)

@[export: 'rdata']
const rdata = c'.data.ro'

fn tccelf_new(s &TCCState) {
	s1 := s
	dynarray_add(&s.sections, &s.nb_sections, (unsafe { nil }))
	s1.text_section = new_section(s, c'.text', 1, (1 << 1) | (1 << 2))
	s1.data_section = new_section(s, c'.data', 1, (1 << 1) | (1 << 0))
	s1.rodata_section = new_section(s, rdata, 1, shf_RELRO)
	s1.bss_section = new_section(s, c'.bss', 8, (1 << 1) | (1 << 0))
	s1.common_section = new_section(s, c'.common', 8, 2147483648)
	s1.common_section.sh_num = 65522
	s1.symtab_section = new_symtab(s, c'.symtab', 2, 0, c'.strtab', c'.hashtab', 2147483648)
	s.symtab = s1.symtab_section
	s.dynsymtab_section = new_symtab(s, c'.dynsymtab', 2, 2147483648 | 1073741824, c'.dynstrtab',
		c'.dynhashtab', 2147483648)
	get_sym_attr(s, 0, 1)
	if s.do_debug {
		tcc_debug_new(s)
	}
	if s.do_bounds_check {
		s1.bounds_section = new_section(s, c'.bounds', 1, shf_RELRO)
		s1.lbounds_section = new_section(s, c'.lbounds', 1, shf_RELRO)
	}
}

fn free_section(s &Section) {
	tcc_free(s.data)
}

fn tccelf_delete(s1 &TCCState) {
	i := 0
	for i = 0; i < s1.nb_sym_versions; i++ {
		tcc_free(s1.sym_versions[i].version)
		tcc_free(s1.sym_versions[i].lib)
	}
	tcc_free(s1.sym_versions)
	tcc_free(s1.sym_to_version)
	for i = 1; i < s1.nb_sections; i++ {
		free_section(s1.sections[i])
	}
	dynarray_reset(&s1.sections, &s1.nb_sections)
	for i = 0; i < s1.nb_priv_sections; i++ {
		free_section(s1.priv_sections[i])
	}
	dynarray_reset(&s1.priv_sections, &s1.nb_priv_sections)
	for i = 0; i < s1.nb_loaded_dlls; i++ {
		ref := s1.loaded_dlls[i]
		if ref.handle {
			C.dlclose(ref.handle)
		}
	}
	dynarray_reset(&s1.loaded_dlls, &s1.nb_loaded_dlls)
	tcc_free(s1.sym_attrs)
	s1.symtab_section = (unsafe { nil })
}

fn tccelf_begin_file(s1 &TCCState) {
	s := &Section(0)
	i := 0
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		s.sh_offset = s.data_offset
	}
	s.hash = unsafe { nil }
	s.reloc = s.hash
	s = s1.symtab
}

fn tccelf_end_file(s1 &TCCState) {
	s := s1.symtab
	first_sym := 0
	nb_syms := 0
	tr := &int(0)
	i := 0

	first_sym = s.sh_offset / sizeof(Elf64_Sym)
	nb_syms = s.data_offset / sizeof(Elf64_Sym) - first_sym
	s.data_offset = s.sh_offset
	s.link.data_offset = s.link.sh_offset
	s.hash = s.reloc
	s.reloc = unsafe { nil }
	tr = tcc_mallocz(nb_syms * sizeof(*tr))
	for i = 0; i < nb_syms; i++ {
		sym := unsafe { &Elf64_Sym(s.data) + first_sym + i }
		if sym.st_shndx == 0 {
			sym_bind := ((u8((sym.st_info))) >> 4)
			sym_type := ((sym.st_info) & 15)
			if sym_bind == 0 {
				sym_bind = 1
			}
			if sym_bind == 1 && s1.output_type == 3 {
				sym_type = 0
			}
			sym.st_info = ((sym_bind << 4) + (sym_type & 15))
		}
		tr[i] = set_elf_sym(s, sym.st_value, sym.st_size, sym.st_info, sym.st_other, sym.st_shndx,
			&i8(s.link.data) + sym.st_name)
	}
	for i = 1; i < s1.nb_sections; i++ {
		sr := s1.sections[i]
		if sr.sh_type == 4 && sr.link == s {
			rel := &Elf64_Rela((sr.data + sr.sh_offset))
			rel_end := &Elf64_Rela((sr.data + sr.data_offset))
			for ; voidptr(rel) < voidptr(rel_end); unsafe { rel++ } {
				n := ((rel.r_info) >> 32) - first_sym
				if n < 0 {
					continue
				}
				rel.r_info = (((Elf64_Xword(u64(tr[n]))) << 32) + ((rel.r_info) & 4294967295))
			}
		}
	}
	tcc_free(tr)
	for i = 0; i < 4; i++ {
		s = s1.sections[i + 1]
		s1.total_output[i] += s.data_offset - s.sh_offset
	}
}

fn new_section(s1 &TCCState, name &i8, sh_type int, sh_flags int) &Section {
	sec := &Section(0)
	unsafe {
		sec = tcc_mallocz(sizeof(Section) + C.strlen(name))
		sec.s1 = s1
		C.strcpy(sec.name, name)
	}
	sec.sh_type = sh_type
	sec.sh_flags = sh_flags
	match sh_type {
		1879048191 { // case comp body kind=BinaryOperator is_enum=false
			sec.sh_addralign = 2
		}
		5, 1879048182, 9, 4, 11, 2, 6, 1879048190, 1879048189 {
			sec.sh_addralign = 8
		}
		3 { // case comp body kind=BinaryOperator is_enum=false
			sec.sh_addralign = 1
		}
		else {
			sec.sh_addralign = 8
		}
	}
	if sh_flags & 2147483648 {
		dynarray_add(&s1.priv_sections, &s1.nb_priv_sections, sec)
	} else {
		sec.sh_num = s1.nb_sections
		dynarray_add(&s1.sections, &s1.nb_sections, sec)
	}
	return sec
}

fn new_symtab(s1 &TCCState, symtab_name &i8, sh_type int, sh_flags int, strtab_name &i8, hash_name &i8, hash_sh_flags int) &Section {
	symtab := &Section(0)
	strtab := &Section(0)
	hash := &Section(0)

	ptr := &int(0)
	nb_buckets := 0

	symtab = new_section(s1, symtab_name, sh_type, sh_flags)
	symtab.sh_entsize = sizeof(Elf64_Sym)
	strtab = new_section(s1, strtab_name, 3, sh_flags)
	put_elf_str(strtab, c'')
	symtab.link = strtab
	put_elf_sym(symtab, 0, 0, 0, 0, 0, (unsafe { nil }))
	nb_buckets = 1
	hash = new_section(s1, hash_name, 5, hash_sh_flags)
	hash.sh_entsize = sizeof(int)
	symtab.hash = hash
	hash.link = symtab
	ptr = section_ptr_add(hash, (2 + nb_buckets + 1) * sizeof(int))
	ptr[0] = nb_buckets
	ptr[1] = 1
	unsafe { C.memset(ptr + 2, 0, (nb_buckets + 1) * sizeof(int)) }
	return symtab
}

fn section_realloc(sec &Section, new_size u32) {
	size := u32(0)
	data := &u8(0)
	size = sec.data_allocated
	if size == 0 {
		size = 1
	}
	for size < new_size {
		size = size * 2
	}
	data = tcc_realloc(sec.data, size)
	unsafe { C.memset(data + sec.data_allocated, 0, size - sec.data_allocated) }
	sec.data = data
	sec.data_allocated = size
}

fn section_add(sec &Section, size Elf64_Addr, align int) usize {
	offset := usize(0)
	offset1 := usize(0)

	offset = (sec.data_offset + align - 1) & -align
	offset1 = offset + size
	if sec.sh_type != 8 && offset1 > sec.data_allocated {
		section_realloc(sec, offset1)
	}
	sec.data_offset = offset1
	if align > sec.sh_addralign {
		sec.sh_addralign = align
	}
	return offset
}

fn section_ptr_add(sec &Section, size Elf64_Addr) voidptr {
	offset := section_add(sec, size, 1)
	return unsafe { sec.data + offset }
}

fn section_reserve(sec &Section, size u32) {
	if size > sec.data_allocated {
		section_realloc(sec, size)
	}
	if size > sec.data_offset {
		sec.data_offset = size
	}
}

fn have_section(s1 &TCCState, name &i8) &Section {
	sec := &Section(0)
	i := 0
	for i = 1; i < s1.nb_sections; i++ {
		sec = s1.sections[i]
		if !C.strcmp(name, sec.name) {
			return sec
		}
	}
	return unsafe { nil }
}

fn find_section(s1 &TCCState, name &i8) &Section {
	sec := have_section(s1, name)
	if sec {
		return sec
	}
	return new_section(s1, name, 1, (1 << 1))
}

fn put_elf_str(s &Section, sym &i8) int {
	offset := 0
	len := 0

	ptr := &i8(0)
	len = unsafe { C.strlen(sym) + 1 }
	offset = s.data_offset
	ptr = section_ptr_add(s, len)
	unsafe { C.memmove(ptr, sym, len) }
	return offset
}

fn elf_hash(name &u8) Elf64_Word {
	h := 0
	g := Elf64_Word(0)

	for *name {
		h = (h << 4) + unsafe { *name++ }
		g = h & 4026531840
		if g {
			h ^= g >> 24
		}
		h &= ~g
	}
	return h
}

fn rebuild_hash(s &Section, nb_buckets u32) {
	sym := &Elf64_Sym(0)
	ptr := &int(0)
	hash := &int(0)
	nb_syms := 0
	sym_index := 0
	h := 0

	strtab := &u8(0)
	strtab = s.link.data
	nb_syms = s.data_offset / sizeof(Elf64_Sym)
	if !nb_buckets {
		nb_buckets = unsafe { (&int(s.hash.data))[0] }
	}
	s.hash.data_offset = 0
	ptr = section_ptr_add(s.hash, (2 + nb_buckets + nb_syms) * sizeof(int))
	ptr[0] = nb_buckets
	ptr[1] = nb_syms
	ptr += 2
	hash = ptr
	unsafe { C.memset(hash, 0, (nb_buckets + 1) * sizeof(int)) }
	ptr += nb_buckets + 1
	sym = unsafe { &Elf64_Sym(s.data) + 1 }
	for sym_index = 1; sym_index < nb_syms; sym_index++ {
		if ((u8((sym.st_info))) >> 4) != 0 {
			h = elf_hash(unsafe { strtab + sym.st_name }) % nb_buckets
			*ptr = hash[h]
			hash[h] = sym_index
		} else {
			*ptr = 0
		}
		unsafe { ptr++ }
		unsafe { sym++ }
	}
}

fn put_elf_sym(s &Section, value Elf64_Addr, size u32, info int, other int, shndx int, name &i8) int {
	name_offset := 0
	sym_index := 0

	nbuckets := 0
	h := 0

	sym := &Elf64_Sym(0)
	hs := &Section(0)
	sym = section_ptr_add(s, sizeof(Elf64_Sym))
	if name && name[0] {
		name_offset = put_elf_str(s.link, name)
	} else { // 3
		name_offset = 0
	}
	sym.st_name = name_offset
	sym.st_value = value
	sym.st_size = size
	sym.st_info = info
	sym.st_other = other
	sym.st_shndx = shndx
	sym_index = unsafe { sym - voidptr(&Elf64_Sym(s.data)) }
	hs = s.hash
	if hs {
		ptr := &int(0)
		base := &int(0)

		ptr = section_ptr_add(hs, sizeof(int))
		base = unsafe { &int(hs.data) }
		if ((u8(info)) >> 4) != 0 {
			nbuckets = base[0]
			h = unsafe { elf_hash(&u8(s.link.data) + name_offset) % nbuckets }
			*ptr = base[2 + h]
			base[2 + h] = sym_index
			base[1]++
			hs.nb_hashed_syms++
			if hs.nb_hashed_syms > 2 * nbuckets {
				rebuild_hash(s, 2 * nbuckets)
			}
		} else {
			*ptr = 0
			base[1]++
		}
	}
	return sym_index
}

fn find_elf_sym(s &Section, name &i8) int {
	sym := &Elf64_Sym(0)
	hs := &Section(0)
	nbuckets := 0
	sym_index := 0
	h := 0

	name1 := &i8(0)
	hs = s.hash
	if !hs {
		return 0
	}
	nbuckets = unsafe { (&int(hs.data))[0] }
	h = elf_hash(&u8(name)) % nbuckets
	sym_index = unsafe { (&int(hs.data))[2 + h] }
	for sym_index != 0 {
		sym = &(&Elf64_Sym(s.data))[sym_index]
		name1 = unsafe { &i8(s.link.data) + sym.st_name }
		if unsafe { !C.strcmp(name, name1) } {
			return sym_index
		}
		sym_index = unsafe { (&int(hs.data))[2 + nbuckets + sym_index] }
	}
	return 0
}

fn get_sym_addr(s1 &TCCState, name &i8, err int, forc int) Elf64_Addr {
	sym_index := 0
	sym := &Elf64_Sym(0)
	buf := [256]i8{}
	if forc && s1.leading_underscore {
		buf[0] = `_`
		pstrcpy(buf + 1, sizeof(buf) - 1, name)
		name = buf
	}
	sym_index = find_elf_sym(s1.symtab, name)
	sym = &(&Elf64_Sym(s1.symtab.data))[sym_index]
	if !sym_index || sym.st_shndx == 0 {
		if err {
			_tcc_error_noabort('${name} not defined')
		}
		return Elf64_Addr(-1)
	}
	return sym.st_value
}

fn tcc_get_symbol(s &TCCState, name &i8) voidptr {
	addr := get_sym_addr(s, name, 0, 1)
	return unsafe {
		voidptr(if addr == -1 {
			nil
		} else {
			uintptr_t(addr)
		})
	}
}

fn list_elf_symbols(s &TCCState, ctx voidptr, symbol_cb fn (voidptr, &i8, voidptr)) {
	sym := &Elf64_Sym(0)
	symtab := &Section(0)
	sym_index := 0
	end_sym := 0

	name := &i8(0)
	sym_vis := u8(0)
	sym_bind := u8(0)

	symtab = s.symtab
	end_sym = symtab.data_offset / sizeof(Elf64_Sym)
	for sym_index = 0; sym_index < end_sym; sym_index++ {
		sym = &(&Elf64_Sym(symtab.data))[sym_index]
		if sym.st_value {
			name = unsafe { &i8(symtab.link.data) + sym.st_name }
			sym_bind = ((u8((sym.st_info))) >> 4)
			sym_vis = ((sym.st_other) & 3)
			if sym_bind == 1 && sym_vis == 0 {
				symbol_cb(ctx, name, voidptr(uintptr_t(sym.st_value)))
			}
		}
	}
}

fn tcc_list_symbols(s &TCCState, ctx voidptr, symbol_cb fn (voidptr, &i8, voidptr)) {
	list_elf_symbols(s, ctx, symbol_cb)
}

fn version_add(s1 &TCCState) {
	i := 0
	sym := &Elf64_Sym(0)
	vn := &Elf64_Verneed{}
	symtab := &Section(0)
	sym_index := 0
	end_sym := 0
	nb_versions := 2
	nb_entries := 0

	versym := &Elf64_Half(0)
	name := &i8(0)
	if 0 == s1.nb_sym_versions {
		return
	}
	s1.versym_section = new_section(s1, c'.gnu.version', 1879048191, (1 << 1))
	s1.versym_section.sh_entsize = sizeof(Elf64_Half)
	s1.versym_section.link = s1.dynsym
	symtab = s1.dynsym
	end_sym = symtab.data_offset / sizeof(Elf64_Sym)
	versym = section_ptr_add(s1.versym_section, end_sym * sizeof(Elf64_Half))
	for sym_index = 1; sym_index < end_sym; sym_index++ {
		dllindex := 0
		verndx := 0

		sym = &(&Elf64_Sym(symtab.data))[sym_index]
		if sym.st_shndx != 0 {
			continue
		}
		name = unsafe { &i8(symtab.link.data) + sym.st_name }
		dllindex = find_elf_sym(s1.dynsymtab_section, name)
		verndx = if (dllindex && dllindex < s1.nb_sym_to_version) {
			s1.sym_to_version[dllindex]
		} else {
			-1
		}
		if verndx >= 0 {
			if !s1.sym_versions[verndx].out_index {
				s1.sym_versions[verndx].out_index = nb_versions++
			}
			versym[sym_index] = s1.sym_versions[verndx].out_index
		}
	}
	if nb_versions > 2 {
		s1.verneed_section = new_section(s1, c'.gnu.version_r', 1879048190, (1 << 1))
		s1.verneed_section.link = s1.dynsym.link
		for i = s1.nb_sym_versions; i > 0; {
			sv := &s1.sym_versions[i]
			n_same_libs := 0
			prev := 0

			vnofs := usize(0)
			vna := &Elf64_Vernaux(0)
			if sv.out_index < 1 {
				i--
				continue
			}
			if unsafe { C.strcmp(sv.lib, c'ld-linux.so.2') } {
				tcc_add_dllref(s1, sv.lib, 0)
			}
			vnofs = section_add(s1.verneed_section, sizeof(*vn), 1)
			unsafe {
				vn = &Elf64_Verneed((s1.verneed_section.data + vnofs))
			}
			vn.vn_version = 1
			vn.vn_file = put_elf_str(s1.verneed_section.link, sv.lib)
			vn.vn_aux = sizeof(*vn)
			for {
				prev = sv.prev_same_lib
				if sv.out_index > 0 {
					vna = &Elf64_Vernaux(section_ptr_add(s1.verneed_section, sizeof(*vna)))
					vna.vna_hash = elf_hash(&i8(sv.version))
					vna.vna_flags = 0
					vna.vna_other = sv.out_index
					sv.out_index = -2
					vna.vna_name = put_elf_str(s1.verneed_section.link, sv.version)
					vna.vna_next = sizeof(*vna)
					n_same_libs++
				}
				if prev >= 0 {
					sv = &s1.sym_versions[prev]
				}
				// while()
				if !(prev >= 0) {
					break
				}
			}
			vna.vna_next = 0
			vn = unsafe { &Elf64_Verneed((s1.verneed_section.data + vnofs)) }
			vn.vn_cnt = n_same_libs
			vn.vn_next = sizeof(*vn) + n_same_libs * sizeof(*vna)
			nb_entries++
			i--
		}
		if vn {
			vn.vn_next = 0
		}
		s1.verneed_section.sh_info = nb_entries
	}
	s1.dt_verneednum = nb_entries
}

fn set_elf_sym(s &Section, value Elf64_Addr, size u32, info int, other int, shndx int, name &i8) int {
	s1 := s.s1
	esym := &Elf64_Sym(0)
	sym_bind := 0
	sym_index := 0
	sym_type := 0
	esym_bind := 0

	sym_vis := u8(0)
	esym_vis := u8(0)
	new_vis := u8(0)

	sym_bind = ((u8(info)) >> 4)
	sym_type = (info & 15)
	sym_vis = (other & 3)
	if sym_bind != 0 {
		sym_index = find_elf_sym(s, name)
		if !sym_index {
			unsafe {
				goto do_def
			} // id: 0x7fffe8fdba20
		}
		esym = &(&Elf64_Sym(s.data))[sym_index]
		if esym.st_value == value && esym.st_size == size && esym.st_info == info
			&& esym.st_other == other && esym.st_shndx == shndx {
			return sym_index
		}
		if esym.st_shndx != 0 {
			esym_bind = ((u8((esym.st_info))) >> 4)
			esym_vis = ((esym.st_other) & 3)
			if esym_vis == 0 {
				new_vis = sym_vis
			} else if sym_vis == 0 {
				new_vis = esym_vis
			} else {
				new_vis = if (esym_vis < sym_vis) { esym_vis } else { sym_vis }
			}
			esym.st_other = (esym.st_other & ~((-1) & 3)) | new_vis
			if shndx == 0 {
			} else if sym_bind == 1 && esym_bind == 2 {
				unsafe {
					goto do_patch
				} // id: 0x7fffe8fdced0
			} else if sym_bind == 2 && esym_bind == 1 {
			} else if sym_bind == 2 && esym_bind == 2 {
			} else if sym_vis == 2 || sym_vis == 1 {
			} else if (esym.st_shndx == 65522 || esym.st_shndx == s1.bss_section.sh_num)
				&& (shndx < 65280 && shndx != s1.bss_section.sh_num) {
				unsafe {
					goto do_patch
				} // id: 0x7fffe8fdced0
			} else if shndx == 65522 || shndx == s1.bss_section.sh_num {
			} else if s.sh_flags & 1073741824 {
			} else if esym.st_other & 4 {
				unsafe {
					goto do_patch
				} // id: 0x7fffe8fdced0
			} else {
				_tcc_error_noabort("'${name}' defined twice")
			}
		} else {
			esym.st_other = other
			// RRRREG do_patch id=0x7fffe8fdced0
			do_patch:
			esym.st_info = ((sym_bind << 4) + (sym_type & 15))
			esym.st_shndx = shndx
			s1.new_undef_sym = 1
			esym.st_value = value
			esym.st_size = size
		}
	} else {
		// RRRREG do_def id=0x7fffe8fdba20
		do_def:
		sym_index = put_elf_sym(s, value, size, ((sym_bind << 4) + (sym_type & 15)), other,
			shndx, name)
	}
	return sym_index
}

fn put_elf_reloca(symtab &Section, s &Section, offset u32, type_ int, symbol int, addend Elf64_Addr) {
	s1 := s.s1
	buf := [256]i8{}
	sr := &Section(0)
	rel := &Elf64_Rela(0)
	sr = s.reloc
	if !sr {
		unsafe { C.snprintf(buf, sizeof(buf), c'.rela%s', s.name) }
		sr = new_section(s.s1, buf, 4, symtab.sh_flags)
		sr.sh_entsize = sizeof(Elf64_Rela)
		sr.link = symtab
		sr.sh_info = s.sh_num
		s.reloc = sr
	}
	rel = section_ptr_add(sr, sizeof(Elf64_Rela))
	rel.r_offset = offset
	rel.r_info = (((Elf64_Xword(u64(symbol))) << 32) + type_)
	rel.r_addend = addend
	if 4 != 4 && addend {
		_tcc_error_noabort('non-zero addend on REL architecture')
	}
}

fn put_elf_reloc(symtab &Section, s &Section, offset u32, type_ int, symbol int) {
	put_elf_reloca(symtab, s, offset, type_, symbol, 0)
}

fn get_sym_attr(s1 &TCCState, index int, alloc int) &Sym_attr {
	n := 0
	tab := &Sym_attr(0)
	if index >= s1.nb_sym_attrs {
		if !alloc {
			return s1.sym_attrs
		}
		n = 1
		for index >= n {
			n *= 2
		}
		tab = tcc_realloc(s1.sym_attrs, n * sizeof(*s1.sym_attrs))
		s1.sym_attrs = tab
		unsafe {
			C.memset(s1.sym_attrs + s1.nb_sym_attrs, 0, (n - s1.nb_sym_attrs) * sizeof(*s1.sym_attrs))
		}
		s1.nb_sym_attrs = n
	}
	return &s1.sym_attrs[index]
}

fn modify_reloctions_old_to_new(s1 &TCCState, s &Section, old_to_new_syms &int) {
	i := 0
	type_ := 0
	sym_index := 0

	sr := &Section(0)
	rel := &Elf64_Rela(0)
	for i = 1; i < s1.nb_sections; i++ {
		sr = s1.sections[i]
		if sr.sh_type == 4 && sr.link == s {
			for rel = &Elf64_Rela(sr.data); unsafe {
				voidptr(rel) < &Elf64_Rela((sr.data + sr.data_offset))
			}; unsafe { rel++ } {
				sym_index = ((rel.r_info) >> 32)
				type_ = ((rel.r_info) & 4294967295)
				sym_index = old_to_new_syms[sym_index]
				rel.r_info = (((Elf64_Xword(u64(sym_index))) << 32) + type_)
			}
		}
	}
}

fn sort_syms(s1 &TCCState, s &Section) {
	old_to_new_syms := &int(0)
	new_syms := &Elf64_Sym(0)
	nb_syms := 0
	i := 0

	p := &Elf64_Sym(0)
	q := &Elf64_Sym(0)

	nb_syms = s.data_offset / sizeof(Elf64_Sym)
	new_syms = tcc_malloc(nb_syms * sizeof(Elf64_Sym))
	old_to_new_syms = tcc_malloc(nb_syms * sizeof(int))
	p = &Elf64_Sym(s.data)
	q = new_syms
	for i = 0; i < nb_syms; i++ {
		if ((u8((p.st_info))) >> 4) == 0 {
			unsafe {
				old_to_new_syms[i] = q - voidptr(new_syms)
			}
			unsafe {
				*q++ = *p
			}
		}
		unsafe { p++ }
	}
	if s.sh_size {
		s.sh_info = unsafe { q - voidptr(new_syms) }
	}
	p = &Elf64_Sym(s.data)
	for i = 0; i < nb_syms; i++ {
		if ((u8((p.st_info))) >> 4) != 0 {
			old_to_new_syms[i] = unsafe { q - voidptr(new_syms) }
			unsafe {
				*q++ = *p
			}
		}
		unsafe { p++ }
	}
	unsafe { C.memcpy(s.data, new_syms, nb_syms * sizeof(Elf64_Sym)) }
	tcc_free(new_syms)
	modify_reloctions_old_to_new(s1, s, old_to_new_syms)
	tcc_free(old_to_new_syms)
}

fn create_gnu_hash(s1 &TCCState) &Section {
	nb_syms := 0
	i := 0
	ndef := 0
	nbuckets := 0
	symoffset := 0
	bloom_size := 0
	bloom_shift := 0

	p := &Elf64_Sym(0)
	gnu_hash := &Section(0)
	dynsym := s1.dynsym
	ptr := &Elf32_Word(0)
	gnu_hash = new_section(s1, c'.gnu.hash', 1879048182, (1 << 1))
	gnu_hash.link = dynsym.hash.link
	nb_syms = dynsym.data_offset / sizeof(Elf64_Sym)
	ndef = 0
	p = &Elf64_Sym(dynsym.data)
	for i = 0; i < nb_syms; i++, unsafe { p++ } {
		ndef += p.st_shndx != 0
	}
	nbuckets = ndef / 4 + 1
	symoffset = nb_syms - ndef
	bloom_shift = if 8 == 8 { 6 } else { 5 }
	bloom_size = 1
	for ndef >= bloom_size * (1 << (bloom_shift - 3)) {
		bloom_size *= 2
	}
	ptr = section_ptr_add(gnu_hash, 4 * 4 + 8 * bloom_size + nbuckets * 4 + ndef * 4)
	ptr[0] = nbuckets
	ptr[1] = symoffset
	ptr[2] = bloom_size
	ptr[3] = bloom_shift
	return gnu_hash
}

fn elf_gnu_hash(name &u8) Elf32_Word {
	h := 5381
	c := u8(0)
	for {
		unsafe {
			c = *name++
		}
		if !c {
			break
		}
		h = h * 33 + c
	}
	return h
}

struct buck {
	first int
	last  int
}

fn update_gnu_hash(s1 &TCCState, gnu_hash &Section) {
	old_to_new_syms := &int(0)
	new_syms := &Elf64_Sym(0)
	nb_syms := 0
	i := 0
	nbuckets := 0
	bloom_size := 0
	bloom_shift := 0

	p := &Elf64_Sym(0)
	q := &Elf64_Sym(0)

	vs := &Section(0)
	dynsym := s1.dynsym
	ptr := &Elf32_Word(0)
	buckets := &Elf32_Word(0)
	chain := &Elf32_Word(0)
	hash := &Elf32_Word(0)

	nextbuck := &u32(0)
	bloom := &Elf64_Addr(0)
	strtab := &u8(0)

	strtab = dynsym.link.data
	nb_syms = dynsym.data_offset / sizeof(Elf64_Sym)
	new_syms = tcc_malloc(nb_syms * sizeof(Elf64_Sym))
	old_to_new_syms = tcc_malloc(nb_syms * sizeof(int))
	hash = tcc_malloc(nb_syms * sizeof(Elf32_Word))
	nextbuck = tcc_malloc(nb_syms * sizeof(int))
	p = &Elf64_Sym(dynsym.data)
	q = new_syms
	for i = 0; i < nb_syms; i++, unsafe { p++ } {
		if p.st_shndx == 0 {
			unsafe {
				old_to_new_syms[i] = q - voidptr(new_syms)
			}
			unsafe {
				*q++ = *p
			}
		} else { // 3
			unsafe {
				hash[i] = elf_gnu_hash(strtab + p.st_name)
			}
		}
	}
	ptr = &Elf32_Word(gnu_hash.data)
	nbuckets = ptr[0]
	bloom_size = ptr[2]
	bloom_shift = ptr[3]
	bloom = &Elf64_Addr(voidptr(&ptr[4]))
	buckets = &Elf32_Word(voidptr(&bloom[bloom_size]))
	chain = &buckets[nbuckets]
	buck := &buck(tcc_malloc(nbuckets * sizeof(buck)))
	unsafe {
		if gnu_hash.data_offset != 4 * 4 + 8 * bloom_size + nbuckets * 4 +
			(nb_syms - (q - voidptr(new_syms))) * 4 {
			_tcc_error_noabort('gnu_hash size incorrect')
		}
	}
	for i = 0; i < nbuckets; i++ {
		buck[i].first = -1
	}
	p = &Elf64_Sym(dynsym.data)
	for i = 0; i < nb_syms; i++, unsafe { p++ } {
		if p.st_shndx != 0 {
			bucket := hash[i] % nbuckets
			if buck[bucket].first == -1 {
				buck[bucket].first = i
				buck[bucket].last = buck[bucket].first
			} else {
				nextbuck[buck[bucket].last] = i
				buck[bucket].last = i
			}
		}
	}
	p = &Elf64_Sym(dynsym.data)
	for i = 0; i < nbuckets; i++ {
		cur := buck[i].first
		if cur != -1 {
			unsafe {
				buckets[i] = q - voidptr(new_syms)
			}
			for ; true; {
				unsafe {
					old_to_new_syms[cur] = q - voidptr(new_syms)
				}
				unsafe {
					*q++ = p[cur]
				}
				unsafe {
					*chain++ = hash[cur] & ~1
				}
				bloom[(hash[cur] / (8 * 8)) % bloom_size] |= Elf64_Addr(1) << (hash[cur] % (8 * 8)) | Elf64_Addr(1) << ((hash[cur] >> bloom_shift) % (8 * 8))
				if cur == buck[i].last {
					break
				}
				cur = nextbuck[cur]
			}
			chain[-1] |= 1
		}
	}
	unsafe {
		C.memcpy(dynsym.data, new_syms, nb_syms * sizeof(Elf64_Sym))
	}
	tcc_free(new_syms)
	tcc_free(hash)
	tcc_free(buck)
	tcc_free(nextbuck)
	modify_reloctions_old_to_new(s1, dynsym, old_to_new_syms)
	vs = s1.versym_section
	if vs {
		newver := &Elf64_Half(0)
		versym := &Elf64_Half(vs.data)

		if 1 {
			newver = tcc_malloc(nb_syms * sizeof(*newver))
			for i = 0; i < nb_syms; i++ {
				newver[old_to_new_syms[i]] = versym[i]
			}
			unsafe { C.memcpy(vs.data, newver, nb_syms * sizeof(*newver)) }
			tcc_free(newver)
		}
	}
	tcc_free(old_to_new_syms)
	ptr = &Elf32_Word(dynsym.hash.data)
	rebuild_hash(dynsym, ptr[0])
}

fn relocate_syms(s1 &TCCState, symtab &Section, do_resolve int) {
	sym := &Elf64_Sym(0)
	sym_bind := 0
	sh_num := 0

	name := &i8(0)
	for sym = unsafe { &Elf64_Sym(symtab.data) + 1 }; unsafe {
		voidptr(sym) < &Elf64_Sym((symtab.data + symtab.data_offset))
	}; unsafe { sym++ } {
		sh_num = sym.st_shndx
		if sh_num == 0 {
			if do_resolve == 2 {
				continue
			}
			name = &i8(s1.symtab.link.data) + sym.st_name
			if do_resolve {
				addr := C.dlsym((unsafe { nil }), &name[s1.leading_underscore])
				if addr {
					sym.st_value = Elf64_Addr(u64(addr))
					unsafe {
						goto found
					} // id: 0x7fffe8ff9bc8
				}
			} else if unsafe { s1.dynsym != nil } && find_elf_sym(s1.dynsym, name) {
				unsafe {
					goto found
				} // id: 0x7fffe8ff9bc8
			}
			if !C.strcmp(name, c'_fp_hw') {
				unsafe {
					goto found
				} // id: 0x7fffe8ff9bc8
			}
			sym_bind = ((u8((sym.st_info))) >> 4)
			if sym_bind == 2 {
				sym.st_value = 0
			} else { // 3
				_tcc_error_noabort("undefined symbol '${name}'")
			}
		} else if sh_num < 65280 {
			sym.st_value += s1.sections[sym.st_shndx].sh_addr
		}
		// RRRREG found id=0x7fffe8ff9bc8
		found:
	}
}

fn relocate_section(s1 &TCCState, s &Section, sr &Section) {
	rel := &Elf64_Rela(0)
	sym := &Elf64_Sym(0)
	type_ := 0
	sym_index := 0

	ptr := &u8(0)
	tgt := Elf64_Addr(0)
	addr := Elf64_Addr(0)

	is_dwarf := s.sh_num >= s1.dwlo && s.sh_num < s1.dwhi
	s1.qrel = &Elf64_Rela(sr.data)
	for rel = unsafe { &Elf64_Rela(sr.data) }; unsafe {
		voidptr(rel) < &Elf64_Rela((sr.data + sr.data_offset))
	}; unsafe { rel++ } {
		ptr = unsafe { s.data + rel.r_offset }
		sym_index = ((rel.r_info) >> 32)
		sym = &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
		type_ = ((rel.r_info) & 4294967295)
		tgt = sym.st_value
		tgt += rel.r_addend
		if is_dwarf && type_ == 10 && sym.st_shndx >= s1.dwlo && sym.st_shndx < s1.dwhi {
			add32le(ptr, tgt - s1.sections[sym.st_shndx].sh_addr)
			continue
		}
		addr = s.sh_addr + rel.r_offset
		relocate(s1, rel, type_, ptr, addr, tgt)
	}
	if sr.sh_flags & (1 << 1) {
		sr.link = s1.dynsym
		if s1.output_type & 4 {
			r := unsafe { &u8(s1.qrel) - sr.data }
			if sizeof(u32) < 8 && 0 == unsafe { C.strcmp(s.name, c'.stab') } {
				r = 0
			}
			sr.data_offset = r
			sr.sh_size = sr.data_offset
		}
	}
}

fn relocate_sections(s1 &TCCState) {
	i := 0
	s := &Section(0)
	sr := &Section(0)

	for i = 1; i < s1.nb_sections; i++ {
		sr = s1.sections[i]
		if sr.sh_type != 4 {
			continue
		}
		s = s1.sections[sr.sh_info]
		if s != s1.got || s1.static_link || s1.output_type == 1 {
			relocate_section(s1, s, sr)
		}
		if sr.sh_flags & (1 << 1) {
			rel := &Elf64_Rela(0)
			for rel = unsafe { &Elf64_Rela(sr.data) }; unsafe {
				voidptr(rel) < &Elf64_Rela((sr.data + sr.data_offset))
			}; unsafe { rel++ } {
				rel.r_offset += s.sh_addr
			}
		}
	}
}

fn prepare_dynamic_rel(s1 &TCCState, sr &Section) int {
	count := 0
	rel := &Elf64_Rela(0)
	for rel = unsafe { &Elf64_Rela(sr.data) }; unsafe {
		voidptr(rel) < &Elf64_Rela((sr.data + sr.data_offset))
	}; unsafe { rel++ } {
		sym_index := ((rel.r_info) >> 32)
		type_ := ((rel.r_info) & 4294967295)
		match type_ {
			10, 11, 1 {
				count++
			}
			2 {
				// case comp stmt
				sym := &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
				if sym.st_shndx != 0 && ((sym.st_other) & 3) == 2 {
					rel.r_info = (((Elf64_Xword(sym_index)) << 32) + (4))
				}

				if s1.output_type != 4 {
				}
				if get_sym_attr(s1, sym_index, 0).dyn_index != 0 {
					count++
				}
			}
			else {}
		}
	}
	return count
}

fn build_got(s1 &TCCState) int {
	s1.got = new_section(s1, c'.got', 1, (1 << 1) | (1 << 0))
	s1.got.sh_entsize = 4
	section_ptr_add(s1.got, 3 * 8)
	return set_elf_sym(s1.symtab_section, 0, 0, (((1) << 4) + ((1) & 15)), 0, s1.got.sh_num,
		c'_GLOBAL_OFFSET_TABLE_')
}

fn put_got_entry(s1 &TCCState, dyn_reloc_type int, sym_index int) &Sym_attr {
	need_plt_entry := 0
	name := &i8(0)
	sym := &Elf64_Sym(0)
	attr := &Sym_attr(0)
	got_offset := u32(0)
	plt_name := [200]i8{}
	len := 0
	s_rel := &Section(0)
	need_plt_entry = (dyn_reloc_type == 7)
	attr = get_sym_attr(s1, sym_index, 1)
	if if need_plt_entry {
		attr.plt_offset
	} else {
		attr.got_offset
	} {
		return attr
	}
	s_rel = s1.got
	if need_plt_entry {
		if !s1.plt {
			s1.plt = new_section(s1, c'.plt', 1, (1 << 1) | (1 << 2))
			s1.plt.sh_entsize = 4
		}
		s_rel = s1.plt
	}
	got_offset = s1.got.data_offset
	section_ptr_add(s1.got, 8)
	sym = &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
	name = unsafe { &i8(s1.symtab_section.link.data) + sym.st_name }
	if s1.dynsym {
		if ((u8((sym.st_info))) >> 4) == 0 {
			put_elf_reloc(s1.dynsym, s1.got, got_offset, 8, sym_index)
		} else {
			if 0 == attr.dyn_index {
				attr.dyn_index = set_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info,
					0, sym.st_shndx, name)
			}
			put_elf_reloc(s1.dynsym, s_rel, got_offset, dyn_reloc_type, attr.dyn_index)
		}
	} else {
		put_elf_reloc(s1.symtab_section, s1.got, got_offset, dyn_reloc_type, sym_index)
	}
	if need_plt_entry {
		attr.plt_offset = create_plt_entry(s1, got_offset, attr)
		len = unsafe { C.strlen(name) }
		if len > sizeof(plt_name) - 5 {
			len = sizeof(plt_name) - 5
		}
		unsafe {
			C.memcpy(plt_name, name, len)
			C.strcpy(plt_name + len, c'@plt')
		}
		attr.plt_sym = put_elf_sym(s1.symtab, attr.plt_offset, 0, (((1) << 4) + ((2) & 15)),
			0, s1.plt.sh_num, plt_name)
	} else {
		attr.got_offset = got_offset
	}
	return attr
}

fn build_got_entries(s1 &TCCState, got_sym int) {
	s := &Section(0)
	rel := &Elf64_Rela(0)
	sym := &Elf64_Sym(0)
	i := 0
	type_ := 0
	gotplt_entry := 0
	reloc_type := 0
	sym_index := 0

	attr := &Sym_attr(0)
	pass := 0
	// RRRREG redo id=0x7fffe9010808

	redo: for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		if s.sh_type != 4 {
			continue
		}
		if s.link != s1.symtab_section {
			continue
		}
		for rel = unsafe { &Elf64_Rela(s.data) }; unsafe {
			voidptr(rel) < &Elf64_Rela((s.data + s.data_offset))
		}; unsafe { rel++ } {
			type_ = ((rel.r_info) & 4294967295)
			gotplt_entry = gotplt_entry_type(type_)
			if gotplt_entry == -1 {
				_tcc_error_noabort('Unknown relocation type for got: ${type_}')
				continue
			}
			sym_index = ((rel.r_info) >> 32)
			sym = &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
			if gotplt_entry == Gotplt_entry.no_gotplt_entry {
				continue
			}
			if gotplt_entry == Gotplt_entry.auto_gotplt_entry {
				if sym.st_shndx == 0 {
					esym := &Elf64_Sym(0)
					dynindex := 0
					if !1 && s1.output_type & 4 {
						continue
					}
					if s1.dynsym {
						dynindex = get_sym_attr(s1, sym_index, 0).dyn_index
						esym = unsafe { &Elf64_Sym(s1.dynsym.data) + dynindex }
						if dynindex && (((esym.st_info) & 15) == 2
							|| (((esym.st_info) & 15) == 0 && ((sym.st_info) & 15) == 2)) {
							unsafe {
								goto jmp_slot
							} // id: 0x7fffe900eaf0
						}
					}
				} else if sym.st_shndx == 65521 {
					if sym.st_value == 0 {
						continue
					}
					if 8 != 8 {
						continue
					}
				} else { // 3
					continue
				}
			}
			if (type_ == 4 || type_ == 2) && sym.st_shndx != 0 && (((sym.st_other) & 3) != 0
				|| ((u8((sym.st_info))) >> 4) == 0 || s1.output_type & 2) {
				if pass != 0 {
					continue
				}
				rel.r_info = (((Elf64_Xword(u64(sym_index))) << 32) + (2))
				continue
			}
			reloc_type = code_reloc(type_)
			if reloc_type == -1 {
				_tcc_error_noabort('Unknown relocation type: ${type_}')
				continue
			}
			if reloc_type != 0 {
				// RRRREG jmp_slot id=0x7fffe900eaf0
				jmp_slot:
				if pass != 0 {
					continue
				}
				reloc_type = 7
			} else {
				if pass != 1 {
					continue
				}
				reloc_type = 6
			}
			if !s1.got {
				got_sym = build_got(s1)
			}
			if gotplt_entry == Gotplt_entry.build_got_only {
				continue
			}
			attr = put_got_entry(s1, reloc_type, sym_index)
			if reloc_type == 7 {
				rel.r_info = (((Elf64_Xword(u64(attr.plt_sym))) << 32) + type_)
			}
		}
	}
	if pass++$ < 2 {
		unsafe {
			goto redo
		} // id: 0x7fffe9010808
	}
	if s1.plt && s1.plt.reloc {
		s1.plt.reloc.sh_info = s1.got.sh_num
	}
	if got_sym {
		(&Elf64_Sym(s1.symtab_section.data))[got_sym].st_size = s1.got.data_offset
	}
}

fn set_global_sym(s1 &TCCState, name &i8, sec &Section, offs Elf64_Addr) int {
	shn := if sec {
		sec.sh_num
	} else {
		if offs || !name { 65521 } else { 0 }
	}
	if sec && offs == -1 {
		offs = sec.data_offset
	}
	return set_elf_sym(s1.symtab_section, offs, 0, (((if name { 1 } else { 0 }) << 4) + ((0) & 15)),
		0, shn, name)
}

fn add_init_array_defines(s1 &TCCState, section_name &i8) {
	s := &Section(0)
	end_offset := Elf64_Addr(0)
	buf := [1024]i8{}
	s = have_section(s1, section_name)
	if unsafe { s == 0 } || !(s.sh_flags & (1 << 1)) {
		end_offset = 0
		s = s1.data_section
	} else {
		end_offset = s.data_offset
	}
	unsafe {
		C.snprintf(buf, sizeof(buf), c'__%s_start', section_name + 1)
		set_global_sym(s1, buf, s, 0)
		C.snprintf(buf, sizeof(buf), c'__%s_end', section_name + 1)
		set_global_sym(s1, buf, s, end_offset)
	}
}

fn add_array(s1 &TCCState, sec &i8, c int) {
	s := &Section(0)
	s = find_section(s1, sec)
	s.sh_flags = shf_RELRO
	s.sh_type = if sec[1] == 'i' { 14 } else { 15 }
	put_elf_reloc(s1.symtab, s, s.data_offset, 1, c)
	section_ptr_add(s, 8)
}

fn tcc_add_bcheck(s1 &TCCState) {
	if 0 == s1.do_bounds_check {
		return
	}
	section_ptr_add(s1.bounds_section, sizeof(Elf64_Addr))
}

fn set_local_sym(s1 &TCCState, name &i8, s &Section, offset int) {
	c := find_elf_sym(s1.symtab, name)
	if c {
		esym := unsafe { &Elf64_Sym(s1.symtab.data) + c }
		esym.st_info = (((0) << 4) + ((0) & 15))
		esym.st_value = offset
		esym.st_shndx = s.sh_num
	}
}

fn tcc_compile_string_no_debug(s &TCCState, str &i8) {
	save_do_debug := s.do_debug
	save_test_coverage := s.test_coverage
	s.do_debug = 0
	s.test_coverage = 0
	tcc_compile_string(s, str)
	s.do_debug = save_do_debug
	s.test_coverage = save_test_coverage
}

fn put_ptr(s1 &TCCState, s &Section, offs int) {
	c := 0
	c = set_global_sym(s1, (unsafe { nil }), s, offs)
	s = s1.data_section
	put_elf_reloc(s1.symtab, s, s.data_offset, 1, c)
	section_ptr_add(s, 8)
}

fn tcc_add_btstub(s1 &TCCState) {
	s := &Section(0)
	n := 0
	o := 0

	cstr := CString{}
	s = s1.data_section
	section_ptr_add(s, -s.data_offset & (8 - 1))
	o = s.data_offset
	if s1.dwarf {
		put_ptr(s1, s1.dwarf_line_section, 0)
		put_ptr(s1, s1.dwarf_line_section, -1)
		if s1.dwarf >= 5 {
			put_ptr(s1, s1.dwarf_line_str_section, 0)
		} else { // 3
			put_ptr(s1, s1.dwarf_str_section, 0)
		}
	} else {
		put_ptr(s1, s1.stab_section, 0)
		put_ptr(s1, s1.stab_section, -1)
		put_ptr(s1, s1.stab_section.link, 0)
	}
	*&Elf64_Addr(section_ptr_add(s, 8)) = s1.dwarf
	section_ptr_add(s, 3 * 8)
	put_ptr(s1, (unsafe { nil }), 0)
	n = 2 * 8
	if s1.do_bounds_check {
		put_ptr(s1, s1.bounds_section, 0)
		n -= 8
	}
	section_ptr_add(s, n)
	cstr_new(&cstr)
	cstr_printf(&cstr, c'extern void __bt_init(),__bt_exit(),__bt_init_dll();static void *__rt_info[];__attribute__((constructor)) static void __bt_init_rt(){')
	cstr_printf(&cstr, c'__bt_init(__rt_info,%d);}', if s1.output_type == 4 {
		0
	} else {
		s1.rt_num_callers + 1
	})
	cstr_printf(&cstr, c'__attribute__((destructor)) static void __bt_exit_rt(){__bt_exit(__rt_info);}')
	tcc_compile_string_no_debug(s1, cstr.data)
	cstr_free(&cstr)
	set_local_sym(s1, &c'___rt_info'[!s1.leading_underscore], s, o)
}

fn tcc_tcov_add_file(s1 &TCCState, filename &i8) {
	cstr := CString{}
	ptr := &voidptr(0)
	wd := [1024]i8{}
	if s1.tcov_section == (unsafe { nil }) {
		return
	}
	section_ptr_add(s1.tcov_section, 1)
	write32le(s1.tcov_section.data, s1.tcov_section.data_offset)
	cstr_new(&cstr)
	if filename[0] == '/' {
		cstr_printf(&cstr, c'%s.tcov', filename)
	} else {
		C.getcwd(wd, sizeof(wd))
		cstr_printf(&cstr, c'%s/%s.tcov', wd, filename)
	}
	ptr = section_ptr_add(s1.tcov_section, cstr.size + 1)
	unsafe {
		C.strcpy(&i8(ptr), cstr.data)
		C.unlink(&i8(ptr))
	}
	cstr_free(&cstr)
	cstr_new(&cstr)
	cstr_printf(&cstr, c'extern char *__tcov_data[];extern void __store_test_coverage ();__attribute__((destructor)) static void __tcov_exit() {__store_test_coverage(__tcov_data);}')
	tcc_compile_string_no_debug(s1, cstr.data)
	cstr_free(&cstr)
	set_local_sym(s1, &c'___tcov_data'[!s1.leading_underscore], s1.tcov_section, 0)
}

fn tccelf_add_crtbegin(s1 &TCCState) {
	if s1.output_type != 4 {
		tcc_add_crt(s1, c'crt1.o')
	}
	tcc_add_crt(s1, c'crti.o')
}

fn tccelf_add_crtend(s1 &TCCState) {
	tcc_add_crt(s1, c'crtn.o')
}

fn tcc_add_runtime(s1 &TCCState) {
	s1.filetype = 0
	tcc_add_bcheck(s1)
	tcc_add_pragma_libs(s1)
	if !s1.nostdlib {
		lpthread := s1.option_pthread
		if s1.do_bounds_check && s1.output_type != 4 {
			tcc_add_support(s1, c'bcheck.o')
			tcc_add_library_err(s1, c'dl')
			lpthread = 1
		}
		if s1.do_backtrace {
			if s1.output_type & 2 {
				tcc_add_support(s1, c'bt-exe.o')
			}
			if s1.output_type != 4 {
				tcc_add_support(s1, c'bt-log.o')
			}
			if s1.output_type != 1 {
				tcc_add_btstub(s1)
			}
		}
		if lpthread {
			tcc_add_library_err(s1, c'pthread')
		}
		tcc_add_library_err(s1, c'c')
		if c'libtcc1.a'[0] {
			tcc_add_support(s1, c'libtcc1.a')
		}
		if s1.output_type != 1 {
			tccelf_add_crtend(s1)
		}
	}
}

fn tcc_add_linker_symbols(s1 &TCCState) {
	buf := [1024]i8{}
	i := 0
	s := &Section(0)
	set_global_sym(s1, c'_etext', s1.text_section, -1)
	set_global_sym(s1, c'_edata', s1.data_section, -1)
	set_global_sym(s1, c'_end', s1.bss_section, -1)
	add_init_array_defines(s1, c'.preinit_array')
	add_init_array_defines(s1, c'.init_array')
	add_init_array_defines(s1, c'.fini_array')
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		if s.sh_flags & (1 << 1) && (s.sh_type == 1 || s.sh_type == 3) {
			p := &i8(0)
			p = s.name
			for ; true; {
				c := *p
				if !c {
					break
				}
				if !isid(c) && !isnum(c) {
					unsafe {
						goto next_sec
					} // id: 0x7fffe901ce88
				}
				unsafe { p++ }
			}
			unsafe { C.snprintf(buf, sizeof(buf), c'__start_%s', s.name) }
			set_global_sym(s1, buf, s, 0)
			unsafe { C.snprintf(buf, sizeof(buf), c'__stop_%s', s.name) }
			set_global_sym(s1, buf, s, -1)
		}
		// RRRREG next_sec id=0x7fffe901ce88
		next_sec:
		0
	}
}

fn resolve_common_syms(s1 &TCCState) {
	sym := &Elf64_Sym(0)
	for sym = unsafe { &Elf64_Sym(s1.symtab_section.data) + 1 }; unsafe {
		voidptr(sym) < &Elf64_Sym((s1.symtab_section.data + s1.symtab_section.data_offset))
	}; unsafe { sym++ } {
		if sym.st_shndx == 65522 {
			sym.st_value = section_add(s1.bss_section, sym.st_size, sym.st_value)
			sym.st_shndx = s1.bss_section.sh_num
		}
	}
	tcc_add_linker_symbols(s1)
}

fn fill_got_entry(s1 &TCCState, rel &Elf64_Rela) {
	sym_index := ((rel.r_info) >> 32)
	sym := &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
	attr := get_sym_attr(s1, sym_index, 0)
	offset := attr.got_offset
	if 0 == offset {
		return
	}
	section_reserve(s1.got, offset + 8)
	unsafe {
		write64le(s1.got.data + offset, sym.st_value)
	}
}

fn fill_got(s1 &TCCState) {
	s := &Section(0)
	rel := &Elf64_Rela(0)
	i := 0
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		if s.sh_type != 4 {
			continue
		}
		if s.link != s1.symtab_section {
			continue
		}
		for rel = unsafe { &Elf64_Rela(s.data) }; unsafe {
			voidptr(rel) < &Elf64_Rela((s.data + s.data_offset))
		}; unsafe { rel++ } {
			match ((rel.r_info) & 4294967295) {
				3, 9, 41, 42, 4 {
					fill_got_entry(s1, rel)
				}
				else {}
			}
		}
	}
}

fn fill_local_got_entries(s1 &TCCState) {
	rel := &Elf64_Rela(0)
	if !s1.got.reloc {
		return
	}
	for rel = unsafe { &Elf64_Rela(s1.got.reloc.data) }; unsafe {
		voidptr(rel) < &Elf64_Rela((s1.got.reloc.data + s1.got.reloc.data_offset))
	}; unsafe { rel++ } {
		if ((rel.r_info) & 4294967295) == 8 {
			sym_index := ((rel.r_info) >> 32)
			sym := &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
			attr := get_sym_attr(s1, sym_index, 0)
			offset := attr.got_offset
			if offset != rel.r_offset - s1.got.sh_addr {
				_tcc_error_noabort('fill_local_got_entries: huh?')
			}
			rel.r_info = (((Elf64_Xword((0))) << 32) + (8))
			rel.r_addend = sym.st_value
		}
	}
}

fn bind_exe_dynsyms(s1 &TCCState, is_pie int) {
	name := &i8(0)
	sym_index := 0
	index := 0

	sym := &Elf64_Sym(0)
	esym := &Elf64_Sym(0)

	type_ := 0
	for sym = unsafe { &Elf64_Sym(s1.symtab_section.data) + 1 }; unsafe {
		voidptr(sym) < &Elf64_Sym((s1.symtab_section.data + s1.symtab_section.data_offset))
	}; unsafe { sym++ } {
		if sym.st_shndx == 0 {
			name = unsafe { &i8(s1.symtab_section.link.data) + sym.st_name }
			sym_index = find_elf_sym(s1.dynsymtab_section, name)
			if sym_index {
				if is_pie {
					continue
				}
				esym = &(&Elf64_Sym(s1.dynsymtab_section.data))[sym_index]
				type_ = ((esym.st_info) & 15)
				if type_ == 2 || type_ == 10 {
					dynindex := put_elf_sym(s1.dynsym, 0, esym.st_size, (((1) << 4) + ((2) & 15)),
						0, 0, name)
					index = unsafe { sym - voidptr(&Elf64_Sym(s1.symtab_section.data)) }
					get_sym_attr(s1, index, 1).dyn_index = dynindex
				} else if type_ == 1 {
					offset := u32(0)
					dynsym := &Elf64_Sym(0)
					offset = s1.bss_section.data_offset
					offset = (offset + 16 - 1) & -16
					set_elf_sym(s1.symtab, offset, esym.st_size, esym.st_info, 0, s1.bss_section.sh_num,
						name)
					index = put_elf_sym(s1.dynsym, offset, esym.st_size, esym.st_info,
						0, s1.bss_section.sh_num, name)
					if ((u8((esym.st_info))) >> 4) == 2 {
						for dynsym = unsafe { &Elf64_Sym(s1.dynsymtab_section.data) + 1 }; unsafe {
							voidptr(dynsym) < &Elf64_Sym((s1.dynsymtab_section.data +
								s1.dynsymtab_section.data_offset))
						}; unsafe { dynsym++ } {
							if dynsym.st_value == esym.st_value
								&& ((u8((dynsym.st_info))) >> 4) == 1 {
								dynname := &i8(s1.dynsymtab_section.link.data) + dynsym.st_name
								put_elf_sym(s1.dynsym, offset, dynsym.st_size, dynsym.st_info,
									0, s1.bss_section.sh_num, dynname)
								break
							}
						}
					}
					put_elf_reloc(s1.dynsym, s1.bss_section, offset, 5, index)
					offset += esym.st_size
					s1.bss_section.data_offset = offset
				}
			} else {
				if ((u8((sym.st_info))) >> 4) == 2 || !C.strcmp(name, c'_fp_hw') {
				} else {
					_tcc_error_noabort("undefined symbol '${name}'")
				}
			}
		}
	}
}

fn bind_libs_dynsyms(s1 &TCCState) {
	name := &i8(0)
	dynsym_index := 0
	sym := &Elf64_Sym(0)
	esym := &Elf64_Sym(0)

	for sym = unsafe { &Elf64_Sym(s1.symtab_section.data) + 1 }; unsafe {
		voidptr(sym) < &Elf64_Sym((s1.symtab_section.data + s1.symtab_section.data_offset))
	}; unsafe { sym++ } {
		name = &i8(s1.symtab_section.link.data) + sym.st_name
		dynsym_index = find_elf_sym(s1.dynsymtab_section, name)
		if sym.st_shndx != 0 {
			if ((u8((sym.st_info))) >> 4) != 0 && (dynsym_index || s1.rdynamic) {
				set_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info, 0, sym.st_shndx,
					name)
			}
		} else if dynsym_index {
			esym = &Elf64_Sym(s1.dynsymtab_section.data) + dynsym_index
			if esym.st_shndx == 0 {
				if ((u8((esym.st_info))) >> 4) != 2 {
					_tcc_warning(c"undefined dynamic symbol '%s'", name)
				}
			}
		}
	}
}

fn export_global_syms(s1 &TCCState) {
	dynindex := 0
	index := 0

	name := &i8(0)
	sym := &Elf64_Sym(0)
	for sym = &Elf64_Sym(s1.symtab_section.data) + 1; sym < &Elf64_Sym((s1.symtab_section.data +
		s1.symtab_section.data_offset)); sym++ {
		if ((u8((sym.st_info))) >> 4) != 0 {
			name = &i8(s1.symtab_section.link.data) + sym.st_name
			dynindex = set_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info,
				0, sym.st_shndx, name)
			index = sym - &Elf64_Sym(s1.symtab_section.data)
			get_sym_attr(s1, index, 1).dyn_index = dynindex
		}
	}
}

fn set_sec_sizes(s1 &TCCState) int {
	i := 0
	s := &Section(0)
	textrel := 0
	file_type := s1.output_type
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		if s.sh_type == 4 && !(s.sh_flags & (1 << 1)) {
			if file_type & 4 && s1.sections[s.sh_info].sh_flags & (1 << 1) {
				count := prepare_dynamic_rel(s1, s)
				if count {
					s.sh_flags |= (1 << 1)
					s.sh_size = count * sizeof(Elf64_Rela)
					if !(s1.sections[s.sh_info].sh_flags & (1 << 0)) {
						textrel += count
					}
				}
			}
		} else if s.sh_flags & (1 << 1) || s1.do_debug {
			s.sh_size = s.data_offset
		}
	}
	return textrel
}

struct Dyn_inf {
	dynamic     &Section
	dynstr      &Section
	data_offset u64
	rel_addr    usize
	rel_size    usize
	phdr        &Elf64_Phdr
	phnum       int
	interp      &Section
	note        &Section
	gnu_hash    &Section
	_roinf      Section
	roinf       &Section
}

fn sort_sections(s1 &TCCState, sec_order &int, interp &Section) int {
	s := &Section(0)
	i := 0
	j := 0
	k := 0
	f := 0
	f0 := 0
	n := 0

	nb_sections := s1.nb_sections
	sec_cls := sec_order + nb_sections
	for i = 1; i < nb_sections; i++ {
		s = s1.sections[i]
		if s.sh_flags & (1 << 1) {
			j = 256
			if s.sh_flags & (1 << 0) {
				j = 512
			}
			if s.sh_flags & (1 << 10) {
				j += 512
			}
		} else if s.sh_name {
			j = 1792
		} else {
			j = 2304
		}
		if s.sh_type == 2 || s.sh_type == 11 {
			k = 16
		} else if s.sh_type == 3 && C.strcmp(s.name, c'.stabstr') {
			k = 17
			if i == nb_sections - 1 {
				k = 255
			}
		} else if s.sh_type == 5 || s.sh_type == 1879048182 {
			k = 18
		} else if s.sh_type == 4 {
			k = 32
			if s1.plt && s == s1.plt.reloc {
				k = 33
			}
		} else if s.sh_type == 16 {
			k = 65
		} else if s.sh_type == 14 {
			k = 66
		} else if s.sh_type == 15 {
			k = 67
		} else if s == s1.bounds_section || s == s1.lbounds_section {
			k = 68
		} else if s == s1.rodata_section || 0 == C.strcmp(s.name, c'.data.rel.ro') {
			k = 69
		} else if s.sh_type == 6 {
			k = 70
		} else if s == s1.got {
			k = 71
		} else {
			k = 80
			if s.sh_type == 7 {
				k = 96
			}
			if s.sh_flags & (1 << 2) {
				k = 112
			}
			if s.sh_type == 8 {
				k = 128
			}
			if s == interp {
				k = 0
			}
		}
		k += j
		for n = i; n > 1 && k < sec_cls[n - 1]; n-- {
			f = sec_cls[n - 1]
			sec_cls[n] = f
			sec_order[n] = sec_order[n - 1]
		}
		sec_cls[n] = k
		sec_order[n] = i
	}
	sec_order[0] = 0
	n = 0
	f0 = n
	for i = 1; i < nb_sections; i++ {
		s = s1.sections[sec_order[i]]
		k = sec_cls[i]
		f = 0
		if k < 1792 {
			f = s.sh_flags & ((1 << 1) | (1 << 0) | (1 << 2) | (1 << 10))
			if (k & 65520) == 576 {
				f |= 1 << 4
			}
			if f != f0 {
				f0 = f
				n++
				f |= 1 << 8
			}
		}
		sec_cls[i] = f
	}
	return n
}

fn fill_phdr(ph &Elf64_Phdr, type_ int, s &Section) &Elf64_Phdr {
	if s {
		ph.p_offset = s.sh_offset
		ph.p_vaddr = s.sh_addr
		ph.p_filesz = s.sh_size
		ph.p_align = s.sh_addralign
	}
	ph.p_type = type_
	ph.p_flags = (1 << 2)
	ph.p_paddr = ph.p_vaddr
	ph.p_memsz = ph.p_filesz
	return ph
}

fn layout_sections(s1 &TCCState, sec_order &int, d &Dyn_inf) int {
	s := &Section(0)
	addr := Elf64_Addr{}
	tmp := Elf64_Addr{}
	align := Elf64_Addr{}
	s_align := Elf64_Addr{}
	base := Elf64_Addr{}

	ph := (unsafe { nil })
	i := 0
	f := 0
	n := 0
	phnum := 0
	phfill := 0

	file_offset := 0
	phnum = sort_sections(s1, sec_order, d.interp)
	phfill = 0
	if d.interp {
		phfill = 2
	}
	phnum += phfill
	if d.note {
		phnum++$
	}
	if d.dynamic {
		phnum++$
	}
	if d.roinf {
		phnum++$
	}
	d.phnum = phnum
	d.phdr = tcc_mallocz(phnum * sizeof(Elf64_Phdr))
	file_offset = 0
	if s1.output_format == 0 {
		file_offset = sizeof(Elf64_Ehdr) + phnum * sizeof(Elf64_Phdr)
	}
	s_align = 2097152
	if s1.section_align {
		s_align = s1.section_align
	}
	addr = 4194304
	if s1.output_type & 4 {
		addr = 0
	}
	if s1.has_text_addr {
		addr = s1.text_addr
		if 0 {
			a_offset := 0
			p_offset := 0

			a_offset = int((addr & (s_align - 1)))
			p_offset = file_offset & (s_align - 1)
			if a_offset < p_offset {
				a_offset += s_align
			}
			file_offset += (a_offset - p_offset)
		}
	}
	base = addr
	addr = addr + (file_offset & (s_align - 1))
	n = 0
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[sec_order[i]]
		f = sec_order[i + s1.nb_sections]
		align = s.sh_addralign - 1
		if f == 0 {
			file_offset = (file_offset + align) & ~align
			s.sh_offset = file_offset
			if s.sh_type != 8 {
				file_offset += s.sh_size
			}
			continue
		}
		if f & 1 << 8 && n {
			if s1.output_format == 0 {
				if (addr & (s_align - 1)) != 0 {
					addr += s_align
				}
			} else {
				align = s_align - 1
			}
		}
		tmp = addr
		addr = (addr + align) & ~align
		file_offset += int((addr - tmp))
		s.sh_offset = file_offset
		s.sh_addr = addr
		if f & 1 << 8 {
			ph = &d.phdr[phfill + n]
			ph.p_type = 1
			ph.p_align = s_align
			ph.p_flags = (1 << 2)
			if f & (1 << 0) {
				ph.p_flags |= (1 << 1)
			}
			if f & (1 << 2) {
				ph.p_flags |= (1 << 0)
			}
			if f & (1 << 10) {
				ph.p_type = 7
				ph.p_align = align + 1
			}
			ph.p_offset = file_offset
			ph.p_vaddr = addr
			if n == 0 {
				ph.p_offset = 0
				ph.p_vaddr = base
			}
			ph.p_paddr = ph.p_vaddr
			n++$
		}
		if f & 1 << 4 {
			roinf := &d._roinf
			if roinf.sh_size == 0 {
				roinf.sh_offset = s.sh_offset
				roinf.sh_addr = s.sh_addr
				roinf.sh_addralign = 1
			}
			roinf.sh_size = (addr - roinf.sh_addr) + s.sh_size
		}
		addr += s.sh_size
		if s.sh_type != 8 {
			file_offset += s.sh_size
		}
		ph.p_filesz = file_offset - ph.p_offset
		ph.p_memsz = addr - ph.p_vaddr
	}
	if d.note {
		fill_phdr(ph++$, 4, d.note)
	}
	if d.dynamic {
		fill_phdr(ph++$, 2, d.dynamic).p_flags |= (1 << 1)
	}
	if d.roinf {
		fill_phdr(ph++$, 1685382482, d.roinf).p_flags |= (1 << 1)
	}
	if d.interp {
		fill_phdr(&d.phdr[1], 3, d.interp)
	}
	if phfill {
		ph = &d.phdr[0]
		ph.p_offset = sizeof(Elf64_Ehdr)
		ph.p_vaddr = base + ph.p_offset
		ph.p_filesz = phnum * sizeof(Elf64_Phdr)
		ph.p_align = 4
		fill_phdr(ph, 6, (unsafe { nil }))
	}
	return file_offset
}

fn put_dt(dynamic &Section, dt int, val Elf64_Addr) {
	dyn := &Elf64_Dyn(0)
	dyn = section_ptr_add(dynamic, sizeof(Elf64_Dyn))
	dyn.d_tag = dt
	dyn.d_un.d_val = val
}

fn fill_dynamic(s1 &TCCState, dyninf &Dyn_inf) {
	dynamic := dyninf.dynamic
	s := &Section(0)
	put_dt(dynamic, 4, s1.dynsym.hash.sh_addr)
	put_dt(dynamic, 1879047925, dyninf.gnu_hash.sh_addr)
	put_dt(dynamic, 5, dyninf.dynstr.sh_addr)
	put_dt(dynamic, 6, s1.dynsym.sh_addr)
	put_dt(dynamic, 10, dyninf.dynstr.data_offset)
	put_dt(dynamic, 11, sizeof(Elf64_Sym))
	put_dt(dynamic, 7, dyninf.rel_addr)
	put_dt(dynamic, 8, dyninf.rel_size)
	put_dt(dynamic, 9, sizeof(Elf64_Rela))
	if s1.plt && s1.plt.reloc {
		put_dt(dynamic, 3, s1.got.sh_addr)
		put_dt(dynamic, 2, s1.plt.reloc.data_offset)
		put_dt(dynamic, 23, s1.plt.reloc.sh_addr)
		put_dt(dynamic, 20, 7)
	}
	put_dt(dynamic, 1879048185, 0)
	if s1.versym_section && s1.verneed_section {
		put_dt(dynamic, 1879048176, s1.versym_section.sh_addr)
		put_dt(dynamic, 1879048190, s1.verneed_section.sh_addr)
		put_dt(dynamic, 1879048191, s1.dt_verneednum)
	}
	s = have_section(s1, c'.preinit_array')
	if s && s.data_offset {
		put_dt(dynamic, 32, s.sh_addr)
		put_dt(dynamic, 33, s.data_offset)
	}
	s = have_section(s1, c'.init_array')
	if s && s.data_offset {
		put_dt(dynamic, 25, s.sh_addr)
		put_dt(dynamic, 27, s.data_offset)
	}
	s = have_section(s1, c'.fini_array')
	if s && s.data_offset {
		put_dt(dynamic, 26, s.sh_addr)
		put_dt(dynamic, 28, s.data_offset)
	}
	s = have_section(s1, c'.init')
	if s && s.data_offset {
		put_dt(dynamic, 12, s.sh_addr)
	}
	s = have_section(s1, c'.fini')
	if s && s.data_offset {
		put_dt(dynamic, 13, s.sh_addr)
	}
	if s1.do_debug {
		put_dt(dynamic, 21, 0)
	}
	put_dt(dynamic, 0, 0)
}

fn update_reloc_sections(s1 &TCCState, dyninf &Dyn_inf) {
	i := 0
	file_offset := 0
	s := &Section(0)
	relocplt := if s1.plt { s1.plt.reloc } else { (unsafe { nil }) }
	dyninf.rel_addr = 0
	dyninf.rel_size = dyninf.rel_addr
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		if s.sh_type == 4 && s != relocplt {
			if dyninf.rel_size == 0 {
				dyninf.rel_addr = s.sh_addr
				file_offset = s.sh_offset
			} else {
				s.sh_addr = dyninf.rel_addr + dyninf.rel_size
				s.sh_offset = file_offset + dyninf.rel_size
			}
			dyninf.rel_size += s.sh_size
		}
	}
}

fn tcc_output_elf(s1 &TCCState, f &C.FILE, phnum int, phdr &Elf64_Phdr, file_offset int, sec_order &int) int {
	i := 0
	shnum := 0
	offset := 0
	size := 0
	file_type := 0

	s := &Section(0)
	ehdr := Elf64_Ehdr{}
	shdr := Elf64_Shdr{}
	sh := &Elf64_Shdr(0)

	file_type = s1.output_type
	shnum = s1.nb_sections
	C.memset(&ehdr, 0, sizeof(ehdr))
	if phnum > 0 {
		ehdr.e_phentsize = sizeof(Elf64_Phdr)
		ehdr.e_phnum = phnum
		ehdr.e_phoff = sizeof(Elf64_Ehdr)
		shnum = tidy_section_headers(s1, sec_order)
	}
	file_offset = (file_offset + 3) & -4
	ehdr.e_ident[0] = 127
	ehdr.e_ident[1] = `E`
	ehdr.e_ident[2] = `L`
	ehdr.e_ident[3] = `F`
	ehdr.e_ident[4] = 2
	ehdr.e_ident[5] = 1
	ehdr.e_ident[6] = 1
	if file_type == 3 {
		ehdr.e_type = 1
	} else {
		if file_type & 4 {
			ehdr.e_type = 3
		} else { // 3
			ehdr.e_type = 2
		}
		if s1.elf_entryname {
			ehdr.e_entry = get_sym_addr(s1, s1.elf_entryname, 1, 0)
		} else { // 3
			ehdr.e_entry = get_sym_addr(s1, c'_start', !!(file_type & 2), 0)
		}
		if ehdr.e_entry == Elf64_Addr(-1) {
			ehdr.e_entry = s1.text_section.sh_addr
		}
		if s1.nb_errors {
			return -1
		}
	}
	ehdr.e_machine = 62
	ehdr.e_version = 1
	ehdr.e_shoff = file_offset
	ehdr.e_ehsize = sizeof(Elf64_Ehdr)
	ehdr.e_shentsize = sizeof(Elf64_Shdr)
	ehdr.e_shnum = shnum
	ehdr.e_shstrndx = shnum - 1
	C.fwrite(&ehdr, 1, sizeof(Elf64_Ehdr), f)
	if phdr {
		C.fwrite(phdr, 1, phnum * sizeof(Elf64_Phdr), f)
	}
	offset = sizeof(Elf64_Ehdr) + phnum * sizeof(Elf64_Phdr)
	sort_syms(s1, s1.symtab_section)
	for i = 1; i < shnum; i++ {
		s = s1.sections[if sec_order { sec_order[i] } else { i }]
		if s.sh_type != 8 {
			for offset < s.sh_offset {
				fputc(0, f)
				offset++
			}
			size = s.sh_size
			if size {
				C.fwrite(s.data, 1, size, f)
			}
			offset += size
		}
	}
	for offset < ehdr.e_shoff {
		fputc(0, f)
		offset++
	}
	for i = 0; i < shnum; i++ {
		sh = &shdr
		C.memset(sh, 0, sizeof(Elf64_Shdr))
		s = s1.sections[i]
		if s {
			sh.sh_name = s.sh_name
			sh.sh_type = s.sh_type
			sh.sh_flags = s.sh_flags
			sh.sh_entsize = s.sh_entsize
			sh.sh_info = s.sh_info
			if s.link {
				sh.sh_link = s.link.sh_num
			}
			sh.sh_addralign = s.sh_addralign
			sh.sh_addr = s.sh_addr
			sh.sh_offset = s.sh_offset
			sh.sh_size = s.sh_size
		}
		C.fwrite(sh, 1, sizeof(Elf64_Shdr), f)
	}
	return 0
}

fn tcc_output_binary(s1 &TCCState, f &C.FILE, sec_order &int) int {
	s := &Section(0)
	i := 0
	offset := 0
	size := 0

	offset = 0
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[sec_order[i]]
		if s.sh_type != 8 && s.sh_flags & (1 << 1) {
			for offset < s.sh_offset {
				fputc(0, f)
				offset++
			}
			size = s.sh_size
			C.fwrite(s.data, 1, size, f)
			offset += size
		}
	}
	return 0
}

fn tcc_write_elf_file(s1 &TCCState, filename &i8, phnum int, phdr &Elf64_Phdr, file_offset int, sec_order &int) int {
	fd := 0
	mode := 0
	file_type := 0
	ret := 0

	f := &C.FILE(0)
	file_type = s1.output_type
	if file_type == 3 {
		mode = 438
	} else { // 3
		mode = 511
	}
	C.unlink(filename)
	fd = C.open(filename, 1 | 64 | 512 | 0, mode)
	if fd < 0 {
		f = C.fdopen(fd, c'wb')
		if f == unsafe { nil } {
			return _tcc_error_noabort("could not write '%s: %s'", filename, strerror((*__errno_location())))
		}
	}
	if s1.verbose {
		C.printf(c'<- %s\n', filename)
	}
	if s1.output_format == 0 {
		ret = tcc_output_elf(s1, f, phnum, phdr, file_offset, sec_order)
	} else { // 3
		ret = tcc_output_binary(s1, f, sec_order)
	}
	C.fclose(f)
	return ret
}

fn tidy_section_headers(s1 &TCCState, sec_order &int) int {
	i := 0
	nnew := 0
	l := 0
	backmap := &int(0)

	snew := &&Section(0)
	s := &Section(0)

	sym := &Elf64_Sym(0)
	snew = tcc_malloc(s1.nb_sections * sizeof(snew[0]))
	backmap = tcc_malloc(s1.nb_sections * sizeof(backmap[0]))
	i = 0
	nnew = 0
	for l = s1.nb_sections; i < s1.nb_sections; i++ {
		s = s1.sections[sec_order[i]]
		if !i || s.sh_name {
			backmap[sec_order[i]] = nnew
			snew[nnew] = s
			nnew++$
		} else {
			backmap[sec_order[i]] = 0
			snew[l--$] = s
		}
	}
	for i = 0; i < nnew; i++ {
		s = snew[i]
		if s {
			s.sh_num = i
			if s.sh_type == 4 {
				s.sh_info = backmap[s.sh_info]
			}
		}
	}
	for sym = unsafe { &Elf64_Sym(s1.symtab_section.data) + 1 }; unsafe {
		sym < &Elf64_Sym((s1.symtab_section.data + s1.symtab_section.data_offset))
	}; unsafe { sym++ } {
		if sym.st_shndx != 0 && sym.st_shndx < 65280 {
			sym.st_shndx = backmap[sym.st_shndx]
		}
	}
	if !s1.static_link {
		for sym = unsafe { &Elf64_Sym(s1.dynsym.data) + 1 }; unsafe {
			sym < &Elf64_Sym((s1.dynsym.data + s1.dynsym.data_offset))
		}; unsafe { sym++ } {
			if sym.st_shndx != 0 && sym.st_shndx < 65280 {
				sym.st_shndx = backmap[sym.st_shndx]
			}
		}
	}
	for i = 0; i < s1.nb_sections; i++ {
		sec_order[i] = i
	}
	tcc_free(s1.sections)
	s1.sections = snew
	tcc_free(backmap)
	return nnew
}

fn elf_output_file(s1 &TCCState, filename &i8) int {
	i := 0
	ret := 0
	file_type := 0
	file_offset := 0
	sec_order := &int(0)

	dyninf := Dyn_inf{
		dynamic: 0
	}

	interp := &Section(0)
	dynstr := &Section(0)
	dynamic := &Section(0)

	textrel := 0
	got_sym := 0
	dt_flags_1 := 0

	file_type = s1.output_type
	s1.nb_errors = 0
	ret = -1
	interp = dynamic
	dynstr = unsafe { nil }
	sec_order = (unsafe { nil })
	dyninf.roinf = &dyninf._roinf
	tcc_add_runtime(s1)
	resolve_common_syms(s1)
	if !s1.static_link {
		if file_type & 2 {
			ptr := &i8(0)
			elfint := C.getenv(c'LD_SO')
			if elfint == (unsafe { nil }) {
				elfint = c'/lib64/ld-linux-x86-64.so.2'
			}
			interp = new_section(s1, c'.interp', 1, (1 << 1))
			interp.sh_addralign = 1
			ptr = section_ptr_add(interp, 1 + C.strlen(elfint))
			C.strcpy(ptr, elfint)
			dyninf.interp = interp
		}
		s1.dynsym = new_symtab(s1, c'.dynsym', 11, (1 << 1), c'.dynstr', c'.hash', (1 << 1))
		s1.dynsym.sh_info = 1
		dynstr = s1.dynsym.link
		dynamic = new_section(s1, c'.dynamic', 6, (1 << 1) | (1 << 0))
		dynamic.link = dynstr
		dynamic.sh_entsize = sizeof(Elf64_Dyn)
		got_sym = build_got(s1)
		if file_type & 2 {
			bind_exe_dynsyms(s1, file_type & 4)
			if s1.nb_errors {
				goto the_end // id: 0x7fffe904af18
			}
		}
		build_got_entries(s1, got_sym)
		if file_type & 2 {
			bind_libs_dynsyms(s1)
		} else {
			export_global_syms(s1)
		}
		dyninf.gnu_hash = create_gnu_hash(s1)
	} else {
		build_got_entries(s1, 0)
	}
	version_add(s1)
	textrel = set_sec_sizes(s1)
	alloc_sec_names(s1, 0)
	if !s1.static_link {
		for i = 0; i < s1.nb_loaded_dlls; i++ {
			dllref := s1.loaded_dlls[i]
			if dllref.level == 0 {
				put_dt(dynamic, 1, put_elf_str(dynstr, dllref.name))
			}
		}
		if s1.rpath {
			put_dt(dynamic, if s1.enable_new_dtags { 29 } else { 15 }, put_elf_str(dynstr,
				s1.rpath))
		}
		dt_flags_1 = 1
		if file_type & 4 {
			if s1.soname {
				put_dt(dynamic, 14, put_elf_str(dynstr, s1.soname))
			}
			if textrel {
				put_dt(dynamic, 22, 0)
			}
			if file_type & 2 {
				dt_flags_1 = 1 | 134217728
			}
		}
		put_dt(dynamic, 30, 8)
		put_dt(dynamic, 1879048187, dt_flags_1)
		if s1.symbolic {
			put_dt(dynamic, 16, 0)
		}
		dyninf.dynamic = dynamic
		dyninf.dynstr = dynstr
		dyninf.data_offset = dynamic.data_offset
		fill_dynamic(s1, &dyninf)
		dynamic.sh_size = dynamic.data_offset
		dynstr.sh_size = dynstr.data_offset
	}
	sec_order = tcc_malloc(sizeof(int) * 2 * s1.nb_sections)
	file_offset = layout_sections(s1, sec_order, &dyninf)
	if dynamic {
		write32le(s1.got.data, dynamic.sh_addr)
		if file_type == 2 || (1 && file_type & 4) {
			relocate_plt(s1)
		}
		relocate_syms(s1, s1.dynsym, 2)
	}
	relocate_syms(s1, s1.symtab, 0)
	if s1.nb_errors != 0 {
		goto the_end // id: 0x7fffe904af18
	}
	relocate_sections(s1)
	if dynamic {
		update_reloc_sections(s1, &dyninf)
		dynamic.data_offset = dyninf.data_offset
		fill_dynamic(s1, &dyninf)
	}
	if file_type == 2 && s1.static_link {
		fill_got(s1)
	} else if s1.got {
		fill_local_got_entries(s1)
	}
	if dyninf.gnu_hash {
		update_gnu_hash(s1, dyninf.gnu_hash)
	}
	ret = tcc_write_elf_file(s1, filename, dyninf.phnum, dyninf.phdr, file_offset, sec_order)
	// RRRREG the_end id=0x7fffe904af18
	the_end:
	tcc_free(sec_order)
	tcc_free(dyninf.phdr)
	return ret
}

fn alloc_sec_names(s1 &TCCState, is_obj int) {
	i := 0
	s := &Section(0)
	strsec := &Section(0)

	strsec = new_section(s1, c'.shstrtab', 3, 0)
	put_elf_str(strsec, c'')
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		if is_obj {
			s.sh_size = s.data_offset
		}
		if s == strsec || s.sh_size || s.sh_flags & (1 << 1) {
			s.sh_name = put_elf_str(strsec, s.name)
		}
	}
	strsec.sh_size = strsec.data_offset
}

fn elf_output_obj(s1 &TCCState, filename &i8) int {
	s := &Section(0)
	i := 0
	ret := 0
	file_offset := 0

	s1.nb_errors = 0
	alloc_sec_names(s1, 1)
	file_offset = sizeof(Elf64_Ehdr)
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		file_offset = (file_offset + 15) & -16
		s.sh_offset = file_offset
		if s.sh_type != 8 {
			file_offset += s.sh_size
		}
	}
	ret = tcc_write_elf_file(s1, filename, 0, (unsafe { nil }), file_offset, (unsafe { nil }))
	return ret
}

fn tcc_output_file(s &TCCState, filename &i8) int {
	if s.test_coverage {
		tcc_tcov_add_file(s, filename)
	}
	if s.output_type == 3 {
		return elf_output_obj(s, filename)
	}
	return elf_output_file(s, filename)
}

fn full_read(fd int, buf voidptr, count usize) isize {
	cbuf := buf
	rnum := 0
	for 1 {
		num := C.read(fd, cbuf, count - rnum)
		if num < 0 {
			return num
		}
		if num == 0 {
			return rnum
		}
		rnum += num
		cbuf += num
	}
	return 0
}

fn load_data(fd int, file_offset u32, size u32) voidptr {
	data := &voidptr(0)
	data = tcc_malloc(size)
	C.lseek(fd, file_offset, 0)
	full_read(fd, data, size)
	return data
}

struct SectionMergeInfo {
	s           &Section
	offset      u32
	new_section u8
	link_once   u8
}

fn tcc_object_type(fd int, h &Elf64_Ehdr) int {
	size := full_read(fd, h, sizeof(*h))
	if size == sizeof(*h) && 0 == C.memcmp(h, c'\177ELF', 4) {
		if h.e_type == 1 {
			return 1
		}
		if h.e_type == 3 {
			return 2
		}
	} else if size >= 8 {
		if 0 == C.memcmp(h, c'!<arch>\n', 8) {
			return 3
		}
	}
	return 0
}

fn tcc_load_object_file(s1 &TCCState, fd int, file_offset u32) int {
	ehdr := Elf64_Ehdr{}
	shdr := &Elf64_Shdr(0)
	sh := &Elf64_Shdr(0)

	size := u32(0)
	offset := u32(0)
	offseti := u32(0)

	i := 0
	j := 0
	nb_syms := 0
	sym_index := 0
	ret := 0
	seencompressed := 0

	strsec := &i8(0)
	strtab := &i8(0)

	stab_index := 0
	stabstr_index := 0

	old_to_new_syms := &int(0)
	sh_name := &i8(0)
	name := &i8(0)

	sm_table := &SectionMergeInfo(0)
	sm := &SectionMergeInfo(0)

	sym := &Elf64_Sym(0)
	symtab := &Elf64_Sym(0)

	rel := &Elf64_Rela(0)
	s := &Section(0)
	C.lseek(fd, file_offset, 0)
	if tcc_object_type(fd, &ehdr) != 1 {
		goto invalid // id: 0x7fffe9054a68
	}
	if ehdr.e_ident[5] != 1 || ehdr.e_machine != 62 {
		// RRRREG invalid id=0x7fffe9054a68
		invalid:
		return _tcc_error_noabort('invalid object file')
	}
	shdr = load_data(fd, file_offset + ehdr.e_shoff, sizeof(Elf64_Shdr) * ehdr.e_shnum)
	sm_table = tcc_mallocz(sizeof(SectionMergeInfo) * ehdr.e_shnum)
	sh = &shdr[ehdr.e_shstrndx]
	strsec = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
	old_to_new_syms = (unsafe { nil })
	symtab = (unsafe { nil })
	strtab = (unsafe { nil })
	nb_syms = 0
	seencompressed = 0
	stab_index = 0
	stabstr_index = stab_index
	ret = -1
	for i = 1; i < ehdr.e_shnum; i++ {
		sh = &shdr[i]
		if sh.sh_type == 2 {
			if symtab {
				_tcc_error_noabort('object must contain only one symtab')
				goto found // id: 0x7fffe9056020
			}
			nb_syms = sh.sh_size / sizeof(Elf64_Sym)
			symtab = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
			sm_table[i].s = s1.symtab_section
			sh = &shdr[sh.sh_link]
			strtab = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
		}
		if sh.sh_flags & (1 << 11) {
			seencompressed = 1
		}
	}
	for i = 1; i < ehdr.e_shnum; i++ {
		if i == ehdr.e_shstrndx {
			continue
		}
		sh = &shdr[i]
		if sh.sh_type == 4 {
			sh = &shdr[sh.sh_info]
		}
		if sh.sh_type != 1 && sh.sh_type != 7 && sh.sh_type != 8 && sh.sh_type != 16
			&& sh.sh_type != 14 && sh.sh_type != 15 && C.strcmp(strsec + sh.sh_name, c'.stabstr') {
			continue
		}
		if seencompressed && 0 == C.strncmp(strsec + sh.sh_name, c'.debug_', 7) {
			continue
		}
		sh = &shdr[i]
		sh_name = strsec + sh.sh_name
		if sh.sh_addralign < 1 {
			sh.sh_addralign = 1
		}
		for j = 1; j < s1.nb_sections; j++ {
			s = s1.sections[j]
			if !C.strcmp(s.name, sh_name) {
				if !C.strncmp(sh_name, c'.gnu.linkonce', sizeof(c'.gnu.linkonce') - 1) {
					sm_table[i].link_once = 1
					goto next // id: 0x7fffe90586f0
				}
				if s1.stab_section {
					if s == s1.stab_section {
						stab_index = i
					}
					if s == s1.stab_section.link {
						stabstr_index = i
					}
				}
				goto found // id: 0x7fffe9058b80
			}
		}
		s = new_section(s1, sh_name, sh.sh_type, sh.sh_flags & ~(1 << 9))
		s.sh_addralign = sh.sh_addralign
		s.sh_entsize = sh.sh_entsize
		sm_table[i].new_section = 1
		// RRRREG found id=0x7fffe9058b80
		found:
		if sh.sh_type != s.sh_type {
			_tcc_error_noabort('invalid section type')
			goto next // id: 0x7fffe9056020
		}
		s.data_offset += -s.data_offset & (sh.sh_addralign - 1)
		if sh.sh_addralign > s.sh_addralign {
			s.sh_addralign = sh.sh_addralign
		}
		sm_table[i].offset = s.data_offset
		sm_table[i].s = s
		size = sh.sh_size
		if sh.sh_type != 8 {
			ptr := &u8(0)
			C.lseek(fd, file_offset + sh.sh_offset, 0)
			ptr = section_ptr_add(s, size)
			full_read(fd, ptr, size)
		} else {
			s.data_offset += size
		}
		// RRRREG next id=0x7fffe90586f0
		next:
	}
	if stab_index && stabstr_index {
		a := &Stab_Sym(0)
		b := &Stab_Sym(0)

		o := u32(0)
		s = sm_table[stab_index].s
		a = &Stab_Sym((s.data + sm_table[stab_index].offset))
		b = &Stab_Sym((s.data + s.data_offset))
		o = sm_table[stabstr_index].offset
		for unsafe { voidptr(a) < b } {
			if a.n_strx {
				a.n_strx += o
			}
			unsafe { a++ }
		}
	}
	for i = 1; i < ehdr.e_shnum; i++ {
		s = sm_table[i].s
		if s == unsafe { nil } || !sm_table[i].new_section {
			continue
		}
		sh = &shdr[i]
		if sh.sh_link > 0 {
			s.link = sm_table[sh.sh_link].s
		}
		if sh.sh_type == 4 {
			s.sh_info = sm_table[sh.sh_info].s.sh_num
			s1.sections[s.sh_info].reloc = s
		}
	}
	old_to_new_syms = tcc_mallocz(nb_syms * sizeof(int))
	sym = unsafe { symtab + 1 }
	for i = 1; i < nb_syms; i++, unsafe { sym++ } {
		if sym.st_shndx != 0 && sym.st_shndx < 65280 {
			sm = &sm_table[sym.st_shndx]
			if sm.link_once {
				if ((u8((sym.st_info))) >> 4) != 0 {
					name = strtab + sym.st_name
					sym_index = find_elf_sym(s1.symtab_section, name)
					if sym_index {
						old_to_new_syms[i] = sym_index
					}
				}
				continue
			}
			if !sm.s {
				continue
			}
			sym.st_shndx = sm.s.sh_num
			sym.st_value += sm.offset
		}
		name = strtab + sym.st_name
		sym_index = set_elf_sym(s1.symtab_section, sym.st_value, sym.st_size, sym.st_info,
			sym.st_other, sym.st_shndx, name)
		old_to_new_syms[i] = sym_index
	}
	for i = 1; i < ehdr.e_shnum; i++ {
		s = sm_table[i].s
		if !s {
			continue
		}
		sh = &shdr[i]
		offset = sm_table[i].offset
		size = sh.sh_size
		match s.sh_type {
			4 { // case comp body kind=BinaryOperator is_enum=false
				offseti = sm_table[sh.sh_info].offset
				for rel = unsafe { &Elf64_Rela(s.data) + (offset / sizeof(*rel)) }; unsafe {
					voidptr(rel) < &Elf64_Rela(s.data) + ((offset + size) / sizeof(*rel))
				}; unsafe { rel++ } {
					type_ := 0
					sym_index = u32(0)
					type_ = ((rel.r_info) & 4294967295)
					sym_index = ((rel.r_info) >> 32)
					if sym_index >= nb_syms {
						goto invalid_reloc // id: 0x7fffe905e8c0
					}
					sym_index = old_to_new_syms[sym_index]
					if !sym_index && !sm_table[sh.sh_info].link_once {
						// RRRREG invalid_reloc id=0x7fffe905e8c0
						invalid_reloc:
						_tcc_error_noabort("Invalid relocation entry [${i}] '${strsec + sh.sh_name}' @ ${int(rel.r_offset)}")
						goto the_end // id: 0x7fffe9056020
					}
					rel.r_info = (((Elf64_Xword(u64(sym_index))) << 32) + type_)
					rel.r_offset += offseti
				}
			}
			else {}
		}
	}
	ret = 0
	// RRRREG the_end id=0x7fffe9056020
	the_end:
	tcc_free(symtab)
	tcc_free(strtab)
	tcc_free(old_to_new_syms)
	tcc_free(sm_table)
	tcc_free(strsec)
	tcc_free(shdr)
	return ret
}

struct ArchiveHeader {
	ar_name [16]i8
	ar_date [12]i8
	ar_uid  [6]i8
	ar_gid  [6]i8
	ar_mode [8]i8
	ar_size [10]i8
	ar_fmag [2]i8
}

fn get_be(b &u8, n int) i64 {
	ret := 0
	for n {
		ret = (ret << 8) | *b++
		n--
	}
	return ret
}

fn read_ar_header(fd int, offset int, hdr &ArchiveHeader) int {
	p := &i8(0)
	e := &i8(0)

	len := 0
	C.lseek(fd, offset, 0)
	len = full_read(fd, hdr, sizeof(ArchiveHeader))
	if len != sizeof(ArchiveHeader) {
		return if len { -1 } else { 0 }
	}
	p = hdr.ar_name
	for e = p + sizeof(hdr.ar_name); e > p && e[-1] == ' '; {
		e--$
	}
	*e = `\x00`
	hdr.ar_size[sizeof(hdr.ar_size) - 1] = 0
	return len
}

fn tcc_load_alacarte(s1 &TCCState, fd int, size int, entrysize int) int {
	i := 0
	bound := 0
	nsyms := 0
	sym_index := 0
	len := 0
	ret := -1

	off := i64(0)
	data := &u8(0)
	ar_names := &i8(0)
	p := &i8(0)

	ar_index := &u8(0)
	sym := &Elf64_Sym(0)
	hdr := ArchiveHeader{}
	data = tcc_malloc(size)
	if full_read(fd, data, size) != size {
		unsafe {
			goto the_end
		} // id: 0x7fffe90626c0
	}
	nsyms = get_be(data, entrysize)
	ar_index = data + entrysize
	ar_names = &i8(ar_index) + nsyms * entrysize
	for {
		bound = 0
		p = ar_names

		for i = 0; i < nsyms; i++ {
			s := s1.symtab_section
			sym_index = find_elf_sym(s, p)
			if !sym_index {
				p += C.strlen(p) + 1
				continue
			}
			sym = &(&Elf64_Sym(s.data))[sym_index]
			if sym.st_shndx != 0 {
				p += C.strlen(p) + 1
				continue
			}
			off = get_be(ar_index + i * entrysize, entrysize)
			len = read_ar_header(fd, off, &hdr)
			if len <= 0 || C.memcmp(hdr.ar_fmag, c'`\n', 2) {
				_tcc_error_noabort('invalid archive')
				unsafe {
					goto the_end
				} // id: 0x7fffe90626c0
			}
			off += len
			if s1.verbose == 2 {
				C.printf(c'   -> %s\n', hdr.ar_name)
			}
			if tcc_load_object_file(s1, fd, off) < 0 {
				unsafe {
					goto the_end
				} // id: 0x7fffe90626c0
			}
			bound++
			p += C.strlen(p) + 1
		}
		// while()
		if !bound {
			break
		}
	}
	ret = 0
	// RRRREG the_end id=0x7fffe90626c0
	the_end:
	tcc_free(data)
	return ret
}

fn tcc_load_archive(s1 &TCCState, fd int, alacarte int) int {
	hdr := ArchiveHeader{}
	size := 0
	len := 0

	file_offset := u32(0)
	ehdr := Elf64_Ehdr{}
	file_offset = sizeof(c'!<arch>\n') - 1
	for ; true; {
		len = read_ar_header(fd, file_offset, &hdr)
		if len == 0 {
			return 0
		}
		if len < 0 {
			return _tcc_error_noabort('invalid archive')
		}
		file_offset += len
		size = C.strtol(hdr.ar_size, (unsafe { nil }), 0)
		size = (size + 1) & ~1
		if alacarte {
			if !C.strcmp(hdr.ar_name, c'/') {
				return tcc_load_alacarte(s1, fd, size, 4)
			}
			if !C.strcmp(hdr.ar_name, c'/SYM64/') {
				return tcc_load_alacarte(s1, fd, size, 8)
			}
		} else if tcc_object_type(fd, &ehdr) == 1 {
			if s1.verbose == 2 {
				C.printf(c'   -> %s\n', hdr.ar_name)
			}
			if tcc_load_object_file(s1, fd, file_offset) < 0 {
				return -1
			}
		}
		file_offset += size
	}
	return 0
}

fn set_ver_to_ver(s1 &TCCState, n &int, lv &&int, i int, lib &i8, version &i8) {
	for i >= *n {
		*lv = tcc_realloc(*lv, (*n + 1) * sizeof(**lv))
		(*lv)[(*n)++] = -1
	}
	if (*lv)[i] == -1 {
		v := 0
		prev_same_lib := -1

		for v = 0; v < s1.nb_sym_versions; v++ {
			if C.strcmp(s1.sym_versions[v].lib, lib) {
				continue
			}
			prev_same_lib = v
			if !C.strcmp(s1.sym_versions[v].version, version) {
				break
			}
		}
		if v == s1.nb_sym_versions {
			s1.sym_versions = tcc_realloc(s1.sym_versions, (v + 1) * sizeof(*s1.sym_versions))
			s1.sym_versions[v].lib = tcc_strdup(lib)
			s1.sym_versions[v].version = tcc_strdup(version)
			s1.sym_versions[v].out_index = 0
			s1.sym_versions[v].prev_same_lib = prev_same_lib
			s1.nb_sym_versions++
		}
		(*lv)[i] = v
	}
}

fn set_sym_version(s1 &TCCState, sym_index int, verndx int) {
	if sym_index >= s1.nb_sym_to_version {
		newelems := if sym_index { sym_index * 2 } else { 1 }
		s1.sym_to_version = tcc_realloc(s1.sym_to_version, newelems * sizeof(*s1.sym_to_version))
		C.memset(s1.sym_to_version + s1.nb_sym_to_version, -1, (newelems - s1.nb_sym_to_version) * sizeof(*s1.sym_to_version))
		s1.nb_sym_to_version = newelems
	}
	if s1.sym_to_version[sym_index] < 0 {
		s1.sym_to_version[sym_index] = verndx
	}
}

struct Versym_info {
	nb_versyms   int
	verdef       &Elf64_Verdef
	verneed      &Elf64_Verneed
	versym       &Elf64_Half
	nb_local_ver int
	local_ver    &int
}

fn store_version(s1 &TCCState, v &Versym_info, dynstr &i8) {
	lib := &i8(0)
	version := &i8(0)

	next := u32(0)
	i := 0
	if v.versym && v.verdef {
		vdef := v.verdef
		lib = (unsafe { nil })
		for {
			verdaux := &Elf64_Verdaux(((&i8(vdef)) + vdef.vd_aux))
			if vdef.vd_cnt {
				version = dynstr + verdaux.vda_name
				if lib == (unsafe { nil }) {
					lib = version
				} else { // 3
					set_ver_to_ver(s1, &v.nb_local_ver, &v.local_ver, vdef.vd_ndx, lib,
						version)
				}
			}
			next = vdef.vd_next
			vdef = &Elf64_Verdef(((&i8(vdef)) + next))
			// while()
			if !next {
				break
			}
		}
	}
	if v.versym && v.verneed {
		vneed := v.verneed
		for {
			vernaux := &Elf64_Vernaux(((&i8(vneed)) + vneed.vn_aux))
			lib = dynstr + vneed.vn_file
			for i = 0; i < vneed.vn_cnt; i++ {
				if (vernaux.vna_other & 32768) == 0 {
					version = dynstr + vernaux.vna_name
					set_ver_to_ver(s1, &v.nb_local_ver, &v.local_ver, vernaux.vna_other,
						lib, version)
				}
				vernaux = &Elf64_Vernaux(((&i8(vernaux)) + vernaux.vna_next))
			}
			next = vneed.vn_next
			vneed = &Elf64_Verneed(((&i8(vneed)) + next))
			// while()
			if !next {
				break
			}
		}
	}
}

fn tcc_load_dll(s1 &TCCState, fd int, filename &i8, level int) int {
	ehdr := Elf64_Ehdr{}
	shdr := &Elf64_Shdr(0)
	sh := &Elf64_Shdr(0)
	sh1 := &Elf64_Shdr(0)

	i := 0
	nb_syms := 0
	nb_dts := 0
	sym_bind := 0
	ret := -1

	sym := &Elf64_Sym(0)
	dynsym := &Elf64_Sym(0)

	dt := &Elf64_Dyn(0)
	dynamic := &Elf64_Dyn(0)

	dynstr := &i8(0)
	sym_index := 0
	name := &i8(0)
	soname := &i8(0)

	v := Versym_info{}
	full_read(fd, &ehdr, sizeof(ehdr))
	if ehdr.e_ident[5] != 1 || ehdr.e_machine != 62 {
		return _tcc_error_noabort('bad architecture')
	}
	shdr = load_data(fd, ehdr.e_shoff, sizeof(Elf64_Shdr) * ehdr.e_shnum)
	nb_syms = 0
	nb_dts = 0
	dynamic = (unsafe { nil })
	dynsym = (unsafe { nil })
	dynstr = (unsafe { nil })
	C.memset(&v, 0, sizeof(v))
	i = 0
	for sh = shdr; i < ehdr.e_shnum; i++, unsafe { sh++ } {
		match sh.sh_type {
			6 { // case comp body kind=BinaryOperator is_enum=true
				nb_dts = sh.sh_size / sizeof(Elf64_Dyn)
				dynamic = load_data(fd, sh.sh_offset, sh.sh_size)
			}
			11 { // case comp body kind=BinaryOperator is_enum=true
				nb_syms = sh.sh_size / sizeof(Elf64_Sym)
				dynsym = load_data(fd, sh.sh_offset, sh.sh_size)
				sh1 = &shdr[sh.sh_link]
				dynstr = load_data(fd, sh1.sh_offset, sh1.sh_size)
			}
			1879048189 { // case comp body kind=BinaryOperator is_enum=true
				v.verdef = load_data(fd, sh.sh_offset, sh.sh_size)
			}
			1879048190 { // case comp body kind=BinaryOperator is_enum=true
				v.verneed = load_data(fd, sh.sh_offset, sh.sh_size)
			}
			1879048191 { // case comp body kind=BinaryOperator is_enum=true
				v.nb_versyms = sh.sh_size / sizeof(Elf64_Half)
				v.versym = load_data(fd, sh.sh_offset, sh.sh_size)
			}
			else {}
		}
	}
	if !dynamic {
		goto the_end // id: 0x7fffe9071040
	}
	soname = tcc_basename(filename)
	i = 0
	for dt = dynamic; i < nb_dts; i++, unsafe { dt++ } {
		if dt.d_tag == 14 {
			soname = dynstr + dt.d_un.d_val
		}
	}
	if tcc_add_dllref(s1, soname, level).found {
		goto ret_success // id: 0x7fffe90717c0
	}
	if v.nb_versyms != nb_syms {
		tcc_free(v.versym)
		v.versym = unsafe { nil }
	} else { // 3
		store_version(s1, &v, dynstr)
	}
	i = 1

	for sym = unsafe { dynsym + 1 }; i < nb_syms; i++, unsafe { sym++ } {
		sym_bind = ((u8((sym.st_info))) >> 4)
		if sym_bind == 0 {
			continue
		}
		name = dynstr + sym.st_name
		sym_index = set_elf_sym(s1.dynsymtab_section, sym.st_value, sym.st_size, sym.st_info,
			sym.st_other, sym.st_shndx, name)
		if v.versym {
			vsym := v.versym[i]
			if (vsym & 32768) == 0 && vsym > 0 && vsym < v.nb_local_ver {
				set_sym_version(s1, sym_index, v.local_ver[vsym])
			}
		}
	}
	// RRRREG ret_success id=0x7fffe90717c0
	ret_success:
	ret = 0
	// RRRREG the_end id=0x7fffe9071040
	the_end:
	tcc_free(dynstr)
	tcc_free(dynsym)
	tcc_free(dynamic)
	tcc_free(shdr)
	tcc_free(v.local_ver)
	tcc_free(v.verdef)
	tcc_free(v.verneed)
	tcc_free(v.versym)
	return ret
}

fn ld_inp(s1 &TCCState) int {
	b := i8(0)
	if s1.cc != -1 {
		c := s1.cc
		s1.cc = -1
		return c
	}
	if 1 == C.read(s1.fd, &b, 1) {
		return b
	}
	return -1
}

fn ld_next(s1 &TCCState, name &i8, name_size int) int {
	c := 0
	d := 0
	ch := 0

	q := &i8(0)
	// RRRREG redo id=0x7fffe90744f8
	redo:
	ch = ld_inp(s1)
	match rune(ch) {
		` `, `\t`, `\f`, `\v`, `\r`, `\n` {
			goto redo // id: 0x7fffe90744f8
		}
		`/` { // case comp body kind=BinaryOperator is_enum=false
			ch = ld_inp(s1)
			if ch == `*` {
				for d = 0; true; d = ch {
					ch = ld_inp(s1)
					if ch == (-1) || (ch == `/` && d == `*`) {
					}
				}
				goto redo // id: 0x7fffe90744f8
			} else {
				q = name
				*q++ = `/`
				goto parse_name // id: 0x7fffe9074f00
			}
		}
		`\\`, `a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`,
		`r`, `s`, `t`, `u`, `v`, `w`, `x`, `y`, `z`, `A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`, `I`,
		`J`, `K`, `L`, `M`, `N`, `O`, `P`, `Q`, `R`, `S`, `T`, `U`, `V`, `W`, `X`, `Y`, `Z`, `_`,
		`.`, `$`, `~` {
			q = name
			// RRRREG parse_name id=0x7fffe9074f00

			parse_name: for ; true; {
				if !((ch >= `a` && ch <= `z`) || (ch >= `A` && ch <= `Z`)
					|| (ch >= `0` && ch <= `9`) || C.strchr(c'/.-_+=$:\\,~', ch)) {
				}
				if (q - name) < name_size - 1 {
					*q++ = ch
				}
				ch = ld_inp(s1)
			}
			s1.cc = ch
			*q = `\x00`
			c = 256
		}
		(-1) { // case comp body kind=BinaryOperator is_enum=false
			c = (-1)
		}
		else {
			c = ch
		}
	}
	return c
}

fn ld_add_file(s1 &TCCState, filename &i8) int {
	if filename[0] == '/' {
		if CONFIG_SYSROOT[0] == `\x00` && tcc_add_file_internal(s1, filename, 64) == 0 {
			return 0
		}
		filename = tcc_basename(filename)
	}
	return tcc_add_dll(s1, filename, 16)
}

fn ld_add_file_list(s1 &TCCState, cmd &i8, as_needed int) int {
	filename := [1024]i8{}
	libname := [1024]i8{}

	t := 0
	group := 0
	nblibs := 0
	ret := 0

	libs := &&char(unsafe { nil })
	group = !C.strcmp(cmd, c'GROUP')
	if !as_needed {
		s1.new_undef_sym = 0
	}
	t = ld_next(s1, filename, sizeof(filename))
	if t != `(` {
		ret = _tcc_error_noabort('( expected')
		goto lib_parse_error // id: 0x7fffe9078940
	}
	t = ld_next(s1, filename, sizeof(filename))
	for ; true; {
		libname[0] = `\x00`
		if t == (-1) {
			ret = _tcc_error_noabort('unexpected end of file')
			goto lib_parse_error // id: 0x7fffe9078940
		} else if t == `)` {
			break
		} else if t == `-` {
			t = ld_next(s1, filename, sizeof(filename))
			if t != 256 || filename[0] != 'l' {
				ret = _tcc_error_noabort('library name expected')
				goto lib_parse_error // id: 0x7fffe9078940
			}
			pstrcpy(libname, sizeof(libname), &filename[1])
			if s1.static_link {
				C.snprintf(filename, sizeof(filename), c'lib%s.a', libname)
			} else {
				C.snprintf(filename, sizeof(filename), c'lib%s.so', libname)
			}
		} else if t != 256 {
			ret = _tcc_error_noabort('filename expected')
			goto lib_parse_error // id: 0x7fffe9078940
		}
		if !C.strcmp(filename, c'AS_NEEDED') {
			ret = ld_add_file_list(s1, cmd, 1)
			if ret {
				goto lib_parse_error // id: 0x7fffe9078940
			}
		} else {
			if 1 || !as_needed {
				ret = ld_add_file(s1, filename)
				if ret {
					goto lib_parse_error // id: 0x7fffe9078940
				}
				if group {
					dynarray_add(&libs, &nblibs, tcc_strdup(filename))
					if libname[0] != '\x00' {
						dynarray_add(&libs, &nblibs, tcc_strdup(libname))
					}
				}
			}
		}
		t = ld_next(s1, filename, sizeof(filename))
		if t == `,` {
			t = ld_next(s1, filename, sizeof(filename))
		}
	}
	if group && !as_needed {
		for s1.new_undef_sym {
			i := 0
			s1.new_undef_sym = 0
			for i = 0; i < nblibs; i++ {
				ld_add_file(s1, libs[i])
			}
		}
	}
	// RRRREG lib_parse_error id=0x7fffe9078940
	lib_parse_error:
	dynarray_reset(&libs, &nblibs)
	return ret
}

fn tcc_load_ldscript(s1 &TCCState, fd int) int {
	cmd := [64]i8{}
	filename := [1024]i8{}
	t := 0
	ret := 0

	s1.fd = fd
	s1.cc = -1
	for ; true; {
		t = ld_next(s1, cmd, sizeof(cmd))
		if t == (-1) {
			return 0
		} else if t != 256 {
			return -1
		}
		if !C.strcmp(cmd, c'INPUT') || !C.strcmp(cmd, c'GROUP') {
			ret = ld_add_file_list(s1, cmd, 0)
			if ret {
				return ret
			}
		} else if !C.strcmp(cmd, c'OUTPUT_FORMAT') || !C.strcmp(cmd, c'TARGET') {
			t = ld_next(s1, cmd, sizeof(cmd))
			if t != `(` {
				return _tcc_error_noabort('( expected')
			}
			for ; true; {
				t = ld_next(s1, filename, sizeof(filename))
				if t == (-1) {
					return _tcc_error_noabort('unexpected end of file')
				} else if t == `)` {
					break
				}
			}
		} else {
			return -1
		}
	}
	return 0
}
