@[translated]
module main

pub const TOK_IDENT = 256
const SYM_POOL_NB = 8192 / sizeof(Sym)

const dif_first = 1
const dif_size_only = 2
const dif_have_elem = 4
const dif_clear = 8

const expr_const = 1
const expr_any = 2

const tok_udiv = 0x83 // unsigned division
const tok_umod = 0x84 // unsigned modulo
const tok_pdiv = 0x85 // fast division with undefined rounding for pointers
const tok_shl = `<` // shift left
const tok_sar = `>` // signed shift right
const tok_shr = 0x8b // unsigned shift right
const tok_str = 0xc8 // pointer to string in tokc
const tok_lstr = 0xc9

const tok_ult = 0x92
const tok_uge = 0x93

const rc_int = 0x0001 // generic integer register
const rc_float = 0x0002 // generic float register

const vt_valmask = 0x003f // mask for value location, register or:
const vt_cmp = 0x0033 // the value is stored in processor flags (in vc)
const vt_jmp = 0x0034 // value is the consequence of jmp true (even)
const vt_lval = 0x0100 // var is an lvalue
const vt_const = 0x0030 // c onstant in vc (must be first non register value)
const vt_llocal = 0x0031 // lvalue, offset on stack
const vt_local = 0x0032 // offset on stack
const vt_sym = 0x0200 // a symbol value is added
const vt_mustcast = 0x0C0
const vt_nonconst = 0x1000 // VT_CONST, but not an (C standard) integer constant expression
const vt_mustbound = 0x4000
const vt_bounded = 0x8000 // value is bounded. The address of the bounding function call point is in vc

const vt_btype = 0x000f // mask for basic type
const vt_void = 0 // void type
const vt_byte = 1 // signed byte type
const vt_short = 2 //  short type
const vt_int = 3
const vt_llong = 4 //  64 bit integer
const vt_ptr = 5 //  pointer
const vt_func = 6 //  function type
const vt_struct = 7 //  struct/union definition
const vt_float = 8 //  IEEE float
const vt_double = 9 //  IEEE double
const vt_ldouble = 10 //  IEEE long double
const vt_bool = 11 //  ISOC99 boolean type
const vt_qlong = 13 //  128-bit integer. Only used for x86-64 ABI
const vt_qfloat = 14 //  128-bit float. Only used for x86-64 ABI

const vt_struct_shift = 20
const vt_union = ((1 << vt_struct_shift) | vt_struct)
const vt_enum = (2 << vt_struct_shift)

const vt_atomic = vt_volatile
const vt_storage = (vt_extern | vt_static | vt_typedef | vt_inline)

const vt_unsigned = 0x0010 // unsigned type
const vt_defsign = 0x0020 // explicitly signed or unsigned
const vt_long = 0x0800 // long type (also has VT_INT rsp. VT_LLONG)
const vt_constant = 0x0100 // const modifier
const vt_volatile = 0x0200 // volatile modifier
const vt_vla = 0x0400 // VLA type (also has VT_PTR and VT_ARRAY)
const vt_bitfield = 0x0040
const vt_array = 0x0040 // array type (also has VT_PTR)

const vt_extern = 0x00001000 // extern definition
const vt_static = 0x00002000 // static variable
const vt_typedef = 0x00004000 // typedef definition
const vt_inline = 0x00008000 // inline definition

const vt_size_t = (vt_llong | vt_unsigned)
const vt_ptrdiff_t = (vt_long | vt_llong)

const sym_struct = 0x40000000 // struct/union/enum symbol space
const sym_field = 0x20000000 // struct/union field symbol space
const sym_first_anom = 0x10000000 // first anonymous sym

// field 'Sym.r' for C labels
const label_defined = 0 // label is defined
const label_forward = 1 // label is forward defined
const label_declared = 2 // label is declared but never used
const label_gone = 3 // label isn't in scope, but not yet popped from local_label_stack (stmt exprs)

// type_decl() types
const type_abstract = 1 // type without variable
const type_direct = 2 // type with variable
const type_param = 4 // type declares function parameter
const type_nest = 8 // nested call to post_type

// stored in 'Sym->f.func_type' field
const func_new = 1 // ansi function prototype
const func_old = 2 // old function prototype
const func_ellipsis = 3 // ansi function prototype with ...

const func_cdecl = 0 // standard c call

const parse_flag_preprocess = 0x0001 // activate preprocessing
const parse_flag_tok_num = 0x0002 // return numbers instead of TOK_PPNUM
const parse_flag_linefeed = 0x0004 // line feed is returned as a token. line feed is also returned at eof
const parse_flag_asm_file = 0x0008 // we processing an asm file: '#' can be used for line comment, etc.
const parse_flag_spaces = 0x0010 // next() returns space tokens (for -E)
const parse_flag_accept_strays = 0x0020 // next() returns '\\' token
const parse_flag_tok_str = 0x0040 // return parsed strings instead of TOK_PPSTR

fn C.qsort(voidptr, usize, usize, fn (voidptr, voidptr) int)

__global prec = [256]u8{}

__global global_stack = &Sym(0)
__global local_stack = &Sym(0)
__global define_stack = &Sym(0)
__global global_label_stack = &Sym(0)
__global local_label_stack = &Sym(0)

__global sym_free_first = &Sym(0)
__global sym_pools = &voidptr(0)
__global nb_sym_pools = int(0)

__global all_cleanups = &Sym(0)
__global pending_gotos = &Sym(0)
__global local_scope = int(0)

__global _vstack = [1 + VSTACK_SIZE]SValue{}
__global initstr = CString{}

__global cur_switch = &Switch_t(0)

const MAX_TEMP_LOCAL_VARIABLE_NUMBER = 8

__global arr_temp_local_vars = [MAX_TEMP_LOCAL_VARIABLE_NUMBER]Temp_local_variable{}

__global nb_temp_local_vars = int(0)

struct Case_t {
	v1  i64
	v2  i64
	sym int
}

struct Switch_t {
	p             &&Case_t
	n             int
	def_sym       int
	nocode_wanted int
	bsym          &int
	scope         &Scope
	prev          &Switch_t
	sv            SValue
}

struct Temp_local_variable {
	location int
	size     i16
	align    i16
}

struct Scope {
	prev &Scope
	vla  struct {
		loc     int
		locorig int
		num     int
	}

	cl struct {
		s &Sym
		n int
	}

	bsym  &int
	csym  &int
	lstk  &Sym
	llstk &Sym
}

__global cur_scope = &Scope(0)
__global loop_scope = &Scope(0)
__global root_scope = &Scope(0)

struct Init_params {
	sec            &Section
	local_offset   int
	flex_array_ref &Sym
}

const code_off_bit = 0x20000000 // no code output after unconditional jumps such as with if (0) ...
const data_only_wanted = u64(0x80000000) // ON outside of functions and for static initializers
const CONST_WANTED_BIT = 0x00010000
const CONST_WANTED_MASK = 0x0FFF0000
const NOEVAL_MASK = 0x0000FFFF

fn gsym(t int) { // ok
	if t {
		vcc_trace_print('${@LOCATION} ${ind}')
		gsym_addr(t, ind)
		nocode_wanted &= ~code_off_bit
	}
}

fn gind() int { // ok
	t := ind
	nocode_wanted &= ~code_off_bit
	if debug_modes {
		tcc_tcov_block_begin(tcc_state)
	}
	return t
}

fn gjmp_addr_acs(t int) { // ok
	gjmp_addr(t)
	if !nocode_wanted {
		nocode_wanted |= code_off_bit
	}
}

fn gjmp_acs(t int) int { // ok
	t = gjmp(t)
	if !nocode_wanted {
		nocode_wanted |= code_off_bit
	}
	return t
}

fn is_float(t int) bool {
	bt := t & vt_btype
	return bt == vt_ldouble || bt == vt_double || bt == vt_float || bt == vt_qfloat
}

fn is_integer_btype(bt int) bool {
	return bt == 1 || bt == 11 || bt == 2 || bt == 3 || bt == 4
}

fn btype_size(bt int) int {
	return if bt == vt_byte || bt == vt_bool {
		1
	} else {
		if bt == vt_short {
			2
		} else {
			if bt == vt_int {
				4
			} else {
				if bt == vt_llong {
					8
				} else {
					if bt == vt_ptr {
						ptr_size
					} else {
						0
					}
				}
			}
		}
	}
}

fn r_ret(t int) int {
	if !is_float(t) {
		return treg_rax
	}
	if (t & 15) == 10 {
		return treg_st0
	}
	return treg_xmm0
}

fn r2_ret(t int) int {
	t &= vt_btype
	if t == vt_qlong {
		return treg_rdx
	}
	if t == vt_qfloat {
		return treg_xmm1
	}
	return vt_const
}

fn put_r_ret(sv &SValue, t int) { // ok
	sv.r = r_ret(t)
	sv.r2 = r2_ret(t)
}

fn rc_ret(t int) int { // ok
	return reg_classes[r_ret(t)] & ~(rc_float | rc_int)
}

fn rc_type(t int) int {
	if !is_float(t) {
		return rc_int
	}
	if (t & vt_btype) == vt_ldouble {
		return rc_st0
	}
	if (t & vt_btype) == vt_qfloat {
		return rc_fret
	}
	return rc_float
}

fn rc2_type(t int, rc int) int {
	if !(r2_ret(t) != 48) {
		return 0
	}
	if rc == 4 {
		return 8
	}
	if rc == 4096 {
		return 8192
	}
	if rc & rc_float {
		return rc_float
	}
	return rc_int
}

fn ieee_finite(d f64) int {
	p := [4]int{}
	unsafe { C.memcpy(p, &d, sizeof(f64)) }
	return (u32(((p[1] | 0x800fffff) + 1))) >> 31
}

fn test_lvalue() {
	if !(vtop.r & vt_lval) {
		expect(c'lvalue')
	}
}

fn check_vstack() {
	unsafe {
		if voidptr(vtop) != voidptr(&_vstack[0] + 1 - 1) {
			_tcc_error('internal compiler error: vstack leak (${int((vtop - (_vstack + 1) + 1))})')
		}
	}
}

fn tccgen_init(s1 &TCCState) {
	vtop = unsafe { (&_vstack[0] + 1) - 1 }
	unsafe { C.memset(vtop, 0, sizeof(*vtop)) }

	int_type.t = vt_int
	char_type.t = vt_byte

	if s1.char_is_unsigned {
		char_type.t |= vt_unsigned
	}
	char_pointer_type = char_type
	mk_pointer(&char_pointer_type)

	func_old_type.t = vt_func
	func_old_type.ref = sym_push(sym_field, &int_type, 0, 0)
	func_old_type.ref.f.func_call = func_cdecl
	func_old_type.ref.f.func_type = func_old
	init_prec()
	cstr_new(&initstr)
}

fn tccgen_compile(s1 &TCCState) int {
	vcc_trace('${@LOCATION}')
	tcc_state.cur_text_section = unsafe { nil }
	funcname = c''
	func_ind = -1
	anon_sym = sym_first_anom
	nocode_wanted = data_only_wanted
	local_scope = 0
	debug_modes = char((if s1.do_debug { 1 } else { 0 }) | (s1.test_coverage << 1))
	vcc_trace_print('${@LOCATION} debug_modes=${int(debug_modes)}')

	tcc_debug_start(s1)
	vcc_trace('${@LOCATION}')
	tcc_tcov_start(s1)
	vcc_trace('${@LOCATION}')
	parse_flags = parse_flag_preprocess | parse_flag_tok_num | parse_flag_tok_str
	unsafe { vcc_trace('${@LOCATION} - ${file.truefilename.vstring()}') }
	next()
	vcc_trace('${@LOCATION}')
	// vcc_disable_trace()
	vcc_trace_print('${@LOCATION} tccgen_compile before decl(42)')
	decl(vt_const)
	vcc_trace_print('${@LOCATION} tccgen_compile after decl(42)')
	// vcc_enable_trace()
	vcc_trace('${@LOCATION}')
	gen_inline_functions(s1)
	check_vstack()
	vcc_trace('${@LOCATION}')
	// end of translation unit info
	tcc_debug_end(s1)
	tcc_tcov_end(s1)
	vcc_trace('${@LOCATION}')
	return 0
}

fn tccgen_finish(s1 &TCCState) {
	vcc_trace_print('${@LOCATION}')
	tcc_debug_end(s1)
	vcc_trace('${@LOCATION}')
	free_inline_functions(s1)
	vcc_trace('${@LOCATION}')
	sym_pop(&global_stack, unsafe { nil }, 0)
	sym_pop(&local_stack, unsafe { nil }, 0)
	vcc_trace('${@LOCATION}')
	free_defines(unsafe { nil })
	vcc_trace_print('${@LOCATION}')
	dynarray_reset(&sym_pools, &nb_sym_pools)
	vcc_trace_print('${@LOCATION}')
	sym_free_first = unsafe { nil }
	global_label_stack = unsafe { nil }
	local_label_stack = global_label_stack
	cstr_free(&initstr)
	dynarray_reset(&stk_data, &nb_stk_data)
	vcc_trace_print('${@LOCATION}')
}

pub fn elfsym(s &Sym) &Elf64_Sym {
	if s == unsafe { nil } || !s.c {
		return unsafe { nil }
	}
	return &(&Elf64_Sym(tcc_state.symtab_section.data))[s.c]
}

fn update_storage(sym &Sym) {
	esym := &Elf64_Sym(0)
	sym_bind := 0
	old_sym_bind := 0

	esym = elfsym(sym)
	if !esym {
		return
	}
	if sym.a.visibility {
		esym.st_other = (esym.st_other & ~((-1) & 3)) | sym.a.visibility
	}
	if sym.type_.t & (vt_static | vt_inline) {
		sym_bind = stb_local
	} else if sym.a.weak {
		sym_bind = stb_weak
	} else {
		sym_bind = stb_global
	}
	old_sym_bind = ((u8((esym.st_info))) >> 4)
	if sym_bind != old_sym_bind {
		esym.st_info = ((sym_bind << 4) + (((esym.st_info) & 15) & 15))
	}
}

fn put_extern_sym2(sym &Sym, sh_num int, value Elf64_Addr, size u32, can_add_underscore int) {
	sym_type := 0
	sym_bind := 0
	info := 0
	other := 0
	t := 0

	esym := &Elf64_Sym(0)
	name := &char(0)
	buf1 := [256]char{}

	vcc_trace_print('${@LOCATION}')

	if !sym.c {
		name = get_tok_str(sym.v, unsafe { nil })
		t = sym.type_.t
		if (t & vt_btype) == vt_func {
			sym_type = stt_func
		} else if (t & vt_btype) == vt_void {
			sym_type = stt_notype
			if (t & (15 | ((0 | (1 << 20)) | (2 << 20)))) == ((0 | (1 << 20)) | (2 << 20)) {
				sym_type = stt_func
			}
		} else {
			sym_type = stt_object
		}
		if t & (vt_static | vt_inline) {
			sym_bind = stb_local
		} else { // 3
			sym_bind = stb_global
		}
		other = 0
		if sym.asm_label {
			name = get_tok_str(sym.asm_label, unsafe { nil })
			can_add_underscore = 0
		}
		if tcc_state.leading_underscore && can_add_underscore {
			buf1[0] = `_`
			unsafe { pstrcpy(&buf1[0] + 1, sizeof(buf1) - 1, name) }
			name = buf1
		}
		info = ((sym_bind << 4) + (sym_type & 15))
		vcc_trace_print('${@LOCATION} elf_sym')
		sym.c = put_elf_sym(tcc_state.symtab_section, value, size, info, other, sh_num,
			name)
		// vcc_trace('${@LOCATION} ${name.vstring()}')
		vcc_trace_print('${@LOCATION} debug ${int(debug_modes)}')
		if debug_modes {
			vcc_trace_print('${@LOCATION} debug.1')
			tcc_debug_extern_sym(tcc_state, sym, sh_num, sym_bind, sym_type)
		}
	} else {
		esym = elfsym(sym)
		esym.st_value = value
		esym.st_size = size
		esym.st_shndx = sh_num
	}
	vcc_trace_print('${@LOCATION} updatestorage')
	update_storage(sym)
	vcc_trace_print('${@LOCATION} end')
}

fn put_extern_sym(sym &Sym, s &Section, value Elf64_Addr, size u32) {
	vcc_trace_print('${@LOCATION} extern_sym.0=${size}')
	if nocode_wanted
		&& (nocode_wanted > 0 || (s && voidptr(s) == voidptr(tcc_state.cur_text_section))) {
		vcc_trace_print('${@LOCATION} ret')
		return
	}
	put_extern_sym2(sym, if s { s.sh_num } else { shn_undef }, value, size, 1)
	vcc_trace_print('${@LOCATION} extern_sym=${size}')
}

fn greloca(s &Section, sym &Sym, offset u64, type_ int, addend Elf64_Addr) {
	c := 0
	vcc_trace_print('${@LOCATION} 1')
	if nocode_wanted && voidptr(s) == voidptr(tcc_state.cur_text_section) {
		return
	}
	if sym != unsafe { nil } {
		vcc_trace_print('${@LOCATION} 2')
		if 0 == sym.c {
			vcc_trace_print('${@LOCATION} 3')
			put_extern_sym(sym, unsafe { nil }, 0, 0)
		}
		c = sym.c
	}
	put_elf_reloca(tcc_state.symtab_section, s, offset, type_, c, addend)
}

fn __sym_malloc() &Sym {
	sym_pool := &Sym(0)
	sym := &Sym(0)
	last_sym := &Sym(0)
	i := 0

	sym_pool = tcc_malloc(SYM_POOL_NB * sizeof(Sym))
	dynarray_add(&sym_pools, &nb_sym_pools, sym_pool)

	last_sym = sym_free_first
	sym = sym_pool
	for i = 0; i < SYM_POOL_NB; i++ {
		sym.next = last_sym
		last_sym = sym
		unsafe { sym++ }
	}
	sym_free_first = last_sym
	return last_sym
}

fn sym_malloc() &Sym {
	sym := &Sym(0)
	sym = sym_free_first
	if !sym {
		sym = __sym_malloc()
	}
	sym_free_first = sym.next
	return sym
}

fn sym_free(sym &Sym) {
	sym.next = sym_free_first
	sym_free_first = sym
}

// push, without hashing
fn sym_push2(ps &&Sym, v int, t int, c int) &Sym {
	s := &Sym(sym_malloc())

	unsafe { C.memset(s, 0, sizeof(Sym)) }
	s.v = v
	s.type_.t = t
	s.c = c
	// add in stack
	s.prev = *ps
	*ps = s
	return s
}

// find a symbol and return its associated structure. 's' is the top
//   of the symbol stack
fn sym_find2(s &Sym, v int) &Sym {
	for s {
		if s.v == v {
			return s
		} else if s.v == -1 {
			return unsafe { nil }
		}
		s = s.prev
	}
	return unsafe { nil }
}

fn struct_find(v int) &Sym {
	v -= TOK_IDENT
	if u32(v) >= u32((tok_ident - TOK_IDENT)) {
		return unsafe { nil }
	}
	return table_ident[v].sym_struct
}

fn sym_find(v int) &Sym {
	v -= TOK_IDENT
	if u32(v) >= u32((tok_ident - TOK_IDENT)) {
		return unsafe { nil }
	}
	vcc_trace_print('${@LOCATION} sym found ${v}')
	return table_ident[v].sym_identifier
}

fn sym_scope(s &Sym) int {
	if ((s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20)) {
		return s.type_.ref.sym_scope
	} else {
		return s.sym_scope
	}
}

// push a given symbol on the symbol stack
fn sym_push(v int, type_ &CType, r int, c int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)
	ts := &TokenSym(0)

	if local_stack {
		ps = &local_stack
		vcc_trace_print('${@LOCATION} localstack')
	} else { // 3
		ps = &global_stack
		vcc_trace_print('${@LOCATION} globalstack')
	}
	s = sym_push2(ps, v, type_.t, c)
	s.type_.ref = type_.ref
	s.r = r
	vcc_trace_print('${@LOCATION} r=${r} c=${c} v=${v}')
	if !(v & sym_field) && (v & ~sym_struct) < sym_first_anom {
		ts = table_ident[(v & ~sym_struct) - TOK_IDENT]
		if v & sym_struct {
			ps = &ts.sym_struct
		} else { // 3
			ps = &ts.sym_identifier
			vcc_trace_print('${@LOCATION} ${(v & ~sym_struct) - TOK_IDENT} ${*ps == unsafe { nil }}')
		}
		s.prev_tok = *ps
		*ps = s
		s.sym_scope = local_scope
		vcc_trace_print('${@LOCATION} ${v & sym_struct} sym=${(v & ~sym_struct) - TOK_IDENT} local_scope=${local_scope} nocode=${nocode_wanted}')
		if s.prev_tok != unsafe { nil } {
			vcc_trace_print('${@LOCATION} has prev_tok')
		}
		if s.prev_tok != unsafe { nil } && sym_scope(s.prev_tok) == s.sym_scope {
			unsafe { _tcc_error("redeclaration of '${get_tok_str(v & ~sym_struct, nil).vstring()}'") }
		} else {
			unsafe { vcc_trace_print('${@LOCATION} ok ${get_tok_str(v & ~sym_struct, nil).vstring()}') }
		}
	}
	return s
}

// push a global identifier
fn global_identifier_push(v int, t int, c int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)

	vcc_trace_print('${@LOCATION} v=${v} t=${t} c=${c}')

	s = sym_push2(&global_stack, v, t, c)
	s.r = vt_const | vt_sym
	if v < sym_first_anom {
		ps = &table_ident[v - TOK_IDENT].sym_identifier
		if *ps {
			vcc_trace_print('${@LOCATION} has sym_identifier')
		}
		for *ps != unsafe { nil } && (*ps).sym_scope {
			ps = &(*ps).prev_tok
			vcc_trace_print('${@LOCATION}')
		}
		if *ps == unsafe { nil } {
			vcc_trace_print('${@LOCATION} *ps == null')
		}
		s.prev_tok = *ps
		*ps = s
		vcc_trace_print('${@LOCATION} globalpush')
	}
	return s
}

// pop symbols until top reaches 'b'.  If KEEP is non-zero don't really
// pop them yet from the list, but do remove them from the token array.
fn sym_pop(ptop &&Sym, b &Sym, keep int) {
	vcc_trace('${@LOCATION}')
	s := &Sym(0)
	ss := &Sym(0)
	ps := &&Sym(0)

	ts := &TokenSym(0)
	v := 0
	s = *ptop
	for voidptr(s) != voidptr(b) {
		ss = s.prev
		v = s.v
		// remove symbol in token array
		if !(v & sym_field) && (v & ~sym_struct) < sym_first_anom {
			ts = table_ident[(v & ~sym_struct) - TOK_IDENT]
			if v & sym_struct {
				ps = &ts.sym_struct
			} else { // 3
				ps = &ts.sym_identifier
			}
			*ps = s.prev_tok
			vcc_trace_print('${@LOCATION} pop')
		}
		if !keep {
			vcc_trace_print('${@LOCATION} sym_free')
			sym_free(s)
		}
		s = ss
	}
	if !keep {
		*ptop = b
	}
	vcc_trace('${@LOCATION}')
}

// label lookup
fn label_find(v int) &Sym {
	v -= TOK_IDENT
	if u32(v) >= u32((tok_ident - TOK_IDENT)) {
		return unsafe { nil }
	}
	return table_ident[v].sym_label
}

fn label_push(ptop &&Sym, v int, flags int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)

	s = sym_push2(ptop, v, vt_static, 0)
	s.r = flags
	ps = &table_ident[v - TOK_IDENT].sym_label
	if voidptr(ptop) == voidptr(&global_label_stack) {
		// modify the top most local identifier, so that
		//   sym_identifier will point to 's' when popped
		for *ps != unsafe { nil } {
			ps = &(*ps).prev_tok
		}
	}
	s.prev_tok = *ps
	*ps = s
	return s
}

// pop labels until element last is reached. Look if any labels are
//   undefined. Define symbols if '&&label' was used.
fn label_pop(ptop &&Sym, slast &Sym, keep int) {
	s := &Sym(0)
	s1 := &Sym(0)

	for s = *ptop; voidptr(s) != voidptr(slast); s = s1 {
		s1 = s.prev
		if s.r == label_declared {
			tcc_state.warn_num = __offsetof(TCCState, warn_all) - __offsetof(TCCState, warn_none)
			_tcc_warning("label '${get_tok_str(s.v, (unsafe { nil }))}' declared but not used")
		} else if s.r == label_forward {
			_tcc_error("label '${get_tok_str(s.v, (unsafe { nil }))}' used but not defined")
		} else {
			if s.c {
				put_extern_sym(s, tcc_state.cur_text_section, s.jnext, 1)
			}
		}
		if s.r != label_gone {
			table_ident[s.v - TOK_IDENT].sym_label = s.prev_tok
		}
		if !keep {
			sym_free(s)
		} else {
			s.r = label_gone
		}
	}
	if !keep {
		*ptop = slast
	}
}

fn vcheck_cmp() {
	if vtop.r == vt_cmp && 0 == (nocode_wanted & ~code_off_bit) {
		gv(rc_int)
		vcc_trace_print('${@LOCATION} 1 - ${nocode_wanted}')
	} else {
		vcc_trace_print('${@LOCATION} 0 - ${nocode_wanted}')
	}
}

fn vsetc(type_ &CType, r int, vc &CValue) {
	unsafe {
		if voidptr(vtop) >= voidptr(&_vstack[0] + 1 + (VSTACK_SIZE - 1)) {
			_tcc_error('memory full (vstack)')
		}
	}
	vcheck_cmp()
	unsafe { vtop++ }
	vtop.type_ = *type_
	vtop.r = r
	vtop.r2 = vt_const
	vtop.c = *vc
	vtop.sym = unsafe { nil }
}

fn vswap() {
	tmp := SValue{}
	vcheck_cmp()
	tmp = vtop[0]
	vtop[0] = vtop[-1]
	vtop[-1] = tmp
	vcc_trace_print('${@LOCATION}')
}

// pop stack value
fn vpop() {
	v := 0
	v = vtop.r & vt_valmask
	// for x86, we need to pop the FP stack
	if v == treg_st0 {
		o(0xd8dd) // fstp %st(0)
	} else if v == vt_cmp {
		// need to put correct jump if && or || without test
		gsym(vtop.jtrue)
		gsym(vtop.jfalse)
	}
	unsafe { vtop-- }
}

// push constant of type "type" with useless value
fn vpush(type_ &CType) {
	vset(type_, vt_const, 0)
	vcc_trace_print('${@LOCATION}')
}

// push arbitrary 64bit constant
fn vpush64(ty int, v i64) {
	cval := CValue{}
	ctype := CType{}
	ctype.t = ty
	ctype.ref = unsafe { nil }
	cval.i = v
	vsetc(&ctype, vt_const, &cval)
	vcc_trace_print('${@LOCATION}')
}

// push integer constant
fn vpushi(v int) {
	vpush64(vt_int, v)
	vcc_trace_print('${@LOCATION}')
}

// push a pointer sized constant
fn vpushs(v Elf64_Addr) {
	vpush64(vt_size_t, v)
	vcc_trace_print('${@LOCATION}')
}

// push long long constant
fn vpushll(v i64) {
	vpush64(vt_llong, v)
	vcc_trace_print('${@LOCATION}')
}

fn vset(type_ &CType, r int, v int) {
	cval := CValue{}
	cval.i = v
	vsetc(type_, r, &cval)
}

fn vseti(r int, v int) {
	type_ := CType{}
	type_.t = vt_int
	type_.ref = unsafe { nil }
	vset(&type_, r, v)
	vcc_trace_print('${@LOCATION}')
}

fn vpushv(v &SValue) {
	unsafe {
		if voidptr(vtop) >= voidptr(&_vstack[0] + 1 + (VSTACK_SIZE - 1)) {
			_tcc_error('memory full (vstack)')
		}
		vtop++
		*vtop = *v
		vcc_trace_print('${@LOCATION}')
	}
}

fn vdup() {
	vcc_trace_print('${@LOCATION}')
	vpushv(vtop)
}

// rotate n first stack elements to the bottom
//   I1 ... In -> I2 ... In I1 [top is right]
fn vrotb(n int) {
	i := 0
	tmp := SValue{}
	vcc_trace_print('${@LOCATION}')
	vcheck_cmp()
	tmp = vtop[-n + 1]
	for i = -n + 1; i != 0; i++ {
		vtop[i] = vtop[i + 1]
	}
	vtop[0] = tmp
}

// rotate the n elements before entry e towards the top
//   I1 ... In ... -> In I1 ... I(n-1) ... [top is right]
fn vrote(e &SValue, n int) {
	i := 0
	tmp := SValue{}

	vcc_trace_print('${@LOCATION}')

	vcheck_cmp()
	tmp = *e
	for i = 0; i < n - 1; i++ {
		e[-i] = e[-i - 1]
	}
	e[-n + 1] = tmp
}

// rotate n first stack elements to the top
//  I1 ... In -> In I1 ... I(n-1)  [top is right]
fn vrott(n int) {
	vcc_trace_print('${@LOCATION}')
	vrote(vtop, n)
}

// vtop->r = VT_CMP means CPU-flags have been set from comparison or test.

// called from generators to set the result from relational ops
fn vset_vt_cmp(op int) {
	vtop.r = vt_cmp
	vtop.cmp_op = op
	vtop.jfalse = 0
	vtop.jtrue = 0
}

// called once before asking generators to load VT_CMP to a register
fn vset_vt_jmp() {
	op := vtop.cmp_op
	if vtop.jtrue || vtop.jfalse {
		vcc_trace_print('${@LOCATION} 1')
		origt := vtop.type_.t
		inv := op & (op < 2)
		vseti(52 + inv, gvtst(inv, 0))
		vtop.type_.t |= origt & (vt_unsigned | vt_defsign)
	} else {
		vcc_trace_print('${@LOCATION} vtop.c.i=${op}')
		vtop.c.i = op
		if op < 2 {
			vtop.r = vt_const
		}
	}
}

// Set CPU Flags, doesn't yet jump
fn gvtst_set(inv int, t int) {
	p := &int(0)

	if vtop.r != vt_cmp {
		vpushi(0)
		gen_op(149)
		if vtop.r != vt_cmp { // must be VT_CONST then
			unsafe { vset_vt_cmp(vtop.c.i != 0) }
		}
	}
	p = if inv { &vtop.jfalse } else { &vtop.jtrue }
	*p = gjmp_append(*p, t)
}

