@[translated]
module btexe

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

pub enum Stab_debug_code {
	n_gsym   = 32
	n_fname  = 34
	n_fun    = 36
	n_stsym  = 38
	n_lcsym  = 40
	n_main   = 42
	n_pc     = 48
	n_nsyms  = 50
	n_nomap  = 52
	n_obj    = 56
	n_opt    = 60
	n_rsym   = 64
	n_m2c    = 66
	n_sline  = 68
	n_dsline = 70
	n_bsline = 72
	n_brows  = 72
	n_defd   = 74
	n_ehdecl = 80
	n_mod2   = 80
	n_catch  = 84
	n_ssym   = 96
	n_so     = 100
	n_lsym   = 128
	n_bincl  = 130
	n_sol    = 132
	n_psym   = 160
	n_eincl  = 162
	n_entry  = 164
	n_lbrac  = 192
	n_excl   = 194
	n_scope  = 196
	n_rbrac  = 224
	n_bcomm  = 226
	n_ecomm  = 228
	n_ecoml  = 232
	n_nbtext = 240
	n_nbdata = 242
	n_nbbss  = 244
	n_nbsts  = 246
	n_nblcs  = 248
	n_leng   = 254
	last_unused_stab_code
}

const __SI_MASK = u64(0xffff_0000)
const __SI_KILL = (0 << 16)
const __SI_TIMER = (1 << 16)
const __SI_POLL = (2 << 16)
const __SI_FAULT = (3 << 16)
const __SI_CHLD = (4 << 16)
const __SI_RT = (5 << 16)
const __SI_MESGQ = (6 << 16)
const __SI_SYS = (7 << 16)

fn pstrcpy(buf &char, buf_size usize, s &char) &char {
	q := &char(0)
	q_end := &char(0)

	c := 0
	if buf_size > 0 {
		q = &char(buf)
		q_end = &char(buf) + buf_size - 1
		unsafe {
			for q < q_end {
				c = *s++
				if c == `\x00` {
					break
				}
				*q++ = c
			}
			*q = `\x00`
		}
	}
	return buf
}

