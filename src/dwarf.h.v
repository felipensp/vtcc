@[translated]
module main

// empty enum
const dw_ut_compile = 1
const dw_ut_type = 2
const dw_ut_partial = 3
const dw_ut_skeleton = 4
const dw_ut_split_compile = 5
const dw_ut_split_type = 6
const dw_ut_lo_user = 128
const dw_ut_hi_user = 255

// empty enum
const dw_tag_array_type = 1
const dw_tag_class_type = 2
const dw_tag_entry_point = 3
const dw_tag_enumeration_type = 4
const dw_tag_formal_parameter = 5
const dw_tag_imported_declaration = 8
const dw_tag_label = 10
const dw_tag_lexical_block = 11
const dw_tag_member = 13
const dw_tag_pointer_type = 15
const dw_tag_reference_type = 16
const dw_tag_compile_unit = 17
const dw_tag_string_type = 18
const dw_tag_structure_type = 19
const dw_tag_subroutine_type = 21
const dw_tag_typedef = 22
const dw_tag_union_type = 23
const dw_tag_unspecified_parameters = 24
const dw_tag_variant = 25
const dw_tag_common_block = 26
const dw_tag_common_inclusion = 27
const dw_tag_inheritance = 28
const dw_tag_inlined_subroutine = 29
const dw_tag_module = 30
const dw_tag_ptr_to_member_type = 31
const dw_tag_set_type = 32
const dw_tag_subrange_type = 33
const dw_tag_with_stmt = 34
const dw_tag_access_declaration = 35
const dw_tag_base_type = 36
const dw_tag_catch_block = 37
const dw_tag_const_type = 38
const dw_tag_constant = 39
const dw_tag_enumerator = 40
const dw_tag_file_type = 41
const dw_tag_friend = 42
const dw_tag_namelist = 43
const dw_tag_namelist_item = 44
const dw_tag_packed_type = 45
const dw_tag_subprogram = 46
const dw_tag_template_type_parameter = 47
const dw_tag_template_value_parameter = 48
const dw_tag_thrown_type = 49
const dw_tag_try_block = 50
const dw_tag_variant_part = 51
const dw_tag_variable = 52
const dw_tag_volatile_type = 53
const dw_tag_dwarf_procedure = 54
const dw_tag_restrict_type = 55
const dw_tag_interface_type = 56
const dw_tag_namespace = 57
const dw_tag_imported_module = 58
const dw_tag_unspecified_type = 59
const dw_tag_partial_unit = 60
const dw_tag_imported_unit = 61
const dw_tag_condition = 63
const dw_tag_shared_type = 64
const dw_tag_type_unit = 65
const dw_tag_rvalue_reference_type = 66
const dw_tag_template_alias = 67
const dw_tag_coarray_type = 68
const dw_tag_generic_subrange = 69
const dw_tag_dynamic_type = 70
const dw_tag_atomic_type = 71
const dw_tag_call_site = 72
const dw_tag_call_site_parameter = 73
const dw_tag_skeleton_unit = 74
const dw_tag_immutable_type = 75
const dw_tag_lo_user = 16512
const dw_tag_mips_loop = 16513
const dw_tag_format_label = 16641
const dw_tag_function_template = 16642
const dw_tag_class_template = 16643
const dw_tag_gnu_bincl = 16644
const dw_tag_gnu_eincl = 16645
const dw_tag_gnu_template_template_param = 16646
const dw_tag_gnu_template_parameter_pack = 16647
const dw_tag_gnu_formal_parameter_pack = 16648
const dw_tag_gnu_call_site = 16649
const dw_tag_gnu_call_site_parameter = 16650
const dw_tag_hi_user = 65535

// empty enum
const dw_children_no = 0
const dw_children_yes = 1

