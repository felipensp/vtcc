module main

type Elf32_Half = u16
type Elf64_Half = u16
type Elf32_Word = u32
type Elf32_Sword = int
type Elf64_Word = u32
type Elf64_Sword = int
type Elf32_Xword = u64
type Elf32_Sxword = i64
type Elf64_Xword = u64
type Elf64_Sxword = i64
type Elf32_Addr = u32
type Elf64_Addr = u64
type Elf32_Off = u32
type Elf64_Off = u64
type Elf32_Section = u16
type Elf64_Section = u16
type Elf32_Versym = u16
type Elf64_Versym = u16

struct Elf32_Ehdr {
	e_ident     [16]u8
	e_type      Elf32_Half
	e_machine   Elf32_Half
	e_version   Elf32_Word
	e_entry     Elf32_Addr
	e_phoff     Elf32_Off
	e_shoff     Elf32_Off
	e_flags     Elf32_Word
	e_ehsize    Elf32_Half
	e_phentsize Elf32_Half
	e_phnum     Elf32_Half
	e_shentsize Elf32_Half
	e_shnum     Elf32_Half
	e_shstrndx  Elf32_Half
}

struct Elf64_Ehdr {
	e_ident     [16]u8
	e_type      Elf64_Half
	e_machine   Elf64_Half
	e_version   Elf64_Word
	e_entry     Elf64_Addr
	e_phoff     Elf64_Off
	e_shoff     Elf64_Off
	e_flags     Elf64_Word
	e_ehsize    Elf64_Half
	e_phentsize Elf64_Half
	e_phnum     Elf64_Half
	e_shentsize Elf64_Half
	e_shnum     Elf64_Half
	e_shstrndx  Elf64_Half
}

struct Elf32_Shdr {
	sh_name      Elf32_Word
	sh_type      Elf32_Word
	sh_flags     Elf32_Word
	sh_addr      Elf32_Addr
	sh_offset    Elf32_Off
	sh_size      Elf32_Word
	sh_link      Elf32_Word
	sh_info      Elf32_Word
	sh_addralign Elf32_Word
	sh_entsize   Elf32_Word
}

struct Elf64_Shdr {
	sh_name      Elf64_Word
	sh_type      Elf64_Word
	sh_flags     Elf64_Xword
	sh_addr      Elf64_Addr
	sh_offset    Elf64_Off
	sh_size      Elf64_Xword
	sh_link      Elf64_Word
	sh_info      Elf64_Word
	sh_addralign Elf64_Xword
	sh_entsize   Elf64_Xword
}

struct Elf32_Sym {
	st_name  Elf32_Word
	st_value Elf32_Addr
	st_size  Elf32_Word
	st_info  u8
	st_other u8
	st_shndx Elf32_Section
}

struct Elf64_Sym {
	st_name  Elf64_Word
	st_info  u8
	st_other u8
	st_shndx Elf64_Section
	st_value Elf64_Addr
	st_size  Elf64_Xword
}

struct Elf32_Syminfo {
	si_boundto Elf32_Half
	si_flags   Elf32_Half
}

struct Elf64_Syminfo {
	si_boundto Elf64_Half
	si_flags   Elf64_Half
}

struct Elf32_Rel {
	r_offset Elf32_Addr
	r_info   Elf32_Word
}

struct Elf64_Rel {
	r_offset Elf64_Addr
	r_info   Elf64_Xword
}

struct Elf32_Rela {
	r_offset Elf32_Addr
	r_info   Elf32_Word
	r_addend Elf32_Sword
}

struct Elf64_Rela {
	r_offset Elf64_Addr
	r_info   Elf64_Xword
	r_addend Elf64_Sxword
}

struct Elf32_Phdr {
	p_type   Elf32_Word
	p_offset Elf32_Off
	p_vaddr  Elf32_Addr
	p_paddr  Elf32_Addr
	p_filesz Elf32_Word
	p_memsz  Elf32_Word
	p_flags  Elf32_Word
	p_align  Elf32_Word
}

struct Elf64_Phdr {
	p_type   Elf64_Word
	p_flags  Elf64_Word
	p_offset Elf64_Off
	p_vaddr  Elf64_Addr
	p_paddr  Elf64_Addr
	p_filesz Elf64_Xword
	p_memsz  Elf64_Xword
	p_align  Elf64_Xword
}