@[direct_array_access]
fn rt_printline(rc &Rt_context, wanted_pc Elf64_Addr, msg &char, skip &char) Elf64_Addr {
	func_name := [128]char{}
	func_addr := Elf64_Addr(0)
	last_pc := Elf64_Addr(0)
	pc := Elf64_Addr(0)

	incl_files := [32]&char{}
	incl_index := 0
	last_incl_index := 0
	len := 0
	last_line_num := 0
	i := 0

	str := &char(0)
	p := &char(0)

	sym := &Stab_Sym(0)
	// RRRREG next id=0x7fffd8ce44c8
	next:
	func_name[0] = `\x00`
	func_addr = 0
	incl_index = 0
	last_pc = Elf64_Addr(-1)
	last_line_num = 1
	last_incl_index = 0
	unsafe {
		for sym = rc.u.stab.stab_sym + 1; voidptr(sym) < voidptr(rc.u.stab.stab_sym_end); sym++ {
			str = rc.u.stab.stab_str + sym.n_strx
			pc = sym.n_value
			match Stab_debug_code(sym.n_type) {
				.n_sline { // case comp body kind=IfStmt is_enum=true
					if func_addr {
						goto rel_pc // id: 0x7fffd8ce4f18
					}
				}
				.n_so, .n_sol {
					goto abs_pc // id: 0x7fffd8ce5060
				}
				.n_fun { // case comp body kind=IfStmt is_enum=true
					if sym.n_strx == 0 {
						goto rel_pc // id: 0x7fffd8ce4f18
					}
					// RRRREG abs_pc id=0x7fffd8ce5060
					abs_pc:
					pc += rc.prog_base
					goto check_pc // id: 0x7fffd8ce5328
					// RRRREG rel_pc id=0x7fffd8ce4f18
					rel_pc:
					pc += func_addr
					// RRRREG check_pc id=0x7fffd8ce5328
					check_pc:
					if pc >= wanted_pc && wanted_pc >= last_pc {
						goto found // id: 0x7fffd8ce5578
					}
				}
				else {}
			}
			match Stab_debug_code(sym.n_type) {
				.n_fun { // case comp body kind=IfStmt is_enum=true
					if sym.n_strx == 0 {
						goto reset_func // id: 0x7fffd8ce5870
					}
					p = C.strchr(str, `:`)
					len = p - str + 1
					if 0 == p || len > sizeof(func_name) {
						len = sizeof(func_name)
					}
					pstrcpy(&func_name[0], len, str)
					func_addr = pc
				}
				.n_sline { // case comp body kind=BinaryOperator is_enum=true
					last_pc = pc
					last_line_num = sym.n_desc
					last_incl_index = incl_index
				}
				.n_bincl { // case comp body kind=IfStmt is_enum=true
					if incl_index < 32 {
						incl_files[incl_index++] = str
					}
				}
				.n_eincl { // case comp body kind=IfStmt is_enum=true
					if incl_index > 1 {
						incl_index--
					}
				}
				.n_so { // case comp body kind=BinaryOperator is_enum=true
					incl_index = 0
					if sym.n_strx {
						len = C.strlen(str)
						if len > 0 && str[len - 1] != `/` {
							incl_files[incl_index++] = str
						}
					}
					// RRRREG reset_func id=0x7fffd8ce5870
					reset_func:
					func_name[0] = `\x00`
					func_addr = 0
					last_pc = Elf64_Addr(-1)
				}
				.n_sol { // case comp body kind=IfStmt is_enum=true
					if incl_index {
						incl_files[incl_index - 1] = str
					}
				}
				else {}
			}
		}
	}
	func_name[0] = `\x00`
	func_addr = 0
	last_incl_index = 0
	p = rt_elfsym(rc, wanted_pc, &func_addr)
	if p {
		pstrcpy(&func_name[0], sizeof(func_name), p)
		goto found // id: 0x7fffd8ce5578
	}
	rc = rc.next
	if rc {
		goto next // id: 0x7fffd8ce44c8
	}
	// RRRREG found id=0x7fffd8ce5578
	found:
	i = last_incl_index
	if i > 0 {
		str = incl_files[i-- - 1]
		if skip[0] && C.strstr(str, skip) {
			return Elf64_Addr(-1)
		}
		rt_printf(c'%s:%d: ', str, last_line_num)
	} else { // 3
		rt_printf(c'%08llx : ', i64(wanted_pc))
	}
	if func_name[0] {
		rt_printf(c'%s %s', msg, func_name)
	} else {
		rt_printf(c'%s %s', msg, c'???')
	}

	return func_addr
}

fn dwarf_read_uleb128(ln &&u8, end &u8) i64 {
	cp := *ln
	retval := 0
	i := 0
	for i = 0; i < ((8 * sizeof(i64) + 6) / 7); i++ {
		byte_ := (if cp < end { *cp++ } else { 0 })
		retval |= (byte_ & 127) << (i * 7)
		if (byte_ & 128) == 0 {
			break
		}
	}
	*ln = cp
	return retval
}

fn dwarf_read_sleb128(ln &&u8, end &u8) i64 {
	cp := *ln
	retval := 0
	i := 0
	for i = 0; i < ((8 * sizeof(i64) + 6) / 7); i++ {
		byte_ := (if cp < end { *cp++ } else { 0 })
		retval |= (byte_ & 127) << (i * 7)
		if (byte_ & 128) == 0 {
			if byte_ & 64 && (i + 1) * 7 < 64 {
				retval |= -1 << ((i + 1) * 7)
			}
			break
		}
	}
	*ln = cp
	return retval
}

fn read16le(p &u8) u16 {
	return p[0] | u16(p[1]) << 8
}

fn write16le(p &u8, x u16) {
	p[0] = x & 255
	p[1] = (x >> 8) & 255
}

fn read32le(p &u8) u32 {
	return read16le(p) | u32(read16le(unsafe { p + 2 })) << 16
}

fn write32le(p &u8, x u32) {
	write16le(p, x)
	write16le(unsafe { p + 2 }, x >> 16)
}

