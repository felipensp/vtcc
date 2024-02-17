@[translated]
module main

fn C.abort()

@[weak]
__global (
	gnu_ext int
)

@[weak]
__global (
	tcc_ext int
)

@[weak]
__global (
	tcc_state &TCCState
)

@[weak]
__global (
	file &BufferedFile
)

@[weak]
__global (
	ch int
)

@[weak]
__global (
	tok int
)

@[weak]
__global (
	tok_flags int
)

@[weak]
__global (
	total_lines int
)

@[weak]
__global (
	total_bytes int
)

@[weak]
__global (
	tok_ident int
)

fn isnum(c int) int {
	return c >= `0` && c <= `9`
}

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
	global_stack &Sym
)

@[weak]
__global (
	local_stack &Sym
)

@[weak]
__global (
	define_stack &Sym
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
	g_debug int
)

@[weak]
__global (
	symtab_section &Section
)

@[weak]
__global (
	nb_states int
)

fn skip(c int) {
	if tok != c {
		tcc_error(c'\'%c\' expected (got "%s")', c, get_tok_str(tok, &tokc))
	}
	next()
}

fn cstr_ccat(cstr &CString, ch int) {
	size := 0
	size = cstr.size + 1
	if size > cstr.size_allocated {
		cstr_realloc(cstr, size)
	}
	(&u8(cstr.data))[size - 1] = ch
	cstr.size = size
}

fn cstr_cat(cstr &CString, str &i8, len int) {
	size := 0
	if len <= 0 {
		len = C.strlen(str) + 1 + len
	}
	size = cstr.size + len
	if size > cstr.size_allocated {
		cstr_realloc(cstr, size)
	}
	C.memmove((&u8(cstr.data)) + cstr.size, str, len)
	cstr.size = size
}

fn cstr_new(cstr &CString) {
	C.memset(cstr, 0, sizeof(CString))
}

fn cstr_free(cstr &CString) {
	tal_free_impl(cstr_alloc, cstr.data)
	cstr_new(cstr)
}

fn tok_alloc(str &i8, len int) &TokenSym {
	ts := &TokenSym(0)
	pts := &&TokenSym(0)

	i := 0
	h := u32(0)
	h = 1
	for i = 0; i < len; i++ {
		h = (h + (h << 5) + (h >> 27) + ((&u8(str))[i]))
	}
	h &= (16384 - 1)
	pts = &hash_ident[h]
	for ; true; {
		ts = *pts
		if !ts {
			break
		}
		if ts.len == len && !C.memcmp(ts.str, str, len) {
			return ts
		}
		pts = &(ts.hash_next)
	}
	return tok_alloc_new(pts, str, len)
}

fn tok_str_free_str(str &int) {
	tal_free_impl(tokstr_alloc, str)
}

fn tok_str_free(str &TokenString) {
	tok_str_free_str(str.str)
	tal_free_impl(tokstr_alloc, str)
}

fn define_push(v int, macro_type int, str &int, first_arg &Sym) {
	s := &Sym(0)
	o := &Sym(0)

	o = define_find(v)
	s = sym_push2(&define_stack, v, macro_type, 0)
	s.d = str
	s.next = first_arg
	table_ident[v - 256].sym_define = s
	if o && !macro_is_equal(o.d, s.d) {
		tcc_warning(c'%s redefined', get_tok_str(v, (unsafe { nil })))
	}
}

fn define_undef(s &Sym) {
	v := s.v
	if v >= 256 && v < tok_ident {
		table_ident[v - 256].sym_define = (unsafe { nil })
	}
}

fn define_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
		return unsafe { nil }
	}
	return table_ident[v].sym_define
}

fn free_defines(b &Sym) {
	for define_stack != b {
		top := define_stack
		define_stack = top.prev
		tok_str_free_str(top.d)
		define_undef(top)
		sym_free(top)
	}
	for b {
		v := b.v
		if v >= 256 && v < tok_ident {
			d := &table_ident[v - 256].sym_define
			if !*d && b.d {
				*d = b
			}
		}
		b = b.prev
	}
}

fn parse_define() {
	s := &Sym(0)
	first := &Sym(0)
	ps := &&Sym(0)

	v := 0
	t := 0
	varg := 0
	is_vaargs := 0
	spc := 0

	saved_parse_flags := parse_flags
	v = tok
	if v < 256 || v == Tcc_token.tok_defined {
		tcc_error(c"invalid macro name '%s'", get_tok_str(tok, &tokc))
	}
	first = (unsafe { nil })
	t = 0
	parse_flags = ((parse_flags & ~8) | 16)
	next_nomacro_spc()
	if tok == `(` {
		dotid := set_idnum(`.`, 0)
		next_nomacro()
		ps = &first
		if tok != `)` {
			for ; true; {
				varg = tok
				next_nomacro()
				is_vaargs = 0
				if varg == 200 {
					varg = Tcc_token.tok___va_args__
					is_vaargs = 1
				} else if tok == 200 && gnu_ext {
					is_vaargs = 1
					next_nomacro()
				}
				if varg < 256 {
					// RRRREG bad_list id=0x7fffe5cc8710
					bad_list:
					tcc_error(c'bad macro parameter list')
				}
				s = sym_push2(&define_stack, varg | 536870912, is_vaargs, 0)
				*ps = s
				ps = &s.next
				if tok == `)` {
					break
				}
				if tok != `,` || is_vaargs {
					goto bad_list // id: 0x7fffe5cc8710
				}
				next_nomacro()
			}
		}
		next_nomacro_spc()
		t = 1
		set_idnum(`.`, dotid)
	}
	tokstr_buf.len = 0
	spc = 2
	parse_flags |= 32 | 16 | 4
	for tok != 10 && tok != (-1) {
		if 202 == tok {
			if 2 == spc {
				goto bad_twosharp // id: 0x7fffe5cc93e0
			}
			if 1 == spc {
				tokstr_buf.len--$
			}
			spc = 3
			tok = 205
		} else if `#` == tok {
			spc = 4
		} else if check_space(tok, &spc) {
			goto skip // id: 0x7fffe5cc9848
		}
		tok_str_add2(&tokstr_buf, tok, &tokc)
		// RRRREG skip id=0x7fffe5cc9848
		skip:
		next_nomacro_spc()
	}
	parse_flags = saved_parse_flags
	if spc == 1 {
		tokstr_buf.len--$
	}
	tok_str_add(&tokstr_buf, 0)
	if 3 == spc {
		// RRRREG bad_twosharp id=0x7fffe5cc93e0
		bad_twosharp:
		tcc_error(c"'##' cannot appear at either end of macro")
	}
	define_push(v, t, tok_str_dup(&tokstr_buf), first)
}

fn preprocess(is_bof int) {
	s1 := tcc_state
	i := 0
	c := 0
	n := 0
	saved_parse_flags := 0

	buf := [1024]i8{}
	q := &i8(0)

	s := &Sym(0)
	saved_parse_flags = parse_flags
	parse_flags = 1 | 2 | 64 | 4 | (parse_flags & 8)
	next_nomacro()
	// RRRREG redo id=0x7fffe5cd8018
	redo:
	match tok {
		.tok_define { // case comp body kind=BinaryOperator is_enum=true
			pp_debug_tok = tok
			next_nomacro()
			pp_debug_symv = tok
			parse_define()
		}
		.tok_undef { // case comp body kind=BinaryOperator is_enum=true
			pp_debug_tok = tok
			next_nomacro()
			pp_debug_symv = tok
			s = define_find(tok)
			if s {
				define_undef(s)
			}
		}
		.tok_include, .tok_include_next {
			ch = file.buf_ptr[0]
			skip_spaces()
			if ch == `<` {
				c = `>`
				goto read_name // id: 0x7fffe5cd16d8
			} else if ch == `"` {
				c = ch
				// RRRREG read_name id=0x7fffe5cd16d8
				read_name:
				inp()
				q = buf
				for ch != c && ch != `\n` && ch != (-1) {
					if (q - buf) < sizeof(buf) - 1 {
						*q++ = ch
					}
					if ch == `\\` {
						if handle_stray_noerror() == 0 {
							q--$
						}
					} else { // 3
						inp()
					}
				}
				*q = `\x00`
				minp()
			} else {
				len := 0
				parse_flags = (1 | 4 | (parse_flags & 8))
				next()
				buf[0] = `\x00`
				for tok != 10 {
					pstrcat(buf, sizeof(buf), get_tok_str(tok, &tokc))
					next()
				}
				len = C.strlen(buf)
				if (len < 2 || ((buf[0] != `"` || buf[len - 1] != `"`)
					&& (buf[0] != `<` || buf[len - 1] != `>`))) {
					tcc_error(c'\'#include\' expects "FILENAME" or <FILENAME>')
				}
				c = buf[len - 1]
				C.memmove(buf, buf + 1, len - 2)
				buf[len - 2] = `\x00`
			}
			if s1.include_stack_ptr >= s1.include_stack + 32 {
				tcc_error(c'#include recursion too deep')
			}
			*s1.include_stack_ptr++ = file
			i = if tok == Tcc_token.tok_include_next { file.include_next_index } else { 0 }
			n = 2 + s1.nb_include_paths + s1.nb_sysinclude_paths
			for ; i < n; i++ {
				buf1 := [1024]i8{}
				e := &CachedInclude(0)
				path := &i8(0)
				if i == 0 {
					if !(buf[0] == `/`) {
						continue
					}
					buf1[0] = 0
				} else if i == 1 {
					if c != `"` {
						continue
					}
					path = file.truefilename
					pstrncpy(buf1, path, tcc_basename(path) - path)
				} else {
					j := i - 2
					k := j - s1.nb_include_paths

					path = if k < 0 { s1.include_paths[j] } else { s1.sysinclude_paths[k] }
					pstrcpy(buf1, sizeof(buf1), path)
					pstrcat(buf1, sizeof(buf1), c'/')
				}
				pstrcat(buf1, sizeof(buf1), buf)
				e = search_cached_include(s1, buf1, 0)
				if e && (define_find(e.ifndef_macro) || e.once == pp_once) {
					goto include_done // id: 0x7fffe5cd5350
				}
				if tcc_open(s1, buf1) < 0 {
					continue
				}
				file.include_next_index = i + 1
				if s1.gen_deps {
					dynarray_add(&s1.target_deps, &s1.nb_target_deps, tcc_strdup(buf1))
				}
				if s1.do_debug {
					put_stabs(file.filename, __stab_debug_code.n_bincl, 0, 0, 0)
				}
				tok_flags |= 2 | 1
				ch = file.buf_ptr[0]
				goto _GOTO_PLACEHOLDER_0x7fffe5cd5e00 // id: 0x7fffe5cd5e00
			}
			tcc_error(c"include file '%s' not found", buf)
			// RRRREG include_done id=0x7fffe5cd5350
			include_done:
			s1.include_stack_ptr--$
		}
		.tok_ifndef { // case comp body kind=BinaryOperator is_enum=true
			c = 1
			goto do_ifdef // id: 0x7fffe5cd6190
		}
		.tok_if { // case comp body kind=BinaryOperator is_enum=true
			c = expr_preprocess()
			goto do_if // id: 0x7fffe5cd62f0
		}
		.tok_ifdef { // case comp body kind=BinaryOperator is_enum=true
			c = 0
			// RRRREG do_ifdef id=0x7fffe5cd6190
			do_ifdef:
			next_nomacro()
			if tok < 256 {
				tcc_error(c"invalid argument for '#if%sdef'", if c { c'n' } else { c'' })
			}
			if is_bof {
				if c {
					file.ifndef_macro = tok
				}
			}
			c = (define_find(tok) != 0) ^ c
			// RRRREG do_if id=0x7fffe5cd62f0
			do_if:
			if s1.ifdef_stack_ptr >= s1.ifdef_stack + 64 {
				tcc_error(c'memory full (ifdef)')
			}
			*s1.ifdef_stack_ptr++ = c
			goto test_skip // id: 0x7fffe5cd6d60
		}
		.tok_else { // case comp body kind=IfStmt is_enum=true
			if s1.ifdef_stack_ptr == s1.ifdef_stack {
				tcc_error(c'#else without matching #if')
			}
			if s1.ifdef_stack_ptr[-1] & 2 {
				tcc_error(c'#else after #else')
			}
			s1.ifdef_stack_ptr[-1] ^= 3
			c = s1.ifdef_stack_ptr[-1]
			goto test_else // id: 0x7fffe5cd7408
		}
		.tok_elif { // case comp body kind=IfStmt is_enum=true
			if s1.ifdef_stack_ptr == s1.ifdef_stack {
				tcc_error(c'#elif without matching #if')
			}
			c = s1.ifdef_stack_ptr[-1]
			if c > 1 {
				tcc_error(c'#elif after #else')
			}
			if c == 1 {
				c = 0
			} else {
				c = expr_preprocess()
				s1.ifdef_stack_ptr[-1] = c
			}
			// RRRREG test_else id=0x7fffe5cd7408
			test_else:
			if s1.ifdef_stack_ptr == file.ifdef_stack_ptr + 1 {
				file.ifndef_macro = 0
			}
			// RRRREG test_skip id=0x7fffe5cd6d60
			test_skip:
			if !(c & 1) {
				preprocess_skip()
				is_bof = 0
				goto _GOTO_PLACEHOLDER_0x7fffe5cd8018 // id: 0x7fffe5cd8018
			}
		}
		.tok_endif { // case comp body kind=IfStmt is_enum=true
			if s1.ifdef_stack_ptr <= file.ifdef_stack_ptr {
				tcc_error(c'#endif without matching #if')
			}
			s1.ifdef_stack_ptr--
			if file.ifndef_macro && s1.ifdef_stack_ptr == file.ifdef_stack_ptr {
				file.ifndef_macro_saved = file.ifndef_macro
				file.ifndef_macro = 0
				for tok != 10 {
					next_nomacro()
				}
				tok_flags |= 4
				goto _GOTO_PLACEHOLDER_0x7fffe5cd5e00 // id: 0x7fffe5cd5e00
			}
		}
		190 { // case comp body kind=BinaryOperator is_enum=true
			n = strtoul(&i8(tokc.str.data), &q, 10)
			goto _line_num // id: 0x7fffe5cd8bb8
		}
		.tok_line { // case comp body kind=CallExpr is_enum=true
			next()
			if tok != 181 {
				// RRRREG _line_err id=0x7fffe5cdae78
				_line_err:
				tcc_error(c'wrong #line format')
			}
			n = tokc.i
			// RRRREG _line_num id=0x7fffe5cd8bb8
			_line_num:
			next()
			if tok != 10 {
				if tok == 185 {
					if file.truefilename == file.filename {
						file.truefilename = tcc_strdup(file.filename)
					}
					pstrcpy(file.filename, sizeof(file.filename), &i8(tokc.str.data))
				} else if parse_flags & 8 {
				} else { // 3
					goto _line_err // id: 0x7fffe5cdae78
				}
				n--$
			}
			if file.fd > 0 {
				total_lines += file.line_num - n
			}
			file.line_num = n
			if s1.do_debug {
				put_stabs(file.filename, __stab_debug_code.n_bincl, 0, 0, 0)
			}
		}
		.tok_error, .tok_warning {
			c = tok
			ch = file.buf_ptr[0]
			skip_spaces()
			q = buf
			for ch != `\n` && ch != (-1) {
				if (q - buf) < sizeof(buf) - 1 {
					*q++ = ch
				}
				if ch == `\\` {
					if handle_stray_noerror() == 0 {
						q--$
					}
				} else { // 3
					inp()
				}
			}
			*q = `\x00`
			if c == Tcc_token.tok_error {
				tcc_error(c'#error %s', buf)
			} else { // 3
				tcc_warning(c'#warning %s', buf)
			}
		}
		.tok_pragma { // case comp body kind=CallExpr is_enum=true
			pragma_parse(s1)
		}
		10 { // case comp body kind=GotoStmt is_enum=true
			goto _GOTO_PLACEHOLDER_0x7fffe5cd5e00 // id: 0x7fffe5cd5e00
			if tok == `!` && is_bof {
				goto ignore // id: 0x7fffe5cdcbe0
			}
			tcc_warning(c'Ignoring unknown preprocessing directive #%s', get_tok_str(tok,
				&tokc))
			// RRRREG ignore id=0x7fffe5cdcbe0
			ignore:
			file.buf_ptr = parse_line_comment(file.buf_ptr - 1)
			goto _GOTO_PLACEHOLDER_0x7fffe5cd5e00 // id: 0x7fffe5cd5e00
		}
		else {
			if saved_parse_flags & 8 {
				goto ignore // id: 0x7fffe5cdcbe0
			}
		}
	}
	for tok != 10 {
		next_nomacro()
	}
	// RRRREG the_end id=0x7fffe5cd5e00
	the_end:
	parse_flags = saved_parse_flags
}