// empty enum
const dw_at_sibling = 1
const dw_at_location = 2
const dw_at_name = 3
const dw_at_ordering = 9
const dw_at_byte_size = 11
const dw_at_bit_offset = 12
const dw_at_bit_size = 13
const dw_at_stmt_list = 16
const dw_at_low_pc = 17
const dw_at_high_pc = 18
const dw_at_language = 19
const dw_at_discr = 21
const dw_at_discr_value = 22
const dw_at_visibility = 23
const dw_at_import = 24
const dw_at_string_length = 25
const dw_at_common_reference = 26
const dw_at_comp_dir = 27
const dw_at_const_value = 28
const dw_at_containing_type = 29
const dw_at_default_value = 30
const dw_at_inline = 32
const dw_at_is_optional = 33
const dw_at_lower_bound = 34
const dw_at_producer = 37
const dw_at_prototyped = 39
const dw_at_return_addr = 42
const dw_at_start_scope = 44
const dw_at_bit_stride = 46
const dw_at_upper_bound = 47
const dw_at_abstract_origin = 49
const dw_at_accessibility = 50
const dw_at_address_class = 51
const dw_at_artificial = 52
const dw_at_base_types = 53
const dw_at_calling_convention = 54
const dw_at_count = 55
const dw_at_data_member_location = 56
const dw_at_decl_column = 57
const dw_at_decl_file = 58
const dw_at_decl_line = 59
const dw_at_declaration = 60
const dw_at_discr_list = 61
const dw_at_encoding = 62
const dw_at_external = 63
const dw_at_frame_base = 64
const dw_at_friend = 65
const dw_at_identifier_case = 66
const dw_at_macro_info = 67
const dw_at_namelist_item = 68
const dw_at_priority = 69
const dw_at_segment = 70
const dw_at_specification = 71
const dw_at_static_link = 72
const dw_at_type = 73
const dw_at_use_location = 74
const dw_at_variable_parameter = 75
const dw_at_virtuality = 76
const dw_at_vtable_elem_location = 77
const dw_at_allocated = 78
const dw_at_associated = 79
const dw_at_data_location = 80
const dw_at_byte_stride = 81
const dw_at_entry_pc = 82
const dw_at_use_utf8 = 83
const dw_at_extension = 84
const dw_at_ranges = 85
const dw_at_trampoline = 86
const dw_at_call_column = 87
const dw_at_call_file = 88
const dw_at_call_line = 89
const dw_at_description = 90
const dw_at_binary_scale = 91
const dw_at_decimal_scale = 92
const dw_at_small = 93
const dw_at_decimal_sign = 94
const dw_at_digit_count = 95
const dw_at_picture_string = 96
const dw_at_mutable = 97
const dw_at_threads_scaled = 98
const dw_at_explicit = 99
const dw_at_object_pointer = 100
const dw_at_endianity = 101
const dw_at_elemental = 102
const dw_at_pure = 103
const dw_at_recursive = 104
const dw_at_signature = 105
const dw_at_main_subprogram = 106
const dw_at_data_bit_offset = 107
const dw_at_const_expr = 108
const dw_at_enum_class = 109
const dw_at_linkage_name = 110
const dw_at_string_length_bit_size = 111
const dw_at_string_length_byte_size = 112
const dw_at_rank = 113
const dw_at_str_offsets_base = 114
const dw_at_addr_base = 115
const dw_at_rnglists_base = 116
const dw_at_dwo_name = 118
const dw_at_reference = 119
const dw_at_rvalue_reference = 120
const dw_at_macros = 121
const dw_at_call_all_calls = 122
const dw_at_call_all_source_calls = 123
const dw_at_call_all_tail_calls = 124
const dw_at_call_return_pc = 125
const dw_at_call_value = 126
const dw_at_call_origin = 127
const dw_at_call_parameter = 128
const dw_at_call_pc = 129
const dw_at_call_tail_call = 130
const dw_at_call_target = 131
const dw_at_call_target_clobbered = 132
const dw_at_call_data_location = 133
const dw_at_call_data_value = 134
const dw_at_noreturn = 135
const dw_at_alignment = 136
const dw_at_export_symbols = 137
const dw_at_deleted = 138
const dw_at_defaulted = 139
const dw_at_loclists_base = 140
const dw_at_lo_user = 8192
const dw_at_mips_fde = 8193
const dw_at_mips_loop_begin = 8194
const dw_at_mips_tail_loop_begin = 8195
const dw_at_mips_epilog_begin = 8196
const dw_at_mips_loop_unroll_factor = 8197
const dw_at_mips_software_pipeline_depth = 8198
const dw_at_mips_linkage_name = 8199
const dw_at_mips_stride = 8200
const dw_at_mips_abstract_name = 8201
const dw_at_mips_clone_origin = 8202
const dw_at_mips_has_inlines = 8203
const dw_at_mips_stride_byte = 8204
const dw_at_mips_stride_elem = 8205
const dw_at_mips_ptr_dopetype = 8206
const dw_at_mips_allocatable_dopetype = 8207
const dw_at_mips_assumed_shape_dopetype = 8208
const dw_at_mips_assumed_size = 8209
const dw_at_sf_names = 8449
const dw_at_src_info = 8450
const dw_at_mac_info = 8451
const dw_at_src_coords = 8452
const dw_at_body_begin = 8453
const dw_at_body_end = 8454
const dw_at_gnu_vector = 8455
const dw_at_gnu_guarded_by = 8456
const dw_at_gnu_pt_guarded_by = 8457
const dw_at_gnu_guarded = 8458
const dw_at_gnu_pt_guarded = 8459
const dw_at_gnu_locks_excluded = 8460
const dw_at_gnu_exclusive_locks_required = 8461
const dw_at_gnu_shared_locks_required = 8462
const dw_at_gnu_odr_signature = 8463
const dw_at_gnu_template_name = 8464
const dw_at_gnu_call_site_value = 8465
const dw_at_gnu_call_site_data_value = 8466
const dw_at_gnu_call_site_target = 8467
const dw_at_gnu_call_site_target_clobbered = 8468
const dw_at_gnu_tail_call = 8469
const dw_at_gnu_all_tail_call_sites = 8470
const dw_at_gnu_all_call_sites = 8471
const dw_at_gnu_all_source_call_sites = 8472
const dw_at_gnu_locviews = 8503
const dw_at_gnu_entry_view = 8504
const dw_at_gnu_macros = 8473
const dw_at_gnu_deleted = 8474
const dw_at_gnu_dwo_name = 8496
const dw_at_gnu_dwo_id = 8497
const dw_at_gnu_ranges_base = 8498
const dw_at_gnu_addr_base = 8499
const dw_at_gnu_pubnames = 8500
const dw_at_gnu_pubtypes = 8501
const dw_at_gnu_numerator = 8963
const dw_at_gnu_denominator = 8964
const dw_at_gnu_bias = 8965
const dw_at_hi_user = 16383