fn add32le(p &u8, x int) {
	write32le(p, read32le(p) + x)
}

fn read64le(p &u8) u64 {
	return read32le(p) | u64(read32le(unsafe { p + 4 })) << 32
}

fn write64le(p &u8, x u64) {
	write32le(p, x)
	write32le(unsafe { p + 4 }, x >> 32)
}

fn add64le(p &u8, x i64) {
	write64le(p, read64le(p) + x)
}

#include <semaphore.h>
#include <setjmp.h>

#insert "lib/bcheck.h"

const FILE_TABLE_SIZE = 512

struct enry_format_struct {
	type_ u32
	form  u32
}

struct Dwarf_filename_struct {
	dir_entry int
	name      &char
}

fn C.vprintf(&char, C.va_list) int
fn C.vfprintf(&C.FILE, &char) int
fn C.strstr(&char, &char) &char
fn C.strlen(&char) int
fn C.memcpy(voidptr, voidptr, int) voidptr

@[typedef]
struct C.va_list {}

fn C.va_start(C.va_list, voidptr)
fn C.va_end(voidptr)

fn C.printf(&char, ...)
fn C.vfprintf(&C.FILE, &char, C.va_list) int
fn C.fflush(&C.FILE)
fn C.strchr(&char, char) &char

type RtErrorFn = fn (voidptr, voidptr, &char, C.va_list) int

__global __rt_error = RtErrorFn(unsafe { nil })

@[weak]
fn C.__bound_checking_lock()

@[weak]
fn C.__bound_checking_unlock()

@[weak]
fn C.__bound_init(voidptr, int)

@[weak]
fn C.__bound_exit_dll(voidptr)

@[typedef]
struct C.jmp_buf {
}

@[typedef]
struct C.sem_t {
}

struct TCCSem {
	init int
	sem  C.sem_t
}

type Elf64_Addr = u64
type Elf64_Word = u32
type Elf64_Xword = u64
type Elf64_Section = u16

struct Elf64_Sym {
	st_name  Elf64_Word
	st_info  u8
	st_other u8
	st_shndx Elf64_Section
	st_value Elf64_Addr
	st_size  Elf64_Xword
}

struct Stab_Sym {
	n_strx  u32
	n_type  u8
	n_other u8
	n_desc  u16
	n_value u32
}

union Rt_context_union {
	stab struct {
		stab_sym     &Stab_Sym
		stab_sym_end &Stab_Sym
		stab_str     &char
	}

	dwarf struct {
		dwarf_line     &u8
		dwarf_line_end &u8
		dwarf_line_str &u8
	}
}

struct Rt_context {
	u            Rt_context_union
	dwarf        Elf64_Addr
	esym_start   &Elf64_Sym
	esym_end     &Elf64_Sym
	elf_str      &char
	prog_base    Elf64_Addr
	bounds_start voidptr
	next         &Rt_context
	num_callers  int
	ip           Elf64_Addr
	fp           Elf64_Addr
	sp           Elf64_Addr
	top_func     voidptr
	jb           C.jmp_buf
	do_jmp       int
	nr_exit      int
	exitfunc     [32]voidptr
	exitarg      [32]voidptr
}

__global g_rtctxt = Rt_context{}

@[typedef]
struct C.sigset_t {
}

@[typedef]
struct C.siginfo_t {
	si_signo  int
	si_code   int
	si_errno  int
	si_pid    u64
	si_uid    u64
	s_addr    voidptr
	si_status int
	si_band   int
}

struct C.sigaction {
	sa_handler   fn (int)
	sa_mask      C.sigset_t
	sa_flags     int
	sa_sigaction fn (int, &C.siginfo_t, voidptr)
}

const REG_RIP = 16
const NGREG = 19

@[typedef]
struct C.mcontext_t {
	gregs [NGREG]C.gregset_t
}

@[typedef]
struct C.ucontext_t {
	uc_link     &C.ucontext_t
	uc_sigmask  C.sigset_t
	uc_stack    C.stack_t
	uc_mcontext C.mcontext_t
}

