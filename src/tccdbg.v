@[translated]
module main

import strings

fn C.strncpy(&char, &char, u32) &char
fn C.getcwd(&char, usize) &char

struct DefaultDebug {
	type_    int
	size     int
	encoding int
	name     &char
}

const default_debug = [
	DefaultDebug{3, 4, dw_ate_signed, c'int:t1=r1;-2147483648;2147483647;'},
	DefaultDebug{1, 1, dw_ate_signed_char, c'char:t2=r2;0;127;'},
	DefaultDebug{4 | 2048, 8, dw_ate_signed, c'long int:t3=r3;-9223372036854775808;9223372036854775807;'},
	DefaultDebug{3 | 16, 4, dw_ate_unsigned, c'unsigned int:t4=r4;0;037777777777;'},
	DefaultDebug{4 | 2048 | 16, 8, dw_ate_unsigned, c'long unsigned int:t5=r5;0;01777777777777777777777;'},
	DefaultDebug{13, 16, dw_ate_signed, c'__int128:t6=r6;0;-1;'},
	DefaultDebug{13 | 16, 16, dw_ate_unsigned, c'__int128 unsigned:t7=r7;0;-1;'},
	DefaultDebug{4, 8, dw_ate_signed, c'long long int:t8=r8;-9223372036854775808;9223372036854775807;'},
	DefaultDebug{4 | 16, 8, dw_ate_unsigned, c'long long unsigned int:t9=r9;0;01777777777777777777777;'},
	DefaultDebug{2, 2, dw_ate_signed, c'short int:t10=r10;-32768;32767;'},
	DefaultDebug{2 | 16, 2, dw_ate_unsigned, c'short unsigned int:t11=r11;0;65535;'},
	DefaultDebug{1 | 32, 1, dw_ate_signed_char, c'signed char:t12=r12;-128;127;'},
	DefaultDebug{1 | 32 | 16, 1, dw_ate_unsigned_char, c'unsigned char:t13=r13;0;255;'},
	DefaultDebug{8, 4, dw_ate_float, c'float:t14=r1;4;0;'},
	DefaultDebug{9, 8, dw_ate_float, c'double:t15=r1;8;0;'},
	DefaultDebug{10, 16, dw_ate_float, c'long double:t16=r1;16;0;'},
	DefaultDebug{-1, -1, -1, c'_Float32:t17=r1;4;0;'},
	DefaultDebug{-1, -1, -1, c'_Float64:t18=r1;8;0;'},
	DefaultDebug{-1, -1, -1, c'_Float128:t19=r1;16;0;'},
	DefaultDebug{-1, -1, -1, c'_Float32x:t20=r1;8;0;'},
	DefaultDebug{-1, -1, -1, c'_Float64x:t21=r1;16;0;'},
	DefaultDebug{-1, -1, -1, c'_Decimal32:t22=r1;4;0;'},
	DefaultDebug{-1, -1, -1, c'_Decimal64:t23=r1;8;0;'},
	DefaultDebug{-1, -1, -1, c'_Decimal128:t24=r1;16;0;'},
	DefaultDebug{1 | 16, 1, dw_ate_unsigned_char, c'unsigned char:t25=r25;0;255;'},
	DefaultDebug{11, 1, dw_ate_boolean, c'bool:t26=r26;0;255;'},
	DefaultDebug{2048 | 3, 8, dw_ate_signed, c'long int:t27=r27;-9223372036854775808;9223372036854775807;'},
	DefaultDebug{2048 | 3 | 16, 8, dw_ate_unsigned, c'long unsigned int:t28=r28;0;01777777777777777777777;'},
	DefaultDebug{0, 1, dw_ate_unsigned_char, c'void:t29=29'},
]!

const dwarf_abbrev_init = [1, dw_tag_compile_unit, 1, dw_at_producer, dw_form_strp, dw_at_language,
	dw_form_data1, dw_at_name, dw_form_line_strp, dw_at_comp_dir, dw_form_line_strp, dw_at_low_pc,
	dw_form_addr, dw_at_high_pc, dw_form_data8, dw_at_stmt_list, dw_form_sec_offset, 0, 0, 2,
	dw_tag_base_type, 0, dw_at_byte_size, dw_form_udata, dw_at_encoding, dw_form_data1, dw_at_name,
	dw_form_strp, 0, 0, 3, dw_tag_variable, 0, dw_at_name, dw_form_strp, dw_at_decl_file,
	dw_form_udata, dw_at_decl_line, dw_form_udata, dw_at_type, dw_form_ref4, dw_at_external,
	dw_form_flag, dw_at_location, dw_form_exprloc, 0, 0, 4, dw_tag_variable, 0, dw_at_name,
	dw_form_strp, dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata, dw_at_type,
	dw_form_ref4, dw_at_location, dw_form_exprloc, 0, 0, 5, dw_tag_variable, 0, dw_at_name,
	dw_form_strp, dw_at_type, dw_form_ref4, dw_at_location, dw_form_exprloc, 0, 0, 6,
	dw_tag_formal_parameter, 0, dw_at_name, dw_form_strp, dw_at_type, dw_form_ref4, dw_at_location,
	dw_form_exprloc, 0, 0, 7, dw_tag_pointer_type, 0, dw_at_byte_size, dw_form_data1, dw_at_type,
	dw_form_ref4, 0, 0, 8, dw_tag_array_type, 1, dw_at_type, dw_form_ref4, dw_at_sibling,
	dw_form_ref4, 0, 0, 9, dw_tag_subrange_type, 0, dw_at_type, dw_form_ref4, dw_at_upper_bound,
	dw_form_udata, 0, 0, 10, dw_tag_typedef, 0, dw_at_name, dw_form_strp, dw_at_decl_file,
	dw_form_udata, dw_at_decl_line, dw_form_udata, dw_at_type, dw_form_ref4, 0, 0, 11,
	dw_tag_enumerator, 0, dw_at_name, dw_form_strp, dw_at_const_value, dw_form_sdata, 0, 0, 12,
	dw_tag_enumerator, 0, dw_at_name, dw_form_strp, dw_at_const_value, dw_form_udata, 0, 0, 13,
	dw_tag_enumeration_type, 1, dw_at_name, dw_form_strp, dw_at_encoding, dw_form_data1,
	dw_at_byte_size, dw_form_data1, dw_at_type, dw_form_ref4, dw_at_decl_file, dw_form_udata,
	dw_at_decl_line, dw_form_udata, dw_at_sibling, dw_form_ref4, 0, 0, 14, dw_tag_member, 0,
	dw_at_name, dw_form_strp, dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata,
	dw_at_type, dw_form_ref4, dw_at_data_member_location, dw_form_udata, 0, 0, 15, dw_tag_member,
	0, dw_at_name, dw_form_strp, dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata,
	dw_at_type, dw_form_ref4, dw_at_bit_size, dw_form_udata, dw_at_data_bit_offset, dw_form_udata,
	0, 0, 16, dw_tag_structure_type, 1, dw_at_name, dw_form_strp, dw_at_byte_size, dw_form_udata,
	dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata, dw_at_sibling, dw_form_ref4,
	0, 0, 17, dw_tag_structure_type, 0, dw_at_name, dw_form_strp, dw_at_byte_size, dw_form_udata,
	dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata, 0, 0, 18, dw_tag_union_type,
	1, dw_at_name, dw_form_strp, dw_at_byte_size, dw_form_udata, dw_at_decl_file, dw_form_udata,
	dw_at_decl_line, dw_form_udata, dw_at_sibling, dw_form_ref4, 0, 0, 19, dw_tag_union_type, 0,
	dw_at_name, dw_form_strp, dw_at_byte_size, dw_form_udata, dw_at_decl_file, dw_form_udata,
	dw_at_decl_line, dw_form_udata, 0, 0, 20, dw_tag_subprogram, 1, dw_at_external, dw_form_flag,
	dw_at_name, dw_form_strp, dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata,
	dw_at_type, dw_form_ref4, dw_at_low_pc, dw_form_addr, dw_at_high_pc, dw_form_data8, dw_at_sibling,
	dw_form_ref4, dw_at_frame_base, dw_form_exprloc, 0, 0, 21, dw_tag_subprogram, 1, dw_at_name,
	dw_form_strp, dw_at_decl_file, dw_form_udata, dw_at_decl_line, dw_form_udata, dw_at_type,
	dw_form_ref4, dw_at_low_pc, dw_form_addr, dw_at_high_pc, dw_form_data8, dw_at_sibling,
	dw_form_ref4, dw_at_frame_base, dw_form_exprloc, 0, 0, 22, dw_tag_lexical_block, 1, dw_at_low_pc,
	dw_form_addr, dw_at_high_pc, dw_form_data8, 0, 0, 23, dw_tag_lexical_block, 0, dw_at_low_pc,
	dw_form_addr, dw_at_high_pc, dw_form_data8, 0, 0, 24, dw_tag_subroutine_type, 1, dw_at_type,
	dw_form_ref4, dw_at_sibling, dw_form_ref4, 0, 0, 25, dw_tag_subroutine_type, 0, dw_at_type,
	dw_form_ref4, 0, 0, 26, dw_tag_formal_parameter, 0, dw_at_type, dw_form_ref4, 0, 0, 0]!

const dwarf_line_opcodes = [0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1]!

struct Debug_sym {
	type_     int
	value     u64
	str       &char
	sec       &Section
	sym_index int
	info      int
	file      int
	line      int
}

struct debug_info {
	start int
	end   int
	n_sym int
	sym   &Debug_sym

	child  &debug_info
	next   &debug_info
	last   &debug_info
	parent &debug_info
}

struct debug_hash {
	debug_type int
	type_      &Sym
}

struct debug_anon_hash {
	type_        &Sym
	n_debug_type int
	debug_type   &int
}

struct Dwarf_filename_struct {
	dir_entry int
	name      &char
}

