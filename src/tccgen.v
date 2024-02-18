@[translated]
module main

@[weak]
__global (
	file &BufferedFile
)

@[weak]
__global (
	tok int
)

@[weak]
__global (
	tokc CValue
)

@[weak]
__global (
	macro_ptr &int
)

@[weak]
__global (
	parse_flags int
)

@[weak]
__global (
	tokcstr CString
)

@[weak]
__global (
	tok_ident int
)

@[weak]
__global (
	table_ident &&TokenSym
)

fn tok_alloc(str &i8, len int) &TokenSym

fn tok_alloc_const(str &i8) int

fn get_tok_str(v int, cv &CValue) &i8

fn begin_macro(str &TokenString, alloc int)

fn end_macro()

fn tok_str_alloc() &TokenString

fn tok_str_free(s &TokenString)

fn tok_str_free_str(str &int)

fn tok_str_add(s &TokenString, t int)

fn tok_str_add_tok(s &TokenString)

fn free_defines(b &Sym)

fn preprocess(is_bof int)

fn next()

fn unget_tok(last_tok int)

fn skip(c int)

fn expect(msg &i8)

@[weak]
__global (
	global_stack &Sym
)

@[weak]
__global (
	local_stack &Sym
)

@[weak]
__global (
	local_label_stack &Sym
)

@[weak]
__global (
	global_label_stack &Sym
)

@[weak]
__global (
	define_stack &Sym
)

@[weak]
__global (
	int_type CType
)

@[weak]
__global (
	func_old_type CType
)

@[weak]
__global (
	char_pointer_type CType
)

@[weak]
__global (
	vtop &SValue
)

@[weak]
__global (
	rsym int
)

@[weak]
__global (
	anon_sym int
)

@[weak]
__global (
	ind int
)

@[weak]
__global (
	loc int
)

@[weak]
__global (
	debug_modes i8
)

@[weak]
__global (
	nocode_wanted int
)

@[weak]
__global (
	global_expr int
)

@[weak]
__global (
	func_vt CType
)

@[weak]
__global (
	func_var int
)

@[weak]
__global (
	func_vc int
)

@[weak]
__global (
	func_ind int
)

@[weak]
__global (
	funcname &i8
)

@[weak]
__global (
	sym_free_first &Sym
)

@[weak]
__global (
	sym_pools &voidptr
)

@[weak]
__global (
	nb_sym_pools int
)

@[weak]
__global (
	all_cleanups &Sym
)

@[weak]
__global (
	pending_gotos &Sym
)

@[weak]
__global (
	local_scope int
)

@[weak]
__global (
	_vstack [513]SValue
)

@[weak]
__global (
	char_type CType
)

@[weak]
__global (
	initstr CString
)

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

@[weak]
__global (
	cur_switch &Switch_t
)

struct Temp_local_variable {
	location int
	size     i16
	align    i16
}

@[weak]
__global (
	arr_temp_local_vars [8]Temp_local_variable
)

@[weak]
__global (
	nb_temp_local_vars int
)

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

@[weak]
__global (
	cur_scope &Scope
)

@[weak]
__global (
	loop_scope &Scope
)

@[weak]
__global (
	root_scope &Scope
)

struct Init_params {
	sec            &Section
	local_offset   int
	flex_array_ref &Sym
}

fn init_prec()

fn block(flags int)

fn gen_cast(type_ &CType)

fn gen_cast_s(t int)

fn pointed_type(type_ &CType) &CType

fn is_compatible_types(type1 &CType, type2 &CType) int

fn parse_btype(type_ &CType, ad &AttributeDef, ignore_label int) int

fn type_decl(type_ &CType, ad &AttributeDef, v &int, td int) &CType

fn parse_expr_type(type_ &CType)

fn init_putv(p &Init_params, type_ &CType, c u32)

fn decl_initializer(p &Init_params, type_ &CType, c u32, flags int)

fn decl_initializer_alloc(type_ &CType, ad &AttributeDef, r int, has_init int, v int, scope int)

fn decl(l int) int

fn expr_eq()

fn vpush_type_size(type_ &CType, a &int)

fn is_compatible_unqualified_types(type1 &CType, type2 &CType) int

fn expr_const64() i64

fn vpush64(ty int, v i64)

fn vpush(type_ &CType)

fn gvtst(inv int, t int) int

fn gen_inline_functions(s &TCCState)

fn free_inline_functions(s &TCCState)

fn skip_or_save_block(str &&TokenString)

fn gv_dup()

fn get_temp_local_var(size int, align int) int

fn clear_temp_local_var_list()

fn cast_error(st &CType, dt &CType)

fn gsym(t int) {
	if t {
		gsym_addr(t, ind)
		nocode_wanted &= ~536870912
	}
}

fn gind() int {
	t := ind
	nocode_wanted &= ~536870912
	if debug_modes {
		tcc_tcov_block_begin(tcc_state)
	}
	return t
}

fn gjmp_addr_acs(t int) {
	gjmp_addr(t)
	if !nocode_wanted {
		nocode_wanted |= 536870912
	}
}

fn gjmp_acs(t int) int {
	t = gjmp(t)
	if !nocode_wanted {
		nocode_wanted |= 536870912
	}
	return t
}

fn is_float(t int) int {
	bt := t & 15
	return bt == 10 || bt == 9 || bt == 8 || bt == 14
}

fn is_integer_btype(bt int) int {
	return bt == 1 || bt == 11 || bt == 2 || bt == 3 || bt == 4
}

fn btype_size(bt int) int {
	return if bt == 1 || bt == 11 {
		1
	} else {
		if bt == 2 {
			2
		} else {
			if bt == 3 {
				4
			} else {
				if bt == 4 {
					8
				} else {
					if bt == 5 {
						8
					} else {
						0
					}
				}
			}
		}
	}
}

@[c: 'R_RET']
fn r_ret(t int) int {
	if !is_float(t) {
		return treg_rax
	}
	if (t & 15) == 10 {
		return treg_st0
	}
	return treg_xmm0
}

@[c: 'R2_RET']
fn r2_ret(t int) int {
	t &= 15
	if t == 13 {
		return treg_rdx
	}
	if t == 14 {
		return treg_xmm1
	}
	return 48
}

@[c: 'PUT_R_RET']
fn put_r_ret(sv &SValue, t int) {
	sv.r = r_ret(t)
	sv.r2 = r2_ret(t)
}

@[c: 'RC_RET']
fn rc_ret(t int) int {
	return reg_classes[r_ret(t)] & ~(2 | 1)
}

@[c: 'RC_TYPE']
fn rc_type(t int) int {
	if !is_float(t) {
		return 1
	}
	if (t & 15) == 10 {
		return 128
	}
	if (t & 15) == 14 {
		return 4096
	}
	return 2
}

@[c: 'RC2_TYPE']
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
	if rc & 2 {
		return 2
	}
	return 1
}

fn ieee_finite(d f64) int {
	p := [4]int{}
	C.memcpy(p, &d, sizeof(f64))
	return (u32(((p[1] | 2148532223) + 1))) >> 31
}

fn test_lvalue() {
	if !(vtop.r & 256) {
		expect(c'lvalue')
	}
}

fn check_vstack() {
	if vtop != (_vstack + 1) - 1 {
		_tcc_error(c'internal compiler error: vstack leak (%d)', int((vtop - (_vstack + 1) + 1)))
	}
}

fn tccgen_init(s1 &TCCState) {
	vtop = (_vstack + 1) - 1
	C.memset(vtop, 0, sizeof(*vtop))
	int_type.t = 3
	char_type.t = 1
	if s1.char_is_unsigned {
		char_type.t |= 16
	}
	char_pointer_type = char_type
	mk_pointer(&char_pointer_type)
	func_old_type.t = 6
	func_old_type.ref = sym_push(536870912, &int_type, 0, 0)
	func_old_type.ref.f.func_call = 0
	func_old_type.ref.f.func_type = 2
	init_prec()
	cstr_new(&initstr)
}

fn tccgen_compile(s1 &TCCState) int {
	tcc_state.cur_text_section = (unsafe { nil })
	funcname = c''
	func_ind = -1
	anon_sym = 268435456
	nocode_wanted = 2147483648
	local_scope = 0
	debug_modes = (if s1.do_debug { 1 } else { 0 }) | s1.test_coverage << 1
	tcc_debug_start(s1)
	tcc_tcov_start(s1)
	parse_flags = 1 | 2 | 64
	next()
	decl(48)
	gen_inline_functions(s1)
	check_vstack()
	tcc_debug_end(s1)
	tcc_tcov_end(s1)
	return 0
}

fn tccgen_finish(s1 &TCCState) {
	tcc_debug_end(s1)
	free_inline_functions(s1)
	sym_pop(&global_stack, (unsafe { nil }), 0)
	sym_pop(&local_stack, (unsafe { nil }), 0)
	free_defines((unsafe { nil }))
	dynarray_reset(&sym_pools, &nb_sym_pools)
	sym_free_first = (unsafe { nil })
	global_label_stack = (unsafe { nil })
	local_label_stack = global_label_stack
	cstr_free(&initstr)
	dynarray_reset(&stk_data, &nb_stk_data)
}

fn elfsym(s &Sym) &Elf64_Sym {
	if !s || !s.c {
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
	if sym.type_.t & (8192 | 32768) {
		sym_bind = 0
	} else if sym.a.weak {
		sym_bind = 2
	} else { // 3
		sym_bind = 1
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
	name := &i8(0)
	buf1 := [256]i8{}
	if !sym.c {
		name = get_tok_str(sym.v, (unsafe { nil }))
		t = sym.type_.t
		if (t & 15) == 6 {
			sym_type = 2
		} else if (t & 15) == 0 {
			sym_type = 0
			if (t & (15 | ((0 | 1 << 20) | 2 << 20))) == ((0 | 1 << 20) | 2 << 20) {
				sym_type = 2
			}
		} else {
			sym_type = 1
		}
		if t & (8192 | 32768) {
			sym_bind = 0
		} else { // 3
			sym_bind = 1
		}
		other = 0
		if sym.asm_label {
			name = get_tok_str(sym.asm_label, (unsafe { nil }))
			can_add_underscore = 0
		}
		if tcc_state.leading_underscore && can_add_underscore {
			buf1[0] = `_`
			pstrcpy(buf1 + 1, sizeof(buf1) - 1, name)
			name = buf1
		}
		info = ((sym_bind << 4) + (sym_type & 15))
		sym.c = put_elf_sym(tcc_state.symtab_section, value, size, info, other, sh_num,
			name)
		if debug_modes {
			tcc_debug_extern_sym(tcc_state, sym, sh_num, sym_bind, sym_type)
		}
	} else {
		esym = elfsym(sym)
		esym.st_value = value
		esym.st_size = size
		esym.st_shndx = sh_num
	}
	update_storage(sym)
}

fn put_extern_sym(sym &Sym, s &Section, value Elf64_Addr, size u32) {
	if nocode_wanted && (nocode_wanted > 0 || (s && s == tcc_state.cur_text_section)) {
		return
	}
	put_extern_sym2(sym, if s { s.sh_num } else { 0 }, value, size, 1)
}

fn greloca(s &Section, sym &Sym, offset u32, type_ int, addend Elf64_Addr) {
	c := 0
	if nocode_wanted && s == tcc_state.cur_text_section {
		return
	}
	if sym {
		if 0 == sym.c {
			put_extern_sym(sym, (unsafe { nil }), 0, 0)
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
	sym_pool = tcc_malloc((8192 / sizeof(Sym)) * sizeof(Sym))
	dynarray_add(&sym_pools, &nb_sym_pools, sym_pool)
	last_sym = sym_free_first
	sym = sym_pool
	for i = 0; i < (8192 / sizeof(Sym)); i++ {
		sym.next = last_sym
		last_sym = sym
		sym++
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

fn sym_push2(ps &&Sym, v int, t int, c int) &Sym {
	s := &Sym(0)
	s = sym_malloc()
	C.memset(s, 0, sizeof(*s))
	s.v = v
	s.type_.t = t
	s.c = c
	s.prev = *ps
	*ps = s
	return s
}

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
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
		return unsafe { nil }
	}
	return table_ident[v].sym_struct
}

fn sym_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
		return unsafe { nil }
	}
	return table_ident[v].sym_identifier
}

fn sym_scope(s &Sym) int {
	if ((s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20)) {
		return s.type_.ref.sym_scope
	} else {
		return s.sym_scope
	}
}

fn sym_push(v int, type_ &CType, r int, c int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)

	ts := &TokenSym(0)
	if local_stack {
		ps = &local_stack
	} else { // 3
		ps = &global_stack
	}
	s = sym_push2(ps, v, type_.t, c)
	s.type_.ref = type_.ref
	s.r = r
	if !(v & 536870912) && (v & ~1073741824) < 268435456 {
		ts = table_ident[(v & ~1073741824) - 256]
		if v & 1073741824 {
			ps = &ts.sym_struct
		} else { // 3
			ps = &ts.sym_identifier
		}
		s.prev_tok = *ps
		*ps = s
		s.sym_scope = local_scope
		if s.prev_tok && sym_scope(s.prev_tok) == s.sym_scope {
			_tcc_error(c"redeclaration of '%s'", get_tok_str(v & ~1073741824, (unsafe { nil })))
		}
	}
	return s
}

fn global_identifier_push(v int, t int, c int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)

	s = sym_push2(&global_stack, v, t, c)
	s.r = 48 | 512
	if v < 268435456 {
		ps = &table_ident[v - 256].sym_identifier
		for *ps != (unsafe { nil }) && (*ps).sym_scope {
			ps = &(*ps).prev_tok
		}
		s.prev_tok = *ps
		*ps = s
	}
	return s
}

fn sym_pop(ptop &&Sym, b &Sym, keep int) {
	s := &Sym(0)
	ss := &Sym(0)
	ps := &&Sym(0)

	ts := &TokenSym(0)
	v := 0
	s = *ptop
	for s != b {
		ss = s.prev
		v = s.v
		if !(v & 536870912) && (v & ~1073741824) < 268435456 {
			ts = table_ident[(v & ~1073741824) - 256]
			if v & 1073741824 {
				ps = &ts.sym_struct
			} else { // 3
				ps = &ts.sym_identifier
			}
			*ps = s.prev_tok
		}
		if !keep {
			sym_free(s)
		}
		s = ss
	}
	if !keep {
		*ptop = b
	}
}

fn label_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
		return unsafe { nil }
	}
	return table_ident[v].sym_label
}

fn label_push(ptop &&Sym, v int, flags int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)

	s = sym_push2(ptop, v, 8192, 0)
	s.r = flags
	ps = &table_ident[v - 256].sym_label
	if ptop == &global_label_stack {
		for *ps != (unsafe { nil }) {
			ps = &(*ps).prev_tok
		}
	}
	s.prev_tok = *ps
	*ps = s
	return s
}

fn label_pop(ptop &&Sym, slast &Sym, keep int) {
	s := &Sym(0)
	s1 := &Sym(0)

	for s = *ptop; s != slast; s = s1 {
		s1 = s.prev
		if s.r == 2 {
			tcc_state.warn_num = (usize(&(&TCCState(0)).warn_all)) - (usize(&(&TCCState(0)).warn_none))
			_tcc_warning(c"label '%s' declared but not used", get_tok_str(s.v, (unsafe { nil })))
		} else if s.r == 1 {
			_tcc_error(c"label '%s' used but not defined", get_tok_str(s.v, (unsafe { nil })))
		} else {
			if s.c {
				put_extern_sym(s, tcc_state.cur_text_section, s.jnext, 1)
			}
		}
		if s.r != 3 {
			table_ident[s.v - 256].sym_label = s.prev_tok
		}
		if !keep {
			sym_free(s)
		} else { // 3
			s.r = 3
		}
	}
	if !keep {
		*ptop = slast
	}
}

fn vcheck_cmp() {
	if vtop.r == 51 && 0 == (nocode_wanted & ~536870912) {
		gv(1)
	}
}

fn vsetc(type_ &CType, r int, vc &CValue) {
	if vtop >= (_vstack + 1) + (512 - 1) {
		_tcc_error(c'memory full (vstack)')
	}
	vcheck_cmp()
	vtop++
	vtop.type_ = *type_
	vtop.r = r
	vtop.r2 = 48
	vtop.c = *vc
	vtop.sym = (unsafe { nil })
}

fn vswap() {
	tmp := SValue{}
	vcheck_cmp()
	tmp = vtop[0]
	vtop[0] = vtop[-1]
	vtop[-1] = tmp
}

fn vpop() {
	v := 0
	v = vtop.r & 63
	if v == treg_st0 {
		o(55517)
	} else if v == 51 {
		gsym(vtop.jtrue)
		gsym(vtop.jfalse)
	}
	vtop--
}

fn vpush(type_ &CType) {
	vset(type_, 48, 0)
}

fn vpush64(ty int, v i64) {
	cval := CValue{}
	ctype := CType{}
	ctype.t = ty
	ctype.ref = (unsafe { nil })
	cval.i = v
	vsetc(&ctype, 48, &cval)
}

fn vpushi(v int) {
	vpush64(3, v)
}

fn vpushs(v Elf64_Addr) {
	vpush64((2048 | 4 | 16), v)
}