// Generate value test
//
// Generate a test for any value (jump, comparison and integers)
fn gvtst(inv int, t int) int {
	op := 0
	x := 0
	u := 0

	gvtst_set(inv, t)
	t = vtop.jtrue
	u = vtop.jfalse

	if inv {
		x = u
		u = t
		t = x
	}
	op = vtop.cmp_op

	// jump to the wanted target
	if op > 1 {
		t = gjmp_cond(op ^ inv, t)
	} else if op != inv {
		t = gjmp_acs(t)
	}
	// resolve complementary jumps to here
	gsym(u)

	unsafe { vtop-- }
	return t
}

// generate a zero or nozero test
fn gen_test_zero(op int) {
	if vtop.r == vt_cmp {
		j := 0
		if op == 148 {
			j = vtop.jfalse
			vtop.jfalse = vtop.jtrue
			vtop.jtrue = j
			vtop.cmp_op ^= 1
		}
	} else {
		vpushi(0)
		gen_op(op)
	}
}

// push a symbol value of TYPE
fn vpushsym(type_ &CType, sym &Sym) {
	cval := CValue{}
	cval.i = 0
	vsetc(type_, vt_const | vt_sym, &cval)
	vtop.sym = sym
}

// Return a static symbol pointing to a section
fn get_sym_ref(type_ &CType, sec &Section, offset u32, size u32) &Sym {
	v := 0
	sym := &Sym(0)

	v = anon_sym++
	sym = sym_push(v, type_, vt_const | vt_sym, 0)
	sym.type_.t |= vt_static
	put_extern_sym(sym, sec, offset, size)
	return sym
}

// push a reference to a section offset by adding a dummy symbol
fn vpush_ref(type_ &CType, sec &Section, offset u32, size u32) {
	vpushsym(type_, get_sym_ref(type_, sec, offset, size))
}

// define a new external reference to a symbol 'v' of type 'u'
fn external_global_sym(v int, type_ &CType) &Sym {
	s := &Sym(0)

	s = sym_find(v)
	if !s {
		// push forward reference
		s = global_identifier_push(v, type_.t | vt_extern, 0)
		s.type_.ref = type_.ref
	} else if ((s.type_.t & (15 | (0 | (1 << 20)))) == (0 | (1 << 20))) {
		s.type_.t = type_.t | (s.type_.t & vt_extern)
		s.type_.ref = type_.ref
		update_storage(s)
	}
	return s
}

// create an external reference with no specific type similar to asm labels.
//   This avoids type conflicts if the symbol is used from C too
fn external_helper_sym(v int) &Sym {
	ct := CType{
		t: ((0 | (1 << 20)) | (2 << 20))
		ref: unsafe { nil }
	}

	return external_global_sym(v, &ct)
}

// push a reference to an helper function (such as memmove)
fn vpush_helper_func(v int) {
	vpushsym(&func_old_type, external_helper_sym(v))
}

// Merge symbol attributes.
fn merge_symattr(sa &SymAttr, sa1 &SymAttr) {
	if sa1.aligned && !sa.aligned {
		sa.aligned = sa1.aligned
	}
	sa.packed |= sa1.packed
	sa.weak |= sa1.weak
	sa.nodebug |= sa1.nodebug
	if sa1.visibility != 0 {
		vis := sa.visibility
		if vis == 0 || vis > sa1.visibility {
			vis = sa1.visibility
		}
		sa.visibility = vis
	}
	sa.dllexport |= sa1.dllexport
	sa.nodecorate |= sa1.nodecorate
	sa.dllimport |= sa1.dllimport
}

// Merge function attributes.
fn merge_funcattr(fa &FuncAttr, fa1 &FuncAttr) {
	if fa1.func_call && !fa.func_call {
		fa.func_call = fa1.func_call
	}
	if fa1.func_type && !fa.func_type {
		fa.func_type = fa1.func_type
	}
	if fa1.func_args && !fa.func_args {
		fa.func_args = fa1.func_args
	}
	if fa1.func_noreturn {
		fa.func_noreturn = 1
	}
	if fa1.func_ctor {
		fa.func_ctor = 1
	}
	if fa1.func_dtor {
		fa.func_dtor = 1
	}
}

// Merge attributes.
fn merge_attr(ad &AttributeDef, ad1 &AttributeDef) {
	merge_symattr(&ad.a, &ad1.a)
	merge_funcattr(&ad.f, &ad1.f)
	if ad1.section {
		ad.section = ad1.section
	}
	if ad1.alias_target {
		ad.alias_target = ad1.alias_target
	}
	if ad1.asm_label {
		ad.asm_label = ad1.asm_label
	}
	if ad1.attr_mode {
		ad.attr_mode = ad1.attr_mode
	}
}

// Merge some type attributes.
fn patch_type(sym &Sym, type_ &CType) {
	if !(type_.t & vt_extern) || (sym.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20) {
		if !(sym.type_.t & vt_extern) {
			_tcc_error("redefinition of '${get_tok_str(sym.v, (unsafe { nil }))}'")
		}
		sym.type_.t &= ~vt_extern
	}
	if ((sym.type_.t & (15 | (0 | (1 << 20)))) == (0 | (1 << 20))) {
		// stay static if both are static
		sym.type_.t = type_.t & (sym.type_.t | ~vt_static)
		sym.type_.ref = type_.ref
	}
	if !is_compatible_types(&sym.type_, type_) {
		_tcc_error("incompatible types for redefinition of '${get_tok_str(sym.v, (unsafe { nil }))}'")
	} else if (sym.type_.t & vt_btype) == vt_func {
		static_proto := sym.type_.t & vt_static
		// warn if static follows non-static function declaration
		if type_.t & vt_static && !static_proto && !((type_.t | sym.type_.t) & 32768) {
			_tcc_warning("static storage ignored for redefinition of '${get_tok_str(sym.v,
				(unsafe { nil }))}'")
		}
		// set 'inline' if both agree or if one has static
		if (type_.t | sym.type_.t) & vt_inline {
			if !((type_.t ^ sym.type_.t) & vt_inline) || (type_.t | sym.type_.t) & vt_static {
				static_proto |= vt_inline
			}
		}
		if 0 == (type_.t & vt_extern) {
			f := sym.type_.ref.f
			sym.type_.t = (type_.t & ~(vt_static | vt_inline)) | static_proto
			sym.type_.ref = type_.ref
			merge_funcattr(&sym.type_.ref.f, &f)
		} else {
			sym.type_.t &= ~vt_inline | static_proto
		}
		if sym.type_.ref.f.func_type == func_old && type_.ref.f.func_type != func_old {
			sym.type_.ref = type_.ref
		}
	} else {
		if sym.type_.t & vt_array && type_.ref.c >= 0 {
			sym.type_.ref.c = type_.ref.c
		}
		if (type_.t ^ sym.type_.t) & vt_static {
			_tcc_warning("storage mismatch for redefinition of '${get_tok_str(sym.v, (unsafe { nil }))}'")
		}
	}
}

// Merge some storage attributes.
fn patch_storage(sym &Sym, ad &AttributeDef, type_ &CType) {
	if type_ {
		patch_type(sym, type_)
	}
	merge_symattr(&sym.a, &ad.a)
	if ad.asm_label {
		sym.asm_label = ad.asm_label
	}
	update_storage(sym)
}

// copy sym to other stack
fn sym_copy(s0 &Sym, ps &&Sym) &Sym {
	s := &Sym(sym_malloc())
	*s = *s0
	s.prev = *ps
	*ps = s

	if s.v < sym_first_anom {
		ps = &table_ident[s.v - TOK_IDENT].sym_identifier
		s.prev_tok = *ps
		*ps = s
		vcc_trace_print('${@LOCATION} copy')
	}
	return s
}

// copy s->type.ref to stack 'ps' for VT_FUNC and VT_PTR
fn sym_copy_ref(s &Sym, ps &&Sym) {
	bt := s.type_.t & vt_btype
	vcc_trace_print('${@LOCATION} copy_ref ${bt}')
	if bt == vt_func || bt == vt_ptr || (bt == vt_struct && s.sym_scope) {
		sp := &s.type_.ref
		s = *sp
		*sp = unsafe { nil }
		for ; s; s = s.next {
			s2 := sym_copy(s, ps)
			*sp = s2
			sp = &s2.next
			sym_copy_ref(s2, ps)
			vcc_trace_print('${@LOCATION} sym_copy')
		}
	}
}

// define a new external reference to a symbol 'v'
fn external_sym(v int, type_ &CType, r int, ad &AttributeDef) &Sym {
	vcc_trace('${@LOCATION}')
	s := &Sym(0)

	// look for global symbol
	s = sym_find(v)
	vcc_trace('${@LOCATION}')

	for s != unsafe { nil } && s.sym_scope {
		s = s.prev_tok
	}

	if !s {
		vcc_trace_print('${@LOCATION} external.0')
		// push forward reference
		s = global_identifier_push(v, type_.t, 0)
		s.r |= r
		s.a = ad.a
		s.asm_label = ad.asm_label
		s.type_.ref = type_.ref
		if local_stack {
			vcc_trace('${@LOCATION}')
			sym_copy_ref(s, &global_stack)
		}
	} else {
		vcc_trace_print('${@LOCATION} external.1')
		patch_storage(s, ad, type_)
	}
	// push variables on local_stack if any
	if local_stack && (s.type_.t & vt_btype) != vt_func {
		vcc_trace_print('${@LOCATION} external.2')
		vcc_trace('${@LOCATION}')
		s = sym_copy(s, &local_stack)
	}
	vcc_trace_print('${@LOCATION} external.end')
	return s
}

// save registers up to (vtop - n) stack entry
fn save_regs(n int) {
	p := &SValue(0)
	p1 := &SValue(0)

	p = unsafe { &_vstack[0] + 1 }
	vcc_trace_print('${@LOCATION} n=${n} .1')
	unsafe {
		for p1 = vtop - n; voidptr(p) <= voidptr(p1); p++ {
			vcc_trace_print('${@LOCATION} .2')
			save_reg(p.r)
			vcc_trace_print('${@LOCATION} .3')
		}
	}
}

// save r to the memory stack, and mark it as being free
fn save_reg(r int) {
	save_reg_upstack(r, 0)
}

// save r to the memory stack, and mark it as being free,
//   if seen up to (vtop - n) stack entry
fn save_reg_upstack(r int, n int) {
	l := 0
	size := 0
	align := 0
	bt := 0

	p := &SValue(0)
	p1 := &SValue(0)
	sv := SValue{}

	r &= vt_valmask
	if r >= vt_const {
		return
	}
	if nocode_wanted {
		return
	}
	l = 0
	p = unsafe { &_vstack[0] + 1 }
	unsafe {
		for p1 = vtop - n; voidptr(p) <= voidptr(p1); p++ {
			if (p.r & vt_valmask) == r || p.r2 == r {
				if !l {
					bt = p.type_.t & vt_btype
					if bt == vt_void {
						continue
					}
					if p.r & vt_lval || bt == vt_func {
						bt = vt_ptr
					}
					sv.type_.t = bt
					size = type_size(&sv.type_, &align)
					l = get_temp_local_var(size, align)
					sv.r = vt_local | vt_lval
					vcc_trace_print('${@LOCATION} sv.c.i=${l}')
					sv.c.i = l
					store(p.r & vt_valmask, &sv)
					if r == treg_st0 {
						o(55517)
					}
					if p.r2 < vt_const && r2_ret(bt) != 48 {
						sv.c.i += ptr_size
						store(p.r2, &sv)
					}
				}
				if p.r & vt_lval {
					p.r = (p.r & ~(vt_valmask | vt_bounded)) | vt_llocal
				} else {
					p.r = vt_lval | vt_local
				}
				p.sym = nil
				p.r2 = vt_const
				p.c.i = l
				vcc_trace_print('${@LOCATION} p.c.i=${l}')
			}
		}
	}
}

fn get_reg(rc int) int {
	r := 0
	p := &SValue(0)

	for r = 0; r < nb_regs; r++ {
		if reg_classes[r] & rc {
			if nocode_wanted {
				return r
			}
			unsafe {
				for p = &_vstack[0] + 1; voidptr(p) <= voidptr(vtop); p++ {
					if (p.r & vt_valmask) == r || p.r2 == r {
						goto notfound
					}
				}
			}
			return r
		}
		notfound:
	}
	unsafe {
		for p = &_vstack[0] + 1; voidptr(p) <= voidptr(vtop); p++ {
			r = p.r2
			if r < vt_const && reg_classes[r] & rc {
				goto save_found
			}
			r = p.r & vt_valmask
			if r < vt_const && reg_classes[r] & rc {
				save_found:
				save_reg(r)
				return r
			}
		}
	}
	// Should never comes here
	return -1
}

// find a free temporary local variable (return the offset on stack) match the size and align. If none, add new temporary stack variable
fn get_temp_local_var(size int, align int) int {
	i := 0
	temp_var := &Temp_local_variable(0)
	found_var := 0
	p := &SValue(0)
	r := 0
	free := char(0)
	found := char(0)
	found = 0
	for i = 0; i < nb_temp_local_vars; i++ {
		temp_var = &arr_temp_local_vars[i]
		if temp_var.size < size || align != temp_var.align {
			continue
		}
		// check if temp_var is free
		free = 1
		unsafe {
			for p = &_vstack[0] + 1; voidptr(p) <= voidptr(vtop); p++ {
				r = p.r & vt_valmask
				if r == vt_local || r == vt_llocal {
					if p.c.i == u64(temp_var.location) {
						free = 0
						break
					}
				}
			}
		}
		if free {
			found_var = temp_var.location
			found = 1
			break
		}
	}
	if !found {
		loc = (loc - size) & -align
		if nb_temp_local_vars < 8 {
			temp_var = &arr_temp_local_vars[i]
			temp_var.location = loc
			temp_var.size = size
			temp_var.align = align
			nb_temp_local_vars++
		}
		found_var = loc
	}
	return found_var
}

fn clear_temp_local_var_list() {
	nb_temp_local_vars = 0
}

// move register 's' (of type 't') to 'r', and flush previous value of r to memory
//   if needed
fn move_reg(r int, s int, t int) {
	sv := SValue{}

	if r != s {
		save_reg(r)
		sv.type_.t = t
		sv.type_.ref = unsafe { nil }
		sv.r = s
		sv.c.i = 0
		load(r, &sv)
		vcc_trace_print('${@LOCATION} c.i=0')
	}
}

// get address of vtop (vtop MUST BE an lvalue)
fn gaddrof() {
	vtop.r &= ~vt_lval
	// tricky: if saved lvalue, then we can go back to lvalue
	if (vtop.r & vt_valmask) == vt_llocal {
		vtop.r = (vtop.r & ~vt_valmask) | vt_local | vt_lval
	}
}

fn gen_bounded_ptr_add() {
	save := (vtop[-1].r & vt_valmask) == vt_local
	if save {
		vpushv(&vtop[-1])
		vrott(3)
	}
	vpush_helper_func(Tcc_token.tok___bound_ptr_add)
	vrott(3)
	gfunc_call(2)
	vtop -= save
	vpushi(0)
	// returned pointer is in REG_IRET
	vtop.r = treg_rax | vt_bounded
	if nocode_wanted {
		return
	}
	// relocation offset of the bounding function call point
	vtop.c.i = (tcc_state.cur_text_section.reloc.data_offset - sizeof(Elf64_Rela))
	vcc_trace_print('${@LOCATION} vtop.c.i=${vtop.c.i}')
}

// patch pointer addition in vtop so that pointer dereferencing is
//   also tested
fn gen_bounded_ptr_deref() {
	func := Elf64_Addr(0)
	size := 0
	align := 0

	rel := &Elf64_Rela(0)
	sym := &Sym(0)

	if nocode_wanted {
		return
	}

	size = type_size(&vtop.type_, &align)
	match size {
		1 {
			func = Tcc_token.tok___bound_ptr_indir1
		}
		2 {
			func = Tcc_token.tok___bound_ptr_indir2
		}
		4 {
			func = Tcc_token.tok___bound_ptr_indir4
		}
		8 {
			func = Tcc_token.tok___bound_ptr_indir8
		}
		12 {
			func = Tcc_token.tok___bound_ptr_indir12
		}
		16 {
			func = Tcc_token.tok___bound_ptr_indir16
		}
		else {
			// may happen with struct member access
			return
		}
	}
	sym = external_helper_sym(func)
	if !sym.c {
		put_extern_sym(sym, unsafe { nil }, 0, 0)
	}
	// patch relocation
	// XXX: find a better solution ?
	rel = unsafe { &Elf64_Rela((tcc_state.cur_text_section.reloc.data + vtop.c.i)) }
	rel.r_info = (((Elf64_Xword(u64(sym.c))) << 32) + ((rel.r_info) & 4294967295))
}

// generate lvalue bound code
fn gbound() {
	type1 := CType{}

	vtop.r &= ~vt_mustbound
	// if lvalue, then use checking code before dereferencing
	if vtop.r & vt_lval {
		// if not VT_BOUNDED value, then make one
		if !(vtop.r & vt_bounded) {
			// must save type because we must set it to int to get pointer
			type1 = vtop.type_
			vtop.type_.t = vt_ptr
			gaddrof()
			vpushi(0)
			gen_bounded_ptr_add()
			vtop.r |= vt_lval
			vtop.type_ = type1
		}
		// then check for dereferencing
		gen_bounded_ptr_deref()
	}
}

// we need to call __bound_ptr_add before we start to load function
//   args into registers
fn gbound_args(nb_args int) {
	i := 0
	v := 0
	sv := &SValue(0)

	for i = 1; i <= nb_args; i++ {
		if vtop[1 - i].r & vt_mustbound {
			vrotb(i)
			gbound()
			vrott(i)
		}
	}
	sv = unsafe { vtop - nb_args }
	if sv.r & vt_sym {
		v = sv.sym.v
		if v == Tcc_token.tok_setjmp || v == Tcc_token.tok__setjmp || v == Tcc_token.tok_sigsetjmp
			|| v == Tcc_token.tok___sigsetjmp {
			vpush_helper_func(Tcc_token.tok___bound_setjmp)
			vpushv(unsafe { sv + 1 })
			gfunc_call(1)
			func_bound_add_epilog = 1
		}
		if v == Tcc_token.tok_alloca {
			func_bound_add_epilog = 1
		}
	}
}

fn add_local_bounds(s &Sym, e &Sym) {
	for ; voidptr(s) != voidptr(e); s = s.prev {
		if !s.v || (s.r & vt_valmask) != vt_local {
			continue
		}
		if s.type_.t & vt_array || (s.type_.t & vt_btype) == vt_struct || s.a.addrtaken {
			align := 0
			size := type_size(&s.type_, &align)

			bounds_ptr := &Elf64_Addr(section_ptr_add(tcc_state.lbounds_section, 2 * sizeof(Elf64_Addr)))
			bounds_ptr[0] = s.c
			bounds_ptr[1] = size
		}
	}
}

fn pop_local_syms(b &Sym, keep int) {
	if tcc_state.do_bounds_check && !keep && (local_scope || !func_var) {
		add_local_bounds(local_stack, b)
	}
	if debug_modes {
		tcc_add_debug_info(tcc_state, !local_scope, local_stack, b)
	}
	sym_pop(&local_stack, b, keep)
}

fn incr_offset(offset int) {
	t := vtop.type_.t
	gaddrof()
	vtop.type_.t = vt_ptrdiff_t
	vpushs(offset)
	gen_op(`+`)
	vtop.r |= vt_lval
	vtop.type_.t = t
}

fn incr_bf_adr(o int) {
	vtop.type_.t = vt_byte | vt_unsigned
	incr_offset(o)
}

fn load_packed_bf(type_ &CType, bit_pos int, bit_size int) {
	n := 0
	o := 0
	bits := 0

	save_reg_upstack(vtop.r, 1)
	vpush64(type_.t & vt_btype, 0)
	bits = 0
	o = bit_pos >> 3
	bit_pos &= 7
	for {
		vswap()
		incr_bf_adr(o)
		vdup()
		n = 8 - bit_pos
		if n > bit_size {
			n = bit_size
		}
		if bit_pos {
			vpushi(bit_pos)
			gen_op(139)
			bit_pos = 0
		}
		if n < 8 {
			vpushi((1 << n) - 1)
			gen_op(`&`)
		}
		gen_cast(type_)
		if bits {
			vpushi(bits)
			gen_op(`<`)
		}
		vrotb(3)
		gen_op(`|`)
		bits += n
		bit_size -= n
		o = 1
		// while()
		if !bit_size {
			break
		}
	}
	vswap()
	vpop()
	if !(type_.t & vt_unsigned) {
		n = (if (type_.t & vt_btype) == vt_llong { 64 } else { 32 }) - bits
		vpushi(n)
		gen_op(`<`)
		vpushi(n)
		gen_op(`>`)
	}
}

fn store_packed_bf(bit_pos int, bit_size int) {
	bits := 0
	n := 0
	o := 0
	m := 0
	c := 0

	c = (vtop.r & (vt_valmask | vt_lval | vt_sym)) == vt_const
	vswap()
	save_reg_upstack(vtop.r, 1)
	bits = 0
	o = bit_pos >> 3
	bit_pos &= 7
	for {
		incr_bf_adr(o)
		vswap()
		if c {
			vdup()
		} else {
			gv_dup()
		}
		vrott(3)
		if bits {
			vpushi(bits)
			gen_op(139)
		}
		if bit_pos {
			vpushi(bit_pos)
			gen_op(`<`)
		}
		n = 8 - bit_pos
		if n > bit_size {
			n = bit_size
		}
		if n < 8 {
			m = ((1 << n) - 1) << bit_pos
			vpushi(m)
			gen_op(`&`)
			vpushv(unsafe { vtop - 1 })
			vpushi(if m & 0x80 { ~m & 0x7f } else { ~m })
			gen_op(`&`)
			gen_op(`|`)
		}

		vdup()
		vtop[-1] = vtop[-2]
		vstore()
		vpop()
		bits += n
		bit_size -= n
		bit_pos = 0
		o = 1
		// while()
		if !bit_size {
			break
		}
	}
	vpop()
	vpop()
}

fn adjust_bf(sv &SValue, bit_pos int, bit_size int) int {
	t := 0
	if 0 == sv.type_.ref {
		return 0
	}
	t = sv.type_.ref.auxtype
	if t != -1 && t != vt_struct {
		sv.type_.t = (sv.type_.t & ~(vt_btype | vt_long)) | t
		sv.r |= vt_lval
	}
	return t
}

fn gv(rc int) int {
	r := 0
	r2 := 0
	r_ok := 0
	r2_ok := 0
	rc2 := 0
	bt := 0

	bit_pos := 0
	bit_size := 0
	size := 0
	align := 0

	vcc_trace_print('${@LOCATION} .t=${vtop.type_.t}')

	if vtop.type_.t & vt_bitfield {
		type_ := CType{}

		vcc_trace_print('${@LOCATION} bitfield')

		bit_pos = (((vtop.type_.t) >> 20) & 63)
		bit_size = (((vtop.type_.t) >> (20 + 6)) & 63)
		vtop.type_.t &= ~(((1 << (6 + 6)) - 1) << 20 | 128)

		type_.ref = unsafe { nil }
		type_.t = vtop.type_.t & vt_unsigned
		if (vtop.type_.t & vt_btype) == vt_bool {
			type_.t |= vt_unsigned
		}

		r = adjust_bf(vtop, bit_pos, bit_size)

		if (vtop.type_.t & vt_btype) == vt_llong {
			type_.t |= vt_llong
		} else {
			type_.t |= vt_int
		}

		if r == vt_struct {
			load_packed_bf(&type_, bit_pos, bit_size)
		} else {
			bits := if (type_.t & vt_btype) == vt_llong { 64 } else { 32 }

			vcc_trace_print('${@LOCATION} cast')
			gen_cast(&type_)
			vpushi(bits - (bit_pos + bit_size))
			gen_op(`<`)
			vpushi(bits - bit_size)
			gen_op(`>`)
		}
		r = gv(rc)
	} else {
		if is_float(vtop.type_.t) && (vtop.r & (vt_valmask | vt_lval)) == vt_const {
			p := Init_params{
				sec: tcc_state.rodata_section
			}

			offset := u32(0)
			size = type_size(&vtop.type_, &align)
			if (nocode_wanted > 0) {
				size = 0
				align = 1
			}
			offset = section_add(p.sec, size, align)
			vpush_ref(&vtop.type_, p.sec, offset, size)
			vswap()
			init_putv(&p, &vtop.type_, offset)
			vtop.r |= vt_lval
		}
		if vtop.r & vt_mustbound {
			gbound()
		}

		bt = vtop.type_.t & vt_btype

		rc2 = rc2_type(bt, rc)

		r = vtop.r & vt_valmask

		r_ok = !(vtop.r & vt_lval) && r < vt_const && reg_classes[r] & rc
		r2_ok = !rc2 || (vtop.r2 < vt_const && reg_classes[vtop.r2] & rc2)

		if !r_ok || !r2_ok {
			vcc_trace_print('${@LOCATION} save_reg')
			if !r_ok {
				if 1 && r < vt_const && reg_classes[r] & rc && !rc2 {
					save_reg_upstack(r, 1)
				} else { // 3
					r = get_reg(rc)
				}
			}
			if rc2 {
				load_type := if (bt == vt_qfloat) { vt_double } else { vt_ptrdiff_t }
				original_type := vtop.type_.t

				if (vtop.r & (vt_valmask | vt_lval)) == vt_const {
					unsafe {
						ll := u64(vtop.c.i)
						vtop.c.i = ll
						vcc_trace_print('${@LOCATION} longlong vtop.c.i=${ll}')
						load(r, vtop)
						vtop.r = r
						vpushi(ll >> 32)
						vcc_trace_print('${@LOCATION} vtop.c.i=${ll}')
					}
				} else if vtop.r & vt_lval {
					save_reg_upstack(vtop.r, 1)
					vtop.type_.t = load_type
					vcc_trace_print('${@LOCATION} load.0')
					load(r, vtop)
					vdup()
					vtop[-1].r = r
					incr_offset(ptr_size)
				} else {
					vcc_trace_print('${@LOCATION} else')
					if !r_ok {
						load(r, vtop)
					}
					if r2_ok && vtop.r2 < vt_const {
						unsafe {
							goto done
						}
					}
					vdup()
					vtop[-1].r = r
					vtop.r = vtop[-1].r2
				}
				r2 = get_reg(rc2)
				load(r2, vtop)
				vpop()
				vtop.r2 = r2
				// RRRREG done id=0x7fffed4395d8
				done:
				vtop.type_.t = original_type
			} else {
				if vtop.r == vt_cmp {
					vset_vt_jmp()
				}
				load(r, vtop)
			}
		}
		vtop.r = r
	}
	return r
}

fn gv2(rc1 int, rc2 int) {
	if vtop.r != vt_cmp && rc1 <= rc2 {
		vswap()
		gv(rc1)
		vswap()
		gv(rc2)
		if (vtop[-1].r & vt_valmask) >= vt_const {
			vswap()
			gv(rc1)
			vswap()
		}
	} else {
		gv(rc2)
		vswap()
		gv(rc1)
		vswap()
		if (vtop[0].r & vt_valmask) >= vt_const {
			gv(rc2)
		}
	}
}

fn gv_dup() {
	t := 0
	rc := 0
	r := 0

	t = vtop.type_.t
	rc = rc_type(t)
	gv(rc)
	r = get_reg(rc)
	vdup()
	load(r, vtop)
	vtop.r = r
}

fn gen_opic_sdiv(a u64, b u64) u64 {
	x := u64((if a >> 63 { -a } else { a }) / (if b >> 63 { -b } else { b }))
	return if (a ^ b) >> 63 { -x } else { x }
}

fn gen_opic_lt(a u64, b u64) int {
	return int((a ^ u64(1) << 63) < (b ^ u64(1) << 63))
}