pub struct Tccdbg {
	last_line_num     int
	new_file          int
	section_sym       int
	debug_next_type   int
	debug_hash        &debug_hash
	debug_anon_hash   &debug_anon_hash
	n_debug_hash      int
	n_debug_anon_hash int
	debug_info        &debug_info
	debug_info_root   &debug_info
	dwarf_sym         struct {
		info     int
		abbrev   int
		line     int
		str      int
		line_str int
	}

	dwarf_line struct {
		start          int
		dir_size       int
		dir_table      &&u8
		filename_size  int
		filename_table &Dwarf_filename_struct
		line_size      int
		line_max_size  int
		line_data      &u8
		cur_file       int
		last_file      int
		last_pc        int
		last_line      int
	}

	dwarf_info struct {
		start          int
		func           &Sym
		line           int
		base_type_used [29]int
	}

	tcov_data struct {
		offset         u32
		last_file_name u32
		last_func_name u32
		ind            int
		line           int
	}
}

fn tcc_debug_new(s1 &TCCState) {
	shf := 0
	if !s1.dState {
		s1.dState = tcc_mallocz(sizeof(*s1.dState))
	}
	if s1.do_backtrace && s1.output_type & (2 | 4) {
		shf = (1 << 1) | (1 << 0)
	}
	if s1.dwarf {
		s1.dwlo = s1.nb_sections
		s1.dwarf_info_section = new_section(s1, c'.debug_info', 1, shf)
		s1.dwarf_abbrev_section = new_section(s1, c'.debug_abbrev', 1, shf)
		s1.dwarf_line_section = new_section(s1, c'.debug_line', 1, shf)
		s1.dwarf_aranges_section = new_section(s1, c'.debug_aranges', 1, shf)
		shf |= (1 << 4) | (1 << 5)
		s1.dwarf_str_section = new_section(s1, c'.debug_str', 1, shf)
		s1.dwarf_str_section.sh_entsize = 1
		s1.dwarf_str_section.sh_addralign = 1
		s1.dwarf_aranges_section.sh_addralign = s1.dwarf_str_section.sh_addralign
		s1.dwarf_line_section.sh_addralign = s1.dwarf_aranges_section.sh_addralign
		s1.dwarf_abbrev_section.sh_addralign = s1.dwarf_line_section.sh_addralign
		s1.dwarf_info_section.sh_addralign = s1.dwarf_abbrev_section.sh_addralign
		if s1.dwarf >= 5 {
			s1.dwarf_line_str_section = new_section(s1, c'.debug_line_str', 1, shf)
			s1.dwarf_line_str_section.sh_entsize = 1
			s1.dwarf_line_str_section.sh_addralign = 1
		}
		s1.dwhi = s1.nb_sections
	} else {
		s1.stab_section = new_section(s1, c'.stab', 1, shf)
		s1.stab_section.sh_entsize = sizeof(Stab_Sym)
		s1.stab_section.sh_addralign = sizeof(u32)
		s1.stab_section.link = new_section(s1, c'.stabstr', 3, shf)
		put_stabs(s1, c'', 0, 0, 0, 0)
	}
}

fn put_stabs(s1 &TCCState, str &char, type_ int, other int, desc int, value u32) {
	sym := &Stab_Sym(0)
	offset := u32(0)
	offset = s1.stab_section.data_offset
	sym = unsafe { &Stab_Sym((s1.stab_section.data + offset)) - 1 }
	if type_ == Stab_debug_code.n_sline && offset && sym && sym.n_type == type_
		&& sym.n_value == value {
		sym.n_desc = desc
		return
	}
	sym = section_ptr_add(s1.stab_section, sizeof(Stab_Sym))
	if str {
		sym.n_strx = put_elf_str(s1.stab_section.link, str)
	} else {
		sym.n_strx = 0
	}
	sym.n_type = type_
	sym.n_other = other
	sym.n_desc = desc
	sym.n_value = value
}

fn put_stabs_r(s1 &TCCState, str &char, type_ int, other int, desc int, value u32, sec &Section, sym_index int) {
	put_elf_reloc(s1.symtab_section, s1.stab_section, s1.stab_section.data_offset + 8,
		if sizeof(u32) == 8 { 1 } else { 11 }, sym_index)
	put_stabs(s1, str, type_, other, desc, value)
}

fn put_stabn(s1 &TCCState, type_ int, other int, desc int, value int) {
	put_stabs(s1, (unsafe { nil }), type_, other, desc, value)
}

fn dwarf_get_section_sym(s &Section) int {
	s1 := s.s1
	return put_elf_sym(s1.symtab_section, 0, 0, (((0) << 4) + ((3) & 15)), 0, s.sh_num,
		(unsafe { nil }))
}

fn dwarf_reloc(s &Section, sym int, rel int) {
	s1 := s.s1
	put_elf_reloca(s1.symtab_section, s, s.data_offset, rel, sym, 0)
}

fn dwarf_string(s &Section, dw &Section, sym int, str &char) {
	s1 := s.s1
	offset := 0
	len := 0

	ptr := &char(0)
	len = unsafe { C.strlen(str) + 1 }
	offset = dw.data_offset
	ptr = section_ptr_add(dw, len)
	unsafe { C.memmove(ptr, str, len) }
	put_elf_reloca(s1.symtab_section, s, s.data_offset, 10, sym, if 8 == 4 { 0 } else { offset })
	write32le(section_ptr_add(s, 4), (if 8 == 4 { offset } else { 0 }))
}

fn dwarf_strp(s &Section, str &char) {
	s1 := s.s1
	dwarf_string(s, s1.dwarf_str_section, s1.dState.dwarf_sym.str, str)
}

fn dwarf_line_strp(s &Section, str &char) {
	s1 := s.s1
	dwarf_string(s, s1.dwarf_line_str_section, s1.dState.dwarf_sym.line_str, str)
}

fn dwarf_line_op(s1 &TCCState, op u8) {
	if s1.dState.dwarf_line.line_size >= s1.dState.dwarf_line.line_max_size {
		s1.dState.dwarf_line.line_max_size += 1024
		s1.dState.dwarf_line.line_data = &u8(tcc_realloc(s1.dState.dwarf_line.line_data,
			s1.dState.dwarf_line.line_max_size))
	}
	s1.dState.dwarf_line.line_data[s1.dState.dwarf_line.line_size++] = op
}

fn dwarf_file(s1 &TCCState) {
	i := 0
	j := 0

	filename := &char(0)
	index_offset := s1.dwarf < 5
	if unsafe { !C.strcmp(file.filename, c'<command line>') } {
		s1.dState.dwarf_line.cur_file = 1
		return
	}
	filename = unsafe { C.strrchr(file.filename, `/`) }
	if filename == (unsafe { nil }) {
		for i = 1; i < s1.dState.dwarf_line.filename_size; i++ {
			if s1.dState.dwarf_line.filename_table[i].dir_entry == 0
				&& unsafe { C.strcmp(s1.dState.dwarf_line.filename_table[i].name, file.filename) } == 0 {
				s1.dState.dwarf_line.cur_file = i + index_offset
				return
			}
		}
		i = -int(index_offset)
		filename = file.filename
	} else {
		undo := filename
		dir := file.filename
		unsafe {
			*filename++ = c'\x00'
		}
		for i = 0; i < s1.dState.dwarf_line.dir_size; i++ {
			if unsafe { C.strcmp(s1.dState.dwarf_line.dir_table[i], dir) == 0 } {
				for j = 1; j < s1.dState.dwarf_line.filename_size; j++ {
					if s1.dState.dwarf_line.filename_table[j].dir_entry - index_offset == i
						&& unsafe { C.strcmp(s1.dState.dwarf_line.filename_table[j].name, filename) == 0 } {
						*undo = `/`
						s1.dState.dwarf_line.cur_file = j + index_offset
						return
					}
				}
				break
			}
		}
		if i == s1.dState.dwarf_line.dir_size {
			s1.dState.dwarf_line.dir_size++
			s1.dState.dwarf_line.dir_table = &&u8(tcc_realloc(s1.dState.dwarf_line.dir_table,
				s1.dState.dwarf_line.dir_size * sizeof(&char)))
			s1.dState.dwarf_line.dir_table[i] = tcc_strdup(dir)
		}
		*undo = `/`
	}
	s1.dState.dwarf_line.filename_table = &Dwarf_filename_struct{}
	(tcc_realloc(s1.dState.dwarf_line.filename_table, (s1.dState.dwarf_line.filename_size + 1) * sizeof(Dwarf_filename_struct)))
	s1.dState.dwarf_line.filename_table[s1.dState.dwarf_line.filename_size].dir_entry = i +
		index_offset
	s1.dState.dwarf_line.filename_table[s1.dState.dwarf_line.filename_size].name = tcc_strdup(filename)
	s1.dState.dwarf_line.cur_file = s1.dState.dwarf_line.filename_size++ + index_offset
	return
}

fn dwarf_sleb128_size(value i64) int {
	size := 0
	end := value >> 63
	last := end & 64
	byte_ := u8(0)
	for {
		byte_ = value & 127
		value >>= 7
		size++
		// while()
		if !(value != end || (byte_ & 64) != last) {
			break
		}
	}
	return size
}

fn dwarf_uleb128(s &Section, value i64) {
	for {
		byte_ := value & 127
		value >>= 7
		{
			p := &char(section_ptr_add(s, 1))
			*p = (byte_ | (if value { 128 } else { 0 }))
		}
		0
		// while()
		if !(value != 0) {
			break
		}
	}
}

fn dwarf_sleb128(s &Section, value i64) {
	more := 0
	end := value >> 63
	last := end & 64
	for {
		byte_ := value & 127
		value >>= 7
		more = value != end || (byte_ & 64) != last

		p := &char(section_ptr_add(s, 1))
		*p = (byte_ | (128 * more))

		// while()
		if !more {
			break
		}
	}
}

fn dwarf_uleb128_op(s1 &TCCState, value i64) {
	for {
		byte_ := value & 127
		value >>= 7
		dwarf_line_op(s1, byte_ | (if value { 128 } else { 0 }))
		// while()
		if !(value != 0) {
			break
		}
	}
}

