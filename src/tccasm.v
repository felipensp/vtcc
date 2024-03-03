@[translated]
module main

__global last_text_section = &Section(0)
// to handle .previous asm directive
__global asmgoto_n int

fn asm_get_prefix_name(s1 &TCCState, prefix &char, n u32) int {
	buf := [64]char{}
	unsafe { C.snprintf(buf, sizeof(buf), c'%s%u', prefix, n) }
	return tok_alloc_const(buf)
}

fn asm_get_local_label_name(s1 &TCCState, n u32) int {
	return asm_get_prefix_name(s1, c'L..', n)
}

fn asm2cname(v int, addeddot &int) int {
	name := &char(0)
	*addeddot = 0
	if !tcc_state.leading_underscore {
		return v
	}
	name = get_tok_str(v, (unsafe { nil }))
	if !name {
		return v
	}
	if name[0] == `_` {
		v = tok_alloc_const(unsafe { name + 1 })
	} else if unsafe { !C.strchr(name, `.`) } {
		newname := [256]char{}
		unsafe { C.snprintf(newname, sizeof(newname), c'.%s', name) }
		v = tok_alloc_const(newname)
		*addeddot = 1
	}
	return v
}

fn asm_label_find(v int) &Sym {
	sym := &Sym(0)
	addeddot := 0
	v = asm2cname(v, &addeddot)
	sym = sym_find(v)
	for sym != unsafe { nil } && sym.sym_scope && !(sym.type_.t & 8192) {
		sym = sym.prev_tok
	}
	return sym
}

fn asm_label_push(v int) &Sym {
	addeddot := 0
	v2 := asm2cname(v, &addeddot)

	sym := global_identifier_push(v2, (0 | 1 << 20) | 4096 | 8192, 0)
	if addeddot {
		sym.asm_label = v
	}
	return sym
}

fn get_asm_sym(name int, csym &Sym) &Sym {
	sym := asm_label_find(name)
	if !sym {
		sym = asm_label_push(name)
		if csym {
			sym.c = csym.c
		}
	}
	return sym
}

fn asm_section_sym(s1 &TCCState, sec &Section) &Sym {
	buf := [100]char{}
	label := 0
	sym := &Sym(0)
	unsafe { C.snprintf(buf, sizeof(buf), c'L.%s', sec.name) }
	label = tok_alloc_const(buf)
	sym = asm_label_find(label)
	return if sym { sym } else { asm_new_label1(s1, label, 1, sec.sh_num, 0) }
}

fn asm_expr_unary(s1 &TCCState, pe &ExprValue) {
	sym := &Sym(0)
	op := 0
	label := 0

	n := u64(0)
	p := &char(0)
	match rune(tok) {
		205 { // case comp body kind=BinaryOperator is_enum=false
			p = &char(unsafe { tokc.str.data })
			n = C.strtoull(p, &&char(&p), 0)
			if *p == `b` || *p == `f` {
				label = asm_get_local_label_name(s1, n)
				sym = asm_label_find(label)
				if *p == `b` {
					if sym != unsafe { nil } && (!sym.c || elfsym(sym).st_shndx == 0) {
						sym = sym.prev_tok
					}
					if !sym {
						_tcc_error("local label '${int(n)}' not found backward")
					}
				} else {
					if sym == unsafe { nil } || (sym.c && elfsym(sym).st_shndx != 0) {
						sym = asm_label_push(label)
					}
				}
				pe.v = 0
				pe.sym = sym
				pe.pcrel = 0
			} else if *p == `\x00` {
				pe.v = n
				pe.sym = unsafe { nil }
				pe.pcrel = 0
			} else {
				_tcc_error('invalid number syntax')
			}
			next()
		}
		`+` { // case comp body kind=CallExpr is_enum=false
			next()
			asm_expr_unary(s1, pe)
		}
		`-`, `~` {
			op = tok
			next()
			asm_expr_unary(s1, pe)
			if pe.sym {
				_tcc_error('invalid operation with label')
			}
			if op == `-` {
				pe.v = -pe.v
			} else { // 3
				pe.v = ~pe.v
			}
		}
		192, 193 {
			pe.v = unsafe { tokc.i }
			pe.sym = unsafe { nil }
			pe.pcrel = 0
			next()
		}
		`(` { // case comp body kind=CallExpr is_enum=false
			next()
			asm_expr(s1, pe)
			skip(`)`)
		}
		`.` { // case comp body kind=BinaryOperator is_enum=false
			pe.v = ind
			pe.sym = asm_section_sym(s1, tcc_state.cur_text_section)
			pe.pcrel = 0
			next()
		}
		else {
			if tok >= 256 {
				esym := &Elf64_Sym(0)
				sym = get_asm_sym(tok, (unsafe { nil }))
				esym = elfsym(sym)
				if esym && esym.st_shndx == 65521 {
					pe.v = esym.st_value
					pe.sym = unsafe { nil }
					pe.pcrel = 0
				} else {
					pe.v = 0
					pe.sym = sym
					pe.pcrel = 0
				}
				next()
			} else {
				_tcc_error('bad expression syntax [${get_tok_str(tok, &tokc)}]')
			}
		}
	}
}

