@[translated]
module main

pub const fp_int_upward = 0
pub const fp_int_downward = 1
pub const fp_int_towardzero = 2
pub const fp_int_tonearestfromzero = 3
pub const fp_int_tonearest = 4

pub const fp_nan = 0
pub const fp_infinite = 1
pub const fp_zero = 2
pub const fp_subnormal = 3
pub const fp_normal = 4

pub struct Dl_info {
	dli_fname &i8
	dli_fbase voidptr
	dli_sname &i8
	dli_saddr voidptr
}

// empty enum
pub const rtld_dl_syment = 1
pub const rtld_dl_linkmap = 2

// empty enum
pub const rtld_di_lmid = 1
pub const rtld_di_linkmap = 2
pub const rtld_di_configaddr = 3
pub const rtld_di_serinfo = 4
pub const rtld_di_serinfosize = 5
pub const rtld_di_origin = 6
pub const rtld_di_profilename = 7
pub const rtld_di_profileout = 8
pub const rtld_di_tls_modid = 9
pub const rtld_di_tls_data = 10
pub const rtld_di_max = 10

pub struct Dl_serpath {
	dls_name  &i8
	dls_flags u32
}

pub struct Dl_serinfo {
	dls_size    usize
	dls_cnt     u32
	dls_serpath [1]Dl_serpath
}

enum __stab_debug_code {
	n_gsym                = 32
	n_fname               = 34
	n_fun                 = 36
	n_stsym               = 38
	n_lcsym               = 40
	n_main                = 42
	n_pc                  = 48
	n_nsyms               = 50
	n_nomap               = 52
	n_obj                 = 56
	n_opt                 = 60
	n_rsym                = 64
	n_m2c                 = 66
	n_sline               = 68
	n_dsline              = 70
	n_bsline              = 72
	n_brows               = 72
	n_defd                = 74
	n_ehdecl              = 80
	n_mod2                = 80
	n_catch               = 84
	n_ssym                = 96
	n_so                  = 100
	n_lsym                = 128
	n_bincl               = 130
	n_sol                 = 132
	n_psym                = 160
	n_eincl               = 162
	n_entry               = 164
	n_lbrac               = 192
	n_excl                = 194
	n_scope               = 196
	n_rbrac               = 224
	n_bcomm               = 226
	n_ecomm               = 228
	n_ecoml               = 232
	n_nbtext              = 240
	n_nbdata              = 242
	n_nbbss               = 244
	n_nbsts               = 246
	n_nblcs               = 248
	n_leng                = 254
	last_unused_stab_code
}

fn read32le(p &u8) u32 {
	return read16le(p) | u32(read16le(p + 2)) << 16
}

fn write32le(p &u8, x u32) {
	write16le(p, x)
	write16le(p + 2, x >> 16)
}

fn add32le(p &u8, x int) {
	write32le(p, read32le(p) + x)
}

fn read64le(p &u8) u64 {
	return read32le(p) | u64(read32le(p + 4)) << 32
}

fn write64le(p &u8, x u64) {
	write32le(p, x)
	write32le(p + 4, x >> 32)
}

fn add64le(p &u8, x i64) {
	write64le(p, read64le(p) + x)
}

fn g(c int)

fn code_reloc(reloc_type int) int {
	match reloc_type {
		10, 11, 1, 26, 29, 9, 41, 42, 22, 3, 27, 6, 5, 8, 25 {
			return 0
		}
		2, 24, 4, 31, 7 {
			return 1
		}
		else {}
	}
	tcc_error(c'Unknown relocation type: %d', reloc_type)
	return -1
}

fn gotplt_entry_type(reloc_type int) int {
	match reloc_type {
		6, 7, 5, 8 {
			return Gotplt_entry.no_gotplt_entry
		}
		10, 11, 1, 2, 24 {
			return Gotplt_entry.auto_gotplt_entry
		}
		22 { // case comp body kind=ReturnStmt is_enum=false
			return Gotplt_entry.build_got_only
		}
		3, 27, 26, 29, 25, 9, 41, 42, 4, 31 {
			return Gotplt_entry.always_gotplt_entry
		}
		else {}
	}
	tcc_error(c'Unknown relocation type: %d', reloc_type)
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
	relofs = if s1.got.reloc { s1.got.reloc.data_offset } else { 0 }
	p = section_ptr_add(plt, 16)
	p[0] = 255
	p[1] = modrm
	write32le(p + 2, got_offset)
	p[6] = 104
	write32le(p + 7, relofs / sizeof(Elf64_Rela))
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
			add32le(p + 2, x + s1.plt.data - p)
			p += 16
		}
	}
}

@[weak]
__global (
	qrel &Elf64_Rela
)

fn relocate_init(sr &Section) {
	qrel = &Elf64_Rela(sr.data)
}

fn relocate_fini(sr &Section) {
}

fn relocate(s1 &TCCState, rel &Elf64_Rela, type_ int, ptr &u8, addr Elf64_Addr, val Elf64_Addr) {
	sym_index := 0
	esym_index := 0

	sym_index = ((rel.r_info) >> 32)
	match type_ {
		1 { // case comp body kind=IfStmt is_enum=false
			if s1.output_type == 3 {
				esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
				qrel.r_offset = rel.r_offset
				if esym_index {
					qrel.r_info = (((Elf64_Xword(esym_index)) << 32) + (1))
					qrel.r_addend = rel.r_addend
					qrel++
				} else {
					qrel.r_info = (((Elf64_Xword((0))) << 32) + (8))
					qrel.r_addend = read64le(ptr) + val
					qrel++
				}
			}
			add64le(ptr, val)
		}
		10, 11 {
			if s1.output_type == 3 {
				qrel.r_info = (((Elf64_Xword((0))) << 32) + (8))
				qrel.r_addend = int(read32le(ptr)) + val
				qrel++
			}
			add32le(ptr, val)
		}
		2 { // case comp body kind=IfStmt is_enum=false
			if s1.output_type == 3 {
				esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
				if esym_index {
					qrel.r_offset = rel.r_offset
					qrel.r_info = (((Elf64_Xword(esym_index)) << 32) + (2))
					qrel.r_addend = int(read32le(ptr)) + rel.r_addend
					qrel++
				}
			}
			goto plt32pc32 // id: 0x7fffba323c50
		}
		4 { // case comp body kind=LabelStmt is_enum=false
			// RRRREG plt32pc32 id=0x7fffba323c50
			plt32pc32:
			{
				diff := i64(0)
				diff = i64(val) - addr
				if diff < -2147483648 || diff > 2147483647 {
					tcc_error(c'internal error: relocation failed')
				}
				add32le(ptr, diff)
			}
		}
		31 { // case comp body kind=CallExpr is_enum=false
			add64le(ptr, val - s1.got.sh_addr + rel.r_addend)
		}
		24 { // case comp body kind=IfStmt is_enum=false
			if s1.output_type == 3 {
				esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
				if esym_index {
					qrel.r_offset = rel.r_offset
					qrel.r_info = (((Elf64_Xword(esym_index)) << 32) + (24))
					qrel.r_addend = read64le(ptr) + rel.r_addend
					qrel++
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
		8 { // case comp body kind=BreakStmt is_enum=false
		}
		else {}
	}
}