fn dwarf_sleb128_op(s1 &TCCState, value i64) {
	more := 0
	end := value >> 63
	last := end & 64
	for {
		byte_ := value & 127
		value >>= 7
		more = value != end || (byte_ & 64) != last
		dwarf_line_op(s1, byte_ | (128 * more))
		// while()
		if !more {
			break
		}
	}
}

fn tcc_debug_start(s1 &TCCState) {
	vcc_trace('${@LOCATION}')
	i := 0
	buf := [512]char{}
	filename := &char(0)
	vcc_trace('${@LOCATION}')
	filename = if file.prev { file.prev.filename } else { file.filename }
	vcc_trace('${@LOCATION} ${s1.symtab_section != unsafe { nil }}')
	put_elf_sym(s1.symtab_section, 0, 0, (((0) << 4) + ((4) & 15)), 0, 65521, filename)
	vcc_trace('${@LOCATION}')
	if s1.do_debug {
		s1.dState.new_file = 0
		s1.dState.last_line_num = s1.dState.new_file
		s1.dState.debug_next_type = (sizeof(default_debug) / sizeof(default_debug[0]))
		s1.dState.debug_hash = (unsafe { nil })
		s1.dState.debug_anon_hash = (unsafe { nil })
		s1.dState.n_debug_hash = 0
		s1.dState.n_debug_anon_hash = 0
		vcc_trace('${@LOCATION}')
		C.getcwd(buf, sizeof(buf))
		vcc_trace('${@LOCATION}')
		if s1.dwarf {
			start_abbrev := 0
			ptr := &u8(0)
			undo := &char(0)
			start_abbrev = s1.dwarf_abbrev_section.data_offset
			ptr = section_ptr_add(s1.dwarf_abbrev_section, sizeof(dwarf_abbrev_init))
			unsafe { C.memcpy(ptr, dwarf_abbrev_init, sizeof(dwarf_abbrev_init)) }
			if s1.dwarf < 5 {
				for *ptr {
					ptr += 3
					for *ptr {
						if ptr[1] == dw_form_line_strp {
							ptr[1] = dw_form_strp
						}
						if s1.dwarf < 4 {
							if ptr[1] == dw_form_sec_offset {
								ptr[1] = dw_form_data4
							}
							if ptr[1] == dw_form_exprloc {
								ptr[1] = dw_form_block1
							}
						}
						ptr += 2
					}
					ptr += 2
				}
			}
			vcc_trace('${@LOCATION}')
			s1.dState.dwarf_sym.info = dwarf_get_section_sym(s1.dwarf_info_section)
			s1.dState.dwarf_sym.abbrev = dwarf_get_section_sym(s1.dwarf_abbrev_section)
			s1.dState.dwarf_sym.line = dwarf_get_section_sym(s1.dwarf_line_section)
			s1.dState.dwarf_sym.str = dwarf_get_section_sym(s1.dwarf_str_section)
			vcc_trace('${@LOCATION}')
			if tcc_state.dwarf >= 5 {
				s1.dState.dwarf_sym.line_str = dwarf_get_section_sym(s1.dwarf_line_str_section)
			} else {
				s1.dwarf_line_str_section = s1.dwarf_str_section
				s1.dState.dwarf_sym.line_str = s1.dState.dwarf_sym.str
			}
			vcc_trace('${@LOCATION}')
			s1.dState.section_sym = dwarf_get_section_sym(s1.text_section)
			s1.dState.dwarf_info.start = s1.dwarf_info_section.data_offset
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			write16le(section_ptr_add((s1.dwarf_info_section), 2), (s1.dwarf))
			vcc_trace('${@LOCATION}')
			if s1.dwarf >= 5 {
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = dw_ut_compile
				}
				0
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (8)
				}
				0
				dwarf_reloc(s1.dwarf_info_section, s1.dState.dwarf_sym.abbrev, 10)
				write32le(section_ptr_add((s1.dwarf_info_section), 4), start_abbrev)
			} else {
				dwarf_reloc(s1.dwarf_info_section, s1.dState.dwarf_sym.abbrev, 10)
				write32le(section_ptr_add((s1.dwarf_info_section), 4), start_abbrev)
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (8)
				}
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (1)
			}
			dwarf_strp(s1.dwarf_info_section, c'tcc 0.9.28rc')
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = dw_lang_c11
			}
			dwarf_line_strp(s1.dwarf_info_section, filename)
			dwarf_line_strp(s1.dwarf_info_section, buf)
			dwarf_reloc(s1.dwarf_info_section, s1.dState.section_sym, 1)
			write64le(section_ptr_add((s1.dwarf_info_section), 8), ind)
			write64le(section_ptr_add((s1.dwarf_info_section), 8), (0))
			dwarf_reloc(s1.dwarf_info_section, s1.dState.dwarf_sym.line, 10)
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (s1.dwarf_line_section.data_offset))
			s1.dState.dwarf_line.start = s1.dwarf_line_section.data_offset
			write32le(section_ptr_add((s1.dwarf_line_section), 4), (0))
			write16le(section_ptr_add((s1.dwarf_line_section), 2), (s1.dwarf))
			if s1.dwarf >= 5 {
				{
					p := &char(section_ptr_add((s1.dwarf_line_section), 1))
					*p = (8)
				}
				{
					p := &char(section_ptr_add((s1.dwarf_line_section), 1))
					*p = (0)
				}
			}
			write32le(section_ptr_add((s1.dwarf_line_section), 4), (0))
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (1)
			}
			if s1.dwarf >= 4 {
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (1)
			}

			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (1)
			}
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (-5)
			}
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (14)
			}
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (13)
			}
			ptr = section_ptr_add(s1.dwarf_line_section, sizeof(dwarf_line_opcodes))
			unsafe {
				C.memcpy(ptr, dwarf_line_opcodes, sizeof(dwarf_line_opcodes))
				undo = C.strrchr(filename, `/`)
			}
			if undo {
				*undo = 0
			}
			s1.dState.dwarf_line.dir_size = 1 + (undo != (unsafe { nil }))
			s1.dState.dwarf_line.dir_table = &&u8(tcc_malloc(sizeof(&char) * s1.dState.dwarf_line.dir_size))
			s1.dState.dwarf_line.dir_table[0] = tcc_strdup(buf)
			if undo {
				s1.dState.dwarf_line.dir_table[1] = tcc_strdup(filename)
			}
			s1.dState.dwarf_line.filename_size = 2
			s1.dState.dwarf_line.filename_table = &Dwarf_filename_struct{}
			(tcc_malloc(2 * sizeof(Dwarf_filename_struct)))
			s1.dState.dwarf_line.filename_table[0].dir_entry = 0
			if undo {
				unsafe {
					s1.dState.dwarf_line.filename_table[0].name = tcc_strdup(undo + 1)
					s1.dState.dwarf_line.filename_table[1].dir_entry = 1
					s1.dState.dwarf_line.filename_table[1].name = tcc_strdup(undo + 1)
					*undo = `/`
				}
			} else {
				s1.dState.dwarf_line.filename_table[0].name = tcc_strdup(filename)
				s1.dState.dwarf_line.filename_table[1].dir_entry = 0
				s1.dState.dwarf_line.filename_table[1].name = tcc_strdup(filename)
			}
			s1.dState.dwarf_line.line_size = 0
			s1.dState.dwarf_line.line_max_size = s1.dState.dwarf_line.line_size
			s1.dState.dwarf_line.line_data = (unsafe { nil })
			s1.dState.dwarf_line.cur_file = 1
			s1.dState.dwarf_line.last_file = 0
			s1.dState.dwarf_line.last_pc = 0
			s1.dState.dwarf_line.last_line = 1
			dwarf_line_op(s1, 0)
			dwarf_uleb128_op(s1, 1 + 8)
			dwarf_line_op(s1, dw_lne_set_address)
			for i = 0; i < 8; i++ {
				dwarf_line_op(s1, 0)
			}
			unsafe {
				C.memset(&s1.dState.dwarf_info.base_type_used, 0, sizeof(s1.dState.dwarf_info.base_type_used))
			}
		} else {
			pstrcat(buf, sizeof(buf), c'/')
			s1.dState.section_sym = put_elf_sym(s1.symtab_section, 0, 0, (((0) << 4) + ((3) & 15)),
				0, s1.text_section.sh_num, (unsafe { nil }))
			put_stabs_r(s1, buf, Stab_debug_code.n_so, 0, 0, s1.text_section.data_offset,
				s1.text_section, s1.dState.section_sym)
			put_stabs_r(s1, filename, Stab_debug_code.n_so, 0, 0, s1.text_section.data_offset,
				s1.text_section, s1.dState.section_sym)
			for i = 0; i < (sizeof(default_debug) / sizeof(default_debug[0])); i++ {
				put_stabs(s1, default_debug[i].name, Stab_debug_code.n_lsym, 0, 0, 0)
			}
		}
		tcc_debug_bincl(s1)
	}
}