fn asm_expr_prod(s1 &TCCState, pe &ExprValue) {
	op := 0
	e2 := ExprValue{}
	asm_expr_unary(s1, pe)
	for ; true; {
		op = tok
		if op != `*` && op != `/` && op != `%` && op != `<` && op != `>` {
			break
		}
		next()
		asm_expr_unary(s1, &e2)
		if pe.sym || e2.sym {
			_tcc_error('invalid operation with label')
		}
		match rune(op) {
			`*` { // case comp body kind=CompoundAssignOperator is_enum=false
				pe.v *= e2.v
			}
			`/` { // case comp body kind=IfStmt is_enum=false
				if e2.v == 0 {
					// RRRREG div_error id=0x7fffceac60f0
					div_error:
					_tcc_error('division by zero')
				}
				pe.v /= e2.v
			}
			`%` { // case comp body kind=IfStmt is_enum=false
				if e2.v == 0 {
					unsafe {
						goto div_error
					} // id: 0x7fffceac60f0
				}
				pe.v %= e2.v
			}
			`<` { // case comp body kind=CompoundAssignOperator is_enum=false
				pe.v <<= e2.v
			}
			`>` { // case comp body kind=CompoundAssignOperator is_enum=false
				pe.v >>= e2.v
			}
			else {}
		}
	}
}

fn asm_expr_logic(s1 &TCCState, pe &ExprValue) {
	op := 0
	e2 := ExprValue{}
	asm_expr_prod(s1, pe)
	for ; true; {
		op = tok
		if op != `&` && op != `|` && op != `^` {
			break
		}
		next()
		asm_expr_prod(s1, &e2)
		if pe.sym || e2.sym {
			_tcc_error('invalid operation with label')
		}
		match rune(op) {
			`&` { // case comp body kind=CompoundAssignOperator is_enum=false
				pe.v &= e2.v
			}
			`|` { // case comp body kind=CompoundAssignOperator is_enum=false
				pe.v |= e2.v
			}
			`^` { // case comp body kind=CompoundAssignOperator is_enum=false
				pe.v ^= e2.v
			}
			else {}
		}
	}
}

fn asm_expr_sum(s1 &TCCState, pe &ExprValue) {
	op := 0
	e2 := ExprValue{}
	asm_expr_logic(s1, pe)
	for ; true; {
		op = tok
		if op != `+` && op != `-` {
			break
		}
		next()
		asm_expr_logic(s1, &e2)
		if op == `+` {
			if pe.sym != unsafe { nil } && e2.sym != unsafe { nil } {
				unsafe {
					goto cannot_relocate
				} // id: 0x7fffceac81a8
			}
			pe.v += e2.v
			if pe.sym == unsafe { nil } && e2.sym != unsafe { nil } {
				pe.sym = e2.sym
			}
		} else {
			pe.v -= e2.v
			if !e2.sym {
			} else if voidptr(pe.sym) == voidptr(e2.sym) {
				pe.sym = unsafe { nil }
			} else {
				esym1 := &Elf64_Sym(0)
				esym2 := &Elf64_Sym(0)

				esym1 = elfsym(pe.sym)
				esym2 = elfsym(e2.sym)
				if esym1 && esym1.st_shndx == esym2.st_shndx && esym1.st_shndx != 0 {
					pe.v += esym1.st_value - esym2.st_value
					pe.sym = unsafe { nil }
				} else if esym2.st_shndx == tcc_state.cur_text_section.sh_num {
					pe.v -= esym2.st_value - ind - 4
					pe.pcrel = 1
					e2.sym = unsafe { nil }
				} else {
					// RRRREG cannot_relocate id=0x7fffceac81a8
					cannot_relocate:
					_tcc_error('invalid operation with label')
				}
			}
		}
	}
}

