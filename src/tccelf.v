@[translated]
module main

fn tccelf_new(s &TCCState)  {
	dynarray_add(&s.sections, &s.nb_sections, (voidptr(0)))
	text_section = new_section(s, c'.text', 1, (1 << 1) | (1 << 2))
	data_section = new_section(s, c'.data', 1, (1 << 1) | (1 << 0))
	bss_section = new_section(s, c'.bss', 8, (1 << 1) | (1 << 0))
	common_section = new_section(s, c'.common', 8, 2147483648)
	common_section.sh_num = 65522
	symtab_section = new_symtab(s, c'.symtab', 2, 0, c'.strtab', c'.hashtab', 2147483648)
	s.symtab = symtab_section
	s.dynsymtab_section = new_symtab(s, c'.dynsymtab', 2, 2147483648 | 1073741824, c'.dynstrtab', c'.dynhashtab', 2147483648)
	get_sym_attr(s, 0, 1)
}

fn tccelf_bounds_new(s &TCCState)  {
	bounds_section = new_section(s, c'.bounds', 1, (1 << 1))
	lbounds_section = new_section(s, c'.lbounds', 1, (1 << 1))
}

fn tccelf_stab_new(s &TCCState)  {
	stab_section = new_section(s, c'.stab', 1, 0)
	stab_section.sh_entsize = sizeof(Stab_Sym)
	stabstr_section = new_section(s, c'.stabstr', 3, 0)
	put_elf_str(stabstr_section, c'')
	stab_section.link = stabstr_section
	put_stabs(c'', 0, 0, 0, 0)
}

fn free_section(s &Section)  {
	tcc_free(s.data)
}

fn tccelf_delete(s1 &TCCState)  {
	i := 0
	for i = 1 ; i < s1.nb_sections ; i ++ {
	free_section(s1.sections [i] )
	}
	dynarray_reset(&s1.sections, &s1.nb_sections)
	for i = 0 ; i < s1.nb_priv_sections ; i ++ {
	free_section(s1.priv_sections [i] )
	}
	dynarray_reset(&s1.priv_sections, &s1.nb_priv_sections)
	for i = 0 ; i < s1.nb_loaded_dlls ; i ++ {
		ref := s1.loaded_dlls [i] 
		if ref.handle {
		dlclose(ref.handle)
		}
	}
	dynarray_reset(&s1.loaded_dlls, &s1.nb_loaded_dlls)
	tcc_free(s1.sym_attrs)
	symtab_section = (voidptr(0))
}

fn tccelf_begin_file(s1 &TCCState)  {
	s := &Section(0)
	i := 0
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		s.sh_offset = s.data_offset
	}
	s = s1.symtab , s.hash
	s.reloc = s = s1.symtab , (voidptr(0))
	s.hash = s = s1.symtab , s.hash
	s.reloc = s = s1.symtab
}

fn tccelf_end_file(s1 &TCCState)  {
	s := s1.symtab
	first_sym := 0
	nb_syms := 0
	tr := &int(0)
	i := 0
	
	first_sym = s.sh_offset / sizeof(Elf64_Sym)
	nb_syms = s.data_offset / sizeof(Elf64_Sym) - first_sym
	s.data_offset = s.sh_offset
	s.link.data_offset = s.link.sh_offset
	s.hash = s.reloc , (voidptr(0))
	s.reloc = s.hash = s.reloc
	tr = tcc_mallocz(nb_syms * sizeof*tr)
	for i = 0 ; i < nb_syms ; i ++ {
		sym := &Elf64_Sym(s.data) + first_sym + i
		if sym.st_shndx == 0 && ((u8((sym.st_info))) >> 4) == 0 {
		sym.st_info = ((((1)) << 4) + (((((sym.st_info) & 15))) & 15))
		}
		tr [i]  = set_elf_sym(s, sym.st_value, sym.st_size, sym.st_info, sym.st_other, sym.st_shndx, &i8(s.link.data) + sym.st_name)
	}
	for i = 1 ; i < s1.nb_sections ; i ++ {
		sr := s1.sections [i] 
		if sr.sh_type == 4 && sr.link == s {
			rel := &Elf64_Rela((sr.data + sr.sh_offset))
			rel_end := &Elf64_Rela((sr.data + sr.data_offset))
			for  ; rel < rel_end ; rel ++ {
				n := ((rel.r_info) >> 32) - first_sym
				rel.r_info = (((Elf64_Xword((tr [n] ))) << 32) + (((rel.r_info) & 4294967295)))
			}
		}
	}
	tcc_free(tr)
}