struct Elf32_Dyn {
	d_tag Elf32_Sword
	// d_un Union (unnamed union at ./elf.h
}

struct Elf64_Dyn {
	d_tag Elf64_Sxword
	// d_un Union (unnamed union at ./elf.h
}

struct Elf32_Verdef {
	vd_version Elf32_Half
	vd_flags   Elf32_Half
	vd_ndx     Elf32_Half
	vd_cnt     Elf32_Half
	vd_hash    Elf32_Word
	vd_aux     Elf32_Word
	vd_next    Elf32_Word
}

struct Elf64_Verdef {
	vd_version Elf64_Half
	vd_flags   Elf64_Half
	vd_ndx     Elf64_Half
	vd_cnt     Elf64_Half
	vd_hash    Elf64_Word
	vd_aux     Elf64_Word
	vd_next    Elf64_Word
}

struct Elf32_Verdaux {
	vda_name Elf32_Word
	vda_next Elf32_Word
}

struct Elf64_Verdaux {
	vda_name Elf64_Word
	vda_next Elf64_Word
}

struct Elf32_Verneed {
	vn_version Elf32_Half
	vn_cnt     Elf32_Half
	vn_file    Elf32_Word
	vn_aux     Elf32_Word
	vn_next    Elf32_Word
}

struct Elf64_Verneed {
	vn_version Elf64_Half
	vn_cnt     Elf64_Half
	vn_file    Elf64_Word
	vn_aux     Elf64_Word
	vn_next    Elf64_Word
}

struct Elf32_Vernaux {
	vna_hash  Elf32_Word
	vna_flags Elf32_Half
	vna_other Elf32_Half
	vna_name  Elf32_Word
	vna_next  Elf32_Word
}

struct Elf64_Vernaux {
	vna_hash  Elf64_Word
	vna_flags Elf64_Half
	vna_other Elf64_Half
	vna_name  Elf64_Word
	vna_next  Elf64_Word
}

struct Elf32_auxv_t {
	a_type u32
	// a_un Union (unnamed union at ./elf.h
}

struct Elf64_auxv_t {
	a_type u64
	// a_un Union (unnamed union at ./elf.h
}

struct Elf32_Nhdr {
	n_namesz Elf32_Word
	n_descsz Elf32_Word
	n_type   Elf32_Word
}

struct Elf64_Nhdr {
	n_namesz Elf64_Word
	n_descsz Elf64_Word
	n_type   Elf64_Word
}

struct Elf32_Move {
	m_value   Elf32_Xword
	m_info    Elf32_Word
	m_poffset Elf32_Word
	m_repeat  Elf32_Half
	m_stride  Elf32_Half
}

struct Elf64_Move {
	m_value   Elf64_Xword
	m_info    Elf64_Xword
	m_poffset Elf64_Xword
	m_repeat  Elf64_Half
	m_stride  Elf64_Half
}

union Elf32_gptab {
	gt_header struct {
		gt_current_g_value Elf32_Word
		gt_unused          Elf32_Word
	}

	gt_entry struct {
		gt_g_value Elf32_Word
		gt_bytes   Elf32_Word
	}
}

struct Elf32_RegInfo {
	ri_gprmask  Elf32_Word
	ri_cprmask  [4]Elf32_Word
	ri_gp_value Elf32_Sword
}

struct Elf_Options {
	kind    u8
	size    u8
	section Elf32_Section
	info    Elf32_Word
}

struct Elf_Options_Hw {
	hwp_flags1 Elf32_Word
	hwp_flags2 Elf32_Word
}

struct Elf32_Lib {
	l_name       Elf32_Word
	l_time_stamp Elf32_Word
	l_checksum   Elf32_Word
	l_version    Elf32_Word
	l_flags      Elf32_Word
}

struct Elf64_Lib {
	l_name       Elf64_Word
	l_time_stamp Elf64_Word
	l_checksum   Elf64_Word
	l_version    Elf64_Word
	l_flags      Elf64_Word
}

type Elf32_Conflict = u32
