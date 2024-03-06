@[translated]
module main

#include <setjmp.h>
#include <semaphore.h>

@[typedef]
struct C.jmp_buf {
}

__global int_type = CType{}
__global func_old_type = CType{}
__global char_pointer_type = CType{}
__global char_type = CType{}
__global vtop = &SValue(0)
__global rsym = int(0)
__global anon_sym = int(0)
__global ind = int(0)
__global loc = int(0)
__global debug_modes = char(0)

__global tcc_compile_sem = TCCSem{}

__global nocode_wanted = int(0)
__global global_expr = int(0)
__global func_vt = CType{}
__global func_var = int(0)
__global func_vc = int(0)
__global func_ind = int(0)
__global funcname = &char(0)

__global tcc_state = &TCCState(0)

pub const CONFIG_SYSROOT = '/usr/lib/x86_64-linux-gnu'

pub const CH_EOF = (-1) // end of file
pub const VSTACK_SIZE = 512
pub const IFDEF_STACK_SIZE = 64
pub const CACHED_INCLUDES_HASH_SIZE = 32
pub const PACK_STACK_SIZE = 8
pub const INCLUDE_STACK_SIZE = 32

pub struct TokenSym {
	hash_next      &TokenSym
	sym_define     &Sym
	sym_label      &Sym
	sym_struct     &Sym
	sym_identifier &Sym
	tok            int
	len            int
	str            [1]char
}

pub type Nwchar_t = int

pub struct CString {
	size           int
	size_allocated int
	data           voidptr
}

// pub struct CString {
// 	size           int
// 	size_allocated int
// 	data           voidptr
// }

pub struct CType {
	t   int
	ref &Sym
}

pub const ldouble_size = 16

pub union CValue {
	ld  f64
	d   f64
	f   f32
	i   u64
	str struct {
		data voidptr
		size int
	}

	tab [ldouble_size / 4]int
}

pub struct SValue {
	type_  CType
	r      u16
	r2     u16
	jtrue  int
	jfalse int
	c      CValue
	cmp_op u16
	cmp_r  u16
	sym    &Sym
}

pub struct SymAttr {
	aligned    u16
	packed     u16
	weak       u16
	visibility u16
	dllexport  u16
	nodecorate u16
	dllimport  u16
	addrtaken  u16
	nodebug    u16
	xxxx       u16
}

pub struct FuncAttr {
	func_call     u32
	func_type     u32
	func_noreturn u32
	func_ctor     u32
	func_dtor     u32
	func_args     u32
	func_alwinl   u32
	xxxx          u32
}

pub struct Sym {
	v             int
	r             u16
	a             SymAttr
	c             int
	sym_scope     int
	jnext         int
	f             FuncAttr
	auxtype       int
	enum_val      i64
	d             &int
	ncl           &Sym
	type_         CType
	vla_array_str &int
	next          &Sym
	cleanupstate  &Sym
	asm_label     int
	prev          &Sym = unsafe { nil }
	prev_tok      &Sym = unsafe { nil }
}

pub struct Section {
	data_offset    u32
	data           &u8
	data_allocated u32
	s1             &TCCState
	sh_name        int
	sh_num         int
	sh_type        int
	sh_flags       int
	sh_info        int
	sh_addralign   int
	sh_entsize     int
	sh_size        u32
	sh_addr        Elf64_Addr
	sh_offset      u32
	nb_hashed_syms int
	link           &Section
	reloc          &Section
	hash           &Section
	prev           &Section
	name           [1]char
}

@[minify]
struct TCCState {
	verbose          u8  // if true, display some information during compilation
	nostdinc         u8  // if true, no standard headers are added
	nostdlib         u8  // if true, no standard libraries are added
	nocommon         u8  // if true, do not use common symbols for .bss data
	static_link      u8  // if true, static linking is performed
	rdynamic         u8  // if true, all symbols are exported
	symbolic         u8  // if true, resolve symbols in the current module first
	filetype         u8  // file type for compilation (NONE,C,ASM)
	optimize         u8  // only to #define __OPTIMIZE__
	option_pthread   u8  // -pthread option
	enable_new_dtags u8  // -Wl,--enable-new-dtags
	cversion         u64 // supported C ISO version, 199901 (the default), 201112, ...
	// C language options
	char_is_unsigned       u8
	leading_underscore     u8
	ms_extensions          u8 // allow nested named struct w/o identifier behave like unnamed
	dollars_in_identifiers u8 // allows c'$' char in identifiers
	ms_bitfields           u8 // if true, emulate MS algorithm for aligning bitfields
	// warning switches
	warn_none                          u8
	warn_all                           u8
	warn_error                         u8
	warn_write_strings                 u8
	warn_unsupported                   u8
	warn_implicit_function_declaration u8
	warn_discarded_qualifiers          u8
	warn_num                           u8 // temp var for tcc_warning_c()