fn gen_opic(op int) {
	v1 := unsafe { vtop - 1 }
	v2 := vtop
	t1 := v1.type_.t & vt_btype
	t2 := v2.type_.t & vt_btype
	c1 := (v1.r & (vt_valmask | vt_lval | vt_sym)) == vt_const
	c2 := (v2.r & (vt_valmask | vt_lval | vt_sym)) == vt_const
	l1 := u64(unsafe { if c1 { v1.c.i } else { 0 } })
	l2 := u64(unsafe { if c2 { v2.c.i } else { 0 } })
	shm := u64(if (t1 == vt_llong) { 63 } else { 31 })
	r := 0

	if t1 != vt_llong && (ptr_size != 8 || t1 != vt_ptr) {
		C.printf(c'%s t1=%d v1.r=%d c1=%d l1.1=%ld\n', C.__FUNCTION__, t1, v1.r, c1, l1)
		l1 = (u32(l1) | (if v1.type_.t & vt_unsigned { 0 } else { -(l1 & u32(0x80000000)) }))
		C.printf(c'%s l1.2=%lu\n', C.__FUNCTION__, l1)
	}
	if t2 != vt_llong && (ptr_size != 8 || t2 != vt_ptr) {
		C.printf(c'%s t2=%d v2.r=%d c2=%d l2.1=%ld\n', C.__FUNCTION__, t2, v2.r, c2, l2)
		l2 = (u32(l2) | (if v2.type_.t & vt_unsigned { 0 } else { -(l2 & u32(0x80000000)) }))
		C.printf(c'%s l2.2=%ld\n', C.__FUNCTION__, l2)
	}
	if c1 && c2 {
		match rune(op) {
			`+` {
				l1 += l2
			}
			`-` {
				l1 -= l2
			}
			`&` {
				l1 &= l2
			}
			`^` {
				l1 ^= l2
			}
			`|` {
				l1 |= l2
			}
			`*` {
				l1 *= l2
			}
			133, `/`, `%`, 131, 132 {
				if l2 == 0 {
					if nocode_wanted & CONST_WANTED_MASK && !(nocode_wanted & NOEVAL_MASK) {
						_tcc_error('division by zero in constant')
					}
					unsafe {
						goto general_case
					} // id: 0x7fffed43f2b0
				}
				match rune(op) {
					`%` { // case comp body kind=BinaryOperator is_enum=false
						l1 = l1 - l2 * gen_opic_sdiv(l1, l2)
					}
					131 { // case comp body kind=BinaryOperator is_enum=false
						l1 = l1 / l2
					}
					132 { // case comp body kind=BinaryOperator is_enum=false
						l1 = l1 % l2
					}
					else {
						l1 = gen_opic_sdiv(l1, l2)
					}
				}
			}
			`<` {
				l1 <<= (l2 & shm)
			}
			139 {
				l1 >>= (l2 & shm)
			}
			`>` {
				l1 = if (l1 >> 63) { ~(~l1 >> (l2 & shm)) } else { l1 >> (l2 & shm) }
			}
			146 {
				l1 = l1 < l2
			}
			147 {
				l1 = l1 >= l2
			}
			148 {
				l1 = l1 == l2
			}
			149 {
				l1 = l1 != l2
			}
			150 {
				l1 = l1 <= l2
			}
			151 {
				l1 = l1 > l2
			}
			156 {
				l1 = gen_opic_lt(l1, l2)
			}
			157 {
				l1 = !gen_opic_lt(l1, l2)
			}
			158 {
				l1 = !gen_opic_lt(l2, l1)
			}
			159 {
				l1 = gen_opic_lt(l2, l1)
			}
			144 {
				l1 = l1 && l2
			}
			145 {
				l1 = l1 || l2
			}
			else {
				unsafe {
					goto general_case
				}
			}
		}
		C.printf(c'%s t1=%d l1=%ld %ld\n', C.__FUNCTION__, t1, l1, -(l1 & 0x80000000))
		if t1 != vt_llong && (ptr_size != 8 || t1 != vt_ptr) {
			l1 = (u32(l1) | (if v1.type_.t & vt_unsigned { 0 } else { -(l1 & 0x80000000) }))
		}
		v1.c.i = l1
		v1.r |= v2.r & vt_nonconst
		vcc_trace_print('${@LOCATION} v1.c.i=${l1}')
		unsafe { vtop-- }
	} else {
		if c1 && (op == `+` || op == `&` || op == `^` || op == `|` || op == `*`
			|| op == 148 || op == 149) {
			vswap()
			c2 = c1
			l2 = l1
		}
		if c1 && ((l1 == 0 && (op == `<` || op == 139 || op == `>`)) || (l1 == -1 && op == `>`)) {
			vpop()
		} else if c2 && ((l2 == 0 && (op == `&` || op == `*`))
			|| (op == `|` && (l2 == -1 || (l2 == 4294967295 && t2 != 4)))
			|| (l2 == 1 && (op == `%` || op == 132))) {
			if l2 == 1 {
				vtop.c.i = 0
				vcc_trace_print('${@LOCATION} vtop.c.i=${vtop.c.i}')
			}
			vswap()
			unsafe { vtop-- }
		} else if c2 && (((op == `*` || op == `/` || op == 131 || op == 133) && l2 == 1)
			|| ((op == `+` || op == `-` || op == `|` || op == `^` || op == `<` || op == 139
			|| op == `>`) && l2 == 0)
			|| (op == `&` && (l2 == -1 || (l2 == 4294967295 && t2 != 4)))) {
			unsafe { vtop-- }
		} else if c2 && (op == `*` || op == 133 || op == 131) {
			if l2 > 0 && (l2 & (l2 - 1)) == 0 {
				n := -1
				for l2 {
					l2 >>= 1
					n++
				}
				vcc_trace_print('${@LOCATION} n=${n}')
				vtop.c.i = n
				if op == `*` {
					op = `<`
				} else if op == 133 {
					op = `>`
				} else {
					op = 139
				}
			}
			unsafe {
				goto general_case
			}
		} else if c2 && (op == `+` || op == `-`)
			&& ((vtop[-1].r & (vt_valmask | vt_lval | vt_sym)) == (vt_const | vt_sym)
			|| (vtop[-1].r & (vt_valmask | vt_lval | vt_sym)) == vt_local) {
			r = vtop[-1].r & (vt_valmask | vt_lval | vt_sym)
			// symbol + constant case
			if op == `-` {
				l2 = -l2
			}
			l2 += vtop[-1].c.i
			if u64(int(l2)) != l2 {
				unsafe {
					goto general_case
				}
			}
			unsafe { vtop-- }
			vtop.c.i = l2
			vcc_trace_print('${@LOCATION} l2=${int(l2)}')
		} else {
			general_case:
			// call low level op generator
			if t1 == vt_llong || t2 == vt_llong || (ptr_size == 8 && (t1 == vt_ptr || t2 == vt_ptr)) {
				gen_opl(op)
			} else {
				gen_opi(op)
			}
		}
		if vtop.r == vt_const {
			vtop.r |= vt_nonconst // is const, but only by optimization
		}
	}
}

union Gen_opif_union {
	f f64
	u u32
}

fn gen_opif(op int) {
	c1 := 0
	c2 := 0
	i := 0
	bt := 0

	v1 := &SValue(0)
	v2 := &SValue(0)

	f1 := f64(0.0)
	f2 := f64(0.0)

	v1 = unsafe { vtop - 1 }
	v2 = vtop
	if op == 129 {
		v1 = v2
	}
	bt = v1.type_.t & vt_btype
	c1 = (v1.r & (vt_valmask | vt_lval | vt_sym)) == vt_const
	c2 = (v2.r & (vt_valmask | vt_lval | vt_sym)) == vt_const
	if c1 && c2 {
		unsafe {
			if bt == 8 {
				f1 = v1.c.f
				f2 = v2.c.f
			} else if bt == 9 {
				f1 = v1.c.d
				f2 = v2.c.d
			} else {
				f1 = v1.c.ld
				f2 = v2.c.ld
			}
		}
		if !(ieee_finite(f1) || !ieee_finite(f2)) && !(nocode_wanted & CONST_WANTED_MASK) {
			unsafe {
				goto general_case
			}
		}
		match rune(op) {
			`+` { // case comp body kind=CompoundAssignOperator is_enum=false
				f1 += f2
			}
			`-` { // case comp body kind=CompoundAssignOperator is_enum=false
				f1 -= f2
			}
			`*` { // case comp body kind=CompoundAssignOperator is_enum=false
				f1 *= f2
			}
			`/` { // case comp body kind=IfStmt is_enum=false
				if f2 == 0 {
					x1 := Gen_opif_union{}
					x2 := Gen_opif_union{}
					y := Gen_opif_union{}
					if !(nocode_wanted & CONST_WANTED_MASK) {
						unsafe {
							goto general_case
						} // id: 0x7fffed447ea8
					}
					x1.f = f1
					x2.f = f2
					unsafe {
						if f1 == 0 {
							y.u = 0x7fc00000 // nan
						} else { // 3
							y.u = 0x7f800000 // infinity
						}

						y.u |= (x1.u ^ x2.u) & 0x80000000 // set sign
						f1 = y.f
					}
				}
				f1 /= f2
			}
			129 { // case comp body kind=BinaryOperator is_enum=false
				f1 = -f1
				unsafe {
					goto unary_result
				} // id: 0x7fffed449028
			}
			148 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 == f2
				// RRRREG make_int id=0x7fffed449230
				make_int:
				vtop -= 2
				vpushi(i)
				return
			}
			149 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 != f2
				unsafe {
					goto make_int
				} // id: 0x7fffed449230
			}
			156 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 < f2
				unsafe {
					goto make_int
				} // id: 0x7fffed449230
			}
			157 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 >= f2
				unsafe {
					goto make_int
				} // id: 0x7fffed449230
			}
			158 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 <= f2
				unsafe {
					goto make_int
				} // id: 0x7fffed449230
			}
			159 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 > f2
				unsafe {
					goto make_int
				} // id: 0x7fffed449230
			}
			else {
				unsafe {
					goto general_case
				} // id: 0x7fffed447ea8
			}
		}
		unsafe { vtop-- }
		// RRRREG unary_result id=0x7fffed449028
		unary_result:
		if bt == vt_float {
			v1.c.f = f1
		} else if bt == vt_double {
			v1.c.d = f1
		} else {
			v1.c.ld = f1
		}
	} else {
		// RRRREG general_case id=0x7fffed447ea8
		general_case:
		if op == 129 {
			gen_opf(op)
		} else {
			gen_opf(op)
		}
	}
}

fn type_to_str(buf &char, buf_size int, type_ &CType, varstr &char) {
	bt := 0
	v := 0
	t := 0

	s := &Sym(0)
	sa := &Sym(0)

	buf1 := [256]char{}
	tstr := &char(0)
	t = type_.t
	bt = t & 15
	buf[0] = `\x00`
	if t & 4096 {
		pstrcat(buf, buf_size, c'extern ')
	}
	if t & 8192 {
		pstrcat(buf, buf_size, c'static ')
	}
	if t & 16384 {
		pstrcat(buf, buf_size, c'typedef ')
	}
	if t & 32768 {
		pstrcat(buf, buf_size, c'inline ')
	}
	if bt != 5 {
		if t & 512 {
			pstrcat(buf, buf_size, c'volatile ')
		}
		if t & 256 {
			pstrcat(buf, buf_size, c'const ')
		}
	}
	if (t & 32 && bt == 1) || (t & 16 && (bt == 2 || bt == 3 || bt == 4)
		&& !((t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20))) {
		pstrcat(buf, buf_size, if (t & 16) { c'unsigned ' } else { c'signed ' })
	}
	unsafe {
		buf_size -= C.strlen(buf)
		buf += C.strlen(buf)
	}
	match bt {
		0 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'void'
			unsafe {
				goto add_tstr
			} // id: 0x7fffed44c8d8
		}
		11 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'_Bool'
			unsafe {
				goto add_tstr
			} // id: 0x7fffed44c8d8
		}
		1 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'char'
			unsafe {
				goto add_tstr
			} // id: 0x7fffed44c8d8
		}
		2 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'short'
			unsafe {
				goto add_tstr
			} // id: 0x7fffed44c8d8
		}
		3 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'int'
			unsafe {
				goto maybe_long
			} // id: 0x7fffed44cd80
		}
		4 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'long long'
			// RRRREG maybe_long id=0x7fffed44cd80
			maybe_long:
			if t & 2048 {
				tstr = c'long'
			}
			if !((t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
				unsafe {
					goto add_tstr
				} // id: 0x7fffed44c8d8
			}
			tstr = c'enum '
			unsafe {
				goto tstruct
			} // id: 0x7fffed44d480
		}
		8 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'float'
			unsafe {
				goto add_tstr
			} // id: 0x7fffed44c8d8
		}
		9 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'double'
			if !(t & 2048) {
				unsafe {
					goto add_tstr
				} // id: 0x7fffed44c8d8
			}
		}
		10 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'long double'
			// RRRREG add_tstr id=0x7fffed44c8d8
			add_tstr:
			pstrcat(buf, buf_size, tstr)
		}
		7 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'struct '
			if ((t & ((((1 << (6 + 6)) - 1) << 20 | 128) | 15)) == (1 << 20 | 7)) {
				tstr = c'union '
			}
			// RRRREG tstruct id=0x7fffed44d480
			tstruct:
			pstrcat(buf, buf_size, tstr)
			v = type_.ref.v & ~1073741824
			if v >= 268435456 {
				pstrcat(buf, buf_size, c'<anonymous>')
			} else { // 3
				pstrcat(buf, buf_size, get_tok_str(v, (unsafe { nil })))
			}
		}
		6 { // case comp body kind=BinaryOperator is_enum=false
			s = type_.ref
			buf1[0] = 0
			if varstr && `*` == *varstr {
				pstrcat(buf1, sizeof(buf1), c'(')
				pstrcat(buf1, sizeof(buf1), varstr)
				pstrcat(buf1, sizeof(buf1), c')')
			}
			pstrcat(buf1, buf_size, c'(')
			sa = s.next
			for sa != (unsafe { nil }) {
				buf2 := [256]char{}
				type_to_str(buf2, sizeof(buf2), &sa.type_, (unsafe { nil }))
				pstrcat(buf1, sizeof(buf1), buf2)
				sa = sa.next
				if sa {
					pstrcat(buf1, sizeof(buf1), c', ')
				}
			}
			if s.f.func_type == 3 {
				pstrcat(buf1, sizeof(buf1), c', ...')
			}
			pstrcat(buf1, sizeof(buf1), c')')
			type_to_str(buf, buf_size, &s.type_, buf1)
			unsafe {
				goto no_var
			} // id: 0x7fffed450020
		}
		5 { // case comp body kind=BinaryOperator is_enum=false
			s = type_.ref
			if t & (64 | 1024) {
				unsafe {
					if varstr && `*` == *varstr {
						C.snprintf(buf1, sizeof(buf1), c'(%s)[%d]', varstr, s.c)
					} else { // 3
						C.snprintf(buf1, sizeof(buf1), c'%s[%d]', if varstr { varstr } else { c'' },
							s.c)
					}

					type_to_str(buf, buf_size, &s.type_, buf1)
					goto no_var // id: 0x7fffed450020
				}
			}
			pstrcpy(buf1, sizeof(buf1), c'*')
			if t & 256 {
				pstrcat(buf1, buf_size, c'const ')
			}
			if t & 512 {
				pstrcat(buf1, buf_size, c'volatile ')
			}
			if varstr {
				pstrcat(buf1, sizeof(buf1), varstr)
			}
			type_to_str(buf, buf_size, &s.type_, buf1)
			unsafe {
				goto no_var
			} // id: 0x7fffed450020
		}
		else {}
	}
	if varstr {
		pstrcat(buf, buf_size, c' ')
		pstrcat(buf, buf_size, varstr)
	}
	// RRRREG no_var id=0x7fffed450020
	no_var:
	0
}

fn type_incompatibility_error(st &CType, dt &CType, fmt &char) {
	buf1 := [256]char{}
	buf2 := [256]char{}

	type_to_str(buf1, sizeof(buf1), st, unsafe { nil })
	type_to_str(buf2, sizeof(buf2), dt, unsafe { nil })

	vfmt := fmt.vstring()
	vfmt = vfmt.replace_once('%s', (&char(buf1)).vstring())
	vfmt = vfmt.replace_once('%s', (&char(buf2)).vstring())
	_tcc_error(vfmt)
}

fn type_incompatibility_warning(st &CType, dt &CType, fmt &char) {
	buf1 := [256]char{}
	buf2 := [256]char{}

	type_to_str(buf1, sizeof(buf1), st, (unsafe { nil }))
	type_to_str(buf2, sizeof(buf2), dt, (unsafe { nil }))
	_tcc_warning('${buf1} ${buf2}')
}

fn pointed_size(type_ &CType) int {
	align := 0
	return type_size(pointed_type(type_), &align)
}

fn is_null_pointer(p &SValue) bool {
	if (p.r & (63 | 256 | 512 | 4096)) != 48 {
		return false
	}
	return unsafe {
		((p.type_.t & 15) == 3 && u32(p.c.i) == 0) || ((p.type_.t & 15) == 4 && p.c.i == 0) || ((p.type_.t & 15) == 5 && (if 8 == 4 {
			u32(p.c.i) == 0
		} else {
			p.c.i == 0
		}) && (pointed_type(&p.type_).t & 15) == 0 && 0 == (pointed_type(&p.type_).t & (256 | 512)))
	}
}

fn is_compatible_func(type1 &CType, type2 &CType) bool {
	s1 := &Sym(0)
	s2 := &Sym(0)

	s1 = type1.ref
	s2 = type2.ref
	if s1.f.func_call != s2.f.func_call {
		return false
	}
	if s1.f.func_type != s2.f.func_type && s1.f.func_type != 2 && s2.f.func_type != 2 {
		return false
	}
	for ; true; {
		if !is_compatible_unqualified_types(&s1.type_, &s2.type_) {
			return false
		}
		if s1.f.func_type == 2 || s2.f.func_type == 2 {
			return true
		}
		s1 = s1.next
		s2 = s2.next
		if !s1 {
			return bool(!s2)
		}
		if !s2 {
			return false
		}
	}
	return false
}

fn compare_types(type1 &CType, type2 &CType, unqualified int) bool {
	bt1 := 0
	t1 := 0
	t2 := 0

	t1 = type1.t & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
	t2 = type2.t & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
	if unqualified {
		t1 &= ~(vt_constant | vt_volatile)
		t2 &= ~(vt_constant | vt_volatile)
	}
	if (t1 & vt_btype) != vt_byte {
		t1 &= ~vt_defsign
		t2 &= ~vt_defsign
	}
	if t1 != t2 {
		return false
	}
	if t1 & vt_array && !(type1.ref.c < 0 || type2.ref.c < 0 || type1.ref.c == type2.ref.c) {
		return false
	}
	bt1 = t1 & vt_btype
	if bt1 == vt_ptr {
		type1 = pointed_type(type1)
		type2 = pointed_type(type2)
		return is_compatible_types(type1, type2)
	} else if bt1 == vt_struct {
		return voidptr(type1.ref) == voidptr(type2.ref)
	} else if bt1 == vt_func {
		return is_compatible_func(type1, type2)
	} else if (type1.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)
		&& (type2.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20) {
		return voidptr(type1.ref) == voidptr(type2.ref)
	} else {
		return true
	}
}

fn combine_types(dest &CType, op1 &SValue, op2 &SValue, op int) int {
	type1 := &op1.type_
	type2 := &op2.type_
	type_ := CType{}

	t1 := type1.t
	t2 := type2.t
	bt1 := t1 & vt_btype
	bt2 := t2 & vt_btype

	ret := 1
	type_.t = vt_void
	type_.ref = unsafe { nil }

	if bt1 == vt_void || bt2 == vt_void {
		ret = if op == `?` { 1 } else { 0 }
		type_.t = vt_void
	} else if bt1 == vt_ptr || bt2 == vt_ptr {
		if op == `+` {
		} else if is_null_pointer(op2) {
			type_ = *type1
		} else if is_null_pointer(op1) {
			type_ = *type2
		} else if bt1 != bt2 {
			if (op == `?` || (op >= 144 && op <= 159))
				&& (is_integer_btype(bt1) || is_integer_btype(bt2)) {
				if op == `?` {
					_tcc_warning('pointer/integer mismatch in conditional expression')
				} else {
					_tcc_warning('pointer/integer mismatch in comparison')
				}
			} else if op != `-` || !is_integer_btype(bt2) {
				ret = 0
			}
			type_ = *(if bt1 == vt_ptr { type1 } else { type2 })
		} else {
			pt1 := pointed_type(type1)
			pt2 := pointed_type(type2)
			pbt1 := pt1.t & vt_btype
			pbt2 := pt2.t & vt_btype
			newquals := 0
			copied := 0

			if pbt1 != vt_void && pbt2 != vt_void && !compare_types(pt1, pt2, 1) {
				if op != `?` && !(op >= 144 && op <= 159) {
					ret = 0
				} else { // 3
					type_incompatibility_warning(type1, type2, if op == `?` {
						c"pointer type mismatch in conditional expression ('%s' and '%s')"
					} else {
						c"pointer type mismatch in comparison('%s' and '%s')"
					})
				}
			}
			if op == `?` {
				type_ = *(if (pbt1 == vt_void) { type1 } else { type2 })
				newquals = ((pt1.t | pt2.t) & (vt_constant | vt_volatile))
				if (~pointed_type(&type_).t & (vt_constant | vt_volatile)) & newquals {
					type_.ref = sym_push(sym_field, &type_.ref.type_, 0, type_.ref.c)
					copied = 1
					pointed_type(&type_).t |= newquals
				}
				if pt1.t & vt_array && pt2.t & vt_array && pointed_type(&type_).ref.c < 0
					&& (pt1.ref.c > 0 || pt2.ref.c > 0) {
					if !copied {
						type_.ref = sym_push(sym_field, &type_.ref.type_, 0, type_.ref.c)
					}
					pointed_type(&type_).ref = sym_push(sym_field, &pointed_type(&type_).ref.type_,
						0, pointed_type(&type_).ref.c)
					pointed_type(&type_).ref.c = if 0 < pt1.ref.c { pt1.ref.c } else { pt2.ref.c }
				}
			}
		}
		if (op >= 144 && op <= 159) {
			type_.t = vt_size_t
		}
	} else if bt1 == vt_struct || bt2 == vt_struct {
		if op != `?` || !compare_types(type1, type2, 1) {
			ret = 0
		}
		type_ = *type1
	} else if is_float(bt1) || is_float(bt2) {
		if bt1 == vt_ldouble || bt2 == vt_ldouble {
			type_.t = vt_ldouble
		} else if bt1 == vt_double || bt2 == vt_double {
			type_.t = vt_double
		} else {
			type_.t = vt_float
		}
	} else if bt1 == vt_llong || bt2 == vt_llong {
		type_.t = vt_llong | vt_long
		if bt1 == vt_llong {
			type_.t &= t1
		}
		if bt2 == vt_llong {
			type_.t &= t2
		}
		if (t1 & (vt_btype | vt_unsigned | vt_bitfield)) == (4 | 16)
			|| (t2 & (15 | 16 | 128)) == (vt_llong | vt_unsigned) {
			type_.t |= vt_unsigned
		}
	} else {
		type_.t = vt_int | (vt_long & (t1 | t2))
		if (t1 & (vt_btype | vt_unsigned | vt_bitfield)) == (3 | 16)
			|| (t2 & (vt_btype | vt_unsigned | vt_bitfield)) == (vt_int | vt_unsigned) {
			type_.t |= vt_unsigned
		}
	}
	if dest {
		*dest = type_
	}
	return ret
}

fn gen_op(op int) {
	t1 := 0
	t2 := 0
	bt1 := 0
	bt2 := 0
	t := 0

	type1 := CType{}
	combtype := CType{}

	// RRRREG redo id=0x7fffed462e40
	redo:
	t1 = vtop[-1].type_.t
	t2 = vtop[0].type_.t

	bt1 = t1 & vt_btype
	bt2 = t2 & vt_btype

	vcc_trace_print('${@LOCATION} t1=${t1} bt1=${bt1} t2=${t2} bt2=${bt2}')
	if bt1 == vt_func || bt2 == vt_func {
		if bt2 == vt_func {
			mk_pointer(&vtop.type_)
			gaddrof()
		}
		if bt1 == vt_func {
			vswap()
			mk_pointer(&vtop.type_)
			gaddrof()
			vswap()
		}
		unsafe {
			goto redo
		} // id: 0x7fffed462e40
	} else if !combine_types(&combtype, unsafe { vtop - 1 }, vtop, op) {
		_tcc_error('invalid operand types for binary operation')
	} else if bt1 == vt_ptr || bt2 == vt_ptr {
		align := 0
		if (op >= 144 && op <= 159) {
			unsafe {
				goto std_op
			} // id: 0x7fffed463d50
		}
		if bt1 == vt_ptr && bt2 == vt_ptr {
			if op != `-` {
				_tcc_error('cannot use pointers here')
			}
			vcc_trace_print('${@LOCATION} ptr t1=${t1}')
			vpush_type_size(pointed_type(&vtop[-1].type_), &align)
			vrott(3)
			gen_opic(op)
			vtop.type_.t = vt_ptrdiff_t
			vswap()
			gen_op(tok_pdiv)
		} else {
			if op != `-` && op != `+` {
				_tcc_error('cannot use pointers here')
			}
			if bt2 == vt_ptr {
				vswap()
				t = t1
				t1 = t2
				t2 = t
			}
			type1 = vtop[-1].type_
			vpush_type_size(pointed_type(&vtop[-1].type_), &align)
			gen_op(`*`)
			if tcc_state.do_bounds_check && !(nocode_wanted & CONST_WANTED_MASK) {
				if op == `-` {
					vpushi(0)
					vswap()
					vcc_trace_print('${@LOCATION} genop- t1=${t1}')
					gen_op(`-`)
				}
				gen_bounded_ptr_add()
			} else {
				vcc_trace_print('${@LOCATION} else t1=${t1}')
				gen_opic(op)
			}
			type1.t &= ~(vt_array | vt_vla)
			vtop.type_ = type1
		}
	} else {
		if is_float(combtype.t) && op != `+` && op != `-` && op != `*` && op != `/` && !(op >= 144
			&& op <= 159) {
			_tcc_error('invalid operands for binary operation')
		} else if op == 139 || op == `>` || op == `<` {
			t = if bt1 == 4 { 4 } else { 3 }
			if (t1 & (15 | 16 | 128)) == (t | 16) {
				t |= vt_unsigned
			}
			t |= (vt_long & t1)
			combtype.t = t
			vcc_trace_print('${@LOCATION} combined t=${t} t1=${t1}')
		}
		// RRRREG std_op id=0x7fffed463d50
		std_op:
		t = combtype.t
		t2 = t
		if t & vt_unsigned {
			if op == `>` {
				op = tok_shr
			} else if op == `/` {
				op = tok_udiv
			} else if op == `%` {
				op = tok_umod
			} else if op == 156 {
				op = 146
			} else if op == 159 {
				op = 151
			} else if op == 158 {
				op = 150
			} else if op == 157 {
				op = 147
			}
			vcc_trace_print('${@LOCATION} gen_op.unsigned')
		}
		vswap()
		gen_cast_s(t)
		vswap()
		if op == 139 || op == `>` || op == `<` {
			t2 = vt_int
			vcc_trace_print('${@LOCATION} int')
		}
		gen_cast_s(t2)
		if is_float(t) {
			vcc_trace_print('${@LOCATION} is_float')
			gen_opif(op)
		} else { // 3
			vcc_trace_print('${@LOCATION} is not float')
			gen_opic(op)
		}
		if (op >= 144 && op <= 159) {
			vtop.type_.t = vt_int
		} else {
			vtop.type_.t = t
		}
	}
	if vtop.r & vt_lval {
		vcc_trace_print('${@LOCATION} gen_op.float')
		gv(if is_float(vtop.type_.t & vt_btype) { rc_float } else { rc_int })
	}
	vcc_trace_print('${@LOCATION} gen_op.end')
}

fn gen_cvt_itof1(t int) {
	if (vtop.type_.t & (vt_btype | vt_unsigned)) == (vt_llong | vt_unsigned) {
		if t == 8 {
			vpush_helper_func(Tcc_token.tok___floatundisf)
		} else if t == 10 {
			vpush_helper_func(Tcc_token.tok___floatundixf)
		} else { // 3
			vpush_helper_func(Tcc_token.tok___floatundidf)
		}
		vrott(2)
		gfunc_call(1)
		vpushi(0)
		put_r_ret(vtop, t)
	} else {
		gen_cvt_itof(t)
	}
}

fn gen_cvt_ftoi1(t int) {
	st := 0
	if t == (vt_llong | vt_unsigned) {
		st = vtop.type_.t & vt_btype
		if st == 8 {
			vpush_helper_func(Tcc_token.tok___fixunssfdi)
		} else if st == 10 {
			vpush_helper_func(Tcc_token.tok___fixunsxfdi)
		} else { // 3
			vpush_helper_func(Tcc_token.tok___fixunsdfdi)
		}
		vrott(2)
		gfunc_call(1)
		vpushi(0)
		put_r_ret(vtop, t)
	} else {
		gen_cvt_ftoi(t)
	}
}

fn force_charshort_cast() {
	sbt := if (((vtop.r) & (3072)) / (u32(((3072) & ~((3072) << 1))) * (1))) == 2 { 4 } else { 3 }
	dbt := vtop.type_.t
	vtop.r &= ~3072
	vtop.type_.t = sbt
	gen_cast_s(if dbt == 11 { 1 | 16 } else { dbt })
	vtop.type_.t = dbt
}

fn gen_cast_s(t int) {
	type_ := CType{}
	type_.t = t
	type_.ref = unsafe { nil }
	gen_cast(&type_)
}