fn tcc_debug_end(s1 &TCCState) {
	if !s1.do_debug || s1.dState.debug_next_type == 0 {
		return
	}
	if s1.dState.debug_info_root {
		tcc_debug_funcend(s1, 0)
	}
	if s1.dwarf {
		i := 0
		j := 0

		start_aranges := 0
		ptr := &u8(0)
		text_size := s1.text_section.data_offset
		for i = 0; i < s1.dState.n_debug_anon_hash; i++ {
			t := s1.dState.debug_anon_hash[i].type_
			pos := s1.dwarf_info_section.data_offset
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (if ((t.type_.t & ((((1 << (6 + 6)) - 1) << 20 | 128) | 15)) == (1 << 20 | 7)) {
					19
				} else {
					17
				})
			}
			0
			dwarf_strp(s1.dwarf_info_section, if (t.v & ~1073741824) >= 268435456 {
				c''
			} else {
				get_tok_str(t.v & ~1073741824, (unsafe { nil }))
			})
			dwarf_uleb128(s1.dwarf_info_section, 0)
			dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
			dwarf_uleb128(s1.dwarf_info_section, file.line_num)
			for j = 0; j < s1.dState.debug_anon_hash[i].n_debug_type; j++ {
				unsafe {
					write32le(s1.dwarf_info_section.data +
						s1.dState.debug_anon_hash[i].debug_type[j], pos - s1.dState.dwarf_info.start)
				}
			}
			tcc_free(s1.dState.debug_anon_hash[i].debug_type)
		}
		tcc_free(s1.dState.debug_anon_hash)
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (0)
		}
		unsafe {
			ptr = s1.dwarf_info_section.data + s1.dState.dwarf_info.start
			write32le(ptr, s1.dwarf_info_section.data_offset - s1.dState.dwarf_info.start - 4)

			write32le(ptr + 25 + int(s1.dwarf >= 5) + 8, text_size)
		}
		start_aranges = s1.dwarf_aranges_section.data_offset
		write32le(section_ptr_add((s1.dwarf_aranges_section), 4), (0))
		write16le(section_ptr_add((s1.dwarf_aranges_section), 2), (2))
		dwarf_reloc(s1.dwarf_aranges_section, s1.dState.dwarf_sym.info, 10)
		write32le(section_ptr_add((s1.dwarf_aranges_section), 4), (0))
		{
			p := &char(section_ptr_add((s1.dwarf_aranges_section), 1))
			*p = (8)
		}
		{
			p := &char(section_ptr_add((s1.dwarf_aranges_section), 1))
			*p = (0)
		}
		write32le(section_ptr_add((s1.dwarf_aranges_section), 4), (0))
		dwarf_reloc(s1.dwarf_aranges_section, s1.dState.section_sym, 1)
		write64le(section_ptr_add((s1.dwarf_aranges_section), 8), (0))
		write64le(section_ptr_add((s1.dwarf_aranges_section), 8), text_size)
		write64le(section_ptr_add((s1.dwarf_aranges_section), 8), (0))
		write64le(section_ptr_add((s1.dwarf_aranges_section), 8), (0))

		unsafe {
			ptr = s1.dwarf_aranges_section.data + start_aranges
		}
		write32le(ptr, s1.dwarf_aranges_section.data_offset - start_aranges - 4)
		if s1.dwarf >= 5 {
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (1)
			}
			0
			dwarf_uleb128(s1.dwarf_line_section, dw_lnct_path)
			dwarf_uleb128(s1.dwarf_line_section, dw_form_line_strp)
			dwarf_uleb128(s1.dwarf_line_section, s1.dState.dwarf_line.dir_size)
			for i = 0; i < s1.dState.dwarf_line.dir_size; i++ {
				dwarf_line_strp(s1.dwarf_line_section, s1.dState.dwarf_line.dir_table[i])
			}
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (2)
			}
			0
			dwarf_uleb128(s1.dwarf_line_section, dw_lnct_path)
			dwarf_uleb128(s1.dwarf_line_section, dw_form_line_strp)
			dwarf_uleb128(s1.dwarf_line_section, dw_lnct_directory_index)
			dwarf_uleb128(s1.dwarf_line_section, dw_form_udata)
			dwarf_uleb128(s1.dwarf_line_section, s1.dState.dwarf_line.filename_size)
			for i = 0; i < s1.dState.dwarf_line.filename_size; i++ {
				dwarf_line_strp(s1.dwarf_line_section, s1.dState.dwarf_line.filename_table[i].name)
				dwarf_uleb128(s1.dwarf_line_section, s1.dState.dwarf_line.filename_table[i].dir_entry)
			}
		} else {
			len := 0
			for i = 0; i < s1.dState.dwarf_line.dir_size; i++ {
				unsafe {
					len = C.strlen(s1.dState.dwarf_line.dir_table[i]) + 1
					ptr = section_ptr_add(s1.dwarf_line_section, len)
					C.memmove(ptr, s1.dState.dwarf_line.dir_table[i], len)
				}
			}
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (0)
			}
			for i = 0; i < s1.dState.dwarf_line.filename_size; i++ {
				unsafe {
					len = C.strlen(s1.dState.dwarf_line.filename_table[i].name) + 1
				}
				ptr = section_ptr_add(s1.dwarf_line_section, len)
				unsafe {
					C.memmove(ptr, s1.dState.dwarf_line.filename_table[i].name, len)
				}
				dwarf_uleb128(s1.dwarf_line_section, s1.dState.dwarf_line.filename_table[i].dir_entry)
				dwarf_uleb128(s1.dwarf_line_section, 0)
				dwarf_uleb128(s1.dwarf_line_section, 0)
			}
			{
				p := &char(section_ptr_add((s1.dwarf_line_section), 1))
				*p = (0)
			}
		}
		for i = 0; i < s1.dState.dwarf_line.dir_size; i++ {
			tcc_free(s1.dState.dwarf_line.dir_table[i])
		}
		tcc_free(s1.dState.dwarf_line.dir_table)
		for i = 0; i < s1.dState.dwarf_line.filename_size; i++ {
			tcc_free(s1.dState.dwarf_line.filename_table[i].name)
		}
		tcc_free(s1.dState.dwarf_line.filename_table)
		dwarf_line_op(s1, 0)
		dwarf_uleb128_op(s1, 1)
		dwarf_line_op(s1, dw_lne_end_sequence)
		i = int(s1.dwarf >= 5) * 2
		write32le(&s1.dwarf_line_section.data[s1.dState.dwarf_line.start + 6 + i], s1.dwarf_line_section.data_offset - s1.dState.dwarf_line.start - (
			10 + i))
		section_ptr_add(s1.dwarf_line_section, 3)
		dwarf_reloc(s1.dwarf_line_section, s1.dState.section_sym, 1)
		ptr = section_ptr_add(s1.dwarf_line_section, s1.dState.dwarf_line.line_size - 3)
		unsafe {
			C.memmove(ptr - 3, s1.dState.dwarf_line.line_data, s1.dState.dwarf_line.line_size)
		}
		tcc_free(s1.dState.dwarf_line.line_data)
		unsafe {
			write32le(s1.dwarf_line_section.data + s1.dState.dwarf_line.start, s1.dwarf_line_section.data_offset - s1.dState.dwarf_line.start - 4)
		}
	} else {
		put_stabs_r(s1, (unsafe { nil }), Stab_debug_code.n_so, 0, 0, s1.text_section.data_offset,
			s1.text_section, s1.dState.section_sym)
	}
	tcc_free(s1.dState.debug_hash)
	s1.dState.debug_next_type = 0
}

fn put_new_file(s1 &TCCState) &BufferedFile {
	f := file
	if f.filename[0] == c':' {
		f = f.prev
	}
	if unsafe { f != 0 } && s1.dState.new_file {
		s1.dState.new_file = 0
		s1.dState.last_line_num = s1.dState.new_file
		if s1.dwarf {
			dwarf_file(s1)
		} else { // 3
			put_stabs_r(s1, f.filename, Stab_debug_code.n_sol, 0, 0, ind, s1.text_section,
				s1.dState.section_sym)
		}
	}
	return f
}

fn tcc_debug_putfile(s1 &TCCState, filename &char) {
	if 0 == unsafe { C.strcmp(file.filename, filename) } {
		return
	}
	pstrcpy(file.filename, sizeof([1024]char), filename)
	if !s1.do_debug {
		return
	}
	if s1.dwarf {
		dwarf_file(s1)
	}
	s1.dState.new_file = 1
}

fn tcc_debug_bincl(s1 &TCCState) {
	if !s1.do_debug {
		return
	}
	if s1.dwarf {
		dwarf_file(s1)
	} else { // 3
		put_stabs(s1, file.filename, Stab_debug_code.n_bincl, 0, 0, 0)
	}
	s1.dState.new_file = 1
}

fn tcc_debug_eincl(s1 &TCCState) {
	if !s1.do_debug {
		return
	}
	if s1.dwarf {
		dwarf_file(s1)
	} else { // 3
		put_stabn(s1, Stab_debug_code.n_eincl, 0, 0, 0)
	}
	s1.dState.new_file = 1
}

fn tcc_debug_line(s1 &TCCState) {
	f := &BufferedFile(0)
	if !s1.do_debug {
		return
	}
	if s1.cur_text_section != s1.text_section || nocode_wanted {
		return
	}
	f = put_new_file(s1)
	if !f {
		return
	}
	if s1.dState.last_line_num == f.line_num {
		return
	}
	s1.dState.last_line_num = f.line_num
	if s1.dwarf {
		len_pc := (ind - s1.dState.dwarf_line.last_pc) / 1
		len_line := f.line_num - s1.dState.dwarf_line.last_line
		n := len_pc * 14 + len_line + 13 - -5
		if s1.dState.dwarf_line.cur_file != s1.dState.dwarf_line.last_file {
			s1.dState.dwarf_line.last_file = s1.dState.dwarf_line.cur_file
			dwarf_line_op(s1, dw_lns_set_file)
			dwarf_uleb128_op(s1, s1.dState.dwarf_line.cur_file)
		}
		if len_pc && len_line >= -5 && len_line <= (13 + -5) && n >= 13 && n <= 255 {
			dwarf_line_op(s1, n)
		} else {
			if len_pc {
				n = len_pc * 14 + 0 + 13 - -5
				if n >= 13 && n <= 255 {
					dwarf_line_op(s1, n)
				} else {
					dwarf_line_op(s1, dw_lns_advance_pc)
					dwarf_uleb128_op(s1, len_pc)
				}
			}
			if len_line {
				n = 0 * 14 + len_line + 13 - -5
				if len_line >= -5 && len_line <= (13 + -5) && n >= 13 && n <= 255 {
					dwarf_line_op(s1, n)
				} else {
					dwarf_line_op(s1, dw_lns_advance_line)
					dwarf_sleb128_op(s1, len_line)
				}
			}
		}
		s1.dState.dwarf_line.last_pc = ind
		s1.dState.dwarf_line.last_line = f.line_num
	} else {
		if func_ind != -1 {
			put_stabn(s1, Stab_debug_code.n_sline, 0, f.line_num, ind - func_ind)
		} else {
			put_stabs_r(s1, (unsafe { nil }), Stab_debug_code.n_sline, 0, f.line_num,
				ind, s1.text_section, s1.dState.section_sym)
		}
	}
}