fn next_nomacro() {
	for {
		next_nomacro_spc()
		// while()
		if !(tok < 256 && isidnum_table[tok - (-1)] & 1) {
			break
		}
	}
}

@[export: 'ab_month_name']
const ab_month_name = [c'Jan', c'Feb', c'Mar', c'Apr', c'May', c'Jun', c'Jul', c'Aug', c'Sep',
	c'Oct', c'Nov', c'Dec']!

fn next() {
	if tcc_state.do_debug {
		tcc_debug_line(tcc_state)
	}
	// RRRREG redo id=0x7fffe5d1dc40
	redo:
	if parse_flags & 16 {
		next_nomacro_spc()
	} else { // 3
		next_nomacro()
	}
	if macro_ptr {
		if tok == 204 || tok == 203 {
			goto redo // id: 0x7fffe5d1dc40
		} else if tok == 0 {
			end_macro()
			goto redo // id: 0x7fffe5d1dc40
		}
	} else if tok >= 256 && parse_flags & 1 {
		s := &Sym(0)
		s = define_find(tok)
		if s {
			nested_list := (unsafe { nil })
			tokstr_buf.len = 0
			macro_subst_tok(&tokstr_buf, &nested_list, s)
			tok_str_add(&tokstr_buf, 0)
			begin_macro(&tokstr_buf, 0)
			goto redo // id: 0x7fffe5d1dc40
		}
	}
	if tok == 190 {
		if parse_flags & 2 {
			parse_number(&i8(tokc.str.data))
		}
	} else if tok == 191 {
		if parse_flags & 64 {
			parse_string(&i8(tokc.str.data), tokc.str.size - 1)
		}
	}
}

fn preprocess_start(s1 &TCCState, is_asm int) {
	cstr := CString{}
	i := 0
	s1.include_stack_ptr = s1.include_stack
	s1.ifdef_stack_ptr = s1.ifdef_stack
	file.ifdef_stack_ptr = s1.ifdef_stack_ptr
	pp_expr = 0
	pp_counter = 0
	pp_debug_tok = 0
	pp_debug_symv = pp_debug_tok
	pp_once++
	pvtop = (__vstack + 1) - 1
	vtop = pvtop
	C.memset(vtop, 0, sizeof(*vtop))
	s1.pack_stack[0] = 0
	s1.pack_stack_ptr = s1.pack_stack
	set_idnum(`$`, if s1.dollars_in_identifiers { 2 } else { 0 })
	set_idnum(`.`, if is_asm { 2 } else { 0 })
	cstr_new(&cstr)
	cstr_cat(&cstr, c'"', -1)
	cstr_cat(&cstr, file.filename, -1)
	cstr_cat(&cstr, c'"', 0)
	tcc_define_symbol(s1, c'__BASE_FILE__', cstr.data)
	cstr_reset(&cstr)
	for i = 0; i < s1.nb_cmd_include_files; i++ {
		cstr_cat(&cstr, c'#include "', -1)
		cstr_cat(&cstr, s1.cmd_include_files[i], -1)
		cstr_cat(&cstr, c'"\n', -1)
	}
	if cstr.size {
		*s1.include_stack_ptr++ = file
		tcc_open_bf(s1, c'<command line>', cstr.size)
		C.memcpy(file.buffer, cstr.data, cstr.size)
	}
	cstr_free(&cstr)
	if is_asm {
		tcc_define_symbol(s1, c'__ASSEMBLER__', (unsafe { nil }))
	}
	parse_flags = if is_asm { 8 } else { 0 }
	tok_flags = 1 | 2
}

fn preprocess_end(s1 &TCCState) {
	for macro_stack {
		end_macro()
	}
	macro_ptr = (unsafe { nil })
}

fn tccpp_new(s &TCCState) {
	i := 0
	c := 0

	p := &i8(0)
	r := &i8(0)

	s.include_stack_ptr = s.include_stack
	s.ppfp = C.stdout
	for i = (-1); i < 128; i++ {
		set_idnum(i, if is_space(i) {
			1
		} else {
			if isid(i) {
				2
			} else {
				if isnum(i) { 4 } else { 0 }
			}
		})
	}
	for i = 128; i < 256; i++ {
		set_idnum(i, 2)
	}
	tal_new(&toksym_alloc, 256, (768 * 1024))
	tal_new(&tokstr_alloc, 128, (768 * 1024))
	tal_new(&cstr_alloc, 1024, (256 * 1024))
	C.memset(hash_ident, 0, 16384 * sizeof(&TokenSym))
	cstr_new(&cstr_buf)
	cstr_realloc(&cstr_buf, 1024)
	tok_str_new(&tokstr_buf)
	tok_str_realloc(&tokstr_buf, 256)
	tok_ident = 256
	p = tcc_keywords
	for *p {
		r = p
		for ; true; {
			c = *r++
			if c == `\x00` {
				break
			}
		}
		tok_alloc(p, r - p - 1)
		p = r
	}
}

fn tccpp_delete(s &TCCState) {
	i := 0
	n := 0

	free_defines((unsafe { nil }))
	n = tok_ident - 256
	for i = 0; i < n; i++ {
		tal_free_impl(toksym_alloc, table_ident[i])
	}
	tcc_free(table_ident)
	table_ident = (unsafe { nil })
	cstr_free(&tokcstr)
	cstr_free(&cstr_buf)
	cstr_free(&macro_equal_buf)
	tok_str_free_str(tokstr_buf.str)
	tal_delete(toksym_alloc)
	toksym_alloc = (unsafe { nil })
	tal_delete(tokstr_alloc)
	tokstr_alloc = (unsafe { nil })
	tal_delete(cstr_alloc)
	cstr_alloc = (unsafe { nil })
}

fn tcc_preprocess(s1 &TCCState) int {
	iptr := &&BufferedFile(0)
	token_seen := 0
	spcs := 0
	level := 0

	p := &i8(0)
	white := [400]i8{}
	parse_flags = 1 | (parse_flags & 8) | 4 | 16 | 32
	if s1.Pflag == line_macro_output_format_p10 {
		parse_flags |= 2
		s1.Pflag = parse_flags
	}
	if s1.dflag & 1 {
		pp_debug_builtins(s1)
		s1.dflag &= ~1
	}
	token_seen = 10
	spcs = 0
	pp_line(s1, file, 0)
	for ; true; {
		iptr = s1.include_stack_ptr
		next()
		if tok == (-1) {
			break
		}
		level = s1.include_stack_ptr - iptr
		if level {
			if level > 0 {
				pp_line(s1, *iptr, 0)
			}
			pp_line(s1, file, level)
		}
		if s1.dflag & 7 {
			pp_debug_defines(s1)
			if s1.dflag & 4 {
				continue
			}
		}
		if is_space(tok) {
			if spcs < sizeof(white) - 1 {
				white[spcs++] = tok
			}
			continue
		} else if tok == 10 {
			spcs = 0
			if token_seen == 10 {
				continue
			}
			file.line_ref++$
		} else if token_seen == 10 {
			pp_line(s1, file, 0)
		} else if spcs == 0 && pp_need_space(token_seen, tok) {
			white[spcs++] = ` `
		}
		white[spcs] = 0
		fputs(white, s1.ppfp)
		spcs = 0
		p = get_tok_str(tok, &tokc)
		fputs(p, s1.ppfp)
		token_seen = pp_check_he0xe(tok, p)
	}
	return 0
}

// skipping global dup "ind"
// skipping global dup "loc"
// skipping global dup "sym_free_first"
// skipping global dup "sym_pools"
// skipping global dup "nb_sym_pools"
// skipping global dup "global_stack"
// skipping global dup "local_stack"
// skipping global dup "define_stack"
// skipping global dup "g_debug"
struct Switch_t {
	p       &&Case_t
	n       int
	def_sym int
	bsym    &int
	scope   &Scope
}

struct Temp_local_variable {
	location int
	size     i16
	align    i16
}