// empty enum
const dw_form_addr = 1
const dw_form_block2 = 3
const dw_form_block4 = 4
const dw_form_data2 = 5
const dw_form_data4 = 6
const dw_form_data8 = 7
const dw_form_string = 8
const dw_form_block = 9
const dw_form_block1 = 10
const dw_form_data1 = 11
const dw_form_flag = 12
const dw_form_sdata = 13
const dw_form_strp = 14
const dw_form_udata = 15
const dw_form_ref_addr = 16
const dw_form_ref1 = 17
const dw_form_ref2 = 18
const dw_form_ref4 = 19
const dw_form_ref8 = 20
const dw_form_ref_udata = 21
const dw_form_indirect = 22
const dw_form_sec_offset = 23
const dw_form_exprloc = 24
const dw_form_flag_present = 25
const dw_form_strx = 26
const dw_form_addrx = 27
const dw_form_ref_sup4 = 28
const dw_form_strp_sup = 29
const dw_form_data16 = 30
const dw_form_line_strp = 31
const dw_form_ref_sig8 = 32
const dw_form_implicit_const = 33
const dw_form_loclistx = 34
const dw_form_rnglistx = 35
const dw_form_ref_sup8 = 36
const dw_form_strx1 = 37
const dw_form_strx2 = 38
const dw_form_strx3 = 39
const dw_form_strx4 = 40
const dw_form_addrx1 = 41
const dw_form_addrx2 = 42
const dw_form_addrx3 = 43
const dw_form_addrx4 = 44
const dw_form_gnu_addr_index = 7937
const dw_form_gnu_str_index = 7938
const dw_form_gnu_ref_alt = 7968
const dw_form_gnu_strp_alt = 7969

