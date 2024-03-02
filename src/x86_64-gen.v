@[translated]
module main

__global func_bound_offset = u64(0)
__global func_bound_ind = u64(0)
__global func_bound_add_epilog = int(0)

__global func_sub_sp_offset = u64(0)
__global func_ret_sub = int(0)

pub const target_machine_defs = ['__x86_64__', '__amd64__']

pub const ptr_size = 8

const RC_INT = 0x0001 // generic integer register
const RC_FLOAT = 0x0002 // generic float register
const RC_RAX = 0x0004
const RC_RDX = 0x0008
const RC_RCX = 0x0010
const RC_RSI = 0x0020
const RC_RDI = 0x0040
const rc_st0 = 0x0080 // only for long double
const RC_R8 = 0x0100
const RC_R9 = 0x0200
const RC_R10 = 0x0400
const RC_R11 = 0x0800
const RC_XMM0 = 0x1000
const RC_XMM1 = 0x2000
const RC_XMM2 = 0x4000
const RC_XMM3 = 0x8000
const RC_XMM4 = 0x10000
const RC_XMM5 = 0x20000
const RC_XMM6 = 0x40000
const RC_XMM7 = 0x80000
const RC_IRET = RC_RAX // function return: integer register
const RC_IRE2 = RC_RDX // function return: second integer register
const rc_fret = RC_XMM0 // function return: float register
const RC_FRE2 = RC_XMM1 // function return: second float register

const reg_classes = [0x0001 | 0x0004, // eax
 0x0001 | 0x0010, // ecx
 0x0001 | 0x0008, // edx
 0, 0, 0, RC_RSI, RC_RDI, RC_R8, RC_R9, RC_R10, RC_R11, 0, 0, 0, 0, 0x0002 | 0x1000, // xmm0
 0x0002 | 0x2000, // xmm1
 0x0002 | 0x4000, // xmm2
 0x0002 | 0x8000, // xmm3
 0x0002 | 0x10000, // xmm4
 0x0002 | 0x20000, // xmm5
 0x40000, 0x80000, 0x0080, // st0
]!

// empty enum
const treg_rax = 0
const treg_rcx = 1
const treg_rdx = 2
const treg_rsp = 4
const treg_rsi = 6
const treg_rdi = 7
const treg_r8 = 8
const treg_r9 = 9
const treg_r10 = 10
const treg_r11 = 11
const treg_xmm0 = 16
const treg_xmm1 = 17
const treg_xmm2 = 18
const treg_xmm3 = 19
const treg_xmm4 = 20
const treg_xmm5 = 21
const treg_xmm6 = 22
const treg_xmm7 = 23
const treg_st0 = 24
const treg_mem = 32

// skipping global dup "func_bound_add_epilog"
fn g(c int) {
	ind1 := 0
	if nocode_wanted {
		return
	}
	ind1 = ind + 1
	if ind1 > tcc_state.cur_text_section.data_allocated {
		section_realloc(tcc_state.cur_text_section, ind1)
	}
	tcc_state.cur_text_section.data[ind] = c
	ind = ind1
}

fn o(c u32) {
	for c {
		g(c)
		c = c >> 8
	}
}

fn gen_le16(v int) {
	g(v)
	g(v >> 8)
}

fn gen_le32(c int) {
	g(c)
	g(c >> 8)
	g(c >> 16)
	g(c >> 24)
}

fn gen_le64(c i64) {
	g(c)
	g(c >> 8)
	g(c >> 16)
	g(c >> 24)
	g(c >> 32)
	g(c >> 40)
	g(c >> 48)
	g(c >> 56)
}

fn orex(ll int, r int, r2 int, b int) {
	if (r & 63) >= 48 {
		r = 0
	}
	if (r2 & 63) >= 48 {
		r2 = 0
	}
	if ll || (r >> 3) & 1 || (r2 >> 3) & 1 {
		o(64 | ((r >> 3) & 1) | (((r2 >> 3) & 1) << 2) | (ll << 3))
	}
	o(b)
}

fn gsym_addr(t int, a int) {
	for t {
		ptr := tcc_state.cur_text_section.data + t
		n := read32le(ptr)
		write32le(ptr, if a < 0 { -a } else { a - t - 4 })
		t = n
	}
}