fn gen_cast(type_ &CType) {
	sbt := 0
	dbt := 0
	sf := 0
	df := 0
	c := 0

	dbt_bt := 0
	sbt_bt := 0
	ds := 0
	ss := 0
	bits := 0
	trunc := 0

	vcc_trace_print('${@LOCATION}')

	if vtop.r & 3072 {
		vcc_trace_print('${@LOCATION} cast.1')
		force_charshort_cast()
	}
	if vtop.type_.t & 128 {
		vcc_trace_print('${@LOCATION} cast.2')
		gv(1)
	}
	dbt = type_.t & (vt_btype | vt_unsigned)
	sbt = vtop.type_.t & (vt_btype | vt_unsigned)
	if sbt == vt_func {
		sbt = vt_ptr
	}
	// RRRREG again id=0x7fffed470288
	again:
	vcc_trace_print('${@LOCATION} cast.again')
	if sbt != dbt {
		sf = is_float(sbt)
		df = is_float(dbt)
		dbt_bt = dbt & vt_btype
		sbt_bt = sbt & vt_btype
		if dbt_bt == vt_void {
			unsafe {
				goto done
			} // id: 0x7fffed46b878
		}
		if sbt_bt == vt_void {
			// RRRREG error id=0x7fffed46baf8
			error:
			vcc_trace_print('${@LOCATION} cast.error')
			cast_error(&vtop.type_, type_)
		}
		c = (vtop.r & (vt_valmask | vt_lval | vt_sym)) == vt_const
		if c {
			unsafe {
				if sbt == vt_float {
					vtop.c.ld = vtop.c.f
				} else if sbt == vt_double {
					vtop.c.ld = vtop.c.d
				}
				vcc_trace_print('${@LOCATION} long double.0=${vtop.c.ld}')
			}
			if df {
				if sbt_bt == vt_llong {
					unsafe {
						if sbt & vt_unsigned || !(vtop.c.i >> 63) {
							vtop.c.ld = vtop.c.i
							vcc_trace_print('${@LOCATION} long double.1=${vtop.c.ld}')
						} else { // 3
							vtop.c.ld = -f64(-vtop.c.i)
							vcc_trace_print('${@LOCATION} long double.2=${vtop.c.ld}')
						}
					}
				} else if !sf {
					unsafe {
						if sbt & vt_unsigned || !(vtop.c.i >> 31) {
							vtop.c.ld = u32(vtop.c.i)
						} else { // 3
							vtop.c.ld = -f64(-u32(vtop.c.i))
							vcc_trace_print('${@LOCATION} long double2=${vtop.c.ld}')
						}
					}
				}
				unsafe {
					if dbt == vt_float {
						vtop.c.f = f32(vtop.c.ld)
					} else if dbt == vt_double {
						vtop.c.d = f64(vtop.c.ld)
					}
				}
			} else if sf && dbt == vt_bool {
				unsafe {
					vtop.c.i = (vtop.c.ld != 0)
				}
			} else {
				unsafe {
					vcc_trace_print('${@LOCATION} 0 v.c.i=${vtop.c.i}')
					if sf {
						vtop.c.i = vtop.c.ld
					} else if sbt_bt == vt_llong || (ptr_size == 8 && sbt == vt_ptr) {
					} else if sbt & vt_unsigned {
						vtop.c.i = u32(vtop.c.i)
						vcc_trace_print('${@LOCATION} u32.0=${vtop.c.i}')
					} else { // 3
						vtop.c.i = (u32(vtop.c.i) | -(vtop.c.i & u32(0x80000000)))
						vcc_trace_print('${@LOCATION} u32.1=${vtop.c.i}')
					}
					if dbt_bt == vt_llong || (ptr_size == 8 && dbt == vt_ptr) {
					} else if dbt == vt_bool {
						vtop.c.i = (vtop.c.i != 0)
					} else {
						m := u32(if dbt_bt == vt_btype {
							0xff
						} else {
							if dbt_bt == vt_short { 0xffff } else { u32(0xffffffff) }
						})
						vcc_trace_print('${@LOCATION} u32.3=${vtop.c.i} m=${m}')
						vtop.c.i &= m
						if !(dbt & vt_unsigned) {
							vtop.c.i |= -(vtop.c.i & ((m >> 1) + 1))
							vcc_trace_print('${@LOCATION} unisig.6=${vtop.c.i}')
						}
					}
					vcc_trace_print('${@LOCATION} v.c.i=${vtop.c.i}')
				}
			}
			unsafe {
				vcc_trace_print('${@LOCATION} goto done')
				goto done
			} // id: 0x7fffed46b878
		} else if dbt == vt_bool
			&& (vtop.r & (vt_valmask | vt_lval | vt_sym)) == (vt_const | vt_sym) {
			vtop.r = vt_const
			vtop.c.i = 1
			vcc_trace_print('${@LOCATION} vtop.c.i=1 fix')
			unsafe {
				goto done
			} // id: 0x7fffed46b878
		}
		if nocode_wanted & data_only_wanted {
			unsafe {
				vcc_trace_print('${@LOCATION} goto done2')
				goto done
			} // id: 0x7fffed46b878
		}
		if dbt == vt_bool {
			gen_test_zero(149)
			unsafe {
				vcc_trace_print('${@LOCATION} goto done3')
				goto done
			} // id: 0x7fffed46b878
		}
		if sf || df {
			vcc_trace_print('${@LOCATION} cast.2')
			if sf && df {
				gen_cvt_ftof(dbt)
			} else if df {
				gen_cvt_itof1(dbt)
			} else {
				sbt = dbt
				if dbt_bt != vt_llong && dbt_bt != vt_int {
					sbt = vt_int
				}
				gen_cvt_ftoi1(sbt)
				unsafe {
					goto again
				} // id: 0x7fffed470288
			}
			unsafe {
				goto done
			} // id: 0x7fffed46b878
		}
		ds = btype_size(dbt_bt)
		ss = btype_size(sbt_bt)
		if ds == 0 || ss == 0 {
			unsafe {
				goto error
			} // id: 0x7fffed46baf8
		}
		if (type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20) && type_.ref.c < 0 {
			_tcc_error('cast to incomplete type')
		}
		if ds == ss && ds >= 4 {
			unsafe {
				goto done
			} // id: 0x7fffed46b878
		}
		if dbt_bt == vt_ptr || sbt_bt == vt_ptr {
			_tcc_warning('cast between pointer and integer of different size')
			if sbt_bt == 5 {
				vtop.type_.t = (if ptr_size == 8 { 4 } else { 3 })
			}
		}
		if 1 && vtop.r & vt_lval {
			unsafe {
				if ds <= ss {
					goto done // id: 0x7fffed46b878
				}
				if ds <= 4 && !(dbt == (vt_short | vt_unsigned) && sbt == vt_byte) {
					gv(1)
					goto done // id: 0x7fffed46b878
				}
			}
		}
		vcc_trace_print('${@LOCATION} cast.3')
		gv(1)
		trunc = 0
		if ds == 8 {
			unsafe {
				if sbt & vt_unsigned {
					goto done // id: 0x7fffed46b878
				} else {
					gen_cvt_sxtw()
					goto done // id: 0x7fffed46b878
				}
			}
			ss = ds
			ds = 4
			dbt = sbt
		} else if ss == 8 {
			trunc = 32
		} else {
			ss = 4
		}
		if ds >= ss {
			unsafe {
				goto done
			}
		}
		if ss == 4 {
			gen_cvt_csti(dbt)
			unsafe {
				goto done
			}
		}
		vcc_trace_print('${@LOCATION} cast.4')
		bits = (ss - ds) * 8
		vtop.type_.t = (if ss == 8 { vt_llong } else { vt_int }) | (dbt & vt_unsigned)
		vpushi(bits)
		gen_op(`<`)
		vpushi(bits - trunc)
		gen_op(`>`)
		vpushi(trunc)
		gen_op(139)
	}
	// RRRREG done id=0x7fffed46b878
	done:
	vtop.type_ = *type_
	vtop.type_.t &= ~(vt_constant | vt_volatile | vt_array)
	vcc_trace_print('${@LOCATION} cast.end')
}

fn type_size(type_ &CType, a &int) int {
	s := &Sym(0)
	bt := 0
	bt = type_.t & vt_btype
	if bt == vt_struct {
		s = type_.ref
		*a = s.r
		return s.c
	} else if bt == vt_ptr {
		if type_.t & vt_array {
			ts := 0
			s = type_.ref
			ts = type_size(&s.type_, a)
			if ts < 0 && s.c < 0 {
				ts = -ts
			}
			return ts * s.c
		} else {
			*a = ptr_size
			return ptr_size
		}
	} else if (type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20) && type_.ref.c < 0 {
		*a = 0
		return -1
	} else if bt == 10 {
		*a = 16
		return 16
	} else if bt == 9 || bt == 4 {
		*a = 8
		return 8
	} else if bt == 3 || bt == 8 {
		*a = 4
		return 4
	} else if bt == 2 {
		*a = 2
		return 2
	} else if bt == 13 || bt == 14 {
		*a = 8
		return 16
	} else {
		*a = 1
		return 1
	}
}

fn vpush_type_size(type_ &CType, a &int) {
	if type_.t & vt_vla {
		type_size(&type_.ref.type_, a)
		vset(&int_type, 50 | 256, type_.ref.c)
	} else {
		size := type_size(type_, a)
		if size < 0 {
			_tcc_error('unknown type size')
		}
		vpushs(size)
	}
}

fn pointed_type(type_ &CType) &CType {
	return &type_.ref.type_
}

fn mk_pointer(type_ &CType) {
	s := &Sym(0)
	s = sym_push(sym_field, type_, 0, -1)
	type_.t = vt_ptr | (type_.t & vt_storage)
	type_.ref = s
}

fn is_compatible_types(type1 &CType, type2 &CType) bool {
	return compare_types(type1, type2, 0)
}

fn is_compatible_unqualified_types(type1 &CType, type2 &CType) bool {
	return compare_types(type1, type2, 1)
}

fn cast_error(st &CType, dt &CType) {
	type_incompatibility_error(st, dt, c"cannot convert '%s' to '%s'")
}

fn verify_assign_cast(dt &CType) {
	st := &CType(0)
	type1 := &CType(0)
	type2 := &CType(0)

	dbt := 0
	sbt := 0
	qualwarn := 0
	lvl := 0

	st = &vtop.type_
	dbt = dt.t & vt_btype
	sbt = st.t & vt_btype
	if dt.t & vt_constant {
		_tcc_warning('assignment of read-only location')
	}
	match dbt {
		0 { // case comp body kind=IfStmt is_enum=false
			if sbt != dbt {
				_tcc_error('assignment to void expression')
			}
		}
		5 { // case comp body kind=IfStmt is_enum=false
			if is_null_pointer(vtop) {
				return
			}
			if is_integer_btype(sbt) {
				_tcc_warning('assignment makes pointer from integer without a cast')
				return
			}
			type1 = pointed_type(dt)
			if sbt == 5 {
				type2 = pointed_type(st)
			} else if sbt == 6 {
				type2 = st
			} else { // 3
				unsafe {
					goto error
				}
			}
			if is_compatible_types(type1, type2) {
				return
			}
			qualwarn = 0
			for lvl = qualwarn; true; lvl++ {
				if (type2.t & 256 && !(type1.t & 256)) || (type2.t & 512 && !(type1.t & 512)) {
					qualwarn = 1
				}
				dbt = type1.t & (15 | 2048)
				sbt = type2.t & (15 | 2048)
				if dbt != vt_ptr || sbt != vt_ptr {
					return
				}
				type1 = pointed_type(type1)
				type2 = pointed_type(type2)
			}
			if !is_compatible_unqualified_types(type1, type2) {
				if (dbt == vt_void || sbt == vt_void) && lvl == 0 {
				} else if dbt == sbt && is_integer_btype(sbt & 15)
					&& int((type1.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) + int((type2.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) + !!((type1.t ^ type2.t) & 16) < 2 {
				} else {
					_tcc_warning('assignment from incompatible pointer type')
					return
				}
			}
			if qualwarn {
				tcc_state.warn_num = __offsetof(TCCState, warn_discarded_qualifiers) - __offsetof(TCCState, warn_none)
				_tcc_warning('assignment discards qualifiers from pointer target type')
			}
		}
		1, 2, 3, 4 {
			if sbt == vt_ptr || sbt == vt_func {
				_tcc_warning('assignment makes integer from pointer without a cast')
			} else if sbt == vt_struct {
				unsafe {
					goto case_VT_STRUCT
				}
			}
		}
		7 { // case comp body kind=LabelStmt is_enum=false
			// RRRREG case_VT_STRUCT id=0x7fffed47a4c8
			case_VT_STRUCT:
			if !is_compatible_unqualified_types(dt, st) {
				// RRRREG error id=0x7fffed477eb8
				error:
				cast_error(st, dt)
			}
		}
		else {}
	}
}

fn gen_assign_cast(dt &CType) {
	verify_assign_cast(dt)
	gen_cast(dt)
}

fn vstore() {
	sbt := 0
	dbt := 0
	ft := 0
	r := 0
	size := 0
	align := 0
	bit_size := 0
	bit_pos := 0
	delayed_cast := 0

	ft = vtop[-1].type_.t
	sbt = vtop.type_.t & 15
	dbt = ft & 15
	verify_assign_cast(&vtop[-1].type_)
	if sbt == 7 {
		size = type_size(&vtop.type_, &align)
		vpushv(unsafe { vtop - 1 })
		if vtop.r & 16384 {
			gbound()
		}
		vtop.type_.t = 5
		gaddrof()
		vswap()
		if vtop.r & 16384 {
			gbound()
		}
		vtop.type_.t = 5
		gaddrof()
		if 1 && !tcc_state.do_bounds_check {
			gen_struct_copy(size)
		} else {
			vpushi(size)
			vpush_helper_func(Tcc_token.tok_memmove)
			vrott(4)
			gfunc_call(3)
		}
	} else if ft & 128 {
		vdup()
		vtop[-1] = vtop[-2]
		bit_pos = ((ft >> 20) & 63)
		bit_size = ((ft >> (20 + 6)) & 63)
		vtop[-1].type_.t = ft & ~(((1 << (6 + 6)) - 1) << 20 | 128)
		if dbt == 11 {
			gen_cast(&vtop[-1].type_)
			vtop[-1].type_.t = (vtop[-1].type_.t & ~15) | (1 | 16)
		}
		r = adjust_bf(unsafe { vtop - 1 }, bit_pos, bit_size)
		if dbt != 11 {
			gen_cast(&vtop[-1].type_)
			dbt = vtop[-1].type_.t & 15
		}
		if r == 7 {
			store_packed_bf(bit_pos, bit_size)
		} else {
			mask := (1 << bit_size) - 1
			if dbt != 11 {
				if dbt == 4 {
					vpushll(mask)
				} else { // 3
					vpushi(u32(mask))
				}
				gen_op(`&`)
			}
			vpushi(bit_pos)
			gen_op(`<`)
			vswap()
			vdup()
			vrott(3)
			if dbt == 4 {
				vpushll(~(mask << bit_pos))
			} else { // 3
				vpushi(~(u32(mask) << bit_pos))
			}
			gen_op(`&`)
			gen_op(`|`)
			vstore()
			vpop()
		}
	} else if dbt == 0 {
		unsafe { vtop-- }
	} else {
		delayed_cast = 0
		if (dbt == 1 || dbt == 2) && is_integer_btype(sbt) {
			if vtop.r & 3072 && btype_size(dbt) > btype_size(sbt) {
				force_charshort_cast()
			}
			delayed_cast = 1
		} else {
			gen_cast(&vtop[-1].type_)
		}
		if vtop[-1].r & 16384 {
			vswap()
			gbound()
			vswap()
		}
		gv(rc_type(dbt))
		if delayed_cast {
			vtop.r |= (u32(((3072) & ~((3072) << 1))) * (int(sbt == 4) + 1))
			vtop.type_.t = ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
		}
		if (vtop[-1].r & vt_valmask) == vt_llocal {
			sv := SValue{}
			unsafe {
				r = get_reg(1)
				sv.type_.t = vt_ptrdiff_t
				sv.r = vt_local | vt_lval
				sv.c.i = vtop[-1].c.i
				vcc_trace_print('${@LOCATION} c.i=${sv.c.i}')
				load(r, &sv)
				vtop[-1].r = r | vt_lval
			}
		}
		r = vtop.r & vt_valmask
		if (r2_ret(dbt) != 48) {
			load_type := if (dbt == 14) { 9 } else { (2048 | 4) }
			vtop[-1].type_.t = load_type
			store(r, unsafe { vtop - 1 })
			vswap()
			incr_offset(8)
			vswap()
			store(vtop.r2, unsafe { vtop - 1 })
		} else {
			store(r, unsafe { vtop - 1 })
		}
		vswap()
		unsafe { vtop-- }
	}
}

fn inc(post int, c int) {
	test_lvalue()
	vdup()
	if post {
		gv_dup()
		vrotb(3)
		vrotb(3)
	}
	vpushi(c - 129)
	gen_op(`+`)
	vstore()
	if post {
		vpop()
	}
}

fn parse_mult_str(msg &char) &CString {
	if tok != 200 {
		expect(msg)
	}
	cstr_reset(&initstr)
	for tok == 200 {
		unsafe { cstr_cat(&initstr, tokc.str.data, -1) }
		next()
	}
	cstr_ccat(&initstr, `\x00`)
	return &initstr
}

fn exact_log2p1(i int) int {
	ret := 0
	if !i {
		return 0
	}
	for ret = 1; i >= 1 << 8; ret += 8 {
		i >>= 8
	}
	if i >= 1 << 4 {
		ret += 4
		i >>= 4
	}
	if i >= 1 << 2 {
		ret += 2
		i >>= 2
	}
	if i >= 1 << 1 {
		ret++
	}
	return ret
}

fn parse_attribute(ad &AttributeDef) {
	t := 0
	n := 0

	astr := &char(0)
	// RRRREG redo id=0x7fffed482e00
	redo:
	vcc_trace_print('${@LOCATION} parse_attr')
	if tok != Tcc_token.tok_attribute1 && tok != Tcc_token.tok_attribute2 {
		return
	}
	next()
	skip(`(`)
	skip(`(`)
	for tok != `)` {
		if tok < 256 {
			expect(c'attribute name')
		}
		t = tok
		next()
		match Tcc_token(t) {
			.tok_cleanup1, .tok_cleanup2 {
				{
					s := &Sym(0)
					skip(`(`)
					s = sym_find(tok)
					if !s {
						tcc_state.warn_num = __offsetof(TCCState, warn_implicit_function_declaration) - __offsetof(TCCState, warn_none)
						_tcc_warning("implicit declaration of function '${get_tok_str(tok,
							&tokc)}'")
						s = external_global_sym(tok, &func_old_type)
					} else if (s.type_.t & 15) != 6 {
						_tcc_error("'${get_tok_str(tok, &tokc)}' is not declared as function")
					}
					ad.cleanup_func = s
					next()
					skip(`)`)
				}
			}
			.tok_constructor1, .tok_constructor2 {
				ad.f.func_ctor = 1
			}
			.tok_destructor1, .tok_destructor2 {
				ad.f.func_dtor = 1
			}
			.tok_always_inline1, .tok_always_inline2 {
				ad.f.func_alwinl = 1
			}
			.tok_section1, .tok_section2 {
				skip(`(`)
				astr = parse_mult_str(c'section name').data
				ad.section = find_section(tcc_state, astr)
				skip(`)`)
			}
			.tok_alias1, .tok_alias2 {
				skip(`(`)
				astr = parse_mult_str(c'alias("target")').data
				ad.alias_target = tok_alloc_const(astr)
				skip(`)`)
			}
			.tok_visibility1, .tok_visibility2 {
				skip(`(`)
				astr = parse_mult_str(c'visibility("default|hidden|internal|protected")').data
				if !C.strcmp(astr, c'default') {
					ad.a.visibility = 0
				} else if !C.strcmp(astr, c'hidden') {
					ad.a.visibility = 2
				} else if !C.strcmp(astr, c'internal') {
					ad.a.visibility = 1
				} else if !C.strcmp(astr, c'protected') {
					ad.a.visibility = 3
				} else { // 3
					expect(c'visibility("default|hidden|internal|protected")')
				}
				skip(`)`)
			}
			.tok_aligned1, .tok_aligned2 {
				if tok == `(` {
					next()
					n = expr_const()
					if n <= 0 || (n & (n - 1)) != 0 {
						_tcc_error('alignment must be a positive power of two')
					}
					skip(`)`)
				} else {
					n = 16
				}
				ad.a.aligned = exact_log2p1(n)
				if n != 1 << (ad.a.aligned - 1) {
					_tcc_error('alignment of ${n} is larger than implemented')
				}
			}
			.tok_packed1, .tok_packed2 {
				ad.a.packed = 1
			}
			.tok_weak1, .tok_weak2 {
				ad.a.weak = 1
			}
			.tok_nodebug1, .tok_nodebug2 {
				ad.a.nodebug = 1
			}
			.tok_unused1, .tok_unused2 {}
			.tok_noreturn1, .tok_noreturn2 {
				ad.f.func_noreturn = 1
			}
			.tok_cdecl1, .tok_cdecl2, .tok_cdecl3 {
				ad.f.func_call = 0
			}
			.tok_stdcall1, .tok_stdcall2, .tok_stdcall3 {
				ad.f.func_call = 1
			}
			.tok_mode { // case comp body kind=CallExpr is_enum=true
				skip(`(`)
				match Tcc_token(tok) {
					.tok_mode_di { // case comp body kind=BinaryOperator is_enum=true
						ad.attr_mode = 4 + 1
					}
					.tok_mode_qi { // case comp body kind=BinaryOperator is_enum=true
						ad.attr_mode = 1 + 1
					}
					.tok_mode_hi { // case comp body kind=BinaryOperator is_enum=true
						ad.attr_mode = 2 + 1
					}
					.tok_mode_si, .tok_mode_word {
						ad.attr_mode = 3 + 1
					}
					else {
						_tcc_warning('__mode__(${get_tok_str(tok, (unsafe { nil }))}) not supported\n')
					}
				}
				next()
				skip(`)`)
			}
			.tok_dllexport { // case comp body kind=BinaryOperator is_enum=true
				ad.a.dllexport = 1
			}
			.tok_nodecorate { // case comp body kind=BinaryOperator is_enum=true
				ad.a.nodecorate = 1
			}
			.tok_dllimport { // case comp body kind=BinaryOperator is_enum=true
				ad.a.dllimport = 1
			}
			else {
				tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
				_tcc_warning("'${get_tok_str(t, (unsafe { nil }))}' attribute ignored")
				if tok == `(` {
					parenthesis := 0
					for {
						if tok == `(` {
							parenthesis++
						} else if tok == `)` {
							parenthesis--
						}
						next()
						// while()
						if !(parenthesis && tok != -1) {
							break
						}
					}
				}
			}
		}
		if tok != `,` {
			break
		}
		next()
	}
	skip(`)`)
	skip(`)`)
	unsafe {
		goto redo
	} // id: 0x7fffed482e00
}

fn find_field(type_ &CType, v int, cumofs &int) &Sym {
	s := type_.ref
	v1 := v | sym_field
	if !(v & sym_field) {
		if (type_.t & 15) != 7 {
			expect(c'struct or union')
		}
		if v < Tcc_token.tok_define {
			expect(c'field name')
		}
		if s.c < 0 {
			_tcc_error("dereferencing incomplete type '${get_tok_str(s.v & ~1073741824,
				unsafe { nil })}'")
		}
	}
	for {
		s = s.next
		if s == unsafe { nil } {
			break
		}
		if s.v == v1 {
			*cumofs = s.c
			return s
		}
		if (s.type_.t & 15) == 7 && s.v >= (sym_first_anom | sym_field) {
			ret := find_field(&s.type_, v1, cumofs)
			if ret {
				*cumofs += s.c
				return ret
			}
		}
	}
	if !(v & sym_field) {
		_tcc_error('field not found: ${get_tok_str(v, (unsafe { nil }))}')
	}
	return s
}

fn check_fields(type_ &CType, check int) {
	s := type_.ref
	for {
		s = s.next
		if s == (unsafe { nil }) {
			break
		}
		v := s.v & ~sym_field
		if v < sym_first_anom {
			ts := table_ident[v - 256]
			if check && ts.tok & sym_field {
				_tcc_error("duplicate member '${get_tok_str(v, (unsafe { nil }))}'")
			}
			ts.tok ^= sym_field
		} else if (s.type_.t & vt_btype) == vt_struct {
			check_fields(&s.type_, check)
		}
	}
}

fn struct_layout(type_ &CType, ad &AttributeDef) {
	size := 0
	align := 0
	maxalign := 0
	offset := 0
	c := 0
	bit_pos := 0
	bit_size := 0

	packed := 0
	a := 0
	bt := 0
	prevbt := 0
	prev_bit_size := 0

	pcc := !tcc_state.ms_bitfields
	pragma_pack := *tcc_state.pack_stack_ptr
	f := &Sym(0)
	maxalign = 1
	offset = 0
	c = 0
	bit_pos = 0
	prevbt = 7
	prev_bit_size = 0
	for f = type_.ref.next; f; f = f.next {
		if f.type_.t & 128 {
			bit_size = (((f.type_.t) >> (20 + 6)) & 63)
		} else { // 3
			bit_size = -1
		}
		size = type_size(&f.type_, &align)
		a = if f.a.aligned { 1 << (f.a.aligned - 1) } else { 0 }
		packed = 0
		if pcc && bit_size == 0 {
		} else {
			if pcc && (f.a.packed || ad.a.packed) {
				align = 1
				packed = align
			}
			if pragma_pack {
				packed = 1
				if pragma_pack < align {
					align = pragma_pack
				}
				if pcc && pragma_pack < a {
					a = 0
				}
			}
		}
		if a {
			align = a
		}
		if type_.ref.type_.t == (1 << 20 | 7) {
			if pcc && bit_size >= 0 {
				size = (bit_size + 7) >> 3
			}
			offset = 0
			if size > c {
				c = size
			}
		} else if bit_size < 0 {
			if pcc {
				c += (bit_pos + 7) >> 3
			}
			c = (c + align - 1) & -align
			offset = c
			if size > 0 {
				c += size
			}
			bit_pos = 0
			prevbt = 7
			prev_bit_size = 0
		} else {
			if pcc {
				if bit_size == 0 {
					// RRRREG new_field id=0x7fffed48fd90
					new_field:
					c = (c + ((bit_pos + 7) >> 3) + align - 1) & -align
					bit_pos = 0
				} else if f.a.aligned {
					unsafe {
						goto new_field
					} // id: 0x7fffed48fd90
				} else if !packed {
					a8 := align * 8
					ofs := ((c * 8 + bit_pos) % a8 + bit_size + a8 - 1) / a8
					if ofs > size / align {
						unsafe {
							goto new_field
						} // id: 0x7fffed48fd90
					}
				}
				if size == 8 && bit_size <= 32 {
					f.type_.t = (f.type_.t & ~15) | 3
					size = 4
				}
				for bit_pos >= align * 8 {
					c += align
					bit_pos -= align * 8
				}
				offset = c
				if f.v & 268435456 {
					align = 1
				}
			} else {
				bt = f.type_.t & 15
				if bit_pos + bit_size > size * 8 || (bit_size > 0) == (bt != prevbt) {
					c = (c + align - 1) & -align
					offset = c
					bit_pos = 0
					if bit_size || prev_bit_size {
						c += size
					}
				}
				if bit_size == 0 && prevbt != bt {
					align = 1
				}
				prevbt = bt
				prev_bit_size = bit_size
			}
			f.type_.t = (f.type_.t & ~(63 << 20)) | (bit_pos << 20)
			bit_pos += bit_size
		}
		if align > maxalign {
			maxalign = align
		}
		f.c = offset
		f.r = 0
	}
	if pcc {
		c += (bit_pos + 7) >> 3
	}
	a = if ad.a.aligned { 1 << (ad.a.aligned - 1) } else { 1 }
	bt = a
	if a < maxalign {
		a = maxalign
	}
	type_.ref.r = a
	if pragma_pack && pragma_pack < maxalign && 0 == pcc {
		a = pragma_pack
		if a < bt {
			a = bt
		}
	}
	c = (c + a - 1) & -a
	type_.ref.c = c
	for f = type_.ref.next; f; f = f.next {
		s := 0
		px := 0
		cx := 0
		c0 := 0

		t := CType{}
		if 0 == (f.type_.t & 128) {
			continue
		}
		f.type_.ref = f
		f.auxtype = -1
		bit_size = (((f.type_.t) >> (20 + 6)) & 63)
		if bit_size == 0 {
			continue
		}
		bit_pos = (((f.type_.t) >> 20) & 63)
		size = type_size(&f.type_, &align)
		if bit_pos + bit_size <= size * 8 && f.c + size <= c {
			continue
		}
		c0 = -1
		align = 1
		s = c0
		t.t = -1
		for ; true; {
			px = f.c * 8 + bit_pos
			cx = (px >> 3) & -align
			px = px - (cx << 3)
			if c0 == cx {
				break
			}
			s = (px + bit_size + 7) >> 3
			if s > 4 {
				t.t = 4
			} else if s > 2 {
				t.t = 3
			} else if s > 1 {
				t.t = 2
			} else {
				t.t = 1
			}
			s = type_size(&t, &align)
			c0 = cx
		}
		if px + bit_size <= s * 8 && cx + s <= c {
			f.c = cx
			bit_pos = px
			f.type_.t = (f.type_.t & ~(63 << 20)) | (bit_pos << 20)
			if s != size {
				f.auxtype = t.t
			}
		} else {
			f.auxtype = 7
		}
	}
}