fn new_section(s1 &TCCState, name &i8, sh_type int, sh_flags int) &Section {
	sec := &Section(0)
	sec = tcc_mallocz(sizeof(Section) + C.strlen(name))
	strcpy(sec.name, name)
	sec.sh_type = sh_type
	sec.sh_flags = sh_flags
	match sh_type {
	 5, 9, 4, 11, 2, 6{
	sec.sh_addralign = 4
	
	}
	 3{ // case comp body kind=BinaryOperator is_enum=false
	sec.sh_addralign = 1
	
	
	}
	else {
	sec.sh_addralign = 8
	}
	}
	if sh_flags & 2147483648 {
		dynarray_add(&s1.priv_sections, &s1.nb_priv_sections, sec)
	}
	else {
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
	put_elf_sym(symtab, 0, 0, 0, 0, 0, (voidptr(0)))
	nb_buckets = 1
	hash = new_section(s1, hash_name, 5, hash_sh_flags)
	hash.sh_entsize = sizeof(int)
	symtab.hash = hash
	hash.link = symtab
	ptr = section_ptr_add(hash, (2 + nb_buckets + 1) * sizeof(int))
	ptr [0]  = nb_buckets
	ptr [1]  = 1
	C.memset(ptr + 2, 0, (nb_buckets + 1) * sizeof(int))
	return symtab
}

fn section_realloc(sec &Section, new_size u32)  {
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
	C.memset(data + sec.data_allocated, 0, size - sec.data_allocated)
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
	return sec.data + offset
}

fn section_reserve(sec &Section, size u32)  {
	if size > sec.data_allocated {
	section_realloc(sec, size)
	}
	if size > sec.data_offset {
	sec.data_offset = size
	}
}

fn find_section(s1 &TCCState, name &i8) &Section {
	sec := &Section(0)
	i := 0
	for i = 1 ; i < s1.nb_sections ; i ++ {
		sec = s1.sections [i] 
		if !C.strcmp(name, sec.name) {
		return sec
		}
	}
	return new_section(s1, name, 1, (1 << 1))
}

fn put_elf_str(s &Section, sym &i8) int {
	offset := 0
	len := 0
	
	ptr := &i8(0)
	len = C.strlen(sym) + 1
	offset = s.data_offset
	ptr = section_ptr_add(s, len)
	C.memmove(ptr, sym, len)
	return offset
}

fn elf_hash(name &u8) u32 {
	h := 0
g := u32(0)
	
	for *name {
		h = (h << 4) + *name ++
		g = h & 4026531840
		if g {
		h ^= g >> 24
		}
		h &= ~g
	}
	return h
}

fn rebuild_hash(s &Section, nb_buckets u32)  {
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
	nb_buckets = (&int(s.hash.data)) [0] 
	}
	s.hash.data_offset = 0
	ptr = section_ptr_add(s.hash, (2 + nb_buckets + nb_syms) * sizeof(int))
	ptr [0]  = nb_buckets
	ptr [1]  = nb_syms
	ptr += 2
	hash = ptr
	C.memset(hash, 0, (nb_buckets + 1) * sizeof(int))
	ptr += nb_buckets + 1
	sym = &Elf64_Sym(s.data) + 1
	for sym_index = 1 ; sym_index < nb_syms ; sym_index ++ {
		if ((u8((sym.st_info))) >> 4) != 0 {
			h = elf_hash(strtab + sym.st_name) % nb_buckets
			*ptr = hash [h] 
			hash [h]  = sym_index
		}
		else {
			*ptr = 0
		}
		ptr ++
		sym ++
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
	if name && name [0]  {
	name_offset = put_elf_str(s.link, name)
	}
	else { // 3
	name_offset = 0
}
	sym.st_name = name_offset
	sym.st_value = value
	sym.st_size = size
	sym.st_info = info
	sym.st_other = other
	sym.st_shndx = shndx
	sym_index = sym - &Elf64_Sym(s.data)
	hs = s.hash
	if hs {
		ptr := &int(0)
		base := &int(0)
		
		ptr = section_ptr_add(hs, sizeof(int))
		base = &int(hs.data)
		if ((u8((info))) >> 4) != 0 {
			nbuckets = base [0] 
			h = elf_hash(&u8(s.link.data) + name_offset) % nbuckets
			*ptr = base [2 + h] 
			base [2 + h]  = sym_index
			base [1]  ++
			hs.nb_hashed_syms ++
			if hs.nb_hashed_syms > 2 * nbuckets {
				rebuild_hash(s, 2 * nbuckets)
			}
		}
		else {
			*ptr = 0
			base [1]  ++
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
	nbuckets = (&int(hs.data)) [0] 
	h = elf_hash(&u8(name)) % nbuckets
	sym_index = (&int(hs.data)) [2 + h] 
	for sym_index != 0 {
		sym = &(&Elf64_Sym(s.data)) [sym_index] 
		name1 = &i8(s.link.data) + sym.st_name
		if !C.strcmp(name, name1) {
		return sym_index
		}
		sym_index = (&int(hs.data)) [2 + nbuckets + sym_index] 
	}
	return 0
}

fn get_elf_sym_addr(s &TCCState, name &i8, err int) Elf64_Addr {
	sym_index := 0
	sym := &Elf64_Sym(0)
	sym_index = find_elf_sym(s.symtab, name)
	sym = &(&Elf64_Sym(s.symtab.data)) [sym_index] 
	if !sym_index || sym.st_shndx == 0 {
		if err {
		tcc_error(c'%s not defined', name)
		}
		return 0
	}
	return sym.st_value
}

fn list_elf_symbols(s &TCCState, ctx voidptr, symbol_cb fn (voidptr, &i8, voidptr))  {
	sym := &Elf64_Sym(0)
	symtab := &Section(0)
	sym_index := 0
	end_sym := 0
	
	name := &i8(0)
	sym_vis := u8(0)
	sym_bind := u8(0)
	
	symtab = s.symtab
	end_sym = symtab.data_offset / sizeof(Elf64_Sym)
	for sym_index = 0 ; sym_index < end_sym ; sym_index ++ {
		sym = &(&Elf64_Sym(symtab.data)) [sym_index] 
		if sym.st_value {
			name = &i8(symtab.link.data) + sym.st_name
			sym_bind = ((u8((sym.st_info))) >> 4)
			sym_vis = ((sym.st_other) & 3)
			if sym_bind == 1 && sym_vis == 0 {
			symbol_cb(ctx, name, voidptr(Uintptr_t(sym.st_value)))
			}
		}
	}
}

fn tcc_get_symbol(s &TCCState, name &i8) voidptr {
	return voidptr(Uintptr_t(get_elf_sym_addr(s, name, 0)))
}

fn tcc_list_symbols(s &TCCState, ctx voidptr, symbol_cb fn (voidptr, &i8, voidptr))  {
	list_elf_symbols(s, ctx, symbol_cb)
}

fn tcc_get_symbol_err(s &TCCState, name &i8) voidptr {
	return voidptr(Uintptr_t(get_elf_sym_addr(s, name, 1)))
}

fn set_elf_sym(s &Section, value Elf64_Addr, size u32, info int, other int, shndx int, name &i8) int {
	esym := &Elf64_Sym(0)
	sym_bind := 0
	sym_index := 0
	sym_type := 0
	esym_bind := 0
	
	sym_vis := u8(0)
	esym_vis := u8(0)
	new_vis := u8(0)
	
	sym_bind = ((u8((info))) >> 4)
	sym_type = ((info) & 15)
	sym_vis = ((other) & 3)
	if sym_bind != 0 {
		sym_index = find_elf_sym(s, name)
		if !sym_index {
		goto do_def // id: 0x7fffc61d1158
		}
		esym = &(&Elf64_Sym(s.data)) [sym_index] 
		if esym.st_value == value && esym.st_size == size && esym.st_info == info && esym.st_other == other && esym.st_shndx == shndx {
		return sym_index
		}
		if esym.st_shndx != 0 {
			esym_bind = ((u8((esym.st_info))) >> 4)
			esym_vis = ((esym.st_other) & 3)
			if esym_vis == 0 {
				new_vis = sym_vis
			}
			else if sym_vis == 0 {
				new_vis = esym_vis
			}
			else {
				new_vis = if (esym_vis < sym_vis){ esym_vis } else {sym_vis}
			}
			esym.st_other = (esym.st_other & ~((-1) & 3)) | new_vis
			other = esym.st_other
			if shndx == 0 {
			}
			else if sym_bind == 1 && esym_bind == 2 {
				goto do_patch // id: 0x7fffc61d2700
			}
			else if sym_bind == 2 && esym_bind == 1 {
			}
			else if sym_bind == 2 && esym_bind == 2 {
			}
			else if sym_vis == 2 || sym_vis == 1 {
			}
			else if (esym.st_shndx == 65522 || esym.st_shndx == bss_section.sh_num) && (shndx < 65280 && shndx != bss_section.sh_num) {
				goto do_patch // id: 0x7fffc61d2700
			}
			else if shndx == 65522 || shndx == bss_section.sh_num {
			}
			else if s.sh_flags & 1073741824 {
			}
			else if esym.st_other & 4 {
				goto do_patch // id: 0x7fffc61d2700
			}
			else {
				tcc_error_noabort(c"'%s' defined twice", name)
			}
		}
		else {
			// RRRREG do_patch id=0x7fffc61d2700
			do_patch: 
			esym.st_info = ((((sym_bind)) << 4) + (((sym_type)) & 15))
			esym.st_shndx = shndx
			new_undef_sym = 1
			esym.st_value = value
			esym.st_size = size
			esym.st_other = other
		}
	}
	else {
		// RRRREG do_def id=0x7fffc61d1158
		do_def: 
		sym_index = put_elf_sym(s, value, size, ((((sym_bind)) << 4) + (((sym_type)) & 15)), other, shndx, name)
	}
	return sym_index
}

fn put_elf_reloca(symtab &Section, s &Section, offset u32, type_ int, symbol int, addend Elf64_Addr)  {
	buf := [256]i8{}
	sr := &Section(0)
	rel := &Elf64_Rela(0)
	sr = s.reloc
	if !sr {
		C.snprintf(buf, sizeof(buf), c'.rela%s', s.name)
		sr = new_section(tcc_state, buf, 4, symtab.sh_flags)
		sr.sh_entsize = sizeof(Elf64_Rela)
		sr.link = symtab
		sr.sh_info = s.sh_num
		s.reloc = sr
	}
	rel = section_ptr_add(sr, sizeof(Elf64_Rela))
	rel.r_offset = offset
	rel.r_info = (((Elf64_Xword((symbol))) << 32) + (type_))
	rel.r_addend = addend
}

fn put_elf_reloc(symtab &Section, s &Section, offset u32, type_ int, symbol int)  {
	put_elf_reloca(symtab, s, offset, type_, symbol, 0)
}

fn squeeze_multi_relocs(s &Section, oldrelocoffset usize)  {
	sr := s.reloc
	r := &Elf64_Rela(0)
	dest := &Elf64_Rela(0)
	
	a := isize(0)
	addr := Elf64_Addr{}
	if oldrelocoffset + sizeof(*r) >= sr.data_offset {
	return 
	}
	for a = oldrelocoffset + sizeof(*r) ; a < sr.data_offset ; a += sizeof(*r) {
		i := a - sizeof(*r)
		addr = (&Elf64_Rela((sr.data + a))).r_offset
		for  ; i >= isize(oldrelocoffset) && (&Elf64_Rela((sr.data + i))).r_offset > addr ; i -= sizeof(*r) {
			tmp := *&Elf64_Rela((sr.data + a))
			*&Elf64_Rela((sr.data + a)) = *&Elf64_Rela((sr.data + i))
			*&Elf64_Rela((sr.data + i)) = tmp
		}
	}
	r = &Elf64_Rela((sr.data + oldrelocoffset))
	dest = r
	for  ; r < &Elf64_Rela((sr.data + sr.data_offset)) ; r ++ {
		if dest.r_offset != r.r_offset {
		dest ++
		}
		*dest = *r
	}
	sr.data_offset = &u8(dest) - sr.data + sizeof(*r)
}

fn put_stabs(str &i8, type_ int, other int, desc int, value u32)  {
	sym := &Stab_Sym(0)
	sym = section_ptr_add(stab_section, sizeof(Stab_Sym))
	if str {
		sym.n_strx = put_elf_str(stabstr_section, str)
	}
	else {
		sym.n_strx = 0
	}
	sym.n_type = type_
	sym.n_other = other
	sym.n_desc = desc
	sym.n_value = value
}

fn put_stabs_r(str &i8, type_ int, other int, desc int, value u32, sec &Section, sym_index int)  {
	put_stabs(str, type_, other, desc, value)
	put_elf_reloc(symtab_section, stab_section, stab_section.data_offset - sizeof(u32), 11, sym_index)
}

fn put_stabn(type_ int, other int, desc int, value int)  {
	put_stabs((voidptr(0)), type_, other, desc, value)
}

fn put_stabd(type_ int, other int, desc int)  {
	put_stabs((voidptr(0)), type_, other, desc, 0)
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
		C.memset(s1.sym_attrs + s1.nb_sym_attrs, 0, (n - s1.nb_sym_attrs) * sizeof(*s1.sym_attrs))
		s1.nb_sym_attrs = n
	}
	return &s1.sym_attrs [index] 
}

fn sort_syms(s1 &TCCState, s &Section)  {
	old_to_new_syms := &int(0)
	new_syms := &Elf64_Sym(0)
	nb_syms := 0
	i := 0
	
	p := &Elf64_Sym(0)
	q := &Elf64_Sym(0)
	
	rel := &Elf64_Rela(0)
	sr := &Section(0)
	type_ := 0
	sym_index := 0
	
	nb_syms = s.data_offset / sizeof(Elf64_Sym)
	new_syms = tcc_malloc(nb_syms * sizeof(Elf64_Sym))
	old_to_new_syms = tcc_malloc(nb_syms * sizeof(int))
	p = &Elf64_Sym(s.data)
	q = new_syms
	for i = 0 ; i < nb_syms ; i ++ {
		if ((u8((p.st_info))) >> 4) == 0 {
			old_to_new_syms [i]  = q - new_syms
			*q ++ = *p
		}
		p ++
	}
	if s.sh_size {
	s.sh_info = q - new_syms
	}
	p = &Elf64_Sym(s.data)
	for i = 0 ; i < nb_syms ; i ++ {
		if ((u8((p.st_info))) >> 4) != 0 {
			old_to_new_syms [i]  = q - new_syms
			*q ++ = *p
		}
		p ++
	}
	C.memcpy(s.data, new_syms, nb_syms * sizeof(Elf64_Sym))
	tcc_free(new_syms)
	for i = 1 ; i < s1.nb_sections ; i ++ {
		sr = s1.sections [i] 
		if sr.sh_type == 4 && sr.link == s {
			for rel = &Elf64_Rela(sr.data) + 0 ; rel < &Elf64_Rela((sr.data + sr.data_offset)) ; rel ++ {
				sym_index = ((rel.r_info) >> 32)
				type_ = ((rel.r_info) & 4294967295)
				sym_index = old_to_new_syms [sym_index] 
				rel.r_info = (((Elf64_Xword((sym_index))) << 32) + (type_))
			}
		}
	}
	tcc_free(old_to_new_syms)
}

fn relocate_syms(s1 &TCCState, symtab &Section, do_resolve int)  {
	sym := &Elf64_Sym(0)
	sym_bind := 0
	sh_num := 0
	
	name := &i8(0)
	for sym = &Elf64_Sym(symtab.data) + 1 ; sym < &Elf64_Sym((symtab.data + symtab.data_offset)) ; sym ++ {
		sh_num = sym.st_shndx
		if sh_num == 0 {
			name = &i8(s1.symtab.link.data) + sym.st_name
			if do_resolve {
				addr := dlsym((voidptr(0)), name)
				if addr {
					sym.st_value = Elf64_Addr(addr)
					goto _GOTO_PLACEHOLDER_0x7fffc61e7300 // id: 0x7fffc61e7300
				}
			}
			else if s1.dynsym && find_elf_sym(s1.dynsym, name) {
			goto _GOTO_PLACEHOLDER_0x7fffc61e7300 // id: 0x7fffc61e7300
			}
			if !C.strcmp(name, c'_fp_hw') {
			goto _GOTO_PLACEHOLDER_0x7fffc61e7300 // id: 0x7fffc61e7300
			}
			sym_bind = ((u8((sym.st_info))) >> 4)
			if sym_bind == 2 {
			sym.st_value = 0
			}
			else { // 3
			tcc_error_noabort(c"undefined symbol '%s'", name)
}
		}
		else if sh_num < 65280 {
			sym.st_value += s1.sections [sym.st_shndx] .sh_addr
		}
		// RRRREG found id=0x7fffc61e7300
		found: 
		0
	}
}

fn relocate_section(s1 &TCCState, s &Section)  {
	sr := s.reloc
	rel := &Elf64_Rela(0)
	sym := &Elf64_Sym(0)
	type_ := 0
	sym_index := 0
	
	ptr := &u8(0)
	tgt := Elf64_Addr{}
	addr := Elf64_Addr{}
	
	relocate_init(sr)
	for rel = &Elf64_Rela(sr.data) + 0 ; rel < &Elf64_Rela((sr.data + sr.data_offset)) ; rel ++ {
		ptr = s.data + rel.r_offset
		sym_index = ((rel.r_info) >> 32)
		sym = &(&Elf64_Sym(symtab_section.data)) [sym_index] 
		type_ = ((rel.r_info) & 4294967295)
		tgt = sym.st_value
		tgt += rel.r_addend
		addr = s.sh_addr + rel.r_offset
		relocate(s1, rel, type_, ptr, addr, tgt)
	}
	if sr.sh_flags & (1 << 1) {
	sr.link = s1.dynsym
	}
}

fn relocate_rel(s1 &TCCState, sr &Section)  {
	s := &Section(0)
	rel := &Elf64_Rela(0)
	s = s1.sections [sr.sh_info] 
	for rel = &Elf64_Rela(sr.data) + 0 ; rel < &Elf64_Rela((sr.data + sr.data_offset)) ; rel ++ {
	rel.r_offset += s.sh_addr
	}
}

fn prepare_dynamic_rel(s1 &TCCState, sr &Section) int {
	count := 0
	rel := &Elf64_Rela(0)
	for rel = &Elf64_Rela(sr.data) + 0 ; rel < &Elf64_Rela((sr.data + sr.data_offset)) ; rel ++ {
		sym_index := ((rel.r_info) >> 32)
		type_ := ((rel.r_info) & 4294967295)
		match type_ {
		 10, 11, 1{
		count ++
		
		}
		 2{ // case comp body kind=IfStmt is_enum=false
		if get_sym_attr(s1, sym_index, 0).dyn_index {
		count ++
		}
		
		}
		else {
		
		}
		}
	}
	if count {
		sr.sh_flags |= (1 << 1)
		sr.sh_size = count * sizeof(Elf64_Rela)
	}
	return count
}

fn build_got(s1 &TCCState)  {
	s1.got = new_section(s1, c'.got', 1, (1 << 1) | (1 << 0))
	s1.got.sh_entsize = 4
	set_elf_sym(symtab_section, 0, 4, ((((1)) << 4) + (((1)) & 15)), 0, s1.got.sh_num, c'_GLOBAL_OFFSET_TABLE_')
	section_ptr_add(s1.got, 3 * 8)
}

fn put_got_entry(s1 &TCCState, dyn_reloc_type int, sym_index int) &Sym_attr {
	need_plt_entry := 0
	name := &i8(0)
	sym := &Elf64_Sym(0)
	attr := &Sym_attr(0)
	got_offset := u32(0)
	plt_name := [100]i8{}
	len := 0
	need_plt_entry = (dyn_reloc_type == 7)
	attr = get_sym_attr(s1, sym_index, 1)
	if if need_plt_entry{ attr.plt_offset } else {attr.got_offset} {
	return attr
	}
	got_offset = s1.got.data_offset
	section_ptr_add(s1.got, 8)
	sym = &(&Elf64_Sym(symtab_section.data)) [sym_index] 
	name = &i8(symtab_section.link.data) + sym.st_name
	if s1.dynsym {
		if ((u8((sym.st_info))) >> 4) == 0 {
			put_elf_reloc(s1.dynsym, s1.got, got_offset, 8, sym_index)
		}
		else {
			if 0 == attr.dyn_index {
			attr.dyn_index = set_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info, 0, sym.st_shndx, name)
			}
			put_elf_reloc(s1.dynsym, s1.got, got_offset, dyn_reloc_type, attr.dyn_index)
		}
	}
	else {
		put_elf_reloc(symtab_section, s1.got, got_offset, dyn_reloc_type, sym_index)
	}
	if need_plt_entry {
		if !s1.plt {
			s1.plt = new_section(s1, c'.plt', 1, (1 << 1) | (1 << 2))
			s1.plt.sh_entsize = 4
		}
		attr.plt_offset = create_plt_entry(s1, got_offset, attr)
		len = C.strlen(name)
		if len > sizeof(plt_name) - 5 {
		len = sizeof(plt_name) - 5
		}
		C.memcpy(plt_name, name, len)
		strcpy(plt_name + len, c'@plt')
		attr.plt_sym = put_elf_sym(s1.symtab, attr.plt_offset, sym.st_size, ((((1)) << 4) + (((2)) & 15)), 0, s1.plt.sh_num, plt_name)
	}
	else {
		attr.got_offset = got_offset
	}
	return attr
}

fn build_got_entries(s1 &TCCState)  {
	s := &Section(0)
	rel := &Elf64_Rela(0)
	sym := &Elf64_Sym(0)
	i := 0
	type_ := 0
	gotplt_entry := 0
	reloc_type := 0
	sym_index := 0
	
	attr := &Sym_attr(0)
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if s.sh_type != 4 {
		continue
		
		}
		if s.link != symtab_section {
		continue
		
		}
		for rel = &Elf64_Rela(s.data) + 0 ; rel < &Elf64_Rela((s.data + s.data_offset)) ; rel ++ {
			type_ = ((rel.r_info) & 4294967295)
			gotplt_entry = gotplt_entry_type(type_)
			sym_index = ((rel.r_info) >> 32)
			sym = &(&Elf64_Sym(symtab_section.data)) [sym_index] 
			if gotplt_entry == Gotplt_entry.no_gotplt_entry {
				continue
				
			}
			if gotplt_entry == Gotplt_entry.auto_gotplt_entry {
				if sym.st_shndx == 0 {
					esym := &Elf64_Sym(0)
					dynindex := 0
					if s1.output_type == 3 && !1 {
					continue
					
					}
					if s1.dynsym {
						dynindex = get_sym_attr(s1, sym_index, 0).dyn_index
						esym = &Elf64_Sym(s1.dynsym.data) + dynindex
						if dynindex && (((esym.st_info) & 15) == 2 || (((esym.st_info) & 15) == 0 && ((sym.st_info) & 15) == 2)) {
						goto jmp_slot // id: 0x7fffc61f15a8
						}
					}
				}
				else if !(sym.st_shndx == 65521 && 8 == 8) {
				continue
				
				}
			}
			if (type_ == 4 || type_ == 2) && sym.st_shndx != 0 && (((sym.st_other) & 3) != 0 || ((u8((sym.st_info))) >> 4) == 0 || s1.output_type == 2) {
				rel.r_info = (((Elf64_Xword((sym_index))) << 32) + (2))
				continue
				
			}
			if code_reloc(type_) {
				// RRRREG jmp_slot id=0x7fffc61f15a8
				jmp_slot: 
				reloc_type = 7
			}
			else { // 3
			reloc_type = 6
}
			if !s1.got {
			build_got(s1)
			}
			if gotplt_entry == Gotplt_entry.build_got_only {
			continue
			
			}
			attr = put_got_entry(s1, reloc_type, sym_index)
			if reloc_type == 7 {
			rel.r_info = (((Elf64_Xword((attr.plt_sym))) << 32) + (type_))
			}
		}
	}
}

