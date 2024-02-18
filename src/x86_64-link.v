@[translated]
module main

struct Lldiv_t { 
	quot i64
	rem i64
}
type U_int8_t = u8
type U_int16_t = u16
type U_int32_t = u32
type U_int64_t = u32
struct Random_data { 
	fptr &int
	rptr &int
	state &int
	rand_type int
	rand_deg int
	rand_sep int
	end_ptr &int
}
struct Drand48_data { 
	__x [3]u16
	__old_x [3]u16
	__c u16
	__init u16
	__a i64
}
fn abort() 

fn abort() 

type Comparison_fn_t = Compar_fn_t

const ( // empty enum
	fp_int_upward = 0
	fp_int_downward = 1
	fp_int_towardzero = 2
	fp_int_tonearestfromzero = 3
	fp_int_tonearest = 4
)


const ( // empty enum
	fp_nan = 0
	fp_infinite = 1
	fp_zero = 2
	fp_subnormal = 3
	fp_normal = 4
)

fn creat(__file &i8, __mode Mode_t) int

type Sigjmp_buf = [1]jmp_buf_tag
fn link(__from &i8, __to &i8) int

enum __itimer_which {
	itimer_real = 0
	itimer_virtual = 1
	itimer_prof = 2
}

struct Itimer_which_t { 
	it_interval Timeval
	it_value Timeval
}
struct Dl_info { 
	dli_fname &i8
	dli_fbase voidptr
	dli_sname &i8
	dli_saddr voidptr
}

const ( // empty enum
	rtld_dl_syment = 1
	rtld_dl_linkmap = 2
)


const ( // empty enum
	rtld_di_lmid = 1
	rtld_di_linkmap = 2
	rtld_di_configaddr = 3
	rtld_di_serinfo = 4
	rtld_di_serinfosize = 5
	rtld_di_origin = 6
	rtld_di_profilename = 7
	rtld_di_profileout = 8
	rtld_di_tls_modid = 9
	rtld_di_tls_data = 10
	rtld_di_max = 10
)

struct Dl_serpath { 
	dls_name &i8
	dls_flags u32
}
struct Dl_serinfo { 
	dls_size usize
	dls_cnt u32
	dls_serpath [1]Dl_serpath
}
type TCCErrorFunc = fn (voidptr, &i8)
type TCCReallocFunc = fn (voidptr, usize) voidptr
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
type Elf32_Versym = Elf32_Half
type Elf64_Versym = Elf64_Half
struct Elf32_Ehdr { 
	e_ident [16]u8
	e_type Elf32_Half
	e_machine Elf32_Half
	e_version Elf32_Word
	e_entry Elf32_Addr
	e_phoff Elf32_Off
	e_shoff Elf32_Off
	e_flags Elf32_Word
	e_ehsize Elf32_Half
	e_phentsize Elf32_Half
	e_phnum Elf32_Half
	e_shentsize Elf32_Half
	e_shnum Elf32_Half
	e_shstrndx Elf32_Half
}
struct Elf64_Ehdr { 
	e_ident [16]u8
	e_type Elf64_Half
	e_machine Elf64_Half
	e_version Elf64_Word
	e_entry Elf64_Addr
	e_phoff Elf64_Off
	e_shoff Elf64_Off
	e_flags Elf64_Word
	e_ehsize Elf64_Half
	e_phentsize Elf64_Half
	e_phnum Elf64_Half
	e_shentsize Elf64_Half
	e_shnum Elf64_Half
	e_shstrndx Elf64_Half
}
struct Elf32_Shdr { 
	sh_name Elf32_Word
	sh_type Elf32_Word
	sh_flags Elf32_Word
	sh_addr Elf32_Addr
	sh_offset Elf32_Off
	sh_size Elf32_Word
	sh_link Elf32_Word
	sh_info Elf32_Word
	sh_addralign Elf32_Word
	sh_entsize Elf32_Word
}
struct Elf64_Shdr { 
	sh_name Elf64_Word
	sh_type Elf64_Word
	sh_flags Elf64_Xword
	sh_addr Elf64_Addr
	sh_offset Elf64_Off
	sh_size Elf64_Xword
	sh_link Elf64_Word
	sh_info Elf64_Word
	sh_addralign Elf64_Xword
	sh_entsize Elf64_Xword
}
struct Elf32_Sym { 
	st_name Elf32_Word
	st_value Elf32_Addr
	st_size Elf32_Word
	st_info u8
	st_other u8
	st_shndx Elf32_Section
}
struct Elf64_Sym { 
	st_name Elf64_Word
	st_info u8
	st_other u8
	st_shndx Elf64_Section
	st_value Elf64_Addr
	st_size Elf64_Xword
}
struct Elf32_Syminfo { 
	si_boundto Elf32_Half
	si_flags Elf32_Half
}
struct Elf64_Syminfo { 
	si_boundto Elf64_Half
	si_flags Elf64_Half
}
struct Elf32_Rel { 
	r_offset Elf32_Addr
	r_info Elf32_Word
}
struct Elf64_Rel { 
	r_offset Elf64_Addr
	r_info Elf64_Xword
}
struct Elf32_Rela { 
	r_offset Elf32_Addr
	r_info Elf32_Word
	r_addend Elf32_Sword
}
struct Elf64_Rela { 
	r_offset Elf64_Addr
	r_info Elf64_Xword
	r_addend Elf64_Sxword
}
struct Elf32_Phdr { 
	p_type Elf32_Word
	p_offset Elf32_Off
	p_vaddr Elf32_Addr
	p_paddr Elf32_Addr
	p_filesz Elf32_Word
	p_memsz Elf32_Word
	p_flags Elf32_Word
	p_align Elf32_Word
}
struct Elf64_Phdr { 
	p_type Elf64_Word
	p_flags Elf64_Word
	p_offset Elf64_Off
	p_vaddr Elf64_Addr
	p_paddr Elf64_Addr
	p_filesz Elf64_Xword
	p_memsz Elf64_Xword
	p_align Elf64_Xword
}
struct Elf32_Dyn { 
	d_tag Elf32_Sword
	d_un Union (unnamed union at ./elf.h
}
struct Elf64_Dyn { 
	d_tag Elf64_Sxword
	d_un Union (unnamed union at ./elf.h
}
struct Elf32_Verdef { 
	vd_version Elf32_Half
	vd_flags Elf32_Half
	vd_ndx Elf32_Half
	vd_cnt Elf32_Half
	vd_hash Elf32_Word
	vd_aux Elf32_Word
	vd_next Elf32_Word
}
struct Elf64_Verdef { 
	vd_version Elf64_Half
	vd_flags Elf64_Half
	vd_ndx Elf64_Half
	vd_cnt Elf64_Half
	vd_hash Elf64_Word
	vd_aux Elf64_Word
	vd_next Elf64_Word
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
	vn_cnt Elf32_Half
	vn_file Elf32_Word
	vn_aux Elf32_Word
	vn_next Elf32_Word
}
struct Elf64_Verneed { 
	vn_version Elf64_Half
	vn_cnt Elf64_Half
	vn_file Elf64_Word
	vn_aux Elf64_Word
	vn_next Elf64_Word
}
struct Elf32_Vernaux { 
	vna_hash Elf32_Word
	vna_flags Elf32_Half
	vna_other Elf32_Half
	vna_name Elf32_Word
	vna_next Elf32_Word
}
struct Elf64_Vernaux { 
	vna_hash Elf64_Word
	vna_flags Elf64_Half
	vna_other Elf64_Half
	vna_name Elf64_Word
	vna_next Elf64_Word
}
struct Elf32_auxv_t { 
	a_type u32
	a_un Union (unnamed union at ./elf.h
}
struct Elf64_auxv_t { 
	a_type u64
	a_un Union (unnamed union at ./elf.h
}
struct Elf32_Nhdr { 
	n_namesz Elf32_Word
	n_descsz Elf32_Word
	n_type Elf32_Word
}
struct Elf64_Nhdr { 
	n_namesz Elf64_Word
	n_descsz Elf64_Word
	n_type Elf64_Word
}
struct Elf32_Move { 
	m_value Elf32_Xword
	m_info Elf32_Word
	m_poffset Elf32_Word
	m_repeat Elf32_Half
	m_stride Elf32_Half
}
struct Elf64_Move { 
	m_value Elf64_Xword
	m_info Elf64_Xword
	m_poffset Elf64_Xword
	m_repeat Elf64_Half
	m_stride Elf64_Half
}
union Elf32_gptab { 
	gt_header  struct {	gt_current_g_value Elf32_Word
	gt_unused Elf32_Word
}