fn tcc_debug_stabs(s1 &TCCState, str &char, type_ int, value u32, sec &Section, sym_index int, info int) {
	s := &Debug_sym(0)
	if s1.dState.debug_info {
		s1.dState.debug_info.sym = &Debug_sym(tcc_realloc(s1.dState.debug_info.sym, sizeof(Debug_sym) * (
			s1.dState.debug_info.n_sym + 1)))
		s = unsafe { s1.dState.debug_info.sym + s1.dState.debug_info.n_sym++ }
		s.type_ = type_
		s.value = value
		s.str = tcc_strdup(str)
		s.sec = sec
		s.sym_index = sym_index
		s.info = info
		s.file = s1.dState.dwarf_line.cur_file
		s.line = file.line_num
	} else if sec {
		put_stabs_r(s1, str, type_, 0, 0, value, sec, sym_index)
	} else { // 3
		put_stabs(s1, str, type_, 0, 0, value)
	}
}

fn tcc_debug_stabn(s1 &TCCState, type_ int, value int) {
	if !s1.do_debug {
		return
	}
	if type_ == Stab_debug_code.n_lbrac {
		info := &debug_info(tcc_mallocz(sizeof(debug_info)))
		info.start = value
		info.parent = s1.dState.debug_info
		if s1.dState.debug_info {
			if s1.dState.debug_info.child {
				if s1.dState.debug_info.child.last {
					s1.dState.debug_info.child.last.next = info
				} else { // 3
					s1.dState.debug_info.child.next = info
				}
				s1.dState.debug_info.child.last = info
			} else { // 3
				s1.dState.debug_info.child = info
			}
		} else { // 3
			s1.dState.debug_info_root = info
		}
		s1.dState.debug_info = info
	} else {
		s1.dState.debug_info.end = value
		s1.dState.debug_info = s1.dState.debug_info.parent
	}
}

fn tcc_debug_find(s1 &TCCState, t &Sym, dwarf int) int {
	i := 0
	if !s1.dState.debug_info && dwarf != 0 && (t.type_.t & 15) == 7 && t.c == -1 {
		for i = 0; i < s1.dState.n_debug_anon_hash; i++ {
			if t == s1.dState.debug_anon_hash[i].type_ {
				return 0
			}
		}
		s1.dState.debug_anon_hash = &debug_anon_hash(tcc_realloc(s1.dState.debug_anon_hash,
			(s1.dState.n_debug_anon_hash + 1) * sizeof(*s1.dState.debug_anon_hash)))
		s1.dState.debug_anon_hash[s1.dState.n_debug_anon_hash].n_debug_type = 0
		s1.dState.debug_anon_hash[s1.dState.n_debug_anon_hash].debug_type = (unsafe { nil })
		s1.dState.debug_anon_hash[s1.dState.n_debug_anon_hash++].type_ = t
		return 0
	}
	for i = 0; i < s1.dState.n_debug_hash; i++ {
		if t == s1.dState.debug_hash[i].type_ {
			return s1.dState.debug_hash[i].debug_type
		}
	}
	return -1
}

fn tcc_debug_check_anon(s1 &TCCState, t &Sym, debug_type int) {
	i := 0
	if !s1.dState.debug_info && (t.type_.t & 15) == 7 && t.type_.ref.c == -1 {
		for i = 0; i < s1.dState.n_debug_anon_hash; i++ {
			if t.type_.ref == s1.dState.debug_anon_hash[i].type_ {
				s1.dState.debug_anon_hash[i].debug_type = tcc_realloc(s1.dState.debug_anon_hash[i].debug_type,
					(s1.dState.debug_anon_hash[i].n_debug_type + 1) * sizeof(int))
				s1.dState.debug_anon_hash[i].debug_type[s1.dState.debug_anon_hash[i].n_debug_type++] = debug_type
			}
		}
	}
}

fn tcc_debug_fix_anon(s1 &TCCState, t &CType) {
	i := 0
	j := 0
	debug_type := 0

	if !(s1.do_debug & 2) || !s1.dwarf || s1.dState.debug_info {
		return
	}
	if (t.t & 15) == 7 && t.ref.c != -1 {
		for i = 0; i < s1.dState.n_debug_anon_hash; i++ {
			if t.ref == s1.dState.debug_anon_hash[i].type_ {
				sym := Sym{
					v: 0
				}

				sym.type_ = *t
				s1.dState.debug_info = &debug_info(t)
				debug_type = tcc_get_dwarf_info(s1, &sym)
				s1.dState.debug_info = (unsafe { nil })
				for j = 0; j < s1.dState.debug_anon_hash[i].n_debug_type; j++ {
					unsafe {
						write32le(s1.dwarf_info_section.data +
							s1.dState.debug_anon_hash[i].debug_type[j], debug_type - s1.dState.dwarf_info.start)
					}
				}
				tcc_free(s1.dState.debug_anon_hash[i].debug_type)
				s1.dState.n_debug_anon_hash--
				for ; i < s1.dState.n_debug_anon_hash; i++ {
					s1.dState.debug_anon_hash[i] = s1.dState.debug_anon_hash[i + 1]
				}
			}
		}
	}
}

fn tcc_debug_add(s1 &TCCState, t &Sym, dwarf int) int {
	offset := if dwarf { s1.dwarf_info_section.data_offset } else { s1.dState.debug_next_type++ + 1 }
	s1.dState.debug_hash = &debug_hash(tcc_realloc(s1.dState.debug_hash, (s1.dState.n_debug_hash + 1) * sizeof(*s1.dState.debug_hash)))
	s1.dState.debug_hash[s1.dState.n_debug_hash].debug_type = offset
	s1.dState.debug_hash[s1.dState.n_debug_hash++].type_ = t
	return offset
}

fn tcc_debug_remove(s1 &TCCState, t &Sym) {
	i := 0
	for i = 0; i < s1.dState.n_debug_hash; i++ {
		if t == s1.dState.debug_hash[i].type_ {
			s1.dState.n_debug_hash--
			for ; i < s1.dState.n_debug_hash; i++ {
				s1.dState.debug_hash[i] = s1.dState.debug_hash[i + 1]
			}
		}
	}
}