fn put_dt(dynamic &Section, dt int, val Elf64_Addr)  {
	dyn := &Elf64_Dyn(0)
	dyn = section_ptr_add(dynamic, sizeof(Elf64_Dyn))
	dyn.d_tag = dt
	dyn.d_un.d_val = val
}

fn add_init_array_defines(s1 &TCCState, section_name &i8)  {
	s := &Section(0)
	end_offset := 0
	sym_start := [1024]i8{}
	sym_end := [1024]i8{}
	C.snprintf(sym_start, sizeof(sym_start), c'__%s_start', section_name + 1)
	C.snprintf(sym_end, sizeof(sym_end), c'__%s_end', section_name + 1)
	s = find_section(s1, section_name)
	if !s {
		end_offset = 0
		s = data_section
	}
	else {
		end_offset = s.data_offset
	}
	set_elf_sym(symtab_section, 0, 0, ((((1)) << 4) + (((0)) & 15)), 0, s.sh_num, sym_start)
	set_elf_sym(symtab_section, end_offset, 0, ((((1)) << 4) + (((0)) & 15)), 0, s.sh_num, sym_end)
}

fn tcc_add_support(s1 &TCCState, filename &i8) int {
	buf := [1024]i8{}
	C.snprintf(buf, sizeof(buf), c'%s/%s', s1.tcc_lib_path, filename)
	return tcc_add_file(s1, buf)
}

fn tcc_add_bcheck(s1 &TCCState)  {
	ptr := &Elf64_Addr(0)
	sym_index := 0
	if 0 == s1.do_bounds_check {
	return 
	}
	ptr = section_ptr_add(bounds_section, sizeof(*ptr))
	*ptr = 0
	set_elf_sym(symtab_section, 0, 0, ((((1)) << 4) + (((0)) & 15)), 0, bounds_section.sh_num, c'__bounds_start')
	sym_index = set_elf_sym(symtab_section, 0, 0, ((((1)) << 4) + (((0)) & 15)), 0, 0, c'__bound_init')
	if s1.output_type != 1 {
		init_section := find_section(s1, c'.init')
		pinit := section_ptr_add(init_section, 5)
		pinit [0]  = 232
		write32le(pinit + 1, -4)
		put_elf_reloc(symtab_section, init_section, init_section.data_offset - 4, 2, sym_index)
	}
}