fn struct_decl(type_ &CType, u int) {
	v := 0
	c := 0
	size := 0
	align := 0
	flexible := 0
	bit_size := 0
	bsize := 0
	bt := 0

	s := &Sym(0)
	ss := &Sym(0)
	ps := &&Sym(0)

	ad := AttributeDef{}
	ad1 := AttributeDef{}

	type1 := CType{}
	btype := CType{}

	unsafe { C.memset(&ad, 0, sizeof(ad)) }
	vcc_trace_print('${@LOCATION} struct_decl.1 tok=${tok}')
	next()
	vcc_trace_print('${@LOCATION} struct_decl.2 tok=${tok}')
	parse_attribute(&ad)
	if tok != `{` {
		v = tok
		next()
		vcc_trace_print('${@LOCATION} struct_decl.3 tok=${tok}')
		if v < 256 {
			expect(c'struct/union/enum name')
		}
		s = struct_find(v)
		if s && (s.sym_scope == local_scope || tok != `{`) {
			if u == s.type_.t {
				unsafe {
					goto do_decl
				}
			}
			if u == (2 << 20) && (s.type_.t & ((((1 << (6 + 6)) - 1) << 20) | 128)) == (2 << 20) {
				unsafe {
					goto do_decl
				}
			}
			_tcc_error("redefinition of '${get_tok_str(v, (unsafe { nil }))}'")
		}
	} else {
		v = anon_sym++
	}
	type1.t = if u == (2 << 20) { u | 3 | 16 } else { u }
	type1.ref = unsafe { nil }
	s = sym_push(v | sym_struct, &type1, 0, -1)
	s.r = 0
	// RRRREG do_decl id=0x7fffed4970e8
	do_decl:
	type_.t = s.type_.t
	type_.ref = s
	if tok == `{` {
		next()
		if s.c != -1 {
			_tcc_error('struct/union/enum already defined')
		}
		s.c = -2
		ps = &s.next
		if u == (2 << 20) {
			ll := i64(0)
			pl := i64(0)
			nl := i64(0)

			t := CType{}
			t.ref = s
			t.t = vt_int | vt_static | (3 << 20)
			for {
				v = tok
				if v < Tcc_token.tok_define {
					expect(c'identifier')
				}
				ss = sym_find(v)
				if ss && !local_stack {
					_tcc_error("redefinition of enumerator '${get_tok_str(v, (unsafe { nil }))}'")
				}
				next()
				vcc_trace_print('${@LOCATION} struct_decl.4 tok=${tok}')
				if tok == `=` {
					next()
					ll = expr_const64()
				}
				ss = sym_push(v, &t, vt_const, 0)
				ss.enum_val = ll
				*ps = ss
				ps = &ss.next
				if ll < nl {
					nl = ll
				}
				if ll > pl {
					pl = ll
				}
				if tok != `,` {
					break
				}
				next()
				vcc_trace_print('${@LOCATION} struct_decl.5 tok=${tok}')
				ll++
				if tok == `}` {
					break
				}
			}
			skip(`}`)
			t.t = vt_int
			if nl >= 0 {
				if pl != u32(pl) {
					t.t = (if 8 == 8 { vt_llong | vt_long } else { vt_llong })
				}
				t.t |= vt_unsigned
			} else if pl != int(pl) || nl != int(nl) {
				t.t = (if 8 == 8 { vt_llong | vt_long } else { vt_llong })
			}
			s.type_.t = t.t | (2 << 20)
			type_.t = s.type_.t
			s.c = 0
			for ss = s.next; ss; ss = ss.next {
				ll = ss.enum_val
				if ll == int(ll) {
					continue
				}
				if t.t & vt_unsigned {
					ss.type_.t |= vt_unsigned
					if ll == u32(ll) {
						continue
					}
				}
				ss.type_.t = (ss.type_.t & ~15) | (if 8 == 8 { 4 | 2048 } else { 4 })
			}
		} else {
			c = 0
			flexible = 0
			for tok != `}` {
				if !parse_btype(&btype, &ad1, 0) {
					if tok == Tcc_token.tok_static_assert {
						do_static_assert()
						continue
					}
					skip(`;`)
					continue
				}
				for {
					if flexible {
						_tcc_error("flexible array member '${get_tok_str(v, (unsafe { nil }))}' not at the end of struct")
					}
					bit_size = -1
					v = 0
					type1 = btype
					if tok != `:` {
						if tok != `;` {
							type_decl(&type1, &ad1, &v, 2)
						}
						if v == 0 {
							if (type1.t & vt_btype) != vt_struct {
								expect(c'identifier')
							} else {
								v = btype.ref.v
								if !(v & sym_field) && (v & ~sym_struct) < sym_first_anom {
									if tcc_state.ms_extensions == 0 {
										expect(c'identifier')
									}
								}
							}
						}
						if type_size(&type1, &align) < 0 {
							if u == vt_struct && type1.t & vt_array && c {
								flexible = 1
							} else { // 3
								_tcc_error("field '${get_tok_str(v, (unsafe { nil }))}' has incomplete type")
							}
						}
						if (type1.t & 15) == 6 || (type1.t & 15) == vt_void
							|| type1.t & (4096 | 8192 | 16384 | 32768) {
							_tcc_error("invalid type for '${get_tok_str(v, (unsafe { nil }))}'")
						}
					}
					if tok == `:` {
						next()
						bit_size = expr_const()
						if bit_size < 0 {
							_tcc_error("negative width in bit-field '${get_tok_str(v,
								(unsafe { nil }))}'")
						}
						if v && bit_size == 0 {
							_tcc_error("zero width for bit-field '${get_tok_str(v, (unsafe { nil }))}'")
						}
						parse_attribute(&ad1)
					}
					size = type_size(&type1, &align)
					if bit_size >= 0 {
						bt = type1.t & vt_btype
						if bt != 3 && bt != 1 && bt != 2 && bt != 11 && bt != 4 {
							_tcc_error('bitfields must have scalar type')
						}
						bsize = size * 8
						if bit_size > bsize {
							_tcc_error("width of '${get_tok_str(v, (unsafe { nil }))}' exceeds its type")
						} else if bit_size == bsize && !ad.a.packed && !ad1.a.packed {
							// no need for bit fields
						} else if bit_size == 64 {
							_tcc_error('field width 64 not implemented')
						} else {
							type1.t = (type1.t & ~((((1 << (6 + 6)) - 1) << 20) | 128)) | 128 | (bit_size << (
								20 + 6))
						}
					}
					if v != 0 || (type1.t & vt_btype) == vt_struct {
						c = 1
					}
					if v == 0 && ((type1.t & vt_btype) == vt_struct || bit_size >= 0) {
						v = anon_sym++
					}
					if v {
						ss = sym_push(v | sym_field, &type1, 0, 0)
						ss.a = ad1.a
						*ps = ss
						ps = &ss.next
					}
					if tok == `;` || tok == tok_eof {
						break
					}
					skip(`,`)
				}
				skip(`;`)
			}
			skip(`}`)
			parse_attribute(&ad)
			if ad.cleanup_func {
				_tcc_warning("attribute '__cleanup__' ignored on type")
			}
			check_fields(type_, 1)
			check_fields(type_, 0)
			struct_layout(type_, &ad)
			if debug_modes {
				tcc_debug_fix_anon(tcc_state, type_)
			}
		}
	}
}

fn sym_to_attr(ad &AttributeDef, s &Sym) {
	merge_symattr(&ad.a, &s.a)
	merge_funcattr(&ad.f, &s.f)
}

fn parse_btype_qualify(type_ &CType, qualifiers int) {
	vcc_trace_print('${@LOCATION} ${qualifiers}')
	for type_.t & vt_array {
		type_.ref = sym_push(sym_field, &type_.ref.type_, 0, type_.ref.c)
		type_ = &type_.ref.type_
	}
	type_.t |= qualifiers
}

fn parse_btype(type_ &CType, ad &AttributeDef, ignore_label int) int {
	vcc_trace('${@LOCATION}')
	t := 0
	u := 0
	bt := 0
	st := 0
	type_found := 0
	typespec_found := 0
	g := 0
	n := 0

	s := &Sym(0)
	type1 := CType{}

	vcc_trace_print('${@LOCATION} ${ignore_label}')
	unsafe { C.memset(ad, 0, sizeof(AttributeDef)) }
	t = vt_int
	bt = -1
	st = -1
	type_.ref = unsafe { nil }
	for {
		unsafe {
			vcc_trace_print('${@LOCATION} ${tok} ${file.truefilename.vstring()}')
		}
		match Tcc_token(tok) {
			.tok_extension { // case comp body kind=CallExpr is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				next()
				continue
			}
			.tok_char { // case comp body kind=BinaryOperator is_enum=true
				u = vt_byte
				basic_type:
				vcc_trace('${@LOCATION} ${tok}')
				next()
				basic_type1:
				if u == vt_short || u == vt_long {
					if st != -1 || (bt != -1 && bt != vt_int) {
						tmbt:
						_tcc_error('too many basic types')
					}
					st = u
				} else {
					if bt != -1 || (st != -1 && u != vt_int) {
						vcc_trace('${@LOCATION} ${tok}')
						unsafe {
							goto tmbt
						} // id: 0x7fffed4a2690
					}
					bt = u
				}
				if u != vt_int {
					t = (t & ~(vt_btype | vt_long)) | u
				}
				typespec_found = 1
			}
			.tok_void { // case comp body kind=BinaryOperator is_enum=true
				u = vt_void
				vcc_trace('${@LOCATION} ${tok}')
				unsafe {
					goto basic_type
				}
			}
			.tok_short { // case comp body kind=BinaryOperator is_enum=true
				u = vt_short
				vcc_trace('${@LOCATION} ${tok}')
				unsafe {
					goto basic_type
				}
			}
			.tok_int { // case comp body kind=BinaryOperator is_enum=true
				u = vt_int
				vcc_trace('${@LOCATION} ${tok}')
				unsafe {
					goto basic_type
				}
			}
			.tok_alignas {
				// case comp stmt
				n = 0
				ad1 := AttributeDef{}
				vcc_trace('${@LOCATION} ${tok}')
				next()
				vcc_trace('${@LOCATION} ${tok}')
				skip(`(`)
				vcc_trace('${@LOCATION} ${tok}')
				unsafe { C.memset(&ad1, 0, sizeof(AttributeDef)) }
				vcc_trace('${@LOCATION}')
				if parse_btype(&type1, &ad1, 0) {
					vcc_trace('${@LOCATION} ${tok}')
					type_decl(&type1, &ad1, &n, 1)
					if ad1.a.aligned {
						n = 1 << (ad1.a.aligned - 1)
					} else { // 3
						vcc_trace('${@LOCATION} ${tok}')
						type_size(&type1, &n)
					}
				} else {
					vcc_trace('${@LOCATION} ${tok}')
					n = expr_const()
					if n < 0 || (n & (n - 1)) != 0 {
						_tcc_error('alignment must be a positive power of two')
					}
				}
				vcc_trace('${@LOCATION} ${tok}')
				skip(`)`)
				vcc_trace('${@LOCATION} ${tok}')
				ad.a.aligned = exact_log2p1(n)
				continue
			}
			.tok_long { // case comp body kind=IfStmt is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				if (t & vt_btype) == vt_ldouble {
					t = (t & ~(vt_btype | vt_long)) | vt_ldouble
				} else if (t & (vt_btype | vt_long)) == vt_long {
					t = (t & ~(vt_btype | vt_long)) | vt_llong
				} else {
					u = vt_long
					unsafe {
						goto basic_type
					} // id: 0x7fffed4a2258
				}
				next()
			}
			.tok_bool { // case comp body kind=BinaryOperator is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				u = vt_bool
				unsafe {
					goto basic_type
				} // id: 0x7fffed4a2258
			}
			.tok_complex { // case comp body kind=CallExpr is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				_tcc_error('_Complex is not yet supported')
			}
			.tok_float { // case comp body kind=BinaryOperator is_enum=
				vcc_trace('${@LOCATION} ${tok}')
				u = vt_float
				unsafe {
					goto basic_type
				} // id: 0x7fffed4a2258
			}
			.tok_double { // case comp body kind=IfStmt is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				if (t & (vt_btype | vt_long)) == vt_long {
					t = (t & ~(vt_btype | vt_long)) | vt_ldouble
				} else {
					u = vt_double
					unsafe {
						goto basic_type
					} // id: 0x7fffed4a2258
				}
				next()
			}
			.tok_enum { // case comp body kind=CallExpr is_enum=true
				vcc_trace_print('${@LOCATION} enum tok=${tok}')
				struct_decl(&type1, vt_enum)
				basic_type2:
				vcc_trace('${@LOCATION} ${tok}')
				u = type1.t
				type_.ref = type1.ref
				unsafe {
					goto basic_type1
				}
			}
			.tok_struct { // case comp body kind=CallExpr is_enum=true
				vcc_trace_print('${@LOCATION} struct tok=${tok}')
				struct_decl(&type1, vt_struct)
				unsafe {
					goto basic_type2
				}
			}
			.tok_union { // case comp body kind=CallExpr is_enum=true
				vcc_trace_print('${@LOCATION} union tok=${tok}')
				struct_decl(&type1, vt_union)
				unsafe {
					goto basic_type2
				}
			}
			.tok__atomic { // case comp body kind=CallExpr is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				next()
				type_.t = t
				vcc_trace('${@LOCATION} ${tok}')
				parse_btype_qualify(type_, vt_atomic)
				vcc_trace('${@LOCATION} ${tok}')
				t = type_.t
				if tok == `(` {
					vcc_trace('${@LOCATION} ${tok}')
					parse_expr_type(&type1)
					vcc_trace('${@LOCATION} ${tok}')
					type1.t &= ~(vt_storage & ~vt_typedef)
					if type1.ref {
						vcc_trace('${@LOCATION} ${tok}')
						sym_to_attr(ad, type1.ref)
					}
					vcc_trace('${@LOCATION} ${tok}')
					unsafe {
						goto basic_type2
					}
				}
			}
			.tok_const1, .tok_const2, .tok_const3 {
				type_.t = t
				parse_btype_qualify(type_, vt_constant)
				t = type_.t
				next()
				vcc_trace('${@LOCATION} ${tok}')
			}
			.tok_volatile1, .tok_volatile2, .tok_volatile3 {
				vcc_trace('${@LOCATION} ${tok}')
				type_.t = t
				parse_btype_qualify(type_, vt_volatile)
				t = type_.t
				next()
				vcc_trace('${@LOCATION} ${tok}')
			}
			.tok_signed1, .tok_signed2, .tok_signed3 {
				vcc_trace('${@LOCATION} ${tok}')
				if (t & (vt_defsign | vt_unsigned)) == (vt_defsign | vt_unsigned) {
					_tcc_error('signed and unsigned modifier')
				}
				t |= vt_defsign
				next()
				typespec_found = 1
			}
			.tok_register, .tok_auto, .tok_restrict1, .tok_restrict2, .tok_restrict3 {
				vcc_trace('${@LOCATION} ${tok}')
				next()
			}
			.tok_unsigned { // case comp body kind=IfStmt is_enum=true
				if (t & (vt_defsign | vt_unsigned)) == vt_defsign {
					_tcc_error('signed and unsigned modifier')
				}
				vcc_trace('${@LOCATION} ${tok}')
				t |= vt_defsign | vt_unsigned
				next()
				typespec_found = 1
			}
			.tok_extern { // case comp body kind=BinaryOperator is_enum=true
				g = vt_extern
				vcc_trace('${@LOCATION} ${tok}')
				unsafe {
					goto storage
				} // id: 0x7fffed4a8020
			}
			.tok_static { // case comp body kind=BinaryOperator is_enum=true
				g = vt_static
				vcc_trace('${@LOCATION} ${tok}')
				unsafe {
					goto storage
				} // id: 0x7fffed4a8020
			}
			.tok_typedef { // case comp body kind=BinaryOperator is_enum=true
				g = vt_typedef
				vcc_trace('${@LOCATION} ${tok}')
				unsafe {
					goto storage
				} // id: 0x7fffed4a8020
				// RRRREG storage id=0x7fffed4a8020
				storage:
				vcc_trace('${@LOCATION} ${tok}')
				if t & (vt_extern | vt_static | vt_typedef) & ~g {
					_tcc_error('multiple storage classes')
				}
				t |= g
				vcc_trace('${@LOCATION} ${tok}')
				next()
				vcc_trace('${@LOCATION} ${tok}')
			}
			.tok_inline1, .tok_inline2, .tok_inline3 {
				t |= vt_inline
				vcc_trace('${@LOCATION} ${tok}')
				next()
				vcc_trace('${@LOCATION} ${tok}')
			}
			.tok_noreturn3 { // case comp body kind=CallExpr is_enum=true
				vcc_trace('${@LOCATION} ${tok}')
				next()
				vcc_trace('${@LOCATION} ${tok}')
				ad.f.func_noreturn = 1
			}
			.tok_attribute1, .tok_attribute2 {
				parse_attribute(ad)
				if ad.attr_mode {
					u = ad.attr_mode - 1
					t = (t & ~(vt_btype | vt_long)) | u
				}
				continue
			}
			.tok_typeof1, .tok_typeof2, .tok_typeof3 {
				vcc_trace('${@LOCATION} ${tok}')
				next()
				vcc_trace('${@LOCATION} ${tok}')
				parse_expr_type(&type1)
				vcc_trace('${@LOCATION} ${tok}')
				type1.t &= ~(vt_storage & ~vt_typedef)
				if type1.ref {
					vcc_trace('${@LOCATION} ${tok}')
					sym_to_attr(ad, type1.ref)
					vcc_trace('${@LOCATION} ${tok}')
				}
				unsafe {
					goto basic_type2
				} // id: 0x7fffed4a4fc8
			}
			.tok_thread_local { // case comp body kind=CallExpr is_enum=true
				_tcc_error('_Thread_local is not implemented')
			}
			else {
				vcc_trace_print('${@LOCATION} - default ${tok}')
				if typespec_found {
					vcc_trace_print('${@LOCATION} typespec_found')
					unsafe {
						goto the_end
					} // id: 0x7fffed4a9550
				}
				vcc_trace('${@LOCATION} ${rune(tok)}')
				s = sym_find(tok)
				vcc_trace('${@LOCATION}')
				if s == unsafe { nil } || !(s.type_.t & vt_typedef) {
					vcc_trace_print('${@LOCATION} goto the_end')
					unsafe {
						goto the_end
					}
				}
				n = tok
				vcc_trace('${@LOCATION}')
				next()
				vcc_trace('${@LOCATION}')
				if (tok == `:` && ignore_label) {
					// ignore if it's a label
					unget_tok(n)
					unsafe {
						goto the_end
					}
				}

				t &= ~(vt_btype | vt_long)
				u = t & ~(vt_constant | vt_volatile)
				t ^= u
				type_.t = (s.type_.t & ~vt_typedef) | u
				type_.ref = s.type_.ref
				vcc_trace_print('${@LOCATION} ${t} ${u}')
				if t {
					vcc_trace_print('${@LOCATION}')
					parse_btype_qualify(type_, t)
				}
				t = type_.t
				// get attributes from typedef
				sym_to_attr(ad, s)
				typespec_found = 1
				st = -2
				bt = -2
			}
		}
		type_found = 1
	}
	the_end:
	vcc_trace_print('${@LOCATION} the_end - ${tok}')
	if tcc_state.char_is_unsigned {
		if (t & (vt_defsign | vt_btype)) == vt_byte {
			t |= vt_unsigned
		}
	}
	bt = t & (vt_btype | vt_long)
	if bt == vt_long {
		t |= if 8 == 8 { vt_llong } else { vt_int }
	}
	type_.t = t
	return type_found
}

fn convert_parameter_type(pt &CType) {
	pt.t &= ~(vt_constant | vt_volatile)
	pt.t &= ~(vt_array | vt_vla)
	if (pt.t & vt_btype) == vt_func {
		mk_pointer(pt)
	}
}

fn parse_asm_str() &CString {
	skip(`(`)
	return parse_mult_str(c'string constant')
}

fn asm_label_instr() int {
	v := 0
	astr := &char(0)
	next()
	astr = parse_asm_str().data
	skip(`)`)
	v = tok_alloc_const(astr)
	return v
}

fn post_type(type_ &CType, ad &AttributeDef, storage int, td int) int {
	n := 0
	l := 0
	t1 := 0
	arg_size := 0
	align := 0
	plast := &&Sym(0)
	s := &Sym(0)
	first := &Sym(0)
	ad1 := AttributeDef{}
	pt := CType{}
	vla_array_tok := &TokenString(unsafe { nil })
	vla_array_str := &int(0)

	if tok == `(` {
		vcc_trace_print('${@LOCATION} post.1')
		next()
		if 2 == (td & (2 | 1)) {
			vcc_trace_print('${@LOCATION} post.2')
			return 0
		}
		vcc_trace('${@LOCATION}')
		if tok == `)` {
			l = 0
			vcc_trace_print('${@LOCATION} post.3')
		} else if parse_btype(&pt, &ad1, 0) {
			l = func_new
			vcc_trace_print('${@LOCATION} post.4')
		} else if td & (2 | 1) {
			merge_attr(ad, &ad1)
			vcc_trace_print('${@LOCATION} post.5')
			return 0
		} else { // 3
			l = func_old
			vcc_trace_print('${@LOCATION} post.6')
		}
		first = unsafe { nil }
		plast = &first
		arg_size = 0
		local_scope++
		if l {
			vcc_trace_print('${@LOCATION} post.7 local_scope=${local_scope}')
			for {
				if l != func_old {
					if (pt.t & vt_btype) == vt_void && tok == `)` {
						break
					}
					type_decl(&pt, &ad1, &n, 2 | 1 | 4)
					if (pt.t & vt_btype) == vt_void {
						_tcc_error('parameter declared as void')
					}
					if n == 0 {
						n = sym_field
					}
					vcc_trace_print('${@LOCATION} n=${n}')
				} else {
					n = tok
					pt.t = vt_void
					pt.ref = unsafe { nil }
					next()
				}
				if n < Tcc_token.tok_define {
					expect(c'identifier')
				}
				convert_parameter_type(&pt)
				arg_size += (type_size(&pt, &align) + ptr_size - 1) / ptr_size
				s = sym_push(n, &pt, vt_local | vt_lval, 0)
				*plast = s
				plast = &s.next
				if tok == `)` {
					break
				}
				skip(`,`)
				if l == func_new && tok == 161 {
					l = func_ellipsis
					next()
					break
				}
				vcc_trace('${@LOCATION}')
				if l == func_new && !parse_btype(&pt, &ad1, 0) {
					_tcc_error('invalid type')
				}
			}
		} else { // 3
			l = func_old
		}
		skip(`)`)
		if first != unsafe { nil } {
			sym_pop(if local_stack { &local_stack } else { &global_stack }, first.prev,
				1)
			for s = first; s; s = s.next {
				s.v |= sym_field
				vcc_trace_print('${@LOCATION}')
			}
		}
		local_scope--
		type_.t &= ~vt_constant
		if tok == `[` {
			next()
			skip(`]`)
			mk_pointer(type_)
		}
		ad.f.func_args = arg_size
		ad.f.func_type = l
		s = sym_push(sym_field, type_, 0, 0)
		s.a = ad.a
		s.f = ad.f
		s.next = first
		type_.t = vt_func
		type_.ref = s
		vcc_trace_print('${@LOCATION} vt_func')
	} else if tok == `[` {
		saved_nocode_wanted := nocode_wanted
		vcc_trace_print('${@LOCATION} arraydef.0 ${nocode_wanted}')
		next()
		n = -1
		t1 = 0
		if td & 4 {
			for {
				match tok {
					int(Tcc_token.tok_restrict1), int(Tcc_token.tok_restrict2),
					int(Tcc_token.tok_restrict3), int(Tcc_token.tok_const1),
					int(Tcc_token.tok_volatile1), int(Tcc_token.tok_static), int(`*`) {
						next()
						continue
					}
					else {}
				}
				if tok != `]` {
					nocode_wanted = 1
					vcc_trace_print('${@LOCATION} arraydef.1 ${nocode_wanted}')
					skip_or_save_block(&vla_array_tok)
					unget_tok(0)
					vla_array_str = vla_array_tok.str
					begin_macro(vla_array_tok, 2)
					next()
					gexpr()
					end_macro()
					next()
					unsafe {
						goto check
					}
				}
				break
			}
		} else if tok != `]` {
			if local_stack == unsafe { nil } || storage & vt_static {
				vpushi(expr_const())
			} else {
				vcc_trace_print('${@LOCATION} before gexpr')
				nocode_wanted = 0
				gexpr()
			}
			// RRRREG check id=0x7fffed4b0ba0
			check:
			if (vtop.r & (63 | 256 | 512)) == 48 {
				unsafe {
					n = vtop.c.i
				}
				if n < 0 {
					_tcc_error('invalid array size')
				}
			} else {
				if !is_integer_btype(vtop.type_.t & 15) {
					_tcc_error('size of variable length array should be an integer')
				}
				n = 0
				t1 = vt_vla
			}
		}
		skip(`]`)
		post_type(type_, ad, storage, (td & ~(2 | 1)) | type_nest)
		if (type_.t & vt_btype) == vt_func {
			_tcc_error('declaration of an array of functions')
		}
		if (type_.t & vt_btype) == vt_void || type_size(type_, &align) < 0 {
			_tcc_error('declaration of an array of incomplete type elements')
		}
		t1 |= type_.t & vt_vla
		if t1 & vt_vla {
			if n < 0 {
				if td & type_nest {
					_tcc_error('need explicit inner array size in VLAs')
				}
			} else {
				loc -= type_size(&int_type, &align)
				loc &= -align
				n = loc
				vpush_type_size(type_, &align)
				gen_op(`*`)
				vset(&int_type, vt_local | vt_lval, n)
				vswap()
				vstore()
			}
		}
		if n != -1 {
			vpop()
		}
		nocode_wanted = saved_nocode_wanted
		vcc_trace_print('${@LOCATION} arraydef.2 ${nocode_wanted}')
		s = sym_push(sym_field, type_, 0, n)
		type_.t = (if t1 { vt_vla } else { vt_array }) | vt_ptr
		type_.ref = s
		if vla_array_str {
			if t1 & vt_vla && td & type_nest {
				s.vla_array_str = vla_array_str
			} else { // 3
				tok_str_free_str(vla_array_str)
			}
		}
	}
	return 1
}

fn type_decl(type_ &CType, ad &AttributeDef, v &int, td int) &CType {
	post := &CType(0)
	ret := &CType(0)

	qualifiers := 0
	storage := 0

	storage = type_.t & vt_storage
	type_.t &= ~vt_storage
	post = type_
	ret = post
	for tok == `*` {
		qualifiers = 0
		// RRRREG redo id=0x7fffed4b4180
		redo:
		next()
		match Tcc_token(tok) {
			.tok__atomic { // case comp body kind=CompoundAssignOperator is_enum=true
				qualifiers |= vt_atomic
				unsafe {
					goto redo
				} // id: 0x7fffed4b4180
			}
			.tok_const1, .tok_const2, .tok_const3 {
				qualifiers |= vt_constant
				unsafe {
					goto redo
				} // id: 0x7fffed4b4180
			}
			.tok_volatile1, .tok_volatile2, .tok_volatile3 {
				qualifiers |= vt_volatile
				unsafe {
					goto redo
				} // id: 0x7fffed4b4180
			}
			.tok_restrict1, .tok_restrict2, .tok_restrict3 {
				unsafe {
					goto redo
				} // id: 0x7fffed4b4180
			}
			.tok_attribute1, .tok_attribute2 {
				parse_attribute(ad)
			}
			else {}
		}
		mk_pointer(type_)
		type_.t |= qualifiers
		if voidptr(ret) == voidptr(type_) {
			ret = pointed_type(type_)
		}
	}
	if tok == `(` {
		if !post_type(type_, ad, 0, td) {
			vcc_trace_print('${@LOCATION} funcarg')
			parse_attribute(ad)
			post = type_decl(type_, ad, v, td)
			skip(`)`)
		} else { // 3
			unsafe {
				goto abstract
			} // id: 0x7fffed4b5160
		}
	} else if tok >= 256 && td & 2 {
		*v = tok
		vcc_trace_print('${@LOCATION} ${tok}')
		next()
	} else {
		// RRRREG abstract id=0x7fffed4b5160
		abstract:
		vcc_trace_print('${@LOCATION}')
		if !(td & 1) {
			expect(c'identifier')
		}
		*v = 0
	}
	vcc_trace_print('${@LOCATION} end')
	post_type(post, ad, if voidptr(post) != voidptr(ret) { 0 } else { storage }, td & ~(2 | 1))
	parse_attribute(ad)
	type_.t |= storage
	vcc_trace_print('${@LOCATION} - ${storage}')
	return ret
}

fn indir() {
	if (vtop.type_.t & 15) != 5 {
		if (vtop.type_.t & 15) == 6 {
			return
		}
		expect(c'pointer')
	}
	if vtop.r & 256 {
		gv(1)
	}
	vtop.type_ = *pointed_type(&vtop.type_)
	if !(vtop.type_.t & (64 | 1024)) && (vtop.type_.t & 15) != 6 {
		vtop.r |= 256
		if tcc_state.do_bounds_check {
			vtop.r |= 16384
		}
	}
}

fn gfunc_param_typed(func &Sym, arg &Sym) {
	func_type := 0
	type_ := CType{}
	func_type = func.f.func_type
	if func_type == 2 || (func_type == 3 && arg == (unsafe { nil })) {
		if (vtop.type_.t & 15) == 8 {
			gen_cast_s(9)
		} else if vtop.type_.t & 128 {
			type_.t = vtop.type_.t & (15 | 16)
			type_.ref = vtop.type_.ref
			gen_cast(&type_)
		} else if vtop.r & 3072 {
			force_charshort_cast()
		}
	} else if arg == (unsafe { nil }) {
		_tcc_error('too many arguments to function')
	} else {
		type_ = arg.type_
		type_.t &= ~256
		gen_assign_cast(&type_)
	}
}

fn expr_type(type_ &CType, expr_fn fn ()) {
	vcc_trace_print('${@LOCATION}')
	nocode_wanted++
	expr_fn()
	*type_ = vtop.type_
	vpop()
	nocode_wanted--
}

fn parse_expr_type(type_ &CType) {
	vcc_trace('${@LOCATION}')
	n := 0
	ad := AttributeDef{}
	skip(`(`)
	if parse_btype(type_, &ad, 0) {
		type_decl(type_, &ad, &n, type_abstract)
	} else {
		expr_type(type_, gexpr)
	}
	skip(`)`)
}

fn parse_type(type_ &CType) {
	vcc_trace('${@LOCATION}')
	ad := AttributeDef{}
	n := 0
	if !parse_btype(type_, &ad, 0) {
		expect(c'type')
	}
	type_decl(type_, &ad, &n, 1)
}

fn parse_builtin_params(nc int, args &char) {
	c := char(0)
	sep := `(`

	type_ := CType{}

	vcc_trace_print('${@LOCATION}')

	if nc {
		nocode_wanted++
	}
	next()
	if *args == 0 {
		skip(sep)
	}
	for {
		c = unsafe { *args++ }
		if !c {
			break
		}
		skip(sep)
		sep = `,`
		if c == `t` {
			parse_type(&type_)
			vpush(&type_)
			continue
		}
		expr_eq()
		type_.ref = (unsafe { nil })
		type_.t = 0
		match rune(c) {
			`e` { // case comp body kind=ContinueStmt is_enum=true
				continue
			}
			`V` { // case comp body kind=BinaryOperator is_enum=true
				type_.t = 256
			}
			`v` { // case comp body kind=CompoundAssignOperator is_enum=true
				type_.t |= 0
				mk_pointer(&type_)
			}
			`S` { // case comp body kind=BinaryOperator is_enum=true
				type_.t = 256
			}
			`s` { // case comp body kind=CompoundAssignOperator is_enum=true
				type_.t |= char_type.t
				mk_pointer(&type_)
			}
			`i` { // case comp body kind=BinaryOperator is_enum=true
				type_.t = 3
			}
			`l` { // case comp body kind=BinaryOperator is_enum=true
				type_.t = (2048 | 4 | 16)
			}
			else {}
		}
		gen_assign_cast(&type_)
	}
	skip(`)`)
	if nc {
		nocode_wanted--
	}
}