fn is64_type(t int) bool {
	return (t & 15) == 5 || (t & 15) == 6 || (t & 15) == 4
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

fn gen_addr32(r int, sym &Sym, c int) {
	if r & vt_sym {
		greloca(tcc_state.cur_text_section, sym, ind, 11, c)
		c = 0
	}
	gen_le32(c)
}

fn gen_addr64(r int, sym &Sym, c i64) {
	if r & vt_sym {
		greloca(tcc_state.cur_text_section, sym, ind, 1, c)
		c = 0
	}
	gen_le64(c)
}

fn gen_addrpc32(r int, sym &Sym, c int) {
	if r & vt_sym {
		greloca(tcc_state.cur_text_section, sym, ind, 2, c - 4)
		c = 4
	}
	gen_le32(c - 4)
}

fn gen_gotpcrel(r int, sym &Sym, c int) {
	greloca(tcc_state.cur_text_section, sym, ind, 9, -4)
	gen_le32(0)
	if c {
		orex(1, r, 0, 129)
		o(192 + (r & 7))
		gen_le32(c)
	}
}

fn gen_modrm_impl(op_reg int, r int, sym &Sym, c int, is_got int) {
	op_reg = (op_reg & 7) << 3
	if (r & 63) == 48 {
		if !(r & 512) {
			o(4 | op_reg)
			oad(37, c)
		} else {
			o(5 | op_reg)
			if is_got {
				gen_gotpcrel(r, sym, c)
			} else {
				gen_addrpc32(r, sym, c)
			}
		}
	} else if (r & 63) == 50 {
		if c == i8(c) {
			o(69 | op_reg)
			g(c)
		} else {
			oad(133 | op_reg, c)
		}
	} else if (r & 63) >= treg_mem {
		if c {
			g(128 | op_reg | (r & 7))
			gen_le32(c)
		} else {
			g(0 | op_reg | (r & 7))
		}
	} else {
		g(0 | op_reg | (r & 7))
	}
}

fn gen_modrm(op_reg int, r int, sym &Sym, c int) {
	gen_modrm_impl(op_reg, r, sym, c, 0)
}

fn gen_modrm64(opcode int, op_reg int, r int, sym &Sym, c int) {
	is_got := 0
	is_got = op_reg & treg_mem && !(sym.type_.t & 8192)
	orex(1, r, op_reg, opcode)
	gen_modrm_impl(op_reg, r, sym, c, is_got)
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
	if u64(fc) != sv.c.i && fr & 512 {
		_tcc_error('64 bit addend in load')
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
		if u64(fc) != sv.c.i {
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
					_tcc_error('invalid aggregate type for register load')
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
			b = 219
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
		} else if (ft & (~((4096 | 8192 | 16384 | 32768) | (((1 << (6 + 6)) - 1) << 20 | 128)))) == (0) {
			return
		} else {
			assert (ft & 15) == 3 || (ft & 15) == 4 || (ft & 15) == 5 || (ft & 15) == 6
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
					assert if (v >= treg_xmm0 && v <= treg_xmm7) {
						true
					} else {
						false
					}
					if (ft & 15) == 8 {
						o(1052659)
					} else {
						assert if ((ft & 15) == 9) {
							true
						} else {
							false
						}
						o(1052658)
					}
					o(192 + (v & 7) + (r & 7) * 8)
				}
			} else if r == treg_st0 {
				assert if (v >= treg_xmm0 && v <= treg_xmm7) {
					true
				} else {
					false
				}
				o(1118194)
				o(68 + (r & 7) * 8)
				o(61476)
				o(4028908765)
			} else {
				orex(is64_type(ft), r, v, 137)
				o(192 + (r & 7) + (v & 7) * 8)
			}
		}
	}
}

fn store(r int, v &SValue) {
	fr := 0
	bt := 0
	ft := 0
	fc := u64(0)

	op64 := 0
	pic := 0
	fr = v.r & 63
	ft = v.type_.t
	fc = v.c.i
	if fc != v.c.i && fr & 512 {
		_tcc_error('64 bit addend in store')
	}
	ft &= ~(512 | 256)
	bt = ft & 15
	if fr == 48 && v.r & 512 && !(v.sym.type_.t & 8192) {
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
			orex(1, fr, r, op64)
			o(192 + fr + r * 8)
		}
	} else {
		if fr == 48 || fr == 50 || v.r & 256 {
			gen_modrm(r, v.r, v.sym, fc)
		} else if fr != r {
			o(192 + fr + r * 8)
		}
	}
}

fn gcall_or_jmp(is_jmp int) {
	r := 0
	if (vtop.r & (63 | 256)) == 48 && (vtop.r & 512 && (vtop.c.i - 4) == (vtop.c.i - 4)) {
		greloca(tcc_state.cur_text_section, vtop.sym, ind + 1, 4, int((vtop.c.i - 4)))
		oad(232 + is_jmp, 0)
	} else {
		r = treg_r11
		load(r, vtop)
		o(65)
		o(255)
		o(208 + (r & 7) + (is_jmp << 4))
	}
}

fn gen_bounds_call(v int) {
	sym := external_helper_sym(v)
	oad(232, 0)
	greloca(tcc_state.cur_text_section, sym, ind - 4, 4, -4)
}

fn gen_bounds_prolog() {
	func_bound_offset = tcc_state.lbounds_section.data_offset
	func_bound_ind = ind
	func_bound_add_epilog = 0
	t := u64(treg_rdi == treg_rdi)
	t *= 3145728
	o(888136 + t)
	gen_le32(0)
	oad(184, 0)
}

fn gen_bounds_epilog() {
	saved_ind := Elf64_Addr(0)
	bounds_ptr := &Elf64_Addr(0)
	sym_data := &Sym(0)
	offset_modified := func_bound_offset != tcc_state.lbounds_section.data_offset
	if !offset_modified && !func_bound_add_epilog {
		return
	}
	bounds_ptr = section_ptr_add(tcc_state.lbounds_section, sizeof(Elf64_Addr))
	*bounds_ptr = 0
	sym_data = get_sym_ref(&char_pointer_type, tcc_state.lbounds_section, func_bound_offset,
		8)
	if offset_modified {
		saved_ind = ind
		ind = func_bound_ind
		greloca(tcc_state.cur_text_section, sym_data, ind + 3, 2, -4)
		ind = ind + 7
		gen_bounds_call(Tcc_token.tok___bound_local_new)
		ind = saved_ind
	}
	o(21072)
	o(552371016)
	o(10511)
	o(1057860)
	o(604776719)
	greloca(tcc_state.cur_text_section, sym_data, ind + 3, 2, -4)
	o(888136 + (int(treg_rdi == treg_rdi) * 3145728))
	gen_le32(0)
	gen_bounds_call(Tcc_token.tok___bound_local_delete)
	o(10255)
	o(1057860)
	o(604776463)
	o(549749576)
	o(22618)
}