fn tcc_add_runtime(s1 &TCCState)  {
	s1.filetype = 0
	tcc_add_bcheck(s1)
	tcc_add_pragma_libs(s1)
	if !s1.nostdlib {
		tcc_add_library_err(s1, c'c')
		tcc_add_support(s1, c'libtcc1.a')
		if s1.output_type != 1 {
		tcc_add_crt(s1, c'crtn.o')
		}
	}
}

fn tcc_add_linker_symbols(s1 &TCCState)  {
	buf := [1024]i8{}
	i := 0
	s := &Section(0)
	set_elf_sym(symtab_section, text_section.data_offset, 0, ((((1)) << 4) + (((0)) & 15)), 0, text_section.sh_num, c'_etext')
	set_elf_sym(symtab_section, data_section.data_offset, 0, ((((1)) << 4) + (((0)) & 15)), 0, data_section.sh_num, c'_edata')
	set_elf_sym(symtab_section, bss_section.data_offset, 0, ((((1)) << 4) + (((0)) & 15)), 0, bss_section.sh_num, c'_end')
	add_init_array_defines(s1, c'.preinit_array')
	add_init_array_defines(s1, c'.init_array')
	add_init_array_defines(s1, c'.fini_array')
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if s.sh_type == 1 && (s.sh_flags & (1 << 1)) {
			p := &i8(0)
			ch := 0
			p = s.name
			for  ;  ;  {
				ch = *p
				if !ch {
				break
				
				}
				if !isid(ch) && !isnum(ch) {
				goto next_sec // id: 0x7fffc61f8b18
				}
				p ++
			}
			C.snprintf(buf, sizeof(buf), c'__start_%s', s.name)
			set_elf_sym(symtab_section, 0, 0, ((((1)) << 4) + (((0)) & 15)), 0, s.sh_num, buf)
			C.snprintf(buf, sizeof(buf), c'__stop_%s', s.name)
			set_elf_sym(symtab_section, s.data_offset, 0, ((((1)) << 4) + (((0)) & 15)), 0, s.sh_num, buf)
		}
		// RRRREG next_sec id=0x7fffc61f8b18
		next_sec: 
		0
	}
}

fn resolve_common_syms(s1 &TCCState)  {
	sym := &Elf64_Sym(0)
	for sym = &Elf64_Sym(symtab_section.data) + 1 ; sym < &Elf64_Sym((symtab_section.data + symtab_section.data_offset)) ; sym ++ {
		if sym.st_shndx == 65522 {
			sym.st_value = section_add(bss_section, sym.st_size, sym.st_value)
			sym.st_shndx = bss_section.sh_num
		}
	}
	tcc_add_linker_symbols(s1)
}

fn tcc_output_binary(s1 &TCCState, f &C.FILE, sec_order &int)  {
	s := &Section(0)
	i := 0
	offset := 0
	size := 0
	
	offset = 0
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [sec_order [i] ] 
		if s.sh_type != 8 && (s.sh_flags & (1 << 1)) {
			for offset < s.sh_offset {
				fputc(0, f)
				offset ++
			}
			size = s.sh_size
			C.fwrite(s.data, 1, size, f)
			offset += size
		}
	}
}

fn fill_got_entry(s1 &TCCState, rel &Elf64_Rela)  {
	sym_index := ((rel.r_info) >> 32)
	sym := &(&Elf64_Sym(symtab_section.data)) [sym_index] 
	attr := get_sym_attr(s1, sym_index, 0)
	offset := attr.got_offset
	if 0 == offset {
	return 
	}
	section_reserve(s1.got, offset + 8)
	write64le(s1.got.data + offset, sym.st_value)
}

fn fill_got(s1 &TCCState)  {
	s := &Section(0)
	rel := &Elf64_Rela(0)
	i := 0
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if s.sh_type != 4 {
		continue
		
		}
		if s.link != symtab_section {
		continue
		
		}
		for rel = &Elf64_Rela(s.data) + 0 ; rel < &Elf64_Rela((s.data + s.data_offset)) ; rel ++ {
			match ((rel.r_info) & 4294967295) {
			 3, 9, 41, 42, 4{
			fill_got_entry(s1, rel)
			
			}
			else{}
			}
		}
	}
}

fn fill_local_got_entries(s1 &TCCState)  {
	rel := &Elf64_Rela(0)
	if !s1.got.reloc {
	return 
	}
	for rel = &Elf64_Rela(s1.got.reloc.data) + 0 ; rel < &Elf64_Rela((s1.got.reloc.data + s1.got.reloc.data_offset)) ; rel ++ {
		if ((rel.r_info) & 4294967295) == 8 {
			sym_index := ((rel.r_info) >> 32)
			sym := &(&Elf64_Sym(symtab_section.data)) [sym_index] 
			attr := get_sym_attr(s1, sym_index, 0)
			offset := attr.got_offset
			if offset != rel.r_offset - s1.got.sh_addr {
			tcc_error_noabort(c'huh')
			}
			rel.r_info = (((Elf64_Xword((0))) << 32) + (8))
			rel.r_addend = sym.st_value
		}
	}
}

fn bind_exe_dynsyms(s1 &TCCState)  {
	name := &i8(0)
	sym_index := 0
	index := 0
	
	sym := &Elf64_Sym(0)
	esym := &Elf64_Sym(0)
	
	type_ := 0
	for sym = &Elf64_Sym(symtab_section.data) + 1 ; sym < &Elf64_Sym((symtab_section.data + symtab_section.data_offset)) ; sym ++ {
		if sym.st_shndx == 0 {
			name = &i8(symtab_section.link.data) + sym.st_name
			sym_index = find_elf_sym(s1.dynsymtab_section, name)
			if sym_index {
				esym = &(&Elf64_Sym(s1.dynsymtab_section.data)) [sym_index] 
				type_ = ((esym.st_info) & 15)
				if (type_ == 2) || (type_ == 10) {
					dynindex := put_elf_sym(s1.dynsym, 0, esym.st_size, ((((1)) << 4) + (((2)) & 15)), 0, 0, name)
					index := sym - &Elf64_Sym(symtab_section.data)
					get_sym_attr(s1, index, 1).dyn_index = dynindex
				}
				else if type_ == 1 {
					offset := u32(0)
					dynsym := &Elf64_Sym(0)
					offset = bss_section.data_offset
					offset = (offset + 16 - 1) & -16
					set_elf_sym(s1.symtab, offset, esym.st_size, esym.st_info, 0, bss_section.sh_num, name)
					index = put_elf_sym(s1.dynsym, offset, esym.st_size, esym.st_info, 0, bss_section.sh_num, name)
					if ((u8((esym.st_info))) >> 4) == 2 {
						for dynsym = &Elf64_Sym(s1.dynsymtab_section.data) + 1 ; dynsym < &Elf64_Sym((s1.dynsymtab_section.data + s1.dynsymtab_section.data_offset)) ; dynsym ++ {
							if (dynsym.st_value == esym.st_value) && (((u8((dynsym.st_info))) >> 4) == 1) {
								dynname := &i8(s1.dynsymtab_section.link.data) + dynsym.st_name
								put_elf_sym(s1.dynsym, offset, dynsym.st_size, dynsym.st_info, 0, bss_section.sh_num, dynname)
								break
								
							}
						}
					}
					put_elf_reloc(s1.dynsym, bss_section, offset, 5, index)
					offset += esym.st_size
					bss_section.data_offset = offset
				}
			}
			else {
				if ((u8((sym.st_info))) >> 4) == 2 || !C.strcmp(name, c'_fp_hw') {
				}
				else {
					tcc_error_noabort(c"undefined symbol '%s'", name)
				}
			}
		}
		else if s1.rdynamic && ((u8((sym.st_info))) >> 4) != 0 {
			name = &i8(symtab_section.link.data) + sym.st_name
			set_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info, 0, sym.st_shndx, name)
		}
	}
}

fn bind_libs_dynsyms(s1 &TCCState)  {
	name := &i8(0)
	sym_index := 0
	sym := &Elf64_Sym(0)
	esym := &Elf64_Sym(0)
	
	for esym = &Elf64_Sym(s1.dynsymtab_section.data) + 1 ; esym < &Elf64_Sym((s1.dynsymtab_section.data + s1.dynsymtab_section.data_offset)) ; esym ++ {
		name = &i8(s1.dynsymtab_section.link.data) + esym.st_name
		sym_index = find_elf_sym(symtab_section, name)
		sym = &(&Elf64_Sym(symtab_section.data)) [sym_index] 
		if sym_index && sym.st_shndx != 0 && ((u8((sym.st_info))) >> 4) != 0 {
			set_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info, 0, sym.st_shndx, name)
		}
		else if esym.st_shndx == 0 {
			if ((u8((esym.st_info))) >> 4) != 2 {
			tcc_warning(c"undefined dynamic symbol '%s'", name)
			}
		}
	}
}

fn export_global_syms(s1 &TCCState)  {
	dynindex := 0
	index := 0
	
	name := &i8(0)
	sym := &Elf64_Sym(0)
	for sym = &Elf64_Sym(symtab_section.data) + 1 ; sym < &Elf64_Sym((symtab_section.data + symtab_section.data_offset)) ; sym ++ {
		if ((u8((sym.st_info))) >> 4) != 0 {
			name = &i8(symtab_section.link.data) + sym.st_name
			dynindex = put_elf_sym(s1.dynsym, sym.st_value, sym.st_size, sym.st_info, 0, sym.st_shndx, name)
			index = sym - &Elf64_Sym(symtab_section.data)
			get_sym_attr(s1, index, 1).dyn_index = dynindex
		}
	}
}