	option_r         u8 // option -r
	do_bench         u8 // option -bench
	just_deps        u8 // option -M
	gen_deps         u8 // option -MD
	include_sys_deps u8 // option -MD
	gen_phony_deps   u8 // option -MP
	// compile with debug symbol (and use them if error during execution)
	do_debug     u8
	dwarf        u8
	do_backtrace u8
	// compile with built-in memory and bounds checker
	do_bounds_check u8
	test_coverage   u8 // generate test coverage code
	// use GNU C extensions
	gnu_ext u8
	// use TinyCC extensions
	tcc_ext u8

	dflag u8 // -dX value
	pflag u8 // -P switch (LINE_MACRO_OUTPUT_FORMAT)

	nosse u8 // For -mno-sse support.
	//#ifdef TCC_TARGET_ARM
	//    float_abi u8 // float ABI of the generated code
	//#endif

	has_text_addr u8
	text_addr     u64   // address of text section
	section_align usize // section alignment
	//#ifdef TCC_TARGET_I386
	seg_size int // 32. Can be 16 with i386 assembler (.code16)
	//#endif

	tcc_lib_path  &char // CONFIG_TCCDIR or -B option
	soname        &char // as specified on the command line (-soname)
	rpath         &char // as specified on the command line (-Wl,-rpath=)
	elf_entryname &char // "_start" unless set
	init_symbol   &char // symbols to call at load-time (not used currently)
	fini_symbol   &char // symbols to call at unload-time (not used currently)
	mapfile       &char // create a mapfile (not used currently)
	// output type, see TCC_OUTPUT_XXX
	output_type int
	// output format, see TCC_OUTPUT_FORMAT_xxx
	output_format int
	// nth test to run with -dt -run
	run_test int
	// array of all loaded dlls (including those referenced by loaded dlls)
	loaded_dlls    &&DLLReference
	nb_loaded_dlls int
	// include paths
	include_paths    &&char
	nb_include_paths int

	sysinclude_paths    &&char
	nb_sysinclude_paths int
	// library paths
	library_paths    &&char
	nb_library_paths int
	// crt?.o object path
	crt_paths    &&char
	nb_crt_paths int
	// -D / -U options
	cmdline_defs CString
	// -include options
	cmdline_incl CString
	// error handling
	error_opaque          voidptr
	error_func            fn (voidptr, &char) = unsafe { nil }
	error_set_jmp_enabled int
	error_jmp_buf         C.jmp_buf
	nb_errors             int
	// output file for preprocessing (-E)
	ppfp &C.FILE
	// for -MD/-MF: collected dependencies for this compilation
	target_deps    &&char
	nb_target_deps int
	// compilation
	include_stack     [INCLUDE_STACK_SIZE]&BufferedFile
	include_stack_ptr &&BufferedFile

	ifdef_stack     [IFDEF_STACK_SIZE]int
	ifdef_stack_ptr &int
	// included files enclosed with #ifndef MACRO
	cached_includes_hash [CACHED_INCLUDES_HASH_SIZE]int
	cached_includes      &&CachedInclude
	nb_cached_includes   int
	// #pragma pack stack
	pack_stack     [PACK_STACK_SIZE]int
	pack_stack_ptr &int
	pragma_libs    &&char
	nb_pragma_libs int
	/* inline functions are stored as token lists and compiled last
       only if referenced */
	inline_fns    &&InlineFunc
	nb_inline_fns int
	// sections
	sections    &&Section
	nb_sections int // number of sections, including first dummy section