fn tcc_get_debug_info(s1 &TCCState, s &Sym, result &CString) {
	type_ := 0
	n := 0
	debug_type := -1
	t := s
	str := strings.new_builder(100)
	for ; true; {
		type_ = t.type_.t & ~((4096 | 8192 | 16384 | 32768) | 256 | 512 | 1024)
		if (type_ & 15) != 1 {
			type_ &= ~32
		}
		if type_ == 5 || type_ == (5 | 64) {
			n++, t.type_.ref
			t = n++
		} else { // 3
			break
		}
	}
	if (type_ & 15) == 7 {
		e := t
		t = t.type_.ref
		debug_type = tcc_debug_find(s1, t, 0)
		if debug_type == -1 {
			debug_type = tcc_debug_add(s1, t, 0)
			cstr_new(&str)
			a1 := if (t.v & ~1073741824) >= 268435456 {
				c''
			} else {
				get_tok_str(t.v & ~1073741824, (unsafe { nil }))
			}
			a2 := if ((t.type_.t & ((((1 << (6 + 6)) - 1) << 20 | 128) | 15)) == (1 << 20 | 7)) {
				`u`
			} else {
				`s`
			}
			cstr_printf(&str, '${a1}:T${debug_type}=${a2}${t.c}')
			for t.next {
				pos := 0
				size := 0
				align := 0

				t = t.next
				if (t.a.nodebug || ((t.v & ~536870912) >= 268435456 && ((t.type_.t & 15) == 1
					|| (t.type_.t & 15) == 11 || (t.type_.t & 15) == 2
					|| (t.type_.t & 15) == 3 || (t.type_.t & 15) == 4))) {
					continue
				}
				cstr_printf(&str, '${get_tok_str(t.v & ~536870912, (unsafe { nil }))}:')
				tcc_get_debug_info(s1, t, &str)
				if t.type_.t & 128 {
					pos = t.c * 8 + (((t.type_.t) >> 20) & 63)
					size = (((t.type_.t) >> (20 + 6)) & 63)
				} else {
					pos = t.c * 8
					size = type_size(&t.type_, &align) * 8
				}
				cstr_printf(&str, ',${pos},${size};')
			}
			cstr_printf(&str, ';')
			tcc_debug_stabs(s1, str.data, Stab_debug_code.n_lsym, 0, (unsafe { nil }),
				0, 0)
			cstr_free(&str)
			if s1.dState.debug_info {
				tcc_debug_remove(s1, e)
			}
		}
	} else if ((type_ & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
		t = t.type_.ref
		e := t
		debug_type = tcc_debug_find(s1, t, 0)
		if debug_type == -1 {
			debug_type = tcc_debug_add(s1, t, 0)
			cstr_new(&str)
			tt2 := if (t.v & ~1073741824) >= 268435456 {
				c''
			} else {
				get_tok_str(t.v & ~1073741824, (unsafe { nil }))
			}
			cstr_printf(&str, '${tt2}:T${debug_type}=e')
			for t.next {
				t = t.next
				tt := if (t.v & ~536870912) >= 268435456 {
					c''
				} else {
					get_tok_str(t.v & ~536870912, (unsafe { nil }))
				}
				cstr_printf(&str, '${tt}:')
				cstr_printf(&str, '${int(t.enum_val)}')
			}
			cstr_printf(&str, ';')
			tcc_debug_stabs(s1, str.data, Stab_debug_code.n_lsym, 0, (unsafe { nil }),
				0, 0)
			cstr_free(&str)
			if s1.dState.debug_info {
				tcc_debug_remove(s1, e)
			}
		}
	} else if (type_ & 15) != 6 {
		type_ &= ~(((1 << (6 + 6)) - 1) << 20 | 128)
		for debug_type = 1; debug_type <= (sizeof(default_debug) / sizeof(default_debug[0])); debug_type++ {
			if default_debug[debug_type - 1].type_ == type_ {
				break
			}
		}
		if debug_type > (sizeof(default_debug) / sizeof(default_debug[0])) {
			return
		}
	}
	if n > 0 {
		cstr_printf(result, '${s1.dState.debug_next_type++}=')
	}
	t = s
	for ; true; {
		type_ = t.type_.t & ~((4096 | 8192 | 16384 | 32768) | 256 | 512 | 1024)
		if (type_ & 15) != 1 {
			type_ &= ~32
		}
		if type_ == 5 {
			cstr_printf(result, '${s1.dState.debug_next_type++}=*')
		} else if type_ == (5 | 64) {
			cstr_printf(result, '${s1.dState.debug_next_type++}=ar1;0;${t.type_.ref.c - 1};')
		} else if type_ == 6 {
			cstr_printf(result, '${s1.dState.debug_next_type++}=f')
			tcc_get_debug_info(s1, t.type_.ref, result)
			return
		} else { // 3
			break
		}
		t = t.type_.ref
	}
	cstr_printf(result, '${debug_type}')
}

fn tcc_get_dwarf_info(s1 &TCCState, s &Sym) int {
	type_ := 0
	debug_type := -1
	e := &Sym(0)
	t := s

	i := 0
	last_pos := -1
	retval := 0
	if s1.dState.new_file {
		put_new_file(s1)
	}
	for ; true; {
		type_ = t.type_.t & ~((4096 | 8192 | 16384 | 32768) | 256 | 512 | 1024)
		if (type_ & 15) != 1 {
			type_ &= ~32
		}
		if type_ == 5 || type_ == (5 | 64) {
			t = t.type_.ref
		} else { // 3
			break
		}
	}
	if (type_ & 15) == 7 {
		t = t.type_.ref
		debug_type = tcc_debug_find(s1, t, 1)
		if debug_type == -1 {
			pos_sib := 0
			i = 0
			pos_type := &int(0)

			debug_type = tcc_debug_add(s1, t, 1)
			e = t
			i = 0
			for e.next {
				e = e.next
				if (e.a.nodebug || ((e.v & ~536870912) >= 268435456 && ((e.type_.t & 15) == 1
					|| (e.type_.t & 15) == 11 || (e.type_.t & 15) == 2
					|| (e.type_.t & 15) == 3 || (e.type_.t & 15) == 4))) {
					continue
				}
				i++
			}
			pos_type = &int(tcc_malloc(i * sizeof(int)))
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (if ((t.type_.t & ((((1 << (6 + 6)) - 1) << 20 | 128) | 15)) == (1 << 20 | 7)) {
					if t.next { 18 } else { 19 }
				} else {
					if t.next { 16 } else { 17 }
				})
			}
			0
			dwarf_strp(s1.dwarf_info_section, if (t.v & ~1073741824) >= 268435456 {
				c''
			} else {
				get_tok_str(t.v & ~1073741824, (unsafe { nil }))
			})
			dwarf_uleb128(s1.dwarf_info_section, t.c)
			dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
			dwarf_uleb128(s1.dwarf_info_section, file.line_num)
			if t.next {
				pos_sib = s1.dwarf_info_section.data_offset
				write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			}
			e = t
			i = 0
			for e.next {
				e = e.next
				if (e.a.nodebug || ((e.v & ~536870912) >= 268435456 && ((e.type_.t & 15) == 1
					|| (e.type_.t & 15) == 11 || (e.type_.t & 15) == 2
					|| (e.type_.t & 15) == 3 || (e.type_.t & 15) == 4))) {
					continue
				}
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (if e.type_.t & 128 { 15 } else { 14 })
				}
				0
				dwarf_strp(s1.dwarf_info_section, get_tok_str(e.v & ~536870912, (unsafe { nil })))
				dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
				dwarf_uleb128(s1.dwarf_info_section, file.line_num)
				pos_type[i++] = s1.dwarf_info_section.data_offset
				write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
				if e.type_.t & 128 {
					pos := e.c * 8 + (((e.type_.t) >> 20) & 63)
					size := (((e.type_.t) >> (20 + 6)) & 63)
					dwarf_uleb128(s1.dwarf_info_section, size)
					dwarf_uleb128(s1.dwarf_info_section, pos)
				} else { // 3
					dwarf_uleb128(s1.dwarf_info_section, e.c)
				}
			}
			if t.next {
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (0)
				}
				unsafe {
					write32le(s1.dwarf_info_section.data + pos_sib, s1.dwarf_info_section.data_offset - s1.dState.dwarf_info.start)
				}
			}
			e = t
			i = 0
			for e.next {
				e = e.next
				if (e.a.nodebug || ((e.v & ~536870912) >= 268435456 && ((e.type_.t & 15) == 1
					|| (e.type_.t & 15) == 11 || (e.type_.t & 15) == 2
					|| (e.type_.t & 15) == 3 || (e.type_.t & 15) == 4))) {
					continue
				}
				type_ = tcc_get_dwarf_info(s1, e)
				tcc_debug_check_anon(s1, e, pos_type[i])
				unsafe {
					write32le(s1.dwarf_info_section.data + pos_type[i++], type_ - s1.dState.dwarf_info.start)
				}
			}
			tcc_free(pos_type)
			if s1.dState.debug_info {
				tcc_debug_remove(s1, t)
			}
		}
	} else if ((type_ & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
		t = t.type_.ref
		debug_type = tcc_debug_find(s1, t, 1)
		if debug_type == -1 {
			pos_sib := 0
			pos_type := 0

			sym := Sym{
				v: 0
			}

			sym.type_.t = 3 | (type_ & 16)
			pos_type = tcc_get_dwarf_info(s1, &sym)
			debug_type = tcc_debug_add(s1, t, 1)
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (13)
			}
			dwarf_strp(s1.dwarf_info_section, if (t.v & ~1073741824) >= 268435456 {
				c''
			} else {
				get_tok_str(t.v & ~1073741824, (unsafe { nil }))
			})
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (if type_ & 16 { dw_ate_unsigned } else { dw_ate_signed })
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (4)
			}
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (pos_type - s1.dState.dwarf_info.start))
			dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
			dwarf_uleb128(s1.dwarf_info_section, file.line_num)
			pos_sib = s1.dwarf_info_section.data_offset
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			e = t
			for e.next {
				e = e.next
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (if type_ & 16 { 12 } else { 11 })
				}
				dwarf_strp(s1.dwarf_info_section, if (e.v & ~536870912) >= 268435456 {
					c''
				} else {
					get_tok_str(e.v & ~536870912, (unsafe { nil }))
				})
				if type_ & 16 {
					dwarf_uleb128(s1.dwarf_info_section, e.enum_val)
				} else { // 3
					dwarf_sleb128(s1.dwarf_info_section, e.enum_val)
				}
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (0)
			}
			unsafe {
				write32le(s1.dwarf_info_section.data + pos_sib, s1.dwarf_info_section.data_offset - s1.dState.dwarf_info.start)
			}
			if s1.dState.debug_info {
				tcc_debug_remove(s1, t)
			}
		}
	} else if (type_ & 15) != 6 {
		type_ &= ~(((1 << (6 + 6)) - 1) << 20 | 128)
		for i = 1; i <= (sizeof(default_debug) / sizeof(default_debug[0])); i++ {
			if default_debug[i - 1].type_ == type_ {
				break
			}
		}
		if i > (sizeof(default_debug) / sizeof(default_debug[0])) {
			return 0
		}
		debug_type = s1.dState.dwarf_info.base_type_used[i - 1]
		if debug_type == 0 {
			name := [100]i8{}
			debug_type = s1.dwarf_info_section.data_offset
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (2)
			}
			dwarf_uleb128(s1.dwarf_info_section, default_debug[i - 1].size)
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (default_debug[i - 1].encoding)
			}
			C.strncpy(name, default_debug[i - 1].name, sizeof(name) - 1)
			unsafe {
				*&char(C.strchr(name, `:`)) = 0
			}
			dwarf_strp(s1.dwarf_info_section, name)
			s1.dState.dwarf_info.base_type_used[i - 1] = debug_type
		}
	}
	retval = debug_type
	e = (unsafe { nil })
	t = s
	for ; true; {
		type_ = t.type_.t & ~((4096 | 8192 | 16384 | 32768) | 256 | 512 | 1024)
		if (type_ & 15) != 1 {
			type_ &= ~32
		}
		if type_ == 5 {
			i = s1.dwarf_info_section.data_offset
			if retval == debug_type {
				retval = i
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (7)
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (8)
			}
			if last_pos != -1 {
				tcc_debug_check_anon(s1, e, last_pos)
				unsafe {
					write32le(s1.dwarf_info_section.data + last_pos, i - s1.dState.dwarf_info.start)
				}
			}
			last_pos = s1.dwarf_info_section.data_offset
			e = t.type_.ref
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
		} else if type_ == (5 | 64) {
			sib_pos := 0
			sub_type := 0

			sym := Sym{
				v: 0
			}

			sym.type_.t = 4 | 2048 | 16
			sub_type = tcc_get_dwarf_info(s1, &sym)
			i = s1.dwarf_info_section.data_offset
			if retval == debug_type {
				retval = i
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (8)
			}
			if last_pos != -1 {
				tcc_debug_check_anon(s1, e, last_pos)
				unsafe {
					write32le(s1.dwarf_info_section.data + last_pos, i - s1.dState.dwarf_info.start)
				}
			}
			last_pos = s1.dwarf_info_section.data_offset
			e = t.type_.ref
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			sib_pos = s1.dwarf_info_section.data_offset
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			for ; true; {
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (9)
				}
				0
				write32le(section_ptr_add((s1.dwarf_info_section), 4), (sub_type - s1.dState.dwarf_info.start))
				dwarf_uleb128(s1.dwarf_info_section, t.type_.ref.c - 1)
				s = t.type_.ref
				type_ = s.type_.t & ~((4096 | 8192 | 16384 | 32768) | 256 | 512)
				if type_ != (5 | 64) {
					break
				}
				t = s
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (0)
			}
			unsafe {
				write32le(s1.dwarf_info_section.data + sib_pos, s1.dwarf_info_section.data_offset - s1.dState.dwarf_info.start)
			}
		} else if type_ == 6 {
			sib_pos := 0
			pos_type := &int(0)

			f := &Sym(0)
			i = s1.dwarf_info_section.data_offset
			debug_type = tcc_get_dwarf_info(s1, t.type_.ref)
			if retval == debug_type {
				retval = i
			}
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (if t.type_.ref.next { 24 } else { 25 })
			}
			if last_pos != -1 {
				tcc_debug_check_anon(s1, e, last_pos)
				write32le(s1.dwarf_info_section.data + last_pos, i - s1.dState.dwarf_info.start)
			}
			last_pos = s1.dwarf_info_section.data_offset
			e = t.type_.ref
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			if t.type_.ref.next {
				sib_pos = s1.dwarf_info_section.data_offset
				write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			}
			f = t.type_.ref
			i = 0
			for f.next {
				f = f.next
				i++
			}
			pos_type = &int(tcc_malloc(i * sizeof(int)))
			f = t.type_.ref
			i = 0
			for f.next {
				f = f.next
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (26)
				}
				0
				pos_type[i++] = s1.dwarf_info_section.data_offset
				write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
			}
			if t.type_.ref.next {
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (0)
				}
				unsafe {
					write32le(s1.dwarf_info_section.data + sib_pos, s1.dwarf_info_section.data_offset - s1.dState.dwarf_info.start)
				}
			}
			f = t.type_.ref
			i = 0
			for f.next {
				f = f.next
				type_ = tcc_get_dwarf_info(s1, f)
				tcc_debug_check_anon(s1, f, pos_type[i])
				unsafe {
					write32le(s1.dwarf_info_section.data + pos_type[i++], type_ - s1.dState.dwarf_info.start)
				}
			}
			tcc_free(pos_type)
		} else {
			if last_pos != -1 {
				tcc_debug_check_anon(s1, e, last_pos)
				unsafe {
					write32le(s1.dwarf_info_section.data + last_pos, debug_type - s1.dState.dwarf_info.start)
				}
			}
			break
		}
		t = t.type_.ref
	}
	return retval
}