fn asm_expr_cmp(s1 &TCCState, pe &ExprValue) {
	op := 0
	e2 := ExprValue{}
	asm_expr_sum(s1, pe)
	for ; true; {
		op = tok
		if op != 148 && op != 149 && (op > 159 || op < 150) {
			break
		}
		next()
		asm_expr_sum(s1, &e2)
		if pe.sym || e2.sym {
			_tcc_error('invalid operation with label')
		}
		match op {
			148 { // case comp body kind=BinaryOperator is_enum=false
				pe.v = pe.v == e2.v
			}
			149 { // case comp body kind=BinaryOperator is_enum=false
				pe.v = pe.v != e2.v
			}
			156 { // case comp body kind=BinaryOperator is_enum=false
				pe.v = i64(pe.v) < i64(e2.v)
			}
			157 { // case comp body kind=BinaryOperator is_enum=false
				pe.v = i64(pe.v) >= i64(e2.v)
			}
			158 { // case comp body kind=BinaryOperator is_enum=false
				pe.v = i64(pe.v) <= i64(e2.v)
			}
			159 { // case comp body kind=BinaryOperator is_enum=false
				pe.v = i64(pe.v) > i64(e2.v)
			}
			else {}
		}
		pe.v = -i64(pe.v)
	}
}

fn asm_expr(s1 &TCCState, pe &ExprValue) {
	asm_expr_cmp(s1, pe)
}

fn asm_int_expr(s1 &TCCState) u64 {
	e := ExprValue{}
	asm_expr(s1, &e)
	if e.sym {
		expect(c'constant')
	}
	return e.v
}

fn asm_new_label1(s1 &TCCState, label int, is_local int, sh_num int, value int) &Sym {
	sym := &Sym(0)
	esym := &Elf64_Sym(0)
	sym = asm_label_find(label)
	if sym {
		esym = elfsym(sym)
		if esym && esym.st_shndx != 0 {
			if (sym.type_.t & (15 | (0 | 1 << 20))) == (0 | 1 << 20)
				&& (is_local == 1 || sym.type_.t & 4096) {
				unsafe {
					goto new_label
				} // id: 0x7fffceaccc18
			}
			if !(sym.type_.t & 4096) {
				_tcc_error("assembler label '${get_tok_str(label, (unsafe { nil }))}' already defined")
			}
		}
	} else {
		// RRRREG new_label id=0x7fffceaccc18
		new_label:
		sym = asm_label_push(label)
	}
	if !sym.c {
		put_extern_sym2(sym, 0, 0, 0, 1)
	}
	esym = elfsym(sym)
	esym.st_shndx = sh_num
	esym.st_value = value
	if is_local != 2 {
		sym.type_.t &= ~4096
	}
	return sym
}

fn asm_new_label(s1 &TCCState, label int, is_local int) &Sym {
	return asm_new_label1(s1, label, is_local, tcc_state.cur_text_section.sh_num, ind)
}

fn set_symbol(s1 &TCCState, label int) &Sym {
	n := 0
	e := ExprValue{}
	sym := &Sym(0)
	esym := &Elf64_Sym(0)
	next()
	asm_expr(s1, &e)
	n = e.v
	esym = elfsym(e.sym)
	if esym {
		n += esym.st_value
	}
	sym = asm_new_label1(s1, label, 2, if esym { esym.st_shndx } else { 65521 }, n)
	elfsym(sym).st_other |= 4
	return sym
}

fn use_section1(s1 &TCCState, sec &Section) {
	tcc_state.cur_text_section.data_offset = ind
	tcc_state.cur_text_section = sec
	ind = tcc_state.cur_text_section.data_offset
}

fn use_section(s1 &TCCState, name &char) {
	sec := &Section(0)
	sec = find_section(s1, name)
	use_section1(s1, sec)
}

fn push_section(s1 &TCCState, name &char) {
	sec := find_section(s1, name)
	sec.prev = tcc_state.cur_text_section
	use_section1(s1, sec)
}