fn alloc_sec_names(s1 &TCCState, file_type int, strsec &Section) int {
	i := 0
	s := &Section(0)
	textrel := 0
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if file_type == 3 && s.sh_type == 4 && !(s.sh_flags & (1 << 1)) && (s1.sections [s.sh_info] .sh_flags & (1 << 1)) && prepare_dynamic_rel(s1, s) {
			if s1.sections [s.sh_info] .sh_flags & (1 << 2) {
			textrel = 1
			}
		}
		else if (s1.do_debug && s.sh_type != 4) || file_type == 4 || (s.sh_flags & (1 << 1)) || i == (s1.nb_sections - 1) {
			s.sh_size = s.data_offset
		}
		if s.sh_size || (s.sh_flags & (1 << 1)) {
		s.sh_name = put_elf_str(strsec, s.name)
		}
	}
	strsec.sh_size = strsec.data_offset
	return textrel
}

struct Dyn_inf { 
	dynamic &Section
	dynstr &Section
	data_offset u32
	rel_addr Elf64_Addr
	rel_size Elf64_Addr
}
fn layout_sections(s1 &TCCState, phdr &Elf64_Phdr, phnum int, interp &Section, strsec &Section, dyninf &Dyn_inf, sec_order &int) int {
	i := 0
	j := 0
	k := 0
	file_type := 0
	sh_order_index := 0
	file_offset := 0
	
	s_align := u32(0)
	tmp := i64(0)
	addr := Elf64_Addr{}
	ph := &Elf64_Phdr(0)
	s := &Section(0)
	file_type = s1.output_type
	sh_order_index = 1
	file_offset = 0
	if s1.output_format == 0 {
	file_offset = sizeof(Elf64_Ehdr) + phnum * sizeof(Elf64_Phdr)
	}
	s_align = 2097152
	if s1.section_align {
	s_align = s1.section_align
	}
	if phnum > 0 {
		if s1.has_text_addr {
			a_offset := 0
			p_offset := 0
			
			addr = s1.text_addr
			a_offset = int((addr & (s_align - 1)))
			p_offset = file_offset & (s_align - 1)
			if a_offset < p_offset {
			a_offset += s_align
			}
			file_offset += (a_offset - p_offset)
		}
		else {
			if file_type == 3 {
			addr = 0
			}
			else { // 3
			addr = 4194304
}
			addr += (file_offset & (s_align - 1))
		}
		ph = &phdr [0] 
		if interp {
		ph += 2
		}
		dyninf.rel_addr = 0
		dyninf.rel_size = dyninf.rel_addr
		for j = 0 ; j < 2 ; j ++ {
			ph.p_type = 1
			if j == 0 {
			ph.p_flags = (1 << 2) | (1 << 0)
			}
			else { // 3
			ph.p_flags = (1 << 2) | (1 << 1)
}
			ph.p_align = s_align
			for k = 0 ; k < 5 ; k ++ {
				for i = 1 ; i < s1.nb_sections ; i ++ {
					s = s1.sections [i] 
					if j == 0 {
						if (s.sh_flags & ((1 << 1) | (1 << 0))) != (1 << 1) {
						continue
						
						}
					}
					else {
						if (s.sh_flags & ((1 << 1) | (1 << 0))) != ((1 << 1) | (1 << 0)) {
						continue
						
						}
					}
					if s == interp {
						if k != 0 {
						continue
						
						}
					}
					else if s.sh_type == 11 || s.sh_type == 3 || s.sh_type == 5 {
						if k != 1 {
						continue
						
						}
					}
					else if s.sh_type == 4 {
						if k != 2 {
						continue
						
						}
					}
					else if s.sh_type == 8 {
						if k != 4 {
						continue
						
						}
					}
					else {
						if k != 3 {
						continue
						
						}
					}
					sec_order [sh_order_index ++]  = i
					tmp = addr
					addr = (addr + s.sh_addralign - 1) & ~(s.sh_addralign - 1)
					file_offset += int((addr - tmp))
					s.sh_offset = file_offset
					s.sh_addr = addr
					if ph.p_offset == 0 {
						ph.p_offset = file_offset
						ph.p_vaddr = addr
						ph.p_paddr = ph.p_vaddr
					}
					if s.sh_type == 4 {
						if dyninf.rel_size == 0 {
						dyninf.rel_addr = addr
						}
						dyninf.rel_size += s.sh_size
					}
					addr += s.sh_size
					if s.sh_type != 8 {
					file_offset += s.sh_size
					}
				}
			}
			if j == 0 {
				ph.p_offset &= ~(ph.p_align - 1)
				ph.p_vaddr &= ~(ph.p_align - 1)
				ph.p_paddr &= ~(ph.p_align - 1)
			}
			ph.p_filesz = file_offset - ph.p_offset
			ph.p_memsz = addr - ph.p_vaddr
			ph ++
			if j == 0 {
				if s1.output_format == 0 {
					if (addr & (s_align - 1)) != 0 {
					addr += s_align
					}
				}
				else {
					addr = (addr + s_align - 1) & ~(s_align - 1)
					file_offset = (file_offset + s_align - 1) & ~(s_align - 1)
				}
			}
		}
	}
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if phnum > 0 && (s.sh_flags & (1 << 1)) {
		continue
		
		}
		sec_order [sh_order_index ++]  = i
		file_offset = (file_offset + s.sh_addralign - 1) & ~(s.sh_addralign - 1)
		s.sh_offset = file_offset
		if s.sh_type != 8 {
		file_offset += s.sh_size
		}
	}
	return file_offset
}

fn fill_unloadable_phdr(phdr &Elf64_Phdr, phnum int, interp &Section, dynamic &Section)  {
	ph := &Elf64_Phdr(0)
	if interp {
		ph = &phdr [0] 
		ph.p_type = 6
		ph.p_offset = sizeof(Elf64_Ehdr)
		ph.p_filesz = phnum * sizeof(Elf64_Phdr)
		ph.p_memsz = ph.p_filesz
		ph.p_vaddr = interp.sh_addr - ph.p_filesz
		ph.p_paddr = ph.p_vaddr
		ph.p_flags = (1 << 2) | (1 << 0)
		ph.p_align = 4
		ph ++
		ph.p_type = 3
		ph.p_offset = interp.sh_offset
		ph.p_vaddr = interp.sh_addr
		ph.p_paddr = ph.p_vaddr
		ph.p_filesz = interp.sh_size
		ph.p_memsz = interp.sh_size
		ph.p_flags = (1 << 2)
		ph.p_align = interp.sh_addralign
	}
	if dynamic {
		ph = &phdr [phnum - 1] 
		ph.p_type = 2
		ph.p_offset = dynamic.sh_offset
		ph.p_vaddr = dynamic.sh_addr
		ph.p_paddr = ph.p_vaddr
		ph.p_filesz = dynamic.sh_size
		ph.p_memsz = dynamic.sh_size
		ph.p_flags = (1 << 2) | (1 << 1)
		ph.p_align = dynamic.sh_addralign
	}
}

fn fill_dynamic(s1 &TCCState, dyninf &Dyn_inf)  {
	dynamic := dyninf.dynamic
	put_dt(dynamic, 4, s1.dynsym.hash.sh_addr)
	put_dt(dynamic, 5, dyninf.dynstr.sh_addr)
	put_dt(dynamic, 6, s1.dynsym.sh_addr)
	put_dt(dynamic, 10, dyninf.dynstr.data_offset)
	put_dt(dynamic, 11, sizeof(Elf64_Sym))
	put_dt(dynamic, 7, dyninf.rel_addr)
	put_dt(dynamic, 8, dyninf.rel_size)
	put_dt(dynamic, 9, sizeof(Elf64_Rela))
	if s1.do_debug {
	put_dt(dynamic, 21, 0)
	}
	put_dt(dynamic, 0, 0)
}

fn final_sections_reloc(s1 &TCCState) int {
	i := 0
	s := &Section(0)
	relocate_syms(s1, s1.symtab, 0)
	if s1.nb_errors != 0 {
	return -1
	}
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if s.reloc && (s != s1.got || s1.static_link) {
		relocate_section(s1, s)
		}
	}
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [i] 
		if (s.sh_flags & (1 << 1)) && s.sh_type == 4 {
			relocate_rel(s1, s)
		}
	}
	return 0
}