	priv_sections    &&Section
	nb_priv_sections int // number of private sections
	// predefined sections
	text_section     &Section
	data_section     &Section
	rodata_section   &Section
	bss_section      &Section
	common_section   &Section
	cur_text_section &Section // current section where function code is generated
	//#ifdef CONFIG_TCC_BCHECK
	// bound check related sections
	bounds_section  &Section // contains global data bound description
	lbounds_section &Section // contains local data bound description
	//#endif
	// symbol section
	symtab_section &Section
	// temporary dynamic symbol sections (for dll loading)
	dynsymtab_section &Section
	// exported dynamic symbol section
	dynsym &Section
	// copy of the global symtab_section variable
	symtab &Section
	// got & plt handling
	got &Section
	plt &Section
	// debug sections
	stab_section           &Section
	dwarf_info_section     &Section
	dwarf_abbrev_section   &Section
	dwarf_line_section     &Section
	dwarf_aranges_section  &Section
	dwarf_str_section      &Section
	dwarf_line_str_section &Section
	dwlo                   int
	dwhi                   int // dwarf section range
	// test coverage
	tcov_section &Section
	// debug state
	dState &Tccdbg
	// Is there a new undefined sym since last new_undef_sym()
	new_undef_sym int
	// extra attributes (eg. GOT/PLT value) for symtab symbols
	sym_attrs    &Sym_attr
	nb_sym_attrs int
	// ptr to next reloc entry reused
	qrel &Elf64_Rel
	//#ifdef TCC_TARGET_PE
	// PE info
	pe_subsystem       int
	pe_characteristics u16
	pe_file_align      u16
	pe_stack_size      u16
	pe_imagebase       u64
	//# ifdef TCC_TARGET_X86_64
	uw_pdata &Section
	uw_sym   int
	uw_offs  u16
	//# endif
	//#endif
	//#if defined TCC_TARGET_MACHO
	install_name          &char
	compatibility_version u32
	current_version       u32
	//#endif
	//#ifndef ELF_OBJ_ONLY
	nb_sym_versions   int
	sym_versions      &Sym_version
	nb_sym_to_version int
	sym_to_version    &int
	dt_verneednum     int
	versym_section    &Section
	verneed_section   &Section
	//#endif
	//#ifdef TCC_IS_NATIVE
	runtime_main   &char
	runtime_mem    &voidptr
	nb_runtime_mem int
	//#endif
	//#ifdef CONFIG_TCC_BACKTRACE
	rt_num_callers int
	//#endif
	// benchmark info
	total_idents int
	total_lines  int
	total_bytes  u64
	total_output [4]u64
	// option -dnum (for general development purposes)
	g_debug int
	// used by tcc_load_ldscript
	fd int
	cc int
	// for warnings/errors for object files
	current_filename &char
	// used by main and tcc_parse_args only
	files        &&Filespec // files seen on command line
	nb_files     int        // number thereof
	nb_libraries int        // number of libs thereof
	outfile      &char      // output filename
	deps_outfile &char      // option -MF
	argc         int
	argv         &&char
	linker_arg   CString // collect -Wl options
}

pub struct DLLReference {
	level  int
	handle voidptr
	found  u8
	index  u8
	name   [1]char
}

pub struct BufferedFile {
	buf_ptr            &u8
	buf_end            &u8
	fd                 int
	prev               &BufferedFile
	line_num           int
	line_ref           int
	ifndef_macro       int
	ifndef_macro_saved int
	ifdef_stack_ptr    &int
	include_next_index int
	filename           [1024]char
	truefilename       &char
	unget              [4]u8
	buffer             [1]u8
}

pub struct TokenString {
	str           &int
	len           int
	lastlen       int
	allocated_len int
	last_line_num int
	save_line_num int
	prev          &TokenString
	prev_ptr      &int
	alloc         char
}

pub struct AttributeDef {
	a            SymAttr
	f            FuncAttr
	section      &Section
	cleanup_func &Sym
	alias_target int
	asm_label    int
	attr_mode    i8
}

pub struct InlineFunc {
	func_str &TokenString
	sym      &Sym
	filename [1]char
}

pub struct CachedInclude {
	ifndef_macro int
	once         int
	hash_next    int
	filename     [1]char
}

pub struct ExprValue {
	v     u64
	sym   &Sym
	pcrel int
}

pub struct ASMOperand {
	id          int
	constraint  [16]i8
	asm_str     [16]i8
	vt          &SValue
	ref_index   int
	input_index int
	priority    int
	reg         int
	is_llong    int
	is_memory   int
	is_rw       int
	is_label    int
}

pub struct Sym_attr {
	got_offset u32
	plt_offset u32
	plt_sym    int
	dyn_index  int
}

pub struct Filespec {
	type_ int
	name  [1]char
}

enum Tcc_token as u16 {
	tok_last                       = 256 - 1
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

__global tokcstr = CString{}

enum Line_macro_output_format {
	line_macro_output_format_gcc
	line_macro_output_format_none
	line_macro_output_format_std
	line_macro_output_format_p10  = 11
}

fn is_space(ch int) bool {
	return ch == ` ` || ch == `\t` || ch == `\v` || ch == `\f` || ch == `\r`
}

fn isid(c int) bool {
	return (c >= `a` && c <= `z`) || (c >= `A` && c <= `Z`) || c == `_`
}

fn isnum(c int) bool {
	return c >= `0` && c <= `9`
}

fn isoct(c int) bool {
	return c >= `0` && c <= `7`
}

fn toup(c u8) u8 {
	return if (c >= `a` && c <= `z`) { u8(c) - u8(`a`) + u8(`A`) } else { u8(c) }
}

pub struct Stab_Sym {
	n_strx  u32
	n_type  u8
	n_other u8
	n_desc  u16
	n_value u32
}

enum Gotplt_entry {
	no_gotplt_entry
	build_got_only
	auto_gotplt_entry
	always_gotplt_entry
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

@[typedef]
struct C.sem_t {
}

pub struct TCCSem {
	init int
	sem  C.sem_t
}