fn pop_section(s1 &TCCState) {
	prev := tcc_state.cur_text_section.prev
	if !prev {
		_tcc_error('.popsection without .pushsection')
	}
	tcc_state.cur_text_section.prev = unsafe { nil }
	use_section1(s1, prev)
}

fn asm_parse_directive(s1 &TCCState, global int) {
	n := 0
	offset := 0
	v := 0
	size := 0
	tok1 := 0

	sec := &Section(0)
	ptr := &u8(0)
	sec = tcc_state.cur_text_section
	match Tcc_token(tok) {
		.tok_asmdir_align, .tok_asmdir_balign, .tok_asmdir_p2align, .tok_asmdir_skip,
		.tok_asmdir_space {
			tok1 = tok
			next()
			n = asm_int_expr(s1)
			if tok1 == Tcc_token.tok_asmdir_p2align {
				if n < 0 || n > 30 {
					_tcc_error('invalid p2align, must be between 0 and 30')
				}
				n = 1 << n
				tok1 = Tcc_token.tok_asmdir_align
			}
			if tok1 == Tcc_token.tok_asmdir_align || tok1 == Tcc_token.tok_asmdir_balign {
				if n < 0 || (n & (n - 1)) != 0 {
					_tcc_error('alignment must be a positive power of two')
				}
				offset = (ind + n - 1) & -n
				size = offset - ind
				if sec.sh_addralign < n {
					sec.sh_addralign = n
				}
			} else {
				if n < 0 {
					n = 0
				}
				size = n
			}
			v = 0
			if tok == `,` {
				next()
				v = asm_int_expr(s1)
			}
			// RRRREG zero_pad id=0x7fffcead2358
			zero_pad:
			if sec.sh_type != 8 {
				sec.data_offset = ind
				ptr = section_ptr_add(sec, size)
				unsafe { C.memset(ptr, v, size) }
			}
			ind += size
		}
		.tok_asmdir_quad { // case comp body kind=BinaryOperator is_enum=true
			size = 8
			unsafe {
				goto asm_data
			} // id: 0x7fffcead2530
		}
		.tok_asmdir_byte { // case comp body kind=BinaryOperator is_enum=true
			size = 1
			unsafe {
				goto asm_data
			} // id: 0x7fffcead2530
		}
		.tok_asmdir_word, .tok_asmdir_short {
			size = 2
			unsafe {
				goto asm_data
			} // id: 0x7fffcead2530
		}
		.tok_asmdir_long, .tok_asmdir_int {
			size = 4
			// RRRREG asm_data id=0x7fffcead2530
			asm_data:
			next()
			for ; true; {
				e := ExprValue{}
				asm_expr(s1, &e)
				if sec.sh_type != 8 {
					if size == 4 {
						gen_expr32(&e)
					} else if size == 8 {
						gen_expr64(&e)
					} else {
						if e.sym {
							expect(c'constant')
						}
						if size == 1 {
							g(e.v)
						} else { // 3
							gen_le16(e.v)
						}
					}
				} else {
					ind += size
				}
				if tok != `,` {
				}
				next()
			}
		}
		.tok_asmdir_fill {
			// case comp stmt
			repeat := 0
			size = 0
			val := 0
			i := 0
			j := 0

			repeat_buf := [8]u8{}
			next()
			repeat = asm_int_expr(s1)
			if repeat < 0 {
				_tcc_error('repeat < 0; .fill ignored')
			}
			size = 1
			val = 0
			if tok == `,` {
				next()
				size = asm_int_expr(s1)
				if size < 0 {
					_tcc_error('size < 0; .fill ignored')
				}
				if size > 8 {
					size = 8
				}
				if tok == `,` {
					next()
					val = asm_int_expr(s1)
				}
			}
			repeat_buf[0] = val
			repeat_buf[1] = val >> 8
			repeat_buf[2] = val >> 16
			repeat_buf[3] = val >> 24
			repeat_buf[4] = 0
			repeat_buf[5] = 0
			repeat_buf[6] = 0
			repeat_buf[7] = 0
			for i = 0; i < repeat; i++ {
				for j = 0; j < size; j++ {
					g(repeat_buf[j])
				}
			}
		}
		.tok_asmdir_rept {
			// case comp stmt
			repeat := 0
			init_str := &TokenString(0)
			next()
			repeat = asm_int_expr(s1)
			init_str = tok_str_alloc()
			next()
			for Tcc_token(tok) != .tok_asmdir_endr {
				if tok == (-1) {
					_tcc_error('we at end of file, .endr not found')
				}
				tok_str_add_tok(init_str)
				next()
			}
			tok_str_add(init_str, -1)
			tok_str_add(init_str, 0)
			begin_macro(init_str, 1)
			for repeat-- > 0 {
				tcc_assemble_internal(s1, (parse_flags & 1), global)
				macro_ptr = init_str.str
			}
			end_macro()
			next()
		}
		.tok_asmdir_org {
			// case comp stmt
			n = u32(0)
			e := ExprValue{}
			esym := &Elf64_Sym(0)
			next()
			asm_expr(s1, &e)
			n = e.v
			esym = elfsym(e.sym)
			if esym {
				if esym.st_shndx != tcc_state.cur_text_section.sh_num {
					expect(c'constant or same-section symbol')
				}
				n += esym.st_value
			}
			if n < ind {
				_tcc_error('attempt to .org backwards')
			}
			v = 0
			size = n - ind
			unsafe {
				goto zero_pad
			} // id: 0x7fffcead2358
		}
		.tok_asmdir_set { // case comp body kind=CallExpr is_enum=true
			next()
			tok1 = tok
			next()
			if tok == `,` {
				set_symbol(s1, tok1)
			}
		}
		.tok_asmdir_globl, .tok_asmdir_global, .tok_asmdir_weak, .tok_asmdir_hidden {
			tok1 = tok
			for {
				sym := &Sym(0)
				next()
				sym = get_asm_sym(tok, (unsafe { nil }))
				if tok1 != Tcc_token.tok_asmdir_hidden {
					sym.type_.t &= ~8192
				}
				if tok1 == Tcc_token.tok_asmdir_weak {
					sym.a.weak = 1
				} else if tok1 == Tcc_token.tok_asmdir_hidden {
					sym.a.visibility = 2
				}
				update_storage(sym)
				next()
				// while()
				if !(tok == `,`) {
					break
				}
			}
		}
		.tok_asmdir_string, .tok_asmdir_ascii, .tok_asmdir_asciz {
			{
				p := &u8(0)
				i := 0
				size = 0
				t := 0

				t = tok
				next()
				for ; true; {
					if tok != 200 {
						expect(c'string constant')
					}
					p = unsafe { tokc.str.data }
					size = unsafe { tokc.str.size }
					if t == Tcc_token.tok_asmdir_ascii && size > 0 {
						size--
					}
					for i = 0; i < size; i++ {
						g(p[i])
					}
					next()
					if tok == `,` {
						next()
					} else if tok != 200 {
					}
				}
			}
		}
		.tok_asmdir_text, .tok_asmdir_data, .tok_asmdir_bss {
			{
				sname := [64]char{}
				tok1 = tok
				n = 0
				next()
				if tok != `;` && tok != 10 {
					n = asm_int_expr(s1)
					next()
				}
				if n {
					unsafe { C.sprintf(sname, c'%s%d', get_tok_str(tok1, nil), n) }
				} else { // 3
					unsafe { C.sprintf(sname, c'%s', get_tok_str(tok1, nil)) }
				}
				use_section(s1, sname)
			}
		}
		.tok_asmdir_file {
			// case comp stmt
			filename := [512]char{}
			filename[0] = `\x00`
			next()
			if tok == 200 {
				pstrcat(filename, sizeof(filename), unsafe { tokc.str.data })
			} else { // 3
				pstrcat(filename, sizeof(filename), get_tok_str(tok, (unsafe { nil })))
			}
			tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
			_tcc_warning('ignoring .file ${filename}')
			next()
		}
		.tok_asmdir_ident {
			// case comp stmt
			ident := [256]char{}
			ident[0] = `\x00`
			next()
			if tok == 200 {
				pstrcat(ident, sizeof(ident), unsafe { tokc.str.data })
			} else { // 3
				pstrcat(ident, sizeof(ident), get_tok_str(tok, (unsafe { nil })))
			}
			tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
			_tcc_warning('ignoring .ident ${ident}')
			next()
		}
		.tok_asmdir_size {
			// case comp stmt
			sym := &Sym(0)
			next()
			sym = asm_label_find(tok)
			if !sym {
				_tcc_error('label not found: ${get_tok_str(tok, (unsafe { nil }))}')
			}
			tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
			_tcc_warning('ignoring .size ${get_tok_str(tok, (unsafe { nil }))},*')
			next()
			skip(`,`)
			for tok != 10 && tok != `;` && tok != (-1) {
				next()
			}
		}
		.tok_asmdir_type {
			// case comp stmt
			sym := &Sym(0)
			newtype := &char(0)
			next()
			sym = get_asm_sym(tok, (unsafe { nil }))
			next()
			skip(`,`)
			if tok == 200 {
				newtype = unsafe { tokc.str.data }
			} else {
				if tok == `@` || tok == `%` {
					next()
				}
				newtype = get_tok_str(tok, (unsafe { nil }))
			}
			if unsafe { !C.strcmp(newtype, c'function') || !C.strcmp(newtype, c'STT_FUNC') } {
				sym.type_.t = (sym.type_.t & ~15) | 6
				if sym.c {
					esym := elfsym(sym)
					esym.st_info = ((((u8((esym.st_info))) >> 4) << 4) + ((2) & 15))
				}
			} else { // 3
				tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
				_tcc_warning("change type of '${get_tok_str(sym.v, (unsafe { nil }))}' from 0x${sym.type_.t} to '${newtype}' ignored")
			}
			next()
		}
		.tok_asmdir_pushsection, .tok_asmdir_section {
			sname := [256]char{}
			old_nb_section := s1.nb_sections
			tok1 = tok
			next()
			sname[0] = `\x00`
			for tok != `;` && tok != 10 && tok != `,` {
				if tok == 200 {
					pstrcat(sname, sizeof(sname), unsafe { tokc.str.data })
				} else { // 3
					pstrcat(sname, sizeof(sname), get_tok_str(tok, (unsafe { nil })))
				}
				next()
			}
			if tok == `,` {
				next()
				if tok != 200 {
					expect(c'string constant')
				}
				next()
				if tok == `,` {
					next()
					if tok == `@` || tok == `%` {
						next()
					}
					next()
				}
			}
			last_text_section = tcc_state.cur_text_section
			if tok1 == Tcc_token.tok_asmdir_section {
				use_section(s1, sname)
			} else { // 3
				push_section(s1, sname)
			}
			if old_nb_section != s1.nb_sections {
				tcc_state.cur_text_section.sh_addralign = 1
			}
		}
		.tok_asmdir_previous {
			// case comp stmt
			sec = &Section(0)
			next()
			if !last_text_section {
				_tcc_error('no previous section referenced')
			}
			sec = tcc_state.cur_text_section
			use_section1(s1, last_text_section)
			last_text_section = sec
		}
		.tok_asmdir_popsection { // case comp body kind=CallExpr is_enum=true
			next()
			pop_section(s1)
		}
		.tok_asmdir_code64 { // case comp body kind=CallExpr is_enum=true
			next()
		}
		else {
			_tcc_error("unknown assembler directive '.${get_tok_str(tok, (unsafe { nil }))}'")
		}
	}
}