// empty enum
const dw_op_addr = 3
const dw_op_deref = 6
const dw_op_const1u = 8
const dw_op_const1s = 9
const dw_op_const2u = 10
const dw_op_const2s = 11
const dw_op_const4u = 12
const dw_op_const4s = 13
const dw_op_const8u = 14
const dw_op_const8s = 15
const dw_op_constu = 16
const dw_op_consts = 17
const dw_op_dup = 18
const dw_op_drop = 19
const dw_op_over = 20
const dw_op_pick = 21
const dw_op_swap = 22
const dw_op_rot = 23
const dw_op_xderef = 24
const dw_op_abs = 25
const dw_op_and = 26
const dw_op_div = 27
const dw_op_minus = 28
const dw_op_mod = 29
const dw_op_mul = 30
const dw_op_neg = 31
const dw_op_not = 32
const dw_op_or = 33
const dw_op_plus = 34
const dw_op_plus_uconst = 35
const dw_op_shl = 36
const dw_op_shr = 37
const dw_op_shra = 38
const dw_op_xor = 39
const dw_op_bra = 40
const dw_op_eq = 41
const dw_op_ge = 42
const dw_op_gt = 43
const dw_op_le = 44
const dw_op_lt = 45
const dw_op_ne = 46
const dw_op_skip = 47
const dw_op_lit0 = 48
const dw_op_lit1 = 49
const dw_op_lit2 = 50
const dw_op_lit3 = 51
const dw_op_lit4 = 52
const dw_op_lit5 = 53
const dw_op_lit6 = 54
const dw_op_lit7 = 55
const dw_op_lit8 = 56
const dw_op_lit9 = 57
const dw_op_lit10 = 58
const dw_op_lit11 = 59
const dw_op_lit12 = 60
const dw_op_lit13 = 61
const dw_op_lit14 = 62
const dw_op_lit15 = 63
const dw_op_lit16 = 64
const dw_op_lit17 = 65
const dw_op_lit18 = 66
const dw_op_lit19 = 67
const dw_op_lit20 = 68
const dw_op_lit21 = 69
const dw_op_lit22 = 70
const dw_op_lit23 = 71
const dw_op_lit24 = 72
const dw_op_lit25 = 73
const dw_op_lit26 = 74
const dw_op_lit27 = 75
const dw_op_lit28 = 76
const dw_op_lit29 = 77
const dw_op_lit30 = 78
const dw_op_lit31 = 79
const dw_op_reg0 = 80
const dw_op_reg1 = 81
const dw_op_reg2 = 82
const dw_op_reg3 = 83
const dw_op_reg4 = 84
const dw_op_reg5 = 85
const dw_op_reg6 = 86
const dw_op_reg7 = 87
const dw_op_reg8 = 88
const dw_op_reg9 = 89
const dw_op_reg10 = 90
const dw_op_reg11 = 91
const dw_op_reg12 = 92
const dw_op_reg13 = 93
const dw_op_reg14 = 94
const dw_op_reg15 = 95
const dw_op_reg16 = 96
const dw_op_reg17 = 97
const dw_op_reg18 = 98
const dw_op_reg19 = 99
const dw_op_reg20 = 100
const dw_op_reg21 = 101
const dw_op_reg22 = 102
const dw_op_reg23 = 103
const dw_op_reg24 = 104
const dw_op_reg25 = 105
const dw_op_reg26 = 106
const dw_op_reg27 = 107
const dw_op_reg28 = 108
const dw_op_reg29 = 109
const dw_op_reg30 = 110
const dw_op_reg31 = 111
const dw_op_breg0 = 112
const dw_op_breg1 = 113
const dw_op_breg2 = 114
const dw_op_breg3 = 115
const dw_op_breg4 = 116
const dw_op_breg5 = 117
const dw_op_breg6 = 118
const dw_op_breg7 = 119
const dw_op_breg8 = 120
const dw_op_breg9 = 121
const dw_op_breg10 = 122
const dw_op_breg11 = 123
const dw_op_breg12 = 124
const dw_op_breg13 = 125
const dw_op_breg14 = 126
const dw_op_breg15 = 127
const dw_op_breg16 = 128
const dw_op_breg17 = 129
const dw_op_breg18 = 130
const dw_op_breg19 = 131
const dw_op_breg20 = 132
const dw_op_breg21 = 133
const dw_op_breg22 = 134
const dw_op_breg23 = 135
const dw_op_breg24 = 136
const dw_op_breg25 = 137
const dw_op_breg26 = 138
const dw_op_breg27 = 139
const dw_op_breg28 = 140
const dw_op_breg29 = 141
const dw_op_breg30 = 142
const dw_op_breg31 = 143
const dw_op_regx = 144
const dw_op_fbreg = 145
const dw_op_bregx = 146
const dw_op_piece = 147
const dw_op_deref_size = 148
const dw_op_xderef_size = 149
const dw_op_nop = 150
const dw_op_push_object_address = 151
const dw_op_call2 = 152
const dw_op_call4 = 153
const dw_op_call_ref = 154
const dw_op_form_tls_address = 155
const dw_op_call_frame_cfa = 156
const dw_op_bit_piece = 157
const dw_op_implicit_value = 158
const dw_op_stack_value = 159
const dw_op_implicit_pointer = 160
const dw_op_addrx = 161
const dw_op_constx = 162
const dw_op_entry_value = 163
const dw_op_const_type = 164
const dw_op_regval_type = 165
const dw_op_deref_type = 166
const dw_op_xderef_type = 167
const dw_op_convert = 168
const dw_op_reinterpret = 169
const dw_op_gnu_push_tls_address = 224
const dw_op_gnu_uninit = 240
const dw_op_gnu_encoded_addr = 241
const dw_op_gnu_implicit_pointer = 242
const dw_op_gnu_entry_value = 243
const dw_op_gnu_const_type = 244
const dw_op_gnu_regval_type = 245
const dw_op_gnu_deref_type = 246
const dw_op_gnu_convert = 247
const dw_op_gnu_reinterpret = 249
const dw_op_gnu_parameter_ref = 250
const dw_op_gnu_addr_index = 251
const dw_op_gnu_const_index = 252
const dw_op_gnu_variable_value = 253
const dw_op_lo_user = 224
const dw_op_hi_user = 255