fn vpushll(v i64) {
	vpush64(4, v)
}

fn vset(type_ &CType, r int, v int) {
	cval := CValue{}
	cval.i = v
	vsetc(type_, r, &cval)
}

fn vseti(r int, v int) {
	type_ := CType{}
	type_.t = 3
	type_.ref = (unsafe { nil })
	vset(&type_, r, v)
}

fn vpushv(v &SValue) {
	if vtop >= (_vstack + 1) + (512 - 1) {
		_tcc_error(c'memory full (vstack)')
	}
	vtop++
	*vtop = *v
}

fn vdup() {
	vpushv(vtop)
}

fn vrotb(n int) {
	i := 0
	tmp := SValue{}
	vcheck_cmp()
	tmp = vtop[-n + 1]
	for i = -n + 1; i != 0; i++ {
		vtop[i] = vtop[i + 1]
	}
	vtop[0] = tmp
}

fn vrote(e &SValue, n int) {
	i := 0
	tmp := SValue{}
	vcheck_cmp()
	tmp = *e
	for i = 0; i < n - 1; i++ {
		e[-i] = e[-i - 1]
	}
	e[-n + 1] = tmp
}

fn vrott(n int) {
	vrote(vtop, n)
}

@[c: 'vset_VT_CMP']
fn vset_vt_cmp(op int) {
	vtop.r = 51
	vtop.cmp_op = op
	vtop.jfalse = 0
	vtop.jtrue = 0
}

@[c: 'vset_VT_JMP']
fn vset_vt_jmp() {
	op := vtop.cmp_op
	if vtop.jtrue || vtop.jfalse {
		origt := vtop.type_.t
		inv := op & (op < 2)
		vseti(52 + inv, gvtst(inv, 0))
		vtop.type_.t |= origt & (16 | 32)
	} else {
		vtop.c.i = op
		if op < 2 {
			vtop.r = 48
		}
	}
}

fn gvtst_set(inv int, t int) {
	p := &int(0)
	if vtop.r != 51 {
		vpushi(0)
		gen_op(149)
		if vtop.r != 51 {
			vset_vt_cmp(vtop.c.i != 0)
		}
	}
	p = if inv { &vtop.jfalse } else { &vtop.jtrue }
	*p = gjmp_append(*p, t)
}

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
	if op > 1 {
		t = gjmp_cond(op ^ inv, t)
	} else if op != inv {
		t = gjmp_acs(t)
	}
	gsym(u)
	unsafe { vtop-- }
	return t
}