fn tcc_assemble_internal(s1 &TCCState, do_preprocess int, global int) int {
	opcode := 0
	saved_parse_flags := parse_flags
	parse_flags = 8 | 64
	if do_preprocess {
		parse_flags |= 1
	}
	for {
		next()
		if tok == (-1) {
			break
		}
		parse_flags |= 4
		// RRRREG redo id=0x7fffceae3dd0
		redo:
		if tok == `#` {
			for tok != 10 {
				next()
			}
		} else if tok >= Tcc_token.tok_asmdir_byte && tok <= Tcc_token.tok_asmdir_section {
			asm_parse_directive(s1, global)
		} else if tok == 205 {
			p := &char(0)
			n := 0
			p = unsafe { tokc.str.data }
			n = C.strtoul(p, &&char(&p), 10)
			if *p != `\x00` {
				expect(c"':'")
			}
			asm_new_label(s1, asm_get_local_label_name(s1, n), 1)
			next()
			skip(`:`)
			unsafe {
				goto redo
			} // id: 0x7fffceae3dd0
		} else if tok >= 256 {
			opcode = tok
			next()
			if tok == `:` {
				asm_new_label(s1, opcode, 0)
				next()
				unsafe {
					goto redo
				} // id: 0x7fffceae3dd0
			} else if tok == `=` {
				set_symbol(s1, opcode)
				unsafe {
					goto redo
				} // id: 0x7fffceae3dd0
			} else {
				asm_opcode(s1, opcode)
			}
		}
		if tok != `;` && tok != 10 {
			expect(c'end of line')
		}
		parse_flags &= ~4
	}
	parse_flags = saved_parse_flags
	return 0
}