fn C.exit(int)
fn C.longjmp(&C.jmp_buf, int)
fn C.signal(__sig int, __handler C.sighandler_t) C.sighandler_t
fn C.sigemptyset(__set &C.sigset_t) int
fn C.sigaction(int, &sigaction_struct, &sigaction_struct) int

const FPE_INTDIV = (__SI_FAULT | 1) // integer divide by zero
const FPE_INTOVF = (__SI_FAULT | 2) // integer overflow
const FPE_FLTDIV = (__SI_FAULT | 3) // floating point divide by zero
const FPE_FLTOVF = (__SI_FAULT | 4) // floating point overflow
const FPE_FLTUND = (__SI_FAULT | 5) // floating point underflow
const FPE_FLTRES = (__SI_FAULT | 6) // floating point inexact result
const FPE_FLTINV = (__SI_FAULT | 7) // floating point invalid operation
const FPE_FLTSUB = (__SI_FAULT | 8) // subscript out of range
const NSIGFPE = 8

@[direct_array_access]
fn rt_getcontext(uc &C.ucontext_t, rc &Rt_context) {
	rc.ip = uc.uc_mcontext.gregs[btexe.REG_RIP]
	rc.fp = uc.uc_mcontext.gregs[btexe.REG_RIP]
}

fn rt_exit(code int) {
	rc := &g_rtctxt
	if rc.do_jmp {
		C.longjmp(rc.jb, if code { code } else { 256 })
	}
	C.exit(code)
}

fn sig_error(signum int, siginf &C.siginfo_t, puc voidptr) {
	rc := &g_rtctxt
	rt_getcontext(puc, rc)
	match signum {
		8 { // case comp body kind=SwitchStmt is_enum=false
			match siginf.si_code {
				int(btexe.FPE_INTDIV), int(btexe.FPE_FLTDIV) {
					rt_error(c'division by zero')
				}
				else {
					rt_error(c'floating point exception')
				}
			}
		}
		7, 11 {
			rt_error(c'invalid memory access')
		}
		4 { // case comp body kind=CallExpr is_enum=false
			rt_error(c'illegal instruction')
		}
		6 { // case comp body kind=CallExpr is_enum=false
			rt_error(c'abort() called')
		}
		else {
			rt_error(c'caught signal %d', signum)
		}
	}
	rt_exit(255)
}

fn rt_error(const_fmt &char, ...) int {
	ap := C.va_list{}
	ret := 0
	C.va_start(ap, const_fmt)
	ret = _rt_error(0, 0, const_fmt, ap)
	C.va_end(ap)
	return ret
}

fn set_exception_handler() {
	sigact := C.sigaction{}
	C.sigemptyset(&sigact.sa_mask)
	sigact.sa_flags = 4 | 2147483648
	sigact.sa_sigaction = sig_error
	C.sigemptyset(&sigact.sa_mask)
	C.sigaction(8, &sigact, unsafe { nil })
	C.sigaction(4, &sigact, unsafe { nil })
	C.sigaction(11, &sigact, unsafe { nil })
	C.sigaction(7, &sigact, unsafe { nil })
	C.sigaction(6, &sigact, unsafe { nil })
}

@[export: '__bt_init']
fn __bt_init(p &Rt_context, num_callers int) {
	main := C.main
	__bound_init := C.__bound_init
	rc := &g_rtctxt
	if p.bounds_start {
		__bound_init(p.bounds_start, -1)
		C.__bound_checking_lock()
	}
	if num_callers {
		C.memcpy(rc, p, __offsetof(Rt_context, next))
		rc.num_callers = num_callers - 1
		rc.top_func = main
		__rt_error = _rt_error
		set_exception_handler()
	} else {
		p.next = rc.next
		rc.next = p
	}
	if p.bounds_start {
		C.__bound_checking_unlock()
	}
}