fn parse_atomic(atok int) {
	size := 0
	align := 0
	arg := 0
	t := 0
	save := 0

	atom := &CType(0)
	atom_ptr := &CType(0)
	ct := CType{
		t: 0
	}

	store := SValue{}
	buf := [40]char{}
	templates := [c'alm.?', c'Asm.v', c'alsm.v', c'aplbmm.b', c'avm.v', c'avm.v', c'avm.v', c'avm.v',
		c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v']!

	template := templates[(atok - int(Tcc_token.tok___atomic_store))]

	vcc_trace_print('${@LOCATION}')

	atom = (unsafe { nil })
	atom_ptr = atom
	size = 0
	next()
	skip(`(`)
	for arg = 0; true; {
		expr_eq()
		match template[arg] {
			`a`, `A` {
				atom_ptr = &vtop.type_
				if (atom_ptr.t & 15) != 5 {
					expect(c'pointer')
				}
				atom = pointed_type(atom_ptr)
				size = type_size(atom, &align)
				if size > 8 || size & (size - 1)
					|| (atok > Tcc_token.tok___atomic_compare_exchange
					&& (0 == btype_size(atom.t & 15) || (atom.t & 15) == 5)) {
					expect(c'integral or integer-sized pointer target type')
				}
			}
			`p` { // case comp body kind=IfStmt is_enum=true
				if (vtop.type_.t & 15) != 5 || type_size(pointed_type(&vtop.type_), &align) != size {
					_tcc_error('pointer target type mismatch in argument ${arg + 1}')
				}
				gen_assign_cast(atom_ptr)
			}
			`v` { // case comp body kind=CallExpr is_enum=true
				gen_assign_cast(atom)
			}
			`l` { // case comp body kind=CallExpr is_enum=true
				indir()
				gen_assign_cast(atom)
			}
			`s` { // case comp body kind=BinaryOperator is_enum=true
				save = 1
				indir()
				store = *vtop
				vpop()
			}
			`m` { // case comp body kind=CallExpr is_enum=true
				gen_assign_cast(&int_type)
			}
			`b` { // case comp body kind=BinaryOperator is_enum=true
				ct.t = 11
				gen_assign_cast(&ct)
			}
			else {}
		}
		if `.` == template[arg++ + 1] {
			break
		}
		skip(`,`)
	}
	skip(`)`)
	ct.t = 0
	match template[arg + 1] {
		`b` { // case comp body kind=BinaryOperator is_enum=true
			ct.t = 11
		}
		`v` { // case comp body kind=BinaryOperator is_enum=true
			ct = *atom
		}
		else {}
	}
	unsafe { C.sprintf(buf, c'%s_%d', get_tok_str(atok, nil), size) }
	vpush_helper_func(tok_alloc_const(buf))
	vrott(arg - save + 1)
	gfunc_call(arg - save)
	vpush(&ct)
	put_r_ret(vtop, ct.t)
	t = ct.t & 15
	if t == 1 || t == 2 || t == 11 {
		vtop.r |= (u32(((3072) & ~((3072) << 1))) * (1))
	}
	gen_cast(&ct)
	if save {
		vpush(&ct)
		*vtop = store
		vswap()
		vstore()
	}
}

fn unary() {
	n := 0
	t := 0
	align := 0
	size := 0
	r := 0

	type_ := CType{}
	s := &Sym(0)
	ad := AttributeDef{}
	if debug_modes {
		tcc_debug_line(tcc_state)
		tcc_tcov_check_line(tcc_state, 1)
	}
	type_.ref = unsafe { nil }
	// RRRREG tok_next id=0x7fffed4bf938
	tok_next:
	vcc_trace_print('${@LOCATION} - tok=${tok}')
	match tok {
		int(Tcc_token.tok_extension) { // case comp body kind=CallExpr is_enum=true
			next()
			unsafe {
				goto tok_next
			} // id: 0x7fffed4bf938
		}
		193, 194, 192 {
			t = 3
			// RRRREG push_tokc id=0x7fffed4bfbc8
			push_tokc:
			vcc_trace_print('${@LOCATION} - unary.2 tok=${tok}')
			type_.t = t
			vsetc(&type_, vt_const, &tokc)
			next()
		}
		195 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_int | vt_unsigned
			unsafe {
				goto push_tokc
			}
		}
		196 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_llong
			unsafe {
				goto push_tokc
			}
		}
		197 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_llong | vt_unsigned
			unsafe {
				goto push_tokc
			}
		}
		202 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_float
			unsafe {
				goto push_tokc
			}
		}
		203 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_double
			unsafe {
				goto push_tokc
			}
		}
		204 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_ldouble
			unsafe {
				goto push_tokc
			}
		}
		198 { // case comp body kind=BinaryOperator is_enum=true
			t = (if 8 == 8 { vt_llong } else { vt_int }) | vt_long
			vcc_trace_print('${@LOCATION} unary.3 t=${t}')
			unsafe {
				goto push_tokc
			}
		}
		199 { // case comp body kind=BinaryOperator is_enum=true
			t = (if 8 == 8 { vt_llong } else { vt_int }) | vt_long | vt_unsigned
			unsafe {
				goto push_tokc
			}
		}
		int(Tcc_token.tok___function__) { // case comp body kind=IfStmt is_enum=true
			if !tcc_state.gnu_ext {
				unsafe {
					goto tok_identifier
				}
			}
		}
		int(Tcc_token.tok___func__) { // case comp body kind=BinaryOperator is_enum=true
			tok = 200
			cstr_reset(&tokcstr)
			cstr_cat(&tokcstr, funcname, 0)
			unsafe {
				tokc.str.size = tokcstr.size
				tokc.str.data = tokcstr.data
			}
			unsafe {
				goto case_TOK_STR
			}
		}
		201 { // case comp body kind=BinaryOperator is_enum=true
			t = vt_int
			unsafe {
				goto str_init
			}
		}
		200 { // case comp body kind=LabelStmt is_enum=true
			// RRRREG case_TOK_STR id=0x7fffed4c0d38
			case_TOK_STR:
			t = char_type.t
			// RRRREG str_init id=0x7fffed4c0e60
			str_init:
			vcc_trace_print('${@LOCATION} 200')
			if tcc_state.warn_write_strings & 1 {
				t |= vt_constant
			}
			type_.t = t
			mk_pointer(&type_)
			type_.t |= vt_array
			C.memset(&ad, 0, sizeof(AttributeDef))
			ad.section = tcc_state.rodata_section
			vcc_trace_print('${@LOCATION} 200.1')
			decl_initializer_alloc(&type_, &ad, vt_const, 2, 0, 0)
		}
		167, int(`(`) {
			t = tok
			next()
			if parse_btype(&type_, &ad, 0) {
				vcc_trace_print('${@LOCATION} abstract')
				type_decl(&type_, &ad, &n, 1)
				skip(`)`)
				if tok == `{` {
					if global_expr {
						r = 48
					} else { // 3
						r = 50
					}
					vcc_trace_print('${@LOCATION} r=${r}')
					if !(type_.t & vt_array) {
						r |= vt_lval
					}
					C.memset(&ad, 0, sizeof(AttributeDef))
					decl_initializer_alloc(&type_, &ad, r, 1, 0, 0)
				} else if t == 167 {
					vpush(&type_)
					return
				} else {
					vcc_trace_print('${@LOCATION} unary.6 tok=${tok}')
					unary()
					vcc_trace_print('${@LOCATION} unary.7 tok=${tok}')
					gen_cast(&type_)
				}
			} else if tok == `{` {
				saved_nocode_wanted := nocode_wanted
				if nocode_wanted & CONST_WANTED_MASK && !(nocode_wanted & NOEVAL_MASK) {
					expect(c'constant')
				}
				if 0 == local_scope {
					_tcc_error('statement expression outside of function')
				}
				save_regs(0)
				block(1)
				if saved_nocode_wanted {
					nocode_wanted = saved_nocode_wanted
				}
				skip(`)`)
			} else {
				vcc_trace_print('${@LOCATION} unary.8 tok=${tok}')
				gexpr()
				skip(`)`)
			}
		}
		int(`*`) { // case comp body kind=CallExpr is_enum=true
			vcc_trace_print('${@LOCATION} asterisk')
			next()
			unary()
			indir()
		}
		int(`&`) { // case comp body kind=CallExpr is_enum=true
			vcc_trace_print('${@LOCATION} amp')
			next()
			unary()
			if (vtop.type_.t & vt_btype) != vt_func && !(vtop.type_.t & (vt_array | vt_vla)) {
				test_lvalue()
			}
			if vtop.sym {
				vtop.sym.a.addrtaken = 1
			}
			mk_pointer(&vtop.type_)
			gaddrof()
		}
		int(`!`) { // case comp body kind=CallExpr is_enum=true
			next()
			vcc_trace_print('${@LOCATION} unary.20 tok=${tok}')
			unary()
			gen_test_zero(148)
		}
		int(`~`) { // case comp body kind=CallExpr is_enum=true
			next()
			vcc_trace_print('${@LOCATION} unary.~ tok=${tok}')
			unary()
			vpushi(-1)
			gen_op(`^`)
		}
		int(`+`) { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			if (vtop.type_.t & vt_btype) == vt_ptr {
				_tcc_error('pointer not accepted for unary plus')
			}
			if !is_float(vtop.type_.t) {
				vpushi(0)
				gen_op(`+`)
			}
		}
		int(Tcc_token.tok_sizeof), int(Tcc_token.tok_alignof1), int(Tcc_token.tok_alignof2),
		int(Tcc_token.tok_alignof3) {
			t = tok
			next()
			if tok == `(` {
				tok = 167
			}
			expr_type(&type_, unary)
			if t == Tcc_token.tok_sizeof {
				vpush_type_size(&type_, &align)
				gen_cast_s((2048 | 4 | 16))
			} else {
				type_size(&type_, &align)
				s = unsafe { nil }
				if vtop[1].r & vt_sym {
					s = vtop[1].sym
				}
				if s != unsafe { nil } && s.a.aligned {
					align = 1 << (s.a.aligned - 1)
				}
				vpushs(align)
			}
		}
		int(Tcc_token.tok_builtin_expect) { // case comp body kind=CallExpr is_enum=true
			parse_builtin_params(0, c'ee')
			vpop()
		}
		int(Tcc_token.tok_builtin_types_compatible_p) { // case comp body kind=CallExpr is_enum=true
			parse_builtin_params(0, c'tt')
			vtop[-1].type_.t &= ~(vt_constant | vt_volatile)
			vtop[0].type_.t &= ~(vt_constant | vt_volatile)
			n = is_compatible_types(&vtop[-1].type_, &vtop[0].type_)
			vtop -= 2
			vpushi(n)
		}
		int(Tcc_token.tok_builtin_choose_expr) {
			vcc_trace_print('${@LOCATION} choose_expr')
			// case comp stmt
			c := i64(0)
			next()
			skip(`(`)
			c = expr_const64()
			skip(`,`)
			if !c {
				nocode_wanted++
			}
			expr_eq()
			if !c {
				vpop()
				nocode_wanted--
			}
			skip(`,`)
			if c {
				nocode_wanted++
			}
			expr_eq()
			if c {
				vpop()
				nocode_wanted--
			}
			skip(`)`)
		}
		int(Tcc_token.tok_builtin_constant_p) { // case comp body kind=CallExpr is_enum=true
			parse_builtin_params(1, c'e')
			n = 1
			if (vtop.r & (vt_valmask | vt_lval)) != vt_const
				|| (vtop.r & vt_sym && vtop.sym.a.addrtaken) {
				n = 0
			}
			unsafe { vtop-- }
			vpushi(n)
		}
		int(Tcc_token.tok_builtin_frame_address), int(Tcc_token.tok_builtin_return_address) {
			{
				tok1 := tok
				level := i64(0)
				next()
				skip(`(`)
				level = expr_const64()
				if level < 0 {
					if tok1 == Tcc_token.tok_builtin_return_address {
						_tcc_error('__builtin_return_address only takes positive integers')
					} else {
						_tcc_error('__builtin_frame_address only takes positive integers')
					}
				}
				skip(`)`)
				type_.t = 0
				mk_pointer(&type_)
				vset(&type_, 50, 0)
				for level-- {
					mk_pointer(&vtop.type_)
					indir()
				}
				if tok1 == Tcc_token.tok_builtin_return_address {
					vpushi(8)
					gen_op(`+`)
					mk_pointer(&vtop.type_)
					indir()
				}
			}
		}
		int(Tcc_token.tok_builtin_va_arg_types) { // case comp body kind=CallExpr is_enum=true
			vcc_trace_print('${@LOCATION} va_arg tok=${tok}')
			parse_builtin_params(0, c't')
			vpushi(classify_x86_64_va_arg(&vtop.type_))
			vswap()
			vpop()
		}
		int(Tcc_token.tok___atomic_store), int(Tcc_token.tok___atomic_load),
		int(Tcc_token.tok___atomic_exchange), int(Tcc_token.tok___atomic_compare_exchange),
		int(Tcc_token.tok___atomic_fetch_add), int(Tcc_token.tok___atomic_fetch_sub),
		int(Tcc_token.tok___atomic_fetch_or), int(Tcc_token.tok___atomic_fetch_xor),
		int(Tcc_token.tok___atomic_fetch_and), int(Tcc_token.tok___atomic_fetch_nand),
		int(Tcc_token.tok___atomic_add_fetch), int(Tcc_token.tok___atomic_sub_fetch),
		int(Tcc_token.tok___atomic_or_fetch), int(Tcc_token.tok___atomic_xor_fetch),
		int(Tcc_token.tok___atomic_and_fetch), int(Tcc_token.tok___atomic_nand_fetch) {
			parse_atomic(tok)
		}
		130, 128 {
			t = tok
			next()
			unary()
			inc(0, t)
		}
		int(`-`) { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			if is_float(vtop.type_.t) {
				gen_opif(129)
			} else {
				vpushi(0)
				vswap()
				gen_op(`-`)
			}
		}
		144 { // case comp body kind=IfStmt is_enum=true
			if !tcc_state.gnu_ext {
				goto tok_identifier // id: 0x7fffed4c0830
			}
			next()
			if tok < Tcc_token.tok_define {
				expect(c'label identifier')
			}
			s = label_find(tok)
			if !s {
				s = label_push(&global_label_stack, tok, 1)
			} else {
				if s.r == 2 {
					s.r = 1
				}
			}
			if (s.type_.t & 15) != 5 {
				s.type_.t = 0
				mk_pointer(&s.type_)
				s.type_.t |= 8192
			}
			vpushsym(&s.type_, s)
			next()
		}
		int(Tcc_token.tok_generic) {
			// case comp stmt
			controlling_type := CType{}
			has_default := 0
			has_match := 0
			learn := 0
			str := &TokenString(unsafe { nil })
			saved_nocode_wanted := nocode_wanted
			nocode_wanted &= ~CONST_WANTED_MASK
			next()
			skip(`(`)
			expr_type(&controlling_type, expr_eq)
			convert_parameter_type(&controlling_type)
			nocode_wanted = saved_nocode_wanted
			for {
				learn = 0
				skip(`,`)
				if tok == Tcc_token.tok_default {
					if has_default {
						_tcc_error("too many 'default'")
					}
					has_default = 1
					if !has_match {
						learn = 1
					}
					next()
				} else {
					ad_tmp := AttributeDef{}
					itmp := 0
					cur_type := CType{}
					parse_btype(&cur_type, &ad_tmp, 0)
					type_decl(&cur_type, &ad_tmp, &itmp, 1)
					if compare_types(&controlling_type, &cur_type, 0) {
						if has_match {
							_tcc_error('type match twice')
						}
						has_match = 1
						learn = 1
					}
				}
				skip(`:`)
				if learn {
					if str {
						tok_str_free(str)
					}
					skip_or_save_block(&str)
				} else {
					skip_or_save_block(unsafe { nil })
				}
				if tok == `)` {
					break
				}
			}
			if !str {
				buf := [60]char{}
				type_to_str(buf, sizeof(buf), &controlling_type, (unsafe { nil }))
				_tcc_error("type '${buf}' does not match any association")
			}
			begin_macro(str, 1)
			next()
			vcc_trace_print('${@LOCATION} generic')
			expr_eq()
			if tok != (-1) {
				expect(c',')
			}
			end_macro()
			next()
		}
		int(Tcc_token.tok___nan__) { // case comp body kind=BinaryOperator is_enum=true
			n = 2143289344
			// RRRREG special_math_val id=0x7fffed4cbd30
			special_math_val:
			vpushi(n)
			vtop.type_.t = 8
			next()
		}
		int(Tcc_token.tok___snan__) { // case comp body kind=BinaryOperator is_enum=true
			n = 2139095041
			unsafe {
				goto special_math_val
			}
		}
		int(Tcc_token.tok___inf__) { // case comp body kind=BinaryOperator is_enum=true
			n = 2139095040
			unsafe {
				goto special_math_val
			}
		}
		else {
			tok_identifier:
			if tok < Tcc_token.tok_define {
				_tcc_error("expression expected before '${get_tok_str(tok, &tokc)}'")
			}
			t = tok
			next()
			s = sym_find(t)
			if !s || (s.type_.t & (15 | (0 | (1 << 20)))) == (0 | (1 << 20)) {
				name := get_tok_str(t, unsafe { nil })
				vcc_trace_print('${@LOCATION} glob')
				if tok != `(` {
					_tcc_error("'${name}' undeclared")
				}
				tcc_state.warn_num = __offsetof(TCCState, warn_implicit_function_declaration) - __offsetof(TCCState, warn_none)
				_tcc_warning("implicit declaration of function '${name}'")
				s = external_global_sym(t, &func_old_type)
			}
			r = s.r
			if (r & vt_valmask) < vt_const {
				r = (r & ~vt_valmask) | vt_local
			}
			vset(&s.type_, r, s.c)
			vtop.sym = s
			if r & vt_sym {
				vtop.c.i = 0
				vcc_trace_print('${@LOCATION} 512 ${r}')
			} else if r == vt_const && (s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20) {
				vtop.c.i = s.enum_val
				vcc_trace_print('${@LOCATION} enum_val ${s.enum_val}')
			}
		}
	}
	for {
		if tok == 130 || tok == 128 {
			inc(1, tok)
			next()
		} else if tok == `.` || tok == 160 {
			qualifiers := 0
			cumofs := 0

			vcc_trace_print('${@LOCATION} quali')

			if tok == 160 {
				indir()
			}
			qualifiers = vtop.type_.t & (vt_constant | vt_volatile)
			test_lvalue()
			next()
			s = find_field(&vtop.type_, tok, &cumofs)
			gaddrof()
			vtop.type_ = char_pointer_type
			vpushi(cumofs)
			gen_op(`+`)
			vtop.type_ = s.type_
			vtop.type_.t |= qualifiers
			if !(vtop.type_.t & 64) {
				vtop.r |= 256
				if tcc_state.do_bounds_check {
					vtop.r |= 16384
				}
			}
			next()
		} else if tok == `[` {
			vcc_trace_print('${@LOCATION} unary.9 tok=${tok}')
			next()
			vcc_trace_print('${@LOCATION} unary.10 tok=${tok}')
			gexpr()
			vcc_trace_print('${@LOCATION} unary.11 tok=${tok}')
			gen_op(`+`)
			indir()
			skip(`]`)
		} else if tok == `(` {
			ret := SValue{}
			sa := &Sym(0)
			nb_args := 0
			ret_nregs := 0
			ret_align := 0
			regsize := 0
			variadic := 0
			vcc_trace_print('${@LOCATION} fcall')
			unsafe {
				if (vtop.type_.t & vt_btype) != vt_func {
					if (vtop.type_.t & (vt_btype | vt_array)) == vt_ptr {
						vtop.type_ = *pointed_type(&vtop.type_)
						if (vtop.type_.t & vt_btype) != vt_func {
							goto error_func // id: 0x7fffed4d17c0
						}
					} else {
						// RRRREG error_func id=0x7fffed4d17c0
						error_func:
						expect(c'function pointer')
					}
				} else {
					vtop.r &= ~vt_lval
				}
			}
			s = vtop.type_.ref
			next()
			sa = s.next
			nb_args = 0
			regsize = nb_args
			ret.r2 = vt_const
			if (s.type_.t & vt_btype) == vt_struct {
				vcc_trace_print('${@LOCATION} struct.2')
				variadic = (s.f.func_type == func_ellipsis)
				ret_nregs = gfunc_sret(&s.type_, variadic, &ret.type_, &ret_align, &regsize)
				if ret_nregs <= 0 {
					size = type_size(&s.type_, &align)
					loc = (loc - size) & -align
					ret.type_ = s.type_
					ret.r = vt_local | vt_lval
					vseti(vt_local, loc)
					if tcc_state.do_bounds_check {
						loc--
					}
					ret.c = vtop.c
					if ret_nregs < 0 {
						unsafe { vtop-- }
					} else { // 3
						nb_args++
					}
				}
			} else {
				ret_nregs = 1
				ret.type_ = s.type_
			}
			if ret_nregs > 0 {
				vcc_trace_print('${@LOCATION} ret reg')
				ret.c.i = 0
				put_r_ret(&ret, ret.type_.t)
			}
			if tok != `)` {
				vcc_trace_print('${@LOCATION} }')
				for {
					expr_eq()
					gfunc_param_typed(s, sa)
					nb_args++
					if sa {
						sa = sa.next
					}
					if tok == `)` {
						break
					}
					skip(`,`)
				}
			}
			if sa {
				_tcc_error('too few arguments to function')
			}
			skip(`)`)
			gfunc_call(nb_args)
			if ret_nregs < 0 {
				vsetc(&ret.type_, ret.r, &ret.c)
			} else {
				n = ret_nregs
				for n > 1 {
					rc := reg_classes[ret.r] & ~(1 | 2)
					rc <<= n-- - 1
					for r = 0; r < 25; r++ {
						if reg_classes[r] & rc {
							break
						}
					}
					vsetc(&ret.type_, r, &ret.c)
				}
				vsetc(&ret.type_, ret.r, &ret.c)
				vtop.r2 = ret.r2
				if (s.type_.t & vt_btype) == vt_struct && ret_nregs {
					addr := 0
					offset := 0

					vcc_trace_print('${@LOCATION} struct')

					size = type_size(&s.type_, &align)
					size = (size + regsize - 1) & -regsize
					if ret_align > align {
						align = ret_align
					}
					loc = (loc - size) & -align
					addr = loc
					offset = 0
					for ; true; {
						vset(&ret.type_, vt_local | vt_lval, addr + offset)
						vswap()
						vstore()
						unsafe { vtop-- }
						if (ret_nregs-- - 1) == 0 {
							break
						}
						offset += regsize
					}
					vset(&s.type_, vt_local | vt_lval, addr)
				}
				t = s.type_.t & vt_btype
				if t == 1 || t == 2 || t == 11 {
					vtop.r |= (u32(((3072) & ~((3072) << 1))) * (1))
				}
			}
			if s.f.func_noreturn {
				if debug_modes {
					tcc_tcov_block_end(tcc_state, -1)
				}
				if !nocode_wanted {
					nocode_wanted |= code_off_bit
				}
			}
		} else {
			break
		}
	}
	vcc_trace_print('${@LOCATION} unary.end')
}

fn precedence(tok int) int {
	match tok {
		145 { // case comp body kind=ReturnStmt is_enum=false
			return 1
		}
		144 { // case comp body kind=ReturnStmt is_enum=false
			return 2
		}
		int(`|`) { // case comp body kind=ReturnStmt is_enum=false
			return 3
		}
		int(`^`) { // case comp body kind=ReturnStmt is_enum=false
			return 4
		}
		int(`&`) { // case comp body kind=ReturnStmt is_enum=false
			return 5
		}
		148, 149 {
			return 6
			// RRRREG relat id=0x7fffed4d6a10
		}
		tok_ult, tok_uge {
			return 7
		}
		int(`<`), int(`>`) {
			return 8
		}
		int(`+`), int(`-`) {
			return 9
		}
		int(`*`), int(`/`), int(`%`) {
			return 10
		}
		else {
			if tok >= 150 && tok <= 159 {
				return 7
			}
			return 0
		}
	}
}

fn init_prec() {
	i := 0
	for i = 0; i < 256; i++ {
		prec[i] = precedence(i)
		// vcc_trace_print('${@LOCATION} [${i}]=${prec[i]}')
	}
}

fn expr_infix(p int) {
	vcc_trace_print('${@LOCATION} - tok=${tok} p=${p}')
	t := tok
	p2 := 0

	for {
		p2 = if u32(t) < 256 { prec[t] } else { 0 }
		if !(p2 >= p) {
			break
		}
		vcc_trace_print('${@LOCATION} - p2=${p2} p=${p}')

		if t == 145 || t == 144 {
			vcc_trace_print('${@LOCATION} - landor')
			expr_landor(t)
		} else {
			vcc_trace_print('${@LOCATION} - else p2=${p2} p=${p}')
			next()
			unary()
			if (if u32(tok) < 256 {
				prec[tok]
			} else {
				0
			}) > p2 {
				vcc_trace_print('${@LOCATION} - prec(${tok}) > p2=${p2}')
				expr_infix(p2 + 1)
			}
			gen_op(t)
		}
		t = tok
		vcc_trace_print('${@LOCATION} - end - tok=${tok}')
	}
}

fn condition_3way() int {
	c := -1
	unsafe {
		if (vtop.r & (vt_valmask | vt_lval)) == vt_const && (!(vtop.r & vt_sym) || !vtop.sym.a.weak) {
			vcc_trace_print('${@LOCATION} cond3way.0 c=${c}')
			vdup()
			vcc_trace_print('${@LOCATION} cond3way.1 c=${c}')
			gen_cast_s(vt_bool)
			vcc_trace_print('${@LOCATION} cond3way.2 c=${c}')
			c = vtop.c.i
			vcc_trace_print('${@LOCATION} cond3way.3 c=${c}')
			vpop()
		}
	}
	return c
}

fn expr_landor(op int) {
	t := 0
	cc := 1
	f := 0
	i := op == 144
	c := 0

	vcc_trace_print('${@LOCATION} op=${op} tok=${tok}')

	for {
		c = if f { i } else { condition_3way() }
		vcc_trace_print('${@LOCATION} c=${c}')
		if c < 0 {
			save_regs(1)
			cc = 0
		} else if c != i {
			nocode_wanted++
			f = 1
		}
		if tok != op {
			break
		}
		if c < 0 {
			t = gvtst(i, t)
		} else { // 3
			vpop()
		}
		next()
		unary()
		expr_infix((if u32(op) < 256 { prec[op] } else { 0 }) + 1)
	}
	if cc || f {
		vcc_trace_print('${@LOCATION} c=${c}')
		vpop()
		vpushi(int(i) ^ int(f))
		gsym(t)
		nocode_wanted -= f
	} else {
		vcc_trace_print('${@LOCATION} 2 c=${c}')
		gvtst_set(i, t)
	}
}

fn is_cond_bool(sv &SValue) bool {
	unsafe {
		if (sv.r & (63 | 256 | 512)) == 48 && (sv.type_.t & 15) == 3 {
			return u32(sv.c.i) < 2
		}
		if sv.r == 51 {
			return true
		}
		return false
	}
}

fn expr_cond() {
	tt := 0
	u := 0
	r1 := 0
	r2 := 0
	rc := 0
	t1 := 0
	t2 := 0
	islv := 0
	c := 0
	g := 0

	vcc_trace_print('${@LOCATION} - expr.0 ${tok}')

	sv := SValue{}
	type_ := CType{}
	unary()
	expr_infix(1)

	vcc_trace_print('${@LOCATION} - ${tok}')

	if tok == `?` {
		vcc_trace_print('${@LOCATION} cond ?')
		next()
		c = condition_3way()
		g = (tok == `:` && tcc_state.gnu_ext)
		tt = 0
		if !g {
			vcc_trace_print('${@LOCATION} cond.2 ?')
			if c < 0 {
				vcc_trace_print('${@LOCATION} cond.3 ?')
				save_regs(1)
				tt = gvtst(1, 0)
			} else {
				vpop()
			}
		} else if c < 0 {
			vcc_trace_print('${@LOCATION} cond.4 ?')
			save_regs(1)
			gv_dup()
			tt = gvtst(0, 0)
		}
		if c == 0 {
			nocode_wanted++
		}
		if !g {
			vcc_trace_print('${@LOCATION} cond.5 ?')
			gexpr()
		}
		if (vtop.type_.t & vt_btype) == vt_func {
			vcc_trace_print('${@LOCATION} cond.6 ?')
			mk_pointer(&vtop.type_)
		}
		sv = *vtop
		unsafe { vtop-- }
		if g {
			vcc_trace_print('${@LOCATION} cond.7 ${tt}')
			u = tt
		} else if c < 0 {
			vcc_trace_print('${@LOCATION} cond.8 ${c}')
			u = gjmp_acs(0)
			gsym(tt)
		} else { // 3
			u = 0
		}
		if c == 0 {
			nocode_wanted--
		}
		if c == 1 {
			nocode_wanted++
		}
		skip(`:`)
		expr_cond()
		if (vtop.type_.t & vt_btype) == vt_func {
			mk_pointer(&vtop.type_)
		}
		if !combine_types(&type_, &sv, vtop, `?`) {
			type_incompatibility_error(&sv.type_, &vtop.type_, c"type mismatch in conditional expression (have '%s' and '%s')")
		}
		if c < 0 && is_cond_bool(vtop) && is_cond_bool(&sv) {
			vcc_trace_print('${@LOCATION} cond.9 ${c}')
			t1 = gvtst(0, 0)
			t2 = gjmp_acs(0)
			gsym(u)
			vpushv(&sv)
			gvtst_set(0, t1)
			gvtst_set(1, t2)
			gen_cast(&type_)
			return
		}
		islv = vtop.r & vt_lval && sv.r & vt_lval && vt_struct == (type_.t & vt_btype)
		if c != 1 {
			vcc_trace_print('${@LOCATION} cond.10 ${c} ${islv}')
			gen_cast(&type_)
			if islv {
				mk_pointer(&vtop.type_)
				gaddrof()
			} else if 7 == (vtop.type_.t & 15) {
				gaddrof()
			}
		}
		rc = rc_type(type_.t)
		if (r2_ret(type_.t) != 48) {
			rc = rc_ret(type_.t)
		}
		tt = 0
		r2 = tt
		if c < 0 {
			r2 = gv(rc)
			tt = gjmp_acs(0)
		}
		gsym(u)
		if c == 1 {
			nocode_wanted--
		}
		if c != 0 {
			vcc_trace_print('${@LOCATION} cond.11 ${c}')
			*vtop = sv
			gen_cast(&type_)
			if islv {
				mk_pointer(&vtop.type_)
				gaddrof()
			} else if 7 == (vtop.type_.t & 15) {
				gaddrof()
			}
		}
		if c < 0 {
			vcc_trace_print('${@LOCATION} cond.12 ${c}')
			r1 = gv(rc)
			move_reg(r2, r1, if islv { 5 } else { type_.t })
			vtop.r = r2
			gsym(tt)
		}
		if islv {
			vcc_trace_print('${@LOCATION} cond.13 ${islv}')
			indir()
		}
	}
	vcc_trace_print('${@LOCATION} cond.end')
}