fn tcc_assemble(s1 &TCCState, do_preprocess int) int {
	ret := 0
	tcc_debug_start(s1)
	tcc_state.cur_text_section = tcc_state.text_section
	ind = tcc_state.cur_text_section.data_offset
	nocode_wanted = 0
	ret = tcc_assemble_internal(s1, do_preprocess, 1)
	tcc_state.cur_text_section.data_offset = ind
	tcc_debug_end(s1)
	return ret
}

fn tcc_assemble_inline(s1 &TCCState, str &char, len int, global int) {
	saved_macro_ptr := macro_ptr
	dotid := set_idnum(`.`, 2)
	dolid := set_idnum(`$`, 0)
	tcc_open_bf(s1, c':asm:', len)
	unsafe { C.memcpy(file.buffer, str, len) }
	macro_ptr = unsafe { nil }
	tcc_assemble_internal(s1, 0, global)
	tcc_close()
	set_idnum(`$`, dolid)
	set_idnum(`.`, dotid)
	macro_ptr = saved_macro_ptr
}

fn find_constraint(operands &ASMOperand, nb_operands int, name &char, pp &&char) int {
	index := 0
	ts := &TokenSym(0)
	p := &char(0)
	if isnum(*name) {
		index = 0
		for isnum(*name) {
			index = (index * 10) + (*name) - `0`
			unsafe { name++ }
		}
		if u32(index) >= nb_operands {
			index = -1
		}
	} else if *name == `[` {
		unsafe { name++ }
		p = unsafe { C.strchr(name, `]`) }
		if p {
			ts = tok_alloc(name, unsafe { p - name })
			for index = 0; index < nb_operands; index++ {
				if operands[index].id == ts.tok {
					unsafe {
						goto found
					} // id: 0x7fffceae9940
				}
			}
			index = -1
			// RRRREG found id=0x7fffceae9940
			found:
			name = unsafe { p + 1 }
		} else {
			index = -1
		}
	} else {
		index = -1
	}
	if pp {
		*pp = name
	}
	return index
}