fn tcc_debug_finish(s1 &TCCState, cur &debug_info) {
	for cur {
		next := cur.next
		i := 0
		if s1.dwarf {
			for i = cur.n_sym - 1; i >= 0; i-- {
				s := &cur.sym[i]
				{
					p := &char(section_ptr_add((s1.dwarf_info_section), 1))
					*p = (if s.type_ == Stab_debug_code.n_psym {
						6
					} else {
						if s.type_ == Stab_debug_code.n_gsym {
							3
						} else {
							if s.type_ == Stab_debug_code.n_stsym { 4 } else { 5 }
						}
					})
				}
				dwarf_strp(s1.dwarf_info_section, s.str)
				if s.type_ == Stab_debug_code.n_gsym || s.type_ == Stab_debug_code.n_stsym {
					dwarf_uleb128(s1.dwarf_info_section, s.file)
					dwarf_uleb128(s1.dwarf_info_section, s.line)
				}
				write32le(section_ptr_add((s1.dwarf_info_section), 4), (s.info - s1.dState.dwarf_info.start))
				if s.type_ == Stab_debug_code.n_gsym || s.type_ == Stab_debug_code.n_stsym {
					if s.type_ == Stab_debug_code.n_gsym {
						p := &char(section_ptr_add((s1.dwarf_info_section), 1))
						*p = (1)
					}
					{
						p := &char(section_ptr_add((s1.dwarf_info_section), 1))
						*p = (8 + 1)
					}
					{
						p := &char(section_ptr_add((s1.dwarf_info_section), 1))
						*p = dw_op_addr
					}
					if s.type_ == Stab_debug_code.n_stsym {
						dwarf_reloc(s1.dwarf_info_section, s1.dState.section_sym, 1)
					}
					write64le(section_ptr_add((s1.dwarf_info_section), 8), (s.value))
				} else {
					{
						p := &char(section_ptr_add((s1.dwarf_info_section), 1))
						*p = (dwarf_sleb128_size(s.value) + 1)
					}
					{
						p := &char(section_ptr_add((s1.dwarf_info_section), 1))
						*p = dw_op_fbreg
					}
					dwarf_sleb128(s1.dwarf_info_section, s.value)
				}
				tcc_free(s.str)
			}
			tcc_free(cur.sym)
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (if cur.child { 22 } else { 23 })
			}
			0
			dwarf_reloc(s1.dwarf_info_section, s1.dState.section_sym, 1)
			write64le(section_ptr_add((s1.dwarf_info_section), 8), (func_ind + cur.start))
			write64le(section_ptr_add((s1.dwarf_info_section), 8), (cur.end - cur.start))
			tcc_debug_finish(s1, cur.child)
			if cur.child {
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (0)
			}
			0
		} else {
			for i = 0; i < cur.n_sym; i++ {
				s := &cur.sym[i]
				if s.sec {
					put_stabs_r(s1, s.str, s.type_, 0, 0, s.value, s.sec, s.sym_index)
				} else { // 3
					put_stabs(s1, s.str, s.type_, 0, 0, s.value)
				}
				tcc_free(s.str)
			}
			tcc_free(cur.sym)
			put_stabn(s1, Stab_debug_code.n_lbrac, 0, 0, cur.start)
			tcc_debug_finish(s1, cur.child)
			put_stabn(s1, Stab_debug_code.n_rbrac, 0, 0, cur.end)
		}
		tcc_free(cur)
		cur = next
	}
}

fn tcc_add_debug_info(s1 &TCCState, param int, s &Sym, e &Sym) {
	debug_str := strings.new_builder(100)
	if !(s1.do_debug & 2) {
		return
	}
	cstr_new(&debug_str)
	for ; s != e; s = s.prev {
		if !s.v || (s.r & 63) != 50 {
			continue
		}
		if s1.dwarf {
			tcc_debug_stabs(s1, get_tok_str(s.v, (unsafe { nil })), if param {
				Stab_debug_code.n_psym
			} else {
				Stab_debug_code.n_lsym
			}, s.c, (unsafe { nil }), 0, tcc_get_dwarf_info(s1, s))
		} else {
			cstr_reset(&debug_str)
			t := if param {
				c'p'
			} else {
				c''
			}
			cstr_printf(&debug_str, '${get_tok_str(s.v, (unsafe { nil }))}:${t}')
			tcc_get_debug_info(s1, s, &debug_str)
			tcc_debug_stabs(s1, debug_str.data, if param {
				Stab_debug_code.n_psym
			} else {
				Stab_debug_code.n_lsym
			}, s.c, (unsafe { nil }), 0, 0)
		}
	}
	cstr_free(&debug_str)
}

fn tcc_debug_funcstart(s1 &TCCState, sym &Sym) {
	debug_str := strings.new_builder(100)
	f := &BufferedFile(0)
	if !s1.do_debug {
		return
	}
	s1.dState.debug_info_root = (unsafe { nil })
	s1.dState.debug_info = (unsafe { nil })
	tcc_debug_stabn(s1, Stab_debug_code.n_lbrac, ind - func_ind)
	f = put_new_file(s1)
	if !f {
		return
	}
	if s1.dwarf {
		tcc_debug_line(s1)
		s1.dState.dwarf_info.func = sym
		s1.dState.dwarf_info.line = file.line_num
		if s1.do_backtrace {
			i := 0
			len := 0

			dwarf_line_op(s1, 0)
			dwarf_uleb128_op(s1, unsafe { C.strlen(funcname) + 2 })
			dwarf_line_op(s1, dw_lne_hi_user - 1)
			len = unsafe { C.strlen(funcname) + 1 }
			for i = 0; i < len; i++ {
				dwarf_line_op(s1, funcname[i])
			}
		}
	} else {
		cstr_new(&debug_str)
		t := if sym.type_.t & 8192 { `f` } else { `F` }
		cstr_printf(&debug_str, '${funcname}:${t}')
		tcc_get_debug_info(s1, sym.type_.ref, &debug_str)
		put_stabs_r(s1, debug_str.data, Stab_debug_code.n_fun, 0, f.line_num, 0, s1.cur_text_section,
			sym.c)
		cstr_free(&debug_str)
		tcc_debug_line(s1)
	}
}

fn tcc_debug_prolog_epilog(s1 &TCCState, value int) {
	if !s1.do_debug {
		return
	}
	if s1.dwarf {
		dwarf_line_op(s1, if value == 0 {
			dw_lns_set_prologue_end
		} else {
			dw_lns_set_epilogue_begin
		})
	}
}