fn gadd_sp(val int) {
	if val == i8(val) {
		o(12878664)
		g(val)
	} else {
		oad(12878152, val)
	}
}

enum X86_64_Mode {
	x86_64_mode_none
	x86_64_mode_memory
	x86_64_mode_integer
	x86_64_mode_sse
	x86_64_mode_x87
}

fn classify_x86_64_merge(a X86_64_Mode, b X86_64_Mode) X86_64_Mode {
	if a == b {
		return a
	} else if a == X86_64_Mode.x86_64_mode_none {
		return b
	} else if b == X86_64_Mode.x86_64_mode_none {
		return a
	} else if a == X86_64_Mode.x86_64_mode_memory || b == X86_64_Mode.x86_64_mode_memory {
		return X86_64_Mode.x86_64_mode_memory
	} else if a == X86_64_Mode.x86_64_mode_integer || b == X86_64_Mode.x86_64_mode_integer {
		return X86_64_Mode.x86_64_mode_integer
	} else if a == X86_64_Mode.x86_64_mode_x87 || b == X86_64_Mode.x86_64_mode_x87 {
		return X86_64_Mode.x86_64_mode_memory
	} else {
		return X86_64_Mode.x86_64_mode_sse
	}
}

fn classify_x86_64_inner(ty &CType) X86_64_Mode {
	mode := X86_64_Mode{}
	f := &Sym(0)
	match ty.t & 15 {
		0 { // case comp body kind=ReturnStmt is_enum=false
			return X86_64_Mode.x86_64_mode_none
		}
		3, 1, 2, 4, 11, 5, 6 {
			return X86_64_Mode.x86_64_mode_integer
		}
		8, 9 {
			return X86_64_Mode.x86_64_mode_sse
		}
		10 { // case comp body kind=ReturnStmt is_enum=false
			return X86_64_Mode.x86_64_mode_x87
		}
		7 { // case comp body kind=BinaryOperator is_enum=false
			f = ty.ref
			mode = X86_64_Mode.x86_64_mode_none
			for f = f.next; f; f = f.next {
				mode = classify_x86_64_merge(mode, classify_x86_64_inner(&f.type_))
			}
			return mode
		}
		else {}
	}
	assert false
	return X86_64_Mode.x86_64_mode_none
}

fn classify_x86_64_arg(ty &CType, ret &CType, psize &int, palign &int, reg_count &int) X86_64_Mode {
	mode := X86_64_Mode{}
	size := 0
	align := 0
	ret_t := 0

	if ty.t & (128 | 64) {
		*psize = 8
		*palign = 8
		*reg_count = 1
		ret_t = ty.t
		mode = X86_64_Mode.x86_64_mode_integer
	} else {
		size = type_size(ty, &align)
		*psize = (size + 7) & ~7
		*palign = (align + 7) & ~7
		*reg_count = 0
		if size > 16 {
			mode = X86_64_Mode.x86_64_mode_memory
		} else {
			mode = classify_x86_64_inner(ty)
			match mode {
				.x86_64_mode_integer { // case comp body kind=IfStmt is_enum=true
					if size > 8 {
						*reg_count = 2
						ret_t = 13
					} else {
						*reg_count = 1
						if size > 4 {
							ret_t = 4
						} else if size > 2 {
							ret_t = 3
						} else if size > 1 {
							ret_t = 2
						} else { // 3
							ret_t = 1
						}
						if (ty.t & 15) == 7 || ty.t & 16 {
							ret_t |= 16
						}
					}
				}
				.x86_64_mode_x87 { // case comp body kind=BinaryOperator is_enum=true
					*reg_count = 1
					ret_t = 10
				}
				.x86_64_mode_sse { // case comp body kind=IfStmt is_enum=true
					if size > 8 {
						*reg_count = 2
						ret_t = 14
					} else {
						*reg_count = 1
						ret_t = if (size > 4) { 9 } else { 8 }
					}
				}
				else {}
			}
		}
	}
	if ret {
		ret.ref = (unsafe { nil })
		ret.t = ret_t
	}
	return mode
}

enum ClassifyVaArg {
	__va_gen_reg
	__va_float_reg
	__va_stack
}

fn classify_x86_64_va_arg(ty &CType) ClassifyVaArg {
	size := 0
	align := 0
	reg_count := 0

	mode := classify_x86_64_arg(ty, (unsafe { nil }), &size, &align, &reg_count)
	match mode {
		.x86_64_mode_integer { // case comp body kind=ReturnStmt is_enum=true
			return ClassifyVaArg.__va_gen_reg
		}
		.x86_64_mode_sse { // case comp body kind=ReturnStmt is_enum=true
			return ClassifyVaArg.__va_float_reg
		}
		else {
			return ClassifyVaArg.__va_stack
		}
	}
}

fn gfunc_sret(vt &CType, variadic int, ret &CType, ret_align &int, regsize &int) int {
	size := 0
	align := 0
	reg_count := 0

	if classify_x86_64_arg(vt, ret, &size, &align, &reg_count) == X86_64_Mode.x86_64_mode_memory {
		return 0
	}
	*ret_align = 1
	*regsize = 8 * reg_count
	return 1
}

const arg_regs = [treg_rdi, treg_rsi, treg_rdx, treg_rcx, treg_r8, treg_r9]!