@[direct_array_access; inline]
fn rt_get_caller_pc(paddr &Elf64_Addr, rc &Rt_context, level int) int {
	ip := Elf64_Addr(0)
	fp := Elf64_Addr(0)

	if level == 0 {
		ip = rc.ip
	} else {
		ip = 0
		fp = rc.fp
		for {
			level--
			if level == 0 {
				break
			}
			// XXX: check address validity with program info
			if fp <= Elf64_Addr(0x1000) {
				break
			}
			fp = &Elf64_Addr(fp)[0]
		}
		if fp > Elf64_Addr(0x1000) {
			ip = &Elf64_Addr(fp)[1]
		}
	}
	if ip <= Elf64_Addr(0x1000) {
		return -1
	}
	*paddr = ip
	return 0
}

fn rt_elfsym(rc &Rt_context, wanted_pc Elf64_Addr, func_addr &Elf64_Addr) &char {
	esym := &Elf64_Sym(0)
	unsafe {
		for esym = rc.esym_start + 1; voidptr(esym) < voidptr(rc.esym_end); esym++ {
			type_ := ((esym.st_info) & 15)
			if (type_ == 2 || type_ == 10) && wanted_pc >= esym.st_value
				&& wanted_pc < esym.st_value + esym.st_size {
				*func_addr = esym.st_value
				return rc.elf_str + esym.st_name
			}
		}
	}
	return unsafe { nil }
}

@[inline]
fn rt_vprintf(const_fmt &char, ap C.va_list) int {
	ret := C.vfprintf(C.stderr, const_fmt, ap)
	C.fflush(C.stderr)
	return ret
}

@[inline]
fn rt_printf(const_fmt &char, ...) int {
	ap := C.va_list{}
	r := 0
	C.va_start(ap, const_fmt)
	r = rt_vprintf(const_fmt, ap)
	C.va_end(ap)
	return r
}

@[direct_array_access]
fn _rt_error(fp voidptr, ip voidptr, fmt &char, ap C.va_list) int {
	rc := &g_rtctxt
	pc := Elf64_Addr(0)
	skip := [100]char{}
	mut i := 0
	mut level := 0
	mut ret := 0
	mut n := 0
	mut one := 0
	a := &char(0)
	b := &char(0)
	msg := &char(0)

	if fp != unsafe { nil } {
		// we're called from tcc_backtrace.
		rc.fp = fp
		rc.ip = ip
		msg = c''
	} else {
		// we're called from signal/exception handler
		msg = c'RUNTIME ERROR: '
	}

	skip[0] = 0
	// If fmt is like "^file.c^..." then skip calls from 'file.c'
	if fmt[0] == `^` {
		a = fmt + 1
		b = C.strchr(a, fmt[0])
		if b {
			C.memcpy(skip, a, b - a)
			skip[b - a] = 0
			fmt = b + 1
		}
	}
	one = 0
	// hack for bcheck.c:dprintf(): one level, no newline
	if fmt[0] == `\001` {
		fmt += 1
		one = 1
	}
	n = if rc.num_callers { rc.num_callers } else { 6 }
	for ; level < n; i++ {
		ret = rt_get_caller_pc(&pc, rc, i)
		a = c'%s'
		if ret != -1 {
			if rc.dwarf {
				pc = rt_printline_dwarf(rc, pc, if level { c'by' } else { c'at' }, skip)
			} else {
				pc = rt_printline(rc, pc, if level { c'by' } else { c'at' }, skip)
			}
			if pc == Elf64_Addr(-1) {
				continue
			}
			a = c': %s'
		}
		if level == 0 {
			rt_printf(a, msg)
			rt_vprintf(fmt, ap)
		} else if (ret == -1) {
			break
		}
		if one {
			break
		}
		rt_printf(c'\n')
		if ret == -1 || (pc == Elf64_Addr(rc.top_func) && pc) {
			break
		}
		level++
	}
	rc.ip = 0
	rc.fp = 0
	return 0
}

@[export: '__bt_exit']
fn __bt_exit(p &Rt_context) {
	bound_exit_dll := C.__bound_exit_dll
	rc := &g_rtctxt
	if p.bounds_start {
		bound_exit_dll(p.bounds_start)
		C.__bound_checking_lock()
	}
	for rc {
		if voidptr(rc.next) == voidptr(p) {
			rc.next = rc.next.next
			break
		}
		rc = rc.next
	}
	if p.bounds_start {
		C.__bound_checking_unlock()
	}
}