// empty enum
const dw_ate_void = 0
const dw_ate_address = 1
const dw_ate_boolean = 2
const dw_ate_complex_float = 3
const dw_ate_float = 4
const dw_ate_signed = 5
const dw_ate_signed_char = 6
const dw_ate_unsigned = 7
const dw_ate_unsigned_char = 8
const dw_ate_imaginary_float = 9
const dw_ate_packed_decimal = 10
const dw_ate_numeric_string = 11
const dw_ate_edited = 12
const dw_ate_signed_fixed = 13
const dw_ate_unsigned_fixed = 14
const dw_ate_decimal_float = 15
const dw_ate_utf = 16
const dw_ate_ucs = 17
const dw_ate_ascii = 18
const dw_ate_lo_user = 128
const dw_ate_hi_user = 255

// empty enum
const dw_ds_unsigned = 1
const dw_ds_leading_overpunch = 2
const dw_ds_trailing_overpunch = 3
const dw_ds_leading_separate = 4
const dw_ds_trailing_separate = 5

// empty enum
const dw_end_default = 0
const dw_end_big = 1
const dw_end_little = 2
const dw_end_lo_user = 64
const dw_end_hi_user = 255

// empty enum
const dw_access_public = 1
const dw_access_protected = 2
const dw_access_private = 3

// empty enum
const dw_vis_local = 1
const dw_vis_exported = 2
const dw_vis_qualified = 3