struct Scope {
	prev &Scope
	vla  struct {
		loc int
		num int
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

fn block(is_expr int)

fn decl(l int)

fn tccgen_compile(s1 &TCCState) int {
	cur_text_section = (unsafe { nil })
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
	func_old_type.ref.f.func_call = 0
	func_old_type.ref.f.func_type = 2
	tcc_debug_start(s1)
	parse_flags = 1 | 2 | 64
	next()
	decl(48)
	gen_inline_functions(s1)
	check_vstack()
	tcc_debug_end(s1)
	return 0
}

fn sym_free(sym &Sym) {
	sym.next = sym_free_first
	sym_free_first = sym
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
			gen_op(1)
			vpushi(bits - bit_size)
			gen_op(2)
		}
		r = gv(rc)
	} else {
		if is_float(vtop.type_.t) && (vtop.r & (63 | 256)) == 48 {
			offset := u32(0)
			size = type_size(&vtop.type_, &align)
			if (nocode_wanted > 0) {
				size = 0
				align = 1
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
		rc2 = if (rc & 2) { 2 } else { 1 }
		if rc == 4 {
			rc2 = 16
		} else if rc == 4096 {
			rc2 = 8192
		}
		if r >= 48 || vtop.r & 256 || !(reg_classes[r] & rc)
			|| ((vtop.type_.t & 15) == 13 && !(reg_classes[vtop.r2] & rc2))
			|| ((vtop.type_.t & 15) == 14 && !(reg_classes[vtop.r2] & rc2)) {
			r = get_reg(rc)
			if (vtop.type_.t & 15) == 13 || (vtop.type_.t & 15) == 14 {
				addr_type := 4
				load_size := 8
				load_type := if ((vtop.type_.t & 15) == 13) { 4 } else { 9 }

				r2 := 0
				original_type := 0

				original_type = vtop.type_.t
				if vtop.r & 256 {
					save_reg_upstack(vtop.r, 1)
					vtop.type_.t = load_type
					load(r, vtop)
					vdup()
					vtop[-1].r = r
					vtop.type_.t = addr_type
					gaddrof()
					vpushi(load_size)
					gen_op(`+`)
					vtop.r |= 256
					vtop.type_.t = load_type
				} else {
					load(r, vtop)
					vdup()
					vtop[-1].r = r
					vtop.r = vtop[-1].r2
				}
				r2 = get_reg(rc2)
				load(r2, vtop)
				vpop()
				vtop.r2 = r2
				vtop.type_.t = original_type
			} else if vtop.r & 256 && !is_float(vtop.type_.t) {
				t1 := 0
				t := 0

				t = vtop.type_.t
				t1 = t
				if vtop.r & 4096 {
					t = 1
				} else if vtop.r & 8192 {
					t = 2
				}
				if vtop.r & 16384 {
					t |= 16
				}
				vtop.type_.t = t
				load(r, vtop)
				vtop.type_.t = t1
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

fn inc(post int, c int) {
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

fn block(is_expr int) {
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
	// RRRREG again id=0x7fffe5e1ff18
	again:
	t = tok, next()
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
		} else {
			gsym(a)
		}
	} else if t == Tcc_token.tok_while {
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
	} else if t == `{` {
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
				if !(tok == `,`) {
					break
				}
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
	} else if t == Tcc_token.tok_return {
		a = tok != `;`
		b = (func_vt.t & 15) != 0
		if a {
			gexpr(), gen_assign_cast(&func_vt)
		}
		leave_scope(root_scope)
		if a && b {
			gfunc_return(&func_vt)
		} else if a {
			vtop--
		} else if b {
			tcc_warning(c"'return' with no value.")
		}
		skip(`;`)
		if tok != `}` || local_scope != 1 {
			rsym = gjmp_acs(rsym)
		}
		nocode_wanted |= 536870912
	} else if t == Tcc_token.tok_break {
		if !cur_scope.bsym {
			tcc_error(c'cannot break')
		}
		if !cur_switch || cur_scope.bsym != cur_switch.bsym {
			leave_scope(loop_scope)
		} else { // 3
			leave_scope(cur_switch.scope)
		}
		*cur_scope.bsym = gjmp_acs(*cur_scope.bsym)
		skip(`;`)
	} else if t == Tcc_token.tok_continue {
		if !cur_scope.csym {
			tcc_error(c'cannot continue')
		}
		leave_scope(loop_scope)
		*cur_scope.csym = gjmp_acs(*cur_scope.csym)
		skip(`;`)
	} else if t == Tcc_token.tok_for {
		o := Scope{}
		new_scope(&o)
		skip(`(`)
		if tok != `;` {
			if !decl0(50, 1, (unsafe { nil })) {
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
	} else if t == Tcc_token.tok_switch {
		saved := &Switch_t(0)
		sw := Switch_t{}

		switchval := SValue{}
		sw.p = (unsafe { nil })
		sw.n = 0
		sw.def_sym = 0
		sw.bsym = &a
		sw.scope = cur_scope
		saved = cur_switch
		cur_switch = &sw
		skip(`(`)
		gexpr()
		skip(`)`)
		switchval = *vtop--
		a = 0
		b = gjmp_acs(0)
		lblock(&a, (unsafe { nil }))
		a = gjmp_acs(a)
		gsym(b)
		C.qsort(sw.p, sw.n, sizeof(voidptr), case_cmp)
		for b = 1; b < sw.n; b++ {
			if sw.p[b - 1].v2 >= sw.p[b].v1 {
				tcc_error(c'duplicate case value')
			}
		}
		if (switchval.type_.t & 15) == 4 {
			switchval.type_.t &= ~16
		}
		vpushv(&switchval)
		gv(1)
		d = 0, gcase(sw.p, sw.n, &d)
		vpop()
		if sw.def_sym {
			gsym_addr(d, sw.def_sym)
		} else { // 3
			gsym(d)
		}
		gsym(a)
		dynarray_reset(&sw.p, &sw.n)
		cur_switch = saved
	} else if t == Tcc_token.tok_case {
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
		goto block_after_label // id: 0x7fffe5e27a30
	} else if t == Tcc_token.tok_default {
		if !cur_switch {
			expect(c'switch')
		}
		if cur_switch.def_sym {
			tcc_error(c"too many 'default'")
		}
		cur_switch.def_sym = gind()
		skip(`:`)
		is_expr = 0
		goto block_after_label // id: 0x7fffe5e27a30
	} else if t == Tcc_token.tok_goto {
		vla_restore(root_scope.vla.loc)
		if tok == `*` && gnu_ext {
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
					tcc_error(c"duplicate label '%s'", get_tok_str(s.v, (unsafe { nil })))
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
			// RRRREG block_after_label id=0x7fffe5e27a30
			block_after_label:
			vla_restore(cur_scope.vla.loc)
			if tok == `}` {
				tcc_warning(c'deprecated use of label at end of compound statement')
			} else {
				goto again // id: 0x7fffe5e1ff18
			}
		} else {
			if t != `;` {
				unget_tok(t)
				if is_expr {
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

fn decl(l int) {
	decl0(l, 0, (unsafe { nil }))
}

// skipping global dup "symtab_section"
fn tccelf_new(s &TCCState) {
	dynarray_add(&s.sections, &s.nb_sections, (unsafe { nil }))
	text_section = new_section(s, c'.text', 1, (1 << 1) | (1 << 2))
	data_section = new_section(s, c'.data', 1, (1 << 1) | (1 << 0))
	bss_section = new_section(s, c'.bss', 8, (1 << 1) | (1 << 0))
	common_section = new_section(s, c'.common', 8, 2147483648)
	common_section.sh_num = 65522
	symtab_section = new_symtab(s, c'.symtab', 2, 0, c'.strtab', c'.hashtab', 2147483648)
	s.symtab = symtab_section
	s.dynsymtab_section = new_symtab(s, c'.dynsymtab', 2, 2147483648 | 1073741824, c'.dynstrtab',
		c'.dynhashtab', 2147483648)
	get_sym_attr(s, 0, 1)
}

fn tccelf_bounds_new(s &TCCState) {
	bounds_section = new_section(s, c'.bounds', 1, (1 << 1))
	lbounds_section = new_section(s, c'.lbounds', 1, (1 << 1))
}

fn tccelf_stab_new(s &TCCState) {
	stab_section = new_section(s, c'.stab', 1, 0)
	stab_section.sh_entsize = sizeof(Stab_Sym)
	stabstr_section = new_section(s, c'.stabstr', 3, 0)
	put_elf_str(stabstr_section, c'')
	stab_section.link = stabstr_section
	put_stabs(c'', 0, 0, 0, 0)
}

fn tccelf_delete(s1 &TCCState) {
	i := 0
	for i = 1; i < s1.nb_sections; i++ {
		free_section(s1.sections[i])
	}
	dynarray_reset(&s1.sections, &s1.nb_sections)
	for i = 0; i < s1.nb_priv_sections; i++ {
		free_section(s1.priv_sections[i])
	}
	dynarray_reset(&s1.priv_sections, &s1.nb_priv_sections)
	for i = 0; i < s1.nb_loaded_dlls; i++ {
		ref := s1.loaded_dlls[i]
		if ref.handle {
			dlclose(ref.handle)
		}
	}
	dynarray_reset(&s1.loaded_dlls, &s1.nb_loaded_dlls)
	tcc_free(s1.sym_attrs)
	symtab_section = (unsafe { nil })
}

fn tccelf_begin_file(s1 &TCCState) {
	s := &Section(0)
	i := 0
	for i = 1; i < s1.nb_sections; i++ {
		s = s1.sections[i]
		s.sh_offset = s.data_offset
	}
	s = s1.symtab
	s.reloc = s.hash
	s.hash = (unsafe { nil })
}

fn tccelf_end_file(s1 &TCCState) {
	s := s1.symtab
	first_sym := 0
	nb_syms := 0
	tr := &int(0)
	i := 0

	first_sym = s.sh_offset / sizeof(Elf64_Sym)
	nb_syms = s.data_offset / sizeof(Elf64_Sym) - first_sym
	s.data_offset = s.sh_offset
	s.link.data_offset = s.link.sh_offset
	s.hash = s.reloc
	s.reloc = unsafe { nil }
	tr = tcc_mallocz(nb_syms * sizeof(*tr))
	for i = 0; i < nb_syms; i++ {
		sym := &Elf64_Sym(s.data) + first_sym + i
		if sym.st_shndx == 0 && ((u8((sym.st_info))) >> 4) == 0 {
			sym.st_info = (((1) << 4) + (((sym.st_info) & 15) & 15))
		}
		tr[i] = set_elf_sym(s, sym.st_value, sym.st_size, sym.st_info, sym.st_other, sym.st_shndx,
			&i8(s.link.data) + sym.st_name)
	}
	for i = 1; i < s1.nb_sections; i++ {
		sr := s1.sections[i]
		if sr.sh_type == 4 && sr.link == s {
			rel := &Elf64_Rela((sr.data + sr.sh_offset))
			rel_end := &Elf64_Rela((sr.data + sr.data_offset))
			for ; rel < rel_end; rel++ {
				n := ((rel.r_info) >> 32) - first_sym
				rel.r_info = (((Elf64_Xword((tr[n]))) << 32) + ((rel.r_info) & 4294967295))
			}
		}
	}
	tcc_free(tr)
}

fn set_elf_sym(s &Section, value Elf64_Addr, size u32, info int, other int, shndx int, name &i8) int {
	esym := &Elf64_Sym(0)
	sym_bind := 0
	sym_index := 0
	sym_type := 0
	esym_bind := 0

	sym_vis := u8(0)
	esym_vis := u8(0)
	new_vis := u8(0)

	sym_bind = ((u8(info)) >> 4)
	sym_type = (info & 15)
	sym_vis = (other & 3)
	if sym_bind != 0 {
		sym_index = find_elf_sym(s, name)
		if !sym_index {
			goto do_def // id: 0x7fffe5e77208
		}
		esym = &(&Elf64_Sym(s.data))[sym_index]
		if esym.st_value == value && esym.st_size == size && esym.st_info == info
			&& esym.st_other == other && esym.st_shndx == shndx {
			return sym_index
		}
		if esym.st_shndx != 0 {
			esym_bind = ((u8((esym.st_info))) >> 4)
			esym_vis = ((esym.st_other) & 3)
			if esym_vis == 0 {
				new_vis = sym_vis
			} else if sym_vis == 0 {
				new_vis = esym_vis
			} else {
				new_vis = if (esym_vis < sym_vis) { esym_vis } else { sym_vis }
			}
			esym.st_other = (esym.st_other & ~((-1) & 3)) | new_vis
			other = esym.st_other
			if shndx == 0 {
			} else if sym_bind == 1 && esym_bind == 2 {
				goto do_patch // id: 0x7fffe5e78790
			} else if sym_bind == 2 && esym_bind == 1 {
			} else if sym_bind == 2 && esym_bind == 2 {
			} else if sym_vis == 2 || sym_vis == 1 {
			} else if (esym.st_shndx == 65522 || esym.st_shndx == bss_section.sh_num)
				&& (shndx < 65280 && shndx != bss_section.sh_num) {
				goto do_patch // id: 0x7fffe5e78790
			} else if shndx == 65522 || shndx == bss_section.sh_num {
			} else if s.sh_flags & 1073741824 {
			} else if esym.st_other & 4 {
				goto do_patch // id: 0x7fffe5e78790
			} else {
				tcc_error_noabort(c"'%s' defined twice", name)
			}
		} else {
			// RRRREG do_patch id=0x7fffe5e78790
			do_patch:
			esym.st_info = ((sym_bind << 4) + (sym_type & 15))
			esym.st_shndx = shndx
			new_undef_sym = 1
			esym.st_value = value
			esym.st_size = size
			esym.st_other = other
		}
	} else {
		// RRRREG do_def id=0x7fffe5e77208
		do_def:
		sym_index = put_elf_sym(s, value, size, ((sym_bind << 4) + (sym_type & 15)), other,
			shndx, name)
	}
	return sym_index
}

struct Dyn_inf {
	dynamic     &Section
	dynstr      &Section
	data_offset u32
	rel_addr    Elf64_Addr
	rel_size    Elf64_Addr
}

struct SectionMergeInfo {
	s           &Section
	offset      u32
	new_section u8
	link_once   u8
}

fn tcc_object_type(fd int, h &Elf64_Ehdr) int {
	size := full_read(fd, h, sizeof(*h))
	if size == sizeof(*h) && 0 == C.memcmp(h, c'\177ELF', 4) {
		if h.e_type == 1 {
			return 1
		}
		if h.e_type == 3 {
			return 2
		}
	} else if size >= 8 {
		if 0 == C.memcmp(h, c'!<arch>\n', 8) {
			return 3
		}
	}
	return 0
}

fn tcc_load_object_file(s1 &TCCState, fd int, file_offset u32) int {
	ehdr := Elf64_Ehdr{}
	shdr := &Elf64_Shdr(0)
	sh := &Elf64_Shdr(0)

	size := 0
	i := 0
	j := 0
	offset := 0
	offseti := 0
	nb_syms := 0
	sym_index := 0
	ret := 0
	seencompressed := 0

	strsec := &i8(0)
	strtab := &i8(0)

	old_to_new_syms := &int(0)
	sh_name := &i8(0)
	name := &i8(0)

	sm_table := &SectionMergeInfo(0)
	sm := &SectionMergeInfo(0)

	sym := &Elf64_Sym(0)
	symtab := &Elf64_Sym(0)

	rel := &Elf64_Rela(0)
	s := &Section(0)
	stab_index := 0
	stabstr_index := 0
	stab_index = 0
	stabstr_index = stab_index
	C.lseek(fd, file_offset, 0)
	if tcc_object_type(fd, &ehdr) != 1 {
		goto fail1 // id: 0x7fffe5ecafb8
	}
	if ehdr.e_ident[5] != 1 || ehdr.e_machine != 62 {
		// RRRREG fail1 id=0x7fffe5ecafb8
		fail1:
		tcc_error_noabort(c'invalid object file')
		return -1
	}
	shdr = load_data(fd, file_offset + ehdr.e_shoff, sizeof(Elf64_Shdr) * ehdr.e_shnum)
	sm_table = tcc_mallocz(sizeof(SectionMergeInfo) * ehdr.e_shnum)
	sh = &shdr[ehdr.e_shstrndx]
	strsec = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
	old_to_new_syms = (unsafe { nil })
	symtab = (unsafe { nil })
	strtab = (unsafe { nil })
	nb_syms = 0
	seencompressed = 0
	for i = 1; i < ehdr.e_shnum; i++ {
		sh = &shdr[i]
		if sh.sh_type == 2 {
			if symtab {
				tcc_error_noabort(c'object must contain only one symtab')
				// RRRREG fail id=0x7fffe5ecc348
				fail:
				ret = -1
				goto _GOTO_PLACEHOLDER_0x7fffe5ecc3b8 // id: 0x7fffe5ecc3b8
			}
			nb_syms = sh.sh_size / sizeof(Elf64_Sym)
			symtab = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
			sm_table[i].s = symtab_section
			sh = &shdr[sh.sh_link]
			strtab = load_data(fd, file_offset + sh.sh_offset, sh.sh_size)
		}
		if sh.sh_flags & (1 << 11) {
			seencompressed = 1
		}
	}
	for i = 1; i < ehdr.e_shnum; i++ {
		if i == ehdr.e_shstrndx {
			continue
		}
		sh = &shdr[i]
		if sh.sh_type == 4 {
			sh = &shdr[sh.sh_info]
		}
		if sh.sh_type != 1 && sh.sh_type != 8 && sh.sh_type != 16 && sh.sh_type != 14
			&& sh.sh_type != 15 && C.strcmp(strsec + sh.sh_name, c'.stabstr') {
			continue
		}
		if seencompressed && !C.strncmp(strsec + sh.sh_name, c'.debug_', sizeof(c'.debug_') - 1) {
			continue
		}
		sh = &shdr[i]
		sh_name = strsec + sh.sh_name
		if sh.sh_addralign < 1 {
			sh.sh_addralign = 1
		}
		for j = 1; j < s1.nb_sections; j++ {
			s = s1.sections[j]
			if !C.strcmp(s.name, sh_name) {
				if !C.strncmp(sh_name, c'.gnu.linkonce', sizeof(c'.gnu.linkonce') - 1) {
					sm_table[i].link_once = 1
					goto next // id: 0x7fffe5ece9b0
				} else {
					goto found // id: 0x7fffe5ecea38
				}
			}
		}
		s = new_section(s1, sh_name, sh.sh_type, sh.sh_flags & ~(1 << 9))
		s.sh_addralign = sh.sh_addralign
		s.sh_entsize = sh.sh_entsize
		sm_table[i].new_section = 1
		// RRRREG found id=0x7fffe5ecea38
		found:
		if sh.sh_type != s.sh_type {
			tcc_error_noabort(c'invalid section type')
			goto fail // id: 0x7fffe5ecc348
		}
		offset = s.data_offset
		if 0 == C.strcmp(sh_name, c'.stab') {
			stab_index = i
			goto no_align // id: 0x7fffe5ecfb68
		}
		if 0 == C.strcmp(sh_name, c'.stabstr') {
			stabstr_index = i
			goto no_align // id: 0x7fffe5ecfb68
		}
		size = sh.sh_addralign - 1
		offset = (offset + size) & ~size
		if sh.sh_addralign > s.sh_addralign {
			s.sh_addralign = sh.sh_addralign
		}
		s.data_offset = offset
		// RRRREG no_align id=0x7fffe5ecfb68
		no_align:
		sm_table[i].offset = offset
		sm_table[i].s = s
		size = sh.sh_size
		if sh.sh_type != 8 {
			ptr := &u8(0)
			C.lseek(fd, file_offset + sh.sh_offset, 0)
			ptr = section_ptr_add(s, size)
			full_read(fd, ptr, size)
		} else {
			s.data_offset += size
		}
		// RRRREG next id=0x7fffe5ece9b0
		next:
		0
	}
	if stab_index && stabstr_index {
		a := &Stab_Sym(0)
		b := &Stab_Sym(0)

		o := u32(0)
		s = sm_table[stab_index].s
		a = &Stab_Sym((s.data + sm_table[stab_index].offset))
		b = &Stab_Sym((s.data + s.data_offset))
		o = sm_table[stabstr_index].offset
		for a < b {
			if a.n_strx {
				a.n_strx += o
			}
			a++
		}
	}
	for i = 1; i < ehdr.e_shnum; i++ {
		s = sm_table[i].s
		if !s || !sm_table[i].new_section {
			continue
		}
		sh = &shdr[i]
		if sh.sh_link > 0 {
			s.link = sm_table[sh.sh_link].s
		}
		if sh.sh_type == 4 {
			s.sh_info = sm_table[sh.sh_info].s.sh_num
			s1.sections[s.sh_info].reloc = s
		}
	}
	sm = sm_table
	old_to_new_syms = tcc_mallocz(nb_syms * sizeof(int))
	sym = symtab + 1
	for i = 1; i < nb_syms; i++, sym++ {
		if sym.st_shndx != 0 && sym.st_shndx < 65280 {
			sm = &sm_table[sym.st_shndx]
			if sm.link_once {
				if ((u8((sym.st_info))) >> 4) != 0 {
					name = strtab + sym.st_name
					sym_index = find_elf_sym(symtab_section, name)
					if sym_index {
						old_to_new_syms[i] = sym_index
					}
				}
				continue
			}
			if !sm.s {
				continue
			}
			sym.st_shndx = sm.s.sh_num
			sym.st_value += sm.offset
		}
		name = strtab + sym.st_name
		sym_index = set_elf_sym(symtab_section, sym.st_value, sym.st_size, sym.st_info,
			sym.st_other, sym.st_shndx, name)
		old_to_new_syms[i] = sym_index
	}
	for i = 1; i < ehdr.e_shnum; i++ {
		s = sm_table[i].s
		if !s {
			continue
		}
		sh = &shdr[i]
		offset = sm_table[i].offset
		match s.sh_type {
			4 { // case comp body kind=BinaryOperator is_enum=false
				offseti = sm_table[sh.sh_info].offset
				for rel = &Elf64_Rela(s.data) + (offset / sizeof(*rel)); rel < &Elf64_Rela((
					s.data + s.data_offset)); rel++ {
					type_ := 0
					sym_index = u32(0)
					type_ = ((rel.r_info) & 4294967295)
					sym_index = ((rel.r_info) >> 32)
					if sym_index >= nb_syms {
						goto invalid_reloc // id: 0x7fffe5ed5080
					}
					sym_index = old_to_new_syms[sym_index]
					if !sym_index && !sm.link_once {
						// RRRREG invalid_reloc id=0x7fffe5ed5080
						invalid_reloc:
						tcc_error_noabort(c"Invalid relocation entry [%2d] '%s' @ %.8x",
							i, strsec + sh.sh_name, rel.r_offset)
						goto fail // id: 0x7fffe5ecc348
					}
					rel.r_info = (((Elf64_Xword(sym_index)) << 32) + type_)
					rel.r_offset += offseti
				}
			}
			else {}
		}
	}
	ret = 0
	// RRRREG the_end id=0x7fffe5ecc3b8
	the_end:
	tcc_free(symtab)
	tcc_free(strtab)
	tcc_free(old_to_new_syms)
	tcc_free(sm_table)
	tcc_free(strsec)
	tcc_free(shdr)
	return ret
}

struct ArchiveHeader {
	ar_name [16]i8
	ar_date [12]i8
	ar_uid  [6]i8
	ar_gid  [6]i8
	ar_mode [8]i8
	ar_size [10]i8
	ar_fmag [2]i8
}

fn tcc_load_archive(s1 &TCCState, fd int, alacarte int) int {
	hdr := ArchiveHeader{}
	ar_size := [11]i8{}
	ar_name := [17]i8{}
	magic := [8]i8{}
	size := 0
	len := 0
	i := 0

	file_offset := u32(0)
	full_read(fd, magic, sizeof(magic))
	for ; true; {
		len = full_read(fd, &hdr, sizeof(hdr))
		if len == 0 {
			break
		}
		if len != sizeof(hdr) {
			tcc_error_noabort(c'invalid archive')
			return -1
		}
		C.memcpy(ar_size, hdr.ar_size, sizeof(hdr.ar_size))
		ar_size[sizeof(hdr.ar_size)] = `\x00`
		size = strtol(ar_size, (unsafe { nil }), 0)
		C.memcpy(ar_name, hdr.ar_name, sizeof(hdr.ar_name))
		for i = sizeof(hdr.ar_name) - 1; i >= 0; i-- {
			if ar_name[i] != ` ` {
				break
			}
		}
		ar_name[i + 1] = `\x00`
		file_offset = C.lseek(fd, 0, 1)
		size = (size + 1) & ~1
		if !C.strcmp(ar_name, c'/') {
			if alacarte {
				return tcc_load_alacarte(s1, fd, size, 4)
			}
		} else if !C.strcmp(ar_name, c'/SYM64/') {
			if alacarte {
				return tcc_load_alacarte(s1, fd, size, 8)
			}
		} else {
			ehdr := Elf64_Ehdr{}
			if tcc_object_type(fd, &ehdr) == 1 {
				if tcc_load_object_file(s1, fd, file_offset) < 0 {
					return -1
				}
			}
		}
		C.lseek(fd, file_offset + size, 0)
	}
	return 0
}

fn tcc_load_dll(s1 &TCCState, fd int, filename &i8, level int) int {
	ehdr := Elf64_Ehdr{}
	shdr := &Elf64_Shdr(0)
	sh := &Elf64_Shdr(0)
	sh1 := &Elf64_Shdr(0)

	i := 0
	j := 0
	nb_syms := 0
	nb_dts := 0
	sym_bind := 0
	ret := 0

	sym := &Elf64_Sym(0)
	dynsym := &Elf64_Sym(0)

	dt := &Elf64_Dyn(0)
	dynamic := &Elf64_Dyn(0)

	dynstr := &u8(0)
	name := &i8(0)
	soname := &i8(0)

	dllref := &DLLReference(0)
	full_read(fd, &ehdr, sizeof(ehdr))
	if ehdr.e_ident[5] != 1 || ehdr.e_machine != 62 {
		tcc_error_noabort(c'bad architecture')
		return -1
	}
	shdr = load_data(fd, ehdr.e_shoff, sizeof(Elf64_Shdr) * ehdr.e_shnum)
	nb_syms = 0
	nb_dts = 0
	dynamic = (unsafe { nil })
	dynsym = (unsafe { nil })
	dynstr = (unsafe { nil })
	shdr = 0
	sh = 0
	for i = 0; i < ehdr.e_shnum; i++, sh++ {
		match sh.sh_type {
			6 { // case comp body kind=BinaryOperator is_enum=true
				nb_dts = sh.sh_size / sizeof(Elf64_Dyn)
				dynamic = load_data(fd, sh.sh_offset, sh.sh_size)
			}
			11 { // case comp body kind=BinaryOperator is_enum=true
				nb_syms = sh.sh_size / sizeof(Elf64_Sym)
				dynsym = load_data(fd, sh.sh_offset, sh.sh_size)
				sh1 = &shdr[sh.sh_link]
				dynstr = load_data(fd, sh1.sh_offset, sh1.sh_size)
			}
			else {}
		}
	}
	soname = tcc_basename(filename)
	dynamic = 0
	dt = 0
	for i = 0; i < nb_dts; i++, dt++ {
		if dt.d_tag == 14 {
			soname = &i8(dynstr) + dt.d_un.d_val
		}
	}
	for i = 0; i < s1.nb_loaded_dlls; i++ {
		dllref = s1.loaded_dlls[i]
		if !C.strcmp(soname, dllref.name) {
			if level < dllref.level {
				dllref.level = level
			}
			ret = 0
			goto the_end // id: 0x7fffe5ee66e0
		}
	}
	dllref = tcc_mallocz(sizeof(DLLReference) + C.strlen(soname))
	dllref.level = level
	strcpy(dllref.name, soname)
	dynarray_add(&s1.loaded_dlls, &s1.nb_loaded_dlls, dllref)

	sym = dynsym + 1
	for i = 1; i < nb_syms; i++, sym++ {
		sym_bind = ((u8((sym.st_info))) >> 4)
		if sym_bind == 0 {
			continue
		}
		name = &i8(dynstr) + sym.st_name
		set_elf_sym(s1.dynsymtab_section, sym.st_value, sym.st_size, sym.st_info, sym.st_other,
			sym.st_shndx, name)
	}
	dt = dynamic
	for i = 0; i < nb_dts; i++, dt++ {
		match dt.d_tag {
			1 { // case comp body kind=BinaryOperator is_enum=true
				name = &i8(dynstr) + dt.d_un.d_val
				for j = 0; j < s1.nb_loaded_dlls; j++ {
					dllref = s1.loaded_dlls[j]
					if !C.strcmp(name, dllref.name) {
						goto already_loaded // id: 0x7fffe5ee8148
					}
				}
				if tcc_add_dll(s1, name, 32) < 0 {
					tcc_error_noabort(c"referenced dll '%s' not found", name)
					ret = -1
					goto the_end // id: 0x7fffe5ee66e0
				}
				// RRRREG already_loaded id=0x7fffe5ee8148
				already_loaded:
			}
			else {}
		}
	}
	ret = 0
	// RRRREG the_end id=0x7fffe5ee66e0
	the_end:
	tcc_free(dynstr)
	tcc_free(dynsym)
	tcc_free(dynamic)
	tcc_free(shdr)
	return ret
}

fn tcc_load_ldscript(s1 &TCCState) int {
	cmd := [64]i8{}
	filename := [1024]i8{}
	t := 0
	ret := 0

	ch = handle_eob()
	for ; true; {
		t = ld_next(s1, cmd, sizeof(cmd))
		if t == (-1) {
			return 0
		} else if t != 256 {
			return -1
		}
		if !C.strcmp(cmd, c'INPUT') || !C.strcmp(cmd, c'GROUP') {
			ret = ld_add_file_list(s1, cmd, 0)
			if ret {
				return ret
			}
		} else if !C.strcmp(cmd, c'OUTPUT_FORMAT') || !C.strcmp(cmd, c'TARGET') {
			t = ld_next(s1, cmd, sizeof(cmd))
			if t != `(` {
				expect(c'(')
			}
			for ; true; {
				t = ld_next(s1, filename, sizeof(filename))
				if t == (-1) {
					tcc_error_noabort(c'unexpected end of file')
					return -1
				} else if t == `)` {
					break
				}
			}
		} else {
			return -1
		}
	}
	return 0
}

type Sig_t = Sighandler_t

fn tcc_run_free(s1 &TCCState) {
	i := 0
	for i = 0; i < s1.nb_runtime_mem; i++ {
		tcc_free(s1.runtime_mem[i])
	}
	tcc_free(s1.runtime_mem)
}

type prog_main_fn = fn (int, &&i8) int

type bound_new_region_fn = fn (voidptr, Elf64_Addr)

type tbound_delete_region_fn = fn (voidptr) int

fn tcc_run(s1 &TCCState, argc int, argv &&u8) int {
	prog_main := prog_main_fn{}
	s1.runtime_main = if s1.nostdlib { c'_start' } else { c'main' }
	if s1.dflag & 16 && !find_elf_sym(s1.symtab, s1.runtime_main) {
		return 0
	}
	if tcc_relocate(s1, voidptr(1)) < 0 {
		return -1
	}
	prog_main = tcc_get_symbol_err(s1, s1.runtime_main)
	if s1.do_debug {
		set_exception_handler()
		rt_prog_main = prog_main
	}
	(*__errno_location()) = 0
	if s1.do_bounds_check {
		bound_init := fn () {}
		bound_exit := fn () {}
		bound_new_region := bound_new_region_fn{}
		bound_delete_region := bound_delete_region{}
		i := 0
		ret := 0

		rt_bound_error_msg = tcc_get_symbol_err(s1, c'__bound_error_msg')
		bound_init = tcc_get_symbol_err(s1, c'__bound_init')
		bound_exit = tcc_get_symbol_err(s1, c'__bound_exit')
		bound_new_region = tcc_get_symbol_err(s1, c'__bound_new_region')
		bound_delete_region = tcc_get_symbol_err(s1, c'__bound_delete_region')
		bound_init()
		bound_new_region(argv, argc * sizeof(argv[0]))
		for i = 0; i < argc; i++ {
			bound_new_region(argv[i], C.strlen(argv[i]) + 1)
		}
		ret = prog_main(argc, argv)
		for i = 0; i < argc; i++ {
			bound_delete_region(argv[i])
		}
		bound_delete_region(argv)
		bound_exit()
		return ret
	}
	return prog_main(argc, argv)
}

fn tcc_set_num_callers(n int) {
	rt_num_callers = n
}

@[export: 'reg_classes']
const reg_classes = [1 | 4, 1 | 8, 1 | 16, 0, 0, 0, 0, 0, 256, 512, 1024, 2048, 0, 0, 0, 0, 2 | 4096,
	2 | 8192, 2 | 16384, 2 | 32768, 2 | 65536, 2 | 131072, 262144, 524288, 128]!

fn g(c int) {
	ind1 := 0
	if nocode_wanted {
		return
	}
	ind1 = ind + 1
	if ind1 > cur_text_section.data_allocated {
		section_realloc(cur_text_section, ind1)
	}
	cur_text_section.data[ind] = c
	ind = ind1
}

fn o(c u32) {
	for c {
		g(c)
		c = c >> 8
	}
}

fn oad(c int, s int) int {
	t := 0
	if nocode_wanted {
		return s
	}
	o(c)
	t = ind
	gen_le32(s)
	return t
}

fn load(r int, sv &SValue) {
	v := 0
	t := 0
	ft := 0
	fc := 0
	fr := 0

	v1 := SValue{}
	fr = sv.r
	ft = sv.type_.t & ~32
	fc = sv.c.i
	if fc != sv.c.i && fr & 512 {
		tcc_error(c'64 bit addend in load')
	}
	ft &= ~(512 | 256)
	if (fr & 63) == 48 && fr & 512 && fr & 256 && !(sv.sym.type_.t & 8192) {
		tr := r | treg_mem
		if is_float(ft) {
			tr = get_reg(1) | treg_mem
		}
		gen_modrm64(139, tr, fr, sv.sym, 0)
		fr = tr | 256
	}
	v = fr & 63
	if fr & 256 {
		b := 0
		ll := 0

		if v == 49 {
			v1.type_.t = 5
			v1.r = 50 | 256
			v1.c.i = fc
			fr = r
			if !(reg_classes[fr] & (1 | 2048)) {
				fr = get_reg(1)
			}
			load(fr, &v1)
		}
		if fc != sv.c.i {
			v1.type_.t = 4
			v1.r = 48
			v1.c.i = sv.c.i
			fr = r
			if !(reg_classes[fr] & (1 | 2048)) {
				fr = get_reg(1)
			}
			load(fr, &v1)
			fc = 0
		}
		ll = 0
		if (ft & 15) == 7 {
			align := 0
			match type_size(&sv.type_, &align) {
				1 { // case comp body kind=BinaryOperator is_enum=true
					ft = 1
				}
				2 { // case comp body kind=BinaryOperator is_enum=true
					ft = 2
				}
				4 { // case comp body kind=BinaryOperator is_enum=true
					ft = 3
				}
				8 { // case comp body kind=BinaryOperator is_enum=true
					ft = 4
				}
				else {
					tcc_error(c'invalid aggregate type for register load')
				}
			}
		}
		if (ft & 15) == 8 {
			b = 7212902
			r = (r & 7)
		} else if (ft & 15) == 9 {
			b = 8261619
			r = (r & 7)
		} else if (ft & 15) == 10 {
			b = 219, 5
			r = 5
		} else if
			(ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))) == 1
			|| (ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))) == 11 {
			b = 48655
		} else if (ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))) == (1 | 16) {
			b = 46607
		} else if (ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))) == 2 {
			b = 48911
		} else if (ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))) == (2 | 16) {
			b = 46863
		} else {
			//(void(sizeof(if (((ft & 15) == 3) || ((ft & 15) == 4) || ((ft & 15) == 5) || ((ft & 15) == 6)){ 1 } else {0})) , )
			ll = is64_type(ft)
			b = 139
		}
		if ll {
			gen_modrm64(b, r, fr, sv.sym, fc)
		} else {
			orex(ll, fr, r, b)
			gen_modrm(r, fr, sv.sym, fc)
		}
	} else {
		if v == 48 {
			if fr & 512 {
				if sv.sym.type_.t & 8192 {
					orex(1, 0, r, 141)
					o(5 + (r & 7) * 8)
					gen_addrpc32(fr, sv.sym, fc)
				} else {
					orex(1, 0, r, 139)
					o(5 + (r & 7) * 8)
					gen_gotpcrel(r, sv.sym, fc)
				}
			} else if is64_type(ft) {
				orex(1, r, 0, 184 + (r & 7))
				gen_le64(sv.c.i)
			} else {
				orex(0, r, 0, 184 + (r & 7))
				gen_le32(fc)
			}
		} else if v == 50 {
			orex(1, 0, r, 141)
			gen_modrm(r, 50, sv.sym, fc)
		} else if v == 51 {
			if fc & 256 {
				v = vtop.cmp_r
				fc &= ~256
				orex(0, r, 0, 176 + (r & 7))
				g(v ^ fc ^ (v == 149))
				o(890 + (((r >> 3) & 1) << 8))
			}
			orex(0, r, 0, 15)
			o(fc)
			o(192 + (r & 7))
			orex(0, r, 0, 15)
			o(49334 + (r & 7) * 2304)
		} else if v == 52 || v == 53 {
			t = v & 1
			orex(0, r, 0, 0)
			oad(184 + (r & 7), t)
			o(1515 + (((r >> 3) & 1) << 8))
			gsym(fc)
			orex(0, r, 0, 0)
			oad(184 + (r & 7), t ^ 1)
		} else if v != r {
			if r >= treg_xmm0 && r <= treg_xmm7 {
				if v == treg_st0 {
					o(4028914909)
					o(1052658)
					o(68 + (r & 7) * 8)
					o(61476)
				} else {
					//(void(sizeof(if ((v >= treg_xmm0) && (v <= treg_xmm7)){ 1 } else {0})) , )
					if (ft & 15) == 8 {
						o(1052659)
					} else {
						//(void(sizeof(if ((ft & 15) == 9){ 1 } else {0})) , )
						o(1052658)
					}
					o(192 + (v & 7) + (r & 7) * 8)
				}
			} else if r == treg_st0 {
				//(void(sizeof(if ((v >= treg_xmm0) && (v <= treg_xmm7)){ 1 } else {0})) , )
				o(1118194)
				o(68 + (r & 7) * 8)
				o(61476)
				o(4028908765)
			} else {
				orex(1, r, v, 137)
				o(192 + (r & 7) + (v & 7) * 8)
			}
		}
	}
}

fn store(r int, v &SValue) {
	fr := 0
	bt := 0
	ft := 0
	fc := 0

	op64 := 0
	pic := 0
	fr = v.r & 63
	ft = v.type_.t
	fc = v.c.i
	if fc != v.c.i && fr & 512 {
		tcc_error(c'64 bit addend in store')
	}
	ft &= ~(512 | 256)
	bt = ft & 15
	if fr == 48 && v.r & 512 {
		o(1936204)
		gen_gotpcrel(treg_r11, v.sym, v.c.i)
		pic = if is64_type(bt) { 73 } else { 65 }
	}
	if bt == 8 {
		o(102)
		o(pic)
		o(32271)
		r = (r & 7)
	} else if bt == 9 {
		o(102)
		o(pic)
		o(54799)
		r = (r & 7)
	} else if bt == 10 {
		o(49369)
		o(pic)
		o(219)
		r = 7
	} else {
		if bt == 2 {
			o(102)
		}
		o(pic)
		if bt == 1 || bt == 11 {
			orex(0, 0, r, 136)
		} else if is64_type(bt) {
			op64 = 137
		} else { // 3
			orex(0, 0, r, 137)
		}
	}
	if pic {
		if op64 {
			o(op64)
		}
		o(3 + (r << 3))
	} else if op64 {
		if fr == 48 || fr == 50 || v.r & 256 {
			gen_modrm64(op64, r, v.r, v.sym, fc)
		} else if fr != r {
			abort()
			o(192 + fr + r * 8)
		}
	} else {
		if fr == 48 || fr == 50 || v.r & 256 {
			gen_modrm(r, v.r, v.sym, fc)
		} else if fr != r {
			abort()
			o(192 + fr + r * 8)
		}
	}
}

enum X86_64_Mode {
	x86_64_mode_none
	x86_64_mode_memory
	x86_64_mode_integer
	x86_64_mode_sse
	x86_64_mode_x87
}

@[export: 'arg_regs']
const arg_regs = [treg_rdi, treg_rsi, treg_rdx, treg_rcx, treg_r8, treg_r9]!

fn gjmp(t int) int {
	return oad(233, t)
}

// empty enum
const opt_reg8 = 0
const opt_reg16 = 1
const opt_reg32 = 2
const opt_reg64 = 3
const opt_mmx = 4
const opt_sse = 5
const opt_cr = 6
const opt_tr = 7
const opt_db = 8
const opt_seg = 9
const opt_st = 10
const opt_reg8_low = 11
const opt_im8 = 12
const opt_im8s = 13
const opt_im16 = 14
const opt_im32 = 15
const opt_im64 = 16
const opt_eax = 17
const opt_st0 = 18
const opt_cl = 19
const opt_dx = 20
const opt_addr = 21
const opt_indir = 22
const opt_composite_first = 23
const opt_im = 24
const opt_reg = 25
const opt_regw = 26
const opt_imw = 27
const opt_mmxsse = 28
const opt_disp = 29
const opt_disp8 = 30
const opt_ea = 128

@[export: 'reg_to_size']
const reg_to_size = [0, 0, 1, 0, 2, 0, 0, 0, 3]!

@[export: 'test_bits']
const test_bits = [0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 10, 11, 11, 12, 12,
	13, 13, 14, 14, 15, 15]!

@[export: 'segment_prefixes']
const segment_prefixes = [38, 46, 54, 62, 100, 101]!

@[export: 'op0_codes']
const op0_codes = [248, 252, 250, 3846, 245, 159, 158, 156, 157, 156, 157, 249, 253, 251, 55, 63,
	39, 47, 54538, 54282, 26264, 26265, 152, 153, 26264, 152, 26265, 153, 18585, 204, 206, 207,
	4010, 244, 155, 144, 62352, 215, 240, 243, 243, 243, 242, 242, 3848, 3849, 4002, 3888, 3889,
	3890, 3891, 3845, 3847, 3851, 201, 195, 195, 203, 56041, 55780, 55781, 55784, 55785, 55786,
	55787, 55788, 55789, 55790, 55792, 55793, 55794, 55795, 55796, 55797, 55798, 55799, 55800,
	55801, 55802, 55803, 55804, 55805, 55806, 55807, 55776, 55777, 56291, 56290, 55760, 155, 55753,
	57312, 3959]!

fn tcc_assemble(s1 &TCCState, do_preprocess int) int {
	ret := 0
	tcc_debug_start(s1)
	cur_text_section = text_section
	ind = cur_text_section.data_offset
	nocode_wanted = 0
	ret = tcc_assemble_internal(s1, do_preprocess, 1)
	cur_text_section.data_offset = ind
	tcc_debug_end(s1)
	return ret
}

fn asm_instr() {
	astr := CString{}
	astr1 := CString{}

	operands := [30]ASMOperand{}
	nb_outputs := 0
	nb_operands := 0
	i := 0
	must_subst := 0
	out_reg := 0

	clobber_regs := [16]u8{}
	sec := &Section(0)
	if tok == Tcc_token.tok_volatile1 || tok == Tcc_token.tok_volatile2
		|| tok == Tcc_token.tok_volatile3 {
		next()
	}
	parse_asm_str(&astr)
	nb_operands = 0
	nb_outputs = 0
	must_subst = 0
	C.memset(clobber_regs, 0, sizeof(clobber_regs))
	if tok == `:` {
		next()
		must_subst = 1
		parse_asm_operands(operands, &nb_operands, 1)
		nb_outputs = nb_operands
		if tok == `:` {
			next()
			if tok != `)` {
				parse_asm_operands(operands, &nb_operands, 0)
				if tok == `:` {
					next()
					for ; true; {
						if tok != 185 {
							expect(c'string constant')
						}
						asm_clobber(clobber_regs, tokc.str.data)
						next()
						if tok == `,` {
							next()
						} else {
							break
						}
					}
				}
			}
		}
	}
	skip(`)`)
	if tok != `;` {
		expect(c"';'")
	}
	save_regs(0)
	asm_compute_constraints(operands, nb_operands, nb_outputs, clobber_regs, &out_reg)
	if must_subst {
		subst_asm_operands(operands, nb_operands, &astr1, &astr)
		cstr_free(&astr)
	} else {
		astr1 = astr
	}
	asm_gen_code(operands, nb_operands, nb_outputs, 0, clobber_regs, out_reg)
	sec = cur_text_section
	tcc_assemble_inline(tcc_state, astr1.data, astr1.size - 1, 0)
	if sec != cur_text_section {
		tcc_warning(c'inline asm tries to change current section')
		use_section1(tcc_state, sec)
	}
	next()
	asm_gen_code(operands, nb_operands, nb_outputs, 1, clobber_regs, out_reg)
	for i = 0; i < nb_operands; i++ {
		op := &ASMOperand(0)
		op = &operands[i]
		tcc_free(op.constraint)
		vpop()
	}
	cstr_free(&astr1)
}

fn asm_global_instr() {
	astr := CString{}
	saved_nocode_wanted := nocode_wanted
	nocode_wanted = 0
	next()
	parse_asm_str(&astr)
	skip(`)`)
	if tok != `;` {
		expect(c"';'")
	}
	cur_text_section = text_section
	ind = cur_text_section.data_offset
	tcc_assemble_inline(tcc_state, astr.data, astr.size - 1, 1)
	cur_text_section.data_offset = ind
	next()
	cstr_free(&astr)
	nocode_wanted = saved_nocode_wanted
}

fn pstrcpy(buf &i8, buf_size int, s &i8) &i8 {
	q := &i8(0)
	q_end := &i8(0)

	c := 0
	if buf_size > 0 {
		q = buf
		q_end = buf + buf_size - 1
		for q < q_end {
			c = *s++
			if c == `\x00` {
				break
			}
			*q++ = c
		}
		*q = `\x00`
	}
	return buf
}

fn pstrcat(buf &i8, buf_size int, s &i8) &i8 {
	len := 0
	len = C.strlen(buf)
	if len < buf_size {
		pstrcpy(buf + len, buf_size - len, s)
	}
	return buf
}

fn pstrncpy(out &i8, in_ &i8, num usize) &i8 {
	C.memcpy(out, in_, num)
	out[num] = `\x00`
	return out
}

fn tcc_basename(name &i8) &i8 {
	p := C.strchr(name, 0)
	for p > name && !(p[-1] == `/`) {
		p--$
	}
	return p
}

fn tcc_fileextension(name &i8) &i8 {
	b := tcc_basename(name)
	e := C.strrchr(b, `.`)
	return if e { e } else { C.strchr(b, 0) }
}

fn tcc_free(ptr voidptr) {
	C.free(ptr)
}

fn tcc_malloc(size u32) voidptr {
	ptr := &voidptr(0)
	ptr = C.malloc(size)
	if !ptr && size {
		tcc_error(c'memory full (malloc)')
	}
	return ptr
}

fn tcc_mallocz(size u32) voidptr {
	ptr := &voidptr(0)
	ptr = tcc_malloc(size)
	C.memset(ptr, 0, size)
	return ptr
}

fn tcc_realloc(ptr voidptr, size u32) voidptr {
	ptr1 := &voidptr(0)
	ptr1 = realloc(ptr, size)
	if !ptr1 && size {
		tcc_error(c'memory full (realloc)')
	}
	return ptr1
}

fn tcc_strdup(str &i8) &i8 {
	ptr := &i8(0)
	ptr = tcc_malloc(C.strlen(str) + 1)
	strcpy(ptr, str)
	return ptr
}

fn tcc_memcheck() {
}

fn dynarray_add(ptab voidptr, nb_ptr &int, data voidptr) {
	nb := 0
	nb_alloc := 0

	pp := &voidptr(0)
	nb = *nb_ptr
	pp = *&&&voidptr(ptab)
	if (nb & (nb - 1)) == 0 {
		if !nb {
			nb_alloc = 1
		} else { // 3
			nb_alloc = nb * 2
		}
		pp = tcc_realloc(pp, nb_alloc * sizeof(voidptr))
		*&&&voidptr(ptab) = pp
	}
	pp[nb++] = data
	*nb_ptr = nb
}

fn dynarray_reset(pp voidptr, n &int) {
	p := &voidptr(0)
	for p = *&&&voidptr(pp); *n; p++, *n-- {
		if *p {
			tcc_free(*p)
		}
	}
	tcc_free(*&voidptr(pp))
	*&voidptr(pp) = (unsafe { nil })
}

fn tcc_split_path(s &TCCState, p_ary voidptr, p_nb_ary &int, in_ &i8) {
	p := &i8(0)
	for {
		c := 0
		str := CString{}
		cstr_new(&str)

		p = in_
		for c = *p; c != `\x00` && c != c':'[0]; p++ {
			if c == `{` && p[1] && p[2] == `}` {
				c = p[1]
				p += 2
				if c == `B` {
					cstr_cat(&str, s.tcc_lib_path, -1)
				}
			} else {
				cstr_ccat(&str, c)
			}
		}
		if str.size {
			cstr_ccat(&str, `\x00`)
			dynarray_add(p_ary, p_nb_ary, tcc_strdup(str.data))
		}
		cstr_free(&str)
		in_ = p + 1
		// while()
		if !(*p) {
			break
		}
	}
}

fn strcat_vprintf(buf &i8, buf_size int, fmt &i8, ap va_list) {
	len := 0
	len = C.strlen(buf)
	C.vsnprintf(buf + len, buf_size - len, fmt, ap)
}

@[c2v_variadic]
fn strcat_printf(buf &i8, buf_size int, fmt ...&i8) {
	ap := Va_list{}
	__builtin_va_start(ap, fmt)
	strcat_vprintf(buf, buf_size, fmt, ap)
	__builtin_va_end(ap)
}

fn error1(s1 &TCCState, is_warning int, fmt &i8, ap va_list) {
	buf := [2048]i8{}
	pf := &&BufferedFile(0)
	f := &BufferedFile(0)

	buf[0] = `\x00`
	for f = file; f && f.filename[0] == `:`; f = f.prev {
		0
	}
	if f {
		for pf = s1.include_stack; pf < s1.include_stack_ptr; pf++ {
			strcat_printf(buf, sizeof(buf), c'In file included from %s:%d:\n', (*pf).filename,
				(*pf).line_num)
		}
		if s1.error_set_jmp_enabled {
			strcat_printf(buf, sizeof(buf), c'%s:%d: ', f.filename, f.line_num - !!(tok_flags & 1))
		} else {
			strcat_printf(buf, sizeof(buf), c'%s: ', f.filename)
		}
	} else {
		strcat_printf(buf, sizeof(buf), c'tcc: ')
	}
	if is_warning {
		strcat_printf(buf, sizeof(buf), c'warning: ')
	} else { // 3
		strcat_printf(buf, sizeof(buf), c'error: ')
	}
	strcat_vprintf(buf, sizeof(buf), fmt, ap)
	if !s1.error_func {
		if s1.output_type == 5 && s1.ppfp == C.stdout {
			C.printf(c'\n'), C.fflush(C.stdout)
		}
		C.fflush(C.stdout)
		C.fprintf(C.stderr, c'%s\n', buf)
		C.fflush(C.stderr)
	} else {
		s1.error_func(s1.error_opaque, buf)
	}
	if !is_warning || s1.warn_error {
		s1.nb_errors++
	}
}

fn tcc_set_error_func(s &TCCState, error_opaque voidptr, error_func fn (voidptr, &i8)) {
	s.error_opaque = error_opaque
	s.error_func = error_func
}

@[c2v_variadic]
fn tcc_error_noabort(fmt ...&i8) {
	s1 := tcc_state
	ap := Va_list{}
	__builtin_va_start(ap, fmt)
	error1(s1, 0, fmt, ap)
	__builtin_va_end(ap)
}

@[c2v_variadic]
fn tcc_error(fmt ...&i8) {
	s1 := tcc_state
	ap := Va_list{}
	__builtin_va_start(ap, fmt)
	error1(s1, 0, fmt, ap)
	__builtin_va_end(ap)
	if s1.error_set_jmp_enabled {
		longjmp(s1.error_jmp_buf, 1)
	} else {
		C.exit(1)
	}
}

@[c2v_variadic]
fn tcc_warning(fmt ...&i8) {
	s1 := tcc_state
	ap := Va_list{}
	if s1.warn_none {
		return
	}
	__builtin_va_start(ap, fmt)
	error1(s1, 1, fmt, ap)
	__builtin_va_end(ap)
}

fn tcc_open_bf(s1 &TCCState, filename &i8, initlen int) {
	bf := &BufferedFile(0)
	buflen := if initlen { initlen } else { 8192 }
	bf = tcc_mallocz(sizeof(BufferedFile) + buflen)
	bf.buf_ptr = bf.buffer
	bf.buf_end = bf.buffer + initlen
	bf.buf_end[0] = `\\`
	pstrcpy(bf.filename, sizeof(bf.filename), filename)
	bf.truefilename = bf.filename
	bf.line_num = 1
	bf.ifdef_stack_ptr = s1.ifdef_stack_ptr
	bf.fd = -1
	bf.prev = file
	file = bf
	tok_flags = 1 | 2
}

fn tcc_close() {
	bf := file
	if bf.fd > 0 {
		C.close(bf.fd)
		total_lines += bf.line_num
	}
	if bf.truefilename != bf.filename {
		tcc_free(bf.truefilename)
	}
	file = bf.prev
	tcc_free(bf)
}

fn tcc_open(s1 &TCCState, filename &i8) int {
	fd := 0
	if C.strcmp(filename, c'-') == 0 {
		fd = 0, c'<stdin>'
		filename = 0
		fd = 0
	} else { // 3
		fd = C.open(filename, 0 | 0)
	}
	if (s1.verbose == 2 && fd >= 0) || s1.verbose == 3 {
		C.printf(c'%s %*s%s\n', if fd < 0 { c'nf' } else { c'->' }, int((s1.include_stack_ptr - s1.include_stack)),
			c'', filename)
	}
	if fd < 0 {
		return -1
	}
	tcc_open_bf(s1, filename, 0)
	file.fd = fd
	return fd
}

fn tcc_compile(s1 &TCCState, filetype int) int {
	define_start := &Sym(0)
	is_asm := 0
	define_start = define_stack
	is_asm = !!(filetype & (2 | 4))
	tccelf_begin_file(s1)
	if _setjmp(s1.error_jmp_buf) == 0 {
		s1.nb_errors = 0
		s1.error_set_jmp_enabled = 1
		preprocess_start(s1, is_asm)
		if s1.output_type == 5 {
			tcc_preprocess(s1)
		} else if is_asm {
			tcc_assemble(s1, !!(filetype & 4))
		} else {
			tccgen_compile(s1)
		}
	}
	s1.error_set_jmp_enabled = 0
	preprocess_end(s1)
	free_inline_functions(s1)
	free_defines(define_start)
	sym_pop(&global_stack, (unsafe { nil }), 0)
	sym_pop(&local_stack, (unsafe { nil }), 0)
	tccelf_end_file(s1)
	return if s1.nb_errors != 0 { -1 } else { 0 }
}

fn tcc_compile_string(s &TCCState, str &i8) int {
	len := 0
	ret := 0

	len = C.strlen(str)
	tcc_open_bf(s, c'<string>', len)
	C.memcpy(file.buffer, str, len)
	ret = tcc_compile(s, s.filetype)
	tcc_close()
	return ret
}

fn tcc_define_symbol(s1 &TCCState, sym &i8, value &i8) {
	len1 := 0
	len2 := 0

	if !value {
		value = c'1'
	}
	len1 = C.strlen(sym)
	len2 = C.strlen(value)
	tcc_open_bf(s1, c'<define>', len1 + len2 + 1)
	C.memcpy(file.buffer, sym, len1)
	file.buffer[len1] = ` `
	C.memcpy(file.buffer + len1 + 1, value, len2)
	next_nomacro()
	parse_define()
	tcc_close()
}

fn tcc_undefine_symbol(s1 &TCCState, sym &i8) {
	ts := &TokenSym(0)
	s := &Sym(0)
	ts = tok_alloc(sym, C.strlen(sym))
	s = define_find(ts.tok)
	if s {
		define_undef(s)
		tok_str_free_str(s.d)
		s.d = (unsafe { nil })
	}
}

fn tcc_cleanup() {
	if (unsafe { nil }) == tcc_state {
		return
	}
	for file {
		tcc_close()
	}
	tccpp_delete(tcc_state)
	tcc_state = (unsafe { nil })
	dynarray_reset(&sym_pools, &nb_sym_pools)
	sym_free_first = (unsafe { nil })
}

fn tcc_new() &TCCState {
	s := &TCCState(0)
	tcc_cleanup()
	s = tcc_mallocz(sizeof(TCCState))
	if !s {
		return unsafe { nil }
	}
	tcc_state = s
	nb_states++$
	s.nocommon = 1
	s.dollars_in_identifiers = 1
	s.cversion = 199901
	s.warn_implicit_function_declaration = 1
	s.ms_extensions = 1
	tcc_set_lib_path(s, c'/usr/local/lib/tcc')
	tccelf_new(s)
	tccpp_new(s)
	define_push(Tcc_token.tok___line__, 0, (unsafe { nil }), (unsafe { nil }))
	define_push(Tcc_token.tok___file__, 0, (unsafe { nil }), (unsafe { nil }))
	define_push(Tcc_token.tok___date__, 0, (unsafe { nil }), (unsafe { nil }))
	define_push(Tcc_token.tok___time__, 0, (unsafe { nil }), (unsafe { nil }))
	define_push(Tcc_token.tok___counter__, 0, (unsafe { nil }), (unsafe { nil }))
	{
		buffer := [32]i8{}
		a := 0
		b := 0
		c := 0

		C.sscanf(c'0.9.27', c'%d.%d.%d', &a, &b, &c)
		sprintf(buffer, c'%d', a * 10000 + b * 100 + c)
		tcc_define_symbol(s, c'__TINYC__', buffer)
	}
	tcc_define_symbol(s, c'__STDC__', (unsafe { nil }))
	tcc_define_symbol(s, c'__STDC_VERSION__', c'199901L')
	tcc_define_symbol(s, c'__STDC_HOSTED__', (unsafe { nil }))
	tcc_define_symbol(s, c'__x86_64__', (unsafe { nil }))
	tcc_define_symbol(s, c'__unix__', (unsafe { nil }))
	tcc_define_symbol(s, c'__unix', (unsafe { nil }))
	tcc_define_symbol(s, c'unix', (unsafe { nil }))
	tcc_define_symbol(s, c'__linux__', (unsafe { nil }))
	tcc_define_symbol(s, c'__linux', (unsafe { nil }))
	tcc_define_symbol(s, c'__SIZE_TYPE__', c'unsigned long')
	tcc_define_symbol(s, c'__PTRDIFF_TYPE__', c'long')
	tcc_define_symbol(s, c'__LP64__', (unsafe { nil }))
	tcc_define_symbol(s, c'__SIZEOF_POINTER__', if 8 == 4 { c'4' } else { c'8' })
	tcc_define_symbol(s, c'__WCHAR_TYPE__', c'int')
	tcc_define_symbol(s, c'__WINT_TYPE__', c'unsigned int')
	tcc_define_symbol(s, c'__REDIRECT(name, proto, alias)', c'name proto __asm__ (#alias)')
	tcc_define_symbol(s, c'__REDIRECT_NTH(name, proto, alias)', c'name proto __asm__ (#alias) __THROW')
	tcc_define_symbol(s, c'__builtin_extract_return_addr(x)', c'x')
	return s
}

fn tcc_delete(s1 &TCCState) {
	tcc_cleanup()
	tccelf_delete(s1)
	dynarray_reset(&s1.library_paths, &s1.nb_library_paths)
	dynarray_reset(&s1.crt_paths, &s1.nb_crt_paths)
	dynarray_reset(&s1.cached_includes, &s1.nb_cached_includes)
	dynarray_reset(&s1.include_paths, &s1.nb_include_paths)
	dynarray_reset(&s1.sysinclude_paths, &s1.nb_sysinclude_paths)
	dynarray_reset(&s1.cmd_include_files, &s1.nb_cmd_include_files)
	tcc_free(s1.tcc_lib_path)
	tcc_free(s1.soname)
	tcc_free(s1.rpath)
	tcc_free(s1.init_symbol)
	tcc_free(s1.fini_symbol)
	tcc_free(s1.outfile)
	tcc_free(s1.deps_outfile)
	dynarray_reset(&s1.files, &s1.nb_files)
	dynarray_reset(&s1.target_deps, &s1.nb_target_deps)
	dynarray_reset(&s1.pragma_libs, &s1.nb_pragma_libs)
	dynarray_reset(&s1.argv, &s1.argc)
	tcc_run_free(s1)
	tcc_free(s1)
	if 0 == nb_states--$ {
		tcc_memcheck()
	}
}

fn tcc_set_output_type(s &TCCState, output_type int) int {
	s.output_type = output_type
	if output_type == 4 {
		s.output_format = 0
	}
	if s.char_is_unsigned {
		tcc_define_symbol(s, c'__CHAR_UNSIGNED__', (unsafe { nil }))
	}
	if !s.nostdinc {
		tcc_add_sysinclude_path(s, c'{B}/include:/usr/local/include:/usr/include')
	}
	if s.do_bounds_check {
		tccelf_bounds_new(s)
		tcc_define_symbol(s, c'__BOUNDS_CHECKING_ON', (unsafe { nil }))
	}
	if s.do_debug {
		tccelf_stab_new(s)
	}
	tcc_add_library_path(s, c'/usr/lib:/lib:/usr/local/lib')
	tcc_split_path(s, &s.crt_paths, &s.nb_crt_paths, c'/usr/lib')
	if (output_type == 2 || output_type == 3) && !s.nostdlib {
		if output_type != 3 {
			tcc_add_crt(s, c'crt1.o')
		}
		tcc_add_crt(s, c'crti.o')
	}
	return 0
}

fn tcc_add_include_path(s &TCCState, pathname &i8) int {
	tcc_split_path(s, &s.include_paths, &s.nb_include_paths, pathname)
	return 0
}

fn tcc_add_sysinclude_path(s &TCCState, pathname &i8) int {
	tcc_split_path(s, &s.sysinclude_paths, &s.nb_sysinclude_paths, pathname)
	return 0
}

fn tcc_add_file_internal(s1 &TCCState, filename &i8, flags int) int {
	ret := 0
	ret = tcc_open(s1, filename)
	if ret < 0 {
		if flags & 16 {
			tcc_error_noabort(c"file '%s' not found", filename)
		}
		return ret
	}
	dynarray_add(&s1.target_deps, &s1.nb_target_deps, tcc_strdup(filename))
	if flags & 64 {
		ehdr := Elf64_Ehdr{}
		fd := 0
		obj_type := 0

		fd = file.fd
		obj_type = tcc_object_type(fd, &ehdr)
		C.lseek(fd, 0, 0)
		match obj_type {
			1 { // case comp body kind=BinaryOperator is_enum=false
				ret = tcc_load_object_file(s1, fd, 0)
			}
			2 { // case comp body kind=IfStmt is_enum=false
				if s1.output_type == 1 {
					ret = 0
					if (unsafe { nil }) == dlopen(filename, 256 | 1) {
						ret = -1
					}
				} else {
					ret = tcc_load_dll(s1, fd, filename, (flags & 32) != 0)
				}
			}
			3 { // case comp body kind=BinaryOperator is_enum=false
				ret = tcc_load_archive(s1, fd, !(flags & 128))

				if ret < 0 {
					tcc_error_noabort(c'unrecognized file type')
				}
			}
			else {
				ret = tcc_load_ldscript(s1)
			}
		}
	} else {
		ret = tcc_compile(s1, flags)
	}
	tcc_close()
	return ret
}

fn tcc_add_file(s &TCCState, filename &i8) int {
	filetype := s.filetype
	if 0 == (filetype & (15 | 64)) {
		ext := tcc_fileextension(filename)
		if ext[0] {
			ext++
			if !C.strcmp(ext, c'S') {
				filetype = 4
			} else if !C.strcmp(ext, c's') {
				filetype = 2
			} else if !C.strcmp(ext, c'c') || !C.strcmp(ext, c'i') {
				filetype = 1
			} else { // 3
				filetype |= 64
			}
		} else {
			filetype = 1
		}
	}
	return tcc_add_file_internal(s, filename, filetype | 16)
}

fn tcc_add_library_path(s &TCCState, pathname &i8) int {
	tcc_split_path(s, &s.library_paths, &s.nb_library_paths, pathname)
	return 0
}

fn tcc_add_library_internal(s &TCCState, fmt &i8, filename &i8, flags int, paths &&u8, nb_paths int) int {
	buf := [1024]i8{}
	i := 0
	for i = 0; i < nb_paths; i++ {
		C.snprintf(buf, sizeof(buf), fmt, paths[i], filename)
		if tcc_add_file_internal(s, buf, flags | 64) == 0 {
			return 0
		}
	}
	return -1
}

fn tcc_add_dll(s &TCCState, filename &i8, flags int) int {
	return tcc_add_library_internal(s, c'%s/%s', filename, flags, s.library_paths, s.nb_library_paths)
}

fn tcc_add_crt(s &TCCState, filename &i8) int {
	if -1 == tcc_add_library_internal(s, c'%s/%s', filename, 0, s.crt_paths, s.nb_crt_paths) {
		tcc_error_noabort(c"file '%s' not found", filename)
	}
	return 0
}

fn tcc_add_library(s &TCCState, libraryname &i8) int {
	libs := [c'%s/lib%s.so', c'%s/lib%s.a', (unsafe { nil })]!

	pp := if s.static_link { libs + 1 } else { libs }
	flags := s.filetype & 128
	for *pp {
		if 0 == tcc_add_library_internal(s, *pp, libraryname, flags, s.library_paths,
			s.nb_library_paths) {
			return 0
		}
		pp++$
	}
	return -1
}

fn tcc_add_library_err(s &TCCState, libname &i8) int {
	ret := tcc_add_library(s, libname)
	if ret < 0 {
		tcc_error_noabort(c"library '%s' not found", libname)
	}
	return ret
}

fn tcc_add_pragma_libs(s1 &TCCState) {
	i := 0
	for i = 0; i < s1.nb_pragma_libs; i++ {
		tcc_add_library_err(s1, s1.pragma_libs[i])
	}
}

fn tcc_add_symbol(s &TCCState, name &i8, val voidptr) int {
	set_elf_sym(symtab_section, Uintptr_t(val), 0, (((1) << 4) + ((0) & 15)), 0, 65521,
		name)
	return 0
}

fn tcc_set_lib_path(s &TCCState, path &i8) {
	tcc_free(s.tcc_lib_path)
	s.tcc_lib_path = tcc_strdup(path)
}

struct FlagDef {
	offset u16
	flags  u16
	name   &i8
}

fn no_flag(pp &&u8) int {
	p := *pp
	if *p != `n` || *p++$ != `o` || *p++$ != `-` {
		return 0
	}
	*pp = p + 1
	return 1
}

fn set_flag(s &TCCState, flags &FlagDef, name &i8) int {
	value := 0
	ret := 0

	p := &FlagDef(0)
	r := &i8(0)
	value = 1
	r = name
	if no_flag(&r) {
		value = 0
	}
	flags = -1
	for ret = -1; p.name; p++ {
		if ret {
			if C.strcmp(r, p.name) {
				continue
			}
		} else {
			if 0 == (p.flags & 1) {
				continue
			}
		}
		if p.offset {
			*&int((&i8(s) + p.offset)) = if p.flags & 2 { !value } else { value }
			if ret {
				return 0
			}
		} else {
			ret = 0
		}
	}
	return ret
}

fn strstart(val &i8, str &&u8) int {
	p := &i8(0)
	q := &i8(0)

	p = *str
	q = val
	for *q {
		if *p != *q {
			return 0
		}
		p++
		q++
	}
	*str = p
	return 1
}

fn link_option(str &i8, val &i8, ptr &&u8) int {
	p := &i8(0)
	q := &i8(0)

	ret := 0
	if *str++ != `-` {
		return 0
	}
	if *str == `-` {
		str++
	}
	p = str
	q = val
	ret = 1
	if q[0] == `?` {
		q++$
		if no_flag(&p) {
			ret = -1
		}
	}
	for *q != `\x00` && *q != `=` {
		if *p != *q {
			return 0
		}
		p++
		q++
	}
	if *q == `=` {
		if *p == 0 {
			*ptr = p
		}
		if *p != `,` && *p != `=` {
			return 0
		}
		p++
	} else if *p {
		return 0
	}
	*ptr = p
	return ret
}

fn skip_linker_arg(str &&u8) &i8 {
	s1 := *str
	s2 := C.strchr(s1, `,`)
	*str = if s2 {
		s2++
	} else {
		s2 = s1 + C.strlen(s1)
		S2
	}
	return s2
}

fn copy_linker_arg(pp &&u8, s &i8, sep int) {
	q := s
	p := *pp
	l := 0
	if p && sep {
		l = C.strlen(p)
		p[l] = sep, l++$
	}
	skip_linker_arg(&q)
	*pp = tcc_realloc(p, q - s + l + 1)
	pstrncpy(l + *pp, s, q - s)
}

fn tcc_set_linker(s &TCCState, option &i8) int {
	for *option {
		p := (unsafe { nil })
		end := (unsafe { nil })
		ignoring := 0
		ret := 0
		if link_option(option, c'Bsymbolic', &p) {
			s.symbolic = 1
		} else if link_option(option, c'nostdlib', &p) {
			s.nostdlib = 1
		} else if link_option(option, c'fini=', &p) {
			copy_linker_arg(&s.fini_symbol, p, 0)
			ignoring = 1
		} else if link_option(option, c'image-base=', &p) || link_option(option, c'Ttext=', &p) {
			s.text_addr = strtoull(p, &end, 16)
			s.has_text_addr = 1
		} else if link_option(option, c'init=', &p) {
			copy_linker_arg(&s.init_symbol, p, 0)
			ignoring = 1
		} else if link_option(option, c'oformat=', &p) {
			if strstart(c'elf64-', &p) {
				s.output_format = 0
			} else if !C.strcmp(p, c'binary') {
				s.output_format = 1
			} else { // 3
				goto err // id: 0x7fffe6124718
			}
		} else if link_option(option, c'as-needed', &p) {
			ignoring = 1
		} else if link_option(option, c'O', &p) {
			ignoring = 1
		} else if link_option(option, c'export-all-symbols', &p) {
			s.rdynamic = 1
		} else if link_option(option, c'export-dynamic', &p) {
			s.rdynamic = 1
		} else if link_option(option, c'rpath=', &p) {
			copy_linker_arg(&s.rpath, p, `:`)
		} else if link_option(option, c'enable-new-dtags', &p) {
			s.enable_new_dtags = 1
		} else if link_option(option, c'section-alignment=', &p) {
			s.section_align = strtoul(p, &end, 16)
		} else if link_option(option, c'soname=', &p) {
			copy_linker_arg(&s.soname, p, 0)
		} else if ret2 := link_option(option, c'?whole-archive', &p) {
			if ret2 > 0 {
				s.filetype |= 128
			} else { // 3
				s.filetype &= ~128
			}
		} else if p {
			return 0
		} else {
			// RRRREG err id=0x7fffe6124718
			err:
			tcc_error(c"unsupported linker option '%s'", option)
		}
		if ignoring && s.warn_unsupported {
			tcc_warning(c"unsupported linker option '%s'", option)
		}
		option = skip_linker_arg(&p)
	}
	return 1
}

struct TCCOption {
	name  &i8
	index u16
	flags u16
}

// empty enum
const tcc_option_help = 0
const tcc_option_help2 = 1
const tcc_option_v = 2
const tcc_option_i = 3
const tcc_option_d = 4
const tcc_option_u = 5
const tcc_option_p = 6
const tcc_option_l = 7
const tcc_option_b = 8

const tcc_option_bench = 10
const tcc_option_bt = 11

const tcc_option_g = 13
const tcc_option_c = 14
const tcc_option_dumpversion = 15

const tcc_option_static = 17
const tcc_option_std = 18
const tcc_option_shared = 19
const tcc_option_soname = 20
const tcc_option_o = 21
const tcc_option_r = 22
const tcc_option_s = 23
const tcc_option_traditional = 24
const tcc_option_wl = 25
const tcc_option_wp = 26
const tcc_option_w = 27

const tcc_option_mfloat_abi = 29
const tcc_option_m = 30
const tcc_option_f = 31
const tcc_option_isystem = 32
const tcc_option_iwithprefix = 33
const tcc_option_include = 34
const tcc_option_nostdinc = 35
const tcc_option_nostdlib = 36
const tcc_option_print_search_dirs = 37
const tcc_option_rdynamic = 38
const tcc_option_param = 39
const tcc_option_pedantic = 40
const tcc_option_pthread = 41
const tcc_option_run = 42

const tcc_option_pipe = 44
const tcc_option_e = 45
const tcc_option_md = 46
const tcc_option_mf = 47
const tcc_option_x = 48
const tcc_option_ar = 49
const tcc_option_impdef = 50

@[export: 'tcc_options']
const tcc_options = [TCCOption{
	name: c'h'
	index: tcc_option_help
	flags: 0
}, TCCOption{
	name: c'-help'
	index: tcc_option_help
	flags: 0
}, TCCOption{
	name: c'?'
	index: tcc_option_help
	flags: 0
}, TCCOption{
	name: c'hh'
	index: tcc_option_help2
	flags: 0
}, TCCOption{
	name: c'v'
	index: tcc_option_v
	flags: 1 | 2
}, TCCOption{
	name: c'I'
	index: tcc_option_i
	flags: 1
}, TCCOption{
	name: c'D'
	index: tcc_option_d
	flags: 1
}, TCCOption{
	name: c'U'
	index: tcc_option_u
	flags: 1
}, TCCOption{
	name: c'P'
	index: tcc_option_p
	flags: 1 | 2
}, TCCOption{
	name: c'L'
	index: tcc_option_l
	flags: 1
}, TCCOption{
	name: c'B'
	index: tcc_option_b
	flags: 1
}, TCCOption{
	name: c'l'
	index: tcc_option_l
	flags: 1
}, TCCOption{
	name: c'bench'
	index: tcc_option_bench
	flags: 0
}, TCCOption{
	name: c'bt'
	index: tcc_option_bt
	flags: 1
}, TCCOption{
	name: c'b'
	index: tcc_option_b
	flags: 0
}, TCCOption{
	name: c'g'
	index: tcc_option_g
	flags: 1 | 2
}, TCCOption{
	name: c'c'
	index: tcc_option_c
	flags: 0
}, TCCOption{
	name: c'dumpversion'
	index: tcc_option_dumpversion
	flags: 0
}, TCCOption{
	name: c'd'
	index: tcc_option_d
	flags: 1 | 2
}, TCCOption{
	name: c'static'
	index: tcc_option_static
	flags: 0
}, TCCOption{
	name: c'std'
	index: tcc_option_std
	flags: 1 | 2
}, TCCOption{
	name: c'shared'
	index: tcc_option_shared
	flags: 0
}, TCCOption{
	name: c'soname'
	index: tcc_option_soname
	flags: 1
}, TCCOption{
	name: c'o'
	index: tcc_option_o
	flags: 1
}, TCCOption{
	name: c'-param'
	index: tcc_option_param
	flags: 1
}, TCCOption{
	name: c'pedantic'
	index: tcc_option_pedantic
	flags: 0
}, TCCOption{
	name: c'pthread'
	index: tcc_option_pthread
	flags: 0
}, TCCOption{
	name: c'run'
	index: tcc_option_run
	flags: 1 | 2
}, TCCOption{
	name: c'rdynamic'
	index: tcc_option_rdynamic
	flags: 0
}, TCCOption{
	name: c'r'
	index: tcc_option_r
	flags: 0
}, TCCOption{
	name: c's'
	index: tcc_option_s
	flags: 0
}, TCCOption{
	name: c'traditional'
	index: tcc_option_traditional
	flags: 0
}, TCCOption{
	name: c'Wl,'
	index: tcc_option_wl
	flags: 1 | 2
}, TCCOption{
	name: c'Wp,'
	index: tcc_option_wp
	flags: 1 | 2
}, TCCOption{
	name: c'W'
	index: tcc_option_w
	flags: 1 | 2
}, TCCOption{
	name: c'O'
	index: tcc_option_o
	flags: 1 | 2
}, TCCOption{
	name: c'm'
	index: tcc_option_m
	flags: 1 | 2
}, TCCOption{
	name: c'f'
	index: tcc_option_f
	flags: 1 | 2
}, TCCOption{
	name: c'isystem'
	index: tcc_option_isystem
	flags: 1
}, TCCOption{
	name: c'include'
	index: tcc_option_include
	flags: 1
}, TCCOption{
	name: c'nostdinc'
	index: tcc_option_nostdinc
	flags: 0
}, TCCOption{
	name: c'nostdlib'
	index: tcc_option_nostdlib
	flags: 0
}, TCCOption{
	name: c'print-search-dirs'
	index: tcc_option_print_search_dirs
	flags: 0
}, TCCOption{
	name: c'w'
	index: tcc_option_w
	flags: 0
}, TCCOption{
	name: c'pipe'
	index: tcc_option_pipe
	flags: 0
}, TCCOption{
	name: c'E'
	index: tcc_option_e
	flags: 0
}, TCCOption{
	name: c'MD'
	index: tcc_option_md
	flags: 0
}, TCCOption{
	name: c'MF'
	index: tcc_option_mf
	flags: 1
}, TCCOption{
	name: c'x'
	index: tcc_option_x
	flags: 1
}, TCCOption{
	name: c'ar'
	index: tcc_option_ar
	flags: 0
}, TCCOption{
	name: (unsafe { nil })
	index: 0
	flags: 0
}]!

@[export: 'options_W']
const options_W = [FlagDef{
	offset: 0
	flags: 0
	name: c'all'
}, FlagDef{
	offset: (usize(&(&TCCState(0)).warn_unsupported))
	flags: 0
	name: c'unsupported'
}, FlagDef{
	offset: (usize(&(&TCCState(0)).warn_write_strings))
	flags: 0
	name: c'write-strings'
}, FlagDef{
	offset: (usize(&(&TCCState(0)).warn_error))
	flags: 0
	name: c'error'
}, FlagDef{
	offset: (usize(&(&TCCState(0)).warn_gcc_compat))
	flags: 0
	name: c'gcc-compat'
}, FlagDef{
	offset: (usize(&(&TCCState(0)).warn_implicit_function_declaration))
	flags: 1
	name: c'implicit-function-declaration'
}, FlagDef{
	offset: 0
	flags: 0
	name: (unsafe { nil })
}]!

@[export: 'options_f']
const options_f = [
	FlagDef{
		offset: (usize(&(&TCCState(0)).char_is_unsigned))
		flags: 0
		name: c'unsigned-char'
	},
	FlagDef{
		offset: (usize(&(&TCCState(0)).char_is_unsigned))
		flags: 2
		name: c'signed-char'
	},
	FlagDef{
		offset: (usize(&(&TCCState(0)).nocommon))
		flags: 2
		name: c'common'
	},
	FlagDef{
		offset: (usize(&(&TCCState(0)).leading_underscore))
		flags: 0
		name: c'leading-underscore'
	},
	FlagDef{
		offset: (usize(&(&TCCState(0)).ms_extensions))
		flags: 0
		name: c'ms-extensions'
	},
	FlagDef{
		offset: (usize(&(&TCCState(0)).dollars_in_identifiers))
		flags: 0
		name: c'dollars-in-identifiers'
	},
	FlagDef{
		offset: 0
		flags: 0
		name: (unsafe { nil })
	},
]!

@[export: 'options_m']
const options_m = [
	FlagDef{
		offset: (usize(&(&TCCState(0)).ms_bitfields))
		flags: 0
		name: c'ms-bitfields'
	},
	FlagDef{
		offset: (usize(&(&TCCState(0)).nosse))
		flags: 2
		name: c'sse'
	},
	FlagDef{
		offset: 0
		flags: 0
		name: (unsafe { nil })
	},
]!

@[c: 'parse_option_D']
fn parse_option_d(s1 &TCCState, optarg &i8) {
	sym := tcc_strdup(optarg)
	value := C.strchr(sym, `=`)
	if value {
		*value++ = `\x00`
	}
	tcc_define_symbol(s1, sym, value)
	tcc_free(sym)
}

fn args_parser_add_file(s &TCCState, filename &i8, filetype int) {
	f := tcc_malloc(sizeof(*f) + C.strlen(filename))
	f.type_ = filetype
	strcpy(f.name, filename)
	dynarray_add(&s.files, &s.nb_files, f)
}

fn args_parser_make_argv(r &i8, argc &int, argv &&&i8) int {
	ret := 0
	q := 0
	c := 0

	str := CString{}
	for {
		for {
			c = u8(*r)
			if c == 0 {
				break
			}
			if c && c <= ` ` {
				break
			}
			r++
		}
		if c == 0 {
			break
		}
		q = 0
		cstr_new(&str)
		for {
			c = u8(*r)
			if c == 0 {
				break
			}
			r++
			if c == `\\` && (*r == `"` || *r == `\\`) {
				c = *r++
			} else if c == `"` {
				q = !q
				continue
			} else if q == 0 && c <= ` ` {
				break
			}
			cstr_ccat(&str, c)
		}
		cstr_ccat(&str, 0)
		dynarray_add(argv, argc, tcc_strdup(str.data))
		cstr_free(&str)
		ret++$
	}
	return ret
}

fn args_parser_listfile(s &TCCState, filename &i8, optind int, pargc &int, pargv &&&i8) {
	fd := 0
	i := 0

	len := usize(0)
	p := &i8(0)
	argc := 0
	argv := (unsafe { nil })
	fd = C.open(filename, 0 | 0)
	if fd < 0 {
		tcc_error(c"listfile '%s' not found", filename)
	}
	len = C.lseek(fd, 0, 2)
	p = tcc_malloc(len + 1)
	p[len] = 0
	C.lseek(fd, 0, 0), C.read(fd, p, len), C.close(fd)
	for i = 0; i < *pargc; i++ {
		if i == optind {
			args_parser_make_argv(p, &argc, &argv)
		} else { // 3
			dynarray_add(&argv, &argc, tcc_strdup((*pargv)[i]))
		}
	}
	tcc_free(p)
	dynarray_reset(&s.argv, &s.argc)
	*pargc = argc
	s.argc = argc
	s.argv = argv
	*pargv = argv
}

fn tcc_parse_args(s &TCCState, pargc &int, pargv &&&i8, optind int) int {
	popt := &TCCOption(0)
	optarg := &i8(0)
	r := &i8(0)

	run := (unsafe { nil })
	last_o := -1
	x := 0
	linker_arg := CString{}
	tool := 0
	arg_start := 0
	noaction := optind

	argv := *pargv
	argc := *pargc
	cstr_new(&linker_arg)
	for optind < argc {
		r = argv[optind]
		if r[0] == `@` && r[1] != `\x00` {
			args_parser_listfile(s, r + 1, optind, &argc, &argv)
			continue
		}
		optind++
		if tool {
			if r[0] == `-` && r[1] == `v` && r[2] == 0 {
				s.verbose++$
			}
			continue
		}
		// RRRREG reparse id=0x7fffe6136718
		reparse:
		if r[0] != `-` || r[1] == `\x00` {
			if r[0] != `@` {
				args_parser_add_file(s, r, s.filetype)
			}
			if run {
				tcc_set_options(s, run)
				arg_start = optind - 1
				break
			}
			continue
		}
		for popt = tcc_options; true; popt++ {
			p1 := popt.name
			r1 := r + 1
			if p1 == (unsafe { nil }) {
				tcc_error(c"invalid option -- '%s'", r)
			}
			if !strstart(p1, &r1) {
				continue
			}
			optarg = r1
			if popt.flags & 1 {
				if *r1 == `\x00` && !(popt.flags & 2) {
					if optind >= argc {
						// RRRREG arg_err id=0x7fffe6137258
						arg_err:
						tcc_error(c"argument to '%s' is missing", r)
					}
					optind++
					optarg = argv[optind]
				}
			} else if *r1 != `\x00` {
				continue
			}
			break
		}
		match popt.index {
			int(tcc_option_help) { // case comp body kind=ReturnStmt is_enum=true
				return 1
			}
			int(tcc_option_help2) { // case comp body kind=ReturnStmt is_enum=true
				return 2
			}
			int(tcc_option_i) { // case comp body kind=CallExpr is_enum=true
				tcc_add_include_path(s, optarg)
			}
			int(tcc_option_d) { // case comp body kind=CallExpr is_enum=true
				parse_option_d(s, optarg)
			}
			int(tcc_option_u) { // case comp body kind=CallExpr is_enum=true
				tcc_undefine_symbol(s, optarg)
			}
			int(tcc_option_l) { // case comp body kind=CallExpr is_enum=true
				tcc_add_library_path(s, optarg)
				args_parser_add_file(s, optarg, 8 | (s.filetype & ~(15 | 64)))
				s.nb_libraries++
			}
			int(tcc_option_b) { // case comp body kind=CallExpr is_enum=true
				tcc_set_lib_path(s, optarg)
			}
			int(tcc_option_pthread) { // case comp body kind=CallExpr is_enum=true
				parse_option_d(s, c'_REENTRANT')
				s.option_pthread = 1
			}
			int(tcc_option_bench) { // case comp body kind=BinaryOperator is_enum=true
				s.do_bench = 1
			}
			int(tcc_option_bt) { // case comp body kind=CallExpr is_enum=true
				tcc_set_num_callers(C.atoi(optarg))
			}
			int(tcc_option_b) { // case comp body kind=BinaryOperator is_enum=true
				s.do_bounds_check = 1
				s.do_debug = 1
			}
			int(tcc_option_g) { // case comp body kind=BinaryOperator is_enum=true
				s.do_debug = 1
			}
			int(tcc_option_c) { // case comp body kind=BinaryOperator is_enum=true
				x = 4
				// RRRREG set_output_type id=0x7fffe6138b80
				int(set_output_type)
				{
					if s.output_type {
						tcc_warning(c'-%s: overriding compiler action already specified',
							popt.name)
					}
					s.output_type = x
				}
				int(tcc_option_d)
				{ // case comp body kind=IfStmt is_enum=true
					if *optarg == `D` {
						s.dflag = 3
					} else if *optarg == `M` {
						s.dflag = 7
					} else if *optarg == `t` {
						s.dflag = 16
					} else if isnum(*optarg) {
						g_debug = C.atoi(optarg)
					} else { // 3
						goto unsupported_option // id: 0x7fffe6139338
					}
				}
				int(tcc_option_static)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.static_link = 1
				}
				tcc_option_std{if *optarg == `=` {
					if C.strcmp(optarg, c'=c11') == 0 {
						tcc_undefine_symbol(s, c'__STDC_VERSION__')
						tcc_define_symbol(s, c'__STDC_VERSION__', c'201112L')
						tcc_define_symbol(s, c'__STDC_NO_ATOMICS__', c'1')
						tcc_define_symbol(s, c'__STDC_NO_COMPLEX__', c'1')
						tcc_define_symbol(s, c'__STDC_NO_THREADS__', c'1')
						tcc_define_symbol(s, c'__STDC_UTF_16__', c'1')
						tcc_define_symbol(s, c'__STDC_UTF_32__', c'1')
						s.cversion = 201112
					}
				}}
				int(tcc_option_shared)
				{ // case comp body kind=BinaryOperator is_enum=true
					x = 3
					goto set_output_type // id: 0x7fffe6138b80
				}
				int(tcc_option_soname)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.soname = tcc_strdup(optarg)
				}
				int(tcc_option_o)
				{ // case comp body kind=IfStmt is_enum=true
					if s.outfile {
						tcc_warning(c'multiple -o option')
						tcc_free(s.outfile)
					}
					s.outfile = tcc_strdup(optarg)
				}
				int(tcc_option_r)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.option_r = 1
					x = 4
					goto set_output_type // id: 0x7fffe6138b80
				}
				int(tcc_option_isystem)
				{ // case comp body kind=CallExpr is_enum=true
					tcc_add_sysinclude_path(s, optarg)
				}
				int(tcc_option_include)
				{ // case comp body kind=CallExpr is_enum=true
					dynarray_add(&s.cmd_include_files, &s.nb_cmd_include_files, tcc_strdup(optarg))
				}
				int(tcc_option_nostdinc)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.nostdinc = 1
				}
				int(tcc_option_nostdlib)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.nostdlib = 1
				}
				int(tcc_option_run)
				{ // case comp body kind=BinaryOperator is_enum=true
					run = optarg
					x = 1
					goto set_output_type // id: 0x7fffe6138b80
				}
				int(tcc_option_v)
				{ // case comp body kind=DoStmt is_enum=true
					for {
						s.verbose
						// while()
						if !(*optarg++ == `v`) {
							break
						}
					}
					noaction++$
				}
				int(tcc_option_f)
				{ // case comp body kind=IfStmt is_enum=true
					if set_flag(s, options_f, optarg) < 0 {
						goto unsupported_option // id: 0x7fffe6139338
					}
				}
				int(tcc_option_m)
				{ // case comp body kind=IfStmt is_enum=true
					if set_flag(s, options_m, optarg) < 0 {
						x = C.atoi(optarg)
						if x != 32 && x != 64 {
							goto unsupported_option // id: 0x7fffe6139338
						}
						if 8 != x / 8 {
							return x
						}
						noaction++$
					}
				}
				int(tcc_option_w)
				{ // case comp body kind=IfStmt is_enum=true
					if set_flag(s, options_W, optarg) < 0 {
						goto unsupported_option // id: 0x7fffe6139338
					}
				}
				int(tcc_option_w)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.warn_none = 1
				}
				int(tcc_option_rdynamic)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.rdynamic = 1
				}
				int(tcc_option_wl)
				{ // case comp body kind=IfStmt is_enum=true
					if linker_arg.size {
						linker_arg.size--$, cstr_ccat(&linker_arg, `,`)
					}
					cstr_cat(&linker_arg, optarg, 0)
					if tcc_set_linker(s, linker_arg.data) {
						cstr_free(&linker_arg)
					}
				}
				int(tcc_option_wp)
				{ // case comp body kind=BinaryOperator is_enum=true
					r = optarg
					goto reparse // id: 0x7fffe6136718
				}
				int(tcc_option_e)
				{ // case comp body kind=BinaryOperator is_enum=true
					x = 5
					goto set_output_type // id: 0x7fffe6138b80
				}
				int(tcc_option_p)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.Pflag = C.atoi(optarg) + 1
				}
				int(tcc_option_md)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.gen_deps = 1
				}
				int(tcc_option_mf)
				{ // case comp body kind=BinaryOperator is_enum=true
					s.deps_outfile = tcc_strdup(optarg)
				}
				int(tcc_option_dumpversion)
				{ // case comp body kind=CallExpr is_enum=true
					C.printf(c'%s\n', c'0.9.27')
					C.exit(0)
				}
				int(tcc_option_x)
				{ // case comp body kind=BinaryOperator is_enum=true
					x = 0
					if *optarg == `c` {
						x = 1
					} else if *optarg == `a` {
						x = 4
					} else if *optarg == `b` {
						x = 64
					} else if *optarg == `n` {
						x = 0
					} else { // 3
						tcc_warning(c"unsupported language '%s'", optarg)
					}
					s.filetype = x | (s.filetype & ~(15 | 64))
				}
				int(tcc_option_o)
				{ // case comp body kind=BinaryOperator is_enum=true
					last_o = C.atoi(optarg)
				}
				int(tcc_option_print_search_dirs)
				{ // case comp body kind=BinaryOperator is_enum=true
					x = 4
					goto extra_action // id: 0x7fffe613d7c8
				}
				int(tcc_option_impdef)
				{ // case comp body kind=BinaryOperator is_enum=true
					x = 6
					goto extra_action // id: 0x7fffe613d7c8
				}
				int(tcc_option_ar)
				{ // case comp body kind=BinaryOperator is_enum=true
					x = 5
					// RRRREG extra_action id=0x7fffe613d7c8
					extra_action:
					arg_start = optind - 1
					if arg_start != noaction {
						tcc_error(c'cannot parse %s here', r)
					}
					tool = x
				}
				int(tcc_option_traditional), int(tcc_option_pedantic), int(tcc_option_pipe), int(tcc_option_s)
				{
				}
			}
			else {
				// RRRREG unsupported_option id=0x7fffe6139338
				unsupported_option:
				if s.warn_unsupported {
					tcc_warning(c"unsupported option '%s'", r)
				}
			}
		}
	}
	if last_o > 0 {
		tcc_define_symbol(s, c'__OPTIMIZE__', (unsafe { nil }))
	}
	if linker_arg.size {
		r = linker_arg.data
		goto arg_err // id: 0x7fffe6137258
	}
	*pargc = argc - arg_start
	*pargv = argv + arg_start
	if tool {
		return tool
	}
	if optind != noaction {
		return 0
	}
	if s.verbose == 2 {
		return 4
	}
	if s.verbose {
		return 3
	}
	return 1
}

fn tcc_set_options(s &TCCState, r &i8) {
	argv := (unsafe { nil })
	argc := 0
	args_parser_make_argv(r, &argc, &argv)
	tcc_parse_args(s, &argc, &argv, 0)
	dynarray_reset(&argv, &argc)
}

fn tcc_print_stats(s &TCCState, total_time u32) {
	if total_time < 1 {
		total_time = 1
	}
	if total_bytes < 1 {
		total_bytes = 1
	}
	C.fprintf(C.stderr, c'* %d idents, %d lines, %d bytes\n* %0.3f s, %u lines/s, %0.1f MB/s\n',
		tok_ident - 256, total_lines, total_bytes, f64(total_time) / 1000, u32(total_lines) * 1000 / total_time,
		f64(total_bytes) / 1000 / total_time)
}