	gt_entry  struct {	gt_g_value Elf32_Word
	gt_bytes Elf32_Word
}

}
struct Elf32_RegInfo { 
	ri_gprmask Elf32_Word
	ri_cprmask [4]Elf32_Word
	ri_gp_value Elf32_Sword
}
struct Elf_Options { 
	kind u8
	size u8
	section Elf32_Section
	info Elf32_Word
}
struct Elf_Options_Hw { 
	hwp_flags1 Elf32_Word
	hwp_flags2 Elf32_Word
}
struct Elf32_Lib { 
	l_name Elf32_Word
	l_time_stamp Elf32_Word
	l_checksum Elf32_Word
	l_version Elf32_Word
	l_flags Elf32_Word
}
struct Elf64_Lib { 
	l_name Elf64_Word
	l_time_stamp Elf64_Word
	l_checksum Elf64_Word
	l_version Elf64_Word
	l_flags Elf64_Word
}
type Elf32_Conflict = Elf32_Addr
enum __stab_debug_code {
	n_gsym = 32
	n_fname = 34
	n_fun = 36
	n_stsym = 38
	n_lcsym = 40
	n_main = 42
	n_pc = 48
	n_nsyms = 50
	n_nomap = 52
	n_obj = 56
	n_opt = 60
	n_rsym = 64
	n_m2c = 66
	n_sline = 68
	n_dsline = 70
	n_bsline = 72
	n_brows = 72
	n_defd = 74
	n_ehdecl = 80
	n_mod2 = 80
	n_catch = 84
	n_ssym = 96
	n_so = 100
	n_lsym = 128
	n_bincl = 130
	n_sol = 132
	n_psym = 160
	n_eincl = 162
	n_entry = 164
	n_lbrac = 192
	n_excl = 194
	n_scope = 196
	n_rbrac = 224
	n_bcomm = 226
	n_ecomm = 228
	n_ecoml = 232
	n_nbtext = 240
	n_nbdata = 242
	n_nbbss = 244
	n_nbsts = 246
	n_nblcs = 248
	n_leng = 254
	last_unused_stab_code
}


const ( // empty enum
	dw_ut_compile = 1
	dw_ut_type = 2
	dw_ut_partial = 3
	dw_ut_skeleton = 4
	dw_ut_split_compile = 5
	dw_ut_split_type = 6
	dw_ut_lo_user = 128
	dw_ut_hi_user = 255
)


const ( // empty enum
	dw_tag_array_type = 1
	dw_tag_class_type = 2
	dw_tag_entry_point = 3
	dw_tag_enumeration_type = 4
	dw_tag_formal_parameter = 5
	dw_tag_imported_declaration = 8
	dw_tag_label = 10
	dw_tag_lexical_block = 11
	dw_tag_member = 13
	dw_tag_pointer_type = 15
	dw_tag_reference_type = 16
	dw_tag_compile_unit = 17
	dw_tag_string_type = 18
	dw_tag_structure_type = 19
	dw_tag_subroutine_type = 21
	dw_tag_typedef = 22
	dw_tag_union_type = 23
	dw_tag_unspecified_parameters = 24
	dw_tag_variant = 25
	dw_tag_common_block = 26
	dw_tag_common_inclusion = 27
	dw_tag_inheritance = 28
	dw_tag_inlined_subroutine = 29
	dw_tag_module = 30
	dw_tag_ptr_to_member_type = 31
	dw_tag_set_type = 32
	dw_tag_subrange_type = 33
	dw_tag_with_stmt = 34
	dw_tag_access_declaration = 35
	dw_tag_base_type = 36
	dw_tag_catch_block = 37
	dw_tag_const_type = 38
	dw_tag_constant = 39
	dw_tag_enumerator = 40
	dw_tag_file_type = 41
	dw_tag_friend = 42
	dw_tag_namelist = 43
	dw_tag_namelist_item = 44
	dw_tag_packed_type = 45
	dw_tag_subprogram = 46
	dw_tag_template_type_parameter = 47
	dw_tag_template_value_parameter = 48
	dw_tag_thrown_type = 49
	dw_tag_try_block = 50
	dw_tag_variant_part = 51
	dw_tag_variable = 52
	dw_tag_volatile_type = 53
	dw_tag_dwarf_procedure = 54
	dw_tag_restrict_type = 55
	dw_tag_interface_type = 56
	dw_tag_namespace = 57
	dw_tag_imported_module = 58
	dw_tag_unspecified_type = 59
	dw_tag_partial_unit = 60
	dw_tag_imported_unit = 61
	dw_tag_condition = 63
	dw_tag_shared_type = 64
	dw_tag_type_unit = 65
	dw_tag_rvalue_reference_type = 66
	dw_tag_template_alias = 67
	dw_tag_coarray_type = 68
	dw_tag_generic_subrange = 69
	dw_tag_dynamic_type = 70
	dw_tag_atomic_type = 71
	dw_tag_call_site = 72
	dw_tag_call_site_parameter = 73
	dw_tag_skeleton_unit = 74
	dw_tag_immutable_type = 75
	dw_tag_lo_user = 16512
	dw_tag_mips_loop = 16513
	dw_tag_format_label = 16641
	dw_tag_function_template = 16642
	dw_tag_class_template = 16643
	dw_tag_gnu_bincl = 16644
	dw_tag_gnu_eincl = 16645
	dw_tag_gnu_template_template_param = 16646
	dw_tag_gnu_template_parameter_pack = 16647
	dw_tag_gnu_formal_parameter_pack = 16648
	dw_tag_gnu_call_site = 16649
	dw_tag_gnu_call_site_parameter = 16650
	dw_tag_hi_user = 65535
)


const ( // empty enum
	dw_children_no = 0
	dw_children_yes = 1
)


const ( // empty enum
	dw_at_sibling = 1
	dw_at_location = 2
	dw_at_name = 3
	dw_at_ordering = 9
	dw_at_byte_size = 11
	dw_at_bit_offset = 12
	dw_at_bit_size = 13
	dw_at_stmt_list = 16
	dw_at_low_pc = 17
	dw_at_high_pc = 18
	dw_at_language = 19
	dw_at_discr = 21
	dw_at_discr_value = 22
	dw_at_visibility = 23
	dw_at_import = 24
	dw_at_string_length = 25
	dw_at_common_reference = 26
	dw_at_comp_dir = 27
	dw_at_const_value = 28
	dw_at_containing_type = 29
	dw_at_default_value = 30
	dw_at_inline = 32
	dw_at_is_optional = 33
	dw_at_lower_bound = 34
	dw_at_producer = 37
	dw_at_prototyped = 39
	dw_at_return_addr = 42
	dw_at_start_scope = 44
	dw_at_bit_stride = 46
	dw_at_upper_bound = 47
	dw_at_abstract_origin = 49
	dw_at_accessibility = 50
	dw_at_address_class = 51
	dw_at_artificial = 52
	dw_at_base_types = 53
	dw_at_calling_convention = 54
	dw_at_count = 55
	dw_at_data_member_location = 56
	dw_at_decl_column = 57
	dw_at_decl_file = 58
	dw_at_decl_line = 59
	dw_at_declaration = 60
	dw_at_discr_list = 61
	dw_at_encoding = 62
	dw_at_external = 63
	dw_at_frame_base = 64
	dw_at_friend = 65
	dw_at_identifier_case = 66
	dw_at_macro_info = 67
	dw_at_namelist_item = 68
	dw_at_priority = 69
	dw_at_segment = 70
	dw_at_specification = 71
	dw_at_static_link = 72
	dw_at_type = 73
	dw_at_use_location = 74
	dw_at_variable_parameter = 75
	dw_at_virtuality = 76
	dw_at_vtable_elem_location = 77
	dw_at_allocated = 78
	dw_at_associated = 79
	dw_at_data_location = 80
	dw_at_byte_stride = 81
	dw_at_entry_pc = 82
	dw_at_use_utf8 = 83
	dw_at_extension = 84
	dw_at_ranges = 85
	dw_at_trampoline = 86
	dw_at_call_column = 87
	dw_at_call_file = 88
	dw_at_call_line = 89
	dw_at_description = 90
	dw_at_binary_scale = 91
	dw_at_decimal_scale = 92
	dw_at_small = 93
	dw_at_decimal_sign = 94
	dw_at_digit_count = 95
	dw_at_picture_string = 96
	dw_at_mutable = 97
	dw_at_threads_scaled = 98
	dw_at_explicit = 99
	dw_at_object_pointer = 100
	dw_at_endianity = 101
	dw_at_elemental = 102
	dw_at_pure = 103
	dw_at_recursive = 104
	dw_at_signature = 105
	dw_at_main_subprogram = 106
	dw_at_data_bit_offset = 107
	dw_at_const_expr = 108
	dw_at_enum_class = 109
	dw_at_linkage_name = 110
	dw_at_string_length_bit_size = 111
	dw_at_string_length_byte_size = 112
	dw_at_rank = 113
	dw_at_str_offsets_base = 114
	dw_at_addr_base = 115
	dw_at_rnglists_base = 116
	dw_at_dwo_name = 118
	dw_at_reference = 119
	dw_at_rvalue_reference = 120
	dw_at_macros = 121
	dw_at_call_all_calls = 122
	dw_at_call_all_source_calls = 123
	dw_at_call_all_tail_calls = 124
	dw_at_call_return_pc = 125
	dw_at_call_value = 126
	dw_at_call_origin = 127
	dw_at_call_parameter = 128
	dw_at_call_pc = 129
	dw_at_call_tail_call = 130
	dw_at_call_target = 131
	dw_at_call_target_clobbered = 132
	dw_at_call_data_location = 133
	dw_at_call_data_value = 134
	dw_at_noreturn = 135
	dw_at_alignment = 136
	dw_at_export_symbols = 137
	dw_at_deleted = 138
	dw_at_defaulted = 139
	dw_at_loclists_base = 140
	dw_at_lo_user = 8192
	dw_at_mips_fde = 8193
	dw_at_mips_loop_begin = 8194
	dw_at_mips_tail_loop_begin = 8195
	dw_at_mips_epilog_begin = 8196
	dw_at_mips_loop_unroll_factor = 8197
	dw_at_mips_software_pipeline_depth = 8198
	dw_at_mips_linkage_name = 8199
	dw_at_mips_stride = 8200
	dw_at_mips_abstract_name = 8201
	dw_at_mips_clone_origin = 8202
	dw_at_mips_has_inlines = 8203
	dw_at_mips_stride_byte = 8204
	dw_at_mips_stride_elem = 8205
	dw_at_mips_ptr_dopetype = 8206
	dw_at_mips_allocatable_dopetype = 8207
	dw_at_mips_assumed_shape_dopetype = 8208
	dw_at_mips_assumed_size = 8209
	dw_at_sf_names = 8449
	dw_at_src_info = 8450
	dw_at_mac_info = 8451
	dw_at_src_coords = 8452
	dw_at_body_begin = 8453
	dw_at_body_end = 8454
	dw_at_gnu_vector = 8455
	dw_at_gnu_guarded_by = 8456
	dw_at_gnu_pt_guarded_by = 8457
	dw_at_gnu_guarded = 8458
	dw_at_gnu_pt_guarded = 8459
	dw_at_gnu_locks_excluded = 8460
	dw_at_gnu_exclusive_locks_required = 8461
	dw_at_gnu_shared_locks_required = 8462
	dw_at_gnu_odr_signature = 8463
	dw_at_gnu_template_name = 8464
	dw_at_gnu_call_site_value = 8465
	dw_at_gnu_call_site_data_value = 8466
	dw_at_gnu_call_site_target = 8467
	dw_at_gnu_call_site_target_clobbered = 8468
	dw_at_gnu_tail_call = 8469
	dw_at_gnu_all_tail_call_sites = 8470
	dw_at_gnu_all_call_sites = 8471
	dw_at_gnu_all_source_call_sites = 8472
	dw_at_gnu_locviews = 8503
	dw_at_gnu_entry_view = 8504
	dw_at_gnu_macros = 8473
	dw_at_gnu_deleted = 8474
	dw_at_gnu_dwo_name = 8496
	dw_at_gnu_dwo_id = 8497
	dw_at_gnu_ranges_base = 8498
	dw_at_gnu_addr_base = 8499
	dw_at_gnu_pubnames = 8500
	dw_at_gnu_pubtypes = 8501
	dw_at_gnu_numerator = 8963
	dw_at_gnu_denominator = 8964
	dw_at_gnu_bias = 8965
	dw_at_hi_user = 16383
)


const ( // empty enum
	dw_form_addr = 1
	dw_form_block2 = 3
	dw_form_block4 = 4
	dw_form_data2 = 5
	dw_form_data4 = 6
	dw_form_data8 = 7
	dw_form_string = 8
	dw_form_block = 9
	dw_form_block1 = 10
	dw_form_data1 = 11
	dw_form_flag = 12
	dw_form_sdata = 13
	dw_form_strp = 14
	dw_form_udata = 15
	dw_form_ref_addr = 16
	dw_form_ref1 = 17
	dw_form_ref2 = 18
	dw_form_ref4 = 19
	dw_form_ref8 = 20
	dw_form_ref_udata = 21
	dw_form_indirect = 22
	dw_form_sec_offset = 23
	dw_form_exprloc = 24
	dw_form_flag_present = 25
	dw_form_strx = 26
	dw_form_addrx = 27
	dw_form_ref_sup4 = 28
	dw_form_strp_sup = 29
	dw_form_data16 = 30
	dw_form_line_strp = 31
	dw_form_ref_sig8 = 32
	dw_form_implicit_const = 33
	dw_form_loclistx = 34
	dw_form_rnglistx = 35
	dw_form_ref_sup8 = 36
	dw_form_strx1 = 37
	dw_form_strx2 = 38
	dw_form_strx3 = 39
	dw_form_strx4 = 40
	dw_form_addrx1 = 41
	dw_form_addrx2 = 42
	dw_form_addrx3 = 43
	dw_form_addrx4 = 44
	dw_form_gnu_addr_index = 7937
	dw_form_gnu_str_index = 7938
	dw_form_gnu_ref_alt = 7968
	dw_form_gnu_strp_alt = 7969
)


const ( // empty enum
	dw_op_addr = 3
	dw_op_deref = 6
	dw_op_const1u = 8
	dw_op_const1s = 9
	dw_op_const2u = 10
	dw_op_const2s = 11
	dw_op_const4u = 12
	dw_op_const4s = 13
	dw_op_const8u = 14
	dw_op_const8s = 15
	dw_op_constu = 16
	dw_op_consts = 17
	dw_op_dup = 18
	dw_op_drop = 19
	dw_op_over = 20
	dw_op_pick = 21
	dw_op_swap = 22
	dw_op_rot = 23
	dw_op_xderef = 24
	dw_op_abs = 25
	dw_op_and = 26
	dw_op_div = 27
	dw_op_minus = 28
	dw_op_mod = 29
	dw_op_mul = 30
	dw_op_neg = 31
	dw_op_not = 32
	dw_op_or = 33
	dw_op_plus = 34
	dw_op_plus_uconst = 35
	dw_op_shl = 36
	dw_op_shr = 37
	dw_op_shra = 38
	dw_op_xor = 39
	dw_op_bra = 40
	dw_op_eq = 41
	dw_op_ge = 42
	dw_op_gt = 43
	dw_op_le = 44
	dw_op_lt = 45
	dw_op_ne = 46
	dw_op_skip = 47
	dw_op_lit0 = 48
	dw_op_lit1 = 49
	dw_op_lit2 = 50
	dw_op_lit3 = 51
	dw_op_lit4 = 52
	dw_op_lit5 = 53
	dw_op_lit6 = 54
	dw_op_lit7 = 55
	dw_op_lit8 = 56
	dw_op_lit9 = 57
	dw_op_lit10 = 58
	dw_op_lit11 = 59
	dw_op_lit12 = 60
	dw_op_lit13 = 61
	dw_op_lit14 = 62
	dw_op_lit15 = 63
	dw_op_lit16 = 64
	dw_op_lit17 = 65
	dw_op_lit18 = 66
	dw_op_lit19 = 67
	dw_op_lit20 = 68
	dw_op_lit21 = 69
	dw_op_lit22 = 70
	dw_op_lit23 = 71
	dw_op_lit24 = 72
	dw_op_lit25 = 73
	dw_op_lit26 = 74
	dw_op_lit27 = 75
	dw_op_lit28 = 76
	dw_op_lit29 = 77
	dw_op_lit30 = 78
	dw_op_lit31 = 79
	dw_op_reg0 = 80
	dw_op_reg1 = 81
	dw_op_reg2 = 82
	dw_op_reg3 = 83
	dw_op_reg4 = 84
	dw_op_reg5 = 85
	dw_op_reg6 = 86
	dw_op_reg7 = 87
	dw_op_reg8 = 88
	dw_op_reg9 = 89
	dw_op_reg10 = 90
	dw_op_reg11 = 91
	dw_op_reg12 = 92
	dw_op_reg13 = 93
	dw_op_reg14 = 94
	dw_op_reg15 = 95
	dw_op_reg16 = 96
	dw_op_reg17 = 97
	dw_op_reg18 = 98
	dw_op_reg19 = 99
	dw_op_reg20 = 100
	dw_op_reg21 = 101
	dw_op_reg22 = 102
	dw_op_reg23 = 103
	dw_op_reg24 = 104
	dw_op_reg25 = 105
	dw_op_reg26 = 106
	dw_op_reg27 = 107
	dw_op_reg28 = 108
	dw_op_reg29 = 109
	dw_op_reg30 = 110
	dw_op_reg31 = 111
	dw_op_breg0 = 112
	dw_op_breg1 = 113
	dw_op_breg2 = 114
	dw_op_breg3 = 115
	dw_op_breg4 = 116
	dw_op_breg5 = 117
	dw_op_breg6 = 118
	dw_op_breg7 = 119
	dw_op_breg8 = 120
	dw_op_breg9 = 121
	dw_op_breg10 = 122
	dw_op_breg11 = 123
	dw_op_breg12 = 124
	dw_op_breg13 = 125
	dw_op_breg14 = 126
	dw_op_breg15 = 127
	dw_op_breg16 = 128
	dw_op_breg17 = 129
	dw_op_breg18 = 130
	dw_op_breg19 = 131
	dw_op_breg20 = 132
	dw_op_breg21 = 133
	dw_op_breg22 = 134
	dw_op_breg23 = 135
	dw_op_breg24 = 136
	dw_op_breg25 = 137
	dw_op_breg26 = 138
	dw_op_breg27 = 139
	dw_op_breg28 = 140
	dw_op_breg29 = 141
	dw_op_breg30 = 142
	dw_op_breg31 = 143
	dw_op_regx = 144
	dw_op_fbreg = 145
	dw_op_bregx = 146
	dw_op_piece = 147
	dw_op_deref_size = 148
	dw_op_xderef_size = 149
	dw_op_nop = 150
	dw_op_push_object_address = 151
	dw_op_call2 = 152
	dw_op_call4 = 153
	dw_op_call_ref = 154
	dw_op_form_tls_address = 155
	dw_op_call_frame_cfa = 156
	dw_op_bit_piece = 157
	dw_op_implicit_value = 158
	dw_op_stack_value = 159
	dw_op_implicit_pointer = 160
	dw_op_addrx = 161
	dw_op_constx = 162
	dw_op_entry_value = 163
	dw_op_const_type = 164
	dw_op_regval_type = 165
	dw_op_deref_type = 166
	dw_op_xderef_type = 167
	dw_op_convert = 168
	dw_op_reinterpret = 169
	dw_op_gnu_push_tls_address = 224
	dw_op_gnu_uninit = 240
	dw_op_gnu_encoded_addr = 241
	dw_op_gnu_implicit_pointer = 242
	dw_op_gnu_entry_value = 243
	dw_op_gnu_const_type = 244
	dw_op_gnu_regval_type = 245
	dw_op_gnu_deref_type = 246
	dw_op_gnu_convert = 247
	dw_op_gnu_reinterpret = 249
	dw_op_gnu_parameter_ref = 250
	dw_op_gnu_addr_index = 251
	dw_op_gnu_const_index = 252
	dw_op_gnu_variable_value = 253
	dw_op_lo_user = 224
	dw_op_hi_user = 255
)


const ( // empty enum
	dw_ate_void = 0
	dw_ate_address = 1
	dw_ate_boolean = 2
	dw_ate_complex_float = 3
	dw_ate_float = 4
	dw_ate_signed = 5
	dw_ate_signed_char = 6
	dw_ate_unsigned = 7
	dw_ate_unsigned_char = 8
	dw_ate_imaginary_float = 9
	dw_ate_packed_decimal = 10
	dw_ate_numeric_string = 11
	dw_ate_edited = 12
	dw_ate_signed_fixed = 13
	dw_ate_unsigned_fixed = 14
	dw_ate_decimal_float = 15
	dw_ate_utf = 16
	dw_ate_ucs = 17
	dw_ate_ascii = 18
	dw_ate_lo_user = 128
	dw_ate_hi_user = 255
)


const ( // empty enum
	dw_ds_unsigned = 1
	dw_ds_leading_overpunch = 2
	dw_ds_trailing_overpunch = 3
	dw_ds_leading_separate = 4
	dw_ds_trailing_separate = 5
)


const ( // empty enum
	dw_end_default = 0
	dw_end_big = 1
	dw_end_little = 2
	dw_end_lo_user = 64
	dw_end_hi_user = 255
)


const ( // empty enum
	dw_access_public = 1
	dw_access_protected = 2
	dw_access_private = 3
)


const ( // empty enum
	dw_vis_local = 1
	dw_vis_exported = 2
	dw_vis_qualified = 3
)


const ( // empty enum
	dw_virtuality_none = 0
	dw_virtuality_virtual = 1
	dw_virtuality_pure_virtual = 2
)


const ( // empty enum
	dw_lang_c89 = 1
	dw_lang_c = 2
	dw_lang_ada83 = 3
	dw_lang_c_plus_plus = 4
	dw_lang_cobol74 = 5
	dw_lang_cobol85 = 6
	dw_lang_fortran77 = 7
	dw_lang_fortran90 = 8
	dw_lang_pascal83 = 9
	dw_lang_modula2 = 10
	dw_lang_java = 11
	dw_lang_c99 = 12
	dw_lang_ada95 = 13
	dw_lang_fortran95 = 14
	dw_lang_pli = 15
	dw_lang_objc = 16
	dw_lang_objc_plus_plus = 17
	dw_lang_upc = 18
	dw_lang_d = 19
	dw_lang_python = 20
	dw_lang_opencl = 21
	dw_lang_go = 22
	dw_lang_modula3 = 23
	dw_lang_haskell = 24
	dw_lang_c_plus_plus_03 = 25
	dw_lang_c_plus_plus_11 = 26
	dw_lang_ocaml = 27
	dw_lang_rust = 28
	dw_lang_c11 = 29
	dw_lang_swift = 30
	dw_lang_julia = 31
	dw_lang_dylan = 32
	dw_lang_c_plus_plus_14 = 33
	dw_lang_fortran03 = 34
	dw_lang_fortran08 = 35
	dw_lang_renderscript = 36
	dw_lang_bliss = 37
	dw_lang_lo_user = 32768
	dw_lang_mips_assembler = 32769
	dw_lang_hi_user = 65535
)


const ( // empty enum
	dw_id_case_sensitive = 0
	dw_id_up_case = 1
	dw_id_down_case = 2
	dw_id_case_insensitive = 3
)


const ( // empty enum
	dw_cc_normal = 1
	dw_cc_program = 2
	dw_cc_nocall = 3
	dw_cc_pass_by_reference = 4
	dw_cc_pass_by_value = 5
	dw_cc_lo_user = 64
	dw_cc_hi_user = 255
)


const ( // empty enum
	dw_inl_not_inlined = 0
	dw_inl_inlined = 1
	dw_inl_declared_not_inlined = 2
	dw_inl_declared_inlined = 3
)


const ( // empty enum
	dw_ord_row_major = 0
	dw_ord_col_major = 1
)


const ( // empty enum
	dw_dsc_label = 0
	dw_dsc_range = 1
)


const ( // empty enum
	dw_defaulted_no = 0
	dw_defaulted_in_class = 1
	dw_defaulted_out_of_class = 2
)


const ( // empty enum
	dw_lnct_path = 1
	dw_lnct_directory_index = 2
	dw_lnct_timestamp = 3
	dw_lnct_size = 4
	dw_lnct_md5 = 5
	dw_lnct_lo_user = 8192
	dw_lnct_hi_user = 16383
)


const ( // empty enum
	dw_lns_copy = 1
	dw_lns_advance_pc = 2
	dw_lns_advance_line = 3
	dw_lns_set_file = 4
	dw_lns_set_column = 5
	dw_lns_negate_stmt = 6
	dw_lns_set_basic_block = 7
	dw_lns_const_add_pc = 8
	dw_lns_fixed_advance_pc = 9
	dw_lns_set_prologue_end = 10
	dw_lns_set_epilogue_begin = 11
	dw_lns_set_isa = 12
)


const ( // empty enum
	dw_lne_end_sequence = 1
	dw_lne_set_address = 2
	dw_lne_define_file = 3
	dw_lne_set_discriminator = 4
	dw_lne_lo_user = 128
	dw_lne_nvidia_inlined_call = 144
	dw_lne_nvidia_set_function_name = 145
	dw_lne_hi_user = 255
)


const ( // empty enum
	dw_macinfo_define = 1
	dw_macinfo_undef = 2
	dw_macinfo_start_file = 3
	dw_macinfo_end_file = 4
	dw_macinfo_vendor_ext = 255
)


const ( // empty enum
	dw_macro_define = 1
	dw_macro_undef = 2
	dw_macro_start_file = 3
	dw_macro_end_file = 4
	dw_macro_define_strp = 5
	dw_macro_undef_strp = 6
	dw_macro_import = 7
	dw_macro_define_sup = 8
	dw_macro_undef_sup = 9
	dw_macro_import_sup = 10
	dw_macro_define_strx = 11
	dw_macro_undef_strx = 12
	dw_macro_lo_user = 224
	dw_macro_hi_user = 255
)


const ( // empty enum
	dw_rle_end_of_list = 0
	dw_rle_base_addressx = 1
	dw_rle_startx_endx = 2
	dw_rle_startx_length = 3
	dw_rle_offset_pair = 4
	dw_rle_base_address = 5
	dw_rle_start_end = 6
	dw_rle_start_length = 7
)


const ( // empty enum
	dw_lle_end_of_list = 0
	dw_lle_base_addressx = 1
	dw_lle_startx_endx = 2
	dw_lle_startx_length = 3
	dw_lle_offset_pair = 4
	dw_lle_default_location = 5
	dw_lle_base_address = 6
	dw_lle_start_end = 7
	dw_lle_start_length = 8
)


const ( // empty enum
	dw_lle_gnu_end_of_list_entry = 0
	dw_lle_gnu_base_address_selection_entry = 1
	dw_lle_gnu_start_end_entry = 2
	dw_lle_gnu_start_length_entry = 3
)


const ( // empty enum
	dw_sect_info = 1
	dw_sect_abbrev = 3
	dw_sect_line = 4
	dw_sect_loclists = 5
	dw_sect_str_offsets = 6
	dw_sect_macro = 7
	dw_sect_rnglists = 8
)


const ( // empty enum
	dw_cfa_advance_loc = 64
	dw_cfa_offset = 128
	dw_cfa_restore = 192
	dw_cfa_extended = 0
	dw_cfa_nop = 0
	dw_cfa_set_loc = 1
	dw_cfa_advance_loc1 = 2
	dw_cfa_advance_loc2 = 3
	dw_cfa_advance_loc4 = 4
	dw_cfa_offset_extended = 5
	dw_cfa_restore_extended = 6
	dw_cfa_undefined = 7
	dw_cfa_same_value = 8
	dw_cfa_register = 9
	dw_cfa_remember_state = 10
	dw_cfa_restore_state = 11
	dw_cfa_def_cfa = 12
	dw_cfa_def_cfa_register = 13
	dw_cfa_def_cfa_offset = 14
	dw_cfa_def_cfa_expression = 15
	dw_cfa_expression = 16
	dw_cfa_offset_extended_sf = 17
	dw_cfa_def_cfa_sf = 18
	dw_cfa_def_cfa_offset_sf = 19
	dw_cfa_val_offset = 20
	dw_cfa_val_offset_sf = 21
	dw_cfa_val_expression = 22
	dw_cfa_low_user = 28
	dw_cfa_mips_advance_loc8 = 29
	dw_cfa_gnu_window_save = 45
	dw_cfa_aarch64_negate_ra_state = 45
	dw_cfa_gnu_args_size = 46
	dw_cfa_gnu_negative_offset_extended = 47
	dw_cfa_high_user = 63
)


const ( // empty enum
	dw_cie_id_32
	dw_cie_id_64
)


const ( // empty enum
	dw_eh_pe_absptr = 0
	dw_eh_pe_omit = 255
	dw_eh_pe_uleb128 = 1
	dw_eh_pe_udata2 = 2
	dw_eh_pe_udata4 = 3
	dw_eh_pe_udata8 = 4
	dw_eh_pe_sleb128 = 9
	dw_eh_pe_sdata2 = 10
	dw_eh_pe_sdata4 = 11
	dw_eh_pe_sdata8 = 12
	dw_eh_pe_signed = 8
	dw_eh_pe_pcrel = 16
	dw_eh_pe_textrel = 32
	dw_eh_pe_datarel = 48
	dw_eh_pe_funcrel = 64
	dw_eh_pe_aligned = 80
	dw_eh_pe_indirect = 128
)


const ( // empty enum
	treg_rax = 0
	treg_rcx = 1
	treg_rdx = 2
	treg_rsp = 4
	treg_rsi = 6
	treg_rdi = 7
	treg_r8 = 8
	treg_r9 = 9
	treg_r10 = 10
	treg_r11 = 11
	treg_xmm0 = 16
	treg_xmm1 = 17
	treg_xmm2 = 18
	treg_xmm3 = 19
	treg_xmm4 = 20
	treg_xmm5 = 21
	treg_xmm6 = 22
	treg_xmm7 = 23
	treg_st0 = 24
	treg_mem = 32
)

struct TokenSym { 
	hash_next &TokenSym
	sym_define &Sym
	sym_label &Sym
	sym_struct &Sym
	sym_identifier &Sym
	tok int
	len int
	str [1]i8
}
type Nwchar_t = int
struct CString { 
	size int
	size_allocated int
	data voidptr
}
struct CType { 
	t int
	ref &Sym
}
union CValue { 
	ld f64
	d f64
	f f32
	i u64
	str  struct {	data voidptr
	size int
}