fn expr_eq() {
	t := 0
	vcc_trace_print('${@LOCATION}')
	expr_cond()
	t = tok
	vcc_trace_print('${@LOCATION} - ${t}')
	if t == `=` || (t >= 176 && t <= 185) {
		vcc_trace_print('${@LOCATION} - eq.0 - ${t}')
		test_lvalue()
		vcc_trace_print('${@LOCATION} - eq.20 - ${t}')
		next()
		if t == `=` {
			vcc_trace_print('${@LOCATION} - eq - ${t}')
			expr_eq()
		} else {
			vcc_trace_print('${@LOCATION} - eq.1 - ${t}')
			vdup()
			vcc_trace_print('${@LOCATION} - eq.2 - ${t}')
			expr_eq()
			vcc_trace_print('${@LOCATION} - eq.3 - ${t}')
			gen_op((c'+-*/%&|^<>'[t - 176]))
		}
		vcc_trace_print('${@LOCATION} - eq.4 - ${t}')
		vstore()
	}
}

fn gexpr() {
	vcc_trace_print('${@LOCATION}')
	expr_eq()
	if tok == `,` {
		for {
			vcc_trace_print('${@LOCATION} gexpr.0')
			vpop()
			vcc_trace_print('${@LOCATION} gexpr.1')
			next()
			vcc_trace_print('${@LOCATION} gexpr.2')
			expr_eq()
			vcc_trace_print('${@LOCATION} gexpr.3')
			// while()
			if !(tok == `,`) {
				break
			}
		}
		vcc_trace_print('${@LOCATION} gexpr.4')
		convert_parameter_type(&vtop.type_)
		if (vtop.r & vt_valmask) == vt_const && nocode_wanted
			&& !(nocode_wanted & CONST_WANTED_MASK) {
			vcc_trace_print('${@LOCATION} gexpr.5')
			gv(rc_type(vtop.type_.t))
		}
	}
}

fn expr_const1() {
	nocode_wanted += CONST_WANTED_BIT
	expr_cond()
	nocode_wanted -= CONST_WANTED_BIT
}

fn expr_const64() i64 {
	c := i64(0)
	expr_const1()
	if (vtop.r & (vt_valmask | vt_lval | vt_sym | vt_nonconst)) != vt_const {
		expect(c'constant expression')
	}
	unsafe {
		c = vtop.c.i
	}
	vcc_trace_print('${@LOCATION} vtop.c.i=${c}')
	vpop()
	return c
}

fn expr_const() int {
	c := int(0)
	wc := i64(expr_const64())
	c = wc
	if c != wc && u32(c) != wc {
		_tcc_error('constant exceeds 32 bit')
	}
	return c
}

fn gfunc_return(func_type &CType) {
	if (func_type.t & 15) == 7 {
		type_ := CType{}
		ret_type := CType{}

		ret_align := 0
		ret_nregs := 0
		regsize := 0

		ret_nregs = gfunc_sret(func_type, func_var, &ret_type, &ret_align, &regsize)
		if ret_nregs < 0 {
		} else if 0 == ret_nregs {
			type_ = *func_type
			mk_pointer(&type_)
			vset(&type_, vt_local | 256, func_vc)
			indir()
			vswap()
			vstore()
		} else {
			size := 0
			addr := 0
			align := 0
			rc := 0
			n := 0

			size = type_size(func_type, &align)
			unsafe {
				if align & (ret_align - 1) && ((vtop.r & 63) < 48 || vtop.c.i & (ret_align - 1)) {
					loc = (loc - size) & -ret_align
					addr = loc
					type_ = *func_type
					vset(&type_, vt_local | 256, addr)
					vswap()
					vstore()
					vpop()
					vset(&ret_type, vt_local | 256, addr)
				}
			}
			vtop.type_ = ret_type
			rc = rc_ret(ret_type.t)
			for n = ret_nregs; (n-- - 1) > 0; {
				vdup()
				gv(rc)
				vswap()
				incr_offset(regsize)
				rc <<= 1
			}
			gv(rc)
			vtop -= ret_nregs - 1
		}
	} else {
		gv(rc_ret(func_type.t))
	}
	unsafe { vtop-- }
}

fn check_func_return() {
	if (func_vt.t & vt_btype) == 0 {
		return
	}
	if !C.strcmp(funcname, c'main') && (func_vt.t & vt_btype) == vt_int {
		vpushi(0)
		gen_assign_cast(&func_vt)
		gfunc_return(&func_vt)
	} else {
		unsafe {
			_tcc_warning("function might return no value: '${funcname.vstring()}'")
		}
	}
}

fn case_cmpi(pa voidptr, pb voidptr) int {
	a := (*&&Case_t(pa)).v1
	b := (*&&Case_t(pb)).v1
	return if a < b { -1 } else { a > b }
}

fn case_cmpu(pa voidptr, pb voidptr) int {
	a := u64((*&&Case_t(pa)).v1)
	b := u64((*&&Case_t(pb)).v1)
	return if a < b { -1 } else { a > b }
}

fn gtst_addr(t int, a int) {
	gsym_addr(gvtst(0, t), a)
}

fn gcase(base &&Case_t, len int, bsym &int) {
	p := &Case_t(0)
	e := 0
	ll := (vtop.type_.t & 15) == vt_llong
	for len > 8 {
		p = base[len / 2]
		vdup()
		if ll {
			vpushll(p.v2)
		} else { // 3
			vpushi(p.v2)
		}
		gen_op(158)
		e = gvtst(1, 0)
		vdup()
		if ll {
			vpushll(p.v1)
		} else { // 3
			vpushi(p.v1)
		}
		gen_op(157)
		gtst_addr(0, p.sym)
		gcase(base, len / 2, bsym)
		gsym(e)
		e = len / 2 + 1
		base += e
		len -= e
	}
	for len-- {
		unsafe {
			p = *base++
		}
		vdup()
		if ll {
			vpushll(p.v2)
		} else { // 3
			vpushi(p.v2)
		}
		if p.v1 == p.v2 {
			gen_op(148)
			gtst_addr(0, p.sym)
		} else {
			gen_op(158)
			e = gvtst(1, 0)
			vdup()
			if ll {
				vpushll(p.v1)
			} else { // 3
				vpushi(p.v1)
			}
			gen_op(157)
			gtst_addr(0, p.sym)
			gsym(e)
		}
	}
	*bsym = gjmp_acs(*bsym)
}

fn try_call_scope_cleanup(stop &Sym) {
	cls := cur_scope.cl.s
	for ; voidptr(cls) != voidptr(stop); cls = cls.ncl {
		fs := cls.next
		vs := cls.prev_tok
		vpushsym(&fs.type_, fs)
		vset(&vs.type_, vs.r, vs.c)
		vtop.sym = vs
		mk_pointer(&vtop.type_)
		gaddrof()
		gfunc_call(1)
	}
}

fn try_call_cleanup_goto(cleanupstate &Sym) {
	oc := &Sym(0)
	cc := &Sym(0)

	ocd := 0
	ccd := 0

	if !cur_scope.cl.s {
		return
	}
	ocd = if cleanupstate { cleanupstate.v & ~sym_field } else { 0 }
	ccd = cur_scope.cl.n
	for oc = cleanupstate; ocd > ccd; ocd-- {
		oc = oc.ncl
	}
	for cc = cur_scope.cl.s; ccd > ocd; ccd-- {
		cc = cc.ncl
	}
	for _ = 0; voidptr(cc) != voidptr(oc); ccd-- {
		cc = cc.ncl
		oc = oc.ncl
	}
	try_call_scope_cleanup(cc)
}

fn block_cleanup(o &Scope) {
	jmp := 0
	g := &Sym(0)
	pg := &&Sym(0)

	for pg = &pending_gotos; *pg && g.c > o.cl.n; {
		if g.prev_tok.r & 1 {
			pcl := g.next
			if !jmp {
				jmp = gjmp_acs(0)
			}
			gsym(pcl.jnext)
			try_call_scope_cleanup(o.cl.s)
			pcl.jnext = gjmp_acs(0)
			if !o.cl.n {
				unsafe {
					goto remove_pending
				}
			}
			g.c = o.cl.n
			pg = &g.prev
		} else {
			// RRRREG remove_pending id=0x7fffed4ea588
			remove_pending:
			*pg = g.prev
			sym_free(g)
		}
		g = *pg
	}
	gsym(jmp)
	try_call_scope_cleanup(o.cl.s)
}

fn vla_restore(loc int) {
	if loc {
		gen_vla_sp_restore(loc)
	}
}

fn vla_leave(o &Scope) {
	c := cur_scope
	v := &Scope(unsafe { nil })

	for ; voidptr(c) != voidptr(o) && c; c = c.prev {
		if c.vla.num {
			v = c
		}
	}
	if v {
		vla_restore(v.vla.locorig)
	}
}

fn new_scope(o &Scope) {
	vcc_trace_print('${@LOCATION}')
	*o = *cur_scope
	vcc_trace_print('${@LOCATION} 1')
	o.prev = cur_scope
	cur_scope = o
	vcc_trace_print('${@LOCATION} 2')
	cur_scope.vla.num = 0
	o.lstk = local_stack
	o.llstk = local_label_stack
	local_scope++
	vcc_trace_print('${@LOCATION} new scope')
}

fn prev_scope(o &Scope, is_expr int) {
	vla_leave(o.prev)
	if voidptr(o.cl.s) != voidptr(o.prev.cl.s) {
		block_cleanup(o.prev)
	}
	label_pop(&local_label_stack, o.llstk, is_expr)
	pop_local_syms(o.lstk, is_expr)
	cur_scope = o.prev
	local_scope--
	vcc_trace_print('${@LOCATION} prev_scope')
}

fn leave_scope(o &Scope) {
	if !o {
		return
	}
	try_call_scope_cleanup(o.cl.s)
	vla_leave(o)
	vcc_trace_print('${@LOCATION} leave scope')
}

fn new_scope_s(o &Scope) {
	o.lstk = local_stack
	local_scope++
	vcc_trace_print('${@LOCATION}')
}

fn prev_scope_s(o &Scope) {
	sym_pop(&local_stack, o.lstk, 0)
	local_scope--
	vcc_trace_print('${@LOCATION}')
}

fn lblock(bsym &int, csym &int) {
	lo := loop_scope
	co := cur_scope

	b := co.bsym
	c := co.csym

	if csym {
		co.csym = csym
		loop_scope = co
	}
	co.bsym = bsym
	block(0)
	co.bsym = b
	if csym {
		co.csym = c
		loop_scope = lo
	}
}

fn block(flags int) {
	a := 0
	b := 0
	c := 0
	d := 0
	e := 0
	t := 0

	o := Scope{}
	s := &Sym(0)
	if flags & 1 {
		vpushi(0)
		vtop.type_.t = 0
	}
	// RRRREG again id=0x7fffed4f0b70
	again:
	vcc_trace_print('${@LOCATION} ${tok}')
	t = tok
	if (t >= 192 && t <= 207) {
		vcc_trace_print('${@LOCATION} goto ${tok}')
		unsafe {
			goto expr
		}
	}
	next()
	if debug_modes {
		vcc_trace_print('${@LOCATION} debug_modes=${int(debug_modes)}')
		tcc_tcov_check_line(tcc_state, 0)
		tcc_tcov_block_begin(tcc_state)
		vcc_trace_print('${@LOCATION} debug_modes=${int(debug_modes)} end')
	}
	if t == Tcc_token.tok_if {
		vcc_trace_print('${@LOCATION} if')
		new_scope_s(&o)
		skip(`(`)
		gexpr()
		skip(`)`)
		a = gvtst(1, 0)
		block(0)
		if tok == Tcc_token.tok_else {
			vcc_trace_print('${@LOCATION} else')
			d = gjmp_acs(0)
			gsym(a)
			next()
			block(0)
			gsym(d)
		} else {
			gsym(a)
		}
		prev_scope_s(&o)
	} else if t == Tcc_token.tok_while {
		vcc_trace_print('${@LOCATION} while')
		new_scope_s(&o)
		d = gind()
		skip(`(`)
		gexpr()
		skip(`)`)
		a = gvtst(1, 0)
		b = 0
		lblock(&a, &b)
		gjmp_addr_acs(d)
		gsym_addr(b, d)
		gsym(a)
		prev_scope_s(&o)
	} else if t == `{` {
		vcc_trace_print('${@LOCATION} block')
		if debug_modes {
			vcc_trace_print('${@LOCATION} debug.2')
			tcc_debug_stabn(tcc_state, Stab_debug_code.n_lbrac, ind - func_ind)
		}
		vcc_trace_print('${@LOCATION} new_scope')
		new_scope(&o)
		for tok == Tcc_token.tok_label {
			vcc_trace_print('${@LOCATION} label-for')
			for {
				next()
				if tok < Tcc_token.tok_define {
					expect(c'label identifier')
				}
				label_push(&local_label_stack, tok, 2)
				next()
				// while()
				if !(tok == `,`) {
					break
				}
			}
			skip(`;`)
		}
		for tok != `}` {
			vcc_trace_print('${@LOCATION} loop != }')
			decl(vt_local)
			if tok != `}` {
				if flags & 1 {
					vpop()
				}
				block(flags | 2)
			}
		}
		vcc_trace_print('${@LOCATION} prev_scope.2')
		prev_scope(&o, flags & 1)
		if debug_modes {
			tcc_debug_stabn(tcc_state, Stab_debug_code.n_rbrac, ind - func_ind)
		}
		if local_scope {
			vcc_trace_print('${@LOCATION} local_scope')
			next()
		} else if !nocode_wanted {
			vcc_trace_print('${@LOCATION} check_return')
			check_func_return()
		}
	} else if t == Tcc_token.tok_return {
		vcc_trace_print('${@LOCATION} return')
		b = (func_vt.t & 15) != 0
		if tok != `;` {
			gexpr()
			if b {
				gen_assign_cast(&func_vt)
			} else {
				if vtop.type_.t != 0 {
					_tcc_warning('void function returns a value')
				}
				unsafe { vtop-- }
			}
		} else if b {
			_tcc_warning("'return' with no value")
			b = 0
		}
		leave_scope(root_scope)
		if b {
			gfunc_return(&func_vt)
		}
		skip(`;`)
		if tok != `}` || local_scope != 1 {
			rsym = gjmp_acs(rsym)
		}
		if debug_modes {
			tcc_tcov_block_end(tcc_state, -1)
		}
		if !nocode_wanted {
			nocode_wanted |= code_off_bit
		}
	} else if t == Tcc_token.tok_break {
		vcc_trace_print('${@LOCATION} break')
		if !cur_scope.bsym {
			_tcc_error('cannot break')
		}
		if cur_switch && cur_scope.bsym == cur_switch.bsym {
			leave_scope(cur_switch.scope)
		} else { // 3
			leave_scope(loop_scope)
		}
		*cur_scope.bsym = gjmp_acs(*cur_scope.bsym)
		skip(`;`)
	} else if t == Tcc_token.tok_continue {
		vcc_trace_print('${@LOCATION} continue')
		if !cur_scope.csym {
			_tcc_error('cannot continue')
		}
		leave_scope(loop_scope)
		*cur_scope.csym = gjmp_acs(*cur_scope.csym)
		skip(`;`)
	} else if t == Tcc_token.tok_for {
		vcc_trace_print('${@LOCATION} for')
		new_scope(&o)
		skip(`(`)
		if tok != `;` {
			if !decl(52) {
				gexpr()
				vpop()
			}
		}
		skip(`;`)
		a = 0
		b = a
		c = gind()
		d = c
		if tok != `;` {
			gexpr()
			a = gvtst(1, 0)
		}
		skip(`;`)
		if tok != `)` {
			e = gjmp_acs(0)
			d = gind()
			gexpr()
			vpop()
			gjmp_addr_acs(c)
			gsym(e)
		}
		skip(`)`)
		lblock(&a, &b)
		gjmp_addr_acs(d)
		gsym_addr(b, d)
		gsym(a)
		prev_scope(&o, 0)
	} else if t == Tcc_token.tok_do {
		vcc_trace_print('${@LOCATION} do')
		new_scope_s(&o)
		a = 0
		b = a
		d = gind()
		lblock(&a, &b)
		gsym(b)
		skip(Tcc_token.tok_while)
		skip(`(`)
		gexpr()
		skip(`)`)
		skip(`;`)
		c = gvtst(0, 0)
		gsym_addr(c, d)
		gsym(a)
		prev_scope_s(&o)
	} else if t == Tcc_token.tok_switch {
		vcc_trace_print('${@LOCATION} switch')
		sw := &Switch_t(0)
		sw = tcc_mallocz(sizeof(*sw))
		sw.bsym = &a
		sw.scope = cur_scope
		sw.prev = cur_switch
		sw.nocode_wanted = nocode_wanted
		cur_switch = sw
		new_scope_s(&o)
		skip(`(`)
		gexpr()
		skip(`)`)
		sw.sv = unsafe { *vtop-- }
		a = 0
		b = gjmp_acs(0)
		lblock(&a, (unsafe { nil }))
		a = gjmp_acs(a)
		gsym(b)
		prev_scope_s(&o)
		if sw.nocode_wanted {
			unsafe {
				goto skip_switch
			}
		}
		if sw.sv.type_.t & 16 {
			C.qsort(sw.p, sw.n, sizeof(voidptr), case_cmpu)
		} else { // 3
			C.qsort(sw.p, sw.n, sizeof(voidptr), case_cmpi)
		}
		for b = 1; b < sw.n; b++ {
			if if sw.sv.type_.t & 16 {
				u64(sw.p[b - 1].v2) >= u64(sw.p[b].v1)
			} else {
				sw.p[b - 1].v2 >= sw.p[b].v1
			} {
				_tcc_error('duplicate case value')
			}
		}
		vpushv(&sw.sv)
		gv(1)
		d = 0
		gcase(sw.p, sw.n, &d)
		vpop()
		if sw.def_sym {
			gsym_addr(d, sw.def_sym)
		} else { // 3
			gsym(d)
		}
		skip_switch:
		gsym(a)
		dynarray_reset(&sw.p, &sw.n)
		cur_switch = sw.prev
		tcc_free(sw)
	} else if t == Tcc_token.tok_case {
		vcc_trace_print('${@LOCATION} case')
		cr := &Case_t(tcc_malloc(sizeof(Case_t)))
		if !cur_switch {
			expect(c'switch')
		}
		cr.v1 = expr_const64()
		cr.v2 = cr.v1
		if tcc_state.gnu_ext && tok == 161 {
			next()
			cr.v2 = expr_const64()
			if (!(cur_switch.sv.type_.t & 16) && cr.v2 < cr.v1)
				|| (cur_switch.sv.type_.t & 16 && u64(cr.v2) < u64(cr.v1)) {
				_tcc_warning('empty case range')
			}
		}
		if !cur_switch.nocode_wanted {
			cr.sym = gind()
		}
		dynarray_add(&cur_switch.p, &cur_switch.n, cr)
		skip(`:`)
		unsafe {
			goto block_after_label
		}
	} else if t == Tcc_token.tok_default {
		vcc_trace_print('${@LOCATION} default')
		if !cur_switch {
			expect(c'switch')
		}
		if cur_switch.def_sym {
			_tcc_error("too many 'default'")
		}
		cur_switch.def_sym = if cur_switch.nocode_wanted { 1 } else { gind() }
		skip(`:`)
		unsafe {
			goto block_after_label
		}
	} else if t == Tcc_token.tok_goto {
		vcc_trace_print('${@LOCATION} goto')
		vla_restore(cur_scope.vla.locorig)
		if tok == `*` && tcc_state.gnu_ext {
			next()
			gexpr()
			if (vtop.type_.t & 15) != 5 {
				expect(c'pointer')
			}
			ggoto()
		} else if tok >= Tcc_token.tok_define {
			s = label_find(tok)
			if !s {
				s = label_push(&global_label_stack, tok, 1)
			} else if s.r == 2 {
				s.r = 1
			}
			if s.r & 1 {
				if cur_scope.cl.s != unsafe { nil } && !nocode_wanted {
					sym_push2(&pending_gotos, sym_field, 0, cur_scope.cl.n)
					pending_gotos.prev_tok = s
					s = sym_push2(&s.next, sym_field, 0, 0)
					pending_gotos.next = s
				}
				s.jnext = gjmp_acs(s.jnext)
			} else {
				try_call_cleanup_goto(s.cleanupstate)
				gjmp_addr_acs(s.jnext)
			}
			next()
		} else {
			expect(c'label identifier')
		}
		skip(`;`)
	} else if t == Tcc_token.tok_asm1 || t == Tcc_token.tok_asm2 || t == Tcc_token.tok_asm3 {
		vcc_trace_print('${@LOCATION} asm')
		asm_instr()
	} else {
		vcc_trace_print('${@LOCATION} others')
		if tok == `:` && t >= Tcc_token.tok_define {
			vcc_trace_print('${@LOCATION} others.4')
			next()
			vcc_trace_print('${@LOCATION} others.3')
			s = label_find(t)
			if s {
				if s.r == 0 {
					_tcc_error("duplicate label '${get_tok_str(s.v, (unsafe { nil }))}'")
				}
				s.r = 0
				if s.next {
					pcl := &Sym(0)
					for pcl = s.next; pcl; pcl = pcl.prev {
						gsym(pcl.jnext)
					}
					sym_pop(&s.next, unsafe { nil }, 0)
				} else { // 3
					vcc_trace_print('${@LOCATION} others.1')
					gsym(s.jnext)
				}
			} else {
				vcc_trace_print('${@LOCATION} others.2')
				s = label_push(&global_label_stack, t, 0)
			}
			vcc_trace_print('${@LOCATION} others.5')
			s.jnext = gind()
			vcc_trace_print('${@LOCATION} others.6')
			s.cleanupstate = cur_scope.cl.s
			block_after_label:
			{
				ad_tmp := AttributeDef{}
				parse_attribute(&ad_tmp)
			}
			vcc_trace_print('${@LOCATION} others.7')
			if debug_modes {
				vcc_trace_print('${@LOCATION} others.8')
				tcc_tcov_reset_ind(tcc_state)
			}
			vcc_trace_print('${@LOCATION} others.9')
			vla_restore(cur_scope.vla.loc)
			if tok != `}` {
				if 0 == (flags & 2) {
					unsafe {
						goto again
					}
				}
			} else {
				tcc_state.warn_num = __offsetof(TCCState, warn_all) - __offsetof(TCCState, warn_none)
				_tcc_warning('deprecated use of label at end of compound statement')
			}
		} else {
			if t != `;` {
				vcc_trace_print('${@LOCATION} others.11')
				unget_tok(t)
				// RRRREG expr id=0x7fffed4f0d10
				expr:
				vcc_trace_print('${@LOCATION} others.12')
				if flags & 1 {
					vpop()
					vcc_trace_print('${@LOCATION} others.13')
					gexpr()
					vcc_trace_print('${@LOCATION} others.14')
				} else {
					vcc_trace_print('${@LOCATION} others.15')
					gexpr()
					vcc_trace_print('${@LOCATION} others.16')
					vpop()
					vcc_trace_print('${@LOCATION} others.17')
				}
				skip(`;`)
			}
		}
	}
	if debug_modes {
		vcc_trace_print('${@LOCATION} debug-end')
		tcc_tcov_check_line(tcc_state, 0)
		tcc_tcov_block_end(tcc_state, 0)
	}
	vcc_trace_print('${@LOCATION} block.end')
}

fn skip_or_save_block(str &&TokenString) {
	braces := tok == `{`
	level := 0
	if str {
		*str = tok_str_alloc()
	}
	for 1 {
		t := tok
		if level == 0 && (t == `,` || t == `;` || t == `}` || t == `)` || t == `]`) {
			break
		}
		if t == (-1) {
			if str || level > 0 {
				_tcc_error('unexpected end of file')
			} else { // 3
				break
			}
		}
		if str {
			tok_str_add_tok(*str)
		}
		next()
		if t == `{` || t == `(` || t == `[` {
			level++
		} else if t == `}` || t == `)` || t == `]` {
			level--
			if level == 0 && braces && t == `}` {
				break
			}
		}
	}
	if str {
		tok_str_add(*str, -1)
		tok_str_add(*str, 0)
	}
}

fn parse_init_elem(expr_type int) {
	saved_global_expr := 0
	match expr_type {
		1 { // case comp body kind=BinaryOperator is_enum=false
			saved_global_expr = global_expr
			global_expr = 1
			expr_const1()
			global_expr = saved_global_expr
			if ((vtop.r & (63 | 256)) != 48 && ((vtop.r & (512 | 256)) != (512 | 256)
				|| vtop.sym.v < 268435456)) {
				_tcc_error('initializer element is not constant')
			}
		}
		2 { // case comp body kind=CallExpr is_enum=false
			expr_eq()
		}
		else {}
	}
}

fn init_assert(p &Init_params, offset int) {
	if if p.sec {
		!(nocode_wanted > 0) && offset > p.sec.data_offset
	} else {
		!nocode_wanted && offset > p.local_offset
	} {
		_tcc_error('internal compiler error\n${@FILE}:${@LINE}: in ${@FN}(): initializer overflow')
	}
}

fn init_putz(p &Init_params, c u32, size int) {
	init_assert(p, c + size)
	if p.sec {
	} else {
		vpush_helper_func(Tcc_token.tok_memset)
		vseti(50, c)
		vpushi(0)
		vpushs(size)
		gfunc_call(3)
	}
}

fn decl_design_delrels(sec &Section, c int, size int) {
	rel := &Elf64_Rela(0)
	rel2 := &Elf64_Rela(0)
	rel_end := &Elf64_Rela(0)

	if !sec || !sec.reloc {
		return
	}
	rel = &Elf64_Rela(sec.reloc.data)
	rel2 = rel
	rel_end = unsafe { &Elf64_Rela((sec.reloc.data + sec.reloc.data_offset)) }
	for voidptr(rel) < voidptr(rel_end) {
		if rel.r_offset >= c && rel.r_offset < c + size {
			sec.reloc.data_offset -= sizeof(*rel)
		} else {
			if voidptr(rel2) != voidptr(rel) {
				unsafe { C.memcpy(rel2, rel, sizeof(*rel)) }
			}
			unsafe { rel2++ }
		}
		unsafe { rel++ }
	}
}

fn decl_design_flex(p &Init_params, ref &Sym, index int) {
	if voidptr(ref) == voidptr(p.flex_array_ref) {
		if index >= ref.c {
			ref.c = index + 1
		}
	} else if ref.c < 0 {
		_tcc_error('flexible array has zero size in this context')
	}
}

fn decl_designator(p &Init_params, type_ &CType, c u32, cur_field &&Sym, flags int, al int) int {
	s := &Sym(0)
	f := &Sym(0)

	index := 0
	index_last := 0
	align := 0
	l := 0
	nb_elems := 0
	elem_size := 0

	corig := c
	elem_size = 0
	nb_elems = 1
	if flags & 4 {
		unsafe {
			goto no_designator
		}
	}
	if tcc_state.gnu_ext && tok >= Tcc_token.tok_define {
		l = tok
		next()
		if tok == `:` {
			unsafe {
				goto struct_field
			}
		}
		unget_tok(l)
	}
	for nb_elems == 1 && (tok == `[` || tok == `.`) {
		if tok == `[` {
			if !(type_.t & 64) {
				expect(c'array type')
			}
			next()
			index = expr_const()
			index_last = index
			if tok == 161 && tcc_state.gnu_ext {
				next()
				index_last = expr_const()
			}
			skip(`]`)
			s = type_.ref
			decl_design_flex(p, s, index_last)
			if index < 0 || index_last >= s.c || index_last < index {
				_tcc_error('index exceeds array bounds or range is empty')
			}
			if cur_field {
				(*cur_field).c = index_last
			}
			type_ = pointed_type(type_)
			elem_size = type_size(type_, &align)
			c += index * elem_size
			nb_elems = index_last - index + 1
		} else {
			cumofs := 0
			next()
			l = tok
			// RRRREG struct_field id=0x7fffed508638
			struct_field:
			next()
			f = find_field(type_, l, &cumofs)
			if cur_field {
				*cur_field = f
			}
			type_ = &f.type_
			c += cumofs
		}
		cur_field = (unsafe { nil })
	}
	if !cur_field {
		if tok == `=` {
			next()
		} else if !tcc_state.gnu_ext {
			expect(c'=')
		}
	} else {
		// RRRREG no_designator id=0x7fffed508320
		no_designator:
		if type_.t & 64 {
			index = (*cur_field).c
			s = type_.ref
			decl_design_flex(p, s, index)
			if index >= s.c {
				_tcc_error('too many initializers')
			}
			type_ = pointed_type(type_)
			elem_size = type_size(type_, &align)
			c += index * elem_size
		} else {
			f = *cur_field
			for f != unsafe { nil } && f.v & 268435456 && is_integer_btype(f.type_.t & 15) {
				*cur_field = f.next
				f = *cur_field
			}
			if !f {
				_tcc_error('too many initializers')
			}
			type_ = &f.type_
			c += f.c
		}
	}
	if !elem_size {
		elem_size = type_size(type_, &align)
	}
	if !(flags & 2) && c - corig < al {
		decl_design_delrels(p.sec, c, elem_size * nb_elems)
		flags &= ~8
	}
	decl_initializer(p, type_, c, flags & ~1)
	if !(flags & 2) && nb_elems > 1 {
		aref := Sym{
			v: 0
		}

		t1 := CType{}
		i := 0
		if p.sec != unsafe { nil } || type_.t & 64 {
			aref.c = elem_size
			t1.t = 7
			t1.ref = &aref
			type_ = &t1
		}
		if p.sec {
			vpush_ref(type_, p.sec, c, elem_size)
		} else { // 3
			vset(type_, 50 | 256, c)
		}
		for i = 1; i < nb_elems; i++ {
			vdup()
			init_putv(p, type_, c + elem_size * i)
		}
		vpop()
	}
	c += nb_elems * elem_size
	if c - corig > al {
		al = c - corig
	}
	return al
}