fn arg_prepare_reg(idx int) int {
	if idx == 2 || idx == 3 {
		return idx + 8
	} else {
		return if idx >= 0 && idx < 6 { arg_regs[idx] } else { 0 }
	}
}

fn gfunc_call(nb_args int) {
	vcc_trace_print('${@LOCATION}')
	mode := X86_64_Mode{}
	type_ := CType{}
	size := 0
	align := 0
	r := 0
	args_size := 0
	stack_adjust := 0
	i := 0
	reg_count := 0
	k := 0

	nb_reg_args := 0
	nb_sse_args := 0
	sse_reg := 0
	gen_reg := 0

	onstack := &char(tcc_malloc((nb_args + 1) * sizeof(char)))
	if tcc_state.do_bounds_check {
		vcc_trace_print('${@LOCATION} 1')
		gbound_args(nb_args)
	}
	stack_adjust = 0
	for i = nb_args - 1; i >= 0; i-- {
		vcc_trace_print('${@LOCATION} 2')
		mode = classify_x86_64_arg(&vtop[-i].type_, unsafe { nil }, &size, &align, &reg_count)
		if size == 0 {
			continue
		}
		if mode == X86_64_Mode.x86_64_mode_sse && nb_sse_args + reg_count <= 8 {
			nb_sse_args += reg_count
			onstack[i] = 0
		} else if mode == X86_64_Mode.x86_64_mode_integer && nb_reg_args + reg_count <= 6 {
			nb_reg_args += reg_count
			onstack[i] = 0
		} else if mode == X86_64_Mode.x86_64_mode_none {
			onstack[i] = 0
		} else {
			stack_adjust &= 15
			if align == 16 && stack_adjust {
				onstack[i] = 2
				stack_adjust = 0
			} else { // 3
				onstack[i] = 1
			}
			stack_adjust += size
		}
	}
	if nb_sse_args && tcc_state.nosse {
		_tcc_error('SSE disabled but floating point arguments passed')
	}
	if (vtop.r & 63) == 51 {
		vcc_trace_print('${@LOCATION} 3')
		gv(1)
	}
	gen_reg = nb_reg_args
	sse_reg = nb_sse_args
	args_size = 0
	stack_adjust &= 15
	i = 0
	for k = i; i < nb_args; {
		vcc_trace_print('${@LOCATION} 4')
		mode = classify_x86_64_arg(&vtop[-i].type_, unsafe { nil }, &size, &align, &reg_count)
		vcc_trace_print('${@LOCATION} size=${size}')
		if size {
			vcc_trace_print('${@LOCATION} onstack=${i + k}')
			if !onstack[i + k] {
				i++
				continue
			}
			if stack_adjust {
				vcc_trace_print('${@LOCATION} stack_adjust')
				o(80)
				args_size += 8
				stack_adjust = 0
			}
			if onstack[i + k] == 2 {
				stack_adjust = 1
			}
		}
		vcc_trace_print('${@LOCATION} vrob.1')
		vrotb(i + 1)
		vcc_trace_print('${@LOCATION} vrob.2')
		match vtop.type_.t & 15 {
			7 { // case comp body kind=CallExpr is_enum=false
				o(72)
				oad(60545, size)
				r = get_reg(1)
				orex(1, r, 0, 137)
				o(224 + (r & 7))
				vset(&vtop.type_, r | 256, 0)
				vswap()
				o(283935560)
				o(4041507656)
				orex(0, r, 0, 80 + (r & 7))
				o(149717832)
				vstore()
				o(147096392)
				o(92)
			}
			10 { // case comp body kind=CallExpr is_enum=false
				gv(128)
				oad(15499592, size)
				o(31963)
				g(36)
				g(0)
			}
			8, 9 {
				assert mode == X86_64_Mode.x86_64_mode_sse
				r = gv(2)
				o(80)
				o(14028646)
				o(4 + (r & 7) * 8)
				o(36)
			}
			else {
				assert mode == X86_64_Mode.x86_64_mode_integer
				r = gv(1)
				orex(0, r, 0, 80 + (r & 7))
			}
		}
		args_size += size
		vpop()
		nb_args--
		k++
	}
	vcc_trace_print('${@LOCATION} 20')
	tcc_free(onstack)
	vcc_trace_print('${@LOCATION} 21')
	save_regs(0)
	assert gen_reg <= 6
	assert sse_reg <= 8
	for i = 0; i < nb_args; i++ {
		vcc_trace_print('${@LOCATION} 30')
		mode = classify_x86_64_arg(&vtop.type_, &type_, &size, &align, &reg_count)
		if size == 0 {
			continue
		}
		vtop.type_ = type_
		if mode == X86_64_Mode.x86_64_mode_sse {
			vcc_trace_print('${@LOCATION} 22')
			if reg_count == 2 {
				sse_reg -= 2
				gv(4096)
				if sse_reg {
					o(10255)
					o(193 + ((sse_reg + 1) << 3))
					o(10255)
					o(192 + (sse_reg << 3))
				}
			} else {
				vcc_trace_print('${@LOCATION} 23')
				assert reg_count == 1
				sse_reg--
				gv(4096 << sse_reg)
			}
		} else if mode == X86_64_Mode.x86_64_mode_integer {
			vcc_trace_print('${@LOCATION} 24')
			d := 0
			gen_reg -= reg_count
			r = gv(1)
			d = arg_prepare_reg(gen_reg)
			orex(1, d, r, 137)
			o(192 + (r & 7) * 8 + (d & 7))
			if reg_count == 2 {
				d = arg_prepare_reg(gen_reg + 1)
				orex(1, d, vtop.r2, 137)
				o(192 + ((vtop.r2) & 7) * 8 + (d & 7))
			}
		}
		unsafe { vtop-- }
	}
	vcc_trace_print('${@LOCATION} 25')
	assert gen_reg == 0
	assert sse_reg == 0
	save_regs(0)
	if nb_reg_args > 2 {
		o(13797708)
		if nb_reg_args > 3 {
			o(14256460)
		}
	}
	if vtop.type_.ref.f.func_type != 1 {
		oad(184, if nb_sse_args < 8 { nb_sse_args } else { 8 })
	}
	gcall_or_jmp(0)
	if args_size {
		gadd_sp(args_size)
	}
	unsafe { vtop-- }
	vcc_trace_print('${@LOCATION} end')
}