fn tcc_pstrcpy(buf &char, buf_size usize, s &char) &char {
	l := C.strlen(s)
	if l >= buf_size {
		l = buf_size - 1
	}
	C.memcpy(buf, s, l)
	buf[l] = 0
	return buf
}

@[direct_array_access]
fn rt_printline_dwarf(rc &Rt_context, wanted_pc Elf64_Addr, msg &char, skip &char) Elf64_Addr {
	ln := &u8(0)
	cp := &u8(0)
	end := &u8(0)
	opcode_length := &u8(0)
	size := i64(0)
	length := u32(0)
	version := u8(0)
	min_insn_length := u32(0)
	max_ops_per_insn := u32(0)
	line_base := 0
	line_range := u32(0)
	opcode_base := u32(0)
	opindex := u32(0)
	col := u32(0)
	i := u32(0)
	j := u32(0)
	len := u32(0)
	value := i64(0)
	entry_format := [256]enry_format_struct{}
	dir_size := u32(0)
	filename_size := u32(0)
	filename_table := [btexe.FILE_TABLE_SIZE]Dwarf_filename_struct{}
	last_pc := Elf64_Addr(0)
	pc := Elf64_Addr(0)
	func_addr := Elf64_Addr(0)
	line := 0
	filename := &char(0)
	function := &char(0)
	// RRRREG next id=0x7fffd8cedcc0
	next:
	ln = rc.u.dwarf.dwarf_line
	for ln < rc.u.dwarf.dwarf_line_end {
		dir_size = 0
		filename_size = 0
		last_pc = 0
		pc = 0
		func_addr = 0
		line = 1
		filename = (unsafe { nil })
		function = (unsafe { nil })
		length = 4
		size = if ln + 4 < (rc.u.dwarf.dwarf_line_end) {
			ln += 4
			read32le(ln - 4)
		} else {
			0
		}
		if size == 4294967295 {
			length = 8
			size = if ln + 8 < (rc.u.dwarf.dwarf_line_end) {
				ln += 8
				read64le(ln - 8)
			} else {
				0
			}
		}
		end = ln + size
		if end < ln || end > rc.u.dwarf.dwarf_line_end {
			break
		}
		version = if ln + 2 < end {
			ln += 2
			read16le(ln - 2)
		} else {
			0
		}
		if version >= 5 {
			ln += length + 2
		} else { // 3
			ln += length
		}
		min_insn_length = (if ln < end { *ln++ } else { 0 })
		if version >= 4 {
			max_ops_per_insn = (if ln < end { *ln++ } else { 0 })
		} else { // 3
			max_ops_per_insn = 1
		}
		ln++
		line_base = (if ln < end { *ln++ } else { 0 })
		line_base |= if line_base >= 128 { ~255 } else { 0 }
		line_range = (if ln < end { *ln++ } else { 0 })
		opcode_base = (if ln < end { *ln++ } else { 0 })
		opcode_length = ln
		ln += opcode_base - 1
		opindex = 0
		if version >= 5 {
			col = (if ln < end { *ln++ } else { 0 })
			for i = 0; i < col; i++ {
				entry_format[i].type_ = dwarf_read_uleb128(&ln, end)
				entry_format[i].form = dwarf_read_uleb128(&ln, end)
			}
			dir_size = dwarf_read_uleb128(&ln, end)
			for i = 0; i < dir_size; i++ {
				for j = 0; j < col; j++ {
					if entry_format[j].type_ == btexe.dw_lnct_path {
						if entry_format[j].form != btexe.dw_form_line_strp {
							goto next_line // id: 0x7fffd8cf3458
						}
						if length == 4 {
							if ln + 4 < end {
								ln += 4
								read32le(ln - 4)
							}
						} else {
							if ln + 8 < end {
								ln += 8
								read64le(ln - 8)
							}
						}
					} else { // 3
					}
				}
			}
			col = (if ln < end { *ln++ } else { 0 })
			for i = 0; i < col; i++ {
				entry_format[i].type_ = dwarf_read_uleb128(&ln, end)
				entry_format[i].form = dwarf_read_uleb128(&ln, end)
			}
			filename_size = dwarf_read_uleb128(&ln, end)
			for i = 0; i < filename_size; i++ {
				for j = 0; j < col; j++ {
					if entry_format[j].type_ == btexe.dw_lnct_path {
						if entry_format[j].form != btexe.dw_form_line_strp {
							goto next_line // id: 0x7fffd8cf3458
						}
						value = if length == 4 {
							if ln + 4 < end {
								ln += 4
								read32le(ln - 4)
							} else {
								0
							}
						} else {
							if ln + 8 < end {
								ln += 8
								read64le(ln - 8)
							} else {
								0
							}
						}
						if i < (512) {
							filename_table[i].name = &char(rc.u.dwarf.dwarf_line_str) + value
						}
					} else if entry_format[j].type_ == btexe.dw_lnct_directory_index {
						match entry_format[j].form {
							btexe.dw_form_data1 { // case comp body kind=BinaryOperator is_enum=true
								value = (if ln < end { *ln++ } else { 0 })
							}
							btexe.dw_form_data2 { // case comp body kind=BinaryOperator is_enum=true
								value = (if ln + 2 < end {
									ln += 2
									read16le(ln - 2)
								} else {
									0
								})
							}
							btexe.dw_form_data4 { // case comp body kind=BinaryOperator is_enum=true
								value = (if ln + 4 < end {
									ln += 4
									read32le(ln - 4)
								} else {
									0
								})
							}
							btexe.dw_form_udata { // case comp body kind=BinaryOperator is_enum=true
								value = dwarf_read_uleb128(&ln, end)
							}
							else {
								goto next_line // id: 0x7fffd8cf3458
							}
						}
						if i < (512) {
							filename_table[i].dir_entry = value
						}
					} else { // 3
					}
					0
				}
			}
		} else {
			for (if ln < end {
				*ln++
			} else {
				0
			}) {
				for (if ln < end {
					*ln++
				} else {
					0
				}) {
				}
			}
			for (if ln < end {
				*ln++
			} else {
				0
			}) {
				if (filename_size++ + 1) < (512) {
					filename_table[filename_size - 1].name = &char(ln) - 1
					for (if ln < end {
						*ln++
					} else {
						0
					}) {
					}
					filename_table[filename_size - 1].dir_entry = dwarf_read_uleb128(&ln,
						end)
				} else {
					for (if ln < end {
						*ln++
					} else {
						0
					}) {
					}
					dwarf_read_uleb128(&ln, end)
				}
				dwarf_read_uleb128(&ln, end)
				dwarf_read_uleb128(&ln, end)
			}
		}
		if filename_size >= 1 {
			filename = filename_table[0].name
		}
		for ln < end {
			last_pc = pc
			i = (if ln < end { *ln++ } else { 0 })
			if i >= opcode_base {
				if max_ops_per_insn == 1 {
					pc += ((i - opcode_base) / line_range) * min_insn_length
				} else {
					pc += (opindex + (i - opcode_base) / line_range) / max_ops_per_insn * min_insn_length
					opindex = (opindex + (i - opcode_base) / line_range) % max_ops_per_insn
				}
				i = int(((i - opcode_base) % line_range)) + line_base
				// RRRREG check_pc id=0x7fffd8cf9e20
				check_pc:
				if pc >= wanted_pc && wanted_pc >= last_pc {
					goto found // id: 0x7fffd8cf9d98
				}
				line += i
			} else {
				match i {
					0 { // case comp body kind=BinaryOperator is_enum=true
						len = dwarf_read_uleb128(&ln, end)
						cp = ln
						ln += len
						if len == 0 {
							goto next_line // id: 0x7fffd8cf3458
						}
						z := if cp < end {
							*cp++
						} else {
							0
						}
						match z {
							btexe.dw_lne_end_sequence { // case comp body kind=BreakStmt is_enum=true
							}
							btexe.dw_lne_set_address { // case comp body kind=BinaryOperator is_enum=true
								pc = (if cp + 8 < end {
									cp += 8
									read64le(cp - 8)
								} else {
									0
								})
								opindex = 0
							}
							btexe.dw_lne_define_file { // case comp body kind=IfStmt is_enum=true
								if (filename_size++ + 1) < (512) {
									filename_table[filename_size - 1].name = &char(ln) - 1
									for (if ln < end {
										*ln++
									} else {
										0
									}) {
									}
									filename_table[filename_size - 1].dir_entry = dwarf_read_uleb128(&ln,
										end)
								} else {
									for (if ln < end {
										*ln++
									} else {
										0
									}) {
									}
									dwarf_read_uleb128(&ln, end)
								}
								dwarf_read_uleb128(&ln, end)
								dwarf_read_uleb128(&ln, end)
							}
							btexe.dw_lne_hi_user - 1 { // case comp body kind=BinaryOperator is_enum=true
								function = &char(cp)
								func_addr = pc
							}
							else {}
						}
					}
					btexe.dw_lns_advance_pc { // case comp body kind=IfStmt is_enum=true
						if max_ops_per_insn == 1 {
							pc += dwarf_read_uleb128(&ln, end) * min_insn_length
						} else {
							off := dwarf_read_uleb128(&ln, end)
							pc += (opindex + off) / max_ops_per_insn * min_insn_length
							opindex = (opindex + off) % max_ops_per_insn
						}
						i = 0
						goto check_pc // id: 0x7fffd8cf9e20
					}
					btexe.dw_lns_advance_line { // case comp body kind=CompoundAssignOperator is_enum=true
						line += dwarf_read_sleb128(&ln, end)
					}
					btexe.dw_lns_set_file { // case comp body kind=BinaryOperator is_enum=true
						i = dwarf_read_uleb128(&ln, end)
						i -= i > 0 && version < 5
						if i < (512) && i < filename_size {
							filename = filename_table[i].name
						}
					}
					btexe.dw_lns_const_add_pc { // case comp body kind=IfStmt is_enum=true
						if max_ops_per_insn == 1 {
							pc += ((255 - opcode_base) / line_range) * min_insn_length
						} else {
							off := (255 - opcode_base) / line_range
							pc += ((opindex + off) / max_ops_per_insn) * min_insn_length
							opindex = (opindex + off) % max_ops_per_insn
						}
						i = 0
						goto check_pc // id: 0x7fffd8cf9e20
					}
					btexe.dw_lns_fixed_advance_pc { // case comp body kind=BinaryOperator is_enum=true
						i = (if ln + 2 < end {
							ln += 2
							read16le(ln - 2)
						} else {
							0
						})
						pc += i
						opindex = 0
						i = 0
						goto check_pc // id: 0x7fffd8cf9e20
					}
					else {
						for j = 0; j < opcode_length[i - 1]; j++ {
							dwarf_read_uleb128(&ln, end)
						}
					}
				}
			}
		}
		// RRRREG next_line id=0x7fffd8cf3458
		next_line:
		ln = end
	}
	filename = unsafe { nil }
	func_addr = 0
	function = rt_elfsym(rc, wanted_pc, &func_addr)
	if function {
		goto found // id: 0x7fffd8cf9d98
	}
	rc = rc.next
	if rc {
		goto next // id: 0x7fffd8cedcc0
	}
	// RRRREG found id=0x7fffd8cf9d98
	found:
	if filename {
		if skip[0] && C.strstr(filename, skip) {
			return Elf64_Addr(-1)
		}
		rt_printf(c'%s:%d: ', filename, line)
	} else { // 3
		rt_printf(c'0x%08llx : ', i64(wanted_pc))
	}
	if function {
		rt_printf(c'%s %s', msg, function)
	} else {
		rt_printf(c'%s %s', msg, c'???')
	}
	return Elf64_Addr(func_addr)
}