// empty enum
const dw_virtuality_none = 0
const dw_virtuality_virtual = 1
const dw_virtuality_pure_virtual = 2

// empty enum
const dw_lang_c89 = 1
const dw_lang_c = 2
const dw_lang_ada83 = 3
const dw_lang_c_plus_plus = 4
const dw_lang_cobol74 = 5
const dw_lang_cobol85 = 6
const dw_lang_fortran77 = 7
const dw_lang_fortran90 = 8
const dw_lang_pascal83 = 9
const dw_lang_modula2 = 10
const dw_lang_java = 11
const dw_lang_c99 = 12
const dw_lang_ada95 = 13
const dw_lang_fortran95 = 14
const dw_lang_pli = 15
const dw_lang_objc = 16
const dw_lang_objc_plus_plus = 17
const dw_lang_upc = 18
const dw_lang_d = 19
const dw_lang_python = 20
const dw_lang_opencl = 21
const dw_lang_go = 22
const dw_lang_modula3 = 23
const dw_lang_haskell = 24
const dw_lang_c_plus_plus_03 = 25
const dw_lang_c_plus_plus_11 = 26
const dw_lang_ocaml = 27
const dw_lang_rust = 28
const dw_lang_c11 = 29
const dw_lang_swift = 30
const dw_lang_julia = 31
const dw_lang_dylan = 32
const dw_lang_c_plus_plus_14 = 33
const dw_lang_fortran03 = 34
const dw_lang_fortran08 = 35
const dw_lang_renderscript = 36
const dw_lang_bliss = 37
const dw_lang_lo_user = 32768
const dw_lang_mips_assembler = 32769
const dw_lang_hi_user = 65535

// empty enum
const dw_id_case_sensitive = 0
const dw_id_up_case = 1
const dw_id_down_case = 2
const dw_id_case_insensitive = 3

// empty enum
const dw_cc_normal = 1
const dw_cc_program = 2
const dw_cc_nocall = 3
const dw_cc_pass_by_reference = 4
const dw_cc_pass_by_value = 5
const dw_cc_lo_user = 64
const dw_cc_hi_user = 255

// empty enum
const dw_inl_not_inlined = 0
const dw_inl_inlined = 1
const dw_inl_declared_not_inlined = 2
const dw_inl_declared_inlined = 3

// empty enum
const dw_ord_row_major = 0
const dw_ord_col_major = 1

// empty enum
const dw_dsc_label = 0
const dw_dsc_range = 1

// empty enum
const dw_defaulted_no = 0
const dw_defaulted_in_class = 1
const dw_defaulted_out_of_class = 2

// empty enum
const dw_lnct_path = 1
const dw_lnct_directory_index = 2
const dw_lnct_timestamp = 3
const dw_lnct_size = 4
const dw_lnct_md5 = 5
const dw_lnct_lo_user = 8192
const dw_lnct_hi_user = 16383

// empty enum
const dw_lns_copy = 1
const dw_lns_advance_pc = 2
const dw_lns_advance_line = 3
const dw_lns_set_file = 4
const dw_lns_set_column = 5
const dw_lns_negate_stmt = 6
const dw_lns_set_basic_block = 7
const dw_lns_const_add_pc = 8
const dw_lns_fixed_advance_pc = 9
const dw_lns_set_prologue_end = 10
const dw_lns_set_epilogue_begin = 11
const dw_lns_set_isa = 12

// empty enum
const dw_lne_end_sequence = 1
const dw_lne_set_address = 2
const dw_lne_define_file = 3
const dw_lne_set_discriminator = 4
const dw_lne_lo_user = 128
const dw_lne_nvidia_inlined_call = 144
const dw_lne_nvidia_set_function_name = 145
const dw_lne_hi_user = 255

// empty enum
const dw_macinfo_define = 1
const dw_macinfo_undef = 2
const dw_macinfo_start_file = 3
const dw_macinfo_end_file = 4
const dw_macinfo_vendor_ext = 255