fn push_arg_reg(i int) {
	loc -= 8
	gen_modrm64(137, arg_regs[i], 50, (unsafe { nil }), loc)
}

fn gfunc_prolog(func_sym &Sym) {
	func_type := &func_sym.type_
	mode := X86_64_Mode{}
	ret_mode := X86_64_Mode{}

	i := 0
	addr := 0
	align := 0
	size := 0
	reg_count := 0

	param_addr := 0
	reg_param_index := 0
	sse_param_index := 0

	sym := &Sym(0)
	type_ := &CType(0)
	sym = func_type.ref
	addr = 8 * 2
	loc = 0
	ind += 11
	func_sub_sp_offset = ind
	func_ret_sub = 0
	ret_mode = classify_x86_64_arg(&func_vt, (unsafe { nil }), &size, &align, &reg_count)
	if func_var {
		seen_reg_num := 0
		seen_sse_num := 0
		seen_stack_size := 0

		seen_reg_num = ret_mode == X86_64_Mode.x86_64_mode_memory
		seen_sse_num = 0
		seen_stack_size = 8 * 2
		sym = func_type.ref
		sym = sym.next
		for sym != unsafe { nil } {
			type_ = &sym.type_
			mode = classify_x86_64_arg(type_, (unsafe { nil }), &size, &align, &reg_count)
			match mode {
				.x86_64_mode_integer { // case comp body kind=IfStmt is_enum=true
					if seen_reg_num + reg_count > 6 {
						goto stack_arg // id: 0x7fffc8c1eaa0
					}
					seen_reg_num += reg_count
				}
				.x86_64_mode_sse { // case comp body kind=IfStmt is_enum=true
					if seen_sse_num + reg_count > 8 {
						goto stack_arg // id: 0x7fffc8c1eaa0
					}
					seen_sse_num += reg_count
				}
				else {
					stack_arg:
					seen_stack_size = ((seen_stack_size + align - 1) & -align) + size
				}
			}
			sym = sym.next
		}
		loc -= 24
		o(15222215)
		gen_le32(seen_reg_num * 8)
		o(15484359)
		gen_le32(seen_sse_num * 16 + 48)
		o(10325324)
		gen_le32(seen_stack_size)
		o(4032661836)
		o(10325324)
		gen_le32(-176 - 24)
		o(4166879564)
		for i = 0; i < 8; i++ {
			loc -= 16
			if !tcc_state.nosse {
				o(14028646)
				gen_modrm(7 - i, 50, (unsafe { nil }), loc)
			}
			o(8767304)
			gen_le32(loc + 8)
			gen_le32(0)
		}
		for i = 0; i < 6; i++ {
			push_arg_reg(6 - 1 - i)
		}
	}
	sym = func_type.ref
	reg_param_index = 0
	sse_param_index = 0
	if ret_mode == X86_64_Mode.x86_64_mode_memory {
		push_arg_reg(reg_param_index)
		func_vc = loc
		reg_param_index++
	}
	sym = sym.next
	for sym != (unsafe { nil }) {
		type_ = &sym.type_
		mode = classify_x86_64_arg(type_, (unsafe { nil }), &size, &align, &reg_count)
		match mode {
			.x86_64_mode_sse { // case comp body kind=IfStmt is_enum=true
				if tcc_state.nosse {
					_tcc_error('SSE disabled but floating point arguments used')
				}
				if sse_param_index + reg_count <= 8 {
					loc -= reg_count * 8
					param_addr = loc
					for i = 0; i < reg_count; i++ {
						o(14028646)
						gen_modrm(sse_param_index, 50, (unsafe { nil }), param_addr + i * 8)
						sse_param_index++
					}
				} else {
					addr = (addr + align - 1) & -align
					param_addr = addr
					addr += size
				}
			}
			.x86_64_mode_memory, .x86_64_mode_x87 {
				addr = (addr + align - 1) & -align
				param_addr = addr
				addr += size
			}
			.x86_64_mode_integer {
				// case comp stmt
				if reg_param_index + reg_count <= 6 {
					loc -= reg_count * 8
					param_addr = loc
					for i = 0; i < reg_count; i++ {
						gen_modrm64(137, arg_regs[reg_param_index], 50, (unsafe { nil }),
							param_addr + i * 8)
						reg_param_index++
					}
				} else {
					addr = (addr + align - 1) & -align
					param_addr = addr
					addr += size
				}
			}
			else {}
		}
		sym_push(sym.v & ~536870912, type_, 50 | 256, param_addr)
		sym = sym.next
	}
	if tcc_state.do_bounds_check {
		gen_bounds_prolog()
	}
}