	tab [4]int
}
struct SValue { 
	type_ CType
	r u16
	r2 u16
}
struct SymAttr { 
	aligned u16
	packed u16
	weak u16
	visibility u16
	dllexport u16
	nodecorate u16
	dllimport u16
	addrtaken u16
	nodebug u16
	xxxx u16
}
struct FuncAttr { 
	func_call u32
	func_type u32
	func_noreturn u32
	func_ctor u32
	func_dtor u32
	func_args u32
	func_alwinl u32
	xxxx u32
}
struct Sym { 
	v int
	r u16
	a SymAttr
	type_ CType
	prev &Sym
	prev_tok &Sym
}
struct Section { 
	data_offset u32
	data &u8
	data_allocated u32
	s1 &TCCState
	sh_name int
	sh_num int
	sh_type int
	sh_flags int
	sh_info int
	sh_addralign int
	sh_entsize int
	sh_size u32
	sh_addr Elf64_Addr
	sh_offset u32
	nb_hashed_syms int
	link &Section
	reloc &Section
	hash &Section
	prev &Section
	name [1]i8
}
struct DLLReference { 
	level int
	handle voidptr
	found u8
	index u8
	name [1]i8
}
struct BufferedFile { 
	buf_ptr &u8
	buf_end &u8
	fd int
	prev &BufferedFile
	line_num int
	line_ref int
	ifndef_macro int
	ifndef_macro_saved int
	ifdef_stack_ptr &int
	include_next_index int
	filename [1024]i8
	truefilename &i8
	unget [4]u8
	buffer [1]u8
}
struct TokenString { 
	str &int
	len int
	lastlen int
	allocated_len int
	last_line_num int
	save_line_num int
	prev &TokenString
	prev_ptr &int
	alloc i8
}
struct AttributeDef { 
	a SymAttr
	f FuncAttr
	section &Section
	cleanup_func &Sym
	alias_target int
	asm_label int
	attr_mode i8
}
struct InlineFunc { 
	func_str &TokenString
	sym &Sym
	filename [1]i8
}
struct CachedInclude { 
	ifndef_macro int
	once int
	hash_next int
	filename [1]i8
}
struct ExprValue { 
	v u64
	sym &Sym
	pcrel int
}
struct ASMOperand { 
	id int
	constraint [16]i8
	asm_str [16]i8
	vt &SValue
	ref_index int
	input_index int
	priority int
	reg int
	is_llong int
	is_memory int
	is_rw int
	is_label int
}
struct Sym_attr { 
	got_offset u32
	plt_offset u32
	plt_sym int
	dyn_index int
}
struct Filespec { 
	type_ i8
	name [1]i8
}
enum Tcc_token {
	tok_last = 256 - 1
	tok_int
	tok_void
	tok_char
	tok_if
	tok_else
	tok_while
	tok_break
	tok_return
	tok_for
	tok_extern
	tok_static
	tok_unsigned
	tok_goto
	tok_do
	tok_continue
	tok_switch
	tok_case
	tok__atomic
	tok_const1
	tok_const2
	tok_const3
	tok_volatile1
	tok_volatile2
	tok_volatile3
	tok_long
	tok_register
	tok_signed1
	tok_signed2
	tok_signed3
	tok_auto
	tok_inline1
	tok_inline2
	tok_inline3
	tok_restrict1
	tok_restrict2
	tok_restrict3
	tok_extension
	tok_thread_local
	tok_generic
	tok_static_assert
	tok_float
	tok_double
	tok_bool
	tok_complex
	tok_short
	tok_struct
	tok_union
	tok_typedef
	tok_default
	tok_enum
	tok_sizeof
	tok_attribute1
	tok_attribute2
	tok_alignof1
	tok_alignof2
	tok_alignof3
	tok_alignas
	tok_typeof1
	tok_typeof2
	tok_typeof3
	tok_label
	tok_asm1
	tok_asm2
	tok_asm3
	tok_define
	tok_include
	tok_include_next
	tok_ifdef
	tok_ifndef
	tok_elif
	tok_endif
	tok_defined
	tok_undef
	tok_error
	tok_warning
	tok_line
	tok_pragma
	tok___line__
	tok___file__
	tok___date__
	tok___time__
	tok___function__
	tok___va_args__
	tok___counter__
	tok___has_include
	tok___has_include_next
	tok___func__
	tok___nan__
	tok___snan__
	tok___inf__
	tok___mzerosf
	tok___mzerodf
	tok_section1
	tok_section2
	tok_aligned1
	tok_aligned2
	tok_packed1
	tok_packed2
	tok_weak1
	tok_weak2
	tok_alias1
	tok_alias2
	tok_unused1
	tok_unused2
	tok_nodebug1
	tok_nodebug2
	tok_cdecl1
	tok_cdecl2
	tok_cdecl3
	tok_stdcall1
	tok_stdcall2
	tok_stdcall3
	tok_fastcall1
	tok_fastcall2
	tok_fastcall3
	tok_regparm1
	tok_regparm2
	tok_cleanup1
	tok_cleanup2
	tok_constructor1
	tok_constructor2
	tok_destructor1
	tok_destructor2
	tok_always_inline1
	tok_always_inline2
	tok_mode
	tok_mode_qi
	tok_mode_di
	tok_mode_hi
	tok_mode_si
	tok_mode_word
	tok_dllexport
	tok_dllimport
	tok_nodecorate
	tok_noreturn1
	tok_noreturn2
	tok_noreturn3
	tok_visibility1
	tok_visibility2
	tok_builtin_types_compatible_p
	tok_builtin_choose_expr
	tok_builtin_constant_p
	tok_builtin_frame_address
	tok_builtin_return_address
	tok_builtin_expect
	tok_builtin_va_arg_types
	tok___atomic_store
	tok___atomic_load
	tok___atomic_exchange
	tok___atomic_compare_exchange
	tok___atomic_fetch_add
	tok___atomic_fetch_sub
	tok___atomic_fetch_or
	tok___atomic_fetch_xor
	tok___atomic_fetch_and
	tok___atomic_fetch_nand
	tok___atomic_add_fetch
	tok___atomic_sub_fetch
	tok___atomic_or_fetch
	tok___atomic_xor_fetch
	tok___atomic_and_fetch
	tok___atomic_nand_fetch
	tok_pack
	tok_comment
	tok_lib
	tok_push_macro
	tok_pop_macro
	tok_once
	tok_option
	tok_memcpy
	tok_memmove
	tok_memset
	tok___divdi3
	tok___moddi3
	tok___udivdi3
	tok___umoddi3
	tok___ashrdi3
	tok___lshrdi3
	tok___ashldi3
	tok___floatundisf
	tok___floatundidf
	tok___floatundixf
	tok___fixunsxfdi
	tok___fixunssfdi
	tok___fixunsdfdi
	tok_alloca
	tok___bound_ptr_add
	tok___bound_ptr_indir1
	tok___bound_ptr_indir2
	tok___bound_ptr_indir4
	tok___bound_ptr_indir8
	tok___bound_ptr_indir12
	tok___bound_ptr_indir16
	tok___bound_main_arg
	tok___bound_local_new
	tok___bound_local_delete
	tok___bound_setjmp
	tok___bound_longjmp
	tok___bound_new_region
	tok_sigsetjmp
	tok___sigsetjmp
	tok_siglongjmp
	tok_setjmp
	tok__setjmp
	tok_longjmp
	tok_asmdir_byte
	tok_asmdir_word
	tok_asmdir_align
	tok_asmdir_balign
	tok_asmdir_p2align
	tok_asmdir_set
	tok_asmdir_skip
	tok_asmdir_space
	tok_asmdir_string
	tok_asmdir_asciz
	tok_asmdir_ascii
	tok_asmdir_file
	tok_asmdir_globl
	tok_asmdir_global
	tok_asmdir_weak
	tok_asmdir_hidden
	tok_asmdir_ident
	tok_asmdir_size
	tok_asmdir_type
	tok_asmdir_text
	tok_asmdir_data
	tok_asmdir_bss
	tok_asmdir_previous
	tok_asmdir_pushsection
	tok_asmdir_popsection
	tok_asmdir_fill
	tok_asmdir_rept
	tok_asmdir_endr
	tok_asmdir_org
	tok_asmdir_quad
	tok_asmdir_code64
	tok_asmdir_short
	tok_asmdir_long
	tok_asmdir_int
	tok_asmdir_section
	tok_asm_al
	tok_asm_cl
	tok_asm_dl
	tok_asm_bl
	tok_asm_ah
	tok_asm_ch
	tok_asm_dh
	tok_asm_bh
	tok_asm_ax
	tok_asm_cx
	tok_asm_dx
	tok_asm_bx
	tok_asm_sp
	tok_asm_bp
	tok_asm_si
	tok_asm_di
	tok_asm_eax
	tok_asm_ecx
	tok_asm_edx
	tok_asm_ebx
	tok_asm_esp
	tok_asm_ebp
	tok_asm_esi
	tok_asm_edi
	tok_asm_rax
	tok_asm_rcx
	tok_asm_rdx
	tok_asm_rbx
	tok_asm_rsp
	tok_asm_rbp
	tok_asm_rsi
	tok_asm_rdi
	tok_asm_mm0
	tok_asm_mm1
	tok_asm_mm2
	tok_asm_mm3
	tok_asm_mm4
	tok_asm_mm5
	tok_asm_mm6
	tok_asm_mm7
	tok_asm_xmm0
	tok_asm_xmm1
	tok_asm_xmm2
	tok_asm_xmm3
	tok_asm_xmm4
	tok_asm_xmm5
	tok_asm_xmm6
	tok_asm_xmm7
	tok_asm_cr0
	tok_asm_cr1
	tok_asm_cr2
	tok_asm_cr3
	tok_asm_cr4
	tok_asm_cr5
	tok_asm_cr6
	tok_asm_cr7
	tok_asm_tr0
	tok_asm_tr1
	tok_asm_tr2
	tok_asm_tr3
	tok_asm_tr4
	tok_asm_tr5
	tok_asm_tr6
	tok_asm_tr7
	tok_asm_db0
	tok_asm_db1
	tok_asm_db2
	tok_asm_db3
	tok_asm_db4
	tok_asm_db5
	tok_asm_db6
	tok_asm_db7
	tok_asm_dr0
	tok_asm_dr1
	tok_asm_dr2
	tok_asm_dr3
	tok_asm_dr4
	tok_asm_dr5
	tok_asm_dr6
	tok_asm_dr7
	tok_asm_es
	tok_asm_cs
	tok_asm_ss
	tok_asm_ds
	tok_asm_fs
	tok_asm_gs
	tok_asm_st
	tok_asm_rip
	tok_asm_spl
	tok_asm_bpl
	tok_asm_sil
	tok_asm_dil
	tok_asm_movb
	tok_asm_movw
	tok_asm_movl
	tok_asm_movq
	tok_asm_mov
	tok_asm_addb
	tok_asm_addw
	tok_asm_addl
	tok_asm_addq
	tok_asm_add
	tok_asm_orb
	tok_asm_orw
	tok_asm_orl
	tok_asm_orq
	tok_asm_or
	tok_asm_adcb
	tok_asm_adcw
	tok_asm_adcl
	tok_asm_adcq
	tok_asm_adc
	tok_asm_sbbb
	tok_asm_sbbw
	tok_asm_sbbl
	tok_asm_sbbq
	tok_asm_sbb
	tok_asm_andb
	tok_asm_andw
	tok_asm_andl
	tok_asm_andq
	tok_asm_and
	tok_asm_subb
	tok_asm_subw
	tok_asm_subl
	tok_asm_subq
	tok_asm_sub
	tok_asm_xorb
	tok_asm_xorw
	tok_asm_xorl
	tok_asm_xorq
	tok_asm_xor
	tok_asm_cmpb
	tok_asm_cmpw
	tok_asm_cmpl
	tok_asm_cmpq
	tok_asm_cmp
	tok_asm_incb
	tok_asm_incw
	tok_asm_incl
	tok_asm_incq
	tok_asm_inc
	tok_asm_decb
	tok_asm_decw
	tok_asm_decl
	tok_asm_decq
	tok_asm_dec
	tok_asm_notb
	tok_asm_notw
	tok_asm_notl
	tok_asm_notq
	tok_asm_not
	tok_asm_negb
	tok_asm_negw
	tok_asm_negl
	tok_asm_negq
	tok_asm_neg
	tok_asm_mulb
	tok_asm_mulw
	tok_asm_mull
	tok_asm_mulq
	tok_asm_mul
	tok_asm_imulb
	tok_asm_imulw
	tok_asm_imull
	tok_asm_imulq
	tok_asm_imul
	tok_asm_divb
	tok_asm_divw
	tok_asm_divl
	tok_asm_divq
	tok_asm_div
	tok_asm_idivb
	tok_asm_idivw
	tok_asm_idivl
	tok_asm_idivq
	tok_asm_idiv
	tok_asm_xchgb
	tok_asm_xchgw
	tok_asm_xchgl
	tok_asm_xchgq
	tok_asm_xchg
	tok_asm_testb
	tok_asm_testw
	tok_asm_testl
	tok_asm_testq
	tok_asm_test
	tok_asm_rolb
	tok_asm_rolw
	tok_asm_roll
	tok_asm_rolq
	tok_asm_rol
	tok_asm_rorb
	tok_asm_rorw
	tok_asm_rorl
	tok_asm_rorq
	tok_asm_ror
	tok_asm_rclb
	tok_asm_rclw
	tok_asm_rcll
	tok_asm_rclq
	tok_asm_rcl
	tok_asm_rcrb
	tok_asm_rcrw
	tok_asm_rcrl
	tok_asm_rcrq
	tok_asm_rcr
	tok_asm_shlb
	tok_asm_shlw
	tok_asm_shll
	tok_asm_shlq
	tok_asm_shl
	tok_asm_shrb
	tok_asm_shrw
	tok_asm_shrl
	tok_asm_shrq
	tok_asm_shr
	tok_asm_sarb
	tok_asm_sarw
	tok_asm_sarl
	tok_asm_sarq
	tok_asm_sar
	tok_asm_shldw
	tok_asm_shldl
	tok_asm_shldq
	tok_asm_shld
	tok_asm_shrdw
	tok_asm_shrdl
	tok_asm_shrdq
	tok_asm_shrd
	tok_asm_pushw
	tok_asm_pushl
	tok_asm_pushq
	tok_asm_push
	tok_asm_popw
	tok_asm_popl
	tok_asm_popq
	tok_asm_pop
	tok_asm_inb
	tok_asm_inw
	tok_asm_inl
	tok_asm_in
	tok_asm_outb
	tok_asm_outw
	tok_asm_outl
	tok_asm_out
	tok_asm_movzbw
	tok_asm_movzbl
	tok_asm_movzbq
	tok_asm_movzb
	tok_asm_movzwl
	tok_asm_movsbw
	tok_asm_movsbl
	tok_asm_movswl
	tok_asm_movsbq
	tok_asm_movswq
	tok_asm_movzwq
	tok_asm_movslq
	tok_asm_leaw
	tok_asm_leal
	tok_asm_leaq
	tok_asm_lea
	tok_asm_les
	tok_asm_lds
	tok_asm_lss
	tok_asm_lfs
	tok_asm_lgs
	tok_asm_call
	tok_asm_jmp
	tok_asm_lcall
	tok_asm_ljmp
	tok_asm_jo
	tok_asm_jno
	tok_asm_jb
	tok_asm_jc
	tok_asm_jnae
	tok_asm_jnb
	tok_asm_jnc
	tok_asm_jae
	tok_asm_je
	tok_asm_jz
	tok_asm_jne
	tok_asm_jnz
	tok_asm_jbe
	tok_asm_jna
	tok_asm_jnbe
	tok_asm_ja
	tok_asm_js
	tok_asm_jns
	tok_asm_jp
	tok_asm_jpe
	tok_asm_jnp
	tok_asm_jpo
	tok_asm_jl
	tok_asm_jnge
	tok_asm_jnl
	tok_asm_jge
	tok_asm_jle
	tok_asm_jng
	tok_asm_jnle
	tok_asm_jg
	tok_asm_seto
	tok_asm_setno
	tok_asm_setb
	tok_asm_setc
	tok_asm_setnae
	tok_asm_setnb
	tok_asm_setnc
	tok_asm_setae
	tok_asm_sete
	tok_asm_setz
	tok_asm_setne
	tok_asm_setnz
	tok_asm_setbe
	tok_asm_setna
	tok_asm_setnbe
	tok_asm_seta
	tok_asm_sets
	tok_asm_setns
	tok_asm_setp
	tok_asm_setpe
	tok_asm_setnp
	tok_asm_setpo
	tok_asm_setl
	tok_asm_setnge
	tok_asm_setnl
	tok_asm_setge
	tok_asm_setle
	tok_asm_setng
	tok_asm_setnle
	tok_asm_setg
	tok_asm_setob
	tok_asm_setnob
	tok_asm_setbb
	tok_asm_setcb
	tok_asm_setnaeb
	tok_asm_setnbb
	tok_asm_setncb
	tok_asm_setaeb
	tok_asm_seteb
	tok_asm_setzb
	tok_asm_setneb
	tok_asm_setnzb
	tok_asm_setbeb
	tok_asm_setnab
	tok_asm_setnbeb
	tok_asm_setab
	tok_asm_setsb
	tok_asm_setnsb
	tok_asm_setpb
	tok_asm_setpeb
	tok_asm_setnpb
	tok_asm_setpob
	tok_asm_setlb
	tok_asm_setngeb
	tok_asm_setnlb
	tok_asm_setgeb
	tok_asm_setleb
	tok_asm_setngb
	tok_asm_setnleb
	tok_asm_setgb
	tok_asm_cmovo
	tok_asm_cmovno
	tok_asm_cmovb
	tok_asm_cmovc
	tok_asm_cmovnae
	tok_asm_cmovnb
	tok_asm_cmovnc
	tok_asm_cmovae
	tok_asm_cmove
	tok_asm_cmovz
	tok_asm_cmovne
	tok_asm_cmovnz
	tok_asm_cmovbe
	tok_asm_cmovna
	tok_asm_cmovnbe
	tok_asm_cmova
	tok_asm_cmovs
	tok_asm_cmovns
	tok_asm_cmovp
	tok_asm_cmovpe
	tok_asm_cmovnp
	tok_asm_cmovpo
	tok_asm_cmovl
	tok_asm_cmovnge
	tok_asm_cmovnl
	tok_asm_cmovge
	tok_asm_cmovle
	tok_asm_cmovng
	tok_asm_cmovnle
	tok_asm_cmovg
	tok_asm_bsfw
	tok_asm_bsfl
	tok_asm_bsfq
	tok_asm_bsf
	tok_asm_bsrw
	tok_asm_bsrl
	tok_asm_bsrq
	tok_asm_bsr
	tok_asm_btw
	tok_asm_btl
	tok_asm_btq
	tok_asm_bt
	tok_asm_btsw
	tok_asm_btsl
	tok_asm_btsq
	tok_asm_bts
	tok_asm_btrw
	tok_asm_btrl
	tok_asm_btrq
	tok_asm_btr
	tok_asm_btcw
	tok_asm_btcl
	tok_asm_btcq
	tok_asm_btc
	tok_asm_popcntw
	tok_asm_popcntl
	tok_asm_popcntq
	tok_asm_popcnt
	tok_asm_tzcntw
	tok_asm_tzcntl
	tok_asm_tzcntq
	tok_asm_tzcnt
	tok_asm_lzcntw
	tok_asm_lzcntl
	tok_asm_lzcntq
	tok_asm_lzcnt
	tok_asm_larw
	tok_asm_larl
	tok_asm_larq
	tok_asm_lar
	tok_asm_lslw
	tok_asm_lsll
	tok_asm_lslq
	tok_asm_lsl
	tok_asm_fadd
	tok_asm_faddp
	tok_asm_fadds
	tok_asm_fiaddl
	tok_asm_faddl
	tok_asm_fiadds
	tok_asm_fmul
	tok_asm_fmulp
	tok_asm_fmuls
	tok_asm_fimull
	tok_asm_fmull
	tok_asm_fimuls
	tok_asm_fcom
	tok_asm_fcom_1
	tok_asm_fcoms
	tok_asm_ficoml
	tok_asm_fcoml
	tok_asm_ficoms
	tok_asm_fcomp
	tok_asm_fcompp
	tok_asm_fcomps
	tok_asm_ficompl
	tok_asm_fcompl
	tok_asm_ficomps
	tok_asm_fsub
	tok_asm_fsubp
	tok_asm_fsubs
	tok_asm_fisubl
	tok_asm_fsubl
	tok_asm_fisubs
	tok_asm_fsubr
	tok_asm_fsubrp
	tok_asm_fsubrs
	tok_asm_fisubrl
	tok_asm_fsubrl
	tok_asm_fisubrs
	tok_asm_fdiv
	tok_asm_fdivp
	tok_asm_fdivs
	tok_asm_fidivl
	tok_asm_fdivl
	tok_asm_fidivs
	tok_asm_fdivr
	tok_asm_fdivrp
	tok_asm_fdivrs
	tok_asm_fidivrl
	tok_asm_fdivrl
	tok_asm_fidivrs
	tok_asm_xaddb
	tok_asm_xaddw
	tok_asm_xaddl
	tok_asm_xaddq
	tok_asm_xadd
	tok_asm_cmpxchgb
	tok_asm_cmpxchgw
	tok_asm_cmpxchgl
	tok_asm_cmpxchgq
	tok_asm_cmpxchg
	tok_asm_cmpsb
	tok_asm_cmpsw
	tok_asm_cmpsl
	tok_asm_cmpsq
	tok_asm_cmps
	tok_asm_scmpb
	tok_asm_scmpw
	tok_asm_scmpl
	tok_asm_scmpq
	tok_asm_scmp
	tok_asm_insb
	tok_asm_insw
	tok_asm_insl
	tok_asm_ins
	tok_asm_outsb
	tok_asm_outsw
	tok_asm_outsl
	tok_asm_outs
	tok_asm_lodsb
	tok_asm_lodsw
	tok_asm_lodsl
	tok_asm_lodsq
	tok_asm_lods
	tok_asm_slodb
	tok_asm_slodw
	tok_asm_slodl
	tok_asm_slodq
	tok_asm_slod
	tok_asm_movsb
	tok_asm_movsw
	tok_asm_movsl
	tok_asm_movsq
	tok_asm_movs
	tok_asm_smovb
	tok_asm_smovw
	tok_asm_smovl
	tok_asm_smovq
	tok_asm_smov
	tok_asm_scasb
	tok_asm_scasw
	tok_asm_scasl
	tok_asm_scasq
	tok_asm_scas
	tok_asm_sscab
	tok_asm_sscaw
	tok_asm_sscal
	tok_asm_sscaq
	tok_asm_ssca
	tok_asm_stosb
	tok_asm_stosw
	tok_asm_stosl
	tok_asm_stosq
	tok_asm_stos
	tok_asm_sstob
	tok_asm_sstow
	tok_asm_sstol
	tok_asm_sstoq
	tok_asm_ssto
	tok_asm_clc
	tok_asm_cld
	tok_asm_cli
	tok_asm_clts
	tok_asm_cmc
	tok_asm_lahf
	tok_asm_sahf
	tok_asm_pushfq
	tok_asm_popfq
	tok_asm_pushf
	tok_asm_popf
	tok_asm_stc
	tok_asm_std
	tok_asm_sti
	tok_asm_aaa
	tok_asm_aas
	tok_asm_daa
	tok_asm_das
	tok_asm_aad
	tok_asm_aam
	tok_asm_cbw
	tok_asm_cwd
	tok_asm_cwde
	tok_asm_cdq
	tok_asm_cbtw
	tok_asm_cwtl
	tok_asm_cwtd
	tok_asm_cltd
	tok_asm_cqto
	tok_asm_int3
	tok_asm_into
	tok_asm_iret
	tok_asm_iretw
	tok_asm_iretl
	tok_asm_iretq
	tok_asm_rsm
	tok_asm_hlt
	tok_asm_wait
	tok_asm_nop
	tok_asm_pause
	tok_asm_xlat
	tok_asm_lock
	tok_asm_rep
	tok_asm_repe
	tok_asm_repz
	tok_asm_repne
	tok_asm_repnz
	tok_asm_invd
	tok_asm_wbinvd
	tok_asm_cpuid
	tok_asm_wrmsr
	tok_asm_rdtsc
	tok_asm_rdmsr
	tok_asm_rdpmc
	tok_asm_syscall
	tok_asm_sysret
	tok_asm_ud2
	tok_asm_leave
	tok_asm_ret
	tok_asm_retq
	tok_asm_lret
	tok_asm_fucompp
	tok_asm_ftst
	tok_asm_fxam
	tok_asm_fld1
	tok_asm_fldl2t
	tok_asm_fldl2e
	tok_asm_fldpi
	tok_asm_fldlg2
	tok_asm_fldln2
	tok_asm_fldz
	tok_asm_f2xm1
	tok_asm_fyl2x
	tok_asm_fptan
	tok_asm_fpatan
	tok_asm_fxtract
	tok_asm_fprem1
	tok_asm_fdecstp
	tok_asm_fincstp
	tok_asm_fprem
	tok_asm_fyl2xp1
	tok_asm_fsqrt
	tok_asm_fsincos
	tok_asm_frndint
	tok_asm_fscale
	tok_asm_fsin
	tok_asm_fcos
	tok_asm_fchs
	tok_asm_fabs
	tok_asm_fninit
	tok_asm_fnclex
	tok_asm_fnop
	tok_asm_fwait
	tok_asm_fxch
	tok_asm_fnstsw
	tok_asm_emms
	tok_asm_vmcall
	tok_asm_vmlaunch
	tok_asm_vmresume
	tok_asm_vmxoff
	tok_asm_sysretq
	tok_asm_ljmpw
	tok_asm_ljmpl
	tok_asm_enter
	tok_asm_loopne
	tok_asm_loopnz
	tok_asm_loope
	tok_asm_loopz
	tok_asm_loop
	tok_asm_jecxz
	tok_asm_fld
	tok_asm_fldl
	tok_asm_flds
	tok_asm_fildl
	tok_asm_fildq
	tok_asm_fildll
	tok_asm_fldt
	tok_asm_fbld
	tok_asm_fst
	tok_asm_fstl
	tok_asm_fsts
	tok_asm_fstps
	tok_asm_fstpl
	tok_asm_fist
	tok_asm_fistp
	tok_asm_fistl
	tok_asm_fistpl
	tok_asm_fstp
	tok_asm_fistpq
	tok_asm_fistpll
	tok_asm_fstpt
	tok_asm_fbstp
	tok_asm_fucom
	tok_asm_fucomp
	tok_asm_finit
	tok_asm_fldcw
	tok_asm_fnstcw
	tok_asm_fstcw
	tok_asm_fstsw
	tok_asm_fclex
	tok_asm_fnstenv
	tok_asm_fstenv
	tok_asm_fldenv
	tok_asm_fnsave
	tok_asm_fsave
	tok_asm_frstor
	tok_asm_ffree
	tok_asm_ffreep
	tok_asm_fxsave
	tok_asm_fxrstor
	tok_asm_fxsaveq
	tok_asm_fxrstorq
	tok_asm_arpl
	tok_asm_lgdt
	tok_asm_lgdtq
	tok_asm_lidt
	tok_asm_lidtq
	tok_asm_lldt
	tok_asm_lmsw
	tok_asm_ltr
	tok_asm_sgdt
	tok_asm_sgdtq
	tok_asm_sidt
	tok_asm_sidtq
	tok_asm_sldt
	tok_asm_smsw
	tok_asm_str
	tok_asm_verr
	tok_asm_verw
	tok_asm_swapgs
	tok_asm_bswap
	tok_asm_bswapl
	tok_asm_bswapq
	tok_asm_invlpg
	tok_asm_cmpxchg8b
	tok_asm_cmpxchg16b
	tok_asm_fcmovb
	tok_asm_fcmove
	tok_asm_fcmovbe
	tok_asm_fcmovu
	tok_asm_fcmovnb
	tok_asm_fcmovne
	tok_asm_fcmovnbe
	tok_asm_fcmovnu
	tok_asm_fucomi
	tok_asm_fcomi
	tok_asm_fucomip
	tok_asm_fcomip
	tok_asm_movd
	tok_asm_packssdw
	tok_asm_packsswb
	tok_asm_packuswb
	tok_asm_paddb
	tok_asm_paddw
	tok_asm_paddd
	tok_asm_paddsb
	tok_asm_paddsw
	tok_asm_paddusb
	tok_asm_paddusw
	tok_asm_pand
	tok_asm_pandn
	tok_asm_pcmpeqb
	tok_asm_pcmpeqw
	tok_asm_pcmpeqd
	tok_asm_pcmpgtb
	tok_asm_pcmpgtw
	tok_asm_pcmpgtd
	tok_asm_pmaddwd
	tok_asm_pmulhw
	tok_asm_pmullw
	tok_asm_por
	tok_asm_psllw
	tok_asm_pslld
	tok_asm_psllq
	tok_asm_psraw
	tok_asm_psrad
	tok_asm_psrlw
	tok_asm_psrld
	tok_asm_psrlq
	tok_asm_psubb
	tok_asm_psubw
	tok_asm_psubd
	tok_asm_psubsb
	tok_asm_psubsw
	tok_asm_psubusb
	tok_asm_psubusw
	tok_asm_punpckhbw
	tok_asm_punpckhwd
	tok_asm_punpckhdq
	tok_asm_punpcklbw
	tok_asm_punpcklwd
	tok_asm_punpckldq
	tok_asm_pxor
	tok_asm_ldmxcsr
	tok_asm_stmxcsr
	tok_asm_movups
	tok_asm_movaps
	tok_asm_movhps
	tok_asm_addps
	tok_asm_cvtpi2ps
	tok_asm_cvtps2pi
	tok_asm_cvttps2pi
	tok_asm_divps
	tok_asm_maxps
	tok_asm_minps
	tok_asm_mulps
	tok_asm_pavgb
	tok_asm_pavgw
	tok_asm_pmaxsw
	tok_asm_pmaxub
	tok_asm_pminsw
	tok_asm_pminub
	tok_asm_rcpss
	tok_asm_rsqrtps
	tok_asm_sqrtps
	tok_asm_subps
	tok_asm_movnti
	tok_asm_movntil
	tok_asm_movntiq
	tok_asm_prefetchnta
	tok_asm_prefetcht0
	tok_asm_prefetcht1
	tok_asm_prefetcht2
	tok_asm_prefetchw
	tok_asm_lfence
	tok_asm_mfence
	tok_asm_sfence
	tok_asm_clflush
}

enum Line_macro_output_format {
	line_macro_output_format_gcc
	line_macro_output_format_none
	line_macro_output_format_std
	line_macro_output_format_p10 = 11
}

fn expect(msg &i8) 

@[weak] __global ( ind int 

)

@[weak] __global ( loc int 

)

fn inc(post int, c int) 

struct Stab_Sym { 
	n_strx u32
	n_type u8
	n_other u8
	n_desc u16
	n_value u32
}
fn section_ptr_add(sec &Section, size Elf64_Addr) voidptr

fn get_sym_attr(s1 &TCCState, index int, alloc int) &Sym_attr

fn code_reloc(reloc_type int) int

fn gotplt_entry_type(reloc_type int) int

enum Gotplt_entry {
	no_gotplt_entry
	build_got_only
	auto_gotplt_entry
	always_gotplt_entry
}

fn create_plt_entry(s1 &TCCState, got_offset u32, attr &Sym_attr) u32

fn relocate_plt(s1 &TCCState) 

fn relocate(s1 &TCCState, rel &Elf64_Rela, type_ int, ptr &u8, addr Elf64_Addr, val Elf64_Addr) 

fn load(r int, sv &SValue) 

fn o(c u32) 

fn read32le(p &u8) u32 {
	return read16le(p) | u32(read16le(p + 2)) << 16
}

fn write32le(p &u8, x u32)  {
	write16le(p, x)
	write16le(p + 2, x >> 16)
}

fn add32le(p &u8, x int)  {
	write32le(p, read32le(p) + x)
}

fn read64le(p &u8) u64 {
	return read32le(p) | u64(read32le(p + 4)) << 32
}

fn write64le(p &u8, x u64)  {
	write32le(p, x)
	write32le(p + 4, x >> 32)
}

fn add64le(p &u8, x i64)  {
	write64le(p, read64le(p) + x)
}

fn g(c int) 

struct TCCSem { 
	init int
	sem Sem_t
}
fn code_reloc(reloc_type int) int {
	match reloc_type {
	 10, 11, 1, 26, 29, 9, 41, 42, 22, 3, 27, 6, 5, 8, 25, 19, 20, 21, 23, 17, 18 {
	return 0
	}
	 2, 24, 4, 31, 7 {
	return 1
	}
	else{}
	}
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
	 3, 27, 26, 29, 25, 9, 41, 19, 20, 21, 23, 17, 18, 42, 4, 31 {
	return Gotplt_entry.always_gotplt_entry
	}
	else{}
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
		p [0]  = 255
		p [1]  = modrm + 16
		write32le(p + 2, 8)
		p [6]  = 255
		p [7]  = modrm
		write32le(p + 8, 8 * 2)
	}
	plt_offset = plt.data_offset
	relofs = if s1.plt.reloc{ s1.plt.reloc.data_offset } else {0}
	p = section_ptr_add(plt, 16)
	p [0]  = 255
	p [1]  = modrm
	write32le(p + 2, got_offset)
	p [6]  = 104
	write32le(p + 7, relofs / sizeof(Elf64_Rela) - 1)
	p [11]  = 233
	write32le(p + 12, -(plt.data_offset))
	return plt_offset
}

fn relocate_plt(s1 &TCCState)  {
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
			add32le(p + 2, x + (s1.plt.data - p))
			p += 16
		}
	}
	if s1.plt.reloc {
		rel := &Elf64_Rela(0)
		x := s1.plt.sh_addr + 16 + 6
		p = s1.got.data
		for rel = &Elf64_Rela(s1.plt.reloc.data) + 0 ; rel < &Elf64_Rela((s1.plt.reloc.data + s1.plt.reloc.data_offset)) ; rel ++ {
			write64le(p + rel.r_offset, x)
			x += 16
		}
	}
}

fn relocate(s1 &TCCState, rel &Elf64_Rela, type_ int, ptr &u8, addr Elf64_Addr, val Elf64_Addr)  {
	sym_index := 0
	esym_index := 0
	
	sym_index = ((rel.r_info) >> 32)
	match type_ {
	 1 { // case comp body kind=IfStmt is_enum=false
	if s1.output_type & 4 {
		esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
		s1.qrel.r_offset = rel.r_offset
		if esym_index {
			s1.qrel.r_info = (((Elf64_Xword((esym_index))) << 32) + (1))
			s1.qrel.r_addend = rel.r_addend
			s1.qrel ++
			
		}
		else {
			s1.qrel.r_info = (((Elf64_Xword((0))) << 32) + (8))
			s1.qrel.r_addend = read64le(ptr) + val
			s1.qrel ++
		}
	}
	add64le(ptr, val)
	
	}
	 10, 11 {
	if s1.output_type & 4 {
		s1.qrel.r_offset = rel.r_offset
		s1.qrel.r_info = (((Elf64_Xword((0))) << 32) + (8))
		s1.qrel.r_addend = int(read32le(ptr)) + val
		s1.qrel ++
	}
	add32le(ptr, val)
	
	}
	 2 { // case comp body kind=IfStmt is_enum=false
	if s1.output_type == 4 {
		esym_index = get_sym_attr(s1, sym_index, 0).dyn_index
		if esym_index {
			s1.qrel.r_offset = rel.r_offset
			s1.qrel.r_info = (((Elf64_Xword((esym_index))) << 32) + (2))
			s1.qrel.r_addend = int(read32le(ptr)) + rel.r_addend
			s1.qrel ++
			
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
			(tcc_enter_state(s1) , _tcc_error_noabort)(c'internal error: relocation failed')
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
			s1.qrel.r_info = (((Elf64_Xword((esym_index))) << 32) + (24))
			s1.qrel.r_addend = read64le(ptr) + rel.r_addend
			s1.qrel ++
			
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
			rel [1] .r_info = (((Elf64_Xword((0))) << 32) + (0))
			sym = &(&Elf64_Sym(s1.symtab_section.data)) [sym_index] 
			sec = s1.sections [sym.st_shndx] 
			x = sym.st_value - sec.sh_addr - sec.data_offset
			add32le(ptr + 8, x)
		}
		else { // 3
		(tcc_enter_state(s1) , _tcc_error_noabort)(c'unexpected R_X86_64_TLSGD pattern')
}
	}
	
	}
	 20 {
	// case comp stmt
		expect := [72, 141, 61, 0, 0, 0, 0, 232, 0, 0, 0, 0]!
		
		replace := [102, 102, 102, 100, 72, 139, 4, 37, 0, 0, 0, 0]!
		
		if C.memcmp(ptr - 3, expect, sizeof(expect)) == 0 {
			C.memcpy(ptr - 3, replace, sizeof(replace))
			rel [1] .r_info = (((Elf64_Xword((0))) << 32) + (0))
		}
		else { // 3
		(tcc_enter_state(s1) , _tcc_error_noabort)(c'unexpected R_X86_64_TLSLD pattern')
}
	}
	
	}
	 21, 23 {
	{
		sym := &Elf64_Sym(0)
		sec := &Section(0)
		x := 0
		sym = &(&Elf64_Sym(s1.symtab_section.data)) [sym_index] 
		sec = s1.sections [sym.st_shndx] 
		x = val - sec.sh_addr - sec.data_offset
		add32le(ptr, x)
	}
	
	}
	 17, 18 {
	{
		sym := &Elf64_Sym(0)
		sec := &Section(0)
		x := 0
		sym = &(&Elf64_Sym(s1.symtab_section.data)) [sym_index] 
		sec = s1.sections [sym.st_shndx] 
		x = val - sec.sh_addr - sec.data_offset
		add64le(ptr, x)
	}
	
	}
	 0 { // case comp body kind=BreakStmt is_enum=false
	
	}
	 8 { // case comp body kind=BreakStmt is_enum=false
	
	
	}
	else {
	C.fprintf(C.stderr, c'FIXME: handle reloc type %d at %x [%p] to %x\n', type_, u32(addr), ptr, u32(val))
	}
	}
}

