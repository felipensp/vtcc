@[translated]
module main

fn is_float(t int) int {
	bt := 0
	bt = t & 15
	return bt == 10 || bt == 9 || bt == 8 || bt == 14
}

fn ieee_finite(d f64) int {
	p := [4]int{}
	C.memcpy(p, &d, sizeof(f64))
	return (u32(((p [1]  | 2148532223) + 1))) >> 31
}

fn test_lvalue()  {
	if !(vtop.r & 256) {
	expect(c'lvalue')
	}
}

fn check_vstack()  {
	if pvtop != vtop {
	tcc_error(c'internal compiler error: vstack leak (%d)', vtop - pvtop)
	}
}

fn tcc_debug_start(s1 &TCCState)  {
	if s1.do_debug {
		buf := [512]i8{}
		section_sym = put_elf_sym(symtab_section, 0, 0, ((((0)) << 4) + (((3)) & 15)), 0, text_section.sh_num, (voidptr(0)))
		getcwd(buf, sizeof(buf))
		pstrcat(buf, sizeof(buf), c'/')
		put_stabs_r(buf, __stab_debug_code.n_so, 0, 0, text_section.data_offset, text_section, section_sym)
		put_stabs_r(file.filename, __stab_debug_code.n_so, 0, 0, text_section.data_offset, text_section, section_sym)
		last_ind = 0
		last_line_num = 0
	}
	put_elf_sym(symtab_section, 0, 0, ((((0)) << 4) + (((4)) & 15)), 0, 65521, file.filename)
}

fn tcc_debug_end(s1 &TCCState)  {
	if !s1.do_debug {
	return 
	}
	put_stabs_r((voidptr(0)), __stab_debug_code.n_so, 0, 0, text_section.data_offset, text_section, section_sym)
}

fn tcc_debug_line(s1 &TCCState)  {
	if !s1.do_debug {
	return 
	}
	if (last_line_num != file.line_num || last_ind != ind) {
		put_stabn(__stab_debug_code.n_sline, 0, file.line_num, ind - func_ind)
		last_ind = ind
		last_line_num = file.line_num
	}
}

fn tcc_debug_funcstart(s1 &TCCState, sym &Sym)  {
	buf := [512]i8{}
	if !s1.do_debug {
	return 
	}
	C.snprintf(buf, sizeof(buf), c'%s:%c1', funcname, if sym.type_.t & 8192{ `f` } else {`F`})
	put_stabs_r(buf, __stab_debug_code.n_fun, 0, file.line_num, 0, cur_text_section, sym...c)
	put_stabn(__stab_debug_code.n_sline, 0, file.line_num, 0)
	last_ind = 0
	last_line_num = 0
}

fn tcc_debug_funcend(s1 &TCCState, size int)  {
	if !s1.do_debug {
	return 
	}
	put_stabn(__stab_debug_code.n_fun, 0, 0, size)
}

fn tccgen_compile(s1 &TCCState) int {
	cur_text_section = (voidptr(0))
	funcname = c''
	anon_sym = 268435456
	section_sym = 0
	const_wanted = 0
	nocode_wanted = 2147483648
	local_scope = 0
	int_type.t = 3
	char_pointer_type.t = 1
	mk_pointer(&char_pointer_type)
	size_type.t = 2048 | 4 | 16
	ptrdiff_type.t = 2048 | 4
	func_old_type.t = 6
	func_old_type.ref = sym_push(536870912, &int_type, 0, 0)
	func_old_type.ref....f.func_call = 0
	func_old_type.ref....f.func_type = 2
	tcc_debug_start(s1)
	parse_flags = 1 | 2 | 64
	next()
	decl(48)
	gen_inline_functions(s1)
	check_vstack()
	tcc_debug_end(s1)
	return 0
}

fn elfsym(s &Sym) &Elf64_Sym {
	if !s || !s...c {
	return (voidptr(0))
	}
	return &(&Elf64_Sym(symtab_section.data)) [s...c] 
}

fn update_storage(sym &Sym)  {
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
	}
	else if sym.a.weak {
	sym_bind = 2
	}
	else { // 3
	sym_bind = 1
}
	old_sym_bind = ((u8((esym.st_info))) >> 4)
	if sym_bind != old_sym_bind {
		esym.st_info = ((((sym_bind)) << 4) + (((((esym.st_info) & 15))) & 15))
	}
}

fn put_extern_sym2(sym &Sym, sh_num int, value Elf64_Addr, size u32, can_add_underscore int)  {
	sym_type := 0
	sym_bind := 0
	info := 0
	other := 0
	t := 0
	
	esym := &Elf64_Sym(0)
	name := &i8(0)
	buf1 := [256]i8{}
	buf := [32]i8{}
	if !sym...c {
		name = get_tok_str(sym.v, (voidptr(0)))
		if tcc_state.do_bounds_check {
			match (sym.v) {
			 .tok_memcpy, .tok_memmove, .tok_memset, .tok_strlen, .tok_strcpy, .tok_alloca{
			strcpy(buf, c'__bound_')
			strcat(buf, name)
			name = buf
			
			}
			else{}
			}
		}
		t = sym.type_.t
		if (t & 15) == 6 {
			sym_type = 2
		}
		else if (t & 15) == 0 {
			sym_type = 0
		}
		else {
			sym_type = 1
		}
		if t & (8192 | 32768) {
		sym_bind = 0
		}
		else { // 3
		sym_bind = 1
}
		other = 0
		if tcc_state.leading_underscore && can_add_underscore {
			buf1 [0]  = `_`
			pstrcpy(buf1 + 1, sizeof(buf1) - 1, name)
			name = buf1
		}
		if sym..asm_label {
		name = get_tok_str(sym..asm_label, (voidptr(0)))
		}
		info = ((((sym_bind)) << 4) + (((sym_type)) & 15))
		sym...c = put_elf_sym(symtab_section, value, size, info, other, sh_num, name)
	}
	else {
		esym = elfsym(sym)
		esym.st_value = value
		esym.st_size = size
		esym.st_shndx = sh_num
	}
	update_storage(sym)
}

fn put_extern_sym(sym &Sym, section &Section, value Elf64_Addr, size u32)  {
	sh_num := if section{ section.sh_num } else {0}
	put_extern_sym2(sym, sh_num, value, size, 1)
}

fn greloca(s &Section, sym &Sym, offset u32, type_ int, addend Elf64_Addr)  {
	c := 0
	if nocode_wanted && s == cur_text_section {
	return 
	}
	if sym {
		if 0 == sym...c {
		put_extern_sym(sym, (voidptr(0)), 0, 0)
		}
		c = sym...c
	}
	put_elf_reloca(symtab_section, s, offset, type_, c, addend)
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
	for i = 0 ; i < (8192 / sizeof(Sym)) ; i ++ {
		sym..next = last_sym
		last_sym = sym
		sym ++
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
	sym_free_first = sym..next
	return sym
}

fn sym_free(sym &Sym)  {
	sym..next = sym_free_first
	sym_free_first = sym
}

fn sym_push2(ps &&Sym, v int, t int, c int) &Sym {
	s := &Sym(0)
	s = sym_malloc()
	C.memset(s, 0, sizeof*s)
	s.v = v
	s.type_.t = t
	s...c = c
	s.prev = *ps
	*ps = s
	return s
}

fn sym_find2(s &Sym, v int) &Sym {
	for s {
		if s.v == v {
		return s
		}
		else if s.v == -1 {
		return (voidptr(0))
		}
		s = s.prev
	}
	return (voidptr(0))
}

fn struct_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
	return (voidptr(0))
	}
	return table_ident [v] .sym_struct
}

fn sym_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
	return (voidptr(0))
	}
	return table_ident [v] .sym_identifier
}

fn sym_scope(s &Sym) int {
	if ((s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20)) {
	return s.type_.ref....sym_scope
	}
	else {
	return s....sym_scope
	}
}

fn sym_push(v int, type_ &CType, r int, c int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)
	
	ts := &TokenSym(0)
	if local_stack {
	ps = &local_stack
	}
	else { // 3
	ps = &global_stack
}
	s = sym_push2(ps, v, type_.t, c)
	s.type_.ref = type_.ref
	s.r = r
	if !(v & 536870912) && (v & ~1073741824) < 268435456 {
		ts = table_ident [(v & ~1073741824) - 256] 
		if v & 1073741824 {
		ps = &ts.sym_struct
		}
		else { // 3
		ps = &ts.sym_identifier
}
		s.prev_tok = *ps
		*ps = s
		s....sym_scope = local_scope
		if s.prev_tok && sym_scope(s.prev_tok) == s....sym_scope {
		tcc_error(c"redeclaration of '%s'", get_tok_str(v & ~1073741824, (voidptr(0))))
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
		ps = &table_ident [v - 256] .sym_identifier
		for *ps != (voidptr(0)) && (*ps)....sym_scope {
		ps = &(*ps).prev_tok
		}
		s.prev_tok = *ps
		*ps = s
	}
	return s
}