fn gen_test_zero(op int) {
	if vtop.r == 51 {
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

fn vpushsym(type_ &CType, sym &Sym) {
	cval := CValue{}
	cval.i = 0
	vsetc(type_, 48 | 512, &cval)
	vtop.sym = sym
}

fn get_sym_ref(type_ &CType, sec &Section, offset u32, size u32) &Sym {
	v := 0
	sym := &Sym(0)
	v = anon_sym++
	sym = sym_push(v, type_, 48 | 512, 0)
	sym.type_.t |= 8192
	put_extern_sym(sym, sec, offset, size)
	return sym
}

fn vpush_ref(type_ &CType, sec &Section, offset u32, size u32) {
	vpushsym(type_, get_sym_ref(type_, sec, offset, size))
}

fn external_global_sym(v int, type_ &CType) &Sym {
	s := &Sym(0)
	s = sym_find(v)
	if !s {
		s = global_identifier_push(v, type_.t | 4096, 0)
		s.type_.ref = type_.ref
	} else if ((s.type_.t & (15 | (0 | 1 << 20))) == (0 | 1 << 20)) {
		s.type_.t = type_.t | (s.type_.t & 4096)
		s.type_.ref = type_.ref
		update_storage(s)
	}
	return s
}

fn external_helper_sym(v int) &Sym {
	ct := CType{
		t: ((0 | 1 << 20) | 2 << 20)
		ref: (unsafe { nil })
	}

	return external_global_sym(v, &ct)
}

fn vpush_helper_func(v int) {
	vpushsym(&func_old_type, external_helper_sym(v))
}

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

fn patch_type(sym &Sym, type_ &CType) {
	if !(type_.t & 4096) || (sym.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20) {
		if !(sym.type_.t & 4096) {
			_tcc_error(c"redefinition of '%s'", get_tok_str(sym.v, (unsafe { nil })))
		}
		sym.type_.t &= ~4096
	}
	if ((sym.type_.t & (15 | (0 | 1 << 20))) == (0 | 1 << 20)) {
		sym.type_.t = type_.t & (sym.type_.t | ~8192)
		sym.type_.ref = type_.ref
	}
	if !is_compatible_types(&sym.type_, type_) {
		_tcc_error(c"incompatible types for redefinition of '%s'", get_tok_str(sym.v,
			(unsafe { nil })))
	} else if (sym.type_.t & 15) == 6 {
		static_proto := sym.type_.t & 8192
		if type_.t & 8192 && !static_proto && !((type_.t | sym.type_.t) & 32768) {
			_tcc_warning(c"static storage ignored for redefinition of '%s'", get_tok_str(sym.v,
				(unsafe { nil })))
		}
		if (type_.t | sym.type_.t) & 32768 {
			if !((type_.t ^ sym.type_.t) & 32768) || (type_.t | sym.type_.t) & 8192 {
				static_proto |= 32768
			}
		}
		if 0 == (type_.t & 4096) {
			f := sym.type_.ref.f
			sym.type_.t = (type_.t & ~(8192 | 32768)) | static_proto
			sym.type_.ref = type_.ref
			merge_funcattr(&sym.type_.ref.f, &f)
		} else {
			sym.type_.t &= ~32768 | static_proto
		}
		if sym.type_.ref.f.func_type == 2 && type_.ref.f.func_type != 2 {
			sym.type_.ref = type_.ref
		}
	} else {
		if sym.type_.t & 64 && type_.ref.c >= 0 {
			sym.type_.ref.c = type_.ref.c
		}
		if (type_.t ^ sym.type_.t) & 8192 {
			_tcc_warning(c"storage mismatch for redefinition of '%s'", get_tok_str(sym.v,
				(unsafe { nil })))
		}
	}
}

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

fn sym_copy(s0 &Sym, ps &&Sym) &Sym {
	s := &Sym(0)
	s = sym_malloc()
	*s = *s0
	s.prev = *ps
	*ps = s
	if s.v < 268435456 {
		ps = &table_ident[s.v - 256].sym_identifier
		s.prev_tok = *ps
		*ps = s
	}
	return s
}

fn sym_copy_ref(s &Sym, ps &&Sym) {
	bt := s.type_.t & 15
	if bt == 6 || bt == 5 || (bt == 7 && s.sym_scope) {
		sp := &s.type_.ref
		s = *sp
		*sp = unsafe { nil }
		for ; s; s = s.next {
			s2 := sym_copy(s, ps)
			*sp = s2
			sp = &s2.next
			sym_copy_ref(s2, ps)
		}
	}
}

fn external_sym(v int, type_ &CType, r int, ad &AttributeDef) &Sym {
	s := &Sym(0)
	s = sym_find(v)
	for s && s.sym_scope {
		s = s.prev_tok
	}
	if !s {
		s = global_identifier_push(v, type_.t, 0)
		s.r |= r
		s.a = ad.a
		s.asm_label = ad.asm_label
		s.type_.ref = type_.ref
		if local_stack {
			sym_copy_ref(s, &global_stack)
		}
	} else {
		patch_storage(s, ad, type_)
	}
	if local_stack && (s.type_.t & 15) != 6 {
		s = sym_copy(s, &local_stack)
	}
	return s
}

fn save_regs(n int) {
	p := &SValue(0)
	p1 := &SValue(0)

	p = _vstack + 1
	for p1 = vtop - n; p <= p1; p++ {
		save_reg(p.r)
	}
}

fn save_reg(r int) {
	save_reg_upstack(r, 0)
}

fn save_reg_upstack(r int, n int) {
	l := 0
	size := 0
	align := 0
	bt := 0

	p := &SValue(0)
	p1 := &SValue(0)
	sv := SValue{}
	r &= 63
	if r >= 48 {
		return
	}
	if nocode_wanted {
		return
	}
	l = 0
	p = (_vstack + 1)
	for p1 = vtop - n; p <= p1; p++ {
		if (p.r & 63) == r || p.r2 == r {
			if !l {
				bt = p.type_.t & 15
				if bt == 0 {
					continue
				}
				if p.r & 256 || bt == 6 {
					bt = 5
				}
				sv.type_.t = bt
				size = type_size(&sv.type_, &align)
				l = get_temp_local_var(size, align)
				sv.r = 50 | 256
				sv.c.i = l
				store(p.r & 63, &sv)
				if r == treg_st0 {
					o(55517)
				}
				if p.r2 < 48 && r2_ret(bt) != 48 {
					sv.c.i += 8
					store(p.r2, &sv)
				}
			}
			if p.r & 256 {
				p.r = (p.r & ~(63 | 32768)) | 49
			} else {
				p.r = 256 | 50
			}
			p.sym = (unsafe { nil })
			p.r2 = 48
			p.c.i = l
		}
	}
}

fn get_reg(rc int) int {
	r := 0
	p := &SValue(0)
	for r = 0; r < 25; r++ {
		if reg_classes[r] & rc {
			if nocode_wanted {
				return r
			}
			for p = (_vstack + 1); p <= vtop; p++ {
				if (p.r & 63) == r || p.r2 == r {
					goto notfound // id: 0x7fffed425a30
				}
			}
			return r
		}
		// RRRREG notfound id=0x7fffed425a30
		notfound:
		0
	}
	for p = (_vstack + 1); p <= vtop; p++ {
		r = p.r2
		if r < 48 && reg_classes[r] & rc {
			goto save_found // id: 0x7fffed426048
		}
		r = p.r & 63
		if r < 48 && reg_classes[r] & rc {
			// RRRREG save_found id=0x7fffed426048
			save_found:
			save_reg(r)
			return r
		}
	}
	return -1
}

fn get_temp_local_var(size int, align int) int {
	i := 0
	temp_var := &Temp_local_variable(0)
	found_var := 0
	p := &SValue(0)
	r := 0
	free := i8(0)
	found := i8(0)
	found = 0
	for i = 0; i < nb_temp_local_vars; i++ {
		temp_var = &arr_temp_local_vars[i]
		if temp_var.size < size || align != temp_var.align {
			continue
		}
		free = 1
		for p = (_vstack + 1); p <= vtop; p++ {
			r = p.r & 63
			if r == 50 || r == 49 {
				if p.c.i == temp_var.location {
					free = 0
					break
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

fn move_reg(r int, s int, t int) {
	sv := SValue{}
	if r != s {
		save_reg(r)
		sv.type_.t = t
		sv.type_.ref = (unsafe { nil })
		sv.r = s
		sv.c.i = 0
		load(r, &sv)
	}
}

fn gaddrof() {
	vtop.r &= ~256
	if (vtop.r & 63) == 49 {
		vtop.r = (vtop.r & ~63) | 50 | 256
	}
}

fn gen_bounded_ptr_add() {
	save := (vtop[-1].r & 63) == 50
	if save {
		vpushv(&vtop[-1])
		vrott(3)
	}
	vpush_helper_func(Tcc_token.tok___bound_ptr_add)
	vrott(3)
	gfunc_call(2)
	vtop -= save
	vpushi(0)
	vtop.r = treg_rax | 32768
	if nocode_wanted {
		return
	}
	vtop.c.i = (tcc_state.cur_text_section.reloc.data_offset - sizeof(Elf64_Rela))
}

fn gen_bounded_ptr_deref() {
	func := Elf64_Addr{}
	size := 0
	align := 0

	rel := &Elf64_Rela(0)
	sym := &Sym(0)
	if nocode_wanted {
		return
	}
	size = type_size(&vtop.type_, &align)
	match size {
		1 { // case comp body kind=BinaryOperator is_enum=false
			func = Tcc_token.tok___bound_ptr_indir1
		}
		2 { // case comp body kind=BinaryOperator is_enum=false
			func = Tcc_token.tok___bound_ptr_indir2
		}
		4 { // case comp body kind=BinaryOperator is_enum=false
			func = Tcc_token.tok___bound_ptr_indir4
		}
		8 { // case comp body kind=BinaryOperator is_enum=false
			func = Tcc_token.tok___bound_ptr_indir8
		}
		12 { // case comp body kind=BinaryOperator is_enum=false
			func = Tcc_token.tok___bound_ptr_indir12
		}
		16 { // case comp body kind=BinaryOperator is_enum=false
			func = Tcc_token.tok___bound_ptr_indir16
		}
		else {
			return
		}
	}
	sym = external_helper_sym(func)
	if !sym.c {
		put_extern_sym(sym, (unsafe { nil }), 0, 0)
	}
	rel = &Elf64_Rela((tcc_state.cur_text_section.reloc.data + vtop.c.i))
	rel.r_info = (((Elf64_Xword((sym.c))) << 32) + ((rel.r_info) & 4294967295))
}

fn gbound() {
	type1 := CType{}
	vtop.r &= ~16384
	if vtop.r & 256 {
		if !(vtop.r & 32768) {
			type1 = vtop.type_
			vtop.type_.t = 5
			gaddrof()
			vpushi(0)
			gen_bounded_ptr_add()
			vtop.r |= 256
			vtop.type_ = type1
		}
		gen_bounded_ptr_deref()
	}
}

fn gbound_args(nb_args int) {
	i := 0
	v := 0

	sv := &SValue(0)
	for i = 1; i <= nb_args; i++ {
		if vtop[1 - i].r & 16384 {
			vrotb(i)
			gbound()
			vrott(i)
		}
	}
	sv = vtop - nb_args
	if sv.r & 512 {
		v = sv.sym.v
		if v == Tcc_token.tok_setjmp || v == Tcc_token.tok__setjmp || v == Tcc_token.tok_sigsetjmp
			|| v == Tcc_token.tok___sigsetjmp {
			vpush_helper_func(Tcc_token.tok___bound_setjmp)
			vpushv(sv + 1)
			gfunc_call(1)
			func_bound_add_epilog = 1
		}
		if v == Tcc_token.tok_alloca {
			func_bound_add_epilog = 1
		}
	}
}

fn add_local_bounds(s &Sym, e &Sym) {
	for ; s != e; s = s.prev {
		if !s.v || (s.r & 63) != 50 {
			continue
		}
		if s.type_.t & 64 || (s.type_.t & 15) == 7 || s.a.addrtaken {
			align := 0
			size := type_size(&s.type_, &align)

			bounds_ptr := section_ptr_add(tcc_state.lbounds_section, 2 * sizeof(Elf64_Addr))
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
	vtop.type_.t = (2048 | 4)
	vpushs(offset)
	gen_op(`+`)
	vtop.r |= 256
	vtop.type_.t = t
}

fn incr_bf_adr(o int) {
	vtop.type_.t = 1 | 16
	incr_offset(o)
}

fn load_packed_bf(type_ &CType, bit_pos int, bit_size int) {
	n := 0
	o := 0
	bits := 0

	save_reg_upstack(vtop.r, 1)
	vpush64(type_.t & 15, 0)
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
			vpushi(bit_pos), gen_op(139), 0
			bit_pos = vpushi(bit_pos), gen_op(139)
		}
		if n < 8 {
			vpushi((1 << n) - 1), gen_op(`&`)
		}
		gen_cast(type_)
		if bits {
			vpushi(bits), gen_op(`<`)
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
	vswap(), vpop()
	if !(type_.t & 16) {
		n = (if (type_.t & 15) == 4 { 64 } else { 32 }) - bits
		vpushi(n), gen_op(`<`)
		vpushi(n), gen_op(`>`)
	}
}

fn store_packed_bf(bit_pos int, bit_size int) {
	bits := 0
	n := 0
	o := 0
	m := 0
	c := 0

	c = (vtop.r & (63 | 256 | 512)) == 48
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
			vpushi(bits), gen_op(139)
		}
		if bit_pos {
			vpushi(bit_pos), gen_op(`<`)
		}
		n = 8 - bit_pos
		if n > bit_size {
			n = bit_size
		}
		if n < 8 {
			m = ((1 << n) - 1) << bit_pos
			vpushi(m), gen_op(`&`)
			vpushv(vtop - 1)
			vpushi(if m & 128 { ~m & 127 } else { ~m })
			gen_op(`&`)
			gen_op(`|`)
		}

		vdup(), vtop[-1] = vtop[-2]
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
	vpop(), vpop()
}

fn adjust_bf(sv &SValue, bit_pos int, bit_size int) int {
	t := 0
	if 0 == sv.type_.ref {
		return 0
	}
	t = sv.type_.ref.auxtype
	if t != -1 && t != 7 {
		sv.type_.t = (sv.type_.t & ~(15 | 2048)) | t
		sv.r |= 256
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

	if vtop.type_.t & 128 {
		type_ := CType{}
		bit_pos = (((vtop.type_.t) >> 20) & 63)
		bit_size = (((vtop.type_.t) >> (20 + 6)) & 63)
		vtop.type_.t &= ~(((1 << (6 + 6)) - 1) << 20 | 128)
		type_.ref = (unsafe { nil })
		type_.t = vtop.type_.t & 16
		if (vtop.type_.t & 15) == 11 {
			type_.t |= 16
		}
		r = adjust_bf(vtop, bit_pos, bit_size)
		if (vtop.type_.t & 15) == 4 {
			type_.t |= 4
		} else { // 3
			type_.t |= 3
		}
		if r == 7 {
			load_packed_bf(&type_, bit_pos, bit_size)
		} else {
			bits := if (type_.t & 15) == 4 { 64 } else { 32 }
			gen_cast(&type_)
			vpushi(bits - (bit_pos + bit_size))
			gen_op(`<`)
			vpushi(bits - bit_size)
			gen_op(`>`)
		}
		r = gv(rc)
	} else {
		if is_float(vtop.type_.t) && (vtop.r & (63 | 256)) == 48 {
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
			vtop.r |= 256
		}
		if vtop.r & 16384 {
			gbound()
		}
		bt = vtop.type_.t & 15
		rc2 = rc2_type(bt, rc)
		r = vtop.r & 63
		r_ok = !(vtop.r & 256) && r < 48 && reg_classes[r] & rc
		r2_ok = !rc2 || (vtop.r2 < 48 && reg_classes[vtop.r2] & rc2)
		if !r_ok || !r2_ok {
			if !r_ok {
				if 1 && r < 48 && reg_classes[r] & rc && !rc2 {
					save_reg_upstack(r, 1)
				} else { // 3
					r = get_reg(rc)
				}
			}
			if rc2 {
				load_type := if (bt == 14) { 9 } else { (2048 | 4) }
				original_type := vtop.type_.t
				if (vtop.r & (63 | 256)) == 48 {
					ll := vtop.c.i
					vtop.c.i = ll
					load(r, vtop)
					vtop.r = r
					vpushi(ll >> 32)
				} else if vtop.r & 256 {
					save_reg_upstack(vtop.r, 1)
					vtop.type_.t = load_type
					load(r, vtop)
					vdup()
					vtop[-1].r = r
					incr_offset(8)
				} else {
					if !r_ok {
						load(r, vtop)
					}
					if r2_ok && vtop.r2 < 48 {
						goto _GOTO_PLACEHOLDER_0x7fffed4395d8 // id: 0x7fffed4395d8
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
				if vtop.r == 51 {
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
	if vtop.r != 51 && rc1 <= rc2 {
		vswap()
		gv(rc1)
		vswap()
		gv(rc2)
		if (vtop[-1].r & 63) >= 48 {
			vswap()
			gv(rc1)
			vswap()
		}
	} else {
		gv(rc2)
		vswap()
		gv(rc1)
		vswap()
		if (vtop[0].r & 63) >= 48 {
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
	x := (if a >> 63 { -a } else { a }) / (if b >> 63 { -b } else { b })
	return if (a ^ b) >> 63 { -x } else { x }
}

fn gen_opic_lt(a u64, b u64) int {
	return (a ^ u64(1) << 63) < (b ^ u64(1) << 63)
}

fn gen_opic(op int) {
	v1 := vtop - 1
	v2 := vtop
	t1 := v1.type_.t & 15
	t2 := v2.type_.t & 15
	c1 := (v1.r & (63 | 256 | 512)) == 48
	c2 := (v2.r & (63 | 256 | 512)) == 48
	l1 := if c1 { v1.c.i } else { 0 }
	l2 := if c2 { v2.c.i } else { 0 }
	shm := if (t1 == 4) { 63 } else { 31 }
	r := 0
	if t1 != 4 && (8 != 8 || t1 != 5) {
		l1 = (u32(l1) | (if v1.type_.t & 16 { 0 } else { -(l1 & 2147483648) }))
	}
	if t2 != 4 && (8 != 8 || t2 != 5) {
		l2 = (u32(l2) | (if v2.type_.t & 16 { 0 } else { -(l2 & 2147483648) }))
	}
	if c1 && c2 {
		match op {
			`+` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 += l2
			}
			`-` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 -= l2
			}
			`&` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 &= l2
			}
			`^` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 ^= l2
			}
			`|` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 |= l2
			}
			`*` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 *= l2
			}
			133, `/`, `%`, 131, 132 {
				if l2 == 0 {
					if nocode_wanted & 268369920 && !(nocode_wanted & 65535) {
						_tcc_error(c'division by zero in constant')
					}
					goto _GOTO_PLACEHOLDER_0x7fffed43f2b0 // id: 0x7fffed43f2b0
				}
				match op {
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
			`<` { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 <<= (l2 & shm)
			}
			139 { // case comp body kind=CompoundAssignOperator is_enum=false
				l1 >>= (l2 & shm)
			}
			`>` { // case comp body kind=BinaryOperator is_enum=false
				l1 = if (l1 >> 63) { ~(~l1 >> (l2 & shm)) } else { l1 >> (l2 & shm) }
			}
			146 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 < l2
			}
			147 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 >= l2
			}
			148 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 == l2
			}
			149 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 != l2
			}
			150 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 <= l2
			}
			151 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 > l2
			}
			156 { // case comp body kind=BinaryOperator is_enum=false
				l1 = gen_opic_lt(l1, l2)
			}
			157 { // case comp body kind=BinaryOperator is_enum=false
				l1 = !gen_opic_lt(l1, l2)
			}
			158 { // case comp body kind=BinaryOperator is_enum=false
				l1 = !gen_opic_lt(l2, l1)
			}
			159 { // case comp body kind=BinaryOperator is_enum=false
				l1 = gen_opic_lt(l2, l1)
			}
			144 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 && l2
			}
			145 { // case comp body kind=BinaryOperator is_enum=false
				l1 = l1 || l2
			}
			else {
				goto _GOTO_PLACEHOLDER_0x7fffed43f2b0 // id: 0x7fffed43f2b0
			}
		}
		if t1 != 4 && (8 != 8 || t1 != 5) {
			l1 = (u32(l1) | (if v1.type_.t & 16 { 0 } else { -(l1 & 2147483648) }))
		}
		v1.c.i = l1
		v1.r |= v2.r & 4096
		vtop--
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
			}
			vswap()
			vtop--
		} else if c2 && (((op == `*` || op == `/` || op == 131 || op == 133) && l2 == 1)
			|| ((op == `+` || op == `-` || op == `|` || op == `^` || op == `<` || op == 139
			|| op == `>`) && l2 == 0)
			|| (op == `&` && (l2 == -1 || (l2 == 4294967295 && t2 != 4)))) {
			vtop--
		} else if c2 && (op == `*` || op == 133 || op == 131) {
			if l2 > 0 && (l2 & (l2 - 1)) == 0 {
				n := -1
				for l2 {
					l2 >>= 1
					n++
				}
				vtop.c.i = n
				if op == `*` {
					op = `<`
				} else if op == 133 {
					op = `>`
				} else { // 3
					op = 139
				}
			}
			goto _GOTO_PLACEHOLDER_0x7fffed43f2b0 // id: 0x7fffed43f2b0
		} else if c2 && (op == `+` || op == `-`) && ((vtop[-1].r & (63 | 256 | 512)) == (48 | 512)
			|| (vtop[-1].r & (63 | 256 | 512)) == 5) {
			r = vtop[-1].r & (63 | 256 | 512)
			if op == `-` {
				l2 = -l2
			}
			l2 += vtop[-1].c.i
			if int(l2) != l2 {
				goto _GOTO_PLACEHOLDER_0x7fffed43f2b0 // id: 0x7fffed43f2b0
			}
			vtop--
			vtop.c.i = l2
		} else {
			// RRRREG general_case id=0x7fffed43f2b0
			general_case:
			if t1 == 4 || t2 == 4 || (8 == 8 && (t1 == 5 || t2 == 5)) {
				gen_opl(op)
			} else { // 3
				gen_opi(op)
			}
		}
		if vtop.r == 48 {
			vtop.r |= 4096
		}
	}
}

fn gen_opif(op int) {
	c1 := 0
	c2 := 0
	i := 0
	bt := 0

	v1 := &SValue(0)
	v2 := &SValue(0)

	f1 := 0.0
	f2 := 0.0

	v1 = vtop - 1
	v2 = vtop
	if op == 129 {
		v1 = v2
	}
	bt = v1.type_.t & 15
	c1 = (v1.r & (63 | 256 | 512)) == 48
	c2 = (v2.r & (63 | 256 | 512)) == 48
	if c1 && c2 {
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
		if !(ieee_finite(f1) || !ieee_finite(f2)) && !(nocode_wanted & 268369920) {
			goto general_case // id: 0x7fffed447ea8
		}
		match op {
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
					if !(nocode_wanted & 268369920) {
						goto general_case // id: 0x7fffed447ea8
					}
					x1.f = f1
					x2.f = f2
					if f1 == 0 {
						y.u = 2143289344
					} else { // 3
						y.u = 2139095040
					}
					y.u |= (x1.u ^ x2.u) & 2147483648
					f1 = y.f
				}
				f1 /= f2
			}
			129 { // case comp body kind=BinaryOperator is_enum=false
				f1 = -f1
				goto unary_result // id: 0x7fffed449028
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
				goto make_int // id: 0x7fffed449230
			}
			156 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 < f2
				goto make_int // id: 0x7fffed449230
			}
			157 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 >= f2
				goto make_int // id: 0x7fffed449230
			}
			158 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 <= f2
				goto make_int // id: 0x7fffed449230
			}
			159 { // case comp body kind=BinaryOperator is_enum=false
				i = f1 > f2
				goto make_int // id: 0x7fffed449230
			}
			else {
				goto general_case // id: 0x7fffed447ea8
			}
		}
		vtop--
		// RRRREG unary_result id=0x7fffed449028
		unary_result:
		if bt == 8 {
			v1.c.f = f1
		} else if bt == 9 {
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

fn type_to_str(buf &i8, buf_size int, type_ &CType, varstr &i8) {
	bt := 0
	v := 0
	t := 0

	s := &Sym(0)
	sa := &Sym(0)

	buf1 := [256]i8{}
	tstr := &i8(0)
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
	buf_size -= C.strlen(buf)
	buf += C.strlen(buf)
	match bt {
		0 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'void'
			goto add_tstr // id: 0x7fffed44c8d8
		}
		11 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'_Bool'
			goto add_tstr // id: 0x7fffed44c8d8
		}
		1 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'char'
			goto add_tstr // id: 0x7fffed44c8d8
		}
		2 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'short'
			goto add_tstr // id: 0x7fffed44c8d8
		}
		3 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'int'
			goto maybe_long // id: 0x7fffed44cd80
		}
		4 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'long long'
			// RRRREG maybe_long id=0x7fffed44cd80
			maybe_long:
			if t & 2048 {
				tstr = c'long'
			}
			if !((t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
				goto add_tstr // id: 0x7fffed44c8d8
			}
			tstr = c'enum '
			goto tstruct // id: 0x7fffed44d480
		}
		8 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'float'
			goto add_tstr // id: 0x7fffed44c8d8
		}
		9 { // case comp body kind=BinaryOperator is_enum=false
			tstr = c'double'
			if !(t & 2048) {
				goto add_tstr // id: 0x7fffed44c8d8
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
				buf2 := [256]i8{}
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
			goto no_var // id: 0x7fffed450020
		}
		5 { // case comp body kind=BinaryOperator is_enum=false
			s = type_.ref
			if t & (64 | 1024) {
				if varstr && `*` == *varstr {
					C.snprintf(buf1, sizeof(buf1), c'(%s)[%d]', varstr, s.c)
				} else { // 3
					C.snprintf(buf1, sizeof(buf1), c'%s[%d]', if varstr { varstr } else { c'' },
						s.c)
				}
				type_to_str(buf, buf_size, &s.type_, buf1)
				goto no_var // id: 0x7fffed450020
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
			goto no_var // id: 0x7fffed450020
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

fn type_incompatibility_error(st &CType, dt &CType, fmt &i8) {
	buf1 := [256]i8{}
	buf2 := [256]i8{}

	type_to_str(buf1, sizeof(buf1), st, (unsafe { nil }))
	type_to_str(buf2, sizeof(buf2), dt, (unsafe { nil }))
	_tcc_error(fmt, buf1, buf2)
}

fn type_incompatibility_warning(st &CType, dt &CType, fmt &i8) {
	buf1 := [256]i8{}
	buf2 := [256]i8{}

	type_to_str(buf1, sizeof(buf1), st, (unsafe { nil }))
	type_to_str(buf2, sizeof(buf2), dt, (unsafe { nil }))
	_tcc_warning(fmt, buf1, buf2)
}

fn pointed_size(type_ &CType) int {
	align := 0
	return type_size(pointed_type(type_), &align)
}

fn is_null_pointer(p &SValue) int {
	if (p.r & (63 | 256 | 512 | 4096)) != 48 {
		return 0
	}
	return ((p.type_.t & 15) == 3 && u32(p.c.i) == 0) || ((p.type_.t & 15) == 4 && p.c.i == 0) || ((p.type_.t & 15) == 5 && (if 8 == 4 {
		u32(p.c.i) == 0
	} else {
		p.c.i == 0
	}) && (pointed_type(&p.type_).t & 15) == 0 && 0 == (pointed_type(&p.type_).t & (256 | 512)))
}

fn is_compatible_func(type1 &CType, type2 &CType) int {
	s1 := &Sym(0)
	s2 := &Sym(0)

	s1 = type1.ref
	s2 = type2.ref
	if s1.f.func_call != s2.f.func_call {
		return 0
	}
	if s1.f.func_type != s2.f.func_type && s1.f.func_type != 2 && s2.f.func_type != 2 {
		return 0
	}
	for ; true; {
		if !is_compatible_unqualified_types(&s1.type_, &s2.type_) {
			return 0
		}
		if s1.f.func_type == 2 || s2.f.func_type == 2 {
			return 1
		}
		s1 = s1.next
		s2 = s2.next
		if !s1 {
			return !s2
		}
		if !s2 {
			return 0
		}
	}
}

fn compare_types(type1 &CType, type2 &CType, unqualified int) int {
	bt1 := 0
	t1 := 0
	t2 := 0

	t1 = type1.t & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
	t2 = type2.t & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
	if unqualified {
		t1 &= ~(256 | 512)
		t2 &= ~(256 | 512)
	}
	if (t1 & 15) != 1 {
		t1 &= ~32
		t2 &= ~32
	}
	if t1 != t2 {
		return 0
	}
	if t1 & 64 && !(type1.ref.c < 0 || type2.ref.c < 0 || type1.ref.c == type2.ref.c) {
		return 0
	}
	bt1 = t1 & 15
	if bt1 == 5 {
		type1 = pointed_type(type1)
		type2 = pointed_type(type2)
		return is_compatible_types(type1, type2)
	} else if bt1 == 7 {
		return type1.ref == type2.ref
	} else if bt1 == 6 {
		return is_compatible_func(type1, type2)
	} else if (type1.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)
		&& (type2.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20) {
		return type1.ref == type2.ref
	} else {
		return 1
	}
}

fn combine_types(dest &CType, op1 &SValue, op2 &SValue, op int) int {
	type1 := &op1.type_
	type2 := &op2.type_
	type_ := CType{}

	t1 := type1.t
	t2 := type2.t
	bt1 := t1 & 15
	bt2 := t2 & 15

	ret := 1
	type_.t = 0
	type_.ref = (unsafe { nil })
	if bt1 == 0 || bt2 == 0 {
		ret = if op == `?` { 1 } else { 0 }
		type_.t = 0
	} else if bt1 == 5 || bt2 == 5 {
		if op == `+` {
		} else if is_null_pointer(op2) {
			type_ = *type1
		} else if is_null_pointer(op1) {
			type_ = *type2
		} else if bt1 != bt2 {
			if (op == `?` || (op >= 144 && op <= 159))
				&& (is_integer_btype(bt1) || is_integer_btype(bt2)) {
				_tcc_warning(c'pointer/integer mismatch in %s', if op == `?` {
					c'conditional expression'
				} else {
					c'comparison'
				})
			} else if op != `-` || !is_integer_btype(bt2) {
				ret = 0
			}
			type_ = *(if bt1 == 5 { type1 } else { type2 })
		} else {
			pt1 := pointed_type(type1)
			pt2 := pointed_type(type2)
			pbt1 := pt1.t & 15
			pbt2 := pt2.t & 15
			newquals := 0
			copied := 0

			if pbt1 != 0 && pbt2 != 0 && !compare_types(pt1, pt2, 1) {
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
				type_ = *(if (pbt1 == 0) { type1 } else { type2 })
				newquals = ((pt1.t | pt2.t) & (256 | 512))
				if (~pointed_type(&type_).t & (256 | 512)) & newquals {
					type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref.c)
					copied = 1
					pointed_type(&type_).t |= newquals
				}
				if pt1.t & 64 && pt2.t & 64 && pointed_type(&type_).ref.c < 0
					&& (pt1.ref.c > 0 || pt2.ref.c > 0) {
					if !copied {
						type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref.c)
					}
					pointed_type(&type_).ref = sym_push(536870912, &pointed_type(&type_).ref.type_,
						0, pointed_type(&type_).ref.c)
					pointed_type(&type_).ref.c = if 0 < pt1.ref.c { pt1.ref.c } else { pt2.ref.c }
				}
			}
		}
		if (op >= 144 && op <= 159) {
			type_.t = (2048 | 4 | 16)
		}
	} else if bt1 == 7 || bt2 == 7 {
		if op != `?` || !compare_types(type1, type2, 1) {
			ret = 0
		}
		type_ = *type1
	} else if is_float(bt1) || is_float(bt2) {
		if bt1 == 10 || bt2 == 10 {
			type_.t = 10
		} else if bt1 == 9 || bt2 == 9 {
			type_.t = 9
		} else {
			type_.t = 8
		}
	} else if bt1 == 4 || bt2 == 4 {
		type_.t = 4 | 2048
		if bt1 == 4 {
			type_.t &= t1
		}
		if bt2 == 4 {
			type_.t &= t2
		}
		if (t1 & (15 | 16 | 128)) == (4 | 16) || (t2 & (15 | 16 | 128)) == (4 | 16) {
			type_.t |= 16
		}
	} else {
		type_.t = 3 | (2048 & (t1 | t2))
		if (t1 & (15 | 16 | 128)) == (3 | 16) || (t2 & (15 | 16 | 128)) == (3 | 16) {
			type_.t |= 16
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
	bt1 = t1 & 15
	bt2 = t2 & 15
	if bt1 == 6 || bt2 == 6 {
		if bt2 == 6 {
			mk_pointer(&vtop.type_)
			gaddrof()
		}
		if bt1 == 6 {
			vswap()
			mk_pointer(&vtop.type_)
			gaddrof()
			vswap()
		}
		goto _GOTO_PLACEHOLDER_0x7fffed462e40 // id: 0x7fffed462e40
	} else if !combine_types(&combtype, vtop - 1, vtop, op) {
		_tcc_error(c'invalid operand types for binary operation')
	} else if bt1 == 5 || bt2 == 5 {
		align := 0
		if (op >= 144 && op <= 159) {
			goto std_op // id: 0x7fffed463d50
		}
		if bt1 == 5 && bt2 == 5 {
			if op != `-` {
				_tcc_error(c'cannot use pointers here')
			}
			vpush_type_size(pointed_type(&vtop[-1].type_), &align)
			vrott(3)
			gen_opic(op)
			vtop.type_.t = (2048 | 4)
			vswap()
			gen_op(133)
		} else {
			if op != `-` && op != `+` {
				_tcc_error(c'cannot use pointers here')
			}
			if bt2 == 5 {
				vswap()
				t = t1
				t1 = t2
				t2 = t
			}
			type1 = vtop[-1].type_
			vpush_type_size(pointed_type(&vtop[-1].type_), &align)
			gen_op(`*`)
			if tcc_state.do_bounds_check && !(nocode_wanted & 268369920) {
				if op == `-` {
					vpushi(0)
					vswap()
					gen_op(`-`)
				}
				gen_bounded_ptr_add()
			} else {
				gen_opic(op)
			}
			type1.t &= ~(64 | 1024)
			vtop.type_ = type1
		}
	} else {
		if is_float(combtype.t) && op != `+` && op != `-` && op != `*` && op != `/` && !(op >= 144
			&& op <= 159) {
			_tcc_error(c'invalid operands for binary operation')
		} else if op == 139 || op == `>` || op == `<` {
			t = if bt1 == 4 { 4 } else { 3 }
			if (t1 & (15 | 16 | 128)) == (t | 16) {
				t |= 16
			}
			t |= (2048 & t1)
			combtype.t = t
		}
		// RRRREG std_op id=0x7fffed463d50
		std_op:
		t = combtype.t
		t2 = t
		if t & 16 {
			if op == `>` {
				op = 139
			} else if op == `/` {
				op = 131
			} else if op == `%` {
				op = 132
			} else if op == 156 {
				op = 146
			} else if op == 159 {
				op = 151
			} else if op == 158 {
				op = 150
			} else if op == 157 {
				op = 147
			}
		}
		vswap()
		gen_cast_s(t)
		vswap()
		if op == 139 || op == `>` || op == `<` {
			t2 = 3
		}
		gen_cast_s(t2)
		if is_float(t) {
			gen_opif(op)
		} else { // 3
			gen_opic(op)
		}
		if (op >= 144 && op <= 159) {
			vtop.type_.t = 3
		} else {
			vtop.type_.t = t
		}
	}
	if vtop.r & 256 {
		gv(if is_float(vtop.type_.t & 15) { 2 } else { 1 })
	}
}

fn gen_cvt_itof1(t int) {
	if (vtop.type_.t & (15 | 16)) == (4 | 16) {
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
	if t == (4 | 16) {
		st = vtop.type_.t & 15
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
	type_.ref = (unsafe { nil })
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

	if vtop.r & 3072 {
		force_charshort_cast()
	}
	if vtop.type_.t & 128 {
		gv(1)
	}
	dbt = type_.t & (15 | 16)
	sbt = vtop.type_.t & (15 | 16)
	if sbt == 6 {
		sbt = 5
	}
	// RRRREG again id=0x7fffed470288
	again:
	if sbt != dbt {
		sf = is_float(sbt)
		df = is_float(dbt)
		dbt_bt = dbt & 15
		sbt_bt = sbt & 15
		if dbt_bt == 0 {
			goto done // id: 0x7fffed46b878
		}
		if sbt_bt == 0 {
			// RRRREG error id=0x7fffed46baf8
			error:
			cast_error(&vtop.type_, type_)
		}
		c = (vtop.r & (63 | 256 | 512)) == 48
		if c {
			if sbt == 8 {
				vtop.c.ld = vtop.c.f
			} else if sbt == 9 {
				vtop.c.ld = vtop.c.d
			}
			if df {
				if sbt_bt == 4 {
					if sbt & 16 || !(vtop.c.i >> 63) {
						vtop.c.ld = vtop.c.i
					} else { // 3
						vtop.c.ld = -f64(-vtop.c.i)
					}
				} else if !sf {
					if sbt & 16 || !(vtop.c.i >> 31) {
						vtop.c.ld = u32(vtop.c.i)
					} else { // 3
						vtop.c.ld = -f64(-u32(vtop.c.i))
					}
				}
				if dbt == 8 {
					vtop.c.f = f32(vtop.c.ld)
				} else if dbt == 9 {
					vtop.c.d = f64(vtop.c.ld)
				}
			} else if sf && dbt == 11 {
				vtop.c.i = (vtop.c.ld != 0)
			} else {
				if sf {
					vtop.c.i = vtop.c.ld
				} else if sbt_bt == 4 || (8 == 8 && sbt == 5) {
				} else if sbt & 16 {
					vtop.c.i = u32(vtop.c.i)
				} else { // 3
					vtop.c.i = (u32(vtop.c.i) | -(vtop.c.i & 2147483648))
				}
				if dbt_bt == 4 || (8 == 8 && dbt == 5) {
				} else if dbt == 11 {
					vtop.c.i = (vtop.c.i != 0)
				} else {
					m := if dbt_bt == 1 {
						255
					} else {
						if dbt_bt == 2 { 65535 } else { 4294967295 }
					}
					vtop.c.i &= m
					if !(dbt & 16) {
						vtop.c.i |= -(vtop.c.i & ((m >> 1) + 1))
					}
				}
			}
			goto done // id: 0x7fffed46b878
		} else if dbt == 11 && (vtop.r & (63 | 256 | 512)) == (48 | 512) {
			vtop.r = 48
			vtop.c.i = 1
			goto done // id: 0x7fffed46b878
		}
		if nocode_wanted & 2147483648 {
			goto done // id: 0x7fffed46b878
		}
		if dbt == 11 {
			gen_test_zero(149)
			goto done // id: 0x7fffed46b878
		}
		if sf || df {
			if sf && df {
				gen_cvt_ftof(dbt)
			} else if df {
				gen_cvt_itof1(dbt)
			} else {
				sbt = dbt
				if dbt_bt != 4 && dbt_bt != 3 {
					sbt = 3
				}
				gen_cvt_ftoi1(sbt)
				goto _GOTO_PLACEHOLDER_0x7fffed470288 // id: 0x7fffed470288
			}
			goto done // id: 0x7fffed46b878
		}
		ds = btype_size(dbt_bt)
		ss = btype_size(sbt_bt)
		if ds == 0 || ss == 0 {
			goto _GOTO_PLACEHOLDER_0x7fffed46baf8 // id: 0x7fffed46baf8
		}
		if (type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20) && type_.ref.c < 0 {
			_tcc_error(c'cast to incomplete type')
		}
		if ds == ss && ds >= 4 {
			goto done // id: 0x7fffed46b878
		}
		if dbt_bt == 5 || sbt_bt == 5 {
			_tcc_warning(c'cast between pointer and integer of different size')
			if sbt_bt == 5 {
				vtop.type_.t = (if 8 == 8 { 4 } else { 3 })
			}
		}
		if 1 && vtop.r & 256 {
			if ds <= ss {
				goto done // id: 0x7fffed46b878
			}
			if ds <= 4 && !(dbt == (2 | 16) && sbt == 1) {
				gv(1)
				goto done // id: 0x7fffed46b878
			}
		}
		gv(1)
		trunc = 0
		if ds == 8 {
			if sbt & 16 {
				goto done // id: 0x7fffed46b878
			} else {
				gen_cvt_sxtw()
				goto done // id: 0x7fffed46b878
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
			goto done // id: 0x7fffed46b878
		}
		if ss == 4 {
			gen_cvt_csti(dbt)
			goto done // id: 0x7fffed46b878
		}
		bits = (ss - ds) * 8
		vtop.type_.t = (if ss == 8 { 4 } else { 3 }) | (dbt & 16)
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
	vtop.type_.t &= ~(256 | 512 | 64)
}

fn type_size(type_ &CType, a &int) int {
	s := &Sym(0)
	bt := 0
	bt = type_.t & 15
	if bt == 7 {
		s = type_.ref
		*a = s.r
		return s.c
	} else if bt == 5 {
		if type_.t & 64 {
			ts := 0
			s = type_.ref
			ts = type_size(&s.type_, a)
			if ts < 0 && s.c < 0 {
				ts = -ts
			}
			return ts * s.c
		} else {
			*a = 8
			return 8
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
	if type_.t & 1024 {
		type_size(&type_.ref.type_, a)
		vset(&int_type, 50 | 256, type_.ref.c)
	} else {
		size := type_size(type_, a)
		if size < 0 {
			_tcc_error(c'unknown type size')
		}
		vpushs(size)
	}
}

fn pointed_type(type_ &CType) &CType {
	return &type_.ref.type_
}

fn mk_pointer(type_ &CType) {
	s := &Sym(0)
	s = sym_push(536870912, type_, 0, -1)
	type_.t = 5 | (type_.t & (4096 | 8192 | 16384 | 32768))
	type_.ref = s
}

fn is_compatible_types(type1 &CType, type2 &CType) int {
	return compare_types(type1, type2, 0)
}

fn is_compatible_unqualified_types(type1 &CType, type2 &CType) int {
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
	dbt = dt.t & 15
	sbt = st.t & 15
	if dt.t & 256 {
		_tcc_warning(c'assignment of read-only location')
	}
	match dbt {
		0 { // case comp body kind=IfStmt is_enum=false
			if sbt != dbt {
				_tcc_error(c'assignment to void expression')
			}
		}
		5 { // case comp body kind=IfStmt is_enum=false
			if is_null_pointer(vtop) {
			}
			if is_integer_btype(sbt) {
				_tcc_warning(c'assignment makes pointer from integer without a cast')
			}
			type1 = pointed_type(dt)
			if sbt == 5 {
				type2 = pointed_type(st)
			} else if sbt == 6 {
				type2 = st
			} else { // 3
				goto error // id: 0x7fffed477eb8
			}
			if is_compatible_types(type1, type2) {
			}
			qualwarn = 0
			for lvl = qualwarn; true; lvl++ {
				if (type2.t & 256 && !(type1.t & 256)) || (type2.t & 512 && !(type1.t & 512)) {
					qualwarn = 1
				}
				dbt = type1.t & (15 | 2048)
				sbt = type2.t & (15 | 2048)
				if dbt != 5 || sbt != 5 {
				}
				type1 = pointed_type(type1)
				type2 = pointed_type(type2)
			}
			if !is_compatible_unqualified_types(type1, type2) {
				if (dbt == 0 || sbt == 0) && lvl == 0 {
				} else if dbt == sbt && is_integer_btype(sbt & 15)
					&& ((type1.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) + ((type2.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) + !!((type1.t ^ type2.t) & 16) < 2 {
				} else {
					_tcc_warning(c'assignment from incompatible pointer type')
				}
			}
			if qualwarn {
				tcc_state.warn_num = (usize(&(&TCCState(0)).warn_discarded_qualifiers)) - (usize(&(&TCCState(0)).warn_none))
				_tcc_warning(c'assignment discards qualifiers from pointer target type')
			}
		}
		1, 2, 3, 4 {
			if sbt == 5 || sbt == 6 {
				_tcc_warning(c'assignment makes integer from pointer without a cast')
			} else if sbt == 7 {
				goto case_VT_STRUCT // id: 0x7fffed47a4c8
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
		vpushv(vtop - 1)
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
		vdup(), vtop[-2]
		vtop[-1] = vdup()
		bit_pos = ((ft >> 20) & 63)
		bit_size = ((ft >> (20 + 6)) & 63)
		vtop[-1].type_.t = ft & ~(((1 << (6 + 6)) - 1) << 20 | 128)
		if dbt == 11 {
			gen_cast(&vtop[-1].type_)
			vtop[-1].type_.t = (vtop[-1].type_.t & ~15) | (1 | 16)
		}
		r = adjust_bf(vtop - 1, bit_pos, bit_size)
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
		vtop--$
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
			vtop.r |= (u32(((3072) & ~((3072) << 1))) * ((sbt == 4) + 1))
			vtop.type_.t = ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
		}
		if (vtop[-1].r & 63) == 49 {
			sv := SValue{}
			r = get_reg(1)
			sv.type_.t = (2048 | 4)
			sv.r = 50 | 256
			sv.c.i = vtop[-1].c.i
			load(r, &sv)
			vtop[-1].r = r | 256
		}
		r = vtop.r & 63
		if (r2_ret(dbt) != 48) {
			load_type := if (dbt == 14) { 9 } else { (2048 | 4) }
			vtop[-1].type_.t = load_type
			store(r, vtop - 1)
			vswap()
			incr_offset(8)
			vswap()
			store(vtop.r2, vtop - 1)
		} else {
			store(r, vtop - 1)
		}
		vswap()
		vtop--
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

fn parse_mult_str(msg &i8) &CString {
	if tok != 200 {
		expect(msg)
	}
	cstr_reset(&initstr)
	for tok == 200 {
		cstr_cat(&initstr, tokc.str.data, -1)
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

	astr := &i8(0)
	// RRRREG redo id=0x7fffed482e00
	redo:
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
		match t {
			.tok_cleanup1, .tok_cleanup2 {
				{
					s := &Sym(0)
					skip(`(`)
					s = sym_find(tok)
					if !s {
						tcc_state.warn_num = (usize(&(&TCCState(0)).warn_implicit_function_declaration)) - (usize(&(&TCCState(0)).warn_none))
						_tcc_warning(c"implicit declaration of function '%s'", get_tok_str(tok,
							&tokc))
						s = external_global_sym(tok, &func_old_type)
					} else if (s.type_.t & 15) != 6 {
						_tcc_error(c"'%s' is not declared as function", get_tok_str(tok,
							&tokc))
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
						_tcc_error(c'alignment must be a positive power of two')
					}
					skip(`)`)
				} else {
					n = 16
				}
				ad.a.aligned = exact_log2p1(n)
				if n != 1 << (ad.a.aligned - 1) {
					_tcc_error(c'alignment of %d is larger than implemented', n)
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
				match tok {
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
						_tcc_warning(c'__mode__(%s) not supported\n', get_tok_str(tok,
							(unsafe { nil })))
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
			else {
				tcc_state.warn_num = (usize(&(&TCCState(0)).warn_unsupported)) - (usize(&(&TCCState(0)).warn_none))
				_tcc_warning(c"'%s' attribute ignored", get_tok_str(t, (unsafe { nil })))
			}
		}
		if tok != `,` {
			break
		}
		next()
	}
	skip(`)`)
	skip(`)`)
	goto _GOTO_PLACEHOLDER_0x7fffed482e00 // id: 0x7fffed482e00
}

fn find_field(type_ &CType, v int, cumofs &int) &Sym {
	s := type_.ref
	v1 := v | 536870912
	if !(v & 536870912) {
		if (type_.t & 15) != 7 {
			expect(c'struct or union')
		}
		if v < Tcc_token.tok_define {
			expect(c'field name')
		}
		if s.c < 0 {
			_tcc_error(c"dereferencing incomplete type '%s'", get_tok_str(s.v & ~1073741824,
				0))
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
		if (s.type_.t & 15) == 7 && s.v >= (268435456 | 536870912) {
			ret := find_field(&s.type_, v1, cumofs)
			if ret {
				*cumofs += s.c
				return ret
			}
		}
	}
	if !(v & 536870912) {
		_tcc_error(c'field not found: %s', get_tok_str(v, (unsafe { nil })))
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
		v := s.v & ~536870912
		if v < 268435456 {
			ts := table_ident[v - 256]
			if check && ts.tok & 536870912 {
				_tcc_error(c"duplicate member '%s'", get_tok_str(v, (unsafe { nil })))
			}
			ts.tok ^= 536870912
		} else if (s.type_.t & 15) == 7 {
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
					goto new_field // id: 0x7fffed48fd90
				} else if !packed {
					a8 := align * 8
					ofs := ((c * 8 + bit_pos) % a8 + bit_size + a8 - 1) / a8
					if ofs > size / align {
						goto new_field // id: 0x7fffed48fd90
					}
				}
				if size == 8 && bit_size <= 32 {
					f.type_.t = (f.type_.t & ~15) | 3
					size = f4
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

@[c: 'do_Static_assert']
fn do_static_assert()

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

	C.memset(&ad, 0, sizeof(ad))
	next()
	parse_attribute(&ad)
	if tok != `{` {
		v = tok
		next()
		if v < 256 {
			expect(c'struct/union/enum name')
		}
		s = struct_find(v)
		if s && (s.sym_scope == local_scope || tok != `{`) {
			if u == s.type_.t {
				goto do_decl // id: 0x7fffed4970e8
			}
			if u == (2 << 20) && (s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20) {
				goto do_decl // id: 0x7fffed4970e8
			}
			_tcc_error(c"redefinition of '%s'", get_tok_str(v, (unsafe { nil })))
		}
	} else {
		v = anon_sym++
	}
	type1.t = if u == (2 << 20) { u | 3 | 16 } else { u }
	type1.ref = (unsafe { nil })
	s = sym_push(v | 1073741824, &type1, 0, -1)
	s.r = 0
	// RRRREG do_decl id=0x7fffed4970e8
	do_decl:
	type_.t = s.type_.t
	type_.ref = s
	if tok == `{` {
		next()
		if s.c != -1 {
			_tcc_error(c'struct/union/enum already defined')
		}
		s.c = -2
		ps = &s.next
		if u == (2 << 20) {
			ll := 0
			pl := 0
			nl := 0

			t := CType{}
			t.ref = s
			t.t = 3 | 8192 | (3 << 20)
			for ; true; {
				v = tok
				if v < Tcc_token.tok_define {
					expect(c'identifier')
				}
				ss = sym_find(v)
				if ss && !local_stack {
					_tcc_error(c"redefinition of enumerator '%s'", get_tok_str(v, (unsafe { nil })))
				}
				next()
				if tok == `=` {
					next()
					ll = expr_const64()
				}
				ss = sym_push(v, &t, 48, 0)
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
				ll++
				if tok == `}` {
					break
				}
			}
			skip(`}`)
			t.t = 3
			if nl >= 0 {
				if pl != u32(pl) {
					t.t = (if 8 == 8 { 4 | 2048 } else { 4 })
				}
				t.t |= 16
			} else if pl != int(pl) || nl != int(nl) {
				t.t = (if 8 == 8 { 4 | 2048 } else { 4 })
			}
			s.type_.t = t.t | (2 << 20)
			type_.t = s.type_.t
			s.c = 0
			for ss = s.next; ss; ss = ss.next {
				ll = ss.enum_val
				if ll == int(ll) {
					continue
				}
				if t.t & 16 {
					ss.type_.t |= 16
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
				for 1 {
					if flexible {
						_tcc_error(c"flexible array member '%s' not at the end of struct",
							get_tok_str(v, (unsafe { nil })))
					}
					bit_size = -1
					v = 0
					type1 = btype
					if tok != `:` {
						if tok != `;` {
							type_decl(&type1, &ad1, &v, 2)
						}
						if v == 0 {
							if (type1.t & 15) != 7 {
								expect(c'identifier')
							} else {
								v = btype.ref.v
								if !(v & 536870912) && (v & ~1073741824) < 268435456 {
									if tcc_state.ms_extensions == 0 {
										expect(c'identifier')
									}
								}
							}
						}
						if type_size(&type1, &align) < 0 {
							if u == 7 && type1.t & 64 && c {
								flexible = 1
							} else { // 3
								_tcc_error(c"field '%s' has incomplete type", get_tok_str(v,
									(unsafe { nil })))
							}
						}
						if (type1.t & 15) == 6 || (type1.t & 15) == 0
							|| type1.t & (4096 | 8192 | 16384 | 32768) {
							_tcc_error(c"invalid type for '%s'", get_tok_str(v, (unsafe { nil })))
						}
					}
					if tok == `:` {
						next()
						bit_size = expr_const()
						if bit_size < 0 {
							_tcc_error(c"negative width in bit-field '%s'", get_tok_str(v,
								(unsafe { nil })))
						}
						if v && bit_size == 0 {
							_tcc_error(c"zero width for bit-field '%s'", get_tok_str(v,
								(unsafe { nil })))
						}
						parse_attribute(&ad1)
					}
					size = type_size(&type1, &align)
					if bit_size >= 0 {
						bt = type1.t & 15
						if bt != 3 && bt != 1 && bt != 2 && bt != 11 && bt != 4 {
							_tcc_error(c'bitfields must have scalar type')
						}
						bsize = size * 8
						if bit_size > bsize {
							_tcc_error(c"width of '%s' exceeds its type", get_tok_str(v,
								(unsafe { nil })))
						} else if bit_size == bsize && !ad.a.packed && !ad1.a.packed {
							0
						} else if bit_size == 64 {
							_tcc_error(c'field width 64 not implemented')
						} else {
							type1.t = (type1.t & ~(((1 << (6 + 6)) - 1) << 20 | 128)) | 128 | (bit_size << (
								20 + 6))
						}
					}
					if v != 0 || (type1.t & 15) == 7 {
						c = 1
					}
					if v == 0 && ((type1.t & 15) == 7 || bit_size >= 0) {
						v = anon_sym++
					}
					if v {
						ss = sym_push(v | 536870912, &type1, 0, 0)
						ss.a = ad1.a
						*ps = ss
						ps = &ss.next
					}
					if tok == `;` || tok == (-1) {
						break
					}
					skip(`,`)
				}
				skip(`;`)
			}
			skip(`}`)
			parse_attribute(&ad)
			if ad.cleanup_func {
				_tcc_warning(c"attribute '__cleanup__' ignored on type")
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
	for type_.t & 64 {
		type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref.c)
		type_ = &type_.ref.type_
	}
	type_.t |= qualifiers
}

fn parse_btype(type_ &CType, ad &AttributeDef, ignore_label int) int {
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
	C.memset(ad, 0, sizeof(AttributeDef))
	type_found = 0
	typespec_found = 0
	t = 3
	bt = -1
	st = bt
	type_.ref = (unsafe { nil })
	for {
		match tok {
			.tok_extension { // case comp body kind=CallExpr is_enum=true
				next()
				continue
			}
			.tok_char { // case comp body kind=BinaryOperator is_enum=true
				u = 1
				// RRRREG basic_type id=0x7fffed4a2258
				basic_type:
				next()
				// RRRREG basic_type1 id=0x7fffed4a2ab0
				basic_type1:
				if u == 2 || u == 2048 {
					if st != -1 || (bt != -1 && bt != 3) {
						// RRRREG tmbt id=0x7fffed4a2690
						tmbt:
						_tcc_error(c'too many basic types')
					}
					st = u
				} else {
					if bt != -1 || (st != -1 && u != 3) {
						goto tmbt // id: 0x7fffed4a2690
					}
					bt = u
				}
				if u != 3 {
					t = (t & ~(15 | 2048)) | u
				}
				typespec_found = 1
			}
			.tok_void { // case comp body kind=BinaryOperator is_enum=true
				u = 0
				goto basic_type // id: 0x7fffed4a2258
			}
			.tok_short { // case comp body kind=BinaryOperator is_enum=true
				u = 2
				goto basic_type // id: 0x7fffed4a2258
			}
			.tok_int { // case comp body kind=BinaryOperator is_enum=true
				u = 3
				goto basic_type // id: 0x7fffed4a2258
			}
			.tok_alignas {
				// case comp stmt
				n = 0
				ad1 := AttributeDef{}
				next()
				skip(`(`)
				C.memset(&ad1, 0, sizeof(AttributeDef))
				if parse_btype(&type1, &ad1, 0) {
					type_decl(&type1, &ad1, &n, 1)
					if ad1.a.aligned {
						n = 1 << (ad1.a.aligned - 1)
					} else { // 3
						type_size(&type1, &n)
					}
				} else {
					n = expr_const()
					if n < 0 || (n & (n - 1)) != 0 {
						_tcc_error(c'alignment must be a positive power of two')
					}
				}
				skip(`)`)
				ad.a.aligned = exact_log2p1(n)
				continue
			}
			.tok_long { // case comp body kind=IfStmt is_enum=true
				if (t & 15) == 9 {
					t = (t & ~(15 | 2048)) | 10
				} else if (t & (15 | 2048)) == 2048 {
					t = (t & ~(15 | 2048)) | 4
				} else {
					u = 2048
					goto basic_type // id: 0x7fffed4a2258
				}
				next()
			}
			.tok_bool { // case comp body kind=BinaryOperator is_enum=true
				u = 11
				goto basic_type // id: 0x7fffed4a2258
			}
			.tok_complex { // case comp body kind=CallExpr is_enum=true
				_tcc_error(c'_Complex is not yet supported')
			}
			.tok_float { // case comp body kind=BinaryOperator is_enum=true
				u = 8
				goto basic_type // id: 0x7fffed4a2258
			}
			.tok_double { // case comp body kind=IfStmt is_enum=true
				if (t & (15 | 2048)) == 2048 {
					t = (t & ~(15 | 2048)) | 10
				} else {
					u = 9
					goto basic_type // id: 0x7fffed4a2258
				}
				next()
			}
			.tok_enum { // case comp body kind=CallExpr is_enum=true
				struct_decl(&type1, (2 << 20))
				// RRRREG basic_type2 id=0x7fffed4a4fc8
				basic_type2:
				u = type1.t
				type_.ref = type1.ref
				goto basic_type1 // id: 0x7fffed4a2ab0
			}
			.tok_struct { // case comp body kind=CallExpr is_enum=true
				struct_decl(&type1, 7)
				goto basic_type2 // id: 0x7fffed4a4fc8
			}
			.tok_union { // case comp body kind=CallExpr is_enum=true
				struct_decl(&type1, (1 << 20 | 7))
				goto basic_type2 // id: 0x7fffed4a4fc8
			}
			.tok__atomic { // case comp body kind=CallExpr is_enum=true
				next()
				type_.t = t
				parse_btype_qualify(type_, 512)
				t = type_.t
				if tok == `(` {
					parse_expr_type(&type1)
					type1.t &= ~((4096 | 8192 | 16384 | 32768) & ~16384)
					if type1.ref {
						sym_to_attr(ad, type1.ref)
					}
					goto basic_type2 // id: 0x7fffed4a4fc8
				}
			}
			.tok_const1, .tok_const2, .tok_const3 {
				type_.t = t
				parse_btype_qualify(type_, 256)
				t = type_.t
				next()
			}
			.tok_volatile1, .tok_volatile2, .tok_volatile3 {
				type_.t = t
				parse_btype_qualify(type_, 512)
				t = type_.t
				next()
			}
			.tok_signed1, .tok_signed2, .tok_signed3 {
				if (t & (32 | 16)) == (32 | 16) {
					_tcc_error(c'signed and unsigned modifier')
				}
				t |= 32
				next()
				typespec_found = 1
			}
			.tok_register, .tok_auto, .tok_restrict1, .tok_restrict2, .tok_restrict3 {
				next()
			}
			.tok_unsigned { // case comp body kind=IfStmt is_enum=true
				if (t & (32 | 16)) == 32 {
					_tcc_error(c'signed and unsigned modifier')
				}
				t |= 32 | 16
				next()
				typespec_found = 1
			}
			.tok_extern { // case comp body kind=BinaryOperator is_enum=true
				g = 4096
				goto storage // id: 0x7fffed4a8020
			}
			.tok_static { // case comp body kind=BinaryOperator is_enum=true
				g = 8192
				goto storage // id: 0x7fffed4a8020
			}
			.tok_typedef { // case comp body kind=BinaryOperator is_enum=true
				g = 16384
				goto storage // id: 0x7fffed4a8020
				// RRRREG storage id=0x7fffed4a8020
				storage:
				if t & (4096 | 8192 | 16384) & ~g {
					_tcc_error(c'multiple storage classes')
				}
				t |= g
				next()
			}
			.tok_inline1, .tok_inline2, .tok_inline3 {
				t |= 32768
				next()
			}
			.tok_noreturn3 { // case comp body kind=CallExpr is_enum=true
				next()
				ad.f.func_noreturn = 1
			}
			.tok_attribute1, .tok_attribute2 {
				parse_attribute(ad)
				if ad.attr_mode {
					u = ad.attr_mode - 1
					t = (t & ~(15 | 2048)) | u
				}
				continue
			}
			.tok_typeof1, .tok_typeof2, .tok_typeof3 {
				next()
				parse_expr_type(&type1)
				type1.t &= ~((4096 | 8192 | 16384 | 32768) & ~16384)
				if type1.ref {
					sym_to_attr(ad, type1.ref)
				}
				goto basic_type2 // id: 0x7fffed4a4fc8
			}
			.tok_thread_local { // case comp body kind=CallExpr is_enum=true
				_tcc_error(c'_Thread_local is not implemented')
				s = sym_find(tok)
				if !s || !(s.type_.t & 16384) {
					goto the_end // id: 0x7fffed4a9550
				}
				n = tok
				next()
				if tok == `:` && ignore_label {
					unget_tok(n)
					goto the_end // id: 0x7fffed4a9550
				}
				t &= ~(15 | 2048)
				u = t & ~(256 | 512)
				t ^= u
				type_.t = (s.type_.t & ~16384) | u
				type_.ref = s.type_.ref
				if t {
					parse_btype_qualify(type_, t)
				}
				t = type_.t
				sym_to_attr(ad, s)
				typespec_found = 1
				st = -2
				bt = st
			}
			else {
				if typespec_found {
					goto the_end // id: 0x7fffed4a9550
				}
			}
		}
		type_found = 1
	}
	// RRRREG the_end id=0x7fffed4a9550
	the_end:
	if tcc_state.char_is_unsigned {
		if (t & (32 | 15)) == 1 {
			t |= 16
		}
	}
	bt = t & (15 | 2048)
	if bt == 2048 {
		t |= if 8 == 8 { 4 } else { 3 }
	}
	type_.t = t
	return type_found
}

fn convert_parameter_type(pt &CType) {
	pt.t &= ~(256 | 512)
	pt.t &= ~(64 | 1024)
	if (pt.t & 15) == 6 {
		mk_pointer(pt)
	}
}

fn parse_asm_str() &CString {
	skip(`(`)
	return parse_mult_str(c'string constant')
}

fn asm_label_instr() int {
	v := 0
	astr := &i8(0)
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
	vla_array_tok := (unsafe { nil })
	vla_array_str := (unsafe { nil })
	if tok == `(` {
		next()
		if 2 == (td & (2 | 1)) {
			return 0
		}
		if tok == `)` {
			l = 0
		} else if parse_btype(&pt, &ad1, 0) {
			l = 1
		} else if td & (2 | 1) {
			merge_attr(ad, &ad1)
			return 0
		} else { // 3
			l = 2
		}
		first = (unsafe { nil })
		plast = &first
		arg_size = 0
		local_scope++$
		if l {
			for ; true; {
				if l != 2 {
					if (pt.t & 15) == 0 && tok == `)` {
						break
					}
					type_decl(&pt, &ad1, &n, 2 | 1 | 4)
					if (pt.t & 15) == 0 {
						_tcc_error(c'parameter declared as void')
					}
					if n == 0 {
						n = 536870912
					}
				} else {
					n = tok
					pt.t = 0
					pt.ref = (unsafe { nil })
					next()
				}
				if n < Tcc_token.tok_define {
					expect(c'identifier')
				}
				convert_parameter_type(&pt)
				arg_size += (type_size(&pt, &align) + 8 - 1) / 8
				s = sym_push(n, &pt, 50 | 256, 0)
				*plast = s
				plast = &s.next
				if tok == `)` {
					break
				}
				skip(`,`)
				if l == 1 && tok == 161 {
					l = 3
					next()
					break
				}
				if l == 1 && !parse_btype(&pt, &ad1, 0) {
					_tcc_error(c'invalid type')
				}
			}
		} else { // 3
			l = 2
		}
		skip(`)`)
		if first {
			sym_pop(if local_stack { &local_stack } else { &global_stack }, first.prev,
				1)
			for s = first; s; s = s.next {
				s.v |= 536870912
			}
		}
		local_scope--$
		type_.t &= ~256
		if tok == `[` {
			next()
			skip(`]`)
			mk_pointer(type_)
		}
		ad.f.func_args = arg_size
		ad.f.func_type = l
		s = sym_push(536870912, type_, 0, 0)
		s.a = ad.a
		s.f = ad.f
		s.next = first
		type_.t = 6
		type_.ref = s
	} else if tok == `[` {
		saved_nocode_wanted := nocode_wanted
		next()
		n = -1
		t1 = 0
		if td & 4 {
			for 1 {
				match tok {
					.tok_restrict1, .tok_restrict2, .tok_restrict3, .tok_const1, .tok_volatile1,
					.tok_static, `*` {
						next()
						continue
					}
					else {}
				}
				if tok != `]` {
					nocode_wanted = 1
					skip_or_save_block(&vla_array_tok)
					unget_tok(0)
					vla_array_str = vla_array_tok.str
					begin_macro(vla_array_tok, 2)
					next()
					gexpr()
					end_macro()
					next()
					goto check // id: 0x7fffed4b0ba0
				}
				break
			}
		} else if tok != `]` {
			if !local_stack || storage & 8192 {
				vpushi(expr_const())
			} else {
				nocode_wanted = 0
				gexpr()
			}
			// RRRREG check id=0x7fffed4b0ba0
			check:
			if (vtop.r & (63 | 256 | 512)) == 48 {
				n = vtop.c.i
				if n < 0 {
					_tcc_error(c'invalid array size')
				}
			} else {
				if !is_integer_btype(vtop.type_.t & 15) {
					_tcc_error(c'size of variable length array should be an integer')
				}
				n = 0
				t1 = 1024
			}
		}
		skip(`]`)
		post_type(type_, ad, storage, (td & ~(2 | 1)) | 8)
		if (type_.t & 15) == 6 {
			_tcc_error(c'declaration of an array of functions')
		}
		if (type_.t & 15) == 0 || type_size(type_, &align) < 0 {
			_tcc_error(c'declaration of an array of incomplete type elements')
		}
		t1 |= type_.t & 1024
		if t1 & 1024 {
			if n < 0 {
				if td & 8 {
					_tcc_error(c'need explicit inner array size in VLAs')
				}
			} else {
				loc -= type_size(&int_type, &align)
				loc &= -align
				n = loc
				vpush_type_size(type_, &align)
				gen_op(`*`)
				vset(&int_type, 50 | 256, n)
				vswap()
				vstore()
			}
		}
		if n != -1 {
			vpop()
		}
		nocode_wanted = saved_nocode_wanted
		s = sym_push(536870912, type_, 0, n)
		type_.t = (if t1 { 1024 } else { 64 }) | 5
		type_.ref = s
		if vla_array_str {
			if t1 & 1024 && td & 8 {
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

	storage = type_.t & (4096 | 8192 | 16384 | 32768)
	type_.t &= ~(4096 | 8192 | 16384 | 32768)
	post = type_
	ret = post
	for tok == `*` {
		qualifiers = 0
		// RRRREG redo id=0x7fffed4b4180
		redo:
		next()
		match tok {
			.tok__atomic { // case comp body kind=CompoundAssignOperator is_enum=true
				qualifiers |= 512
				goto redo // id: 0x7fffed4b4180
			}
			.tok_const1, .tok_const2, .tok_const3 {
				qualifiers |= 256
				goto redo // id: 0x7fffed4b4180
			}
			.tok_volatile1, .tok_volatile2, .tok_volatile3 {
				qualifiers |= 512
				goto redo // id: 0x7fffed4b4180
			}
			.tok_restrict1, .tok_restrict2, .tok_restrict3 {
				goto redo // id: 0x7fffed4b4180
			}
			.tok_attribute1, .tok_attribute2 {
				parse_attribute(ad)
			}
			else {}
		}
		mk_pointer(type_)
		type_.t |= qualifiers
		if ret == type_ {
			ret = pointed_type(type_)
		}
	}
	if tok == `(` {
		if !post_type(type_, ad, 0, td) {
			parse_attribute(ad)
			post = type_decl(type_, ad, v, td)
			skip(`)`)
		} else { // 3
			goto abstract // id: 0x7fffed4b5160
		}
	} else if tok >= 256 && td & 2 {
		*v = tok
		next()
	} else {
		// RRRREG abstract id=0x7fffed4b5160
		abstract:
		if !(td & 1) {
			expect(c'identifier')
		}
		*v = 0
	}
	post_type(post, ad, if post != ret { 0 } else { storage }, td & ~(2 | 1))
	parse_attribute(ad)
	type_.t |= storage
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
		_tcc_error(c'too many arguments to function')
	} else {
		type_ = arg.type_
		type_.t &= ~256
		gen_assign_cast(&type_)
	}
}

fn expr_type(type_ &CType, expr_fn fn ()) {
	nocode_wanted++
	expr_fn()
	*type_ = vtop.type_
	vpop()
	nocode_wanted--
}

fn parse_expr_type(type_ &CType) {
	n := 0
	ad := AttributeDef{}
	skip(`(`)
	if parse_btype(type_, &ad, 0) {
		type_decl(type_, &ad, &n, 1)
	} else {
		expr_type(type_, gexpr)
	}
	skip(`)`)
}

fn parse_type(type_ &CType) {
	ad := AttributeDef{}
	n := 0
	if !parse_btype(type_, &ad, 0) {
		expect(c'type')
	}
	type_decl(type_, &ad, &n, 1)
}

fn parse_builtin_params(nc int, args &i8) {
	c := i8(0)
	sep := `(`

	type_ := CType{}
	if nc {
		nocode_wanted++
	}
	next()
	if *args == 0 {
		skip(sep)
	}
	for {
		c = *args++
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
		match c {
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
	buf := [40]i8{}
	templates := [c'alm.?', c'Asm.v', c'alsm.v', c'aplbmm.b', c'avm.v', c'avm.v', c'avm.v', c'avm.v',
		c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v', c'avm.v']!

	template := templates[(atok - int(Tcc_token.tok___atomic_store))]
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
					_tcc_error(c'pointer target type mismatch in argument %d', arg + 1)
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
		if `.` == template[arg++$] {
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
	sprintf(buf, c'%s_%d', get_tok_str(atok, 0), size)
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
		tcc_debug_line(tcc_state), tcc_tcov_check_line(tcc_state, 1)
	}
	type_.ref = (unsafe { nil })
	// RRRREG tok_next id=0x7fffed4bf938
	tok_next:
	match tok {
		.tok_extension { // case comp body kind=CallExpr is_enum=true
			next()
			goto tok_next // id: 0x7fffed4bf938
		}
		193, 194, 192 {
			t = 3
			// RRRREG push_tokc id=0x7fffed4bfbc8
			push_tokc:
			type_.t = t
			vsetc(&type_, 48, &tokc)
			next()
		}
		195 { // case comp body kind=BinaryOperator is_enum=true
			t = 3 | 16
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		196 { // case comp body kind=BinaryOperator is_enum=true
			t = 4
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		197 { // case comp body kind=BinaryOperator is_enum=true
			t = 4 | 16
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		202 { // case comp body kind=BinaryOperator is_enum=true
			t = 8
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		203 { // case comp body kind=BinaryOperator is_enum=true
			t = 9
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		204 { // case comp body kind=BinaryOperator is_enum=true
			t = 10
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		198 { // case comp body kind=BinaryOperator is_enum=true
			t = (if 8 == 8 { 4 } else { 3 }) | 2048
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		199 { // case comp body kind=BinaryOperator is_enum=true
			t = (if 8 == 8 { 4 } else { 3 }) | 2048 | 16
			goto push_tokc // id: 0x7fffed4bfbc8
		}
		.tok___function__ { // case comp body kind=IfStmt is_enum=true
			if !tcc_state.gnu_ext {
				goto tok_identifier // id: 0x7fffed4c0830
			}
		}
		.tok___func__ { // case comp body kind=BinaryOperator is_enum=true
			tok = 200
			cstr_reset(&tokcstr)
			cstr_cat(&tokcstr, funcname, 0)
			tokc.str.size = tokcstr.size
			tokc.str.data = tokcstr.data
			goto case_TOK_STR // id: 0x7fffed4c0d38
		}
		201 { // case comp body kind=BinaryOperator is_enum=true
			t = 3
			goto str_init // id: 0x7fffed4c0e60
		}
		200 { // case comp body kind=LabelStmt is_enum=true
			// RRRREG case_TOK_STR id=0x7fffed4c0d38
			case_TOK_STR:
			t = char_type.t
			// RRRREG str_init id=0x7fffed4c0e60
			str_init:
			if tcc_state.warn_write_strings & 1 {
				t |= 256
			}
			type_.t = t
			mk_pointer(&type_)
			type_.t |= 64
			C.memset(&ad, 0, sizeof(AttributeDef))
			ad.section = tcc_state.rodata_section
			decl_initializer_alloc(&type_, &ad, 48, 2, 0, 0)
		}
		167, `(` {
			t = tok
			next()
			if parse_btype(&type_, &ad, 0) {
				type_decl(&type_, &ad, &n, 1)
				skip(`)`)
				if tok == `{` {
					if global_expr {
						r = 48
					} else { // 3
						r = 50
					}
					if !(type_.t & 64) {
						r |= 256
					}
					C.memset(&ad, 0, sizeof(AttributeDef))
					decl_initializer_alloc(&type_, &ad, r, 1, 0, 0)
				} else if t == 167 {
					vpush(&type_)
					return
				} else {
					unary()
					gen_cast(&type_)
				}
			} else if tok == `{` {
				saved_nocode_wanted := nocode_wanted
				if nocode_wanted & 268369920 && !(nocode_wanted & 65535) {
					expect(c'constant')
				}
				if 0 == local_scope {
					_tcc_error(c'statement expression outside of function')
				}
				save_regs(0)
				block(1)
				if saved_nocode_wanted {
					nocode_wanted = saved_nocode_wanted
				}
				skip(`)`)
			} else {
				gexpr()
				skip(`)`)
			}
		}
		`*` { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			indir()
		}
		`&` { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			if (vtop.type_.t & 15) != 6 && !(vtop.type_.t & (64 | 1024)) {
				test_lvalue()
			}
			if vtop.sym {
				vtop.sym.a.addrtaken = 1
			}
			mk_pointer(&vtop.type_)
			gaddrof()
		}
		`!` { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			gen_test_zero(148)
		}
		`~` { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			vpushi(-1)
			gen_op(`^`)
		}
		`+` { // case comp body kind=CallExpr is_enum=true
			next()
			unary()
			if (vtop.type_.t & 15) == 5 {
				_tcc_error(c'pointer not accepted for unary plus')
			}
			if !is_float(vtop.type_.t) {
				vpushi(0)
				gen_op(`+`)
			}
		}
		.tok_sizeof, .tok_alignof1, .tok_alignof2, .tok_alignof3 {
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
				s = (unsafe { nil })
				if vtop[1].r & 512 {
					s = vtop[1].sym
				}
				if s && s.a.aligned {
					align = 1 << (s.a.aligned - 1)
				}
				vpushs(align)
			}
		}
		.tok_builtin_expect { // case comp body kind=CallExpr is_enum=true
			parse_builtin_params(0, c'ee')
			vpop()
		}
		.tok_builtin_types_compatible_p { // case comp body kind=CallExpr is_enum=true
			parse_builtin_params(0, c'tt')
			vtop[-1].type_.t &= ~(256 | 512)
			vtop[0].type_.t &= ~(256 | 512)
			n = is_compatible_types(&vtop[-1].type_, &vtop[0].type_)
			vtop -= 2
			vpushi(n)
		}
		.tok_builtin_choose_expr {
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
		// 	 .tok_builtin_constant_p { // case comp body kind=CallExpr is_enum=true
		// 	parse_builtin_params(1, c'e')
		// 	n = 1
		// 	if (vtop.r & (63 | 256)) != 48 || ((vtop.r & 512) && vtop.sym.a.addrtaken) {
		// 	n = 0
		// 	}
		// 	vtop --
		// 	vpushi(n)
		// 	}
		//  .tok_builtin_frame_address, .tok_builtin_return_address {
		// {
		// 	tok1 := tok
		// 	level := i64(0)
		// 	next()
		// 	skip(`(`)
		// 	level = expr_const64()
		// 	if level < 0 {
		// 		_tcc_error(c'%s only takes positive integers', if tok1 == Tcc_token.tok_builtin_return_address{ c'__builtin_return_address' } else {c'__builtin_frame_address'})
		// 	}
		// 	skip(`)`)
		// 	type_.t = 0
		// 	mk_pointer(&type_)
		// 	vset(&type_, 50, 0)
		// 	for level -- {
		// 		mk_pointer(&vtop.type_)
		// 		indir()
		// 	}
		// 	if tok1 == Tcc_token.tok_builtin_return_address {
		// 		vpushi(8)
		// 		gen_op(`+`)
		// 		mk_pointer(&vtop.type_)
		// 		indir()
		// 	}
		// }
		// }
		//  .tok_builtin_va_arg_types { // case comp body kind=CallExpr is_enum=true
		// parse_builtin_params(0, c't')
		// vpushi(classify_x86_64_va_arg(&vtop.type_))
		// vswap()
		// vpop()
		// }
		//  .tok___atomic_store, .tok___atomic_load, .tok___atomic_exchange, .tok___atomic_compare_exchange, .tok___atomic_fetch_add, .tok___atomic_fetch_sub, .tok___atomic_fetch_or, .tok___atomic_fetch_xor, .tok___atomic_fetch_and, .tok___atomic_fetch_nand, .tok___atomic_add_fetch, .tok___atomic_sub_fetch, .tok___atomic_or_fetch, .tok___atomic_xor_fetch, .tok___atomic_and_fetch, .tok___atomic_nand_fetch {
		// parse_atomic(tok)
		// }
		//  130, 128 {
		// t = tok
		// next()
		// unary()
		// inc(0, t)
		// }
		`-` { // case comp body kind=CallExpr is_enum=true
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
		//  144 { // case comp body kind=IfStmt is_enum=true
		// if !tcc_state.gnu_ext {
		// goto tok_identifier // id: 0x7fffed4c0830
		// }
		// next()
		// if tok < Tcc_token.tok_define {
		// expect(c'label identifier')
		// }
		// s = label_find(tok)
		// if !s {
		// 	s = label_push(&global_label_stack, tok, 1)
		// }
		// else {
		// 	if s.r == 2 {
		// 	s.r = 1
		// 	}
		// }
		// if (s.type_.t & 15) != 5 {
		// 	s.type_.t = 0
		// 	mk_pointer(&s.type_)
		// 	s.type_.t |= 8192
		// }
		// vpushsym(&s.type_, s)
		// next()
		// }
		.tok_generic {
			// case comp stmt
			controlling_type := CType{}
			has_default := 0
			has_match := 0
			learn := 0
			str := (unsafe { nil })
			saved_nocode_wanted := nocode_wanted
			nocode_wanted &= ~268369920
			next()
			skip(`(`)
			expr_type(&controlling_type, expr_eq)
			convert_parameter_type(&controlling_type)
			nocode_wanted = saved_nocode_wanted
			for {
				learn = 0
				skip(`,`)
				if tok == .tok_default {
					if has_default {
						_tcc_error(c"too many 'default'")
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
							_tcc_error(c'type match twice')
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
					skip_or_save_block((unsafe { nil }))
				}
				if tok == `)` {
				}
			}
			if !str {
				buf := [60]i8{}
				type_to_str(buf, sizeof(buf), &controlling_type, (unsafe { nil }))
				_tcc_error(c"type '%s' does not match any association", buf)
			}
			begin_macro(str, 1)
			next()
			expr_eq()
			if tok != (-1) {
				expect(c',')
			}
			end_macro()
			next()
		}
		//  .tok___nan__ { // case comp body kind=BinaryOperator is_enum=true
		// n = 2143289344
		// // RRRREG special_math_val id=0x7fffed4cbd30
		// special_math_val:
		// vpushi(n)
		// vtop.type_.t = 8
		// next()
		// }
		//  .tok___snan__ { // case comp body kind=BinaryOperator is_enum=true
		// n = 2139095041
		// goto special_math_val // id: 0x7fffed4cbd30
		// }
		//  .tok___inf__ { // case comp body kind=BinaryOperator is_enum=true
		// n = 2139095040
		// goto special_math_val // id: 0x7fffed4cbd30
		// t = tok
		// next()
		// s = sym_find(t)
		// if !s || (((s).type_.t & (15 | (0 | 1 << 20))) == (0 | 1 << 20)) {
		// 	name := get_tok_str(t, (voidptr(0)))
		// 	if tok != `(` {
		// 	_tcc_error(c"'%s' undeclared", name)
		// 	}
		// 	tcc_state.warn_num = (usize(&(&TCCState(0)).warn_implicit_function_declaration)) - (usize(&(&TCCState(0)).warn_none))
		// 	_tcc_warning(c"implicit declaration of function '%s'", name)
		// 	s = external_global_sym(t, &func_old_type)
		// }
		// r = s.r
		// if (r & 63) < 48 {
		// r = (r & ~63) | 50
		// }
		// vset(&s.type_, r, s.c)
		// vtop.sym = s
		// if r & 512 {
		// 	vtop.c.i = 0
		// }
		// else if r == 48 && ((s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20)) {
		// 	vtop.c.i = s.enum_val
		// }
		// }
		else {
			// RRRREG tok_identifier id=0x7fffed4c0830
			tok_identifier:
			if tok < Tcc_token.tok_define {
				_tcc_error(c"expression expected before '%s'", get_tok_str(tok, &tokc))
			}
		}
	}
	for 1 {
		if tok == 130 || tok == 128 {
			inc(1, tok)
			next()
		} else if tok == `.` || tok == 160 {
			qualifiers := 0
			cumofs := 0

			if tok == 160 {
				indir()
			}
			qualifiers = vtop.type_.t & (256 | 512)
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
			next()
			gexpr()
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

			if (vtop.type_.t & 15) != 6 {
				if (vtop.type_.t & (15 | 64)) == 5 {
					vtop.type_ = *pointed_type(&vtop.type_)
					if (vtop.type_.t & 15) != 6 {
						goto error_func // id: 0x7fffed4d17c0
					}
				} else {
					// RRRREG error_func id=0x7fffed4d17c0
					error_func:
					expect(c'function pointer')
				}
			} else {
				vtop.r &= ~256
			}
			s = vtop.type_.ref
			next()
			sa = s.next
			nb_args = 0
			regsize = nb_args
			ret.r2 = 48
			if (s.type_.t & 15) == 7 {
				variadic = (s.f.func_type == 3)
				ret_nregs = gfunc_sret(&s.type_, variadic, &ret.type_, &ret_align, &regsize)
				if ret_nregs <= 0 {
					size = type_size(&s.type_, &align)
					loc = (loc - size) & -align
					ret.type_ = s.type_
					ret.r = 50 | 256
					vseti(50, loc)
					if tcc_state.do_bounds_check {
						loc--$
					}
					ret.c = vtop.c
					if ret_nregs < 0 {
						vtop--
					} else { // 3
						nb_args++
					}
				}
			} else {
				ret_nregs = 1
				ret.type_ = s.type_
			}
			if ret_nregs > 0 {
				ret.c.i = 0
				put_r_ret(&ret, ret.type_.t)
			}
			if tok != `)` {
				for ; true; {
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
				_tcc_error(c'too few arguments to function')
			}
			skip(`)`)
			gfunc_call(nb_args)
			if ret_nregs < 0 {
				vsetc(&ret.type_, ret.r, &ret.c)
			} else {
				n = ret_nregs
				for n > 1 {
					rc := reg_classes[ret.r] & ~(1 | 2)
					rc <<= n--$
					for r = 0; r < 25; r++ {
						if reg_classes[r] & rc {
							break
						}
					}
					vsetc(&ret.type_, r, &ret.c)
				}
				vsetc(&ret.type_, ret.r, &ret.c)
				vtop.r2 = ret.r2
				if (s.type_.t & 15) == 7 && ret_nregs {
					addr := 0
					offset := 0

					size = type_size(&s.type_, &align)
					size = (size + regsize - 1) & -regsize
					if ret_align > align {
						align = ret_align
					}
					loc = (loc - size) & -align
					addr = loc
					offset = 0
					for ; true; {
						vset(&ret.type_, 50 | 256, addr + offset)
						vswap()
						vstore()
						vtop--
						if ret_nregs--$ == 0 {
							break
						}
						offset += regsize
					}
					vset(&s.type_, 50 | 256, addr)
				}
				t = s.type_.t & 15
				if t == 1 || t == 2 || t == 11 {
					vtop.r |= (u32(((3072) & ~((3072) << 1))) * (1))
				}
			}
			if s.f.func_noreturn {
				if debug_modes {
					tcc_tcov_block_end(tcc_state, -1)
				}
				if !nocode_wanted {
					nocode_wanted |= 536870912
				}
			}
		} else {
			break
		}
	}
}

fn precedence(tok int) int {
	match tok {
		145 { // case comp body kind=ReturnStmt is_enum=false
			return 1
		}
		144 { // case comp body kind=ReturnStmt is_enum=false
			return 2
		}
		`|` { // case comp body kind=ReturnStmt is_enum=false
			return 3
		}
		`^` { // case comp body kind=ReturnStmt is_enum=false
			return 4
		}
		`&` { // case comp body kind=ReturnStmt is_enum=false
			return 5
		}
		148, 149 {
			return 6
			// RRRREG relat id=0x7fffed4d6a10
			relat:
		}
		`<`, `>` {
			return 8
		}
		`+`, `-` {
			return 9
		}
		`*`, `/`, `%` {
			return 10
			return 0
		}
		else {
			if tok >= 150 && tok <= 159 {
				goto relat // id: 0x7fffed4d6a10
			}
		}
	}
}

@[weak]
__global (
	prec [256]u8
)

fn init_prec() {
	i := 0
	for i = 0; i < 256; i++ {
		prec[i] = precedence(i)
	}
}

fn expr_landor(op int)

fn expr_infix(p int) {
	t := tok
	p2 := 0

	for {
		p2 = if u32(t) < 256 { prec[t] } else { 0 }
		if !(p2 >= p) {
			break
		}

		if t == 145 || t == 144 {
			expr_landor(t)
		} else {
			next()
			unary()
			if (if u32(tok) < 256 {
				prec[tok]
			} else {
				0
			}) > p2 {
				expr_infix(p2 + 1)
			}
			gen_op(t)
		}
		t = tok
	}
}

fn condition_3way() int {
	c := -1
	if (vtop.r & (63 | 256)) == 48 && (!(vtop.r & 512) || !vtop.sym.a.weak) {
		vdup()
		gen_cast_s(11)
		c = vtop.c.i
		vpop()
	}
	return c
}

fn expr_landor(op int) {
	t := 0
	cc := 1
	f := 0
	i := op == 144
	c := 0

	for ; true; {
		c = if f { i } else { condition_3way() }
		if c < 0 {
			save_regs(1), 0
			cc = save_regs(1)
		} else if c != i {
			nocode_wanted++, 1
			f = nocode_wanted++
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
		unary(), expr_infix((if u32(op) < 256 { prec[op] } else { 0 }) + 1)
	}
	if cc || f {
		vpop()
		vpushi(i ^ f)
		gsym(t)
		nocode_wanted -= f
	} else {
		gvtst_set(i, t)
	}
}

fn is_cond_bool(sv &SValue) int {
	if (sv.r & (63 | 256 | 512)) == 48 && (sv.type_.t & 15) == 3 {
		return u32(sv.c.i) < 2
	}
	if sv.r == 51 {
		return 1
	}
	return 0
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

	sv := SValue{}
	type_ := CType{}
	unary(), expr_infix(1)
	if tok == `?` {
		next()
		c = condition_3way()
		g = (tok == `:` && tcc_state.gnu_ext)
		tt = 0
		if !g {
			if c < 0 {
				save_regs(1)
				tt = gvtst(1, 0)
			} else {
				vpop()
			}
		} else if c < 0 {
			save_regs(1)
			gv_dup()
			tt = gvtst(0, 0)
		}
		if c == 0 {
			nocode_wanted++
		}
		if !g {
			gexpr()
		}
		if (vtop.type_.t & 15) == 6 {
			mk_pointer(&vtop.type_)
		}
		sv = *vtop
		vtop--
		if g {
			u = tt
		} else if c < 0 {
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
		if (vtop.type_.t & 15) == 6 {
			mk_pointer(&vtop.type_)
		}
		if !combine_types(&type_, &sv, vtop, `?`) {
			type_incompatibility_error(&sv.type_, &vtop.type_, c"type mismatch in conditional expression (have '%s' and '%s')")
		}
		if c < 0 && is_cond_bool(vtop) && is_cond_bool(&sv) {
			t1 = gvtst(0, 0)
			t2 = gjmp_acs(0)
			gsym(u)
			vpushv(&sv)
			gvtst_set(0, t1)
			gvtst_set(1, t2)
			gen_cast(&type_)
			return
		}
		islv = vtop.r & 256 && sv.r & 256 && 7 == (type_.t & 15)
		if c != 1 {
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
			r1 = gv(rc)
			move_reg(r2, r1, if islv { 5 } else { type_.t })
			vtop.r = r2
			gsym(tt)
		}
		if islv {
			indir()
		}
	}
}

fn expr_eq() {
	t := 0
	expr_cond()
	t = tok
	if t == `=` || (t >= 176 && t <= 185) {
		test_lvalue()
		next()
		if t == `=` {
			expr_eq()
		} else {
			vdup()
			expr_eq()
			gen_op((c'+-*/%&|^<>'[t - 176]))
		}
		vstore()
	}
}

fn gexpr() {
	expr_eq()
	if tok == `,` {
		for {
			vpop()
			next()
			expr_eq()
			// while()
			if !(tok == `,`) {
				break
			}
		}
		convert_parameter_type(&vtop.type_)
		if (vtop.r & 63) == 48 && nocode_wanted && !(nocode_wanted & 268369920) {
			gv(rc_type(vtop.type_.t))
		}
	}
}

fn expr_const1() {
	nocode_wanted += 65536
	expr_cond()
	nocode_wanted -= 65536
}

fn expr_const64() i64 {
	c := i64(0)
	expr_const1()
	if (vtop.r & (63 | 256 | 512 | 4096)) != 48 {
		expect(c'constant expression')
	}
	c = vtop.c.i
	vpop()
	return c
}

fn expr_const() int {
	c := 0
	wc := expr_const64()
	c = wc
	if c != wc && u32(c) != wc {
		_tcc_error(c'constant exceeds 32 bit')
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
			vset(&type_, 50 | 256, func_vc)
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
			if align & (ret_align - 1) && ((vtop.r & 63) < 48 || vtop.c.i & (ret_align - 1)) {
				loc = (loc - size) & -ret_align
				addr = loc
				type_ = *func_type
				vset(&type_, 50 | 256, addr)
				vswap()
				vstore()
				vpop()
				vset(&ret_type, 50 | 256, addr)
			}
			vtop.type_ = ret_type
			rc = rc_ret(ret_type.t)
			for n = ret_nregs; n > 0; {
				vdup()
				gv(rc)
				vswap()
				incr_offset(regsize)
				rc <<= 1
				n--
			}
			gv(rc)
			vtop -= ret_nregs - 1
		}
	} else {
		gv(rc_ret(func_type.t))
	}
	vtop--
}

fn check_func_return() {
	if (func_vt.t & 15) == 0 {
		return
	}
	if !C.strcmp(funcname, c'main') && (func_vt.t & 15) == 3 {
		vpushi(0)
		gen_assign_cast(&func_vt)
		gfunc_return(&func_vt)
	} else {
		_tcc_warning(c"function might return no value: '%s'", funcname)
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
	ll := (vtop.type_.t & 15) == 4
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
		p = *base++
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
	for ; cls != stop; cls = cls.ncl {
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
	ocd = if cleanupstate { cleanupstate.v & ~536870912 } else { 0 }
	ccd = cur_scope.cl.n
	for oc = cleanupstate; ocd > ccd; ocd--, oc = oc.ncl {
	}
	for cc = cur_scope.cl.s; ccd > ocd; ccd--, cc = cc.ncl {
	}
	for _ = 0; cc != oc; ccd-- {
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
				goto remove_pending // id: 0x7fffed4ea588
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
	v := (unsafe { nil })

	for ; c != o && c; c = c.prev {
		if c.vla.num {
			v = c
		}
	}
	if v {
		vla_restore(v.vla.locorig)
	}
}

fn new_scope(o &Scope) {
	*o = *cur_scope
	o.prev = cur_scope
	cur_scope = o
	cur_scope.vla.num = 0
	o.lstk = local_stack
	o.llstk = local_label_stack
	local_scope++$
}

fn prev_scope(o &Scope, is_expr int) {
	vla_leave(o.prev)
	if o.cl.s != o.prev.cl.s {
		block_cleanup(o.prev)
	}
	label_pop(&local_label_stack, o.llstk, is_expr)
	pop_local_syms(o.lstk, is_expr)
	cur_scope = o.prev
	local_scope--$
}

fn leave_scope(o &Scope) {
	if !o {
		return
	}
	try_call_scope_cleanup(o.cl.s)
	vla_leave(o)
}

fn new_scope_s(o &Scope) {
	o.lstk = local_stack
	local_scope++$
}

fn prev_scope_s(o &Scope) {
	sym_pop(&local_stack, o.lstk, 0)
	local_scope--$
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
	t = tok
	if (t >= 192 && t <= 207) {
		goto expr // id: 0x7fffed4f0d10
	}
	next()
	if debug_modes {
		tcc_tcov_check_line(tcc_state, 0), tcc_tcov_block_begin(tcc_state)
	}
	if t == Tcc_token.tok_if {
		new_scope_s(&o)
		skip(`(`)
		gexpr()
		skip(`)`)
		a = gvtst(1, 0)
		block(0)
		if tok == Tcc_token.tok_else {
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
		if debug_modes {
			tcc_debug_stabn(tcc_state, __stab_debug_code.n_lbrac, ind - func_ind)
		}
		new_scope(&o)
		for tok == Tcc_token.tok_label {
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
			decl(50)
			if tok != `}` {
				if flags & 1 {
					vpop()
				}
				block(flags | 2)
			}
		}
		prev_scope(&o, flags & 1)
		if debug_modes {
			tcc_debug_stabn(tcc_state, __stab_debug_code.n_rbrac, ind - func_ind)
		}
		if local_scope {
			next()
		} else if !nocode_wanted {
			check_func_return()
		}
	} else if t == Tcc_token.tok_return {
		b = (func_vt.t & 15) != 0
		if tok != `;` {
			gexpr()
			if b {
				gen_assign_cast(&func_vt)
			} else {
				if vtop.type_.t != 0 {
					_tcc_warning(c'void function returns a value')
				}
				vtop--
			}
		} else if b {
			_tcc_warning(c"'return' with no value")
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
			nocode_wanted |= 536870912
		}
	} else if t == Tcc_token.tok_break {
		if !cur_scope.bsym {
			_tcc_error(c'cannot break')
		}
		if cur_switch && cur_scope.bsym == cur_switch.bsym {
			leave_scope(cur_switch.scope)
		} else { // 3
			leave_scope(loop_scope)
		}
		*cur_scope.bsym = gjmp_acs(*cur_scope.bsym)
		skip(`;`)
	} else if t == Tcc_token.tok_continue {
		if !cur_scope.csym {
			_tcc_error(c'cannot continue')
		}
		leave_scope(loop_scope)
		*cur_scope.csym = gjmp_acs(*cur_scope.csym)
		skip(`;`)
	} else if t == Tcc_token.tok_for {
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
		sw.sv = *vtop--
		a = 0
		b = gjmp_acs(0)
		lblock(&a, (unsafe { nil }))
		a = gjmp_acs(a)
		gsym(b)
		prev_scope_s(&o)
		if sw.nocode_wanted {
			goto skip_switch // id: 0x7fffed4f7850
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
				_tcc_error(c'duplicate case value')
			}
		}
		vpushv(&sw.sv)
		gv(1)
		d = 0, gcase(sw.p, sw.n, &d)
		vpop()
		if sw.def_sym {
			gsym_addr(d, sw.def_sym)
		} else { // 3
			gsym(d)
		}
		// RRRREG skip_switch id=0x7fffed4f7850
		skip_switch:
		gsym(a)
		dynarray_reset(&sw.p, &sw.n)
		cur_switch = sw.prev
		tcc_free(sw)
	} else if t == Tcc_token.tok_case {
		cr := tcc_malloc(sizeof(Case_t))
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
				_tcc_warning(c'empty case range')
			}
		}
		if !cur_switch.nocode_wanted {
			cr.sym = gind()
		}
		dynarray_add(&cur_switch.p, &cur_switch.n, cr)
		skip(`:`)
		goto block_after_label // id: 0x7fffed4fa5a0
	} else if t == Tcc_token.tok_default {
		if !cur_switch {
			expect(c'switch')
		}
		if cur_switch.def_sym {
			_tcc_error(c"too many 'default'")
		}
		cur_switch.def_sym = if cur_switch.nocode_wanted { 1 } else { gind() }
		skip(`:`)
		goto block_after_label // id: 0x7fffed4fa5a0
	} else if t == Tcc_token.tok_goto {
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
				if cur_scope.cl.s && !nocode_wanted {
					sym_push2(&pending_gotos, 536870912, 0, cur_scope.cl.n)
					pending_gotos.prev_tok = s
					s = sym_push2(&s.next, 536870912, 0, 0)
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
		asm_instr()
	} else {
		if tok == `:` && t >= Tcc_token.tok_define {
			next()
			s = label_find(t)
			if s {
				if s.r == 0 {
					_tcc_error(c"duplicate label '%s'", get_tok_str(s.v, (unsafe { nil })))
				}
				s.r = 0
				if s.next {
					pcl := &Sym(0)
					for pcl = s.next; pcl; pcl = pcl.prev {
						gsym(pcl.jnext)
					}
					sym_pop(&s.next, (unsafe { nil }), 0)
				} else { // 3
					gsym(s.jnext)
				}
			} else {
				s = label_push(&global_label_stack, t, 0)
			}
			s.jnext = gind()
			s.cleanupstate = cur_scope.cl.s
			// RRRREG block_after_label id=0x7fffed4fa5a0
			block_after_label:
			{
				ad_tmp := AttributeDef{}
				parse_attribute(&ad_tmp)
			}
			if debug_modes {
				tcc_tcov_reset_ind(tcc_state)
			}
			vla_restore(cur_scope.vla.loc)
			if tok != `}` {
				if 0 == (flags & 2) {
					goto again // id: 0x7fffed4f0b70
				}
			} else {
				tcc_state.warn_num = (usize(&(&TCCState(0)).warn_all)) - (usize(&(&TCCState(0)).warn_none))
				_tcc_warning(c'deprecated use of label at end of compound statement')
			}
		} else {
			if t != `;` {
				unget_tok(t)
				// RRRREG expr id=0x7fffed4f0d10
				expr:
				if flags & 1 {
					vpop()
					gexpr()
				} else {
					gexpr()
					vpop()
				}
				skip(`;`)
			}
		}
	}
	if debug_modes {
		tcc_tcov_check_line(tcc_state, 0), tcc_tcov_block_end(tcc_state, 0)
	}
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
				_tcc_error(c'unexpected end of file')
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
				_tcc_error(c'initializer element is not constant')
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
		_tcc_error(c'internal compiler error\n%s:%d: in %s(): initializer overflow', c'/home/felipe/github/tcc/tccgen.c',
			7368, @FN)
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
	rel_end = &Elf64_Rela((sec.reloc.data + sec.reloc.data_offset))
	for rel < rel_end {
		if rel.r_offset >= c && rel.r_offset < c + size {
			sec.reloc.data_offset -= sizeof(*rel)
		} else {
			if rel2 != rel {
				C.memcpy(rel2, rel, sizeof(*rel))
			}
			rel2++$
		}
		rel++$
	}
}

fn decl_design_flex(p &Init_params, ref &Sym, index int) {
	if ref == p.flex_array_ref {
		if index >= ref.c {
			ref.c = index + 1
		}
	} else if ref.c < 0 {
		_tcc_error(c'flexible array has zero size in this context')
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
		goto no_designator // id: 0x7fffed508320
	}
	if tcc_state.gnu_ext && tok >= Tcc_token.tok_define {
		l = tok, next()
		if tok == `:` {
			goto struct_field // id: 0x7fffed508638
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
				_tcc_error(c'index exceeds array bounds or range is empty')
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
				_tcc_error(c'too many initializers')
			}
			type_ = pointed_type(type_)
			elem_size = type_size(type_, &align)
			c += index * elem_size
		} else {
			f = *cur_field
			for f && f.v & 268435456 && is_integer_btype(f.type_.t & 15) {
				*cur_field = f.next
				f = *cur_field
			}
			if !f {
				_tcc_error(c'too many initializers')
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
		if p.sec || type_.t & 64 {
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
	ptr := &voidptr(0)
	dtype := CType{}
	size := 0
	align := 0

	sec := p.sec
	val := u64(0)
	dtype = *type_
	dtype.t &= ~256
	size = type_size(type_, &align)
	if type_.t & 128 {
		size = ((((type_.t) >> 20) & 63) + (((type_.t) >> (20 + 6)) & 63) + 7) / 8
	}
	init_assert(p, c + size)
	if sec {
		gen_assign_cast(&dtype)
		bt = type_.t & 15
		if vtop.r & 512 && bt != 5 && (bt != (if 8 == 8 {
			4
		} else {
			3
		}) || type_.t & 128) && !(vtop.r & 48 && vtop.sym.v >= 268435456) {
			_tcc_error(c'initializer element is not computable at load time')
		}
		if (nocode_wanted > 0) {
			vtop--
			return
		}
		ptr = sec.data + c
		val = vtop.c.i
		if (vtop.r & (512 | 48)) == (512 | 48) && vtop.sym.v >= 268435456
			&& (vtop.type_.t & 15) != 5 {
			ssec := &Section(0)
			esym := &Elf64_Sym(0)
			rel := &Elf64_Rela(0)
			esym = elfsym(vtop.sym)
			ssec = tcc_state.sections[esym.st_shndx]
			C.memmove(ptr, ssec.data + esym.st_value + int(vtop.c.i), size)
			if ssec.reloc {
				relofs := ssec.reloc.data_offset
				for relofs >= sizeof(*rel) {
					relofs -= sizeof(*rel)
					rel = &Elf64_Rela((ssec.reloc.data + relofs))
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
			if type_.t & 128 {
				bit_pos := 0
				bit_size := 0
				bits := 0
				n := 0

				p = &u8(0)
				v := u8(0)
				m := u8(0)

				bit_pos = (((vtop.type_.t) >> 20) & 63)
				bit_size = (((vtop.type_.t) >> (20 + 6)) & 63)
				p = &u8(ptr) + (bit_pos >> 3)
				bit_pos &= 7, 0
				bits = 0
				for bit_size {
					n = 8 - bit_pos
					if n > bit_size {
						n = bit_size
					}
					v = val >> bits << bit_pos
					m = ((1 << n) - 1) << bit_pos
					*p = (*p & ~m) | (v & m)
					bits += n
					bit_size -= n
					bit_pos = 0
					p++
				}
			} else { // 3
			}
		}
		vtop--
	} else {
		vset(&dtype, 50 | 256, c)
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
	if debug_modes && !(flags & 2) && !p.sec {
		tcc_debug_line(tcc_state), tcc_tcov_check_line(tcc_state, 1)
	}
	if !(flags & 4) && tok != `{` && tok != 201 && tok != 200 && (!(flags & 2)
		|| (type_.t & 15) == 7) {
		ncw_prev := nocode_wanted
		if flags & 2 && !p.sec {
			nocode_wanted++$
		}
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
				_tcc_error(c'unhandled string literal merging')
			}
			for tok == 200 || tok == 201 {
				if initstr.size {
					initstr.size -= size1
				}
				if tok == 200 {
					len += tokc.str.size
				} else { // 3
					len += tokc.str.size / sizeof(Nwchar_t)
				}
				len--
				cstr_cat(&initstr, tokc.str.data, tokc.str.size)
				next()
			}
			if tok != `)` && tok != `}` && tok != `,` && tok != `;` && tok != (-1) {
				unget_tok(if size1 == 1 { 200 } else { 201 })
				tokc.str.size = initstr.size
				tokc.str.data = initstr.data
				goto do_init_array // id: 0x7fffed520228
			}
			decl_design_flex(p, s, len)
			if !(flags & 2) {
				nb := n
				ch := 0

				if len < nb {
					nb = len
				}
				if len > nb {
					_tcc_warning(c'initializer-string for array is too long')
				}
				if p.sec && size1 == 1 {
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
			decl_design_flex(p, s, len)
			for tok != `}` || flags & 4 {
				len = decl_designator(p, type_, c, &f, flags, len)
				flags &= ~4
				if type_.t & 64 {
					indexsym.c++$
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
		goto _GOTO_PLACEHOLDER_0x7fffed5235f8 // id: 0x7fffed5235f8
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
		decl_initializer(p, type_, c, flags & ~4)
		skip(`}`)
	} else { // 3
	}
}

fn decl_initializer_alloc(type_ &CType, ad &AttributeDef, r int, has_init int, v int, global int) {
	size := 0
	align := 0
	addr := 0

	init_str := (unsafe { nil })
	sec := &Section(0)
	flexible_array := &Sym(0)
	sym := &Sym(0)
	saved_nocode_wanted := nocode_wanted
	bcheck := tcc_state.do_bounds_check && !(nocode_wanted > 0)
	p := Init_params{
		sec: 0
	}

	if v && (r & 63) == 48 {
		nocode_wanted |= 2147483648
	}
	flexible_array = (unsafe { nil })
	size = type_size(type_, &align)
	if size < 0 {
		if !(type_.t & 64) {
			_tcc_error(c'initialization of incomplete type')
		}
		type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref.c)
		p.flex_array_ref = type_.ref
	} else if has_init && (type_.t & 15) == 7 {
		field := type_.ref.next
		if field {
			for field.next {
				field = field.next
			}
			if field.type_.t & 64 && field.type_.ref.c < 0 {
				flexible_array = field
				p.flex_array_ref = field.type_.ref
				size = -1
			}
		}
	}
	if size < 0 {
		if !has_init {
			_tcc_error(c'unknown type size')
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
		macro_ptr = init_str.str
		next()
		size = type_size(type_, &align)
		if size < 0 {
			_tcc_error(c'unknown type size')
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
	if (r & 63) == 50 {
		sec = (unsafe { nil })
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
					r = (r & ~63) | reg
				}
			}
			sym = sym_push(v, type_, r, addr)
			if ad.cleanup_func {
				cls := sym_push2(&all_cleanups, 536870912 | cur_scope.cl.n++$, 0, 0)
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
		sym = (unsafe { nil })
		if v && global {
			sym = sym_find(v)
			if sym {
				if p.flex_array_ref && sym.type_.t & type_.t & 64 && sym.type_.ref.c > type_.ref.c {
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
				sym = sym_push(v, type_, r | 512, 0)
				patch_storage(sym, ad, (unsafe { nil }))
			}
			put_extern_sym(sym, sec, addr, size)
		} else {
			vpush_ref(type_, sec, addr, size)
			sym = vtop.sym
			vtop.r |= r
		}
		if bcheck {
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
			goto no_alloc // id: 0x7fffed52b7b8
		}
		if cur_scope.vla.num == 0 {
			if cur_scope.prev && cur_scope.prev.vla.num {
				cur_scope.vla.locorig = cur_scope.prev.vla.loc
			} else {
				loc -= 8
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
}

fn func_vla_arg_code(arg &Sym) {
	align := 0
	vla_array_tok := (unsafe { nil })
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
	f := Scope{
		prev: 0
	}

	cur_scope = &f
	root_scope = cur_scope
	nocode_wanted = 0
	ind = tcc_state.cur_text_section.data_offset
	if sym.a.aligned {
		newoff := section_add(tcc_state.cur_text_section, 0, 1 << (sym.a.aligned - 1))
		gen_fill_nops(newoff - ind)
	}
	funcname = get_tok_str(sym.v, (unsafe { nil }))
	func_ind = ind
	func_vt = sym.type_.ref.type_
	func_var = sym.type_.ref.f.func_type == 3
	put_extern_sym(sym, tcc_state.cur_text_section, ind, 0)
	if sym.type_.ref.f.func_ctor {
		add_array(tcc_state, c'.init_array', sym.c)
	}
	if sym.type_.ref.f.func_dtor {
		add_array(tcc_state, c'.fini_array', sym.c)
	}
	tcc_debug_funcstart(tcc_state, sym)
	sym_push2(&local_stack, 536870912, 0, 0)
	local_scope = 1
	gfunc_prolog(sym)
	tcc_debug_prolog_epilog(tcc_state, 0)
	local_scope = 0
	rsym = 0
	clear_temp_local_var_list()
	func_vla_arg(sym)
	block(0)
	gsym(rsym)
	nocode_wanted = 0
	pop_local_syms((unsafe { nil }), 0)
	tcc_debug_prolog_epilog(tcc_state, 1)
	gfunc_epilog()
	tcc_debug_funcend(tcc_state, ind - func_ind)
	elfsym(sym).st_size = ind - func_ind
	tcc_state.cur_text_section.data_offset = ind
	local_scope = 0
	label_pop(&global_label_stack, (unsafe { nil }), 0)
	sym_pop(&all_cleanups, (unsafe { nil }), 0)
	tcc_state.cur_text_section = (unsafe { nil })
	funcname = c''
	func_vt.t = 0
	func_var = 0
	ind = 0
	func_ind = -1
	nocode_wanted = 2147483648
	check_vstack()
	next()
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
			if sym && (sym.c || !(sym.type_.t & 32768)) {
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

@[c: 'do_Static_assert']
fn do_static_assert() {
	c := 0
	msg := &i8(0)
	next()
	skip(`(`)
	c = expr_const()
	msg = c'_Static_assert fail'
	if tok == `,` {
		next()
		msg = parse_mult_str(c'string constant').data
	}
	skip(`)`)
	if c == 0 {
		_tcc_error(c'%s', msg)
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

	for 1 {
		oldint = 0
		if !parse_btype(&btype, &adbase, l == 50) {
			if l == 52 {
				return 0
			}
			if tok == `;` && l != 51 {
				next()
				continue
			}
			if tok == Tcc_token.tok_static_assert {
				do_static_assert()
				continue
			}
			if l != 48 {
				break
			}
			if tok == Tcc_token.tok_asm1 || tok == Tcc_token.tok_asm2 || tok == Tcc_token.tok_asm3 {
				asm_global_instr()
				continue
			}
			if tok >= Tcc_token.tok_define {
				btype.t = 3
				oldint = 1
			} else {
				if tok != (-1) {
					expect(c'declaration')
				}
				break
			}
		}
		if tok == `;` {
			if (btype.t & 15) == 7 {
				v = btype.ref.v
				if !(v & 536870912) && (v & ~1073741824) >= 268435456 {
					_tcc_warning(c'unnamed struct/union that defines no instances')
				}
				next()
				continue
			}
			if ((btype.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
				next()
				continue
			}
		}
		for 1 {
			type_ = btype
			ad = adbase
			type_decl(&type_, &ad, &v, 2)
			if (type_.t & 15) == 6 {
				if type_.t & 8192 && l != 48 {
					_tcc_error(c'function without file scope cannot be static')
				}
				sym = type_.ref
				if sym.f.func_type == 2 && l == 48 {
					func_vt = type_
					decl(51)
				}
				if type_.t & 4096 {
					type_.t &= ~32768
				}
			} else if oldint {
				_tcc_warning(c'type defaults to int')
			}
			if tcc_state.gnu_ext && (tok == Tcc_token.tok_asm1
				|| tok == Tcc_token.tok_asm2 || tok == Tcc_token.tok_asm3) {
				ad.asm_label = asm_label_instr()
				parse_attribute(&ad)
			}
			if tok == `{` {
				if l != 48 {
					_tcc_error(c'cannot use local functions')
				}
				if (type_.t & 15) != 6 {
					expect(c'function definition')
				}
				sym = type_.ref
				for {
					sym = sym.next
					if sym == (unsafe { nil }) {
						break
					}
					if !(sym.v & ~536870912) {
						expect(c'identifier')
					}
					if sym.type_.t == 0 {
						sym.type_ = int_type
					}
				}
				merge_funcattr(&type_.ref.f, &ad.f)
				type_.t &= ~4096
				sym = external_sym(v, &type_, 0, &ad)
				if sym.type_.t & 32768 {
					fnc := &InlineFunc(0)
					fnc = tcc_malloc(sizeof(*fnc) + C.strlen(file.filename))
					strcpy(fnc.filename, file.filename)
					fnc.sym = sym
					skip_or_save_block(&fnc.func_str)
					dynarray_add(&tcc_state.inline_fns, &tcc_state.nb_inline_fns, fnc)
				} else {
					tcc_state.cur_text_section = ad.section
					if !tcc_state.cur_text_section {
						tcc_state.cur_text_section = tcc_state.text_section
					}
					gen_function(sym)
				}
				break
			} else {
				if l == 51 {
					for sym = func_vt.ref.next; sym; sym = sym.next {
						if (sym.v & ~536870912) == v {
							goto found // id: 0x7fffed53b268
						}
					}
					_tcc_error(c"declaration for parameter '%s' but no such parameter",
						get_tok_str(v, (unsafe { nil })))
					// RRRREG found id=0x7fffed53b268
					found:
					if type_.t & (4096 | 8192 | 16384 | 32768) {
						_tcc_error(c"storage class specified for '%s'", get_tok_str(v,
							(unsafe { nil })))
					}
					if sym.type_.t != 0 {
						_tcc_error(c"redefinition of parameter '%s'", get_tok_str(v, (unsafe { nil })))
					}
					convert_parameter_type(&type_)
					sym.type_ = type_
				} else if type_.t & 16384 {
					sym = sym_find(v)
					if sym && sym.sym_scope == local_scope {
						if !is_compatible_types(&sym.type_, &type_) || !(sym.type_.t & 16384) {
							_tcc_error(c"incompatible redefinition of '%s'", get_tok_str(v,
								(unsafe { nil })))
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
					_tcc_error(c'declaration of void object')
				} else {
					r = 0
					if (type_.t & 15) == 6 {
						merge_funcattr(&type_.ref.f, &ad.f)
					} else if !(type_.t & 64) {
						r |= 256
					}
					has_init = (tok == `=`)
					if has_init && type_.t & 1024 {
						_tcc_error(c'variable length array cannot be initialized')
					}
					if (type_.t & 4096 && (!has_init || l != 48))
						|| (type_.t & 15) == 6
						|| (type_.t & 64 && !has_init && l == 48 && type_.ref.c < 0) {
						type_.t |= 4096
						sym = external_sym(v, &type_, r, &ad)
					} else {
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
						alias_target := sym_find(ad.alias_target)
						esym := elfsym(alias_target)
						if !esym {
							_tcc_error(c'unsupported forward __alias__ attribute')
						}
						put_extern_sym2(sym_find(v), esym.st_shndx, esym.st_value, esym.st_size,
							1)
					}
				}
				if tok != `,` {
					if l == 52 {
						return 1
					}
					skip(`;`)
					break
				}
				next()
			}
		}
	}
	return 0
}