fn gfunc_epilog() {
	v := 0
	saved_ind := 0

	if tcc_state.do_bounds_check {
		gen_bounds_epilog()
	}
	o(201)
	if func_ret_sub == 0 {
		o(195)
	} else {
		o(194)
		g(func_ret_sub)
		g(func_ret_sub >> 8)
	}
	v = (-loc + 15) & -16
	saved_ind = ind
	ind = func_sub_sp_offset - 11
	o(3850979413)
	o(15499592)
	gen_le32(v)
	ind = saved_ind
}

pub fn gen_fill_nops(bytes int) {
	for bytes-- {
		g(144)
	}
}

fn gjmp(t int) int {
	return oad(233, t)
}

fn gjmp_addr(a int) {
	r := 0
	r = a - ind - 2
	if r == i8(r) {
		g(235)
		g(r)
	} else {
		oad(233, a - ind - 5)
	}
}

fn gjmp_append(n int, t int) int {
	p := unsafe { nil }
	if n {
		n1 := n
		n2 := u32(0)

		p = tcc_state.cur_text_section.data + n1
		n2 = read32le(p)
		for n2 {
			n1 = n2
			p = tcc_state.cur_text_section.data + n1
			n2 = read32le(p)
		}
		write32le(p, t)
		t = n
	}
	return t
}

fn gjmp_cond(op int, t int) int {
	if op & 256 {
		v := vtop.cmp_r
		op &= ~256
		if op ^ v ^ (v != 149) {
			o(1658)
		} else {
			g(15)
			t = oad(138, t)
		}
	}
	g(15)
	t = oad(op - 16, t)
	return t
}

fn gen_opi(op int) {
	r := 0
	fr := 0
	opc := 0
	c := 0

	ll := 0
	uu := 0
	cc := 0

	ll = is64_type(vtop[-1].type_.t)
	uu = (vtop[-1].type_.t & 16) != 0
	cc = (vtop.r & (63 | 256 | 512)) == 48
	match op {
		int(`+`), 135 {
			opc = 0
			gen_op8:
			if cc && (!ll || int(vtop.c.i) == int(vtop.c.i)) {
				vswap()
				r = gv(1)
				vswap()
				c = vtop.c.i
				if c == char(c) {
					orex(ll, r, 0, 131)
					o(192 | (opc << 3) | (r & 7))
					g(c)
				} else {
					orex(ll, r, 0, 129)
					oad(192 | (opc << 3) | (r & 7), c)
				}
			} else {
				gv2(1, 1)
				r = vtop[-1].r
				fr = vtop[0].r
				orex(ll, r, fr, (opc << 3) | 1)
				o(192 + (r & 7) + (fr & 7) * 8)
			}
			unsafe { vtop-- }
			if op >= 146 && op <= 159 {
				vset_vt_cmp(op)
			}
		}
		int(`-`), 137 {
			opc = 5
			goto gen_op8 // id: 0x7fffc8c27fb0
		}
		136 { // case comp body kind=BinaryOperator is_enum=false
			opc = 2
			goto gen_op8 // id: 0x7fffc8c27fb0
		}
		138 { // case comp body kind=BinaryOperator is_enum=false
			opc = 3
			goto gen_op8 // id: 0x7fffc8c27fb0
		}
		int(`&`) { // case comp body kind=BinaryOperator is_enum=false
			opc = 4
			goto gen_op8 // id: 0x7fffc8c27fb0
		}
		int(`^`) { // case comp body kind=BinaryOperator is_enum=false
			opc = 6
			goto gen_op8 // id: 0x7fffc8c27fb0
		}
		int(`|`) { // case comp body kind=BinaryOperator is_enum=false
			opc = 1
			goto gen_op8 // id: 0x7fffc8c27fb0
		}
		int(`*`) { // case comp body kind=CallExpr is_enum=false
			gv2(1, 1)
			r = vtop[-1].r
			fr = vtop[0].r
			orex(ll, fr, r, 44815)
			o(192 + (fr & 7) + (r & 7) * 8)
			unsafe { vtop-- }
		}
		int(`<`) { // case comp body kind=BinaryOperator is_enum=false
			opc = 4
			goto gen_shift // id: 0x7fffc8c28f80
		}
		139 { // case comp body kind=BinaryOperator is_enum=false
			opc = 5
			goto gen_shift // id: 0x7fffc8c28f80
		}
		int(`>`) { // case comp body kind=BinaryOperator is_enum=false
			opc = 7
			gen_shift:
			opc = 192 | (opc << 3)
			if cc {
				vswap()
				r = gv(1)
				vswap()
				orex(ll, r, 0, 193)
				o(opc | (r & 7))
				t := vtop.c.i
				t &= if ll { 63 } else { 31 }
				g(t)
			} else {
				gv2(1, 16)
				r = vtop[-1].r
				orex(ll, r, 0, 211)
				o(opc | (r & 7))
			}
			unsafe { vtop-- }
		}
		131, 132 {
			uu = 1
			goto divmod // id: 0x7fffc8c2a020
		}
		int(`/`), int(`%`), 133 {
			uu = 0
			// RRRREG divmod id=0x7fffc8c2a020
			divmod:
			gv2(4, 16)
			r = vtop[-1].r
			fr = vtop[0].r
			unsafe { vtop-- }
			save_reg(treg_rdx)
			orex(ll, 0, 0, if uu { 53809 } else { 153 })
			orex(ll, fr, 0, 247)
			o((if uu { 240 } else { 248 }) + (fr & 7))
			if op == `%` || op == 132 {
				r = treg_rdx
			} else { // 3
				r = treg_rax
			}
			vtop.r = r
		}
		else {
			opc = 7
			goto gen_op8
		}
	}
}