fn sym_pop(ptop &&Sym, b &Sym, keep int)  {
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
			ts = table_ident [(v & ~1073741824) - 256] 
			if v & 1073741824 {
			ps = &ts.sym_struct
			}
			else { // 3
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

fn vcheck_cmp()  {
	if vtop.r == 51 && !nocode_wanted {
	gv(1)
	}
}

fn vsetc(type_ &CType, r int, vc &CValue)  {
	if vtop >= (__vstack + 1) + (256 - 1) {
	tcc_error(c'memory full (vstack)')
	}
	vcheck_cmp()
	vtop ++
	vtop.type_ = *type_
	vtop.r = r
	vtop.r2 = 48
	vtop..c = *vc
	vtop..sym = (voidptr(0))
}

fn vswap()  {
	tmp := SValue{}
	vcheck_cmp()
	tmp = vtop [0] 
	vtop [0]  = vtop [-1] 
	vtop [-1]  = tmp
}

fn vpop()  {
	v := 0
	v = vtop.r & 63
	if v == treg_st0 {
		o(55517)
	}
	else if v == 51 {
		gsym(vtop...jtrue)
		gsym(vtop...jfalse)
	}
	vtop --
}

fn vpush(type_ &CType)  {
	vset(type_, 48, 0)
}

fn vpushi(v int)  {
	cval := CValue{}
	cval.i = v
	vsetc(&int_type, 48, &cval)
}

fn vpushs(v Elf64_Addr)  {
	cval := CValue{}
	cval.i = v
	vsetc(&size_type, 48, &cval)
}

fn vpush64(ty int, v i64)  {
	cval := CValue{}
	ctype := CType{}
	ctype.t = ty
	ctype.ref = (voidptr(0))
	cval.i = v
	vsetc(&ctype, 48, &cval)
}

fn vpushll(v i64)  {
	vpush64(4, v)
}

fn vset(type_ &CType, r int, v int)  {
	cval := CValue{}
	cval.i = v
	vsetc(type_, r, &cval)
}

fn vseti(r int, v int)  {
	type_ := CType{}
	type_.t = 3
	type_.ref = (voidptr(0))
	vset(&type_, r, v)
}

fn vpushv(v &SValue)  {
	if vtop >= (__vstack + 1) + (256 - 1) {
	tcc_error(c'memory full (vstack)')
	}
	vtop ++
	*vtop = *v
}

fn vdup()  {
	vpushv(vtop)
}

fn vrotb(n int)  {
	i := 0
	tmp := SValue{}
	vcheck_cmp()
	tmp = vtop [-n + 1] 
	for i = -n + 1 ; i != 0 ; i ++ {
	vtop [i]  = vtop [i + 1] 
	}
	vtop [0]  = tmp
}

fn vrote(e &SValue, n int)  {
	i := 0
	tmp := SValue{}
	vcheck_cmp()
	tmp = *e
	for i = 0 ; i < n - 1 ; i ++ {
	e [-i]  = e [-i - 1] 
	}
	e [-n + 1]  = tmp
}

fn vrott(n int)  {
	vrote(vtop, n)
}

[c:'vset_VT_CMP']
fn vset_vt_cmp(op int)  {
	vtop.r = 51
	vtop...cmp_op = op
	vtop...jfalse = 0
	vtop...jtrue = 0
}

[c:'vset_VT_JMP']
fn vset_vt_jmp()  {
	op := vtop...cmp_op
	if vtop...jtrue || vtop...jfalse {
		inv := op & (op < 2)
		vseti(52 + inv, gvtst(inv, 0))
	}
	else {
		vtop..c.i = op
		if op < 2 {
		vtop.r = 48
		}
	}
}

fn gvtst_set(inv int, t int)  {
	p := &int(0)
	if vtop.r != 51 {
		vpushi(0)
		gen_op(149)
		if vtop.r == 51 {}
		else if vtop.r == 48 {
		vset_vt_cmp(vtop..c.i != 0)
		}
		else { // 3
		tcc_error(c'ICE')
}
	}
	p = if inv{ &vtop...jfalse } else {&vtop...jtrue}
	*p = gjmp_append(*p, t)
}

fn gvtst(inv int, t int) int {
	op := 0
	u := 0
	x := 0
	
	gvtst_set(inv, t)
	t = vtop...jtrue , vtop...jfalse
	u = t = vtop...jtrue
	if inv {
	x = u , t
	u = x = u , x
	t = x = u , t
	u = x = u
	}
	op = vtop...cmp_op
	if op > 1 {
	t = gjmp_cond(op ^ inv, t)
	}
	else if op != inv {
	t = gjmp_acs(t)
	}
	gsym(u)
	vtop --
	return t
}

fn vpushsym(type_ &CType, sym &Sym)  {
	cval := CValue{}
	cval.i = 0
	vsetc(type_, 48 | 512, &cval)
	vtop..sym = sym
}

fn get_sym_ref(type_ &CType, sec &Section, offset u32, size u32) &Sym {
	v := 0
	sym := &Sym(0)
	v = anon_sym ++
	sym = sym_push(v, type_, 48 | 512, 0)
	sym.type_.t |= 8192
	put_extern_sym(sym, sec, offset, size)
	return sym
}

fn vpush_ref(type_ &CType, sec &Section, offset u32, size u32)  {
	vpushsym(type_, get_sym_ref(type_, sec, offset, size))
}

fn external_global_sym(v int, type_ &CType) &Sym {
	s := &Sym(0)
	s = sym_find(v)
	if !s {
		s = global_identifier_push(v, type_.t | 4096, 0)
		s.type_.ref = type_.ref
	}
	else if (((s).type_.t & (15 | (0 | 16))) == (0 | 16)) {
		s.type_.t = type_.t | (s.type_.t & 4096)
		s.type_.ref = type_.ref
		update_storage(s)
	}
	return s
}

fn merge_symattr(sa &SymAttr, sa1 &SymAttr)  {
	if sa1.aligned && !sa.aligned {
	sa.aligned = sa1.aligned
	}
	sa.packed |= sa1.packed
	sa.weak |= sa1.weak
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

fn merge_funcattr(fa &FuncAttr, fa1 &FuncAttr)  {
	if fa1.func_call && !fa.func_call {
	fa.func_call = fa1.func_call
	}
	if fa1.func_type && !fa.func_type {
	fa.func_type = fa1.func_type
	}
	if fa1.func_args && !fa.func_args {
	fa.func_args = fa1.func_args
	}
}

fn merge_attr(ad &AttributeDef, ad1 &AttributeDef)  {
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

fn patch_type(sym &Sym, type_ &CType)  {
	if !(type_.t & 4096) || ((sym.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20)) {
		if !(sym.type_.t & 4096) {
		tcc_error(c"redefinition of '%s'", get_tok_str(sym.v, (voidptr(0))))
		}
		sym.type_.t &= ~4096
	}
	if (((sym).type_.t & (15 | (0 | 16))) == (0 | 16)) {
		sym.type_.t = type_.t & (sym.type_.t | ~8192)
		sym.type_.ref = type_.ref
	}
	if !is_compatible_types(&sym.type_, type_) {
		tcc_error(c"incompatible types for redefinition of '%s'", get_tok_str(sym.v, (voidptr(0))))
	}
	else if (sym.type_.t & 15) == 6 {
		static_proto := sym.type_.t & 8192
		if (type_.t & 8192) && !static_proto && !((type_.t | sym.type_.t) & 32768) {
		tcc_warning(c"static storage ignored for redefinition of '%s'", get_tok_str(sym.v, (voidptr(0))))
		}
		if (type_.t | sym.type_.t) & 32768 {
			if !((type_.t ^ sym.type_.t) & 32768) || ((type_.t | sym.type_.t) & 8192) {
			static_proto |= 32768
			}
		}
		if 0 == (type_.t & 4096) {
			sym.type_.t = (type_.t & ~(8192 | 32768)) | static_proto
			sym.type_.ref = type_.ref
		}
		else {
			sym.type_.t &= ~32768 | static_proto
		}
		if sym.type_.ref....f.func_type == 2 && type_.ref....f.func_type != 2 {
			sym.type_.ref = type_.ref
		}
	}
	else {
		if (sym.type_.t & 64) && type_.ref...c >= 0 {
			sym.type_.ref...c = type_.ref...c
		}
		if (type_.t ^ sym.type_.t) & 8192 {
		tcc_warning(c"storage mismatch for redefinition of '%s'", get_tok_str(sym.v, (voidptr(0))))
		}
	}
}

fn patch_storage(sym &Sym, ad &AttributeDef, type_ &CType)  {
	if type_ {
	patch_type(sym, type_)
	}
	merge_symattr(&sym.a, &ad.a)
	if ad.asm_label {
	sym..asm_label = ad.asm_label
	}
	update_storage(sym)
}

fn sym_copy(s0 &Sym, ps &&Sym) &Sym {
	s := &Sym(0)
	s = sym_malloc() , *s0
	*s = s = sym_malloc()
	s.prev = *ps , s
	*ps = s.prev = *ps
	if s.v < 268435456 {
		ps = &table_ident [s.v - 256] .sym_identifier
		s.prev_tok = *ps , s
		*ps = s.prev_tok = *ps
	}
	return s
}

fn sym_copy_ref(s &Sym, ps &&Sym)  {
	bt := s.type_.t & 15
	if bt == 6 || bt == 5 {
		sp := &s.type_.ref
		for s = *sp , (voidptr(0))
		*sp = s = *sp ; s ; s = s..next {
			s2 := sym_copy(s, ps)
			sp = &(*sp = s2)..next
			sym_copy_ref(s2, ps)
		}
	}
}

fn external_sym(v int, type_ &CType, r int, ad &AttributeDef) &Sym {
	s := &Sym(0)
	s = sym_find(v)
	for s && s....sym_scope {
	s = s.prev_tok
	}
	if !s {
		s = global_identifier_push(v, type_.t, 0)
		s.r |= r
		s.a = ad.a
		s..asm_label = ad.asm_label
		s.type_.ref = type_.ref
		if local_stack {
		sym_copy_ref(s, &global_stack)
		}
	}
	else {
		patch_storage(s, ad, type_)
	}
	if local_stack && (s.type_.t & 15) != 6 {
	s = sym_copy(s, &local_stack)
	}
	return s
}

fn vpush_global_sym(type_ &CType, v int)  {
	vpushsym(type_, external_global_sym(v, type_))
}

fn save_regs(n int)  {
	p := &SValue(0)
	p1 := &SValue(0)
	
	for p = (__vstack + 1) , vtop - n
	p1 = p = (__vstack + 1) ; p <= p1 ; p ++ {
	save_reg(p.r)
	}
}

fn save_reg(r int)  {
	save_reg_upstack(r, 0)
}

fn save_reg_upstack(r int, n int)  {
	l := 0
	saved := 0
	size := 0
	align := 0
	
	p := &SValue(0)
	p1 := &SValue(0)
	sv := SValue{}
	
	type_ := &CType(0)
	if (r &= 63) >= 48 {
	return 
	}
	if nocode_wanted {
	return 
	}
	saved = 0
	l = 0
	for p = (__vstack + 1) , vtop - n
	p1 = p = (__vstack + 1) ; p <= p1 ; p ++ {
		if (p.r & 63) == r || (p.r2 & 63) == r {
			if !saved {
				r = p.r & 63
				type_ = &p.type_
				if (p.r & 256) || (!is_float(type_.t) && (type_.t & 15) != 4) {
				type_ = &char_pointer_type
				}
				size = type_size(type_, &align)
				l = get_temp_local_var(size, align)
				sv.type_.t = type_.t
				sv.r = 50 | 256
				sv..c.i = l
				store(r, &sv)
				if r == treg_st0 {
					o(55517)
				}
				if (p.r2 & 63) < 48 {
					sv..c.i += 8
					store(p.r2, &sv)
				}
				saved = 1
			}
			if p.r & 256 {
				p.r = (p.r & ~(63 | 32768)) | 49
			}
			else {
				p.r = lvalue_type(p.type_.t) | 50
			}
			p.r2 = 48
			p..c.i = l
		}
	}
}

fn get_reg(rc int) int {
	r := 0
	p := &SValue(0)
	for r = 0 ; r < 25 ; r ++ {
		if reg_classes [r]  & rc {
			if nocode_wanted {
			return r
			}
			for p = (__vstack + 1) ; p <= vtop ; p ++ {
				if (p.r & 63) == r || (p.r2 & 63) == r {
				goto notfound // id: 0x7fffbd130648
				}
			}
			return r
		}
		// RRRREG notfound id=0x7fffbd130648
		notfound: 
		0
	}
	for p = (__vstack + 1) ; p <= vtop ; p ++ {
		r = p.r2 & 63
		if r < 48 && (reg_classes [r]  & rc) {
		goto save_found // id: 0x7fffbd130ca0
		}
		r = p.r & 63
		if r < 48 && (reg_classes [r]  & rc) {
			// RRRREG save_found id=0x7fffbd130ca0
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
	for i = 0 ; i < nb_temp_local_vars ; i ++ {
		temp_var = &arr_temp_local_vars [i] 
		if temp_var.size < size || align != temp_var.align {
			continue
			
		}
		free = 1
		for p = (__vstack + 1) ; p <= vtop ; p ++ {
			r = p.r & 63
			if r == 50 || r == 49 {
				if p..c.i == temp_var.location {
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
		if nb_temp_local_vars < 4 {
			temp_var = &arr_temp_local_vars [i] 
			temp_var.location = loc
			temp_var.size = size
			temp_var.align = align
			nb_temp_local_vars ++
		}
		found_var = loc
	}
	return found_var
}

fn clear_temp_local_var_list()  {
	nb_temp_local_vars = 0
}

fn move_reg(r int, s int, t int)  {
	sv := SValue{}
	if r != s {
		save_reg(r)
		sv.type_.t = t
		sv.type_.ref = (voidptr(0))
		sv.r = s
		sv..c.i = 0
		load(r, &sv)
	}
}

fn gaddrof()  {
	vtop.r &= ~256
	if (vtop.r & 63) == 49 {
	vtop.r = (vtop.r & ~(63 | (4096 | 8192 | 16384))) | 50 | 256
	}
}

fn gbound()  {
	lval_type := 0
	type1 := CType{}
	vtop.r &= ~2048
	if vtop.r & 256 {
		if !(vtop.r & 32768) {
			lval_type = vtop.r & ((4096 | 8192 | 16384) | 256)
			type1 = vtop.type_
			vtop.type_.t = 5
			gaddrof()
			vpushi(0)
			gen_bounded_ptr_add()
			vtop.r |= lval_type
			vtop.type_ = type1
		}
		gen_bounded_ptr_deref()
	}
}

fn incr_bf_adr(o int)  {
	vtop.type_ = char_pointer_type
	gaddrof()
	vpushi(o)
	gen_op(`+`)
	vtop.type_.t = (vtop.type_.t & ~(15 | 32)) | (1 | 16)
	vtop.r = (vtop.r & ~(4096 | 8192 | 16384)) | (4096 | 16384 | 256)
}

fn load_packed_bf(type_ &CType, bit_pos int, bit_size int)  {
	n := 0
	o := 0
	bits := 0
	
	save_reg_upstack(vtop.r, 1)
	vpush64(type_.t & 15, 0)
	bits = 0 , bit_pos >> 3
	o = bits = 0 , bit_pos &= 7
	for {
	vswap()
	incr_bf_adr(o)
	vdup()
	n = 8 - bit_pos
	if n > bit_size {
	n = bit_size
	}
	if bit_pos {
	vpushi(bit_pos) , gen_op(201) , 0
	bit_pos = vpushi(bit_pos) , gen_op(201)
	}
	if n < 8 {
	vpushi((1 << n) - 1) , gen_op(`&`)
	}
	gen_cast(type_)
	if bits {
	vpushi(bits) , gen_op(1)
	}
	vrotb(3)
	gen_op(`|`)
	bits += n , bit_size -= n , 1
	o = bits += n , bit_size -= n
	// while()
	if ! (bit_size ) { break }
	}
	vswap() , vpop()
	if !(type_.t & 16) {
		n = (if (type_.t & 15) == 4{ 64 } else {32}) - bits
		vpushi(n) , gen_op(1)
		vpushi(n) , gen_op(2)
	}
}

fn store_packed_bf(bit_pos int, bit_size int)  {
	bits := 0
	n := 0
	o := 0
	m := 0
	c := 0
	
	c = (vtop.r & (63 | 256 | 512)) == 48
	vswap()
	save_reg_upstack(vtop.r, 1)
	bits = 0 , bit_pos >> 3
	o = bits = 0 , bit_pos &= 7
	for {
	incr_bf_adr(o)
	vswap()
	if c{ vdup() } else {gv_dup()}
	vrott(3)
	if bits {
	vpushi(bits) , gen_op(201)
	}
	if bit_pos {
	vpushi(bit_pos) , gen_op(1)
	}
	n = 8 - bit_pos
	if n > bit_size {
	n = bit_size
	}
	if n < 8 {
		m = ((1 << n) - 1) << bit_pos
		vpushi(m) , gen_op(`&`)
		vpushv(vtop - 1)
		vpushi(if m & 128{ ~m & 127 } else {~m})
		gen_op(`&`)
		gen_op(`|`)
	}
	vdup() , vtop [-2] 
	vtop [-1]  = vdup()
	vstore() , vpop()
	bits += n , bit_size -= n , 0
	bit_pos = bits += n , bit_size -= n , 1
	o = bits += n , bit_size -= n , 0
	bit_pos = bits += n , bit_size -= n
	// while()
	if ! (bit_size ) { break }
	}
	vpop() , vpop()
}

fn adjust_bf(sv &SValue, bit_pos int, bit_size int) int {
	t := 0
	if 0 == sv.type_.ref {
	return 0
	}
	t = sv.type_.ref....auxtype
	if t != -1 && t != 7 {
		sv.type_.t = (sv.type_.t & ~15) | t
		sv.r = (sv.r & ~(4096 | 8192 | 16384)) | lvalue_type(sv.type_.t)
	}
	return t
}

fn gv(rc int) int {
	r := 0
	bit_pos := 0
	bit_size := 0
	size := 0
	align := 0
	rc2 := 0
	
	if vtop.type_.t & 128 {
		type_ := CType{}
		bit_pos = (((vtop.type_.t) >> 20) & 63)
		bit_size = (((vtop.type_.t) >> (20 + 6)) & 63)
		vtop.type_.t &= ~(((1 << (6 + 6)) - 1) << 20 | 128)
		type_.ref = (voidptr(0))
		type_.t = vtop.type_.t & 16
		if (vtop.type_.t & 15) == 11 {
		type_.t |= 16
		}
		r = adjust_bf(vtop, bit_pos, bit_size)
		if (vtop.type_.t & 15) == 4 {
		type_.t |= 4
		}
		else { // 3
		type_.t |= 3
}
		if r == 7 {
			load_packed_bf(&type_, bit_pos, bit_size)
		}
		else {
			bits := if (type_.t & 15) == 4{ 64 } else {32}
			gen_cast(&type_)
			vpushi(bits - (bit_pos + bit_size))
			gen_op(1)
			vpushi(bits - bit_size)
			gen_op(2)
		}
		r = gv(rc)
	}
	else {
		if is_float(vtop.type_.t) && (vtop.r & (63 | 256)) == 48 {
			offset := u32(0)
			size = type_size(&vtop.type_, &align)
			if (nocode_wanted > 0) {
			size = 0 , 1
			align = size = 0
			}
			offset = section_add(data_section, size, align)
			vpush_ref(&vtop.type_, data_section, offset, size)
			vswap()
			init_putv(&vtop.type_, data_section, offset)
			vtop.r |= 256
		}
		if vtop.r & 2048 {
		gbound()
		}
		r = vtop.r & 63
		rc2 = if (rc & 2){ 2 } else {1}
		if rc == 4 {
		rc2 = 16
		}
		else if rc == 4096 {
		rc2 = 8192
		}
		if r >= 48 || (vtop.r & 256) || !(reg_classes [r]  & rc) || ((vtop.type_.t & 15) == 13 && !(reg_classes [vtop.r2]  & rc2)) || ((vtop.type_.t & 15) == 14 && !(reg_classes [vtop.r2]  & rc2)) {
			r = get_reg(rc)
			if ((vtop.type_.t & 15) == 13) || ((vtop.type_.t & 15) == 14) {
				addr_type := 4
load_size := 8
load_type := if ((vtop.type_.t & 15) == 13){ 4 } else {9}

				r2 := 0
				original_type := 0
				
				original_type = vtop.type_.t
				if vtop.r & 256 {
					save_reg_upstack(vtop.r, 1)
					vtop.type_.t = load_type
					load(r, vtop)
					vdup()
					vtop [-1] .r = r
					vtop.type_.t = addr_type
					gaddrof()
					vpushi(load_size)
					gen_op(`+`)
					vtop.r |= 256
					vtop.type_.t = load_type
				}
				else {
					load(r, vtop)
					vdup()
					vtop [-1] .r = r
					vtop.r = vtop [-1] .r2
				}
				r2 = get_reg(rc2)
				load(r2, vtop)
				vpop()
				vtop.r2 = r2
				vtop.type_.t = original_type
			}
			else if (vtop.r & 256) && !is_float(vtop.type_.t) {
				t1 := 0
				t := 0
				
				t = vtop.type_.t
				t1 = t
				if vtop.r & 4096 {
				t = 1
				}
				else if vtop.r & 8192 {
				t = 2
				}
				if vtop.r & 16384 {
				t |= 16
				}
				vtop.type_.t = t
				load(r, vtop)
				vtop.type_.t = t1
			}
			else {
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

fn gv2(rc1 int, rc2 int)  {
	if vtop.r != 51 && rc1 <= rc2 {
		vswap()
		gv(rc1)
		vswap()
		gv(rc2)
		if (vtop [-1] .r & 63) >= 48 {
			vswap()
			gv(rc1)
			vswap()
		}
	}
	else {
		gv(rc2)
		vswap()
		gv(rc1)
		vswap()
		if (vtop [0] .r & 63) >= 48 {
			gv(rc2)
		}
	}
}

fn rc_fret(t int) int {
	if t == 10 {
		return 128
	}
	return 4096
}

fn reg_fret(t int) int {
	if t == 10 {
		return treg_st0
	}
	return treg_xmm0
}

fn gv_dup()  {
	rc := 0
	t := 0
	r := 0
	r1 := 0
	
	sv := SValue{}
	t = vtop.type_.t
	{
		rc = 1
		sv.type_.t = 3
		if is_float(t) {
			rc = 2
			if (t & 15) == 10 {
				rc = 128
			}
			sv.type_.t = t
		}
		r = gv(rc)
		r1 = get_reg(rc)
		sv.r = r
		sv..c.i = 0
		load(r1, &sv)
		vdup()
		if r != r1 {
		vtop.r = r1
		}
	}
}

fn gen_opic_sdiv(a u64, b u64) u64 {
	x := (if a >> 63{ -a } else {a}) / (if b >> 63{ -b } else {b})
	return if (a ^ b) >> 63{ -x } else {x}
}

fn gen_opic_lt(a u64, b u64) int {
	return (a ^ u64(1) << 63) < (b ^ u64(1) << 63)
}

fn gen_opic(op int)  {
	v1 := vtop - 1
	v2 := vtop
	t1 := v1.type_.t & 15
	t2 := v2.type_.t & 15
	c1 := (v1.r & (63 | 256 | 512)) == 48
	c2 := (v2.r & (63 | 256 | 512)) == 48
	l1 := if c1{ v1..c.i } else {0}
	l2 := if c2{ v2..c.i } else {0}
	shm := if (t1 == 4){ 63 } else {31}
	if t1 != 4 && (8 != 8 || t1 != 5) {
	l1 = (u32(l1) | (if v1.type_.t & 16{ 0 } else {-(l1 & 2147483648)}))
	}
	if t2 != 4 && (8 != 8 || t2 != 5) {
	l2 = (u32(l2) | (if v2.type_.t & 16{ 0 } else {-(l2 & 2147483648)}))
	}
	if c1 && c2 {
		match op {
		 `+`{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 += l2
		
		}
		 `-`{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 -= l2
		
		}
		 `&`{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 &= l2
		
		}
		 `^`{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 ^= l2
		
		}
		 `|`{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 |= l2
		
		}
		 `*`{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 *= l2
		
		}
		 178, `/`, `%`, 176, 177{
		if l2 == 0 {
			if const_wanted {
			tcc_error(c'division by zero in constant')
			}
			goto _GOTO_PLACEHOLDER_0x7fffbd146b90 // id: 0x7fffbd146b90
		}
		match op {
		
		 `%`{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 - l2 * gen_opic_sdiv(l1, l2)
		
		}
		 176{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 / l2
		
		}
		 177{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 % l2
		
		}
		else {
		l1 = gen_opic_sdiv(l1, l2)
		}
		}
		
		}
		 1{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 <<= (l2 & shm)
		
		}
		 201{ // case comp body kind=CompoundAssignOperator is_enum=false
		l1 >>= (l2 & shm)
		
		}
		 2{ // case comp body kind=BinaryOperator is_enum=false
		l1 = if (l1 >> 63){ ~(~l1 >> (l2 & shm)) } else {l1 >> (l2 & shm)}
		
		}
		 146{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 < l2
		
		}
		 147{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 >= l2
		
		}
		 148{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 == l2
		
		}
		 149{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 != l2
		
		}
		 150{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 <= l2
		
		}
		 151{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 > l2
		
		}
		 156{ // case comp body kind=BinaryOperator is_enum=false
		l1 = gen_opic_lt(l1, l2)
		
		}
		 157{ // case comp body kind=BinaryOperator is_enum=false
		l1 = !gen_opic_lt(l1, l2)
		
		}
		 158{ // case comp body kind=BinaryOperator is_enum=false
		l1 = !gen_opic_lt(l2, l1)
		
		}
		 159{ // case comp body kind=BinaryOperator is_enum=false
		l1 = gen_opic_lt(l2, l1)
		
		}
		 160{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 && l2
		
		}
		 161{ // case comp body kind=BinaryOperator is_enum=false
		l1 = l1 || l2
		
		}
		else {
		goto _GOTO_PLACEHOLDER_0x7fffbd146b90 // id: 0x7fffbd146b90
		}
		}
		if t1 != 4 && (8 != 8 || t1 != 5) {
		l1 = (u32(l1) | (if v1.type_.t & 16{ 0 } else {-(l1 & 2147483648)}))
		}
		v1..c.i = l1
		vtop --
	}
	else {
		if c1 && (op == `+` || op == `&` || op == `^` || op == `|` || op == `*` || op == 148 || op == 149) {
			vswap()
			c2 = c1
			l2 = l1
		}
		if !const_wanted && c1 && ((l1 == 0 && (op == 1 || op == 201 || op == 2)) || (l1 == -1 && op == 2)) {
			vtop --
		}
		else if !const_wanted && c2 && ((l2 == 0 && (op == `&` || op == `*`)) || (op == `|` && (l2 == -1 || (l2 == 4294967295 && t2 != 4))) || (l2 == 1 && (op == `%` || op == 177))) {
			if l2 == 1 {
			vtop..c.i = 0
			}
			vswap()
			vtop --
		}
		else if c2 && (((op == `*` || op == `/` || op == 176 || op == 178) && l2 == 1) || ((op == `+` || op == `-` || op == `|` || op == `^` || op == 1 || op == 201 || op == 2) && l2 == 0) || (op == `&` && (l2 == -1 || (l2 == 4294967295 && t2 != 4)))) {
			vtop --
		}
		else if c2 && (op == `*` || op == 178 || op == 176) {
			if l2 > 0 && (l2 & (l2 - 1)) == 0 {
				n := -1
				for l2 {
					l2 >>= 1
					n ++
				}
				vtop..c.i = n
				if op == `*` {
				op = 1
				}
				else if op == 178 {
				op = 2
				}
				else { // 3
				op = 201
}
			}
			goto _GOTO_PLACEHOLDER_0x7fffbd146b90 // id: 0x7fffbd146b90
		}
		else if c2 && (op == `+` || op == `-`) && (((vtop [-1] .r & (63 | 256 | 512)) == (48 | 512)) || (vtop [-1] .r & (63 | 256)) == 50) {
			if op == `-` {
			l2 = -l2
			}
			l2 += vtop [-1] ..c.i
			if int(l2) != l2 {
			goto _GOTO_PLACEHOLDER_0x7fffbd146b90 // id: 0x7fffbd146b90
			}
			vtop --
			vtop..c.i = l2
		}
		else {
			// RRRREG general_case id=0x7fffbd146b90
			general_case: 
			if t1 == 4 || t2 == 4 || (8 == 8 && (t1 == 5 || t2 == 5)) {
			gen_opl(op)
			}
			else { // 3
			gen_opi(op)
}
		}
	}
}

fn gen_opif(op int)  {
	c1 := 0
	c2 := 0
	
	v1 := &SValue(0)
	v2 := &SValue(0)
	
	f1 := 0.0
	f2 := 0.0
	
	v1 = vtop - 1
	v2 = vtop
	c1 = (v1.r & (63 | 256 | 512)) == 48
	c2 = (v2.r & (63 | 256 | 512)) == 48
	if c1 && c2 {
		if v1.type_.t == 8 {
			f1 = v1..c.f
			f2 = v2..c.f
		}
		else if v1.type_.t == 9 {
			f1 = v1..c.d
			f2 = v2..c.d
		}
		else {
			f1 = v1..c.ld
			f2 = v2..c.ld
		}
		if !ieee_finite(f1) || !ieee_finite(f2) {
		goto general_case // id: 0x7fffbd1569e8
		}
		match op {
		 `+`{ // case comp body kind=CompoundAssignOperator is_enum=false
		f1 += f2
		
		}
		 `-`{ // case comp body kind=CompoundAssignOperator is_enum=false
		f1 -= f2
		
		}
		 `*`{ // case comp body kind=CompoundAssignOperator is_enum=false
		f1 *= f2
		
		}
		 `/`{ // case comp body kind=IfStmt is_enum=false
		if f2 == 0 {
			if !const_wanted {
			goto general_case // id: 0x7fffbd1569e8
			}
		}
		f1 /= f2
		
		}
		else {
		goto general_case // id: 0x7fffbd1569e8
		}
		}
		if v1.type_.t == 8 {
			v1..c.f = f1
		}
		else if v1.type_.t == 9 {
			v1..c.d = f1
		}
		else {
			v1..c.ld = f1
		}
		vtop --
	}
	else {
		// RRRREG general_case id=0x7fffbd1569e8
		general_case: 
		gen_opf(op)
	}
}

fn pointed_size(type_ &CType) int {
	align := 0
	return type_size(pointed_type(type_), &align)
}

fn vla_runtime_pointed_size(type_ &CType)  {
	align := 0
	vla_runtime_type_size(pointed_type(type_), &align)
}

fn is_null_pointer(p &SValue) int {
	if (p.r & (63 | 256 | 512)) != 48 {
	return 0
	}
	return ((p.type_.t & 15) == 3 && u32(p..c.i) == 0) || ((p.type_.t & 15) == 4 && p..c.i == 0) || ((p.type_.t & 15) == 5 && (if 8 == 4{ u32(p..c.i) == 0 } else {p..c.i == 0}) && ((pointed_type(&p.type_).t & 15) == 0) && 0 == (pointed_type(&p.type_).t & (256 | 512)))
}

fn is_integer_btype(bt int) int {
	return (bt == 1 || bt == 2 || bt == 3 || bt == 4)
}

fn check_comparison_pointer_types(p1 &SValue, p2 &SValue, op int)  {
	type1 := &CType(0)
	type2 := &CType(0)
	tmp_type1 := CType{}
	tmp_type2 := CType{}
	
	bt1 := 0
	bt2 := 0
	
	if is_null_pointer(p1) || is_null_pointer(p2) {
	return 
	}
	type1 = &p1.type_
	type2 = &p2.type_
	bt1 = type1.t & 15
	bt2 = type2.t & 15
	if (is_integer_btype(bt1) || is_integer_btype(bt2)) && op != `-` {
		if op != 161 && op != 160 {
		tcc_warning(c'comparison between pointer and integer')
		}
		return 
	}
	if bt1 == 5 {
		type1 = pointed_type(type1)
	}
	else if bt1 != 6 {
	goto invalid_operands // id: 0x7fffbd15a9b8
	}
	if bt2 == 5 {
		type2 = pointed_type(type2)
	}
	else if bt2 != 6 {
		// RRRREG invalid_operands id=0x7fffbd15a9b8
		invalid_operands: 
		tcc_error(c'invalid operands to binary %s', get_tok_str(op, (voidptr(0))))
	}
	if (type1.t & 15) == 0 || (type2.t & 15) == 0 {
	return 
	}
	tmp_type1 = *type1
	tmp_type2 = *type2
	tmp_type1.t &= ~(32 | 16 | 256 | 512)
	tmp_type2.t &= ~(32 | 16 | 256 | 512)
	if !is_compatible_types(&tmp_type1, &tmp_type2) {
		if op == `-` {
		goto invalid_operands // id: 0x7fffbd15a9b8
		}
		else { // 3
		tcc_warning(c'comparison of distinct pointer types lacks a cast')
}
	}
}

fn gen_op(op int)  {
	u := 0
	t1 := 0
	t2 := 0
	bt1 := 0
	bt2 := 0
	t := 0
	
	type1 := CType{}
	// RRRREG redo id=0x7fffbd15c080
	redo: 
	t1 = vtop [-1] .type_.t
	t2 = vtop [0] .type_.t
	bt1 = t1 & 15
	bt2 = t2 & 15
	if bt1 == 7 || bt2 == 7 {
		tcc_error(c'operation on a struct')
	}
	else if bt1 == 6 || bt2 == 6 {
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
		goto _GOTO_PLACEHOLDER_0x7fffbd15c080 // id: 0x7fffbd15c080
	}
	else if bt1 == 5 || bt2 == 5 {
		if op >= 146 && op <= 161 {
			check_comparison_pointer_types(vtop - 1, vtop, op)
			t = 4 | 16
			goto std_op // id: 0x7fffbd15cfd8
		}
		if bt1 == 5 && bt2 == 5 {
			if op != `-` {
			tcc_error(c'cannot use pointers here')
			}
			check_comparison_pointer_types(vtop - 1, vtop, op)
			if vtop [-1] .type_.t & 1024 {
				vla_runtime_pointed_size(&vtop [-1] .type_)
			}
			else {
				vpushi(pointed_size(&vtop [-1] .type_))
			}
			vrott(3)
			gen_opic(op)
			vtop.type_.t = ptrdiff_type.t
			vswap()
			gen_op(178)
		}
		else {
			if op != `-` && op != `+` {
			tcc_error(c'cannot use pointers here')
			}
			if bt2 == 5 {
				vswap()
				t = t1 , t2
				t1 = t = t1 , t
				t2 = t = t1 , t2
				t1 = t = t1
			}
			type1 = vtop [-1] .type_
			type1.t &= ~64
			if vtop [-1] .type_.t & 1024 {
			vla_runtime_pointed_size(&vtop [-1] .type_)
			}
			else {
				u = pointed_size(&vtop [-1] .type_)
				if u < 0 {
				tcc_error(c'unknown array element size')
				}
				vpushll(u)
			}
			gen_op(`*`)
			{
				gen_opic(op)
			}
			vtop.type_ = type1
		}
	}
	else if is_float(bt1) || is_float(bt2) {
		if bt1 == 10 || bt2 == 10 {
			t = 10
		}
		else if bt1 == 9 || bt2 == 9 {
			t = 9
		}
		else {
			t = 8
		}
		if op != `+` && op != `-` && op != `*` && op != `/` && (op < 146 || op > 159) {
		tcc_error(c'invalid operands for binary operation')
		}
		goto std_op // id: 0x7fffbd15cfd8
	}
	else if op == 201 || op == 2 || op == 1 {
		t = if bt1 == 4{ 4 } else {3}
		if (t1 & (15 | 16 | 128)) == (t | 16) {
		t |= 16
		}
		t |= (2048 & t1)
		goto std_op // id: 0x7fffbd15cfd8
	}
	else if bt1 == 4 || bt2 == 4 {
		t = 4 | 2048
		if bt1 == 4 {
		t &= t1
		}
		if bt2 == 4 {
		t &= t2
		}
		if (t1 & (15 | 16 | 128)) == (4 | 16) || (t2 & (15 | 16 | 128)) == (4 | 16) {
		t |= 16
		}
		goto std_op // id: 0x7fffbd15cfd8
	}
	else {
		t = 3 | (2048 & (t1 | t2))
		if (t1 & (15 | 16 | 128)) == (3 | 16) || (t2 & (15 | 16 | 128)) == (3 | 16) {
		t |= 16
		}
		// RRRREG std_op id=0x7fffbd15cfd8
		std_op: 
		if t & 16 {
			if op == 2 {
			op = 201
			}
			else if op == `/` {
			op = 176
			}
			else if op == `%` {
			op = 177
			}
			else if op == 156 {
			op = 146
			}
			else if op == 159 {
			op = 151
			}
			else if op == 158 {
			op = 150
			}
			else if op == 157 {
			op = 147
			}
		}
		vswap()
		type1.t = t
		type1.ref = (voidptr(0))
		gen_cast(&type1)
		vswap()
		if op == 201 || op == 2 || op == 1 {
		type1.t = 3
		}
		gen_cast(&type1)
		if is_float(t) {
		gen_opif(op)
		}
		else { // 3
		gen_opic(op)
}
		if op >= 146 && op <= 159 {
			vtop.type_.t = 3
		}
		else {
			vtop.type_.t = t
		}
	}
	if vtop.r & 256 {
	gv(if is_float(vtop.type_.t & 15){ 2 } else {1})
	}
}

fn gen_cvt_itof1(t int)  {
	if (vtop.type_.t & (15 | 16)) == (4 | 16) {
		if t == 8 {
		vpush_global_sym(&func_old_type, Tcc_token.tok___floatundisf)
		}
		else if t == 10 {
		vpush_global_sym(&func_old_type, Tcc_token.tok___floatundixf)
		}
		else { // 3
		vpush_global_sym(&func_old_type, Tcc_token.tok___floatundidf)
}
		vrott(2)
		gfunc_call(1)
		vpushi(0)
		vtop.r = reg_fret(t)
	}
	else {
		gen_cvt_itof(t)
	}
}

fn gen_cvt_ftoi1(t int)  {
	st := 0
	if t == (4 | 16) {
		st = vtop.type_.t & 15
		if st == 8 {
		vpush_global_sym(&func_old_type, Tcc_token.tok___fixunssfdi)
		}
		else if st == 10 {
		vpush_global_sym(&func_old_type, Tcc_token.tok___fixunsxfdi)
		}
		else { // 3
		vpush_global_sym(&func_old_type, Tcc_token.tok___fixunsdfdi)
}
		vrott(2)
		gfunc_call(1)
		vpushi(0)
		vtop.r = treg_rax
		vtop.r2 = treg_rdx
	}
	else {
		gen_cvt_ftoi(t)
	}
}

fn force_charshort_cast(t int)  {
	bits := 0
	dbt := 0
	
	if (nocode_wanted & 3221225472) {
	return 
	}
	dbt = t & 15
	if dbt == 1 {
	bits = 8
	}
	else { // 3
	bits = 16
}
	if t & 16 {
		vpushi((1 << bits) - 1)
		gen_op(`&`)
	}
	else {
		if (vtop.type_.t & 15) == 4 {
		bits = 64 - bits
		}
		else { // 3
		bits = 32 - bits
}
		vpushi(bits)
		gen_op(1)
		vtop.type_.t &= ~16
		vpushi(bits)
		gen_op(2)
	}
}

fn gen_cast_s(t int)  {
	type_ := CType{}
	type_.t = t
	type_.ref = (voidptr(0))
	gen_cast(&type_)
}

fn gen_cast(type_ &CType)  {
	sbt := 0
	dbt := 0
	sf := 0
	df := 0
	c := 0
	p := 0
	
	if vtop.r & 1024 {
		vtop.r &= ~1024
		force_charshort_cast(vtop.type_.t)
	}
	if vtop.type_.t & 128 {
		gv(1)
	}
	dbt = type_.t & (15 | 16)
	sbt = vtop.type_.t & (15 | 16)
	if sbt != dbt {
		sf = is_float(sbt)
		df = is_float(dbt)
		c = (vtop.r & (63 | 256 | 512)) == 48
		p = (vtop.r & (63 | 256 | 512)) == (48 | 512)
		if c {
			if sbt == 8 {
			vtop..c.ld = vtop..c.f
			}
			else if sbt == 9 {
			vtop..c.ld = vtop..c.d
			}
			if df {
				if (sbt & 15) == 4 {
					if (sbt & 16) || !(vtop..c.i >> 63) {
					vtop..c.ld = vtop..c.i
					}
					else { // 3
					vtop..c.ld = -f64(-vtop..c.i)
}
				}
				else if !sf {
					if (sbt & 16) || !(vtop..c.i >> 31) {
					vtop..c.ld = u32(vtop..c.i)
					}
					else { // 3
					vtop..c.ld = -f64(-u32(vtop..c.i))
}
				}
				if dbt == 8 {
				vtop..c.f = f32(vtop..c.ld)
				}
				else if dbt == 9 {
				vtop..c.d = f64(vtop..c.ld)
				}
			}
			else if sf && dbt == (4 | 16) {
				vtop..c.i = vtop..c.ld
			}
			else if sf && dbt == 11 {
				vtop..c.i = (vtop..c.ld != 0)
			}
			else {
				if sf {
				vtop..c.i = vtop..c.ld
				}
				else if sbt == (4 | 16) {}
				else if sbt & 16 {
				vtop..c.i = u32(vtop..c.i)
				}
				else if sbt == 5 {}
				else if sbt != 4 {
				vtop..c.i = (u32(vtop..c.i) | -(vtop..c.i & 2147483648))
				}
				if dbt == (4 | 16) {}
				else if dbt == 11 {
				vtop..c.i = (vtop..c.i != 0)
				}
				else if dbt == 5 {}
				else if dbt != 4 {
					m := (if (dbt & 15) == 1{ 255 } else {if (dbt & 15) == 2{ 65535 } else {4294967295}})
					vtop..c.i &= m
					if !(dbt & 16) {
					vtop..c.i |= -(vtop..c.i & ((m >> 1) + 1))
					}
				}
			}
		}
		else if p && dbt == 11 {
			vtop.r = 48
			vtop..c.i = 1
		}
		else {
			if sf && df {
				gen_cvt_ftof(dbt)
			}
			else if df {
				gen_cvt_itof1(dbt)
			}
			else if sf {
				if dbt == 11 {
					vpushi(0)
					gen_op(149)
				}
				else {
					if dbt != (3 | 16) && dbt != (4 | 16) && dbt != 4 {
					dbt = 3
					}
					gen_cvt_ftoi1(dbt)
					if dbt == 3 && (type_.t & (15 | 16)) != dbt {
						vtop.type_.t = dbt
						gen_cast(type_)
					}
				}
			}
			else if (dbt & 15) == 4 || (dbt & 15) == 5 || (dbt & 15) == 6 {
				if (sbt & 15) != 4 && (sbt & 15) != 5 && (sbt & 15) != 6 {
					gv(1)
					if sbt != (3 | 16) {
						r := gv(1)
						o(25416)
						o(192 + (((r) & 7) << 3) + ((r) & 7))
					}
					else if sbt & 16 {
					}
				}
			}
			else if dbt == 11 {
				vpushi(0)
				gen_op(149)
			}
			else if (dbt & 15) == 1 || (dbt & 15) == 2 {
				if sbt == 5 {
					vtop.type_.t = 3
					tcc_warning(c'nonportable conversion from pointer to char/short')
				}
				force_charshort_cast(dbt)
			}
			else if (dbt & 15) == 3 {
				if (sbt & 15) == 4 {
					if dbt & 16 {
						vpushi(4294967295)
						vtop.type_.t |= 16
						gen_op(`&`)
					}
					else {
					}
				}
			}
		}
	}
	else if (dbt & 15) == 5 && !(vtop.r & 256) {
		vtop.r = (vtop.r & ~(4096 | 8192 | 16384)) | (lvalue_type(type_.ref.type_.t) & (4096 | 8192 | 16384))
	}
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
		return s...c
	}
	else if bt == 5 {
		if type_.t & 64 {
			ts := 0
			s = type_.ref
			ts = type_size(&s.type_, a)
			if ts < 0 && s...c < 0 {
			ts = -ts
			}
			return ts * s...c
		}
		else {
			*a = 8
			return 8
		}
	}
	else if ((type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) && type_.ref...c < 0 {
		return -1
	}
	else if bt == 10 {
		*a = 16
		return 16
	}
	else if bt == 9 || bt == 4 {
		*a = 8
		return 8
	}
	else if bt == 3 || bt == 8 {
		*a = 4
		return 4
	}
	else if bt == 2 {
		*a = 2
		return 2
	}
	else if bt == 13 || bt == 14 {
		*a = 8
		return 16
	}
	else {
		*a = 1
		return 1
	}
}

fn vla_runtime_type_size(type_ &CType, a &int)  {
	if type_.t & 1024 {
		type_size(&type_.ref.type_, a)
		vset(&int_type, 50 | 256, type_.ref...c)
	}
	else {
		vpushi(type_size(type_, a))
	}
}

fn pointed_type(type_ &CType) &CType {
	return &type_.ref.type_
}

fn mk_pointer(type_ &CType)  {
	s := &Sym(0)
	s = sym_push(536870912, type_, 0, -1)
	type_.t = 5 | (type_.t & (4096 | 8192 | 16384 | 32768))
	type_.ref = s
}

fn is_compatible_func(type1 &CType, type2 &CType) int {
	s1 := &Sym(0)
	s2 := &Sym(0)
	
	s1 = type1.ref
	s2 = type2.ref
	if s1....f.func_call != s2....f.func_call {
	return 0
	}
	if s1....f.func_type != s2....f.func_type && s1....f.func_type != 2 && s2....f.func_type != 2 {
	return 0
	}
	if s1....f.func_type == 2 && !s1..next {
	return 1
	}
	if s2....f.func_type == 2 && !s2..next {
	return 1
	}
	for  ;  ;  {
		if !is_compatible_unqualified_types(&s1.type_, &s2.type_) {
		return 0
		}
		s1 = s1..next
		s2 = s2..next
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
	if (t1 & 64) && !(type1.ref...c < 0 || type2.ref...c < 0 || type1.ref...c == type2.ref...c) {
	return 0
	}
	bt1 = t1 & 15
	if bt1 == 5 {
		type1 = pointed_type(type1)
		type2 = pointed_type(type2)
		return is_compatible_types(type1, type2)
	}
	else if bt1 == 7 {
		return (type1.ref == type2.ref)
	}
	else if bt1 == 6 {
		return is_compatible_func(type1, type2)
	}
	else if ((type1.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) || ((type2.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
		return type1.ref == type2.ref
	}
	else {
		return 1
	}
}

fn is_compatible_types(type1 &CType, type2 &CType) int {
	return compare_types(type1, type2, 0)
}

fn is_compatible_unqualified_types(type1 &CType, type2 &CType) int {
	return compare_types(type1, type2, 1)
}

fn type_to_str(buf &i8, buf_size int, type_ &CType, varstr &i8)  {
	bt := 0
	v := 0
	t := 0
	
	s := &Sym(0)
	sa := &Sym(0)
	
	buf1 := [256]i8{}
	tstr := &i8(0)
	t = type_.t
	bt = t & 15
	buf [0]  = ` `
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
	if t & 512 {
	pstrcat(buf, buf_size, c'volatile ')
	}
	if t & 256 {
	pstrcat(buf, buf_size, c'const ')
	}
	if ((t & 32) && bt == 1) || ((t & 16) && (bt == 2 || bt == 3 || bt == 4) && !((t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20))) {
	pstrcat(buf, buf_size, if (t & 16){ c'unsigned ' } else {c'signed '})
	}
	buf_size -= C.strlen(buf)
	buf += C.strlen(buf)
	match bt {
	 0{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'void'
	goto add_tstr // id: 0x7fffbd17f188
	}
	 11{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'_Bool'
	goto add_tstr // id: 0x7fffbd17f188
	}
	 1{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'char'
	goto add_tstr // id: 0x7fffbd17f188
	}
	 2{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'short'
	goto add_tstr // id: 0x7fffbd17f188
	}
	 3{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'int'
	goto maybe_long // id: 0x7fffbd17f630
	}
	 4{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'long long'
	// RRRREG maybe_long id=0x7fffbd17f630
	maybe_long: 
	if t & 2048 {
	tstr = c'long'
	}
	if !((t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
	goto add_tstr // id: 0x7fffbd17f188
	}
	tstr = c'enum '
	goto tstruct // id: 0x7fffbd17fd40
	}
	 8{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'float'
	goto add_tstr // id: 0x7fffbd17f188
	}
	 9{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'double'
	goto add_tstr // id: 0x7fffbd17f188
	}
	 10{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'long double'
	// RRRREG add_tstr id=0x7fffbd17f188
	add_tstr: 
	pstrcat(buf, buf_size, tstr)
	
	}
	 7{ // case comp body kind=BinaryOperator is_enum=false
	tstr = c'struct '
	if ((t & ((((1 << (6 + 6)) - 1) << 20 | 128) | 15)) == (1 << 20 | 7)) {
	tstr = c'union '
	}
	// RRRREG tstruct id=0x7fffbd17fd40
	tstruct: 
	pstrcat(buf, buf_size, tstr)
	v = type_.ref.v & ~1073741824
	if v >= 268435456 {
	pstrcat(buf, buf_size, c'<anonymous>')
	}
	else { // 3
	pstrcat(buf, buf_size, get_tok_str(v, (voidptr(0))))
}
	
	}
	 6{ // case comp body kind=BinaryOperator is_enum=false
	s = type_.ref
	buf1 [0]  = 0
	if varstr && `*` == *varstr {
		pstrcat(buf1, sizeof(buf1), c'(')
		pstrcat(buf1, sizeof(buf1), varstr)
		pstrcat(buf1, sizeof(buf1), c')')
	}
	pstrcat(buf1, buf_size, c'(')
	sa = s..next
	for sa != (voidptr(0)) {
		buf2 := [256]i8{}
		type_to_str(buf2, sizeof(buf2), &sa.type_, (voidptr(0)))
		pstrcat(buf1, sizeof(buf1), buf2)
		sa = sa..next
		if sa {
		pstrcat(buf1, sizeof(buf1), c', ')
		}
	}
	if s....f.func_type == 3 {
	pstrcat(buf1, sizeof(buf1), c', ...')
	}
	pstrcat(buf1, sizeof(buf1), c')')
	type_to_str(buf, buf_size, &s.type_, buf1)
	goto no_var // id: 0x7fffbd1827f8
	}
	 5{ // case comp body kind=BinaryOperator is_enum=false
	s = type_.ref
	if t & 64 {
		if varstr && `*` == *varstr {
		C.snprintf(buf1, sizeof(buf1), c'(%s)[%d]', varstr, s...c)
		}
		else { // 3
		C.snprintf(buf1, sizeof(buf1), c'%s[%d]', if varstr{ varstr } else {c''}, s...c)
}
		type_to_str(buf, buf_size, &s.type_, buf1)
		goto no_var // id: 0x7fffbd1827f8
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
	goto no_var // id: 0x7fffbd1827f8
	}
	else{}
	}
	if varstr {
		pstrcat(buf, buf_size, c' ')
		pstrcat(buf, buf_size, varstr)
	}
	// RRRREG no_var id=0x7fffbd1827f8
	no_var: 
	0
}

fn gen_assign_cast(dt &CType)  {
	st := &CType(0)
	type1 := &CType(0)
	type2 := &CType(0)
	
	buf1 := [256]i8{}
	buf2 := [256]i8{}
	
	dbt := 0
	sbt := 0
	qualwarn := 0
	lvl := 0
	
	st = &vtop.type_
	dbt = dt.t & 15
	sbt = st.t & 15
	if sbt == 0 || dbt == 0 {
		if sbt == 0 && dbt == 0 {}
		else { // 3
		tcc_error(c'cannot cast from/to void')
}
	}
	if dt.t & 256 {
	tcc_warning(c'assignment of read-only location')
	}
	match dbt {
	 5{ // case comp body kind=IfStmt is_enum=false
	if is_null_pointer(vtop) {
	
	}
	if is_integer_btype(sbt) {
		tcc_warning(c'assignment makes pointer from integer without a cast')
		
	}
	type1 = pointed_type(dt)
	if sbt == 5 {
	type2 = pointed_type(st)
	}
	else if sbt == 6 {
	type2 = st
	}
	else { // 3
	goto error // id: 0x7fffbd1857f8
	
}
	if is_compatible_types(type1, type2) {
	
	}
	for qualwarn = 0
	lvl = qualwarn ;  ; lvl ++ {
		if ((type2.t & 256) && !(type1.t & 256)) || ((type2.t & 512) && !(type1.t & 512)) {
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
		}
		else if dbt == sbt && is_integer_btype(sbt & 15) && ((type1.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) + ((type2.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) + !!((type1.t ^ type2.t) & 16) < 2 {
		}
		else {
			tcc_warning(c'assignment from incompatible pointer type')
			
		}
	}
	if qualwarn {
	tcc_warning(c'assignment discards qualifiers from pointer target type')
	}
	
	}
	 1, 2, 3, 4{
	if sbt == 5 || sbt == 6 {
		tcc_warning(c'assignment makes integer from pointer without a cast')
	}
	else if sbt == 7 {
		goto case_VT_STRUCT // id: 0x7fffbd187ab0
	}
	
	}
	 7{ // case comp body kind=LabelStmt is_enum=false
	// RRRREG case_VT_STRUCT id=0x7fffbd187ab0
	case_VT_STRUCT: 
	if !is_compatible_unqualified_types(dt, st) {
		// RRRREG error id=0x7fffbd1857f8
		error: 
		type_to_str(buf1, sizeof(buf1), st, (voidptr(0)))
		type_to_str(buf2, sizeof(buf2), dt, (voidptr(0)))
		tcc_error(c"cannot cast '%s' to '%s'", buf1, buf2)
	}
	
	}
	else{}
	}
	gen_cast(dt)
}

fn vstore()  {
	sbt := 0
	dbt := 0
	ft := 0
	r := 0
	t := 0
	size := 0
	align := 0
	bit_size := 0
	bit_pos := 0
	rc := 0
	delayed_cast := 0
	
	ft = vtop [-1] .type_.t
	sbt = vtop.type_.t & 15
	dbt = ft & 15
	if (((sbt == 3 || sbt == 2) && dbt == 1) || (sbt == 3 && dbt == 2)) && !(vtop.type_.t & 128) {
		delayed_cast = 1024
		vtop.type_.t = ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))
		if ft & 256 {
		tcc_warning(c'assignment of read-only location')
		}
	}
	else {
		delayed_cast = 0
		if !(ft & 128) {
		gen_assign_cast(&vtop [-1] .type_)
		}
	}
	if sbt == 7 {
		size = type_size(&vtop.type_, &align)
		vswap()
		vtop.type_.t = 5
		gaddrof()
		vpush_global_sym(&func_old_type, Tcc_token.tok_memmove)
		vswap()
		vpushv(vtop - 2)
		vtop.type_.t = 5
		gaddrof()
		vpushi(size)
		gfunc_call(3)
	}
	else if ft & 128 {
		vdup() , vtop [-2] 
		vtop [-1]  = vdup()
		bit_pos = (((ft) >> 20) & 63)
		bit_size = (((ft) >> (20 + 6)) & 63)
		vtop [-1] .type_.t = ft & ~(((1 << (6 + 6)) - 1) << 20 | 128)
		if (ft & 15) == 11 {
			gen_cast(&vtop [-1] .type_)
			vtop [-1] .type_.t = (vtop [-1] .type_.t & ~15) | (1 | 16)
		}
		r = adjust_bf(vtop - 1, bit_pos, bit_size)
		if r == 7 {
			gen_cast_s(if (ft & 15) == 4{ 4 } else {3})
			store_packed_bf(bit_pos, bit_size)
		}
		else {
			mask := (1 << bit_size) - 1
			if (ft & 15) != 11 {
				if (vtop [-1] .type_.t & 15) == 4 {
				vpushll(mask)
				}
				else { // 3
				vpushi(u32(mask))
}
				gen_op(`&`)
			}
			vpushi(bit_pos)
			gen_op(1)
			vswap()
			vdup()
			vrott(3)
			if (vtop.type_.t & 15) == 4 {
			vpushll(~(mask << bit_pos))
			}
			else { // 3
			vpushi(~(u32(mask) << bit_pos))
}
			gen_op(`&`)
			gen_op(`|`)
			vstore()
			vpop()
		}
	}
	else if dbt == 0 {
		vtop --$
	}
	else {
		if vtop [-1] .r & 2048 {
			vswap()
			gbound()
			vswap()
		}
		rc = 1
		if is_float(ft) {
			rc = 2
			if (ft & 15) == 10 {
				rc = 128
			}
			else if (ft & 15) == 14 {
				rc = 4096
			}
		}
		r = gv(rc)
		if (vtop [-1] .r & 63) == 49 {
			sv := SValue{}
			t = get_reg(1)
			sv.type_.t = 5
			sv.r = 50 | 256
			sv..c.i = vtop [-1] ..c.i
			load(t, &sv)
			vtop [-1] .r = t | 256
		}
		if ((ft & 15) == 13) || ((ft & 15) == 14) {
			addr_type := 4
load_size := 8
load_type := if ((vtop.type_.t & 15) == 13){ 4 } else {9}

			vtop [-1] .type_.t = load_type
			store(r, vtop - 1)
			vswap()
			vtop.type_.t = addr_type
			gaddrof()
			vpushi(load_size)
			gen_op(`+`)
			vtop.r |= 256
			vswap()
			vtop [-1] .type_.t = load_type
			store(vtop.r2, vtop - 1)
		}
		else {
			store(r, vtop - 1)
		}
		vswap()
		vtop --
		vtop.r |= delayed_cast
	}
}

fn inc(post int, c int)  {
	test_lvalue()
	vdup()
	if post {
		gv_dup()
		vrotb(3)
		vrotb(3)
	}
	vpushi(c - 163)
	gen_op(`+`)
	vstore()
	if post {
	vpop()
	}
}

fn parse_mult_str(astr &CString, msg &i8)  {
	if tok != 185 {
	expect(msg)
	}
	cstr_new(astr)
	for tok == 185 {
		cstr_cat(astr, tokc.str.data, -1)
		next()
	}
	cstr_ccat(astr, ` `)
}

fn exact_log2p1(i int) int {
	ret := 0
	if !i {
	return 0
	}
	for ret = 1 ; i >= 1 << 8 ; ret += 8 {
	i >>= 8
	}
	if i >= 1 << 4 {
	ret += 4 , i >>= 4
	}
	if i >= 1 << 2 {
	ret += 2 , i >>= 2
	}
	if i >= 1 << 1 {
	ret ++
	}
	return ret
}

fn parse_attribute(ad &AttributeDef)  {
	t := 0
	n := 0
	
	astr := CString{}
	// RRRREG redo id=0x7fffbd193bf8
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
		match (t) {
		 .tok_cleanup1, .tok_cleanup2{
		{
			s := &Sym(0)
			skip(`(`)
			s = sym_find(tok)
			if !s {
				tcc_warning(c"implicit declaration of function '%s'", get_tok_str(tok, &tokc))
				s = external_global_sym(tok, &func_old_type)
			}
			ad.cleanup_func = s
			next()
			skip(`)`)
			
		}
		}
		 .tok_section1, .tok_section2{
		skip(`(`)
		parse_mult_str(&astr, c'section name')
		ad.section = find_section(tcc_state, &i8(astr.data))
		skip(`)`)
		cstr_free(&astr)
		
		}
		 .tok_alias1, .tok_alias2{
		skip(`(`)
		parse_mult_str(&astr, c'alias(\"target\")')
		ad.alias_target = tok_alloc(&i8(astr.data), astr.size - 1).tok
		skip(`)`)
		cstr_free(&astr)
		
		}
		 .tok_visibility1, .tok_visibility2{
		skip(`(`)
		parse_mult_str(&astr, c'visibility(\"default|hidden|internal|protected\")')
		if !C.strcmp(astr.data, c'default') {
		ad.a.visibility = 0
		}
		else if !C.strcmp(astr.data, c'hidden') {
		ad.a.visibility = 2
		}
		else if !C.strcmp(astr.data, c'internal') {
		ad.a.visibility = 1
		}
		else if !C.strcmp(astr.data, c'protected') {
		ad.a.visibility = 3
		}
		else { // 3
		expect(c'visibility(\"default|hidden|internal|protected\")')
}
		skip(`)`)
		cstr_free(&astr)
		
		}
		 .tok_aligned1, .tok_aligned2{
		if tok == `(` {
			next()
			n = expr_const()
			if n <= 0 || (n & (n - 1)) != 0 {
			tcc_error(c'alignment must be a positive power of two')
			}
			skip(`)`)
		}
		else {
			n = 16
		}
		ad.a.aligned = exact_log2p1(n)
		if n != 1 << (ad.a.aligned - 1) {
		tcc_error(c'alignment of %d is larger than implemented', n)
		}
		
		}
		 .tok_packed1, .tok_packed2{
		ad.a.packed = 1
		
		}
		 .tok_weak1, .tok_weak2{
		ad.a.weak = 1
		
		}
		 .tok_unused1, .tok_unused2{
		
		}
		 .tok_noreturn1, .tok_noreturn2{
		ad.f.func_noreturn = 1
		
		}
		 .tok_cdecl1, .tok_cdecl2, .tok_cdecl3{
		ad.f.func_call = 0
		
		}
		 .tok_stdcall1, .tok_stdcall2, .tok_stdcall3{
		ad.f.func_call = 1
		
		}
		 .tok_mode{ // case comp body kind=CallExpr is_enum=true
		skip(`(`)
		match (tok) {
		 .tok_mode_di{ // case comp body kind=BinaryOperator is_enum=true
		ad.attr_mode = 4 + 1
		
		}
		 .tok_mode_qi{ // case comp body kind=BinaryOperator is_enum=true
		ad.attr_mode = 1 + 1
		
		}
		 .tok_mode_hi{ // case comp body kind=BinaryOperator is_enum=true
		ad.attr_mode = 2 + 1
		
		}
		 .tok_mode_si, .tok_mode_word{
		ad.attr_mode = 3 + 1
		
		
		}
		else {
		tcc_warning(c'__mode__(%s) not supported\n', get_tok_str(tok, (voidptr(0))))
		}
		}
		next()
		skip(`)`)
		
		}
		 .tok_dllexport{ // case comp body kind=BinaryOperator is_enum=true
		ad.a.dllexport = 1
		
		}
		 .tok_nodecorate{ // case comp body kind=BinaryOperator is_enum=true
		ad.a.nodecorate = 1
		
		}
		 .tok_dllimport{ // case comp body kind=BinaryOperator is_enum=true
		ad.a.dllimport = 1
		
		if tok == `(` {
			parenthesis := 0
			for {
			if tok == `(` {
			parenthesis ++
			}
			else if tok == `)` {
			parenthesis --
			}
			next()
			// while()
			if ! (parenthesis && tok != -1 ) { break }
			}
		}
		
		}
		else {
		if tcc_state.warn_unsupported {
		tcc_warning(c"'%s' attribute ignored", get_tok_str(t, (voidptr(0))))
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
	goto _GOTO_PLACEHOLDER_0x7fffbd193bf8 // id: 0x7fffbd193bf8
}

fn find_field(type_ &CType, v int, cumofs &int) &Sym {
	s := type_.ref
	v |= 536870912
	for (s = s..next) != (voidptr(0)) {
		if (s.v & 536870912) && (s.type_.t & 15) == 7 && (s.v & ~536870912) >= 268435456 {
			ret := find_field(&s.type_, v, cumofs)
			if ret {
				*cumofs += s...c
				return ret
			}
		}
		if s.v == v {
		break
		
		}
	}
	return s
}

fn struct_layout(type_ &CType, ad &AttributeDef)  {
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
	for f = type_.ref..next ; f ; f = f..next {
		if f.type_.t & 128 {
		bit_size = (((f.type_.t) >> (20 + 6)) & 63)
		}
		else { // 3
		bit_size = -1
}
		size = type_size(&f.type_, &align)
		a = if f.a.aligned{ 1 << (f.a.aligned - 1) } else {0}
		packed = 0
		if pcc && bit_size == 0 {
		}
		else {
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
		}
		else if bit_size < 0 {
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
		}
		else {
			if pcc {
				if bit_size == 0 {
					// RRRREG new_field id=0x7fffbd19d608
					new_field: 
					c = (c + ((bit_pos + 7) >> 3) + align - 1) & -align
					bit_pos = 0
				}
				else if f.a.aligned {
					goto new_field // id: 0x7fffbd19d608
				}
				else if !packed {
					a8 := align * 8
					ofs := ((c * 8 + bit_pos) % a8 + bit_size + a8 - 1) / a8
					if ofs > size / align {
					goto new_field // id: 0x7fffbd19d608
					}
				}
				if size == 8 && bit_size <= 32 {
				f.type_.t = (f.type_.t & ~15) | 3 , 4
				size = f.type_.t = (f.type_.t & ~15) | 3
				}
				for bit_pos >= align * 8 {
				c += align , bit_pos -= align * 8
				}
				offset = c
				if f.v & 268435456 {
				align = 1
				}
			}
			else {
				bt = f.type_.t & 15
				if (bit_pos + bit_size > size * 8) || (bit_size > 0) == (bt != prevbt) {
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
		f...c = offset
		f.r = 0
	}
	if pcc {
	c += (bit_pos + 7) >> 3
	}
	a = if ad.a.aligned{ 1 << (ad.a.aligned - 1) } else {1}
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
	type_.ref...c = c
	for f = type_.ref..next ; f ; f = f..next {
		s := 0
		px := 0
		cx := 0
		c0 := 0
		
		t := CType{}
		if 0 == (f.type_.t & 128) {
		continue
		
		}
		f.type_.ref = f
		f....auxtype = -1
		bit_size = (((f.type_.t) >> (20 + 6)) & 63)
		if bit_size == 0 {
		continue
		
		}
		bit_pos = (((f.type_.t) >> 20) & 63)
		size = type_size(&f.type_, &align)
		if bit_pos + bit_size <= size * 8 && f...c + size <= c {
		continue
		
		}
		c0 = -1 , align = 1
		s = c0 = -1
		for  ;  ;  {
			px = f...c * 8 + bit_pos
			cx = (px >> 3) & -align
			px = px - (cx << 3)
			if c0 == cx {
			break
			
			}
			s = (px + bit_size + 7) >> 3
			if s > 4 {
				t.t = 4
			}
			else if s > 2 {
				t.t = 3
			}
			else if s > 1 {
				t.t = 2
			}
			else {
				t.t = 1
			}
			s = type_size(&t, &align)
			c0 = cx
		}
		if px + bit_size <= s * 8 && cx + s <= c {
			f...c = cx
			bit_pos = px
			f.type_.t = (f.type_.t & ~(63 << 20)) | (bit_pos << 20)
			if s != size {
			f....auxtype = t.t
			}
		}
		else {
			f....auxtype = 7
		}
	}
}

fn struct_decl(type_ &CType, u int)  {
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
		if s && (s....sym_scope == local_scope || tok != `{`) {
			if u == s.type_.t {
			goto do_decl // id: 0x7fffbd1a4748
			}
			if u == (2 << 20) && ((s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (2 << 20)) {
			goto do_decl // id: 0x7fffbd1a4748
			}
			tcc_error(c"redefinition of '%s'", get_tok_str(v, (voidptr(0))))
		}
	}
	else {
		v = anon_sym ++
	}
	type1.t = if u == (2 << 20){ u | 3 | 16 } else {u}
	type1.ref = (voidptr(0))
	s = sym_push(v | 1073741824, &type1, 0, -1)
	s.r = 0
	// RRRREG do_decl id=0x7fffbd1a4748
	do_decl: 
	type_.t = s.type_.t
	type_.ref = s
	if tok == `{` {
		next()
		if s...c != -1 {
		tcc_error(c'struct/union/enum already defined')
		}
		s...c = -2
		ps = &s..next
		if u == (2 << 20) {
			ll := 0
pl := 0
nl := 0

			t := CType{}
			t.ref = s
			t.t = 3 | 8192 | (3 << 20)
			for  ;  ;  {
				v = tok
				if v < Tcc_token.tok_define {
				expect(c'identifier')
				}
				ss = sym_find(v)
				if ss && !local_stack {
				tcc_error(c"redefinition of enumerator '%s'", get_tok_str(v, (voidptr(0))))
				}
				next()
				if tok == `=` {
					next()
					ll = expr_const64()
				}
				ss = sym_push(v, &t, 48, 0)
				ss..enum_val = ll
				*ps = ss , &ss..next
				ps = *ps = ss
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
				ll ++
				if tok == `}` {
				break
				
				}
			}
			skip(`}`)
			t.t = 3
			if nl >= 0 {
				if pl != u32(pl) {
				t.t = (if 8 == 8{ 4 | 2048 } else {4})
				}
				t.t |= 16
			}
			else if pl != int(pl) || nl != int(nl) {
			t.t = (if 8 == 8{ 4 | 2048 } else {4})
			}
			s.type_.t = t.t | (2 << 20)
			type_.t = s.type_.t
			s...c = 0
			for ss = s..next ; ss ; ss = ss..next {
				ll = ss..enum_val
				if ll == int(ll) {
				continue
				
				}
				if t.t & 16 {
					ss.type_.t |= 16
					if ll == u32(ll) {
					continue
					
					}
				}
				ss.type_.t = (ss.type_.t & ~15) | (if 8 == 8{ 4 | 2048 } else {4})
			}
		}
		else {
			c = 0
			flexible = 0
			for tok != `}` {
				if !parse_btype(&btype, &ad1) {
					skip(`;`)
					continue
					
				}
				for 1 {
					if flexible {
					tcc_error(c"flexible array member '%s' not at the end of struct", get_tok_str(v, (voidptr(0))))
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
							}
							else {
								v := btype.ref.v
								if !(v & 536870912) && (v & ~1073741824) < 268435456 {
									if tcc_state.ms_extensions == 0 {
									expect(c'identifier')
									}
								}
							}
						}
						if type_size(&type1, &align) < 0 {
							if (u == 7) && (type1.t & 64) && c {
							flexible = 1
							}
							else { // 3
							tcc_error(c"field '%s' has incomplete type", get_tok_str(v, (voidptr(0))))
}
						}
						if (type1.t & 15) == 6 || (type1.t & 15) == 0 || (type1.t & (4096 | 8192 | 16384 | 32768)) {
						tcc_error(c"invalid type for '%s'", get_tok_str(v, (voidptr(0))))
						}
					}
					if tok == `:` {
						next()
						bit_size = expr_const()
						if bit_size < 0 {
						tcc_error(c"negative width in bit-field '%s'", get_tok_str(v, (voidptr(0))))
						}
						if v && bit_size == 0 {
						tcc_error(c"zero width for bit-field '%s'", get_tok_str(v, (voidptr(0))))
						}
						parse_attribute(&ad1)
					}
					size = type_size(&type1, &align)
					if bit_size >= 0 {
						bt = type1.t & 15
						if bt != 3 && bt != 1 && bt != 2 && bt != 11 && bt != 4 {
						tcc_error(c'bitfields must have scalar type')
						}
						bsize = size * 8
						if bit_size > bsize {
							tcc_error(c"width of '%s' exceeds its type", get_tok_str(v, (voidptr(0))))
						}
						else if bit_size == bsize && !ad.a.packed && !ad1.a.packed {
							0
						}
						else if bit_size == 64 {
							tcc_error(c'field width 64 not implemented')
						}
						else {
							type1.t = (type1.t & ~(((1 << (6 + 6)) - 1) << 20 | 128)) | 128 | (bit_size << (20 + 6))
						}
					}
					if v != 0 || (type1.t & 15) == 7 {
						c = 1
					}
					if v == 0 && ((type1.t & 15) == 7 || bit_size >= 0) {
						v = anon_sym ++
					}
					if v {
						ss = sym_push(v | 536870912, &type1, 0, 0)
						ss.a = ad1.a
						*ps = ss
						ps = &ss..next
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
			struct_layout(type_, &ad)
		}
	}
}

fn sym_to_attr(ad &AttributeDef, s &Sym)  {
	merge_symattr(&ad.a, &s.a)
	merge_funcattr(&ad.f, &s....f)
}

fn parse_btype_qualify(type_ &CType, qualifiers int)  {
	for type_.t & 64 {
		type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref...c)
		type_ = &type_.ref.type_
	}
	type_.t |= qualifiers
}

fn parse_btype(type_ &CType, ad &AttributeDef) int {
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
	type_.ref = (voidptr(0))
	for 1 {
		match (tok) {
		 .tok_extension{ // case comp body kind=CallExpr is_enum=true
		next()
		continue
		
		}
		 .tok_char{ // case comp body kind=BinaryOperator is_enum=true
		u = 1
		// RRRREG basic_type id=0x7fffbd1af290
		basic_type: 
		next()
		// RRRREG basic_type1 id=0x7fffbd1afae8
		basic_type1: 
		if u == 2 || u == 2048 {
			if st != -1 || (bt != -1 && bt != 3) {
			// RRRREG tmbt id=0x7fffbd1af6c8
			tmbt: 
			tcc_error(c'too many basic types')
			}
			st = u
		}
		else {
			if bt != -1 || (st != -1 && u != 3) {
			goto tmbt // id: 0x7fffbd1af6c8
			}
			bt = u
		}
		if u != 3 {
		t = (t & ~(15 | 2048)) | u
		}
		typespec_found = 1
		
		}
		 .tok_void{ // case comp body kind=BinaryOperator is_enum=true
		u = 0
		goto basic_type // id: 0x7fffbd1af290
		}
		 .tok_short{ // case comp body kind=BinaryOperator is_enum=true
		u = 2
		goto basic_type // id: 0x7fffbd1af290
		}
		 .tok_int{ // case comp body kind=BinaryOperator is_enum=true
		u = 3
		goto basic_type // id: 0x7fffbd1af290
		}
		 .tok_alignas// case comp stmt
			n := 0
			ad1 := AttributeDef{}
			next()
			skip(`(`)
			C.memset(&ad1, 0, sizeof(AttributeDef))
			if parse_btype(&type1, &ad1) {
				type_decl(&type1, &ad1, &n, 1)
				if ad1.a.aligned {
				n = 1 << (ad1.a.aligned - 1)
				}
				else { // 3
				type_size(&type1, &n)
}
			}
			else {
				n = expr_const()
				if n <= 0 || (n & (n - 1)) != 0 {
				tcc_error(c'alignment must be a positive power of two')
				}
			}
			skip(`)`)
			ad.a.aligned = exact_log2p1(n)
		}
		continue
		
		}
		 .tok_long{ // case comp body kind=IfStmt is_enum=true
		if (t & 15) == 9 {
			t = (t & ~(15 | 2048)) | 10
		}
		else if (t & (15 | 2048)) == 2048 {
			t = (t & ~(15 | 2048)) | 4
		}
		else {
			u = 2048
			goto basic_type // id: 0x7fffbd1af290
		}
		next()
		
		}
		 .tok_bool{ // case comp body kind=BinaryOperator is_enum=true
		u = 11
		goto basic_type // id: 0x7fffbd1af290
		}
		 .tok_float{ // case comp body kind=BinaryOperator is_enum=true
		u = 8
		goto basic_type // id: 0x7fffbd1af290
		}
		 .tok_double{ // case comp body kind=IfStmt is_enum=true
		if (t & (15 | 2048)) == 2048 {
			t = (t & ~(15 | 2048)) | 10
		}
		else {
			u = 9
			goto basic_type // id: 0x7fffbd1af290
		}
		next()
		
		}
		 .tok_enum{ // case comp body kind=CallExpr is_enum=true
		struct_decl(&type1, (2 << 20))
		// RRRREG basic_type2 id=0x7fffbd1b1eb0
		basic_type2: 
		u = type1.t
		type_.ref = type1.ref
		goto basic_type1 // id: 0x7fffbd1afae8
		}
		 .tok_struct{ // case comp body kind=CallExpr is_enum=true
		struct_decl(&type1, 7)
		goto basic_type2 // id: 0x7fffbd1b1eb0
		}
		 .tok_union{ // case comp body kind=CallExpr is_enum=true
		struct_decl(&type1, (1 << 20 | 7))
		goto basic_type2 // id: 0x7fffbd1b1eb0
		}
		 .tok_const1, .tok_const2, .tok_const3{
		type_.t = t
		parse_btype_qualify(type_, 256)
		t = type_.t
		next()
		
		}
		 .tok_volatile1, .tok_volatile2, .tok_volatile3{
		type_.t = t
		parse_btype_qualify(type_, 512)
		t = type_.t
		next()
		
		}
		 .tok_signed1, .tok_signed2, .tok_signed3{
		if (t & (32 | 16)) == (32 | 16) {
		tcc_error(c'signed and unsigned modifier')
		}
		t |= 32
		next()
		typespec_found = 1
		
		}
		 .tok_register, .tok_auto, .tok_restrict1, .tok_restrict2, .tok_restrict3{
		next()
		
		}
		 .tok_unsigned{ // case comp body kind=IfStmt is_enum=true
		if (t & (32 | 16)) == 32 {
		tcc_error(c'signed and unsigned modifier')
		}
		t |= 32 | 16
		next()
		typespec_found = 1
		
		}
		 .tok_extern{ // case comp body kind=BinaryOperator is_enum=true
		g = 4096
		goto storage // id: 0x7fffbd1b36a8
		}
		 .tok_static{ // case comp body kind=BinaryOperator is_enum=true
		g = 8192
		goto storage // id: 0x7fffbd1b36a8
		}
		 .tok_typedef{ // case comp body kind=BinaryOperator is_enum=true
		g = 16384
		goto storage // id: 0x7fffbd1b36a8
		// RRRREG storage id=0x7fffbd1b36a8
		storage: 
		if t & (4096 | 8192 | 16384) & ~g {
		tcc_error(c'multiple storage classes')
		}
		t |= g
		next()
		
		}
		 .tok_inline1, .tok_inline2, .tok_inline3{
		t |= 32768
		next()
		
		}
		 .tok_noreturn3{ // case comp body kind=CallExpr is_enum=true
		next()
		ad.f.func_noreturn = 1
		
		}
		 .tok_attribute1, .tok_attribute2{
		parse_attribute(ad)
		if ad.attr_mode {
			u = ad.attr_mode - 1
			t = (t & ~(15 | 2048)) | u
		}
		continue
		
		}
		 .tok_typeof1, .tok_typeof2, .tok_typeof3{
		next()
		parse_expr_type(&type1)
		type1.t &= ~((4096 | 8192 | 16384 | 32768) & ~16384)
		if type1.ref {
		sym_to_attr(ad, type1.ref)
		}
		goto basic_type2 // id: 0x7fffbd1b1eb0
		s = sym_find(tok)
		if !s || !(s.type_.t & 16384) {
		goto the_end // id: 0x7fffbd1b4b10
		}
		n = tok , next()
		if tok == `:` && !in_generic {
			unget_tok(n)
			goto the_end // id: 0x7fffbd1b4b10
		}
		t &= ~(15 | 2048)
		u = t & ~(256 | 512) , t ^= u
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
		goto the_end // id: 0x7fffbd1b4b10
		}
		}
		}
		type_found = 1
	}
	// RRRREG the_end id=0x7fffbd1b4b10
	the_end: 
	if tcc_state.char_is_unsigned {
		if (t & (32 | 15)) == 1 {
		t |= 16
		}
	}
	bt = t & (15 | 2048)
	if bt == 2048 {
	t |= if 8 == 8{ 4 } else {3}
	}
	type_.t = t
	return type_found
}

fn convert_parameter_type(pt &CType)  {
	pt.t &= ~(256 | 512)
	pt.t &= ~64
	if (pt.t & 15) == 6 {
		mk_pointer(pt)
	}
}

fn parse_asm_str(astr &CString)  {
	skip(`(`)
	parse_mult_str(astr, c'string constant')
}

fn asm_label_instr() int {
	v := 0
	astr := CString{}
	next()
	parse_asm_str(&astr)
	skip(`)`)
	v = tok_alloc(astr.data, astr.size - 1).tok
	cstr_free(&astr)
	return v
}

fn post_type(type_ &CType, ad &AttributeDef, storage int, td int) int {
	n := 0
	l := 0
	t1 := 0
	arg_size := 0
	align := 0
	unused_align := 0
	
	plast := &&Sym(0)
	s := &Sym(0)
	first := &Sym(0)
	
	ad1 := AttributeDef{}
	pt := CType{}
	if tok == `(` {
		next()
		if td && !(td & 1) {
		return 0
		}
		if tok == `)` {
		l = 0
		}
		else if parse_btype(&pt, &ad1) {
		l = 1
		}
		else if td {
			merge_attr(ad, &ad1)
			return 0
		}
		else { // 3
		l = 2
}
		first = (voidptr(0))
		plast = &first
		arg_size = 0
		if l {
			for  ;  ;  {
				if l != 2 {
					if (pt.t & 15) == 0 && tok == `)` {
					break
					
					}
					type_decl(&pt, &ad1, &n, 2 | 1)
					if (pt.t & 15) == 0 {
					tcc_error(c'parameter declared as void')
					}
				}
				else {
					n = tok
					if n < Tcc_token.tok_define {
					expect(c'identifier')
					}
					pt.t = 0
					pt.ref = (voidptr(0))
					next()
				}
				convert_parameter_type(&pt)
				arg_size += (type_size(&pt, &align) + 8 - 1) / 8
				s = sym_push(n | 536870912, &pt, 0, 0)
				*plast = s
				plast = &s..next
				if tok == `)` {
				break
				
				}
				skip(`,`)
				if l == 1 && tok == 200 {
					l = 3
					next()
					break
					
				}
				if l == 1 && !parse_btype(&pt, &ad1) {
				tcc_error(c'invalid type')
				}
			}
		}
		else { // 3
		l = 2
}
		skip(`)`)
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
		s....f = ad.f
		s..next = first
		type_.t = 6
		type_.ref = s
	}
	else if tok == `[` {
		saved_nocode_wanted := nocode_wanted
		next()
		for 1 {
			match (tok) {
			 .tok_restrict1, .tok_restrict2, .tok_restrict3, .tok_const1, .tok_volatile1, .tok_static, `*`{
			next()
			continue
			
			}
			else {
			
			}
			}
			break
			
		}
		n = -1
		t1 = 0
		if tok != `]` {
			if !local_stack || (storage & 8192) {
			vpushi(expr_const())
			}
			else {
				nocode_wanted = 0
				gexpr()
			}
			if (vtop.r & (63 | 256 | 512)) == 48 {
				n = vtop..c.i
				if n < 0 {
				tcc_error(c'invalid array size')
				}
			}
			else {
				if !is_integer_btype(vtop.type_.t & 15) {
				tcc_error(c'size of variable length array should be an integer')
				}
				n = 0
				t1 = 1024
			}
		}
		skip(`]`)
		post_type(type_, ad, storage, 0)
		if (type_.t & 15) == 6 {
		tcc_error(c'declaration of an array of functions')
		}
		if (type_.t & 15) == 0 || type_size(type_, &unused_align) < 0 {
		tcc_error(c'declaration of an array of incomplete type elements')
		}
		t1 |= type_.t & 1024
		if t1 & 1024 {
			if n < 0 {
			tcc_error(c'need explicit inner array size in VLAs')
			}
			loc -= type_size(&int_type, &align)
			loc &= -align
			n = loc
			vla_runtime_type_size(type_, &align)
			gen_op(`*`)
			vset(&int_type, 50 | 256, n)
			vswap()
			vstore()
		}
		if n != -1 {
		vpop()
		}
		nocode_wanted = saved_nocode_wanted
		s = sym_push(536870912, type_, 0, n)
		type_.t = (if t1{ 1024 } else {64}) | 5
		type_.ref = s
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
		// RRRREG redo id=0x7fffbd1bdfc8
		redo: 
		next()
		match (tok) {
		 .tok_const1, .tok_const2, .tok_const3{
		qualifiers |= 256
		goto redo // id: 0x7fffbd1bdfc8
		}
		 .tok_volatile1, .tok_volatile2, .tok_volatile3{
		qualifiers |= 512
		goto redo // id: 0x7fffbd1bdfc8
		}
		 .tok_restrict1, .tok_restrict2, .tok_restrict3{
		goto redo // id: 0x7fffbd1bdfc8
		}
		 .tok_attribute1, .tok_attribute2{
		parse_attribute(ad)
		
		}
		else{}
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
		}
		else { // 3
		goto abstract // id: 0x7fffbd1beec0
		
}
	}
	else if tok >= 256 && (td & 2) {
		*v = tok
		next()
	}
	else {
		// RRRREG abstract id=0x7fffbd1beec0
		abstract: 
		if !(td & 1) {
		expect(c'identifier')
		}
		*v = 0
	}
	post_type(post, ad, storage, 0)
	parse_attribute(ad)
	type_.t |= storage
	return ret
}

fn lvalue_type(t int) int {
	bt := 0
	r := 0
	
	r = 256
	bt = t & 15
	if bt == 1 || bt == 11 {
	r |= 4096
	}
	else if bt == 2 {
	r |= 8192
	}
	else {
	return r
	}
	if t & 16 {
	r |= 16384
	}
	return r
}

fn indir()  {
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
	if !(vtop.type_.t & 64) && !(vtop.type_.t & 1024) && (vtop.type_.t & 15) != 6 {
		vtop.r |= lvalue_type(vtop.type_.t)
		if tcc_state.do_bounds_check {
		vtop.r |= 2048
		}
	}
}

fn gfunc_param_typed(func &Sym, arg &Sym)  {
	func_type := 0
	type_ := CType{}
	func_type = func....f.func_type
	if func_type == 2 || (func_type == 3 && arg == (voidptr(0))) {
		if (vtop.type_.t & 15) == 8 {
			gen_cast_s(9)
		}
		else if vtop.type_.t & 128 {
			type_.t = vtop.type_.t & (15 | 16)
			type_.ref = vtop.type_.ref
			gen_cast(&type_)
		}
	}
	else if arg == (voidptr(0)) {
		tcc_error(c'too many arguments to function')
	}
	else {
		type_ = arg.type_
		type_.t &= ~256
		gen_assign_cast(&type_)
	}
}

fn expr_type(type_ &CType, expr_fn fn ())  {
	nocode_wanted ++
	expr_fn()
	*type_ = vtop.type_
	vpop()
	nocode_wanted --
}

fn parse_expr_type(type_ &CType)  {
	n := 0
	ad := AttributeDef{}
	skip(`(`)
	if parse_btype(type_, &ad) {
		type_decl(type_, &ad, &n, 1)
	}
	else {
		expr_type(type_, gexpr)
	}
	skip(`)`)
}

fn parse_type(type_ &CType)  {
	ad := AttributeDef{}
	n := 0
	if !parse_btype(type_, &ad) {
		expect(c'type')
	}
	type_decl(type_, &ad, &n, 1)
}

fn parse_builtin_params(nc int, args &i8)  {
	c := i8(0)
	sep := `(`

	t := CType{}
	if nc {
	nocode_wanted ++
	}
	next()
	for (c = *args ++) {
		skip(sep)
		sep = `,`
		match c {
		 `e`{ // case comp body kind=CallExpr is_enum=true
		expr_eq()
		continue
		
		}
		 `t`{ // case comp body kind=CallExpr is_enum=true
		parse_type(&t)
		vpush(&t)
		continue
		
		
		}
		else {
		tcc_error(c'internal error')
		}
		}
	}
	skip(`)`)
	if nc {
	nocode_wanted --
	}
}

fn unary()  {
	n := 0
	t := 0
	align := 0
	size := 0
	r := 0
	sizeof_caller := 0
	
	type_ := CType{}
	s := &Sym(0)
	ad := AttributeDef{}
	sizeof_caller = in_sizeof
	in_sizeof = 0
	type_.ref = (voidptr(0))
	// RRRREG tok_next id=0x7fffbd1c4a90
	tok_next: 
	match (tok) {
	 .tok_extension{ // case comp body kind=CallExpr is_enum=true
	next()
	goto tok_next // id: 0x7fffbd1c4a90
	}
	 180, 181, 179{
	t = 3
	// RRRREG push_tokc id=0x7fffbd1c4d20
	push_tokc: 
	type_.t = t
	vsetc(&type_, 48, &tokc)
	next()
	
	}
	 182{ // case comp body kind=BinaryOperator is_enum=true
	t = 3 | 16
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 183{ // case comp body kind=BinaryOperator is_enum=true
	t = 4
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 184{ // case comp body kind=BinaryOperator is_enum=true
	t = 4 | 16
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 187{ // case comp body kind=BinaryOperator is_enum=true
	t = 8
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 188{ // case comp body kind=BinaryOperator is_enum=true
	t = 9
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 189{ // case comp body kind=BinaryOperator is_enum=true
	t = 10
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 206{ // case comp body kind=BinaryOperator is_enum=true
	t = (if 8 == 8{ 4 } else {3}) | 2048
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 207{ // case comp body kind=BinaryOperator is_enum=true
	t = (if 8 == 8{ 4 } else {3}) | 2048 | 16
	goto push_tokc // id: 0x7fffbd1c4d20
	}
	 .tok___function__{ // case comp body kind=IfStmt is_enum=true
	if !gnu_ext {
	goto tok_identifier // id: 0x7fffbd1c5940
	}
	}
	 .tok___func__// case comp stmt
		ptr := &voidptr(0)
		len := 0
		len = C.strlen(funcname) + 1
		type_.t = 1
		mk_pointer(&type_)
		type_.t |= 64
		type_.ref...c = len
		vpush_ref(&type_, data_section, data_section.data_offset, len)
		if !(nocode_wanted > 0) {
			ptr = section_ptr_add(data_section, len)
			C.memcpy(ptr, funcname, len)
		}
		next()
	}
	
	}
	 186{ // case comp body kind=BinaryOperator is_enum=true
	t = 3
	goto str_init // id: 0x7fffbd1c6728
	}
	 185{ // case comp body kind=BinaryOperator is_enum=true
	t = 1
	if tcc_state.char_is_unsigned {
	t = 1 | 16
	}
	// RRRREG str_init id=0x7fffbd1c6728
	str_init: 
	if tcc_state.warn_write_strings {
	t |= 256
	}
	type_.t = t
	mk_pointer(&type_)
	type_.t |= 64
	C.memset(&ad, 0, sizeof(AttributeDef))
	decl_initializer_alloc(&type_, &ad, 48, 2, 0, 0)
	
	}
	 `(`{ // case comp body kind=CallExpr is_enum=true
	next()
	if parse_btype(&type_, &ad) {
		type_decl(&type_, &ad, &n, 1)
		skip(`)`)
		if tok == `{` {
			if global_expr {
			r = 48
			}
			else { // 3
			r = 50
}
			if !(type_.t & 64) {
			r |= lvalue_type(type_.t)
			}
			C.memset(&ad, 0, sizeof(AttributeDef))
			decl_initializer_alloc(&type_, &ad, r, 1, 0, 0)
		}
		else {
			if sizeof_caller {
				vpush(&type_)
				return 
			}
			unary()
			gen_cast(&type_)
		}
	}
	else if tok == `{` {
		saved_nocode_wanted := nocode_wanted
		if const_wanted {
		tcc_error(c'expected constant')
		}
		save_regs(0)
		block(1)
		nocode_wanted = saved_nocode_wanted
		skip(`)`)
	}
	else {
		gexpr()
		skip(`)`)
	}
	
	}
	 `*`{ // case comp body kind=CallExpr is_enum=true
	next()
	unary()
	indir()
	
	}
	 `&`{ // case comp body kind=CallExpr is_enum=true
	next()
	unary()
	if (vtop.type_.t & 15) != 6 && !(vtop.type_.t & 64) {
	test_lvalue()
	}
	mk_pointer(&vtop.type_)
	gaddrof()
	
	}
	 `!`{ // case comp body kind=CallExpr is_enum=true
	next()
	unary()
	if (vtop.r & (63 | 256 | 512)) == 48 {
		gen_cast_s(11)
		vtop..c.i = !vtop..c.i
	}
	else if vtop.r == 51 {
		vtop...cmp_op ^= 1
		n = vtop...jfalse , vtop...jtrue
		vtop...jfalse = n = vtop...jfalse , n
		vtop...jtrue = n = vtop...jfalse , vtop...jtrue
		vtop...jfalse = n = vtop...jfalse
	}
	else {
		vpushi(0)
		gen_op(148)
	}
	
	}
	 `~`{ // case comp body kind=CallExpr is_enum=true
	next()
	unary()
	vpushi(-1)
	gen_op(`^`)
	
	}
	 `+`{ // case comp body kind=CallExpr is_enum=true
	next()
	unary()
	if (vtop.type_.t & 15) == 5 {
	tcc_error(c'pointer not accepted for unary plus')
	}
	if !is_float(vtop.type_.t) {
		vpushi(0)
		gen_op(`+`)
	}
	
	}
	 .tok_sizeof, .tok_alignof1, .tok_alignof2, .tok_alignof3{
	t = tok
	next()
	in_sizeof ++
	expr_type(&type_, unary)
	s = (voidptr(0))
	if vtop [1] .r & 512 {
	s = vtop [1] ..sym
	}
	size = type_size(&type_, &align)
	if s && s.a.aligned {
	align = 1 << (s.a.aligned - 1)
	}
	if t == Tcc_token.tok_sizeof {
		if !(type_.t & 1024) {
			if size < 0 {
			tcc_error(c'sizeof applied to an incomplete type')
			}
			vpushs(size)
		}
		else {
			vla_runtime_type_size(&type_, &align)
		}
	}
	else {
		vpushs(align)
	}
	vtop.type_.t |= 16
	
	}
	 .tok_builtin_expect{ // case comp body kind=CallExpr is_enum=true
	parse_builtin_params(0, c'ee')
	vpop()
	
	}
	 .tok_builtin_types_compatible_p{ // case comp body kind=CallExpr is_enum=true
	parse_builtin_params(0, c'tt')
	vtop [-1] .type_.t &= ~(256 | 512)
	vtop [0] .type_.t &= ~(256 | 512)
	n = is_compatible_types(&vtop [-1] .type_, &vtop [0] .type_)
	vtop -= 2
	vpushi(n)
	
	}
	 .tok_builtin_choose_expr// case comp stmt
		c := i64(0)
		next()
		skip(`(`)
		c = expr_const64()
		skip(`,`)
		if !c {
			nocode_wanted ++
		}
		expr_eq()
		if !c {
			vpop()
			nocode_wanted --
		}
		skip(`,`)
		if c {
			nocode_wanted ++
		}
		expr_eq()
		if c {
			vpop()
			nocode_wanted --
		}
		skip(`)`)
	}
	
	}
	 .tok_builtin_constant_p{ // case comp body kind=CallExpr is_enum=true
	parse_builtin_params(1, c'e')
	n = (vtop.r & (63 | 256 | 512)) == 48
	vtop --
	vpushi(n)
	
	}
	 .tok_builtin_frame_address, .tok_builtin_return_address{
	{
		tok1 := tok
		level := 0
		next()
		skip(`(`)
		if tok != 181 {
			tcc_error(c'%s only takes positive integers', if tok1 == Tcc_token.tok_builtin_return_address{ c'__builtin_return_address' } else {c'__builtin_frame_address'})
		}
		level = u32(tokc.i)
		next()
		skip(`)`)
		type_.t = 0
		mk_pointer(&type_)
		vset(&type_, 50, 0)
		for level -- {
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
	 .tok_builtin_va_arg_types{ // case comp body kind=CallExpr is_enum=true
	parse_builtin_params(0, c't')
	vpushi(classify_x86_64_va_arg(&vtop.type_))
	vswap()
	vpop()
	
	}
	 164, 162{
	t = tok
	next()
	unary()
	inc(0, t)
	
	}
	 `-`{ // case comp body kind=CallExpr is_enum=true
	next()
	unary()
	t = vtop.type_.t & 15
	if is_float(t) {
		vpush(&vtop.type_)
		if t == 8 {
		vtop..c.f = -1 * 0
		}
		else if t == 9 {
		vtop..c.d = -1 * 0
		}
		else { // 3
		vtop..c.ld = -1 * 0
}
	}
	else { // 3
	vpushi(0)
}
	vswap()
	gen_op(`-`)
	
	}
	 160{ // case comp body kind=IfStmt is_enum=true
	if !gnu_ext {
	goto tok_identifier // id: 0x7fffbd1c5940
	}
	next()
	if tok < Tcc_token.tok_define {
	expect(c'label identifier')
	}
	s = label_find(tok)
	if !s {
		s = label_push(&global_label_stack, tok, 1)
	}
	else {
		if s.r == 2 {
		s.r = 1
		}
	}
	if !s.type_.t {
		s.type_.t = 0
		mk_pointer(&s.type_)
		s.type_.t |= 8192
	}
	vpushsym(&s.type_, s)
	next()
	
	}
	 .tok_generic// case comp stmt
		controlling_type := CType{}
		has_default := 0
		has_match := 0
		learn := 0
		str := (voidptr(0))
		saved_const_wanted := const_wanted
		next()
		skip(`(`)
		const_wanted = 0
		expr_type(&controlling_type, expr_eq)
		controlling_type.t &= ~(256 | 512 | 64)
		if (controlling_type.t & 15) == 6 {
		mk_pointer(&controlling_type)
		}
		const_wanted = saved_const_wanted
		for  ;  ;  {
			learn = 0
			skip(`,`)
			if tok == .tok_default {
				if has_default {
				tcc_error(c"too many 'default'")
				}
				has_default = 1
				if !has_match {
				learn = 1
				}
				next()
			}
			else {
				ad_tmp := AttributeDef{}
				itmp := 0
				cur_type := CType{}
				in_generic ++
				parse_btype(&cur_type, &ad_tmp)
				in_generic --
				type_decl(&cur_type, &ad_tmp, &itmp, 1)
				if compare_types(&controlling_type, &cur_type, 0) {
					if has_match {
						tcc_error(c'type match twice')
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
			}
			else {
				skip_or_save_block((voidptr(0)))
			}
			if tok == `)` {
			
			}
		}
		if !str {
			buf := [60]i8{}
			type_to_str(buf, sizeof(buf), &controlling_type, (voidptr(0)))
			tcc_error(c"type '%s' does not match any association", buf)
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
	}
	 .tok___nan__{ // case comp body kind=BinaryOperator is_enum=true
	n = 2143289344
	// RRRREG special_math_val id=0x7fffbd1d1b98
	special_math_val: 
	vpushi(n)
	vtop.type_.t = 8
	next()
	
	}
	 .tok___snan__{ // case comp body kind=BinaryOperator is_enum=true
	n = 2139095041
	goto special_math_val // id: 0x7fffbd1d1b98
	}
	 .tok___inf__{ // case comp body kind=BinaryOperator is_enum=true
	n = 2139095040
	goto special_math_val // id: 0x7fffbd1d1b98
	next()
	if t < Tcc_token.tok_define {
	expect(c'identifier')
	}
	s = sym_find(t)
	if !s || (((s).type_.t & (15 | (0 | 16))) == (0 | 16)) {
		name := get_tok_str(t, (voidptr(0)))
		if tok != `(` {
		tcc_error(c"'%s' undeclared", name)
		}
		if tcc_state.warn_implicit_function_declaration {
		tcc_warning(c"implicit declaration of function '%s'", name)
		}
		s = external_global_sym(t, &func_old_type)
	}
	r = s.r
	if (r & 63) < 48 {
	r = (r & ~63) | 50
	}
	vset(&s.type_, r, s...c)
	vtop..sym = s
	if r & 512 {
		vtop..c.i = 0
	}
	else if r == 48 && ((s.type_.t & (((1 << (6 + 6)) - 1) << 20 | 128)) == (3 << 20)) {
		vtop..c.i = s..enum_val
	}
	
	}
	else {
	// RRRREG tok_identifier id=0x7fffbd1c5940
	tok_identifier: 
	t = tok
	}
	}
	for 1 {
		if tok == 164 || tok == 162 {
			inc(1, tok)
			next()
		}
		else if tok == `.` || tok == 199 || tok == 188 {
			qualifiers := 0
			cumofs := 0

			if tok == 199 {
			indir()
			}
			qualifiers = vtop.type_.t & (256 | 512)
			test_lvalue()
			gaddrof()
			if (vtop.type_.t & 15) != 7 {
			expect(c'struct or union')
			}
			if tok == 188 {
			expect(c'field name')
			}
			next()
			if tok == 181 || tok == 182 {
			expect(c'field name')
			}
			s = find_field(&vtop.type_, tok, &cumofs)
			if !s {
			tcc_error(c'field not found: %s', get_tok_str(tok & ~536870912, &tokc))
			}
			vtop.type_ = char_pointer_type
			vpushi(cumofs + s...c)
			gen_op(`+`)
			vtop.type_ = s.type_
			vtop.type_.t |= qualifiers
			if !(vtop.type_.t & 64) {
				vtop.r |= lvalue_type(vtop.type_.t)
				if tcc_state.do_bounds_check && (vtop.r & 63) != 50 {
				vtop.r |= 2048
				}
			}
			next()
		}
		else if tok == `[` {
			next()
			gexpr()
			gen_op(`+`)
			indir()
			skip(`]`)
		}
		else if tok == `(` {
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
					goto error_func // id: 0x7fffbd1d6a08
					}
				}
				else {
					// RRRREG error_func id=0x7fffbd1d6a08
					error_func: 
					expect(c'function pointer')
				}
			}
			else {
				vtop.r &= ~256
			}
			s = vtop.type_.ref
			next()
			sa = s..next
			nb_args = 0
			regsize = nb_args
			ret.r2 = 48
			if (s.type_.t & 15) == 7 {
				variadic = (s....f.func_type == 3)
				ret_nregs = gfunc_sret(&s.type_, variadic, &ret.type_, &ret_align, &regsize)
				if ret_nregs <= 0 {
					size = type_size(&s.type_, &align)
					loc = (loc - size) & -align
					ret.type_ = s.type_
					ret.r = 50 | 256
					vseti(50, loc)
					ret..c = vtop..c
					if ret_nregs < 0 {
					vtop --
					}
					else { // 3
					nb_args ++
}
				}
			}
			else {
				ret_nregs = 1
				ret.type_ = s.type_
			}
			if ret_nregs > 0 {
				if is_float(ret.type_.t) {
					ret.r = reg_fret(ret.type_.t)
					if (ret.type_.t & 15) == 14 {
					ret.r2 = treg_xmm1
					}
				}
				else {
					if (ret.type_.t & 15) == 13 {
					ret.r2 = treg_rdx
					}
					ret.r = treg_rax
				}
				ret..c.i = 0
			}
			if tok != `)` {
				for  ;  ;  {
					expr_eq()
					gfunc_param_typed(s, sa)
					nb_args ++
					if sa {
					sa = sa..next
					}
					if tok == `)` {
					break
					
					}
					skip(`,`)
				}
			}
			if sa {
			tcc_error(c'too few arguments to function')
			}
			skip(`)`)
			gfunc_call(nb_args)
			if ret_nregs < 0 {
				vsetc(&ret.type_, ret.r, &ret..c)
			}
			else {
				for r = ret.r + ret_nregs + !ret_nregs ; r -- > ret.r ;  {
					vsetc(&ret.type_, r, &ret..c)
					vtop.r2 = ret.r2
				}
				if ((s.type_.t & 15) == 7) && ret_nregs {
					addr := 0
					offset := 0
					
					size = type_size(&s.type_, &align)
					if regsize > align {
					align = regsize
					}
					loc = (loc - size) & -align
					addr = loc
					offset = 0
					for  ;  ;  {
						vset(&ret.type_, 50 | 256, addr + offset)
						vswap()
						vstore()
						vtop --
						if ret_nregs --$ == 0 {
						break
						
						}
						offset += regsize
					}
					vset(&s.type_, 50 | 256, addr)
				}
			}
			if s....f.func_noreturn {
			(nocode_wanted |= 536870912)
			}
		}
		else {
			break
			
		}
	}
}

fn expr_prod()  {
	t := 0
	unary()
	for tok == `*` || tok == `/` || tok == `%` {
		t = tok
		next()
		unary()
		gen_op(t)
	}
}

fn expr_sum()  {
	t := 0
	expr_prod()
	for tok == `+` || tok == `-` {
		t = tok
		next()
		expr_prod()
		gen_op(t)
	}
}

fn expr_shift()  {
	t := 0
	expr_sum()
	for tok == 1 || tok == 2 {
		t = tok
		next()
		expr_sum()
		gen_op(t)
	}
}

fn expr_cmp()  {
	t := 0
	expr_shift()
	for (tok >= 150 && tok <= 159) || tok == 146 || tok == 147 {
		t = tok
		next()
		expr_shift()
		gen_op(t)
	}
}

fn expr_cmpeq()  {
	t := 0
	expr_cmp()
	for tok == 148 || tok == 149 {
		t = tok
		next()
		expr_cmp()
		gen_op(t)
	}
}

fn expr_and()  {
	expr_cmpeq()
	for tok == `&` {
		next()
		expr_cmpeq()
		gen_op(`&`)
	}
}

fn expr_xor()  {
	expr_and()
	for tok == `^` {
		next()
		expr_and()
		gen_op(`^`)
	}
}

fn expr_or()  {
	expr_xor()
	for tok == `|` {
		next()
		expr_xor()
		gen_op(`|`)
	}
}

fn condition_3way() int

fn expr_landor(e_fn fn (), e_op int, i int)  {
	t := 0
cc := 1
f := 0
c := 0
	
	for  ;  ;  {
		c = if f{ i } else {condition_3way()}
		if c < 0 {
			save_regs(1) , 0
			cc = save_regs(1)
		}
		else if c != i {
			nocode_wanted ++ , 1
			f = nocode_wanted ++
		}
		if tok != e_op {
			if cc || f {
				vpop()
				vpushi(i ^ f)
				gsym(t)
				nocode_wanted -= f
			}
			else {
				gvtst_set(i, t)
			}
			break
			
		}
		if c < 0 {
		t = gvtst(i, t)
		}
		else { // 3
		vpop()
}
		next()
		e_fn()
	}
}

fn expr_land()  {
	expr_or()
	if tok == 160 {
	expr_landor(expr_or, 160, 1)
	}
}

fn expr_lor()  {
	expr_land()
	if tok == 161 {
	expr_landor(expr_land, 161, 0)
	}
}

fn condition_3way() int {
	c := -1
	if (vtop.r & (63 | 256)) == 48 && (!(vtop.r & 512) || !vtop..sym.a.weak) {
		vdup()
		gen_cast_s(11)
		c = vtop..c.i
		vpop()
	}
	return c
}

fn is_cond_bool(sv &SValue) int {
	if (sv.r & (63 | 256 | 512)) == 48 && (sv.type_.t & 15) == 3 {
	return u32(sv..c.i) < 2
	}
	if sv.r == 51 {
	return 1
	}
	return 0
}

fn expr_cond()  {
	tt := 0
	u := 0
	r1 := 0
	r2 := 0
	rc := 0
	t1 := 0
	t2 := 0
	bt1 := 0
	bt2 := 0
	islv := 0
	c := 0
	g := 0
	
	sv := SValue{}
	type_ := CType{}
	type1 := CType{}
	type2 := CType{}
	
	ncw_prev := 0
	expr_lor()
	if tok == `?` {
		next()
		c = condition_3way()
		g = (tok == `:` && gnu_ext)
		tt = 0
		if !g {
			if c < 0 {
				save_regs(1)
				tt = gvtst(1, 0)
			}
			else {
				vpop()
			}
		}
		else if c < 0 {
			save_regs(1)
			gv_dup()
			tt = gvtst(0, 0)
		}
		ncw_prev = nocode_wanted
		if 1 {
			if c == 0 {
			nocode_wanted ++
			}
			if !g {
			gexpr()
			}
			if c < 0 && vtop.r == 51 {
				t1 = gvtst(0, 0)
				vpushi(0)
				gvtst_set(0, t1)
			}
			if (vtop.type_.t & 15) == 6 {
			mk_pointer(&vtop.type_)
			}
			type1 = vtop.type_
			sv = *vtop
			vtop --
			if g {
				u = tt
			}
			else if c < 0 {
				u = gjmp_acs(0)
				gsym(tt)
			}
			else { // 3
			u = 0
}
			nocode_wanted = ncw_prev
			if c == 1 {
			nocode_wanted ++
			}
			skip(`:`)
			expr_cond()
			if c < 0 && is_cond_bool(vtop) && is_cond_bool(&sv) {
				if sv.r == 51 {
					t1 = sv...jtrue
					t2 = u
				}
				else {
					t1 = gvtst(0, 0)
					t2 = gjmp_acs(0)
					gsym(u)
					vpushv(&sv)
				}
				gvtst_set(0, t1)
				gvtst_set(1, t2)
				nocode_wanted = ncw_prev
				return 
			}
			if (vtop.type_.t & 15) == 6 {
			mk_pointer(&vtop.type_)
			}
			type2 = vtop.type_
			t1 = type1.t
			bt1 = t1 & 15
			t2 = type2.t
			bt2 = t2 & 15
			type_.ref = (voidptr(0))
			if bt1 == 0 || bt2 == 0 {
				type_.t = 0
			}
			else if is_float(bt1) || is_float(bt2) {
				if bt1 == 10 || bt2 == 10 {
					type_.t = 10
				}
				else if bt1 == 9 || bt2 == 9 {
					type_.t = 9
				}
				else {
					type_.t = 8
				}
			}
			else if bt1 == 4 || bt2 == 4 {
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
			}
			else if bt1 == 5 || bt2 == 5 {
				if is_null_pointer(vtop) {
				type_ = type1
				}
				else if is_null_pointer(&sv) {
				type_ = type2
				}
				else if bt1 != bt2 {
				tcc_error(c'incompatible types in conditional expressions')
				}
				else {
					pt1 := pointed_type(&type1)
					pt2 := pointed_type(&type2)
					pbt1 := pt1.t & 15
					pbt2 := pt2.t & 15
					newquals := 0
					copied := 0

					type_ = if (pbt1 == 0){ type1 } else {type2}
					if pbt1 != 0 && pbt2 != 0 {
						if !compare_types(pt1, pt2, 1) {
						tcc_warning(c'pointer type mismatch in conditional expression\n')
						}
					}
					newquals = ((pt1.t | pt2.t) & (256 | 512))
					if (~pointed_type(&type_).t & (256 | 512)) & newquals {
						type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref...c)
						copied = 1
						pointed_type(&type_).t |= newquals
					}
					if pt1.t & 64 && pt2.t & 64 && pointed_type(&type_).ref...c < 0 && (pt1.ref...c > 0 || pt2.ref...c > 0) {
						if !copied {
						type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref...c)
						}
						pointed_type(&type_).ref = sym_push(536870912, &pointed_type(&type_).ref.type_, 0, pointed_type(&type_).ref...c)
						pointed_type(&type_).ref...c = if 0 < pt1.ref...c{ pt1.ref...c } else {pt2.ref...c}
					}
				}
			}
			else if bt1 == 7 || bt2 == 7 {
				type_ = if bt1 == 7{ type1 } else {type2}
			}
			else {
				type_.t = 3 | (2048 & (t1 | t2))
				if (t1 & (15 | 16 | 128)) == (3 | 16) || (t2 & (15 | 16 | 128)) == (3 | 16) {
				type_.t |= 16
				}
			}
			islv = (vtop.r & 256) && (sv.r & 256) && 7 == (type_.t & 15)
			if c != 1 {
				gen_cast(&type_)
				if islv {
					mk_pointer(&vtop.type_)
					gaddrof()
				}
				else if 7 == (vtop.type_.t & 15) {
				gaddrof()
				}
			}
			rc = 1
			if is_float(type_.t) {
				rc = 2
				if (type_.t & 15) == 10 {
					rc = 128
				}
			}
			else if (type_.t & 15) == 4 {
				rc = 4
			}
			tt = 0
			r2 = tt
			if c < 0 {
				r2 = gv(rc)
				tt = gjmp_acs(0)
			}
			gsym(u)
			nocode_wanted = ncw_prev
			if c != 0 {
				*vtop = sv
				gen_cast(&type_)
				if islv {
					mk_pointer(&vtop.type_)
					gaddrof()
				}
				else if 7 == (vtop.type_.t & 15) {
				gaddrof()
				}
			}
			if c < 0 {
				r1 = gv(rc)
				move_reg(r2, r1, if islv{ 5 } else {type_.t})
				vtop.r = r2
				gsym(tt)
			}
			if islv {
			indir()
			}
		}
	}
}

fn expr_eq()  {
	t := 0
	expr_cond()
	if tok == `=` || (tok >= 165 && tok <= 175) || tok == 222 || tok == 252 || tok == 129 || tok == 130 {
		test_lvalue()
		t = tok
		next()
		if t == `=` {
			expr_eq()
		}
		else {
			vdup()
			expr_eq()
			gen_op(t & 127)
		}
		vstore()
	}
}

fn gexpr()  {
	for 1 {
		expr_eq()
		if tok != `,` {
		break
		
		}
		vpop()
		next()
	}
}

fn expr_const1()  {
	const_wanted ++
	nocode_wanted ++
	expr_cond()
	nocode_wanted --
	const_wanted --
}

fn expr_const64() i64 {
	c := i64(0)
	expr_const1()
	if (vtop.r & (63 | 256 | 512)) != 48 {
	expect(c'constant expression')
	}
	c = vtop..c.i
	vpop()
	return c
}

fn expr_const() int {
	c := 0
	wc := expr_const64()
	c = wc
	if c != wc && u32(c) != wc {
	tcc_error(c'constant exceeds 32 bit')
	}
	return c
}

fn gfunc_return(func_type &CType)  {
	if (func_type.t & 15) == 7 {
		type_ := CType{}
		ret_type := CType{}
		
		ret_align := 0
		ret_nregs := 0
		regsize := 0
		
		ret_nregs = gfunc_sret(func_type, func_var, &ret_type, &ret_align, &regsize)
		if ret_nregs < 0 {
		}
		else if 0 == ret_nregs {
			type_ = *func_type
			mk_pointer(&type_)
			vset(&type_, 50 | 256, func_vc)
			indir()
			vswap()
			vstore()
		}
		else {
			r := 0
			size := 0
			addr := 0
			align := 0
			
			size = type_size(func_type, &align)
			if (vtop.r != (50 | 256) || (vtop..c.i & (ret_align - 1))) && (align & (ret_align - 1)) {
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
			if is_float(ret_type.t) {
			r = rc_fret(ret_type.t)
			}
			else { // 3
			r = 4
}
			if ret_nregs == 1 {
			gv(r)
			}
			else {
				for  ;  ;  {
					vdup()
					gv(r)
					vpop()
					if ret_nregs --$ == 0 {
					break
					
					}
					r <<= 1
					vtop..c.i += regsize
				}
			}
		}
	}
	else if is_float(func_type.t) {
		gv(rc_fret(func_type.t))
	}
	else {
		gv(4)
	}
	vtop --
}

fn check_func_return()  {
	if (func_vt.t & 15) == 0 {
	return 
	}
	if !C.strcmp(funcname, c'main') && (func_vt.t & 15) == 3 {
		vpushi(0)
		gen_assign_cast(&func_vt)
		gfunc_return(&func_vt)
	}
	else {
		tcc_warning(c"function might return no value: '%s'", funcname)
	}
}

fn case_cmp(pa voidptr, pb voidptr) int {
	a := (*&&Case_t(pa)).v1
	b := (*&&Case_t(pb)).v1
	return if a < b{ -1 } else {a > b}
}

fn gtst_addr(t int, a int)  {
	gsym_addr(gvtst(0, t), a)
}

fn gcase(base &&Case_t, len int, bsym &int)  {
	p := &Case_t(0)
	e := 0
	ll := (vtop.type_.t & 15) == 4
	for len > 8 {
		p = base [len / 2] 
		vdup()
		if ll {
		vpushll(p.v2)
		}
		else { // 3
		vpushi(p.v2)
}
		gen_op(158)
		e = gvtst(1, 0)
		vdup()
		if ll {
		vpushll(p.v1)
		}
		else { // 3
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
	for len -- {
		p = *base ++
		vdup()
		if ll {
		vpushll(p.v2)
		}
		else { // 3
		vpushi(p.v2)
}
		if p.v1 == p.v2 {
			gen_op(148)
			gtst_addr(0, p.sym)
		}
		else {
			gen_op(158)
			e = gvtst(1, 0)
			vdup()
			if ll {
			vpushll(p.v1)
			}
			else { // 3
			vpushi(p.v1)
}
			gen_op(157)
			gtst_addr(0, p.sym)
			gsym(e)
		}
	}
	*bsym = gjmp_acs(*bsym)
}

fn try_call_scope_cleanup(stop &Sym)  {
	cls := cur_scope.cl.s
	for  ; cls != stop ; cls = cls..ncl {
		fs := cls..next
		vs := cls.prev_tok
		vpushsym(&fs.type_, fs)
		vset(&vs.type_, vs.r, vs...c)
		vtop..sym = vs
		mk_pointer(&vtop.type_)
		gaddrof()
		gfunc_call(1)
	}
}

fn try_call_cleanup_goto(cleanupstate &Sym)  {
	oc := &Sym(0)
	cc := &Sym(0)
	
	ocd := 0
	ccd := 0
	
	if !cur_scope.cl.s {
	return 
	}
	ocd = if cleanupstate{ cleanupstate.v & ~536870912 } else {0}
	for ccd = cur_scope.cl.n , cleanupstate
	oc = ccd = cur_scope.cl.n ; ocd > ccd ; ocd -- , oc..ncl
	oc = ocd -- {
	0
	}
	for cc = cur_scope.cl.s ; ccd > ocd ; ccd -- , cc..ncl
	cc = ccd -- {
	0
	}
	for  ; cc != oc ; cc = cc..ncl , oc..ncl
	oc = cc = cc..ncl , ccd -- {
	0
	}
	try_call_scope_cleanup(cc)
}

fn block_cleanup(o &Scope)  {
	jmp := 0
	g := &Sym(0)
	pg := &&Sym(0)
	
	for pg = &pending_gotos ; (g = *pg) && g...c > o.cl.n ;  {
		if g.prev_tok.r & 1 {
			pcl := g..next
			if !jmp {
			jmp = gjmp_acs(0)
			}
			gsym(pcl....jnext)
			try_call_scope_cleanup(o.cl.s)
			pcl....jnext = gjmp_acs(0)
			if !o.cl.n {
			goto remove_pending // id: 0x7fffbd1f6a58
			}
			g...c = o.cl.n
			pg = &g.prev
		}
		else {
			// RRRREG remove_pending id=0x7fffbd1f6a58
			remove_pending: 
			*pg = g.prev
			sym_free(g)
		}
	}
	gsym(jmp)
	try_call_scope_cleanup(o.cl.s)
}

fn vla_restore(loc int)  {
	if loc {
	gen_vla_sp_restore(loc)
	}
}

fn vla_leave(o &Scope)  {
	if o.vla.num < cur_scope.vla.num {
	vla_restore(o.vla.loc)
	}
}

fn new_scope(o &Scope)  {
	*o = *cur_scope
	o.prev = cur_scope
	cur_scope = o
	o.lstk = local_stack
	o.llstk = local_label_stack
	local_scope ++$
}

fn prev_scope(o &Scope, is_expr int)  {
	vla_leave(o.prev)
	if o.cl.s != o.prev.cl.s {
	block_cleanup(o.prev)
	}
	label_pop(&local_label_stack, o.llstk, is_expr)
	sym_pop(&local_stack, o.lstk, is_expr)
	cur_scope = o.prev
	local_scope --$
}

fn leave_scope(o &Scope)  {
	if !o {
	return 
	}
	try_call_scope_cleanup(o.cl.s)
	vla_leave(o)
}

fn lblock(bsym &int, csym &int)  {
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

fn block(is_expr int)  {
	a := 0
	b := 0
	c := 0
	d := 0
	e := 0
	t := 0
	
	s := &Sym(0)
	if is_expr {
		vpushi(0)
		vtop.type_.t = 0
	}
	// RRRREG again id=0x7fffbd1fa180
	again: 
	t = tok , next()
	if t == Tcc_token.tok_if {
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
		}
		else {
			gsym(a)
		}
	}
	else if t == Tcc_token.tok_while {
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
	}
	else if t == `{` {
		o := Scope{}
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
			if ! (tok == `,` ) { break }
			}
			skip(`;`)
		}
		for tok != `}` {
			decl(50)
			if tok != `}` {
				if is_expr {
				vpop()
				}
				block(is_expr)
			}
		}
		prev_scope(&o, is_expr)
		if 0 == local_scope && !nocode_wanted {
		check_func_return()
		}
		next()
	}
	else if t == Tcc_token.tok_return {
		a = tok != `;`
		b = (func_vt.t & 15) != 0
		if a {
		gexpr() , gen_assign_cast(&func_vt)
		}
		leave_scope(root_scope)
		if a && b {
		gfunc_return(&func_vt)
		}
		else if a {
		vtop --
		}
		else if b {
		tcc_warning(c"'return' with no value.")
		}
		skip(`;`)
		if tok != `}` || local_scope != 1 {
		rsym = gjmp_acs(rsym)
		}
		(nocode_wanted |= 536870912)
	}
	else if t == Tcc_token.tok_break {
		if !cur_scope.bsym {
		tcc_error(c'cannot break')
		}
		if !cur_switch || cur_scope.bsym != cur_switch.bsym {
		leave_scope(loop_scope)
		}
		else { // 3
		leave_scope(cur_switch.scope)
}
		*cur_scope.bsym = gjmp_acs(*cur_scope.bsym)
		skip(`;`)
	}
	else if t == Tcc_token.tok_continue {
		if !cur_scope.csym {
		tcc_error(c'cannot continue')
		}
		leave_scope(loop_scope)
		*cur_scope.csym = gjmp_acs(*cur_scope.csym)
		skip(`;`)
	}
	else if t == Tcc_token.tok_for {
		o := Scope{}
		new_scope(&o)
		skip(`(`)
		if tok != `;` {
			if !decl0(50, 1, (voidptr(0))) {
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
	}
	else if t == Tcc_token.tok_do {
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
	}
	else if t == Tcc_token.tok_switch {
		saved := &Switch_t(0)
		sw := Switch_t{}
		
		switchval := SValue{}
		sw.p = (voidptr(0))
		sw.n = 0
		sw.def_sym = 0
		sw.bsym = &a
		sw.scope = cur_scope
		saved = cur_switch
		cur_switch = &sw
		skip(`(`)
		gexpr()
		skip(`)`)
		switchval = *vtop --
		a = 0
		b = gjmp_acs(0)
		lblock(&a, (voidptr(0)))
		a = gjmp_acs(a)
		gsym(b)
		C.qsort(sw.p, sw.n, sizeof(voidptr), case_cmp)
		for b = 1 ; b < sw.n ; b ++ {
		if sw.p [b - 1] .v2 >= sw.p [b] .v1 {
		tcc_error(c'duplicate case value')
		}
		}
		if (switchval.type_.t & 15) == 4 {
		switchval.type_.t &= ~16
		}
		vpushv(&switchval)
		gv(1)
		d = 0 , gcase(sw.p, sw.n, &d)
		vpop()
		if sw.def_sym {
		gsym_addr(d, sw.def_sym)
		}
		else { // 3
		gsym(d)
}
		gsym(a)
		dynarray_reset(&sw.p, &sw.n)
		cur_switch = saved
	}
	else if t == Tcc_token.tok_case {
		cr := tcc_malloc(sizeof(Case_t))
		if !cur_switch {
		expect(c'switch')
		}
		cr.v1 = expr_const64()
		cr.v2 = cr.v1
		if gnu_ext && tok == 200 {
			next()
			cr.v2 = expr_const64()
			if cr.v2 < cr.v1 {
			tcc_warning(c'empty case range')
			}
		}
		cr.sym = gind()
		dynarray_add(&cur_switch.p, &cur_switch.n, cr)
		skip(`:`)
		is_expr = 0
		goto block_after_label // id: 0x7fffbd201c80
	}
	else if t == Tcc_token.tok_default {
		if !cur_switch {
		expect(c'switch')
		}
		if cur_switch.def_sym {
		tcc_error(c"too many 'default'")
		}
		cur_switch.def_sym = gind()
		skip(`:`)
		is_expr = 0
		goto block_after_label // id: 0x7fffbd201c80
	}
	else if t == Tcc_token.tok_goto {
		vla_restore(root_scope.vla.loc)
		if tok == `*` && gnu_ext {
			next()
			gexpr()
			if (vtop.type_.t & 15) != 5 {
			expect(c'pointer')
			}
			ggoto()
		}
		else if tok >= Tcc_token.tok_define {
			s = label_find(tok)
			if !s {
			s = label_push(&global_label_stack, tok, 1)
			}
			else if s.r == 2 {
			s.r = 1
			}
			if s.r & 1 {
				if cur_scope.cl.s && !nocode_wanted {
					sym_push2(&pending_gotos, 536870912, 0, cur_scope.cl.n)
					pending_gotos.prev_tok = s
					s = sym_push2(&s..next, 536870912, 0, 0)
					pending_gotos..next = s
				}
				s....jnext = gjmp_acs(s....jnext)
			}
			else {
				try_call_cleanup_goto(s..cleanupstate)
				gjmp_addr_acs(s....jnext)
			}
			next()
		}
		else {
			expect(c'label identifier')
		}
		skip(`;`)
	}
	else if t == Tcc_token.tok_asm1 || t == Tcc_token.tok_asm2 || t == Tcc_token.tok_asm3 {
		asm_instr()
	}
	else {
		if tok == `:` && t >= Tcc_token.tok_define {
			next()
			s = label_find(t)
			if s {
				if s.r == 0 {
				tcc_error(c"duplicate label '%s'", get_tok_str(s.v, (voidptr(0))))
				}
				s.r = 0
				if s..next {
					pcl := &Sym(0)
					for pcl = s..next ; pcl ; pcl = pcl.prev {
					gsym(pcl....jnext)
					}
					sym_pop(&s..next, (voidptr(0)), 0)
				}
				else { // 3
				gsym(s....jnext)
}
			}
			else {
				s = label_push(&global_label_stack, t, 0)
			}
			s....jnext = gind()
			s..cleanupstate = cur_scope.cl.s
			// RRRREG block_after_label id=0x7fffbd201c80
			block_after_label: 
			vla_restore(cur_scope.vla.loc)
			if tok == `}` {
				tcc_warning(c'deprecated use of label at end of compound statement')
			}
			else {
				goto again // id: 0x7fffbd1fa180
			}
		}
		else {
			if t != `;` {
				unget_tok(t)
				if is_expr {
					vpop()
					gexpr()
				}
				else {
					gexpr()
					vpop()
				}
				skip(`;`)
			}
		}
	}
}

fn skip_or_save_block(str &&TokenString)  {
	braces := tok == `{`
	level := 0
	if str {
	*str = tok_str_alloc()
	}
	for (level > 0 || (tok != `}` && tok != `,` && tok != `;` && tok != `)`)) {
		t := 0
		if tok == (-1) {
			if str || level > 0 {
			tcc_error(c'unexpected end of file')
			}
			else { // 3
			break
			
}
		}
		if str {
		tok_str_add_tok(*str)
		}
		t = tok
		next()
		if t == `{` || t == `(` {
			level ++
		}
		else if t == `}` || t == `)` {
			level --
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

fn parse_init_elem(expr_type int)  {
	saved_global_expr := 0
	match expr_type {
	 1{ // case comp body kind=BinaryOperator is_enum=false
	saved_global_expr = global_expr
	global_expr = 1
	expr_const1()
	global_expr = saved_global_expr
	if ((vtop.r & (63 | 256)) != 48 && ((vtop.r & (512 | 256)) != (512 | 256) || vtop..sym.v < 268435456)) {
	tcc_error(c'initializer element is not constant')
	}
	
	}
	 2{ // case comp body kind=CallExpr is_enum=false
	expr_eq()
	
	}
	else{}
	}
}

fn init_putz(sec &Section, c u32, size int)  {
	if sec {
	}
	else {
		vpush_global_sym(&func_old_type, Tcc_token.tok_memset)
		vseti(50, c)
		vpushi(0)
		vpushs(size)
		gfunc_call(3)
	}
}

fn decl_designator(type_ &CType, sec &Section, c u32, cur_field &&Sym, flags int, al int) int {
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
	goto no_designator // id: 0x7fffbd208fc8
	}
	if gnu_ext && tok >= Tcc_token.tok_define {
		l = tok , next()
		if tok == `:` {
		goto struct_field // id: 0x7fffbd209280
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
			if tok == 200 && gnu_ext {
				next()
				index_last = expr_const()
			}
			skip(`]`)
			s = type_.ref
			if index < 0 || (s...c >= 0 && index_last >= s...c) || index_last < index {
			tcc_error(c'invalid index')
			}
			if cur_field {
			(*cur_field)...c = index_last
			}
			type_ = pointed_type(type_)
			elem_size = type_size(type_, &align)
			c += index * elem_size
			nb_elems = index_last - index + 1
		}
		else {
			cumofs := 0
			next()
			l = tok
			// RRRREG struct_field id=0x7fffbd209280
			struct_field: 
			next()
			if (type_.t & 15) != 7 {
			expect(c'struct/union type')
			}
			cumofs = 0
			f = find_field(type_, l, &cumofs)
			if !f {
			expect(c'field')
			}
			if cur_field {
			*cur_field = f
			}
			type_ = &f.type_
			c += cumofs + f...c
		}
		cur_field = (voidptr(0))
	}
	if !cur_field {
		if tok == `=` {
			next()
		}
		else if !gnu_ext {
			expect(c'=')
		}
	}
	else {
		// RRRREG no_designator id=0x7fffbd208fc8
		no_designator: 
		if type_.t & 64 {
			index = (*cur_field)...c
			if type_.ref...c >= 0 && index >= type_.ref...c {
			tcc_error(c'index too large')
			}
			type_ = pointed_type(type_)
			c += index * type_size(type_, &align)
		}
		else {
			f = *cur_field
			for f && (f.v & 268435456) && (f.type_.t & 128) {
			*cur_field = f..next
			f = *cur_field
			}
			if !f {
			tcc_error(c'too many field init')
			}
			type_ = &f.type_
			c += f...c
		}
	}
	if !(flags & 2) && c - corig > al {
	init_putz(sec, corig + al, c - corig - al)
	}
	decl_initializer(type_, sec, c, flags & ~1)
	if !(flags & 2) && nb_elems > 1 {
		c_end := u32(0)
		src := &u8(0)
		dst := &u8(0)
		
		i := 0
		if !sec {
			vset(type_, 50 | 256, c)
			for i = 1 ; i < nb_elems ; i ++ {
				vset(type_, 50 | 256, c + elem_size * i)
				vswap()
				vstore()
			}
			vpop()
		}
		else if !(nocode_wanted > 0) {
			c_end = c + nb_elems * elem_size
			if c_end > sec.data_allocated {
			section_realloc(sec, c_end)
			}
			src = sec.data + c
			dst = src
			for i = 1 ; i < nb_elems ; i ++ {
				dst += elem_size
				C.memcpy(dst, src, elem_size)
			}
		}
	}
	c += nb_elems * type_size(type_, &align)
	if c - corig > al {
	al = c - corig
	}
	return al
}

fn init_putv(type_ &CType, sec &Section, c u32)  {
	bt := 0
	ptr := &voidptr(0)
	dtype := CType{}
	dtype = *type_
	dtype.t &= ~256
	if sec {
		size := 0
		align := 0
		
		gen_assign_cast(&dtype)
		bt = type_.t & 15
		if (vtop.r & 512) && bt != 5 && bt != 6 && (bt != (if 8 == 8{ 4 } else {3}) || (type_.t & 128)) && !((vtop.r & 48) && vtop..sym.v >= 268435456) {
		tcc_error(c'initializer element is not computable at load time')
		}
		if (nocode_wanted > 0) {
			vtop --
			return 
		}
		size = type_size(type_, &align)
		section_reserve(sec, c + size)
		ptr = sec.data + c
		if (vtop.r & (512 | 48)) == (512 | 48) && vtop..sym.v >= 268435456 && (vtop.type_.t & 15) != 5 {
			ssec := &Section(0)
			esym := &Elf64_Sym(0)
			rel := &Elf64_Rela(0)
			esym = elfsym(vtop..sym)
			ssec = tcc_state.sections [esym.st_shndx] 
			C.memmove(ptr, ssec.data + esym.st_value, size)
			if ssec.reloc {
				num_relocs := ssec.reloc.data_offset / sizeof(*rel)
				rel = &Elf64_Rela((ssec.reloc.data + ssec.reloc.data_offset))
				for num_relocs -- {
					rel --
					if rel.r_offset >= esym.st_value + size {
					continue
					
					}
					if rel.r_offset < esym.st_value {
					break
					
					}
					put_elf_reloca(symtab_section, sec, c + rel.r_offset - esym.st_value, ((rel.r_info) & 4294967295), ((rel.r_info) >> 32), rel.r_addend)
				}
			}
		}
		else {
			if type_.t & 128 {
				bit_pos := 0
				bit_size := 0
				bits := 0
				n := 0
				
				p := &u8(0)
				v := u8(0)
				m := u8(0)
				
				bit_pos = (((vtop.type_.t) >> 20) & 63)
				bit_size = (((vtop.type_.t) >> (20 + 6)) & 63)
				p = &u8(ptr) + (bit_pos >> 3)
				bit_pos &= 7 , 0
				bits = bit_pos &= 7
				for bit_size {
					n = 8 - bit_pos
					if n > bit_size {
					n = bit_size
					}
					v = vtop..c.i >> bits << bit_pos
					m = ((1 << n) - 1) << bit_pos
					*p = (*p & ~m) | (v & m)
					bits += n , bit_size -= n , 0
					bit_pos = bits += n , bit_size -= n , p ++$
				}
			}
			else { // 3
			
}
		}
		vtop --
	}
	else {
		vset(&dtype, 50 | 256, c)
		vswap()
		vstore()
		vpop()
	}
}

fn decl_initializer(type_ &CType, sec &Section, c u32, flags int)  {
	len := 0
	n := 0
	no_oblock := 0
	nb := 0
	i := 0
	
	size1 := 0
	align1 := 0
	
	s := &Sym(0)
	f := &Sym(0)
	
	indexsym := Sym{}
	t1 := &CType(0)
	if !(flags & 4) && tok != `{` && tok != 186 && tok != 185 && !(flags & 2) {
		parse_init_elem(if !sec{ 2 } else {1})
		flags |= 4
	}
	if (flags & 4) && !(type_.t & 64) && is_compatible_unqualified_types(type_, &vtop.type_) {
		init_putv(type_, sec, c)
	}
	else if type_.t & 64 {
		s = type_.ref
		n = s...c
		t1 = pointed_type(type_)
		size1 = type_size(t1, &align1)
		no_oblock = 1
		if ((flags & 1) && tok != 186 && tok != 185) || tok == `{` {
			if tok != `{` {
			tcc_error(c'character array initializer must be a literal, optionally enclosed in braces')
			}
			skip(`{`)
			no_oblock = 0
		}
		if (tok == 186 && (t1.t & 15) == 3) || (tok == 185 && (t1.t & 15) == 1) {
			len = 0
			for tok == 185 || tok == 186 {
				cstr_len := 0
				ch := 0
				
				if tok == 185 {
				cstr_len = tokc.str.size
				}
				else { // 3
				cstr_len = tokc.str.size / sizeof(Nwchar_t)
}
				cstr_len --
				nb = cstr_len
				if n >= 0 && nb > (n - len) {
				nb = n - len
				}
				if !(flags & 2) {
					if cstr_len > nb {
					tcc_warning(c'initializer-string for array is too long')
					}
					if sec && tok == 185 && size1 == 1 {
						if !(nocode_wanted > 0) {
						C.memcpy(sec.data + c + len, tokc.str.data, nb)
						}
					}
					else {
						for i = 0 ; i < nb ; i ++ {
							if tok == 185 {
							ch = (&u8(tokc.str.data)) [i] 
							}
							else { // 3
							ch = (&Nwchar_t(tokc.str.data)) [i] 
}
							vpushi(ch)
							init_putv(t1, sec, c + (len + i) * size1)
						}
					}
				}
				len += nb
				next()
			}
			if n < 0 || len < n {
				if !(flags & 2) {
					vpushi(0)
					init_putv(t1, sec, c + (len * size1))
				}
				len ++
			}
			len *= size1
		}
		else {
			indexsym...c = 0
			f = &indexsym
			// RRRREG do_init_list id=0x7fffbd21be90
			do_init_list: 
			len = 0
			for tok != `}` || (flags & 4) {
				len = decl_designator(type_, sec, c, &f, flags, len)
				flags &= ~4
				if type_.t & 64 {
					indexsym...c ++$
					if no_oblock && len >= n * size1 {
					break
					
					}
				}
				else {
					if s.type_.t == (1 << 20 | 7) {
					f = (voidptr(0))
					}
					else { // 3
					f = f..next
}
					if no_oblock && f == (voidptr(0)) {
					break
					
					}
				}
				if tok == `}` {
				break
				
				}
				skip(`,`)
			}
		}
		if !(flags & 2) && len < n * size1 {
		init_putz(sec, c + len, n * size1 - len)
		}
		if !no_oblock {
		skip(`}`)
		}
		if n < 0 {
		s...c = if size1 == 1{ len } else {((len + size1 - 1) / size1)}
		}
	}
	else if (type_.t & 15) == 7 {
		size1 = 1
		no_oblock = 1
		if (flags & 1) || tok == `{` {
			skip(`{`)
			no_oblock = 0
		}
		s = type_.ref
		f = s..next
		n = s...c
		goto do_init_list // id: 0x7fffbd21be90
	}
	else if tok == `{` {
		if flags & 4 {
		skip(`;`)
		}
		next()
		decl_initializer(type_, sec, c, flags & ~4)
		skip(`}`)
	}
	else if (flags & 2) {
		skip_or_save_block((voidptr(0)))
	}
	else {
		if !(flags & 4) {
			if tok != 185 && tok != 186 {
			expect(c'string constant')
			}
			parse_init_elem(if !sec{ 2 } else {1})
		}
		init_putv(type_, sec, c)
	}
}

fn decl_initializer_alloc(type_ &CType, ad &AttributeDef, r int, has_init int, v int, scope int)  {
	size := 0
	align := 0
	addr := 0
	
	init_str := (voidptr(0))
	sec := &Section(0)
	flexible_array := &Sym(0)
	sym := (voidptr(0))
	saved_nocode_wanted := nocode_wanted
	bcheck := 0
	if v && (r & 63) == 48 {
	nocode_wanted |= 2147483648
	}
	bcheck = tcc_state.do_bounds_check && !(nocode_wanted > 0)
	flexible_array = (voidptr(0))
	if (type_.t & 15) == 7 {
		field := type_.ref..next
		if field {
			for field..next {
			field = field..next
			}
			if field.type_.t & 64 && field.type_.ref...c < 0 {
			flexible_array = field
			}
		}
	}
	size = type_size(type_, &align)
	if size < 0 || (flexible_array && has_init) {
		if !has_init {
		tcc_error(c'unknown type size')
		}
		if has_init == 2 {
			init_str = tok_str_alloc()
			for tok == 185 || tok == 186 {
				tok_str_add_tok(init_str)
				next()
			}
			tok_str_add(init_str, -1)
			tok_str_add(init_str, 0)
		}
		else {
			skip_or_save_block(&init_str)
		}
		unget_tok(0)
		begin_macro(init_str, 1)
		next()
		decl_initializer(type_, (voidptr(0)), 0, 1 | 2)
		macro_ptr = init_str.str
		next()
		size = type_size(type_, &align)
		if size < 0 {
		tcc_error(c'unknown type size')
		}
	}
	if flexible_array && flexible_array.type_.ref...c > 0 {
	size += flexible_array.type_.ref...c * pointed_size(&flexible_array.type_)
	}
	if ad.a.aligned {
		speca := 1 << (ad.a.aligned - 1)
		if speca > align {
		align = speca
		}
	}
	else if ad.a.packed {
		align = 1
	}
	if !v && (nocode_wanted > 0) {
	size = 0 , 1
	align = size = 0
	}
	if (r & 63) == 50 {
		sec = (voidptr(0))
		if bcheck && (type_.t & 64) {
			loc --
		}
		loc = (loc - size) & -align
		addr = loc
		if bcheck && (type_.t & 64) {
			bounds_ptr := &Elf64_Addr(0)
			loc --
			bounds_ptr = section_ptr_add(lbounds_section, 2 * sizeof(Elf64_Addr))
			bounds_ptr [0]  = addr
			bounds_ptr [1]  = size
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
				cls := sym_push2(&all_cleanups, 536870912 | cur_scope.cl.n ++$, 0, 0)
				cls.prev_tok = sym
				cls..next = ad.cleanup_func
				cls..ncl = cur_scope.cl.s
				cur_scope.cl.s = cls
			}
			sym.a = ad.a
		}
		else {
			vset(type_, r, addr)
		}
	}
	else {
		if v && scope == 48 {
			sym = sym_find(v)
			if sym {
				patch_storage(sym, ad, type_)
				if !has_init && sym...c && elfsym(sym).st_shndx != 0 {
				goto no_alloc // id: 0x7fffbd224110
				}
			}
		}
		sec = ad.section
		if !sec {
			if has_init {
			sec = data_section
			}
			else if tcc_state.nocommon {
			sec = bss_section
			}
		}
		if sec {
			addr = section_add(sec, size, align)
			if bcheck {
			section_add(sec, 1, 1)
			}
		}
		else {
			addr = align
			sec = common_section
		}
		if v {
			if !sym {
				sym = sym_push(v, type_, r | 512, 0)
				patch_storage(sym, ad, (voidptr(0)))
			}
			put_extern_sym(sym, sec, addr, size)
		}
		else {
			vpush_ref(type_, sec, addr, size)
			sym = vtop..sym
			vtop.r |= r
		}
		if bcheck {
			bounds_ptr := &Elf64_Addr(0)
			greloca(bounds_section, sym, bounds_section.data_offset, 1, 0)
			bounds_ptr = section_ptr_add(bounds_section, 2 * sizeof(Elf64_Addr))
			bounds_ptr [0]  = 0
			bounds_ptr [1]  = size
		}
	}
	if type_.t & 1024 {
		a := 0
		if (nocode_wanted > 0) {
		goto no_alloc // id: 0x7fffbd224110
		}
		if root_scope.vla.loc == 0 {
			v := cur_scope
			gen_vla_sp_save(loc -= 8)
			for {
			v.vla.loc
			loc
			// while()
			if ! ((v = v.prev) ) { break }
			}
		}
		vla_runtime_type_size(type_, &a)
		gen_vla_alloc(type_, a)
		gen_vla_sp_save(addr)
		cur_scope.vla.loc = addr
		cur_scope.vla.num ++
	}
	else if has_init {
		oldreloc_offset := 0
		if sec && sec.reloc {
		oldreloc_offset = sec.reloc.data_offset
		}
		decl_initializer(type_, sec, addr, 1)
		if sec && sec.reloc {
		squeeze_multi_relocs(sec, oldreloc_offset)
		}
		if flexible_array {
		flexible_array.type_.ref...c = -1
		}
	}
	// RRRREG no_alloc id=0x7fffbd224110
	no_alloc: 
	if init_str {
		end_macro()
		next()
	}
	nocode_wanted = saved_nocode_wanted
}

fn gen_function(sym &Sym)  {
	f := Scope {
	prev: 0, 
}
	
	cur_scope = &f
	root_scope = cur_scope
	nocode_wanted = 0
	ind = cur_text_section.data_offset
	if sym.a.aligned {
		newoff := section_add(cur_text_section, 0, 1 << (sym.a.aligned - 1))
		gen_fill_nops(newoff - ind)
	}
	put_extern_sym(sym, cur_text_section, ind, 0)
	funcname = get_tok_str(sym.v, (voidptr(0)))
	func_ind = ind
	tcc_debug_funcstart(tcc_state, sym)
	sym_push2(&local_stack, 536870912, 0, 0)
	local_scope = 1
	gfunc_prolog(&sym.type_)
	local_scope = 0
	rsym = 0
	clear_temp_local_var_list()
	block(0)
	gsym(rsym)
	nocode_wanted = 0
	gfunc_epilog()
	cur_text_section.data_offset = ind
	sym_pop(&local_stack, (voidptr(0)), 0)
	local_scope = 0
	label_pop(&global_label_stack, (voidptr(0)), 0)
	sym_pop(&all_cleanups, (voidptr(0)), 0)
	elfsym(sym).st_size = ind - func_ind
	tcc_debug_funcend(tcc_state, ind - func_ind)
	cur_text_section = (voidptr(0))
	funcname = c''
	func_vt.t = 0
	func_var = 0
	ind = 0
	nocode_wanted = 2147483648
	check_vstack()
}

fn gen_inline_functions(s &TCCState)  {
	sym := &Sym(0)
	inline_generated := 0
	i := 0
	
	fn := &InlineFunc(0)
	tcc_open_bf(s, c':inline:', 0)
	for {
	inline_generated = 0
	for i = 0 ; i < s.nb_inline_fns ; i ++ {
		fn = s.inline_fns [i] 
		sym = fn.sym
		if sym && (sym...c || !(sym.type_.t & 32768)) {
			fn.sym = (voidptr(0))
			if file {
			pstrcpy(file.filename, sizeoffile.filename, fn.filename)
			}
			begin_macro(fn.func_str, 1)
			next()
			cur_text_section = text_section
			gen_function(sym)
			end_macro()
			inline_generated = 1
		}
	}
	// while()
	if ! (inline_generated ) { break }
	}
	tcc_close()
}

fn free_inline_functions(s &TCCState)  {
	i := 0
	for i = 0 ; i < s.nb_inline_fns ; i ++ {
		fn := s.inline_fns [i] 
		if fn.sym {
		tok_str_free(fn.func_str)
		}
	}
	dynarray_reset(&s.inline_fns, &s.nb_inline_fns)
}

fn decl0(l int, is_for_loop_init int, func_sym &Sym) int {
	v := 0
	has_init := 0
	r := 0
	
	type_ := CType{}
	btype := CType{}
	
	sym := &Sym(0)
	ad := AttributeDef{}
	adbase := AttributeDef{}
	
	for 1 {
		if tok == Tcc_token.tok_static_assert {
			c := 0
			next()
			skip(`(`)
			c = expr_const()
			skip(`,`)
			if c == 0 {
			tcc_error(c'%s', get_tok_str(tok, &tokc))
			}
			next()
			skip(`)`)
			skip(`;`)
			continue
			
		}
		if !parse_btype(&btype, &adbase) {
			if is_for_loop_init {
			return 0
			}
			if tok == `;` && l != 51 {
				next()
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
			}
			else {
				if tok != (-1) {
				expect(c'declaration')
				}
				break
				
			}
		}
		if tok == `;` {
			if (btype.t & 15) == 7 {
				v := btype.ref.v
				if !(v & 536870912) && (v & ~1073741824) >= 268435456 {
				tcc_warning(c'unnamed struct/union that defines no instances')
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
			if (type_.t & 64) && type_.ref...c < 0 {
				type_.ref = sym_push(536870912, &type_.ref.type_, 0, type_.ref...c)
			}
			ad = adbase
			type_decl(&type_, &ad, &v, 2)
			if (type_.t & 15) == 6 {
				sym = type_.ref
				if sym....f.func_type == 2 && l == 48 {
				decl0(51, 0, sym)
				}
				if type_.t & 4096 {
				type_.t &= ~32768
				}
			}
			if gnu_ext && (tok == Tcc_token.tok_asm1 || tok == Tcc_token.tok_asm2 || tok == Tcc_token.tok_asm3) {
				ad.asm_label = asm_label_instr()
				parse_attribute(&ad)
			}
			if tok == `{` {
				if l != 48 {
				tcc_error(c'cannot use local functions')
				}
				if (type_.t & 15) != 6 {
				expect(c'function definition')
				}
				sym = type_.ref
				for (sym = sym..next) != (voidptr(0)) {
					if !(sym.v & ~536870912) {
					expect(c'identifier')
					}
					if sym.type_.t == 0 {
					sym.type_ = int_type
					}
				}
				type_.t &= ~4096
				sym = external_sym(v, &type_, 0, &ad)
				if sym.type_.t & 32768 {
					fn := &InlineFunc(0)
					filename := &i8(0)
					filename = if file{ file.filename } else {c''}
					fn = tcc_malloc(sizeof*fn + C.strlen(filename))
					strcpy(fn.filename, filename)
					fn.sym = sym
					skip_or_save_block(&fn.func_str)
					dynarray_add(&tcc_state.inline_fns, &tcc_state.nb_inline_fns, fn)
				}
				else {
					cur_text_section = ad.section
					if !cur_text_section {
					cur_text_section = text_section
					}
					gen_function(sym)
				}
				break
				
			}
			else {
				if l == 51 {
					for sym = func_sym..next ; sym ; sym = sym..next {
					if (sym.v & ~536870912) == v {
					goto found // id: 0x7fffbd231298
					}
					}
					tcc_error(c"declaration for parameter '%s' but no such parameter", get_tok_str(v, (voidptr(0))))
					// RRRREG found id=0x7fffbd231298
					found: 
					if type_.t & (4096 | 8192 | 16384 | 32768) {
					tcc_error(c"storage class specified for '%s'", get_tok_str(v, (voidptr(0))))
					}
					if sym.type_.t != 0 {
					tcc_error(c"redefinition of parameter '%s'", get_tok_str(v, (voidptr(0))))
					}
					convert_parameter_type(&type_)
					sym.type_ = type_
				}
				else if type_.t & 16384 {
					sym = sym_find(v)
					if sym && sym....sym_scope == local_scope {
						if !is_compatible_types(&sym.type_, &type_) || !(sym.type_.t & 16384) {
						tcc_error(c"incompatible redefinition of '%s'", get_tok_str(v, (voidptr(0))))
						}
						sym.type_ = type_
					}
					else {
						sym = sym_push(v, &type_, 0, 0)
					}
					sym.a = ad.a
					sym....f = ad.f
				}
				else if (type_.t & 15) == 0 && !(type_.t & 4096) {
					tcc_error(c'declaration of void object')
				}
				else {
					r = 0
					if (type_.t & 15) == 6 {
						type_.ref....f = ad.f
					}
					else if !(type_.t & 64) {
						r |= lvalue_type(type_.t)
					}
					has_init = (tok == `=`)
					if has_init && (type_.t & 1024) {
					tcc_error(c'variable length array cannot be initialized')
					}
					if ((type_.t & 4096) && (!has_init || l != 48)) || (type_.t & 15) == 6 || ((type_.t & 64) && !has_init && l == 48 && type_.ref...c < 0) {
						type_.t |= 4096
						sym = external_sym(v, &type_, r, &ad)
						if ad.alias_target {
							esym := &Elf64_Sym(0)
							alias_target := &Sym(0)
							alias_target = sym_find(ad.alias_target)
							esym = elfsym(alias_target)
							if !esym {
							tcc_error(c'unsupported forward __alias__ attribute')
							}
							put_extern_sym2(sym, esym.st_shndx, esym.st_value, esym.st_size, 0)
						}
					}
					else {
						if type_.t & 8192 {
						r |= 48
						}
						else { // 3
						r |= l
}
						if has_init {
						next()
						}
						else if l == 48 {
						type_.t |= 4096
						}
						decl_initializer_alloc(&type_, &ad, r, has_init, v, l)
					}
				}
				if tok != `,` {
					if is_for_loop_init {
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

fn decl(l int)  {
	decl0(l, 0, (voidptr(0)))
}

