@[translated]
module main

pub const r_x86_64_64 = 1 // Direct 64 bit
pub const r_data_ptr = r_x86_64_64

fn code_reloc(reloc_type int) int {
	match reloc_type {
		10, 11, 1, 26, 29, 9, 41, 42, 22, 3, 27, 6, 5, 8, 25, 19, 20, 21, 23, 17, 18 {
			return 0
		}
		2, 24, 4, 31, 7 {
			return 1
		}
		else {}
	}
	return -1
}

fn gotplt_entry_type(reloc_type int) int {
	match reloc_type {
		6, 7, 5, 8 {
			return int(Gotplt_entry.no_gotplt_entry)
		}
		10, 11, 1, 2, 24 {
			return int(Gotplt_entry.auto_gotplt_entry)
		}
		22 { // case comp body kind=ReturnStmt is_enum=false
			return int(Gotplt_entry.build_got_only)
		}
		3, 27, 26, 29, 25, 9, 41, 19, 20, 21, 23, 17, 18, 42, 4, 31 {
			return int(Gotplt_entry.always_gotplt_entry)
		}
		else {}
	}
	return -1
}

fn create_plt_entry(s1 &TCCState, got_offset u32, attr &Sym_attr) u32 {
	plt := s1.plt
	p := &u8(0)
	modrm := 0
	plt_offset := u32(0)
	relofs := u32(0)

	modrm = 37
	if plt.data_offset == 0 {
		p = section_ptr_add(plt, 16)
		p[0] = 255
		p[1] = modrm + 16
		write32le(p + 2, 8)
		p[6] = 255
		p[7] = modrm
		write32le(p + 8, 8 * 2)
	}
	plt_offset = plt.data_offset
	relofs = if s1.plt.reloc { s1.plt.reloc.data_offset } else { 0 }
	p = section_ptr_add(plt, 16)
	p[0] = 255
	p[1] = modrm
	write32le(p + 2, got_offset)
	p[6] = 104
	write32le(p + 7, relofs / sizeof(Elf64_Rela) - 1)
	p[11] = 233
	write32le(p + 12, -(plt.data_offset))
	return plt_offset
}

fn relocate_plt(s1 &TCCState) {
	p := &u8(0)
	p_end := &u8(0)

	if !s1.plt {
		return
	}
	p = s1.plt.data
	p_end = p + s1.plt.data_offset
	if p < p_end {
		x := s1.got.sh_addr - s1.plt.sh_addr - 6
		add32le(p + 2, x)
		add32le(p + 8, x - 6)
		p += 16
		for p < p_end {
			t := x
			t += (s1.plt.data - p)
			add32le(p + 2, t)
			p += 16
		}
	}
	if s1.plt.reloc {
		rel := &Elf64_Rela(0)
		x := s1.plt.sh_addr + 16 + 6
		p = s1.got.data
		unsafe {
			for rel = &Elf64_Rela(s1.plt.reloc.data); voidptr(rel) < voidptr(&Elf64_Rela((
				s1.plt.reloc.data + s1.plt.reloc.data_offset))); rel++ {
				write64le(p + rel.r_offset, x)
				x += 16
			}
		}
	}
}