fn init_putv(p &Init_params, type_ &CType, c u32) {
	bt := 0
	ptr := unsafe { nil }
	dtype := CType{}
	size := 0
	align := 0

	sec := p.sec
	val := u64(0)
	dtype = *type_
	dtype.t &= ~vt_constant
	size = type_size(type_, &align)
	if type_.t & vt_bitfield {
		size = ((((type_.t) >> 20) & 63) + (((type_.t) >> (20 + 6)) & 63) + 7) / 8
	}
	init_assert(p, c + size)
	if sec {
		gen_assign_cast(&dtype)
		bt = type_.t & vt_btype
		if vtop.r & vt_sym && bt != vt_ptr && (bt != (if ptr_size == 8 {
			vt_llong
		} else {
			vt_int
		}) || type_.t & vt_bitfield) && !(vtop.r & vt_const && vtop.sym.v >= sym_first_anom) {
			_tcc_error('initializer element is not computable at load time')
		}
		if (nocode_wanted > 0) {
			unsafe { vtop-- }
			return
		}
		unsafe {
			ptr = sec.data + c
			val = vtop.c.i
		}
		if (vtop.r & (512 | 48)) == (512 | 48) && vtop.sym.v >= sym_first_anom
			&& (vtop.type_.t & vt_btype) != vt_ptr {
			ssec := &Section(0)
			esym := &Elf64_Sym(0)
			rel := &Elf64_Rela(0)
			esym = elfsym(vtop.sym)
			ssec = tcc_state.sections[esym.st_shndx]
			unsafe { C.memmove(ptr, ssec.data + esym.st_value + int(vtop.c.i), size) }
			if ssec.reloc {
				relofs := ssec.reloc.data_offset
				for relofs >= sizeof(*rel) {
					relofs -= sizeof(*rel)
					rel = unsafe { &Elf64_Rela((ssec.reloc.data + relofs)) }
					if rel.r_offset >= esym.st_value + size {
						continue
					}
					if rel.r_offset < esym.st_value {
						break
					}
					put_elf_reloca(tcc_state.symtab_section, sec, c + rel.r_offset - esym.st_value,
						((rel.r_info) & 4294967295), ((rel.r_info) >> 32), rel.r_addend)
				}
			}
		} else {
			if type_.t & vt_bitfield {
				bit_pos := 0
				bit_size := 0
				bits := 0
				n := 0

				p2 := &u8(0)
				v := u8(0)
				m := u8(0)

				bit_pos = (((vtop.type_.t) >> 20) & 63)
				bit_size = (((vtop.type_.t) >> (20 + 6)) & 63)
				p2 = unsafe { &u8(ptr) + (bit_pos >> 3) }
				bit_pos &= 7
				bits = 0
				for bit_size {
					n = 8 - bit_pos
					if n > bit_size {
						n = bit_size
					}
					v = val >> bits << bit_pos
					m = ((1 << n) - 1) << bit_pos
					*p2 = (*p2 & ~m) | (v & m)
					bits += n
					bit_size -= n
					bit_pos = 0
					unsafe { p2++ }
				}
			} else { // 3
				match bt {
					vt_bool {
						*&char(ptr) = val != 0
					}
					vt_byte {
						*&char(ptr) = val
					}
					vt_short {
						write16le(ptr, val)
					}
					vt_float {
						write32le(ptr, val)
					}
					vt_double {
						write64le(ptr, val)
					}
					vt_ldouble {
						unsafe {
							if sizeof(f64) == ldouble_size {
								C.memcpy(ptr, &vtop.c.ld, ldouble_size)
							} else if sizeof(f64) == ldouble_size {
								*&f64(ptr) = f64(vtop.c.ld)
							} else if 0 == C.memcmp(ptr, &vtop.c.ld, ldouble_size) {
								// nothing to do for 0.0
							}
						}
					}
					vt_llong, vt_ptr {
						if vtop.r & vt_sym {
							greloca(sec, vtop.sym, c, r_data_ptr, val)
						} else {
							write64le(ptr, val)
						}
					}
					vt_int {
						write32le(ptr, val)
					}
					else {}
				}
			}
		}
		unsafe { vtop-- }
	} else {
		vset(&dtype, vt_local | vt_lval, c)
		vswap()
		vstore()
		vpop()
	}
}

fn decl_initializer(p &Init_params, type_ &CType, c u32, flags int) {
	len := 0
	n := 0
	no_oblock := 0
	i := 0

	size1 := 0
	align1 := 0

	s := &Sym(0)
	f := &Sym(0)

	indexsym := Sym{}
	t1 := &CType(0)

	vcc_trace_print('${@LOCATION} flags=${flags}')

	if debug_modes && !(flags & 2) && !p.sec {
		vcc_trace_print('${@LOCATION} declinit.0')
		tcc_debug_line(tcc_state)
		tcc_tcov_check_line(tcc_state, 1)
	}
	if !(flags & 4) && tok != `{` && tok != 201 && tok != 200 && (!(flags & 2)
		|| (type_.t & 15) == 7) {
		ncw_prev := nocode_wanted
		if flags & 2 && !p.sec {
			nocode_wanted++
		}
		vcc_trace_print('${@LOCATION} declinit.1')
		parse_init_elem(if !p.sec { 2 } else { 1 })
		nocode_wanted = ncw_prev
		flags |= 4
	}
	if type_.t & 64 {
		no_oblock = 1
		if (flags & 1 && tok != 201 && tok != 200) || tok == `{` {
			skip(`{`)
			no_oblock = 0
		}
		s = type_.ref
		n = s.c
		vcc_trace_print('${@LOCATION} declinit.2')
		t1 = pointed_type(type_)
		size1 = type_size(t1, &align1)
		if (tok == 201 && (t1.t & 15) == 3) || (tok == 200 && (t1.t & 15) == 1) {
			len = 0
			cstr_reset(&initstr)
			if size1 != (if tok == 200 {
				1
			} else {
				sizeof(Nwchar_t)
			}) {
				_tcc_error('unhandled string literal merging')
			}
			for tok == 200 || tok == 201 {
				if initstr.size {
					vcc_trace_print('${@LOCATION} go_back ${size1} ${initstr.size}')
					initstr.size -= size1
				}
				if tok == 200 {
					len += tokc.str.size
				} else { // 3
					unsafe {
						len += tokc.str.size / sizeof(Nwchar_t)
					}
				}
				len--
				unsafe {
					cstr_cat(&initstr, tokc.str.data, tokc.str.size)
				}
				vcc_trace_print('${@LOCATION} declinit.3')
				next()
			}
			if tok != `)` && tok != `}` && tok != `,` && tok != `;` && tok != (-1) {
				unget_tok(if size1 == 1 { 200 } else { 201 })
				tokc.str.size = initstr.size
				tokc.str.data = initstr.data
				goto do_init_array // id: 0x7fffed520228
			}
			vcc_trace_print('${@LOCATION} declinit.4')
			decl_design_flex(p, s, len)
			if !(flags & 2) {
				nb := n
				ch := 0

				if len < nb {
					nb = len
				}
				if len > nb {
					_tcc_warning('initializer-string for array is too long')
				}
				if p.sec && size1 == 1 {
					vcc_trace_print('${@LOCATION} declinit.5')
					init_assert(p, c + nb)
					if !(nocode_wanted > 0) {
						C.memcpy(p.sec.data + c, initstr.data, nb)
					}
				} else {
					for i = 0; i < n; i++ {
						if i >= nb {
							if flags & 8 {
								break
							}
							if n - i >= 4 {
								init_putz(p, c + i * size1, (n - i) * size1)
								break
							}
							ch = 0
						} else if size1 == 1 {
							ch = (&u8(initstr.data))[i]
						} else { // 3
							ch = (&Nwchar_t(initstr.data))[i]
						}
						vcc_trace_print('${@LOCATION} declinit.6')
						vpushi(ch)
						init_putv(p, t1, c + i * size1)
					}
				}
			}
		} else {
			// RRRREG do_init_array id=0x7fffed520228
			do_init_array:
			indexsym.c = 0
			f = &indexsym
			// RRRREG do_init_list id=0x7fffed522268
			do_init_list:
			if !(flags & (8 | 2)) {
				init_putz(p, c, n * size1)
				flags |= 8
			}
			len = 0
			vcc_trace_print('${@LOCATION} declinit.7')
			decl_design_flex(p, s, len)
			for tok != `}` || flags & 4 {
				vcc_trace_print('${@LOCATION} declinit.8')
				len = decl_designator(p, type_, c, &f, flags, len)
				flags &= ~4
				if type_.t & 64 {
					indexsym.c++
					if no_oblock && len >= n * size1 {
						break
					}
				} else {
					if s.type_.t == (1 << 20 | 7) {
						f = (unsafe { nil })
					} else { // 3
						f = f.next
					}
					if no_oblock && f == (unsafe { nil }) {
						break
					}
				}
				if tok == `}` {
					break
				}
				skip(`,`)
			}
		}
		if !no_oblock {
			skip(`}`)
		}
	} else if flags & 4 && is_compatible_unqualified_types(type_, &vtop.type_) {
		goto one_elem // id: 0x7fffed5235f8
	} else if (type_.t & 15) == 7 {
		no_oblock = 1
		if flags & 1 || tok == `{` {
			skip(`{`)
			no_oblock = 0
		}
		s = type_.ref
		f = s.next
		n = s.c
		size1 = 1
		goto do_init_list // id: 0x7fffed522268
	} else if tok == `{` {
		if flags & 4 {
			skip(`;`)
		}
		next()
		vcc_trace_print('${@LOCATION} declinit.9')
		decl_initializer(p, type_, c, flags & ~4)
		skip(`}`)
	} else { // 3
		one_elem:
		if (flags & dif_size_only) {
			vcc_trace_print('${@LOCATION} declinit.10')
			if (flags & dif_have_elem) {
				vpop()
			} else {
				skip_or_save_block(unsafe { nil })
			}
		} else {
			if (!(flags & dif_have_elem)) {
				if (tok != tok_str && tok != tok_lstr) {
					expect(c'string constant')
				}
				vcc_trace_print('${@LOCATION} declinit.12')
				parse_init_elem(if !p.sec { expr_any } else { expr_const })
			}
			if (p.sec == unsafe { nil } && (flags & dif_clear) != 0
				&& (vtop.r & (vt_valmask | vt_lval | vt_sym)) == vt_const && vtop.c.i == 0
				&& btype_size(type_.t & vt_btype)) {
				vcc_trace_print('${@LOCATION} declinit.13')
				vpop()
			} else {
				vcc_trace_print('${@LOCATION} declinit.14')
				init_putv(p, type_, c)
			}
		}
	}
	vcc_trace_print('${@LOCATION} declinit.end')
}

fn decl_initializer_alloc(type_ &CType, ad &AttributeDef, r int, has_init int, v int, global int) {
	size := 0
	align := 0
	addr := 0

	init_str := &TokenString(unsafe { nil })
	sec := &Section(0)
	flexible_array := &Sym(0)
	sym := &Sym(0)
	saved_nocode_wanted := nocode_wanted
	bcheck := tcc_state.do_bounds_check && !(nocode_wanted > 0)
	p := Init_params{
		sec: unsafe { nil }
	}

	if v && (r & vt_valmask) == vt_const {
		nocode_wanted |= data_only_wanted
	}
	flexible_array = unsafe { nil }
	size = type_size(type_, &align)
	if size < 0 {
		if !(type_.t & vt_array) {
			_tcc_error('initialization of incomplete type')
		}
		type_.ref = sym_push(sym_field, &type_.ref.type_, 0, type_.ref.c)
		p.flex_array_ref = type_.ref
		vcc_trace_print('${@LOCATION} declinit.0')
	} else if has_init && (type_.t & vt_btype) == vt_struct {
		field := type_.ref.next
		if field {
			for field.next {
				field = field.next
			}
			if field.type_.t & vt_array && field.type_.ref.c < 0 {
				flexible_array = field
				p.flex_array_ref = field.type_.ref
				size = -1
				vcc_trace_print('${@LOCATION} declinit.1')
			}
			vcc_trace_print('${@LOCATION} declinit.2')
		}
	}
	if size < 0 {
		vcc_trace_print('${@LOCATION} declinit.3')
		if !has_init {
			_tcc_error('unknown type size')
		}
		if has_init == 2 {
			init_str = tok_str_alloc()
			for tok == 200 || tok == 201 {
				tok_str_add_tok(init_str)
				next()
			}
			tok_str_add(init_str, -1)
			tok_str_add(init_str, 0)
		} else { // 3
			skip_or_save_block(&init_str)
		}
		unget_tok(0)
		begin_macro(init_str, 1)
		next()
		decl_initializer(&p, type_, 0, 1 | 2)
		vcc_trace_print('${@LOCATION} set macro_ptr=init_str')
		macro_ptr = init_str.str
		next()
		size = type_size(type_, &align)
		if size < 0 {
			_tcc_error('unknown type size')
		}
		if flexible_array && flexible_array.type_.ref.c > 0 {
			size += flexible_array.type_.ref.c * pointed_size(&flexible_array.type_)
		}
	}
	if ad.a.aligned {
		speca := 1 << (ad.a.aligned - 1)
		if speca > align {
			align = speca
		}
	} else if ad.a.packed {
		align = 1
	}
	if !v && nocode_wanted > 0 {
		size = 0
		align = 1
	}
	if (r & vt_valmask) == vt_local {
		sec = unsafe { nil }
		if bcheck && v {
			loc -= align
		}
		loc = (loc - size) & -align
		addr = loc
		p.local_offset = addr + size
		if bcheck && v {
			loc -= align
		}
		if v {
			if ad.asm_label {
				reg := asm_parse_regvar(ad.asm_label)
				if reg >= 0 {
					r = (r & ~vt_valmask) | reg
				}
			}
			sym = sym_push(v, type_, r, addr)
			if ad.cleanup_func {
				cls := sym_push2(&all_cleanups, sym_field | (cur_scope.cl.n++ + 1), 0,
					0)
				cls.prev_tok = sym
				cls.next = ad.cleanup_func
				cls.ncl = cur_scope.cl.s
				cur_scope.cl.s = cls
			}
			sym.a = ad.a
		} else {
			vset(type_, r, addr)
		}
	} else {
		sym = unsafe { nil }
		if v && global {
			sym = sym_find(v)
			if sym {
				if p.flex_array_ref != unsafe { nil } && sym.type_.t & type_.t & 64
					&& sym.type_.ref.c > type_.ref.c {
					type_.ref.c = sym.type_.ref.c
					size = type_size(type_, &align)
				}
				patch_storage(sym, ad, type_)
				if !has_init && sym.c && elfsym(sym).st_shndx != 0 {
					goto no_alloc // id: 0x7fffed52b7b8
				}
			}
		}
		sec = ad.section
		if !sec {
			tp := type_
			for (tp.t & (15 | 64)) == (5 | 64) {
				tp = &tp.ref.type_
			}
			if tp.t & 256 {
				sec = tcc_state.rodata_section
			} else if has_init {
				sec = tcc_state.data_section
			} else if tcc_state.nocommon {
				sec = tcc_state.bss_section
			}
		}
		if sec {
			addr = section_add(sec, size, align)
			if bcheck {
				section_add(sec, 1, 1)
			}
		} else {
			addr = align
			sec = tcc_state.common_section
		}
		if v {
			if !sym {
				sym = sym_push(v, type_, r | vt_sym, 0)
				patch_storage(sym, ad, unsafe { nil })
			}
			vcc_trace_print('${@LOCATION} declinit.20')
			put_extern_sym(sym, sec, addr, size)
		} else {
			vpush_ref(type_, sec, addr, size)
			vcc_trace_print('${@LOCATION} declinit.21')
			sym = vtop.sym
			vtop.r |= r
		}
		if bcheck {
			vcc_trace_print('${@LOCATION} bcheck')
			bounds_ptr := &Elf64_Addr(0)
			greloca(tcc_state.bounds_section, sym, tcc_state.bounds_section.data_offset,
				1, 0)
			bounds_ptr = section_ptr_add(tcc_state.bounds_section, 2 * sizeof(Elf64_Addr))
			bounds_ptr[0] = 0
			bounds_ptr[1] = size
		}
	}
	if type_.t & 1024 {
		a := 0
		if (nocode_wanted > 0) {
			vcc_trace_print('${@LOCATION} declinit.22')
			goto no_alloc // id: 0x7fffed52b7b8
		}
		if cur_scope.vla.num == 0 {
			if cur_scope.prev != unsafe { nil } && cur_scope.prev.vla.num {
				cur_scope.vla.locorig = cur_scope.prev.vla.loc
			} else {
				loc -= ptr_size
				gen_vla_sp_save(loc)
				cur_scope.vla.locorig = loc
			}
		}
		vpush_type_size(type_, &a)
		gen_vla_alloc(type_, a)
		gen_vla_sp_save(addr)
		cur_scope.vla.loc = addr
		cur_scope.vla.num++
	} else if has_init {
		p.sec = sec
		decl_initializer(&p, type_, addr, 1)
		if flexible_array {
			flexible_array.type_.ref.c = -1
		}
	}
	// RRRREG no_alloc id=0x7fffed52b7b8
	no_alloc:
	if init_str {
		end_macro()
		next()
	}
	nocode_wanted = saved_nocode_wanted
	vcc_trace_print('${@LOCATION} declinit.30 ${nocode_wanted}')
}

fn func_vla_arg_code(arg &Sym) {
	align := 0
	vla_array_tok := &TokenString(unsafe { nil })
	if arg.type_.ref {
		func_vla_arg_code(arg.type_.ref)
	}
	if arg.type_.t & 1024 && arg.type_.ref.vla_array_str {
		loc -= type_size(&int_type, &align)
		loc &= -align
		arg.type_.ref.c = loc
		unget_tok(0)
		vla_array_tok = tok_str_alloc()
		vla_array_tok.str = arg.type_.ref.vla_array_str
		begin_macro(vla_array_tok, 1)
		next()
		gexpr()
		end_macro()
		next()
		vpush_type_size(&arg.type_.ref.type_, &align)
		gen_op(`*`)
		vset(&int_type, 50 | 256, arg.type_.ref.c)
		vswap()
		vstore()
		vpop()
	}
}

fn func_vla_arg(sym &Sym) {
	arg := &Sym(0)
	for arg = sym.type_.ref.next; arg; arg = arg.next {
		if (arg.type_.t & 15) == 5 && arg.type_.ref.type_.t & 1024 {
			func_vla_arg_code(arg.type_.ref)
		}
	}
}

fn gen_function(sym &Sym) {
	mut f := Scope{
		prev: unsafe { nil }
	}

	vcc_trace_print('${@LOCATION}')

	root_scope = &Scope(&f)
	cur_scope = &Scope(root_scope)
	nocode_wanted = 0
	ind = tcc_state.cur_text_section.data_offset
	if sym.a.aligned {
		vcc_trace_print('${@LOCATION} gen_fun.0')
		newoff := u64(section_add(tcc_state.cur_text_section, 0, 1 << (sym.a.aligned - 1)))
		gen_fill_nops(newoff - u64(ind))
	}
	funcname = get_tok_str(sym.v, unsafe { nil })
	vcc_trace('${@LOCATION} ${funcname.vstring()}')
	func_ind = ind
	func_vt = sym.type_.ref.type_
	func_var = sym.type_.ref.f.func_type == func_ellipsis

	vcc_trace_print('${@LOCATION} gen_fun.1')
	put_extern_sym(sym, tcc_state.cur_text_section, ind, 0)

	if sym.type_.ref.f.func_ctor {
		vcc_trace_print('${@LOCATION} gen_fun.2')
		add_array(tcc_state, c'.init_array', sym.c)
	}
	if sym.type_.ref.f.func_dtor {
		vcc_trace_print('${@LOCATION} gen_fun.3')
		add_array(tcc_state, c'.fini_array', sym.c)
	}
	vcc_trace_print('${@LOCATION} gen_fun.4')
	tcc_debug_funcstart(tcc_state, sym)

	vcc_trace_print('${@LOCATION} gen_fun.5')
	sym_push2(&local_stack, sym_field, 0, 0)
	local_scope = 1
	vcc_trace_print('${@LOCATION} gen_fun.6')
	gfunc_prolog(sym)
	vcc_trace_print('${@LOCATION} gen_fun.7')
	tcc_debug_prolog_epilog(tcc_state, 0)

	local_scope = 0
	rsym = 0
	vcc_trace_print('${@LOCATION} gen_fun.8')
	clear_temp_local_var_list()
	vcc_trace_print('${@LOCATION} gen_fun.9')
	func_vla_arg(sym)
	vcc_trace_print('${@LOCATION} gen_fun.10')
	block(0)
	vcc_trace_print('${@LOCATION} gen_fun.11')
	gsym(rsym)

	nocode_wanted = 0

	vcc_trace_print('${@LOCATION} gen_fun.12')
	pop_local_syms(unsafe { nil }, 0)
	vcc_trace_print('${@LOCATION} gen_fun.13')
	tcc_debug_prolog_epilog(tcc_state, 1)
	vcc_trace_print('${@LOCATION} gen_fun.14')
	gfunc_epilog()

	vcc_trace_print('${@LOCATION} gen_fun.15')
	tcc_debug_funcend(tcc_state, ind - func_ind)

	elfsym(sym).st_size = ind - func_ind

	vcc_trace_print('${@LOCATION} gen_fun.16')
	tcc_state.cur_text_section.data_offset = ind
	local_scope = 0
	vcc_trace_print('${@LOCATION} gen_fun.17')
	label_pop(&global_label_stack, unsafe { nil }, 0)
	vcc_trace_print('${@LOCATION} gen_fun.18')
	sym_pop(&all_cleanups, unsafe { nil }, 0)

	tcc_state.cur_text_section = unsafe { nil }
	funcname = c''
	func_vt.t = vt_void
	func_var = 0
	ind = 0
	func_ind = -1
	nocode_wanted = data_only_wanted
	check_vstack()
	vcc_trace_print('${@LOCATION} gen_fun.19')
	next()

	vcc_trace_print('${@LOCATION} end')
}

fn gen_inline_functions(s &TCCState) {
	sym := &Sym(0)
	inline_generated := 0
	i := 0

	fnc := &InlineFunc(0)
	tcc_open_bf(s, c':inline:', 0)
	for {
		inline_generated = 0
		for i = 0; i < s.nb_inline_fns; i++ {
			fnc = s.inline_fns[i]
			sym = fnc.sym
			if sym != unsafe { nil } && (sym.c || !(sym.type_.t & 32768)) {
				fnc.sym = (unsafe { nil })
				tcc_debug_putfile(s, fnc.filename)
				begin_macro(fnc.func_str, 1)
				next()
				tcc_state.cur_text_section = tcc_state.text_section
				gen_function(sym)
				end_macro()
				inline_generated = 1
			}
		}
		// while()
		if !inline_generated {
			break
		}
	}
	tcc_close()
}

fn free_inline_functions(s &TCCState) {
	i := 0
	for i = 0; i < s.nb_inline_fns; i++ {
		fnc := s.inline_fns[i]
		if fnc.sym {
			tok_str_free(fnc.func_str)
		}
	}
	dynarray_reset(&s.inline_fns, &s.nb_inline_fns)
}

fn do_static_assert() {
	c := 0
	mut msg := ''
	next()
	skip(`(`)
	c = expr_const()
	msg = '_Static_assert fail'
	if tok == `,` {
		next()
		msg = cstring_to_vstring(parse_mult_str(c'string constant').data)
	}
	skip(`)`)
	if c == 0 {
		_tcc_error(msg)
	}
	skip(`;`)
}

fn decl(l int) int {
	v := 0
	has_init := 0
	r := 0
	oldint := 0

	type_ := CType{}
	btype := CType{}

	sym := &Sym(0)
	ad := AttributeDef{}
	adbase := AttributeDef{}

	for {
		vcc_trace('${@LOCATION}')
		oldint = 0
		vcc_trace_print('${@LOCATION} - decl.1 ${tok} ${l}')
		if !parse_btype(&btype, &adbase, l == vt_local) {
			vcc_trace('${@LOCATION}')
			if l == vt_jmp {
				return 0
			}
			if tok == `;` && l != vt_cmp {
				vcc_trace('${@LOCATION}')
				next()
				continue
			}
			if tok == Tcc_token.tok_static_assert {
				vcc_trace('${@LOCATION}')
				do_static_assert()
				continue
			}
			if l != vt_const {
				break
			}
			if tok == Tcc_token.tok_asm1 || tok == Tcc_token.tok_asm2 || tok == Tcc_token.tok_asm3 {
				vcc_trace('${@LOCATION}')
				asm_global_instr()
				continue
			}
			if tok >= Tcc_token.tok_define {
				btype.t = 3
				oldint = 1
			} else {
				vcc_trace('${@LOCATION} ${tok}')
				if tok != tok_eof {
					expect(c'declaration')
				}
				break
			}
		}
		if tok == `;` {
			if (btype.t & vt_btype) == vt_struct {
				vcc_trace('${@LOCATION} ${rune(tok)}')
				v = btype.ref.v
				if !(v & sym_field) && (v & ~sym_struct) >= sym_first_anom {
					_tcc_warning('unnamed struct/union that defines no instances')
				}
				next()
				continue
			}
			if ((btype.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
				vcc_trace('${@LOCATION}')
				next()
				continue
			}
		}
		for {
			type_ = btype
			ad = adbase
			vcc_trace('${@LOCATION}')
			type_decl(&type_, &ad, &v, 2)
			if (type_.t & 15) == 6 {
				if type_.t & 8192 && l != 48 {
					_tcc_error('function without file scope cannot be static')
				}
				sym = type_.ref
				if sym.f.func_type == 2 && l == 48 {
					func_vt = type_
					vcc_trace('${@LOCATION}')
					decl(51)
				}
				if type_.t & 4096 {
					type_.t &= ~32768
				}
			} else if oldint {
				_tcc_warning('type defaults to int')
			}
			if tcc_state.gnu_ext && (tok == Tcc_token.tok_asm1
				|| tok == Tcc_token.tok_asm2 || tok == Tcc_token.tok_asm3) {
				vcc_trace('${@LOCATION}')
				ad.asm_label = asm_label_instr()
				parse_attribute(&ad)
			}
			if tok == `{` {
				if l != 48 {
					_tcc_error('cannot use local functions')
				}
				if (type_.t & 15) != 6 {
					expect(c'function definition')
				}
				vcc_trace('${@LOCATION}')
				sym = type_.ref
				for {
					sym = sym.next
					if sym == unsafe { nil } {
						break
					}
					if !(sym.v & ~sym_field) {
						expect(c'identifier')
					}
					if sym.type_.t == 0 {
						sym.type_ = int_type
					}
				}
				vcc_trace('${@LOCATION}')
				merge_funcattr(&type_.ref.f, &ad.f)
				type_.t &= ~4096
				sym = external_sym(v, &type_, 0, &ad)
				if sym.type_.t & 32768 {
					fnc := &InlineFunc(tcc_malloc(sizeof(InlineFunc) + C.strlen(file.filename)))
					C.strcpy(fnc.filename, file.filename)
					fnc.sym = sym
					skip_or_save_block(&fnc.func_str)
					dynarray_add(&tcc_state.inline_fns, &tcc_state.nb_inline_fns, fnc)
				} else {
					tcc_state.cur_text_section = ad.section
					if !tcc_state.cur_text_section {
						tcc_state.cur_text_section = tcc_state.text_section
					}
					vcc_trace('${@LOCATION}')
					gen_function(sym)
				}
				break
			} else {
				if l == 51 {
					for sym = func_vt.ref.next; sym; sym = sym.next {
						if (sym.v & ~sym_field) == v {
							goto found // id: 0x7fffed53b268
						}
					}
					_tcc_error("declaration for parameter '${get_tok_str(v, (unsafe { nil }))}' but no such parameter")
					// RRRREG found id=0x7fffed53b268
					found:
					if type_.t & (4096 | 8192 | 16384 | 32768) {
						_tcc_error("storage class specified for '${get_tok_str(v, (unsafe { nil }))}'")
					}
					if sym.type_.t != 0 {
						_tcc_error("redefinition of parameter '${get_tok_str(v, (unsafe { nil }))}'")
					}
					convert_parameter_type(&type_)
					sym.type_ = type_
				} else if type_.t & 16384 {
					vcc_trace('${@LOCATION}')
					sym = sym_find(v)
					if sym && sym.sym_scope == local_scope {
						if !is_compatible_types(&sym.type_, &type_) || !(sym.type_.t & 16384) {
							_tcc_error("incompatible redefinition of '${get_tok_str(v,
								(unsafe { nil }))}'")
						}
						sym.type_ = type_
					} else {
						sym = sym_push(v, &type_, 0, 0)
					}
					sym.a = ad.a
					if (type_.t & 15) == 6 {
						merge_funcattr(&sym.type_.ref.f, &ad.f)
					}
					if debug_modes {
						tcc_debug_typedef(tcc_state, sym)
					}
				} else if (type_.t & 15) == 0 && !(type_.t & 4096) {
					_tcc_error('declaration of void object')
				} else {
					// vcc_trace('${@LOCATION}')
					r = 0
					if (type_.t & 15) == 6 {
						merge_funcattr(&type_.ref.f, &ad.f)
					} else if !(type_.t & 64) {
						r |= 256
					}
					has_init = (tok == `=`)
					if has_init && type_.t & 1024 {
						_tcc_error('variable length array cannot be initialized')
					}
					if (type_.t & 4096 && (!has_init || l != 48))
						|| (type_.t & 15) == 6
						|| (type_.t & 64 && !has_init && l == 48 && type_.ref.c < 0) {
						// vcc_trace('${@LOCATION}')
						type_.t |= 4096
						sym = external_sym(v, &type_, r, &ad)
						// vcc_trace('${@LOCATION}')
					} else {
						// vcc_trace('${@LOCATION}')
						if l == 48 || type_.t & 8192 {
							r |= 48
						} else { // 3
							r |= 50
						}
						if has_init {
							next()
						} else if l == 48 {
							type_.t |= 4096
						}
						decl_initializer_alloc(&type_, &ad, r, has_init, v, l == 48)
					}
					if ad.alias_target && l == 48 {
						// vcc_trace('${@LOCATION}')
						alias_target := sym_find(ad.alias_target)
						esym := elfsym(alias_target)
						if !esym {
							_tcc_error('unsupported forward __alias__ attribute')
						}
						put_extern_sym2(sym_find(v), esym.st_shndx, esym.st_value, esym.st_size,
							1)
					}
				}
				if tok != `,` {
					if l == 52 {
						// vcc_trace('${@LOCATION}')
						return 1
					}
					vcc_trace('${@LOCATION}')
					skip(`;`)
					vcc_trace('${@LOCATION}')
					break
				}
				// vcc_trace('${@LOCATION}')
				next()
			}
		}
	}
	vcc_trace('${@LOCATION}')
	return 0
}