fn gen_opl(op int) {
	gen_opi(op)
}

fn vpush_const(t int, v int) {
	ctype := CType{
		t: t | 256
		ref: unsafe { nil }
	}

	vpushsym(&ctype, external_global_sym(v, &ctype))
	vtop.r |= 256
}

fn gen_opf(op int) {
	vcc_trace_print('${@LOCATION} ${op} ${file.truefilename.vstring()}')
	a := 0
	ft := 0
	fc := 0
	swapped := 0
	r := 0

	bt := vtop.type_.t & 15
	float_type := if bt == 10 { 128 } else { 2 }
	if op == 129 {
		gv(float_type)
		if float_type == 128 {
			o(57561)
		} else {
			vpush_const(bt, if bt == 8 { Tcc_token.tok___mzerosf } else { Tcc_token.tok___mzerodf })
			gv(2)
			if bt == 9 {
				o(102)
			}
			o(12605199 | (((vtop[0].r) & 7) + ((vtop[-1].r) & 7) * 8) << 16)
			unsafe { vtop-- }
		}
		return
	}
	if (vtop[-1].r & (vt_valmask | vt_lval)) == vt_const {
		vswap()
		gv(float_type)
		vswap()
	}
	if (vtop[0].r & (vt_valmask | vt_lval)) == vt_const {
		gv(float_type)
	}
	if vtop[-1].r & vt_lval && vtop[0].r & vt_lval {
		vswap()
		gv(float_type)
		vswap()
	}
	swapped = 0
	if vtop[-1].r & vt_lval {
		vswap()
		swapped = 1
	}
	if (vtop.type_.t & vt_btype) == vt_ldouble {
		if op >= 146 && op <= 159 {
			load(treg_st0, vtop)
			save_reg(treg_rax)
			if op == 157 || op == 159 {
				swapped = !swapped
			} else if op == 148 || op == 149 {
				swapped = 0
			}
			if swapped {
				o(51673)
			}
			if op == 148 || op == 149 {
				o(59866)
			} else { // 3
				o(55774)
			}
			o(57567)
			if op == 148 {
				o(4580480)
				o(4258944)
			} else if op == 149 {
				o(4580480)
				o(4256896)
				op = 149
			} else if op == 157 || op == 158 {
				o(378102)
				op = 148
			} else {
				o(4572406)
				op = 148
			}
			unsafe { vtop-- }
			vset_vt_cmp(op)
		} else {
			load(treg_st0, vtop)
			swapped = !swapped
			match rune(op) {
				`-` { // case comp body kind=BinaryOperator is_enum=false
					a = 4
					if swapped {
						a++
					}
				}
				`*` { // case comp body kind=BinaryOperator is_enum=false
					a = 1
				}
				`/` { // case comp body kind=BinaryOperator is_enum=false
					a = 6
					if swapped {
						a++
					}
				}
				`+` { // case comp body kind=BinaryOperator is_enum=false
					a = 0
				}
				else {}
			}
			ft = vtop.type_.t
			fc = vtop.c.i
			o(222)
			o(193 + (a << 3))
			unsafe { vtop-- }
		}
	} else {
		if op >= 146 && op <= 159 {
			r = vtop.r
			fc = vtop.c.i
			if (r & 63) == 49 {
				v1 := SValue{}
				r = get_reg(1)
				v1.type_.t = vt_ptr
				v1.r = vt_local | vt_lval
				v1.c.i = fc
				load(r, &v1)
				fc = 0
				r = r | vt_lval
				vtop.r = r
			}
			if op == 148 || op == 149 {
				swapped = 0
			} else {
				if op == 158 || op == 156 {
					swapped = !swapped
				}
				if op == 158 || op == 157 {
					op = 147
				} else {
					op = 151
				}
			}
			if swapped {
				gv(2)
				vswap()
			}
			assert !bool(vtop[-1].r & 256)
			if (vtop.type_.t & 15) == 9 {
				o(102)
			}
			if op == 148 || op == 149 {
				o(11791)
			} else { // 3
				o(12047)
			}
			if vtop.r & 256 {
				gen_modrm(vtop[-1].r, r, vtop.sym, fc)
			} else {
				o(192 + ((vtop[0].r) & 7) + ((vtop[-1].r) & 7) * 8)
			}
			unsafe { vtop-- }
			vset_vt_cmp(op | 256)
			vtop.cmp_r = op
		} else {
			assert (vtop.type_.t & vt_btype) != vt_ldouble
			match rune(op) {
				`-` { // case comp body kind=BinaryOperator is_enum=false
					a = 4
				}
				`*` { // case comp body kind=BinaryOperator is_enum=false
					a = 1
				}
				`/` { // case comp body kind=BinaryOperator is_enum=false
					a = 6
				}
				`+` { // case comp body kind=BinaryOperator is_enum=false
					a = 0
				}
				else {}
			}
			ft = vtop.type_.t
			fc = vtop.c.i
			assert (ft & vt_btype) != vt_ldouble
			r = vtop.r
			if (vtop.r & vt_valmask) == vt_llocal {
				v1 := SValue{}
				r = get_reg(1)
				v1.type_.t = vt_ptr
				v1.r = vt_local | vt_lval
				v1.c.i = fc
				load(r, &v1)
				fc = 0
				r = r | vt_lval
				vtop.r = r
			}
			assert !bool(vtop[-1].r & vt_lval)
			if swapped {
				assert bool(vtop.r & vt_lval)
				gv(2)
				vswap()
				fc = vtop.c.i
			}
			if (ft & 15) == 9 {
				o(242)
			} else {
				o(243)
			}
			o(15)
			o(88 + a)
			if vtop.r & 256 {
				gen_modrm(vtop[-1].r, r, vtop.sym, fc)
			} else {
				o(192 + ((vtop[0].r) & 7) + ((vtop[-1].r) & 7) * 8)
			}
			unsafe { vtop-- }
		}
	}
}