fn relocate(s1 &TCCState, rel &Elf64_Rela, type_ int, ptr &u8, addr Elf64_Addr, val Elf64_Addr) {
	sym_index := 0
	esym_index := 0

	sym_index = ((rel.r_info) >> 32)
	match type_ {
		1 { // case comp body kind=IfStmt is_enum=false
			if s1.output_type & 4 {
				esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
				s1.qrel.r_offset = rel.r_offset
				if esym_index {
					s1.qrel.r_info = (((Elf64_Xword(u64(esym_index))) << 32) + (1))
					$if i386 {
						s1.qrel.r_addend = rel.r_addend
					}
					unsafe { s1.qrel++ }
				} else {
					s1.qrel.r_info = (((Elf64_Xword((0))) << 32) + (8))
					$if i386 {
						s1.qrel.r_addend = read64le(ptr) + val
					}
					unsafe { s1.qrel++ }
				}
			}
			add64le(ptr, val)
		}
		10, 11 {
			if s1.output_type & 4 {
				s1.qrel.r_offset = rel.r_offset
				s1.qrel.r_info = (((Elf64_Xword((0))) << 32) + (8))
				$if i386 {
					s1.qrel.r_addend = int(read32le(ptr)) + val
				}
				unsafe { s1.qrel++ }
			}
			add32le(ptr, val)
		}
		2 { // case comp body kind=IfStmt is_enum=false
			if s1.output_type == 4 {
				esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
				if esym_index {
					s1.qrel.r_offset = rel.r_offset
					s1.qrel.r_info = (((Elf64_Xword(u64(esym_index))) << 32) + (2))
					$if i386 {
						s1.qrel.r_addend = int(read32le(ptr)) + rel.r_addend
					}
					unsafe { s1.qrel++ }
				}
			}
			goto plt32pc32 // id: 0x7fffcf338500
		}
		4 { // case comp body kind=LabelStmt is_enum=false
			// RRRREG plt32pc32 id=0x7fffcf338500
			plt32pc32:
			{
				diff := i64(0)
				diff = i64(val) - addr
				if diff < -2147483648 || diff > 2147483647 {
					_tcc_error_noabort(s1, 'internal error: relocation failed')
				}
				add32le(ptr, diff)
			}
		}
		5 { // case comp body kind=BreakStmt is_enum=false
		}
		31 { // case comp body kind=CallExpr is_enum=false
			add64le(ptr, val - s1.got.sh_addr + rel.r_addend)
		}
		24 { // case comp body kind=IfStmt is_enum=false
			if s1.output_type == 4 {
				esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
				if esym_index {
					s1.qrel.r_offset = rel.r_offset
					s1.qrel.r_info = (((Elf64_Xword(u64(esym_index))) << 32) + (24))
					$if i386 {
						s1.qrel.r_addend = read64le(ptr) + rel.r_addend
					}
					unsafe { s1.qrel++ }
				}
			}
			add64le(ptr, val - addr)
		}
		6, 7 {
			write64le(ptr, val - rel.r_addend)
		}
		9, 41, 42 {
			add32le(ptr, s1.got.sh_addr - addr + get_sym_attr(s1, sym_index, 0).got_offset - 4)
		}
		26 { // case comp body kind=CallExpr is_enum=false
			add32le(ptr, s1.got.sh_addr - addr + rel.r_addend)
		}
		29 { // case comp body kind=CallExpr is_enum=false
			add64le(ptr, s1.got.sh_addr - addr + rel.r_addend)
		}
		22 { // case comp body kind=CallExpr is_enum=false
			add32le(ptr, val - s1.got.sh_addr)
		}
		3 { // case comp body kind=CallExpr is_enum=false
			add32le(ptr, get_sym_attr(s1, sym_index, 0).got_offset)
		}
		27 { // case comp body kind=CallExpr is_enum=false
			add64le(ptr, get_sym_attr(s1, sym_index, 0).got_offset)
		}
		25 { // case comp body kind=CallExpr is_enum=false
			add64le(ptr, val - s1.got.sh_addr)
		}
		19 {
			// case comp stmt
			expect := [102, 72, 141, 61, 0, 0, 0, 0, 102, 102, 72, 232, 0, 0, 0, 0]!

			replace := [100, 72, 139, 4, 37, 0, 0, 0, 0, 72, 141, 128, 0, 0, 0, 0]!

			if C.memcmp(ptr - 4, expect, sizeof(expect)) == 0 {
				sym := &Elf64_Sym(0)
				sec := &Section(0)
				x := 0
				C.memcpy(ptr - 4, replace, sizeof(replace))
				rel[1].r_info = (((Elf64_Xword((0))) << 32) + (0))
				sym = &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
				sec = s1.sections[sym.st_shndx]
				x = sym.st_value - sec.sh_addr - sec.data_offset
				add32le(ptr + 8, x)
			} else { // 3
				_tcc_error_noabort(s1, 'unexpected R_X86_64_TLSGD pattern')
			}
		}
		20 {
			// case comp stmt
			expect := [72, 141, 61, 0, 0, 0, 0, 232, 0, 0, 0, 0]!

			replace := [102, 102, 102, 100, 72, 139, 4, 37, 0, 0, 0, 0]!

			if C.memcmp(ptr - 3, expect, sizeof(expect)) == 0 {
				C.memcpy(ptr - 3, replace, sizeof(replace))
				rel[1].r_info = (((Elf64_Xword((0))) << 32) + (0))
			} else { // 3
				_tcc_error_noabort(s1, 'unexpected R_X86_64_TLSLD pattern')
			}
		}
		21, 23 {
			sym := &Elf64_Sym(0)
			sec := &Section(0)
			x := 0
			sym = &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
			sec = s1.sections[sym.st_shndx]
			x = val - sec.sh_addr - sec.data_offset
			add32le(ptr, x)
		}
		17, 18 {
			sym := &Elf64_Sym(0)
			sec := &Section(0)
			x := 0
			sym = &(&Elf64_Sym(s1.symtab_section.data))[sym_index]
			sec = s1.sections[sym.st_shndx]
			x = val - sec.sh_addr - sec.data_offset
			add64le(ptr, x)
		}
		0 { // case comp body kind=BreakStmt is_enum=false
		}
		8 { // case comp body kind=BreakStmt is_enum=false
		}
		else {
			C.fprintf(C.stderr, c'FIXME: handle reloc type %d at %x [%p] to %x\n', type_,
				u32(addr), ptr, u32(val))
		}
	}
}