// empty enum
const dw_macro_define = 1
const dw_macro_undef = 2
const dw_macro_start_file = 3
const dw_macro_end_file = 4
const dw_macro_define_strp = 5
const dw_macro_undef_strp = 6
const dw_macro_import = 7
const dw_macro_define_sup = 8
const dw_macro_undef_sup = 9
const dw_macro_import_sup = 10
const dw_macro_define_strx = 11
const dw_macro_undef_strx = 12
const dw_macro_lo_user = 224
const dw_macro_hi_user = 255

// empty enum
const dw_rle_end_of_list = 0
const dw_rle_base_addressx = 1
const dw_rle_startx_endx = 2
const dw_rle_startx_length = 3
const dw_rle_offset_pair = 4
const dw_rle_base_address = 5
const dw_rle_start_end = 6
const dw_rle_start_length = 7

// empty enum
const dw_lle_end_of_list = 0
const dw_lle_base_addressx = 1
const dw_lle_startx_endx = 2
const dw_lle_startx_length = 3
const dw_lle_offset_pair = 4
const dw_lle_default_location = 5
const dw_lle_base_address = 6
const dw_lle_start_end = 7
const dw_lle_start_length = 8

// empty enum
const dw_lle_gnu_end_of_list_entry = 0
const dw_lle_gnu_base_address_selection_entry = 1
const dw_lle_gnu_start_end_entry = 2
const dw_lle_gnu_start_length_entry = 3

// empty enum
const dw_sect_info = 1
const dw_sect_abbrev = 3
const dw_sect_line = 4
const dw_sect_loclists = 5
const dw_sect_str_offsets = 6
const dw_sect_macro = 7
const dw_sect_rnglists = 8

// empty enum
const dw_cfa_advance_loc = 64
const dw_cfa_offset = 128
const dw_cfa_restore = 192
const dw_cfa_extended = 0
const dw_cfa_nop = 0
const dw_cfa_set_loc = 1
const dw_cfa_advance_loc1 = 2
const dw_cfa_advance_loc2 = 3
const dw_cfa_advance_loc4 = 4
const dw_cfa_offset_extended = 5
const dw_cfa_restore_extended = 6
const dw_cfa_undefined = 7
const dw_cfa_same_value = 8
const dw_cfa_register = 9
const dw_cfa_remember_state = 10
const dw_cfa_restore_state = 11
const dw_cfa_def_cfa = 12
const dw_cfa_def_cfa_register = 13
const dw_cfa_def_cfa_offset = 14
const dw_cfa_def_cfa_expression = 15
const dw_cfa_expression = 16
const dw_cfa_offset_extended_sf = 17
const dw_cfa_def_cfa_sf = 18
const dw_cfa_def_cfa_offset_sf = 19
const dw_cfa_val_offset = 20
const dw_cfa_val_offset_sf = 21
const dw_cfa_val_expression = 22
const dw_cfa_low_user = 28
const dw_cfa_mips_advance_loc8 = 29
const dw_cfa_gnu_window_save = 45
const dw_cfa_aarch64_negate_ra_state = 45
const dw_cfa_gnu_args_size = 46
const dw_cfa_gnu_negative_offset_extended = 47
const dw_cfa_high_user = 63

// empty enum
const dw_cie_id_32 = u64(0xffff_ffff)
const dw_cie_id_64 = u64(0xffff_ffff_ffff_ffff)

// empty enum
const dw_eh_pe_absptr = 0
const dw_eh_pe_omit = 255
const dw_eh_pe_uleb128 = 1
const dw_eh_pe_udata2 = 2
const dw_eh_pe_udata4 = 3
const dw_eh_pe_udata8 = 4
const dw_eh_pe_sleb128 = 9
const dw_eh_pe_sdata2 = 10
const dw_eh_pe_sdata4 = 11
const dw_eh_pe_sdata8 = 12
const dw_eh_pe_signed = 8
const dw_eh_pe_pcrel = 16
const dw_eh_pe_textrel = 32
const dw_eh_pe_datarel = 48
const dw_eh_pe_funcrel = 64
const dw_eh_pe_aligned = 80
const dw_eh_pe_indirect = 128