fn gen_cvt_itof(t int) {
	if (t & 15) == 10 {
		save_reg(treg_st0)
		gv(1)
		if (vtop.type_.t & 15) == 4 {
			o(80 + (vtop.r & 63))
			o(2370783)
			o(147096392)
		} else if (vtop.type_.t & (15 | 16)) == (3 | 16) {
			o(106)
			g(0)
			o(80 + (vtop.r & 63))
			o(2370783)
			o(281314120)
		} else {
			o(80 + (vtop.r & 63))
			o(2360539)
			o(147096392)
		}
		vtop.r = treg_st0
	} else {
		r := get_reg(2)
		gv(1)
		o(242 + (if (t & 15) == 8 { 1 } else { 0 }))
		if (vtop.type_.t & (15 | 16)) == (3 | 16) || (vtop.type_.t & 15) == 4 {
			o(72)
		}
		o(10767)
		o(192 + (vtop.r & 63) + (r & 7) * 8)
		vtop.r = r
	}
}

fn gen_cvt_ftof(t int) {
	ft := 0
	bt := 0
	tbt := 0

	ft = vtop.type_.t
	bt = ft & 15
	tbt = t & 15
	if bt == 8 {
		gv(2)
		if tbt == 9 {
			o(5135)
			o(192 + ((vtop.r) & 7) * 9)
			o(23055)
			o(192 + ((vtop.r) & 7) * 9)
		} else if tbt == 10 {
			save_reg(128)
			o(1118195)
			o(68 + ((vtop.r) & 7) * 8)
			o(61476)
			o(4028908761)
			vtop.r = treg_st0
		}
	} else if bt == 9 {
		gv(2)
		if tbt == 8 {
			o(1314662)
			o(192 + ((vtop.r) & 7) * 9)
			o(5902182)
			o(192 + ((vtop.r) & 7) * 9)
		} else if tbt == 10 {
			save_reg(128)
			o(1118194)
			o(68 + ((vtop.r) & 7) * 8)
			o(61476)
			o(4028908765)
			vtop.r = treg_st0
		}
	} else {
		r := 0
		gv(128)
		r = get_reg(2)
		if tbt == 9 {
			o(4028914909)
			o(1052658)
			o(68 + (r & 7) * 8)
			o(61476)
			vtop.r = r
		} else if tbt == 8 {
			o(4028914905)
			o(1052659)
			o(68 + (r & 7) * 8)
			o(61476)
			vtop.r = r
		}
	}
}

fn gen_cvt_ftoi(t int) {
	ft := 0
	bt := 0
	size := 0
	r := 0

	ft = vtop.type_.t
	bt = ft & 15
	if bt == 10 {
		gen_cvt_ftof(9)
		bt = 9
	}
	gv(2)
	if t != 3 {
		size = 8
	} else { // 3
		size = 4
	}
	r = get_reg(1)
	if bt == 8 {
		o(243)
	} else if bt == 9 {
		o(242)
	} else {
		assert false
	}
	orex(size == 8, r, 0, 11279)
	o(192 + ((vtop.r) & 7) + (r & 7) * 8)
	vtop.r = r
}

fn gen_cvt_sxtw() {
	r := gv(1)
	o(25416)
	o(192 + ((r & 7) << 3) + (r & 7))
}

fn gen_cvt_csti(t int) {
	r := 0
	sz := 0
	xl := 0
	ll := 0

	r = gv(1)
	sz = !(t & 16)
	xl = (t & 15) == 2
	ll = (vtop.type_.t & 15) == 4
	orex(ll, r, 0, 12629519 | (sz << 3 | xl) << 8 | ((r & 7) << 3 | (r & 7)) << 16)
}

fn gen_increment_tcov(sv &SValue) {
	o(361288)
	greloca(tcc_state.cur_text_section, sv.sym, ind, 2, -5)
	gen_le32(0)
	o(1)
}

fn ggoto() {
	gcall_or_jmp(1)
	unsafe { vtop-- }
}

fn gen_vla_sp_save(addr int) {
	gen_modrm64(137, treg_rsp, 50, (unsafe { nil }), addr)
}

fn gen_vla_sp_restore(addr int) {
	gen_modrm64(139, treg_rsp, 50, (unsafe { nil }), addr)
}

fn gen_vla_alloc(type_ &CType, align int) {
	use_call := 0
	use_call = tcc_state.do_bounds_check
	if use_call {
		vpush_helper_func(Tcc_token.tok_alloca)
		vswap()
		gfunc_call(1)
	} else {
		r := 0
		r = gv(1)
		o(11080)
		o(224 | (r & 7))
		o(4041507656)
		vpop()
	}
}

fn gen_struct_copy(size int) {
	n := size / 8
	gv2(64, 32)
	if n <= 4 {
		for n {
			o(42312)
			n--
		}
	} else {
		vpushi(n)
		gv(16)
		o(10832115)
		vpop()
	}
	if size & 4 {
		o(165)
	}
	if size & 2 {
		o(42342)
	}
	if size & 1 {
		o(164)
	}
	vpop()
	vpop()
}