fn tcc_output_elf(s1 &TCCState, f &C.FILE, phnum int, phdr &Elf64_Phdr, file_offset int, sec_order &int)  {
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
	}
	file_offset = (file_offset + 3) & -4
	ehdr.e_ident [0]  = 127
	ehdr.e_ident [1]  = `E`
	ehdr.e_ident [2]  = `L`
	ehdr.e_ident [3]  = `F`
	ehdr.e_ident [4]  = 2
	ehdr.e_ident [5]  = 1
	ehdr.e_ident [6]  = 1
	match file_type {
	ehdr.e_entry = get_elf_sym_addr(s1, c'_start', 1)
	
	 3{ // case comp body kind=BinaryOperator is_enum=false
	ehdr.e_type = 3
	ehdr.e_entry = text_section.sh_addr
	
	}
	 4{ // case comp body kind=BinaryOperator is_enum=false
	ehdr.e_type = 1
	
	 2{ // case comp body kind=BinaryOperator is_enum=false
	ehdr.e_type = 2
	}
	else {
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
	C.fwrite(phdr, 1, phnum * sizeof(Elf64_Phdr), f)
	offset = sizeof(Elf64_Ehdr) + phnum * sizeof(Elf64_Phdr)
	sort_syms(s1, symtab_section)
	for i = 1 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [sec_order [i] ] 
		if s.sh_type != 8 {
			for offset < s.sh_offset {
				fputc(0, f)
				offset ++
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
		offset ++
	}
	for i = 0 ; i < s1.nb_sections ; i ++ {
		sh = &shdr
		C.memset(sh, 0, sizeof(Elf64_Shdr))
		s = s1.sections [i] 
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
}

fn tcc_write_elf_file(s1 &TCCState, filename &i8, phnum int, phdr &Elf64_Phdr, file_offset int, sec_order &int) int {
	fd := 0
	mode := 0
	file_type := 0
	
	f := &C.FILE(0)
	file_type = s1.output_type
	if file_type == 4 {
	mode = 438
	}
	else { // 3
	mode = 511
}
	unlink(filename)
	fd = C.open(filename, 1 | 64 | 512 | 0, mode)
	if fd < 0 {
		tcc_error_noabort(c"could not write '%s'", filename)
		return -1
	}
	f = fdopen(fd, c'wb')
	if s1.verbose {
	C.printf(c'<- %s\n', filename)
	}
	if s1.output_format == 0 {
	tcc_output_elf(s1, f, phnum, phdr, file_offset, sec_order)
	}
	else { // 3
	tcc_output_binary(s1, f, sec_order)
}
	C.fclose(f)
	return 0
}

fn tidy_section_headers(s1 &TCCState, sec_order &int)  {
	i := 0
	nnew := 0
	l := 0
	backmap := &int(0)
	
	snew := &&Section(0)
	s := &Section(0)
	
	sym := &Elf64_Sym(0)
	snew = tcc_malloc(s1.nb_sections * sizeof(snew [0] ))
	backmap = tcc_malloc(s1.nb_sections * sizeof(backmap [0] ))
	for i = 0 , 0
	nnew = i = 0 , s1.nb_sections
	l = i = 0 , 0
	nnew = i = 0 ; i < s1.nb_sections ; i ++ {
		s = s1.sections [sec_order [i] ] 
		if !i || s.sh_name {
			backmap [sec_order [i] ]  = nnew
			snew [nnew]  = s
			nnew ++$
		}
		else {
			backmap [sec_order [i] ]  = 0
			snew [l --$]  = s
		}
	}
	for i = 0 ; i < nnew ; i ++ {
		s = snew [i] 
		if s {
			s.sh_num = i
			if s.sh_type == 4 {
			s.sh_info = backmap [s.sh_info] 
			}
		}
	}
	for sym = &Elf64_Sym(symtab_section.data) + 1 ; sym < &Elf64_Sym((symtab_section.data + symtab_section.data_offset)) ; sym ++ {
	if sym.st_shndx != 0 && sym.st_shndx < 65280 {
	sym.st_shndx = backmap [sym.st_shndx] 
	}
	}
	if !s1.static_link {
		for sym = &Elf64_Sym(s1.dynsym.data) + 1 ; sym < &Elf64_Sym((s1.dynsym.data + s1.dynsym.data_offset)) ; sym ++ {
		if sym.st_shndx != 0 && sym.st_shndx < 65280 {
		sym.st_shndx = backmap [sym.st_shndx] 
		}
		}
	}
	for i = 0 ; i < s1.nb_sections ; i ++ {
	sec_order [i]  = i
	}
	tcc_free(s1.sections)
	s1.sections = snew
	s1.nb_sections = nnew
	tcc_free(backmap)
}

fn elf_output_file(s1 &TCCState, filename &i8) int {
	i := 0
	ret := 0
	phnum := 0
	shnum := 0
	file_type := 0
	file_offset := 0
	sec_order := &int(0)
	
	dyninf := Dyn_inf {
	dynamic: 0, 
}
	
	phdr := &Elf64_Phdr(0)
	sym := &Elf64_Sym(0)
	strsec := &Section(0)
	interp := &Section(0)
	dynamic := &Section(0)
	dynstr := &Section(0)
	
	textrel := 0
	file_type = s1.output_type
	s1.nb_errors = 0
	ret = -1
	phdr = (voidptr(0))
	sec_order = (voidptr(0))
	interp = dynstr = (voidptr(0))
	dynamic = interp
	textrel = 0
	if file_type != 4 {
		tcc_add_runtime(s1)
		resolve_common_syms(s1)
		if !s1.static_link {
			if file_type == 2 {
				ptr := &i8(0)
				elfint := getenv(c'LD_SO')
				if elfint == (voidptr(0)) {
				elfint = c'/lib64/ld-linux-x86-64.so.2'
				}
				interp = new_section(s1, c'.interp', 1, (1 << 1))
				interp.sh_addralign = 1
				ptr = section_ptr_add(interp, 1 + C.strlen(elfint))
				strcpy(ptr, elfint)
			}
			s1.dynsym = new_symtab(s1, c'.dynsym', 11, (1 << 1), c'.dynstr', c'.hash', (1 << 1))
			dynstr = s1.dynsym.link
			dynamic = new_section(s1, c'.dynamic', 6, (1 << 1) | (1 << 0))
			dynamic.link = dynstr
			dynamic.sh_entsize = sizeof(Elf64_Dyn)
			build_got(s1)
			if file_type == 2 {
				bind_exe_dynsyms(s1)
				if s1.nb_errors {
				goto _GOTO_PLACEHOLDER_0x7fffc6220e88 // id: 0x7fffc6220e88
				}
				bind_libs_dynsyms(s1)
			}
			else {
				export_global_syms(s1)
			}
		}
		build_got_entries(s1)
	}
	strsec = new_section(s1, c'.shstrtab', 3, 0)
	put_elf_str(strsec, c'')
	textrel = alloc_sec_names(s1, file_type, strsec)
	if dynamic {
		for i = 0 ; i < s1.nb_loaded_dlls ; i ++ {
			dllref := s1.loaded_dlls [i] 
			if dllref.level == 0 {
			put_dt(dynamic, 1, put_elf_str(dynstr, dllref.name))
			}
		}
		if s1.rpath {
		put_dt(dynamic, if s1.enable_new_dtags{ 29 } else {15}, put_elf_str(dynstr, s1.rpath))
		}
		if file_type == 3 {
			if s1.soname {
			put_dt(dynamic, 14, put_elf_str(dynstr, s1.soname))
			}
			if textrel {
			put_dt(dynamic, 22, 0)
			}
		}
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
	if file_type == 4 {
	phnum = 0
	}
	else if file_type == 3 {
	phnum = 3
	}
	else if s1.static_link {
	phnum = 2
	}
	else { // 3
	phnum = 5
}
	phdr = tcc_mallocz(phnum * sizeof(Elf64_Phdr))
	shnum = s1.nb_sections
	sec_order = tcc_malloc(sizeof(int) * shnum)
	sec_order [0]  = 0
	file_offset = layout_sections(s1, phdr, phnum, interp, strsec, &dyninf, sec_order)
	if file_type != 4 {
		fill_unloadable_phdr(phdr, phnum, interp, dynamic)
		if dynamic {
			dynamic.data_offset = dyninf.data_offset
			fill_dynamic(s1, &dyninf)
			write32le(s1.got.data, dynamic.sh_addr)
			if file_type == 2 || (1 && file_type == 3) {
			relocate_plt(s1)
			}
			for sym = &Elf64_Sym(s1.dynsym.data) + 1 ; sym < &Elf64_Sym((s1.dynsym.data + s1.dynsym.data_offset)) ; sym ++ {
				if sym.st_shndx != 0 && sym.st_shndx < 65280 {
					sym.st_value += s1.sections [sym.st_shndx] .sh_addr
				}
			}
		}
		ret = final_sections_reloc(s1)
		if ret {
		goto _GOTO_PLACEHOLDER_0x7fffc6220e88 // id: 0x7fffc6220e88
		}
		tidy_section_headers(s1, sec_order)
		if file_type == 2 && s1.static_link {
		fill_got(s1)
		}
		else if s1.got {
		fill_local_got_entries(s1)
		}
	}
	ret = tcc_write_elf_file(s1, filename, phnum, phdr, file_offset, sec_order)
	s1.nb_sections = shnum
	// RRRREG the_end id=0x7fffc6220e88
	the_end: 
	tcc_free(sec_order)
	tcc_free(phdr)
	return ret
}

fn tcc_output_file(s &TCCState, filename &i8) int {
	ret := 0
	ret = elf_output_file(s, filename)
	return ret
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
}

fn load_data(fd int, file_offset u32, size u32) voidptr {
	data := &voidptr(0)
	data = tcc_malloc(size)
	C.lseek(fd, file_offset, 0)
	full_read(fd, data, size)
	return data
}

struct SectionMergeInfo { 
	s &Section
	offset u32
	new_section u8
	link_once u8
}
fn tcc_object_type(fd int, h &Elf64_Ehdr) int {
	size := full_read(fd, h, sizeof*h)
	if size == sizeof*h && 0 == C.memcmp(h, c'\177ELF', 4) {
		if h.e_type == 1 {
		return 1
		}
		if h.e_type == 3 {
		return 2
		}
	}
	else if size >= 8 {
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
	
	size := 0
	i := 0
	j := 0
	offset := 0
	offseti := 0
	nb_syms := 0
	sym_index := 0
	ret := 0
	seencompressed := 0
	
	strsec := &i8(0)
	strtab := &i8(0)
	
	old_to_new_syms := &int(0)
	sh_name := &i8(0)
	name := &i8(0)
	
	sm_table := &SectionMergeInfo(0)
	sm := &SectionMergeInfo(0)
	
	sym := &Elf64_Sym(0)
	symtab := &Elf64_Sym(0)
	
	rel := &Elf64_Rela(0)
	s := &Section(0)
	stab_index := 0
	stabstr_index := 0
	stab_index = 0
	stabstr_index = stab_index
	C.lseek(fd, file_offset, 0)
	if tcc_object_type(fd, &ehdr) != 1 {
	goto fail1 // id: 0x7fffc622af38
	}
	if ehdr.e_ident [5]  != 1 || ehdr.e_machine != 62 {
		// RRRREG fail1 id=0x7fffc622af38
		fail1: 
		tcc_error_noabort(c'invalid object file')
		return -1
	}
	shdr = load_data(fd, file_offset + ehdr.e_shoff, sizeof(Elf64_Shdr) * ehdr.e_shnum)
	sm_table = tcc_mallocz(sizeof(SectionMergeInfo) * ehdr.e_shnum)
	sh = &shdr [ehdr.e_shstrndx] 
	strsec = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
	old_to_new_syms = (voidptr(0))
	symtab = (voidptr(0))
	strtab = (voidptr(0))
	nb_syms = 0
	seencompressed = 0
	for i = 1 ; i < ehdr.e_shnum ; i ++ {
		sh = &shdr [i] 
		if sh.sh_type == 2 {
			if symtab {
				tcc_error_noabort(c'object must contain only one symtab')
				// RRRREG fail id=0x7fffc622c300
				fail: 
				ret = -1
				goto _GOTO_PLACEHOLDER_0x7fffc622c370 // id: 0x7fffc622c370
			}
			nb_syms = sh.sh_size / sizeof(Elf64_Sym)
			symtab = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
			sm_table [i] .s = symtab_section
			sh = &shdr [sh.sh_link] 
			strtab = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
		}
		if sh.sh_flags & (1 << 11) {
		seencompressed = 1
		}
	}
	for i = 1 ; i < ehdr.e_shnum ; i ++ {
		if i == ehdr.e_shstrndx {
		continue
		
		}
		sh = &shdr [i] 
		if sh.sh_type == 4 {
		sh = &shdr [sh.sh_info] 
		}
		if sh.sh_type != 1 && sh.sh_type != 8 && sh.sh_type != 16 && sh.sh_type != 14 && sh.sh_type != 15 && C.strcmp(strsec + sh.sh_name, c'.stabstr') {
		continue
		
		}
		if seencompressed && !C.strncmp(strsec + sh.sh_name, c'.debug_', sizeof(c'.debug_') - 1) {
		continue
		
		}
		sh = &shdr [i] 
		sh_name = strsec + sh.sh_name
		if sh.sh_addralign < 1 {
		sh.sh_addralign = 1
		}
		for j = 1 ; j < s1.nb_sections ; j ++ {
			s = s1.sections [j] 
			if !C.strcmp(s.name, sh_name) {
				if !C.strncmp(sh_name, c'.gnu.linkonce', sizeof(c'.gnu.linkonce') - 1) {
					sm_table [i] .link_once = 1
					goto next // id: 0x7fffc622edd0
				}
				else {
					goto found // id: 0x7fffc622ee58
				}
			}
		}
		s = new_section(s1, sh_name, sh.sh_type, sh.sh_flags & ~(1 << 9))
		s.sh_addralign = sh.sh_addralign
		s.sh_entsize = sh.sh_entsize
		sm_table [i] .new_section = 1
		// RRRREG found id=0x7fffc622ee58
		found: 
		if sh.sh_type != s.sh_type {
			tcc_error_noabort(c'invalid section type')
			goto _GOTO_PLACEHOLDER_0x7fffc622c300 // id: 0x7fffc622c300
		}
		offset = s.data_offset
		if 0 == C.strcmp(sh_name, c'.stab') {
			stab_index = i
			goto no_align // id: 0x7fffc622fb68
		}
		if 0 == C.strcmp(sh_name, c'.stabstr') {
			stabstr_index = i
			goto no_align // id: 0x7fffc622fb68
		}
		size = sh.sh_addralign - 1
		offset = (offset + size) & ~size
		if sh.sh_addralign > s.sh_addralign {
		s.sh_addralign = sh.sh_addralign
		}
		s.data_offset = offset
		// RRRREG no_align id=0x7fffc622fb68
		no_align: 
		sm_table [i] .offset = offset
		sm_table [i] .s = s
		size = sh.sh_size
		if sh.sh_type != 8 {
			ptr := &u8(0)
			C.lseek(fd, file_offset + sh.sh_offset, 0)
			ptr = section_ptr_add(s, size)
			full_read(fd, ptr, size)
		}
		else {
			s.data_offset += size
		}
		// RRRREG next id=0x7fffc622edd0
		next: 
		0
	}
	if stab_index && stabstr_index {
		a := &Stab_Sym(0)
		b := &Stab_Sym(0)
		
		o := u32(0)
		s = sm_table [stab_index] .s
		a = &Stab_Sym((s.data + sm_table [stab_index] .offset))
		b = &Stab_Sym((s.data + s.data_offset))
		o = sm_table [stabstr_index] .offset
		for a < b {
			if a.n_strx {
			a.n_strx += o
			}
			a ++
		}
	}
	for i = 1 ; i < ehdr.e_shnum ; i ++ {
		s = sm_table [i] .s
		if !s || !sm_table [i] .new_section {
		continue
		
		}
		sh = &shdr [i] 
		if sh.sh_link > 0 {
		s.link = sm_table [sh.sh_link] .s
		}
		if sh.sh_type == 4 {
			s.sh_info = sm_table [sh.sh_info] .s.sh_num
			s1.sections [s.sh_info] .reloc = s
		}
	}
	sm = sm_table
	old_to_new_syms = tcc_mallocz(nb_syms * sizeof(int))
	sym = symtab + 1
	for i = 1 ; i < nb_syms ; i ++ , sym ++ {
		if sym.st_shndx != 0 && sym.st_shndx < 65280 {
			sm = &sm_table [sym.st_shndx] 
			if sm.link_once {
				if ((u8((sym.st_info))) >> 4) != 0 {
					name = strtab + sym.st_name
					sym_index = find_elf_sym(symtab_section, name)
					if sym_index {
					old_to_new_syms [i]  = sym_index
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
		sym_index = set_elf_sym(symtab_section, sym.st_value, sym.st_size, sym.st_info, sym.st_other, sym.st_shndx, name)
		old_to_new_syms [i]  = sym_index
	}
	for i = 1 ; i < ehdr.e_shnum ; i ++ {
		s = sm_table [i] .s
		if !s {
		continue
		
		}
		sh = &shdr [i] 
		offset = sm_table [i] .offset
		match s.sh_type {
		 4{ // case comp body kind=BinaryOperator is_enum=false
		offseti = sm_table [sh.sh_info] .offset
		for rel = &Elf64_Rela(s.data) + (offset / sizeof(*rel)) ; rel < &Elf64_Rela((s.data + s.data_offset)) ; rel ++ {
			type_ := 0
			sym_index := u32(0)
			type_ = ((rel.r_info) & 4294967295)
			sym_index = ((rel.r_info) >> 32)
			if sym_index >= nb_syms {
			goto invalid_reloc // id: 0x7fffc6235a38
			}
			sym_index = old_to_new_syms [sym_index] 
			if !sym_index && !sm.link_once {
				// RRRREG invalid_reloc id=0x7fffc6235a38
				invalid_reloc: 
				tcc_error_noabort(c"Invalid relocation entry [%2d] '%s' @ %.8x", i, strsec + sh.sh_name, rel.r_offset)
				goto _GOTO_PLACEHOLDER_0x7fffc622c300 // id: 0x7fffc622c300
			}
			rel.r_info = (((Elf64_Xword((sym_index))) << 32) + (type_))
			rel.r_offset += offseti
		}
		
		}
		else {
		
		}
		}
	}
	ret = 0
	// RRRREG the_end id=0x7fffc622c370
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
	ar_uid [6]i8
	ar_gid [6]i8
	ar_mode [8]i8
	ar_size [10]i8
	ar_fmag [2]i8
}
fn get_be32(b &u8) int {
	return b [3]  | (b [2]  << 8) | (b [1]  << 16) | (b [0]  << 24)
}

fn get_be64(b &u8) int {
	ret := get_be32(b)
	ret = (ret << 32) | u32(get_be32(b + 4))
	return int(ret)
}

fn tcc_load_alacarte(s1 &TCCState, fd int, size int, entrysize int) int {
	i := 0
	bound := 0
	nsyms := 0
	sym_index := 0
	off := 0
	ret := 0
	
	data := &u8(0)
	ar_names := &i8(0)
	p := &i8(0)
	
	ar_index := &u8(0)
	sym := &Elf64_Sym(0)
	data = tcc_malloc(size)
	if full_read(fd, data, size) != size {
	goto fail // id: 0x7fffc6238c70
	}
	nsyms = if entrysize == 4{ get_be32(data) } else {get_be64(data)}
	ar_index = data + entrysize
	ar_names = &i8(ar_index) + nsyms * entrysize
	for {
	bound = 0
	for p = ar_names , 0
	i = p = ar_names ; i < nsyms ; i ++ , p += C.strlen(p) + 1 {
		sym_index = find_elf_sym(symtab_section, p)
		if sym_index {
			sym = &(&Elf64_Sym(symtab_section.data)) [sym_index] 
			if sym.st_shndx == 0 {
				off = (if entrysize == 4{ get_be32(ar_index + i * 4) } else {get_be64(ar_index + i * 8)}) + sizeof(ArchiveHeader)
				bound ++$
				if tcc_load_object_file(s1, fd, off) < 0 {
					// RRRREG fail id=0x7fffc6238c70
					fail: 
					ret = -1
					goto _GOTO_PLACEHOLDER_0x7fffc623a198 // id: 0x7fffc623a198
				}
			}
		}
	}
	// while()
	if ! (bound ) { break }
	}
	ret = 0
	// RRRREG the_end id=0x7fffc623a198
	the_end: 
	tcc_free(data)
	return ret
}

fn tcc_load_archive(s1 &TCCState, fd int, alacarte int) int {
	hdr := ArchiveHeader{}
	ar_size := [11]i8{}
	ar_name := [17]i8{}
	magic := [8]i8{}
	size := 0
	len := 0
	i := 0
	
	file_offset := u32(0)
	full_read(fd, magic, sizeof(magic))
	for  ;  ;  {
		len = full_read(fd, &hdr, sizeof(hdr))
		if len == 0 {
		break
		
		}
		if len != sizeof(hdr) {
			tcc_error_noabort(c'invalid archive')
			return -1
		}
		C.memcpy(ar_size, hdr.ar_size, sizeof(hdr.ar_size))
		ar_size [sizeof(hdr.ar_size)]  = ` `
		size = strtol(ar_size, (voidptr(0)), 0)
		C.memcpy(ar_name, hdr.ar_name, sizeof(hdr.ar_name))
		for i = sizeof(hdr.ar_name) - 1 ; i >= 0 ; i -- {
			if ar_name [i]  != ` ` {
			break
			
			}
		}
		ar_name [i + 1]  = ` `
		file_offset = C.lseek(fd, 0, 1)
		size = (size + 1) & ~1
		if !C.strcmp(ar_name, c'/') {
			if alacarte {
			return tcc_load_alacarte(s1, fd, size, 4)
			}
		}
		else if !C.strcmp(ar_name, c'/SYM64/') {
			if alacarte {
			return tcc_load_alacarte(s1, fd, size, 8)
			}
		}
		else {
			ehdr := Elf64_Ehdr{}
			if tcc_object_type(fd, &ehdr) == 1 {
				if tcc_load_object_file(s1, fd, file_offset) < 0 {
				return -1
				}
			}
		}
		C.lseek(fd, file_offset + size, 0)
	}
	return 0
}

fn tcc_load_dll(s1 &TCCState, fd int, filename &i8, level int) int {
	ehdr := Elf64_Ehdr{}
	shdr := &Elf64_Shdr(0)
	sh := &Elf64_Shdr(0)
	sh1 := &Elf64_Shdr(0)
	
	i := 0
	j := 0
	nb_syms := 0
	nb_dts := 0
	sym_bind := 0
	ret := 0
	
	sym := &Elf64_Sym(0)
	dynsym := &Elf64_Sym(0)
	
	dt := &Elf64_Dyn(0)
	dynamic := &Elf64_Dyn(0)
	
	dynstr := &u8(0)
	name := &i8(0)
	soname := &i8(0)
	
	dllref := &DLLReference(0)
	full_read(fd, &ehdr, sizeof(ehdr))
	if ehdr.e_ident [5]  != 1 || ehdr.e_machine != 62 {
		tcc_error_noabort(c'bad architecture')
		return -1
	}
	shdr = load_data(fd, ehdr.e_shoff, sizeof(Elf64_Shdr) * ehdr.e_shnum)
	nb_syms = 0
	nb_dts = 0
	dynamic = (voidptr(0))
	dynsym = (voidptr(0))
	dynstr = (voidptr(0))
	for i = 0 , shdr
	sh = i = 0 ; i < ehdr.e_shnum ; i ++ , sh ++ {
		match sh.sh_type {
		 6{ // case comp body kind=BinaryOperator is_enum=true
		nb_dts = sh.sh_size / sizeof(Elf64_Dyn)
		dynamic = load_data(fd, sh.sh_offset, sh.sh_size)
		
		}
		 11{ // case comp body kind=BinaryOperator is_enum=true
		nb_syms = sh.sh_size / sizeof(Elf64_Sym)
		dynsym = load_data(fd, sh.sh_offset, sh.sh_size)
		sh1 = &shdr [sh.sh_link] 
		dynstr = load_data(fd, sh1.sh_offset, sh1.sh_size)
		
		}
		else {
		
		}
		}
	}
	soname = tcc_basename(filename)
	for i = 0 , dynamic
	dt = i = 0 ; i < nb_dts ; i ++ , dt ++ {
		if dt.d_tag == 14 {
			soname = &i8(dynstr) + dt.d_un.d_val
		}
	}
	for i = 0 ; i < s1.nb_loaded_dlls ; i ++ {
		dllref = s1.loaded_dlls [i] 
		if !C.strcmp(soname, dllref.name) {
			if level < dllref.level {
			dllref.level = level
			}
			ret = 0
			goto the_end // id: 0x7fffc624b310
		}
	}
	dllref = tcc_mallocz(sizeof(DLLReference) + C.strlen(soname))
	dllref.level = level
	strcpy(dllref.name, soname)
	dynarray_add(&s1.loaded_dlls, &s1.nb_loaded_dlls, dllref)
	for i = 1 , dynsym + 1
	sym = i = 1 ; i < nb_syms ; i ++ , sym ++ {
		sym_bind = ((u8((sym.st_info))) >> 4)
		if sym_bind == 0 {
		continue
		
		}
		name = &i8(dynstr) + sym.st_name
		set_elf_sym(s1.dynsymtab_section, sym.st_value, sym.st_size, sym.st_info, sym.st_other, sym.st_shndx, name)
	}
	for i = 0 , dynamic
	dt = i = 0 ; i < nb_dts ; i ++ , dt ++ {
		match dt.d_tag {
		 1{ // case comp body kind=BinaryOperator is_enum=true
		name = &i8(dynstr) + dt.d_un.d_val
		for j = 0 ; j < s1.nb_loaded_dlls ; j ++ {
			dllref = s1.loaded_dlls [j] 
			if !C.strcmp(name, dllref.name) {
			goto already_loaded // id: 0x7fffc624cd68
			}
		}
		if tcc_add_dll(s1, name, 32) < 0 {
			tcc_error_noabort(c"referenced dll '%s' not found", name)
			ret = -1
			goto the_end // id: 0x7fffc624b310
		}
		// RRRREG already_loaded id=0x7fffc624cd68
		already_loaded: 
		
		}
		else{}
		}
	}
	ret = 0
	// RRRREG the_end id=0x7fffc624b310
	the_end: 
	tcc_free(dynstr)
	tcc_free(dynsym)
	tcc_free(dynamic)
	tcc_free(shdr)
	return ret
}

fn ld_next(s1 &TCCState, name &i8, name_size int) int {
	c := 0
	q := &i8(0)
	// RRRREG redo id=0x7fffc624de28
	redo: 
	match ch {
	 ` `, `	`, ``, ``, `
`, `\n`{
	inp()
	goto redo // id: 0x7fffc624de28
	}
	 `/`{ // case comp body kind=CallExpr is_enum=false
	minp()
	if ch == `*` {
		file.buf_ptr = parse_comment(file.buf_ptr)
		ch = file.buf_ptr [0] 
		goto redo // id: 0x7fffc624de28
	}
	else {
		q = name
		*q ++ = `/`
		goto parse_name // id: 0x7fffc624e3f8
	}
	
	}
	 `\\`{ // case comp body kind=BinaryOperator is_enum=false
	ch = handle_eob()
	if ch != `\\` {
	goto redo // id: 0x7fffc624de28
	}
	}
	 `a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `t`, `u`, `v`, `w`, `x`, `y`, `z`, `A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`, `I`, `J`, `K`, `L`, `M`, `N`, `O`, `P`, `Q`, `R`, `S`, `T`, `U`, `V`, `W`, `X`, `Y`, `Z`, `_`, `.`, `$`, `~`{
	q = name
	// RRRREG parse_name id=0x7fffc624e3f8
	parse_name: 
	for  ;  ;  {
		if !((ch >= `a` && ch <= `z`) || (ch >= `A` && ch <= `Z`) || (ch >= `0` && ch <= `9`) || C.strchr(c'/.-_+=$:\\,~', ch)) {
		
		}
		if (q - name) < name_size - 1 {
			*q ++ = ch
		}
		minp()
	}
	*q = ` `
	c = 256
	
	}
	 (-1){ // case comp body kind=BinaryOperator is_enum=false
	c = (-1)
	
	inp()
	
	}
	else {
	c = ch
	}
	}
	return c
}

fn ld_add_file(s1 &TCCState, filename &i8) int {
	if filename [0]  == `/` {
		if c'' [0]  == ` ` && tcc_add_file_internal(s1, filename, 64) == 0 {
		return 0
		}
		filename = tcc_basename(filename)
	}
	return tcc_add_dll(s1, filename, 0)
}

fn new_undef_syms() int {
	ret := 0
	ret = new_undef_sym
	new_undef_sym = 0
	return ret
}

fn ld_add_file_list(s1 &TCCState, cmd &i8, as_needed int) int {
	filename := [1024]i8{}
	libname := [1024]i8{}
	
	t := 0
	group := 0
	nblibs := 0
ret := 0

	libs := (voidptr(0))
	group = !C.strcmp(cmd, c'GROUP')
	if !as_needed {
	new_undef_syms()
	}
	t = ld_next(s1, filename, sizeof(filename))
	if t != `(` {
	expect(c'(')
	}
	t = ld_next(s1, filename, sizeof(filename))
	for  ;  ;  {
		libname [0]  = ` `
		if t == (-1) {
			tcc_error_noabort(c'unexpected end of file')
			ret = -1
			goto lib_parse_error // id: 0x7fffc6252560
		}
		else if t == `)` {
			break
			
		}
		else if t == `-` {
			t = ld_next(s1, filename, sizeof(filename))
			if (t != 256) || (filename [0]  != `l`) {
				tcc_error_noabort(c'library name expected')
				ret = -1
				goto lib_parse_error // id: 0x7fffc6252560
			}
			pstrcpy(libname, sizeof(libname), &filename [1] )
			if s1.static_link {
				C.snprintf(filename, sizeof(filename), c'lib%s.a', libname)
			}
			else {
				C.snprintf(filename, sizeof(filename), c'lib%s.so', libname)
			}
		}
		else if t != 256 {
			tcc_error_noabort(c'filename expected')
			ret = -1
			goto lib_parse_error // id: 0x7fffc6252560
		}
		if !C.strcmp(filename, c'AS_NEEDED') {
			ret = ld_add_file_list(s1, cmd, 1)
			if ret {
			goto lib_parse_error // id: 0x7fffc6252560
			}
		}
		else {
			if !as_needed {
				ret = ld_add_file(s1, filename)
				if ret {
				goto lib_parse_error // id: 0x7fffc6252560
				}
				if group {
					dynarray_add(&libs, &nblibs, tcc_strdup(filename))
					if libname [0]  != ` ` {
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
		for new_undef_syms() {
			i := 0
			for i = 0 ; i < nblibs ; i ++ {
			ld_add_file(s1, libs [i] )
			}
		}
	}
	// RRRREG lib_parse_error id=0x7fffc6252560
	lib_parse_error: 
	dynarray_reset(&libs, &nblibs)
	return ret
}

fn tcc_load_ldscript(s1 &TCCState) int {
	cmd := [64]i8{}
	filename := [1024]i8{}
	t := 0
	ret := 0
	
	ch = handle_eob()
	for  ;  ;  {
		t = ld_next(s1, cmd, sizeof(cmd))
		if t == (-1) {
		return 0
		}
		else if t != 256 {
		return -1
		}
		if !C.strcmp(cmd, c'INPUT') || !C.strcmp(cmd, c'GROUP') {
			ret = ld_add_file_list(s1, cmd, 0)
			if ret {
			return ret
			}
		}
		else if !C.strcmp(cmd, c'OUTPUT_FORMAT') || !C.strcmp(cmd, c'TARGET') {
			t = ld_next(s1, cmd, sizeof(cmd))
			if t != `(` {
			expect(c'(')
			}
			for  ;  ;  {
				t = ld_next(s1, filename, sizeof(filename))
				if t == (-1) {
					tcc_error_noabort(c'unexpected end of file')
					return -1
				}
				else if t == `)` {
					break
					
				}
			}
		}
		else {
			return -1
		}
	}
	return 0
}