fn subst_asm_operands(operands &ASMOperand, nb_operands int, out_str &CString, str &char) {
	c := 0
	index := 0
	modifier := 0

	op := &ASMOperand(0)
	sv := SValue{}
	for {
		c = unsafe { *str++ }
		if c == `%` {
			if *str == `%` {
				unsafe { str++ }
				unsafe {
					goto add_char
				} // id: 0x7fffceaea7a0
			}
			modifier = 0
			if *str == `c` || *str == `n` || *str == `b` || *str == `w` || *str == `h`
				|| *str == `k` || *str == `q` || *str == `l` || *str == `P` {
				modifier = unsafe { *str++ }
			}
			index = find_constraint(unsafe { &operands[0] }, nb_operands, str, &str)
			if index < 0 {
				_tcc_error('invalid operand reference after %%')
			}
			op = unsafe { &operands[0] + index }
			if modifier == `l` {
				cstr_cat(out_str, get_tok_str(op.is_label, (unsafe { nil })), -1)
			} else {
				sv = *op.vt
				if op.reg >= 0 {
					sv.r = op.reg
					if (op.vt.r & 63) == 49 && op.is_memory {
						sv.r |= 256
					}
				}
				subst_asm_operand(out_str, &sv, modifier)
			}
		} else {
			// RRRREG add_char id=0x7fffceaea7a0
			add_char:
			cstr_ccat(out_str, c)
			if c == `\x00` {
				break
			}
		}
	}
}