fn tcc_debug_funcend(s1 &TCCState, size int) {
	min_instr_len := 0
	if !s1.do_debug {
		return
	}
	min_instr_len = if s1.dState.dwarf_line.last_pc == ind { 0 } else { 1 }
	ind -= min_instr_len
	tcc_debug_line(s1)
	ind += min_instr_len
	tcc_debug_stabn(s1, Stab_debug_code.n_rbrac, size)
	if s1.dwarf {
		func_sib := 0
		sym := s1.dState.dwarf_info.func
		n_debug_info := tcc_get_dwarf_info(s1, sym.type_.ref)
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (if sym.type_.t & 8192 { 21 } else { 20 })
		}
		if (sym.type_.t & 8192) == 0 {
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (1)
		}

		dwarf_strp(s1.dwarf_info_section, funcname)
		dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
		dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_info.line)
		tcc_debug_check_anon(s1, sym.type_.ref, s1.dwarf_info_section.data_offset)
		write32le(section_ptr_add((s1.dwarf_info_section), 4), (n_debug_info - s1.dState.dwarf_info.start))
		dwarf_reloc(s1.dwarf_info_section, s1.dState.section_sym, 1)
		write64le(section_ptr_add((s1.dwarf_info_section), 8), func_ind)
		write64le(section_ptr_add((s1.dwarf_info_section), 8), size)
		func_sib = s1.dwarf_info_section.data_offset
		write32le(section_ptr_add((s1.dwarf_info_section), 4), (0))
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (1)
		}
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = dw_op_reg6
		}
		tcc_debug_finish(s1, s1.dState.debug_info_root)
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (0)
		}
		unsafe {
			write32le(s1.dwarf_info_section.data + func_sib, s1.dwarf_info_section.data_offset - s1.dState.dwarf_info.start)
		}
	} else {
		tcc_debug_finish(s1, s1.dState.debug_info_root)
	}
	s1.dState.debug_info_root = 0
}

fn tcc_debug_extern_sym(s1 &TCCState, sym &Sym, sh_num int, sym_bind int, sym_type int) {
	if !(s1.do_debug & 2) {
		return
	}
	if sym_type == 2 || sym.v >= 268435456 {
		return
	}
	if s1.dwarf {
		debug_type := 0
		debug_type = tcc_get_dwarf_info(s1, sym)
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (if sym_bind == 1 { 3 } else { 4 })
		}
		dwarf_strp(s1.dwarf_info_section, get_tok_str(sym.v, (unsafe { nil })))
		dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
		dwarf_uleb128(s1.dwarf_info_section, file.line_num)
		tcc_debug_check_anon(s1, sym, s1.dwarf_info_section.data_offset)
		write32le(section_ptr_add((s1.dwarf_info_section), 4), (debug_type - s1.dState.dwarf_info.start))
		if sym_bind == 1 {
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (1)
		}

		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = (8 + 1)
		}
		{
			p := &char(section_ptr_add((s1.dwarf_info_section), 1))
			*p = dw_op_addr
		}
		greloca(s1.dwarf_info_section, sym, s1.dwarf_info_section.data_offset, 1, 0)
		write64le(section_ptr_add((s1.dwarf_info_section), 8), (0))
	} else {
		s := if sh_num == 65522 { s1.common_section } else { s1.sections[sh_num] }
		str := strings.new_builder(100)
		cstr_new(&str)
		t := if sym_bind == 1 {
			`G`
		} else {
			if func_ind != -1 { `V` } else { `S` }
		}
		cstr_printf(&str, '${get_tok_str(sym.v, (unsafe { nil }))}:${t}')
		tcc_get_debug_info(s1, sym, &str)
		if sym_bind == 1 {
			tcc_debug_stabs(s1, str.data, Stab_debug_code.n_gsym, 0, (unsafe { nil }),
				0, 0)
		} else { // 3
			tcc_debug_stabs(s1, str.data, if sym.type_.t & 8192 && s1.data_section == s {
				Stab_debug_code.n_stsym
			} else {
				Stab_debug_code.n_lcsym
			}, 0, s, sym.c, 0)
		}
		cstr_free(&str)
	}
}

fn tcc_debug_typedef(s1 &TCCState, sym &Sym) {
	if !(s1.do_debug & 2) {
		return
	}
	if s1.dwarf {
		debug_type := 0
		debug_type = tcc_get_dwarf_info(s1, sym)
		if debug_type != -1 {
			{
				p := &char(section_ptr_add((s1.dwarf_info_section), 1))
				*p = (10)
			}
			0
			dwarf_strp(s1.dwarf_info_section, get_tok_str(sym.v & ~536870912, (unsafe { nil })))
			dwarf_uleb128(s1.dwarf_info_section, s1.dState.dwarf_line.cur_file)
			dwarf_uleb128(s1.dwarf_info_section, file.line_num)
			tcc_debug_check_anon(s1, sym, s1.dwarf_info_section.data_offset)
			write32le(section_ptr_add((s1.dwarf_info_section), 4), (debug_type - s1.dState.dwarf_info.start))
		}
	} else {
		str := strings.new_builder(100)
		cstr_new(&str)
		tmp := if (sym.v & ~536870912) >= 268435456 {
			c''
		} else {
			get_tok_str(sym.v & ~536870912, (unsafe { nil }))
		}
		cstr_printf(&str, '${tmp}:t')
		tcc_get_debug_info(s1, sym, &str)
		tcc_debug_stabs(s1, str.data, Stab_debug_code.n_lsym, 0, (unsafe { nil }), 0,
			0)
		cstr_free(&str)
	}
}

fn tcc_tcov_block_begin(s1 &TCCState) {
	sv := SValue{}
	ptr := &voidptr(0)
	last_offset := s1.dState.tcov_data.offset
	tcc_tcov_block_end(tcc_state, 0)
	if s1.test_coverage == 0 || nocode_wanted {
		return
	}
	if s1.dState.tcov_data.last_file_name == 0
		|| unsafe { C.strcmp(&char((s1.tcov_section.data + s1.dState.tcov_data.last_file_name)), file.truefilename) != 0 } {
		wd := [1024]i8{}
		cstr := strings.new_builder(100)
		if s1.dState.tcov_data.last_func_name {
			section_ptr_add(s1.tcov_section, 1)
		}
		if s1.dState.tcov_data.last_file_name {
			section_ptr_add(s1.tcov_section, 1)
		}
		s1.dState.tcov_data.last_func_name = 0
		cstr_new(&cstr)
		if file.truefilename[0] == c'/' {
			s1.dState.tcov_data.last_file_name = s1.tcov_section.data_offset
			cstr_printf(&cstr, '${file.truefilename}')
		} else {
			C.getcwd(wd, sizeof(wd))
			s1.dState.tcov_data.last_file_name = s1.tcov_section.data_offset +
				unsafe { C.strlen(wd) } + 1
			cstr_printf(&cstr, '${wd}/${file.truefilename}')
		}
		ptr = section_ptr_add(s1.tcov_section, cstr.len + 1)
		unsafe { C.strcpy(&char(ptr), cstr.data) }
		cstr_free(&cstr)
	}
	if s1.dState.tcov_data.last_func_name == 0
		|| unsafe { C.strcmp(&char((s1.tcov_section.data + s1.dState.tcov_data.last_func_name)), funcname) != 0 } {
		len := usize(0)
		if s1.dState.tcov_data.last_func_name {
			section_ptr_add(s1.tcov_section, 1)
		}
		s1.dState.tcov_data.last_func_name = s1.tcov_section.data_offset
		len = unsafe { C.strlen(funcname) }
		ptr = section_ptr_add(s1.tcov_section, len + 1)
		C.strcpy(&char(ptr), funcname)
		section_ptr_add(s1.tcov_section, -s1.tcov_section.data_offset & 7)
		ptr = section_ptr_add(s1.tcov_section, 8)
		write64le(ptr, file.line_num)
	}
	if ind == s1.dState.tcov_data.ind && s1.dState.tcov_data.line == file.line_num {
		s1.dState.tcov_data.offset = last_offset
	} else {
		label := Sym{
			v: 0
		}

		label.type_.t = 4 | 8192
		ptr = section_ptr_add(s1.tcov_section, 16)
		s1.dState.tcov_data.line = file.line_num
		write64le(ptr, (s1.dState.tcov_data.line << 8) | 255)
		unsafe {
			put_extern_sym(&label, s1.tcov_section, (&u8(ptr) - s1.tcov_section.data) + 8,
				0)
		}
		sv.type_ = label.type_
		sv.r = 512 | 256 | 48
		sv.r2 = 48
		sv.c.i = 0
		sv.sym = &label
		gen_increment_tcov(&sv)
		unsafe {
			s1.dState.tcov_data.offset = &u8(ptr) - s1.tcov_section.data
		}
		s1.dState.tcov_data.ind = ind
	}
}

fn tcc_tcov_block_end(s1 &TCCState, line int) {
	if s1.test_coverage == 0 {
		return
	}
	if line == -1 {
		line = s1.dState.tcov_data.line
	}
	if s1.dState.tcov_data.offset {
		ptr := unsafe { s1.tcov_section.data + s1.dState.tcov_data.offset }
		nline := if line { line } else { file.line_num }
		mut val := (read64le(ptr) & 68719476735)
		val |= (nline << 36)
		write64le(ptr, val)
		s1.dState.tcov_data.offset = 0
	}
}

fn tcc_tcov_check_line(s1 &TCCState, start int) {
	if s1.test_coverage == 0 {
		return
	}
	if s1.dState.tcov_data.line != file.line_num {
		if (s1.dState.tcov_data.line + 1) != file.line_num {
			tcc_tcov_block_end(s1, -1)
			if start {
				tcc_tcov_block_begin(s1)
			}
		} else { // 3
			s1.dState.tcov_data.line = file.line_num
		}
	}
}

fn tcc_tcov_start(s1 &TCCState) {
	if s1.test_coverage == 0 {
		return
	}
	if !s1.dState {
		s1.dState = tcc_mallocz(sizeof(*s1.dState))
	}
	unsafe {
		C.memset(&s1.dState.tcov_data, 0, sizeof(s1.dState.tcov_data))
	}
	if s1.tcov_section == (unsafe { nil }) {
		s1.tcov_section = new_section(tcc_state, c'.tcov', 1, (1 << 1) | (1 << 0))
		section_ptr_add(s1.tcov_section, 4)
	}
}

fn tcc_tcov_end(s1 &TCCState) {
	if s1.test_coverage == 0 {
		return
	}
	if s1.dState.tcov_data.last_func_name {
		section_ptr_add(s1.tcov_section, 1)
	}
	if s1.dState.tcov_data.last_file_name {
		section_ptr_add(s1.tcov_section, 1)
	}
}

fn tcc_tcov_reset_ind(s1 &TCCState) {
	s1.dState.tcov_data.ind = 0
}