fn parse_asm_operands(operands &ASMOperand, nb_operands_ptr &int, is_output int) {
	op := &ASMOperand(0)
	nb_operands := 0
	astr := &char(0)
	if tok != `:` {
		nb_operands = *nb_operands_ptr
		for {
			if nb_operands >= 30 {
				_tcc_error('too many asm operands')
			}
			op = unsafe { &operands[0] + nb_operands++ }
			op.id = 0
			if tok == `[` {
				next()
				if tok < 256 {
					expect(c'identifier')
				}
				op.id = tok
				next()
				skip(`]`)
			}
			astr = parse_mult_str(c'string constant').data
			pstrcpy(op.constraint, sizeof(op.constraint), astr)
			skip(`(`)
			gexpr()
			if is_output {
				if !(vtop.type_.t & 64) {
					test_lvalue()
				}
			} else {
				if vtop.r & 256 && ((vtop.r & 63) == 49 || (vtop.r & 63) < 48)
					&& unsafe { !C.strchr(op.constraint, `m`) } {
					gv(1)
				}
			}
			op.vt = vtop
			skip(`)`)
			if tok == `,` {
				next()
			} else {
				break
			}
		}
		*nb_operands_ptr = nb_operands
	}
}

fn asm_instr() {
	astr := CString{}
	astr1 := &CString(unsafe { nil })

	operands := [30]ASMOperand{}
	nb_outputs := 0
	nb_operands := 0
	i := 0
	must_subst := 0
	out_reg := 0
	nb_labels := 0

	clobber_regs := [16]u8{}
	sec := &Section(0)
	for tok == Tcc_token.tok_volatile1 || tok == Tcc_token.tok_volatile2
		|| tok == Tcc_token.tok_volatile3 || tok == Tcc_token.tok_goto {
		next()
	}
	astr1 = parse_asm_str()
	cstr_new(&astr)
	dynarray_add(&stk_data, &nb_stk_data, &(&astr).data)
	cstr_cat(&astr, astr1.data, astr1.size)
	nb_operands = 0
	nb_outputs = 0
	nb_labels = 0
	must_subst = 0
	unsafe { C.memset(clobber_regs, 0, sizeof(clobber_regs)) }
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
						if tok == `:` {
							break
						}
						if tok != 200 {
							expect(c'string constant')
						}
						asm_clobber(clobber_regs, unsafe { tokc.str.data })
						next()
						if tok == `,` {
							next()
						} else {
							break
						}
					}
				}
				if tok == `:` {
					next()
					for {
						csym := &Sym(0)
						asmname := 0
						if nb_operands + nb_labels >= 30 {
							_tcc_error('too many asm operands')
						}
						if tok < Tcc_token.tok_define {
							expect(c'label identifier')
						}
						operands[nb_operands + nb_labels++].id = tok
						csym = label_find(tok)
						if !csym {
							csym = label_push(&global_label_stack, tok, 1)
						} else {
							if csym.r == 2 {
								csym.r = 1
							}
						}
						next()
						asmname = asm_get_prefix_name(tcc_state, c'LG.', asmgoto_n++)
						if !csym.c {
							put_extern_sym2(csym, 0, 0, 0, 1)
						}
						get_asm_sym(asmname, csym)
						operands[nb_operands + nb_labels - 1].is_label = asmname
						if tok != `,` {
							break
						}
						next()
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
		cstr_reset(astr1)
		cstr_cat(astr1, astr.data, astr.size)
		cstr_reset(&astr)
		subst_asm_operands(operands, nb_operands + nb_labels, &astr, astr1.data)
	}
	asm_gen_code(operands, nb_operands, nb_outputs, 0, clobber_regs, out_reg)
	sec = tcc_state.cur_text_section
	tcc_assemble_inline(tcc_state, astr.data, astr.size - 1, 0)
	cstr_free(&astr)
	nb_stk_data--
	if voidptr(sec) != voidptr(tcc_state.cur_text_section) {
		_tcc_warning('inline asm tries to change current section')
		use_section1(tcc_state, sec)
	}
	next()
	asm_gen_code(operands, nb_operands, nb_outputs, 1, clobber_regs, out_reg)
	for i = 0; i < nb_operands; i++ {
		vpop()
	}
}

fn asm_global_instr() {
	astr := &CString(unsafe { nil })
	saved_nocode_wanted := nocode_wanted
	nocode_wanted = 0
	next()
	astr = parse_asm_str()
	skip(`)`)
	if tok != `;` {
		expect(c"';'")
	}
	tcc_state.cur_text_section = tcc_state.text_section
	ind = tcc_state.cur_text_section.data_offset
	tcc_assemble_inline(tcc_state, astr.data, astr.size - 1, 1)
	tcc_state.cur_text_section.data_offset = ind
	next()
	nocode_wanted = saved_nocode_wanted
}
