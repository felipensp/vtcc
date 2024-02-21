@[translated]
module main

const reg_to_size = [0, 0, 1, 0, 2, 0, 0, 0, 3]!

const test_bits = [0, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 9, 10, 10, 11, 11, 12, 12,
	13, 13, 14, 14, 15, 15]!

const segment_prefixes = [38, 46, 54, 62, 100, 101]!

pub type TCCErrorFunc = fn (voidptr, &char)

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

struct ASMInstr {
	sym        u16
	opcode     u16
	instr_type u16
	nb_ops     u8
	op_type    [3]u8
}

struct Operand {
	type_ u32
	reg   i8
	reg2  i8
	shift u8
	e     ExprValue
}

@[export: 'asm_instrs']
__global asm_instrs = [
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_vmcall)
		opcode: (u16((if (((193) & 65280) == 3840) {
			((((193) >> 8) & ~255) | ((193) & 255))
		} else {
			(193)
		})))
		instr_type: u16(((96) | ((0) << 13) | (if (((193) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_vmlaunch)
		opcode: (u16((if (((194) & 65280) == 3840) {
			((((194) >> 8) & ~255) | ((194) & 255))
		} else {
			(194)
		})))
		instr_type: u16(((96) | ((0) << 13) | (if (((194) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_vmresume)
		opcode: (u16((if (((195) & 65280) == 3840) {
			((((195) >> 8) & ~255) | ((195) & 255))
		} else {
			(195)
		})))
		instr_type: u16(((96) | ((0) << 13) | (if (((195) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_vmxoff)
		opcode: (u16((if (((196) & 65280) == 3840) {
			((((196) >> 8) & ~255) | ((196) & 255))
		} else {
			(196)
		})))
		instr_type: u16(((96) | ((0) << 13) | (if (((196) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmpsb)
		opcode: (u16((if (((166) & 65280) == 3840) {
			((((166) >> 8) & ~255) | ((166) & 255))
		} else {
			(166)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((166) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_scmpb)
		opcode: (u16((if (((166) & 65280) == 3840) {
			((((166) >> 8) & ~255) | ((166) & 255))
		} else {
			(166)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((166) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_insb)
		opcode: (u16((if (((108) & 65280) == 3840) {
			((((108) >> 8) & ~255) | ((108) & 255))
		} else {
			(108)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((108) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outsb)
		opcode: (u16((if (((110) & 65280) == 3840) {
			((((110) >> 8) & ~255) | ((110) & 255))
		} else {
			(110)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((110) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lodsb)
		opcode: (u16((if (((172) & 65280) == 3840) {
			((((172) >> 8) & ~255) | ((172) & 255))
		} else {
			(172)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((172) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_slodb)
		opcode: (u16((if (((172) & 65280) == 3840) {
			((((172) >> 8) & ~255) | ((172) & 255))
		} else {
			(172)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((172) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsb)
		opcode: (u16((if (((164) & 65280) == 3840) {
			((((164) >> 8) & ~255) | ((164) & 255))
		} else {
			(164)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((164) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_smovb)
		opcode: (u16((if (((164) & 65280) == 3840) {
			((((164) >> 8) & ~255) | ((164) & 255))
		} else {
			(164)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((164) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_scasb)
		opcode: (u16((if (((174) & 65280) == 3840) {
			((((174) >> 8) & ~255) | ((174) & 255))
		} else {
			(174)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((174) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sscab)
		opcode: (u16((if (((174) & 65280) == 3840) {
			((((174) >> 8) & ~255) | ((174) & 255))
		} else {
			(174)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((174) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_stosb)
		opcode: (u16((if (((170) & 65280) == 3840) {
			((((170) >> 8) & ~255) | ((170) & 255))
		} else {
			(170)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((170) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sstob)
		opcode: (u16((if (((170) & 65280) == 3840) {
			((((170) >> 8) & ~255) | ((170) & 255))
		} else {
			(170)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((170) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bsfw)
		opcode: (u16((if (((4028) & 65280) == 3840) {
			((((4028) >> 8) & ~255) | ((4028) & 255))
		} else {
			(4028)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4028) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bsrw)
		opcode: (u16((if (((4029) & 65280) == 3840) {
			((((4029) >> 8) & ~255) | ((4029) & 255))
		} else {
			(4029)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4029) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btw)
		opcode: (u16((if (((4003) & 65280) == 3840) {
			((((4003) >> 8) & ~255) | ((4003) & 255))
		} else {
			(4003)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4003) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16(((8 | 4096) | ((4) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btsw)
		opcode: (u16((if (((4011) & 65280) == 3840) {
			((((4011) >> 8) & ~255) | ((4011) & 255))
		} else {
			(4011)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4011) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btsw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16(((8 | 4096) | ((5) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btrw)
		opcode: (u16((if (((4019) & 65280) == 3840) {
			((((4019) >> 8) & ~255) | ((4019) & 255))
		} else {
			(4019)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4019) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btrw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16(((8 | 4096) | ((6) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btcw)
		opcode: (u16((if (((4027) & 65280) == 3840) {
			((((4027) >> 8) & ~255) | ((4027) & 255))
		} else {
			(4027)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4027) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btcw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16(((8 | 4096) | ((7) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_regw | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popcntw)
		opcode: (u16((if (((15929272) & 65280) == 3840) {
			((((15929272) >> 8) & ~255) | ((15929272) & 255))
		} else {
			(15929272)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((15929272) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_regw | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_tzcntw)
		opcode: (u16((if (((15929276) & 65280) == 3840) {
			((((15929276) >> 8) & ~255) | ((15929276) & 255))
		} else {
			(15929276)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((15929276) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_regw | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lzcntw)
		opcode: (u16((if (((15929277) & 65280) == 3840) {
			((((15929277) >> 8) & ~255) | ((15929277) & 255))
		} else {
			(15929277)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((15929277) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_regw | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sysretq)
		opcode: (u16((if (((4722439) & 65280) == 3840) {
			((((4722439) >> 8) & ~255) | ((4722439) & 255))
		} else {
			(4722439)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((4722439) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((136) & 65280) == 3840) {
			((((136) >> 8) & ~255) | ((136) & 255))
		} else {
			(136)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((136) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((138) & 65280) == 3840) {
			((((138) >> 8) & ~255) | ((138) & 255))
		} else {
			(138)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((138) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((176) & 65280) == 3840) {
			((((176) >> 8) & ~255) | ((176) & 255))
		} else {
			(176)
		})))
		instr_type: u16(((4 | (1 | 4096)) | ((0) << 13) | (if (((176) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mov)
		opcode: (u16((if (((184) & 65280) == 3840) {
			((((184) >> 8) & ~255) | ((184) & 255))
		} else {
			(184)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((184) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im64), opt_reg64, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((184) & 65280) == 3840) {
			((((184) >> 8) & ~255) | ((184) & 255))
		} else {
			(184)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((184) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im64), opt_reg64, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((198) & 65280) == 3840) {
			((((198) >> 8) & ~255) | ((198) & 255))
		} else {
			(198)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((198) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im), opt_reg | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((140) & 65280) == 3840) {
			((((140) >> 8) & ~255) | ((140) & 255))
		} else {
			(140)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((140) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_seg), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((142) & 65280) == 3840) {
			((((142) >> 8) & ~255) | ((142) & 255))
		} else {
			(142)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((142) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_seg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3872) & 65280) == 3840) {
			((((3872) >> 8) & ~255) | ((3872) & 255))
		} else {
			(3872)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((3872) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_cr), opt_reg64, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3873) & 65280) == 3840) {
			((((3873) >> 8) & ~255) | ((3873) & 255))
		} else {
			(3873)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((3873) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_db), opt_reg64, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3874) & 65280) == 3840) {
			((((3874) >> 8) & ~255) | ((3874) & 255))
		} else {
			(3874)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((3874) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg64), opt_cr, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3875) & 65280) == 3840) {
			((((3875) >> 8) & ~255) | ((3875) & 255))
		} else {
			(3875)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((3875) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg64), opt_db, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsbw)
		opcode: (u16((if (((6688702) & 65280) == 3840) {
			((((6688702) >> 8) & ~255) | ((6688702) & 255))
		} else {
			(6688702)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((6688702) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg8 | opt_ea), opt_reg16, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsbl)
		opcode: (u16((if (((4030) & 65280) == 3840) {
			((((4030) >> 8) & ~255) | ((4030) & 255))
		} else {
			(4030)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4030) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg8 | opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsbq)
		opcode: (u16((if (((4030) & 65280) == 3840) {
			((((4030) >> 8) & ~255) | ((4030) & 255))
		} else {
			(4030)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4030) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg8 | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movswl)
		opcode: (u16((if (((4031) & 65280) == 3840) {
			((((4031) >> 8) & ~255) | ((4031) & 255))
		} else {
			(4031)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4031) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg16 | opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movswq)
		opcode: (u16((if (((4031) & 65280) == 3840) {
			((((4031) >> 8) & ~255) | ((4031) & 255))
		} else {
			(4031)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4031) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg16 | opt_ea), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movslq)
		opcode: (u16((if (((99) & 65280) == 3840) {
			((((99) >> 8) & ~255) | ((99) & 255))
		} else {
			(99)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((99) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg32 | opt_ea), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movzbw)
		opcode: (u16((if (((4022) & 65280) == 3840) {
			((((4022) >> 8) & ~255) | ((4022) & 255))
		} else {
			(4022)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4022) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg8 | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movzwl)
		opcode: (u16((if (((4023) & 65280) == 3840) {
			((((4023) >> 8) & ~255) | ((4023) & 255))
		} else {
			(4023)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4023) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg16 | opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movzwq)
		opcode: (u16((if (((4023) & 65280) == 3840) {
			((((4023) >> 8) & ~255) | ((4023) & 255))
		} else {
			(4023)
		})))
		instr_type: u16(u8(((8) | ((0) << 13) | (if (((4023) & 65280) == 3840) { 256 } else { 0 }))))
		nb_ops: 2
		op_type: [u8(opt_reg16 | opt_ea), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushq)
		opcode: (u16((if (((106) & 65280) == 3840) {
			((((106) >> 8) & ~255) | ((106) & 255))
		} else {
			(106)
		})))
		instr_type: u16(u16(((0) | ((0) << 13) | (if (((106) & 65280) == 3840) { 256 } else { 0 }))))
		nb_ops: 1
		op_type: [u8(opt_im8s), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_push)
		opcode: (u16((if (((106) & 65280) == 3840) {
			((((106) >> 8) & ~255) | ((106) & 255))
		} else {
			(106)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((106) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im8s), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((26218) & 65280) == 3840) {
			((((26218) >> 8) & ~255) | ((26218) & 255))
		} else {
			(26218)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((26218) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im8s), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((80) & 65280) == 3840) {
			((((80) >> 8) & ~255) | ((80) & 255))
		} else {
			(80)
		})))
		instr_type: u16(((4 | 4096) | ((0) << 13) | (if (((80) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg64), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((80) & 65280) == 3840) {
			((((80) >> 8) & ~255) | ((80) & 255))
		} else {
			(80)
		})))
		instr_type: u16(((4 | 4096) | ((0) << 13) | (if (((80) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16(((8 | 4096) | ((6) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg64 | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((26216) & 65280) == 3840) {
			((((26216) >> 8) & ~255) | ((26216) & 255))
		} else {
			(26216)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((26216) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((104) & 65280) == 3840) {
			((((104) >> 8) & ~255) | ((104) & 255))
		} else {
			(104)
		})))
		instr_type: u16(((4096) | ((0) << 13) | (if (((104) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im32), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((6) & 65280) == 3840) { ((((6) >> 8) & ~255) | ((6) & 255)) } else { (6) })))
		instr_type: u16(((4096) | ((0) << 13) | (if (((6) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_seg), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((88) & 65280) == 3840) {
			((((88) >> 8) & ~255) | ((88) & 255))
		} else {
			(88)
		})))
		instr_type: u16(((4 | 4096) | ((0) << 13) | (if (((88) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg64), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((88) & 65280) == 3840) {
			((((88) >> 8) & ~255) | ((88) & 255))
		} else {
			(88)
		})))
		instr_type: u16(((4 | 4096) | ((0) << 13) | (if (((88) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((143) & 65280) == 3840) {
			((((143) >> 8) & ~255) | ((143) & 255))
		} else {
			(143)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((143) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_regw | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((7) & 65280) == 3840) { ((((7) >> 8) & ~255) | ((7) & 255)) } else { (7) })))
		instr_type: u16(((4096) | ((0) << 13) | (if (((7) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_seg), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgw)
		opcode: (u16((if (((144) & 65280) == 3840) {
			((((144) >> 8) & ~255) | ((144) & 255))
		} else {
			(144)
		})))
		instr_type: u16(((4 | 4096) | ((0) << 13) | (if (((144) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgw)
		opcode: (u16((if (((144) & 65280) == 3840) {
			((((144) >> 8) & ~255) | ((144) & 255))
		} else {
			(144)
		})))
		instr_type: u16(((4 | 4096) | ((0) << 13) | (if (((144) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_eax), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgb)
		opcode: (u16((if (((134) & 65280) == 3840) {
			((((134) >> 8) & ~255) | ((134) & 255))
		} else {
			(134)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((134) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgb)
		opcode: (u16((if (((134) & 65280) == 3840) {
			((((134) >> 8) & ~255) | ((134) & 255))
		} else {
			(134)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((134) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((228) & 65280) == 3840) {
			((((228) >> 8) & ~255) | ((228) & 255))
		} else {
			(228)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((228) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((228) & 65280) == 3840) {
			((((228) >> 8) & ~255) | ((228) & 255))
		} else {
			(228)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((228) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((236) & 65280) == 3840) {
			((((236) >> 8) & ~255) | ((236) & 255))
		} else {
			(236)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((236) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_dx), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((236) & 65280) == 3840) {
			((((236) >> 8) & ~255) | ((236) & 255))
		} else {
			(236)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((236) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_dx), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((230) & 65280) == 3840) {
			((((230) >> 8) & ~255) | ((230) & 255))
		} else {
			(230)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((230) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_eax), opt_im8, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((230) & 65280) == 3840) {
			((((230) >> 8) & ~255) | ((230) & 255))
		} else {
			(230)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((230) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((238) & 65280) == 3840) {
			((((238) >> 8) & ~255) | ((238) & 255))
		} else {
			(238)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((238) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_eax), opt_dx, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((238) & 65280) == 3840) {
			((((238) >> 8) & ~255) | ((238) & 255))
		} else {
			(238)
		})))
		instr_type: u16(((1 | 2) | ((0) << 13) | (if (((238) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_dx), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_leaw)
		opcode: (u16((if (((141) & 65280) == 3840) {
			((((141) >> 8) & ~255) | ((141) & 255))
		} else {
			(141)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((141) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_les)
		opcode: (u16((if (((196) & 65280) == 3840) {
			((((196) >> 8) & ~255) | ((196) & 255))
		} else {
			(196)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((196) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lds)
		opcode: (u16((if (((197) & 65280) == 3840) {
			((((197) >> 8) & ~255) | ((197) & 255))
		} else {
			(197)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((197) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lss)
		opcode: (u16((if (((4018) & 65280) == 3840) {
			((((4018) >> 8) & ~255) | ((4018) & 255))
		} else {
			(4018)
		})))
		instr_type: u16(u16(((8) | ((0) << 13) | (if (((4018) & 65280) == 3840) { 256 } else { 0 }))))
		nb_ops: 2
		op_type: [u8(opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lfs)
		opcode: (u16((if (((4020) & 65280) == 3840) {
			((((4020) >> 8) & ~255) | ((4020) & 255))
		} else {
			(4020)
		})))
		instr_type: u16(u16(((8) | ((0) << 13) | (if (((4020) & 65280) == 3840) { 256 } else { 0 }))))
		nb_ops: 2
		op_type: [u8(opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lgs)
		opcode: (u16((if (((4021) & 65280) == 3840) {
			((((4021) >> 8) & ~255) | ((4021) & 255))
		} else {
			(4021)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4021) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea), opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((0) & 65280) == 3840) { ((((0) >> 8) & ~255) | ((0) & 255)) } else { (0) })))
		instr_type: u16(((48 | 8 | (1 | 4096)) | ((0) << 13) | (if (((0) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((2) & 65280) == 3840) { ((((2) >> 8) & ~255) | ((2) & 255)) } else { (2) })))
		instr_type: u16(((48 | 8 | (1 | 4096)) | ((0) << 13) | (if (((2) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((4) & 65280) == 3840) { ((((4) >> 8) & ~255) | ((4) & 255)) } else { (4) })))
		instr_type: u16(((48 | (1 | 4096)) | ((0) << 13) | (if (((4) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addw)
		opcode: (u16((if (((131) & 65280) == 3840) {
			((((131) >> 8) & ~255) | ((131) & 255))
		} else {
			(131)
		})))
		instr_type: u16(((48 | 8 | 4096) | ((0) << 13) | (if (((131) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im8s), opt_ea | opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((128) & 65280) == 3840) {
			((((128) >> 8) & ~255) | ((128) & 255))
		} else {
			(128)
		})))
		instr_type: u16(((48 | 8 | (1 | 4096)) | ((0) << 13) | (if (((128) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((132) & 65280) == 3840) {
			((((132) >> 8) & ~255) | ((132) & 255))
		} else {
			(132)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((132) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((132) & 65280) == 3840) {
			((((132) >> 8) & ~255) | ((132) & 255))
		} else {
			(132)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((132) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((168) & 65280) == 3840) {
			((((168) >> 8) & ~255) | ((168) & 255))
		} else {
			(168)
		})))
		instr_type: u16(((1 | 4096) | ((0) << 13) | (if (((168) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_incb)
		opcode: (u16((if (((254) & 65280) == 3840) {
			((((254) >> 8) & ~255) | ((254) & 255))
		} else {
			(254)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((254) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_decb)
		opcode: (u16((if (((254) & 65280) == 3840) {
			((((254) >> 8) & ~255) | ((254) & 255))
		} else {
			(254)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((1) << 13) | (if (((254) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_notb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((2) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_negb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((3) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mulb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((4) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((5) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((4015) & 65280) == 3840) {
			((((4015) >> 8) & ~255) | ((4015) & 255))
		} else {
			(4015)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4015) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg | opt_ea), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((107) & 65280) == 3840) {
			((((107) >> 8) & ~255) | ((107) & 255))
		} else {
			(107)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((107) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 3
		op_type: [u8(opt_im8s), opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((107) & 65280) == 3840) {
			((((107) >> 8) & ~255) | ((107) & 255))
		} else {
			(107)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((107) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8s), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((105) & 65280) == 3840) {
			((((105) >> 8) & ~255) | ((105) & 255))
		} else {
			(105)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((105) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 3
		op_type: [u8(opt_imw), opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((105) & 65280) == 3840) {
			((((105) >> 8) & ~255) | ((105) & 255))
		} else {
			(105)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((105) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_imw), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_divb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((6) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_divb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((6) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg | opt_ea), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_idivb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((7) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_idivb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((7) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg | opt_ea), opt_eax, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rolb)
		opcode: (u16((if (((192) & 65280) == 3840) {
			((((192) >> 8) & ~255) | ((192) & 255))
		} else {
			(192)
		})))
		instr_type: u16(((8 | (1 | 4096) | 32) | ((0) << 13) | (if (((192) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rolb)
		opcode: (u16((if (((210) & 65280) == 3840) {
			((((210) >> 8) & ~255) | ((210) & 255))
		} else {
			(210)
		})))
		instr_type: u16(((8 | (1 | 4096) | 32) | ((0) << 13) | (if (((210) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_cl), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rolb)
		opcode: (u16((if (((208) & 65280) == 3840) {
			((((208) >> 8) & ~255) | ((208) & 255))
		} else {
			(208)
		})))
		instr_type: u16(((8 | (1 | 4096) | 32) | ((0) << 13) | (if (((208) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 1
		op_type: [u8(opt_ea | opt_reg), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shldw)
		opcode: (u16((if (((4004) & 65280) == 3840) {
			((((4004) >> 8) & ~255) | ((4004) & 255))
		} else {
			(4004)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4004) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 3
		op_type: [u8(opt_im8), opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shldw)
		opcode: (u16((if (((4005) & 65280) == 3840) {
			((((4005) >> 8) & ~255) | ((4005) & 255))
		} else {
			(4005)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4005) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 3
		op_type: [u8(opt_cl), opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shldw)
		opcode: (u16((if (((4005) & 65280) == 3840) {
			((((4005) >> 8) & ~255) | ((4005) & 255))
		} else {
			(4005)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4005) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_ea | opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shrdw)
		opcode: (u16((if (((4012) & 65280) == 3840) {
			((((4012) >> 8) & ~255) | ((4012) & 255))
		} else {
			(4012)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4012) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 3
		op_type: [u8(opt_im8), opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shrdw)
		opcode: (u16((if (((4013) & 65280) == 3840) {
			((((4013) >> 8) & ~255) | ((4013) & 255))
		} else {
			(4013)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4013) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 3
		op_type: [u8(opt_cl), opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shrdw)
		opcode: (u16((if (((4013) & 65280) == 3840) {
			((((4013) >> 8) & ~255) | ((4013) & 255))
		} else {
			(4013)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((4013) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_regw), opt_ea | opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_call)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_indir), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_call)
		opcode: (u16((if (((232) & 65280) == 3840) {
			((((232) >> 8) & ~255) | ((232) & 255))
		} else {
			(232)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((232) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jmp)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_indir), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jmp)
		opcode: (u16((if (((235) & 65280) == 3840) {
			((((235) >> 8) & ~255) | ((235) & 255))
		} else {
			(235)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((235) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lcall)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ljmp)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ljmpw)
		opcode: (u16((if (((26367) & 65280) == 3840) {
			((((26367) >> 8) & ~255) | ((26367) & 255))
		} else {
			(26367)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((26367) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ljmpl)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_int)
		opcode: (u16((if (((205) & 65280) == 3840) {
			((((205) >> 8) & ~255) | ((205) & 255))
		} else {
			(205)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((205) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_seto)
		opcode: (u16((if (((3984) & 65280) == 3840) {
			((((3984) >> 8) & ~255) | ((3984) & 255))
		} else {
			(3984)
		})))
		instr_type: u16(((8 | 80) | ((0) << 13) | (if (((3984) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg8 | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_setob)
		opcode: (u16((if (((3984) & 65280) == 3840) {
			((((3984) >> 8) & ~255) | ((3984) & 255))
		} else {
			(3984)
		})))
		instr_type: u16(((8 | 80) | ((0) << 13) | (if (((3984) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg8 | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_enter)
		opcode: (u16((if (((200) & 65280) == 3840) {
			((((200) >> 8) & ~255) | ((200) & 255))
		} else {
			(200)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((200) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im16), opt_im8, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_retq)
		opcode: (u16((if (((194) & 65280) == 3840) {
			((((194) >> 8) & ~255) | ((194) & 255))
		} else {
			(194)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((194) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ret)
		opcode: (u16((if (((194) & 65280) == 3840) {
			((((194) >> 8) & ~255) | ((194) & 255))
		} else {
			(194)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((194) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lret)
		opcode: (u16((if (((202) & 65280) == 3840) {
			((((202) >> 8) & ~255) | ((202) & 255))
		} else {
			(202)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((202) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_im16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jo)
		opcode: (u16((if (((112) & 65280) == 3840) {
			((((112) >> 8) & ~255) | ((112) & 255))
		} else {
			(112)
		})))
		instr_type: u16(((80) | ((0) << 13) | (if (((112) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loopne)
		opcode: (u16((if (((224) & 65280) == 3840) {
			((((224) >> 8) & ~255) | ((224) & 255))
		} else {
			(224)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((224) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loopnz)
		opcode: (u16((if (((224) & 65280) == 3840) {
			((((224) >> 8) & ~255) | ((224) & 255))
		} else {
			(224)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((224) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loope)
		opcode: (u16((if (((225) & 65280) == 3840) {
			((((225) >> 8) & ~255) | ((225) & 255))
		} else {
			(225)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((225) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loopz)
		opcode: (u16((if (((225) & 65280) == 3840) {
			((((225) >> 8) & ~255) | ((225) & 255))
		} else {
			(225)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((225) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loop)
		opcode: (u16((if (((226) & 65280) == 3840) {
			((((226) >> 8) & ~255) | ((226) & 255))
		} else {
			(226)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((226) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jecxz)
		opcode: (u16((if (((26595) & 65280) == 3840) {
			((((26595) >> 8) & ~255) | ((26595) & 255))
		} else {
			(26595)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((26595) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_disp8), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcomp)
		opcode: (u16((if (((55513) & 65280) == 3840) {
			((((55513) >> 8) & ~255) | ((55513) & 255))
		} else {
			(55513)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((55513) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((55488) & 65280) == 3840) {
			((((55488) >> 8) & ~255) | ((55488) & 255))
		} else {
			(55488)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((55488) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((55488) & 65280) == 3840) {
			((((55488) >> 8) & ~255) | ((55488) & 255))
		} else {
			(55488)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((55488) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((56512) & 65280) == 3840) {
			((((56512) >> 8) & ~255) | ((56512) & 255))
		} else {
			(56512)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((56512) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st0), opt_st, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fmul)
		opcode: (u16((if (((56520) & 65280) == 3840) {
			((((56520) >> 8) & ~255) | ((56520) & 255))
		} else {
			(56520)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((56520) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st0), opt_st, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((57025) & 65280) == 3840) {
			((((57025) >> 8) & ~255) | ((57025) & 255))
		} else {
			(57025)
		})))
		instr_type: u16(((64) | ((0) << 13) | (if (((57025) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57024) & 65280) == 3840) {
			((((57024) >> 8) & ~255) | ((57024) & 255))
		} else {
			(57024)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((57024) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57024) & 65280) == 3840) {
			((((57024) >> 8) & ~255) | ((57024) & 255))
		} else {
			(57024)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((57024) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57024) & 65280) == 3840) {
			((((57024) >> 8) & ~255) | ((57024) & 255))
		} else {
			(57024)
		})))
		instr_type: u16(((64 | 4) | ((0) << 13) | (if (((57024) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st0), opt_st, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57025) & 65280) == 3840) {
			((((57025) >> 8) & ~255) | ((57025) & 255))
		} else {
			(57025)
		})))
		instr_type: u16(((64) | ((0) << 13) | (if (((57025) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadds)
		opcode: (u16((if (((216) & 65280) == 3840) {
			((((216) >> 8) & ~255) | ((216) & 255))
		} else {
			(216)
		})))
		instr_type: u16(((64 | 8) | ((0) << 13) | (if (((216) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fiaddl)
		opcode: (u16((if (((218) & 65280) == 3840) {
			((((218) >> 8) & ~255) | ((218) & 255))
		} else {
			(218)
		})))
		instr_type: u16(((64 | 8) | ((0) << 13) | (if (((218) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddl)
		opcode: (u16((if (((220) & 65280) == 3840) {
			((((220) >> 8) & ~255) | ((220) & 255))
		} else {
			(220)
		})))
		instr_type: u16(((64 | 8) | ((0) << 13) | (if (((220) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fiadds)
		opcode: (u16((if (((222) & 65280) == 3840) {
			((((222) >> 8) & ~255) | ((222) & 255))
		} else {
			(222)
		})))
		instr_type: u16(((64 | 8) | ((0) << 13) | (if (((222) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fld)
		opcode: (u16((if (((55744) & 65280) == 3840) {
			((((55744) >> 8) & ~255) | ((55744) & 255))
		} else {
			(55744)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((55744) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldl)
		opcode: (u16((if (((55744) & 65280) == 3840) {
			((((55744) >> 8) & ~255) | ((55744) & 255))
		} else {
			(55744)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((55744) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_flds)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldl)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fildl)
		opcode: (u16((if (((219) & 65280) == 3840) {
			((((219) >> 8) & ~255) | ((219) & 255))
		} else {
			(219)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fildq)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fildll)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldt)
		opcode: (u16((if (((219) & 65280) == 3840) {
			((((219) >> 8) & ~255) | ((219) & 255))
		} else {
			(219)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fbld)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fst)
		opcode: (u16((if (((56784) & 65280) == 3840) {
			((((56784) >> 8) & ~255) | ((56784) & 255))
		} else {
			(56784)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56784) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstl)
		opcode: (u16((if (((56784) & 65280) == 3840) {
			((((56784) >> 8) & ~255) | ((56784) & 255))
		} else {
			(56784)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56784) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fsts)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstps)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstl)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstpl)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fist)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fistp)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fistl)
		opcode: (u16((if (((219) & 65280) == 3840) {
			((((219) >> 8) & ~255) | ((219) & 255))
		} else {
			(219)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fistpl)
		opcode: (u16((if (((219) & 65280) == 3840) {
			((((219) >> 8) & ~255) | ((219) & 255))
		} else {
			(219)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstp)
		opcode: (u16((if (((56792) & 65280) == 3840) {
			((((56792) >> 8) & ~255) | ((56792) & 255))
		} else {
			(56792)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56792) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fistpq)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fistpll)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstpt)
		opcode: (u16((if (((219) & 65280) == 3840) {
			((((219) >> 8) & ~255) | ((219) & 255))
		} else {
			(219)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fbstp)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fxch)
		opcode: (u16((if (((55752) & 65280) == 3840) {
			((((55752) >> 8) & ~255) | ((55752) & 255))
		} else {
			(55752)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((55752) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucom)
		opcode: (u16((if (((56800) & 65280) == 3840) {
			((((56800) >> 8) & ~255) | ((56800) & 255))
		} else {
			(56800)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56800) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucomp)
		opcode: (u16((if (((56808) & 65280) == 3840) {
			((((56808) >> 8) & ~255) | ((56808) & 255))
		} else {
			(56808)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56808) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_finit)
		opcode: (u16((if (((56291) & 65280) == 3840) {
			((((56291) >> 8) & ~255) | ((56291) & 255))
		} else {
			(56291)
		})))
		instr_type: u16(((16) | ((0) << 13) | (if (((56291) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldcw)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnstcw)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstcw)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8 | 16) | ((7) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnstsw)
		opcode: (u16((if (((57312) & 65280) == 3840) {
			((((57312) >> 8) & ~255) | ((57312) & 255))
		} else {
			(57312)
		})))
		instr_type: u16(((0) | ((0) << 13) | (if (((57312) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_eax), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnstsw)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstsw)
		opcode: (u16((if (((57312) & 65280) == 3840) {
			((((57312) >> 8) & ~255) | ((57312) & 255))
		} else {
			(57312)
		})))
		instr_type: u16(((16) | ((0) << 13) | (if (((57312) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_eax), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstsw)
		opcode: (u16((if (((57312) & 65280) == 3840) {
			((((57312) >> 8) & ~255) | ((57312) & 255))
		} else {
			(57312)
		})))
		instr_type: u16(((16) | ((0) << 13) | (if (((57312) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstsw)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8 | 16) | ((7) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fclex)
		opcode: (u16((if (((56290) & 65280) == 3840) {
			((((56290) >> 8) & ~255) | ((56290) & 255))
		} else {
			(56290)
		})))
		instr_type: u16(((16) | ((0) << 13) | (if (((56290) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnstenv)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstenv)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8 | 16) | ((6) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldenv)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnsave)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fsave)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8 | 16) | ((6) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_frstor)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ffree)
		opcode: (u16((if (((56768) & 65280) == 3840) {
			((((56768) >> 8) & ~255) | ((56768) & 255))
		} else {
			(56768)
		})))
		instr_type: u16(((4) | ((4) << 13) | (if (((56768) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ffreep)
		opcode: (u16((if (((57280) & 65280) == 3840) {
			((((57280) >> 8) & ~255) | ((57280) & 255))
		} else {
			(57280)
		})))
		instr_type: u16(((4) | ((4) << 13) | (if (((57280) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_st), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fxsave)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fxrstor)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fxsaveq)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8 | 512) | ((0) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fxrstorq)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8 | 512) | ((1) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_arpl)
		opcode: (u16((if (((99) & 65280) == 3840) {
			((((99) >> 8) & ~255) | ((99) & 255))
		} else {
			(99)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((99) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg16), opt_reg16 | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_larw)
		opcode: (u16((if (((3842) & 65280) == 3840) {
			((((3842) >> 8) & ~255) | ((3842) & 255))
		} else {
			(3842)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((3842) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg | opt_ea), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lgdt)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lgdtq)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lidt)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lidtq)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lldt)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea | opt_reg), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lmsw)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea | opt_reg), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lslw)
		opcode: (u16((if (((3843) & 65280) == 3840) {
			((((3843) >> 8) & ~255) | ((3843) & 255))
		} else {
			(3843)
		})))
		instr_type: u16(((8 | 4096) | ((0) << 13) | (if (((3843) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ltr)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea | opt_reg16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sgdt)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sgdtq)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sidt)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sidtq)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sldt)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_smsw)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_str)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg32 | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_str)
		opcode: (u16((if (((6688512) & 65280) == 3840) {
			((((6688512) >> 8) & ~255) | ((6688512) & 255))
		} else {
			(6688512)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((6688512) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg16), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_str)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8 | 512) | ((1) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg64), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_verr)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_verw)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg | opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_swapgs)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bswap)
		opcode: (u16((if (((4040) & 65280) == 3840) {
			((((4040) >> 8) & ~255) | ((4040) & 255))
		} else {
			(4040)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((4040) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg32), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bswapl)
		opcode: (u16((if (((4040) & 65280) == 3840) {
			((((4040) >> 8) & ~255) | ((4040) & 255))
		} else {
			(4040)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((4040) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg32), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bswapq)
		opcode: (u16((if (((4040) & 65280) == 3840) {
			((((4040) >> 8) & ~255) | ((4040) & 255))
		} else {
			(4040)
		})))
		instr_type: u16(((4 | 512) | ((0) << 13) | (if (((4040) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_reg64), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xaddb)
		opcode: (u16((if (((4032) & 65280) == 3840) {
			((((4032) >> 8) & ~255) | ((4032) & 255))
		} else {
			(4032)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((4032) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_reg | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmpxchgb)
		opcode: (u16((if (((4016) & 65280) == 3840) {
			((((4016) >> 8) & ~255) | ((4016) & 255))
		} else {
			(4016)
		})))
		instr_type: u16(((8 | (1 | 4096)) | ((0) << 13) | (if (((4016) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_reg | opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_invlpg)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmpxchg8b)
		opcode: (u16((if (((4039) & 65280) == 3840) {
			((((4039) >> 8) & ~255) | ((4039) & 255))
		} else {
			(4039)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((4039) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmpxchg16b)
		opcode: (u16((if (((4039) & 65280) == 3840) {
			((((4039) >> 8) & ~255) | ((4039) & 255))
		} else {
			(4039)
		})))
		instr_type: u16(((8 | 512) | ((1) << 13) | (if (((4039) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmovo)
		opcode: (u16((if (((3904) & 65280) == 3840) {
			((((3904) >> 8) & ~255) | ((3904) & 255))
		} else {
			(3904)
		})))
		instr_type: u16(((8 | 80 | 4096) | ((0) << 13) | (if (((3904) & 65280) == 3840) {
			256
		} else {
			0
		})))
		nb_ops: 2
		op_type: [u8(opt_regw | opt_ea), opt_regw, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovb)
		opcode: (u16((if (((56000) & 65280) == 3840) {
			((((56000) >> 8) & ~255) | ((56000) & 255))
		} else {
			(56000)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56000) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmove)
		opcode: (u16((if (((56008) & 65280) == 3840) {
			((((56008) >> 8) & ~255) | ((56008) & 255))
		} else {
			(56008)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56008) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovbe)
		opcode: (u16((if (((56016) & 65280) == 3840) {
			((((56016) >> 8) & ~255) | ((56016) & 255))
		} else {
			(56016)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56016) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovu)
		opcode: (u16((if (((56024) & 65280) == 3840) {
			((((56024) >> 8) & ~255) | ((56024) & 255))
		} else {
			(56024)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56024) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovnb)
		opcode: (u16((if (((56256) & 65280) == 3840) {
			((((56256) >> 8) & ~255) | ((56256) & 255))
		} else {
			(56256)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56256) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovne)
		opcode: (u16((if (((56264) & 65280) == 3840) {
			((((56264) >> 8) & ~255) | ((56264) & 255))
		} else {
			(56264)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56264) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovnbe)
		opcode: (u16((if (((56272) & 65280) == 3840) {
			((((56272) >> 8) & ~255) | ((56272) & 255))
		} else {
			(56272)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56272) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovnu)
		opcode: (u16((if (((56280) & 65280) == 3840) {
			((((56280) >> 8) & ~255) | ((56280) & 255))
		} else {
			(56280)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56280) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucomi)
		opcode: (u16((if (((56296) & 65280) == 3840) {
			((((56296) >> 8) & ~255) | ((56296) & 255))
		} else {
			(56296)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56296) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcomi)
		opcode: (u16((if (((56304) & 65280) == 3840) {
			((((56304) >> 8) & ~255) | ((56304) & 255))
		} else {
			(56304)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((56304) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucomip)
		opcode: (u16((if (((57320) & 65280) == 3840) {
			((((57320) >> 8) & ~255) | ((57320) & 255))
		} else {
			(57320)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((57320) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcomip)
		opcode: (u16((if (((57328) & 65280) == 3840) {
			((((57328) >> 8) & ~255) | ((57328) & 255))
		} else {
			(57328)
		})))
		instr_type: u16(((4) | ((0) << 13) | (if (((57328) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_st), opt_st0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3950) & 65280) == 3840) {
			((((3950) >> 8) & ~255) | ((3950) & 255))
		} else {
			(3950)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3950) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg32), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3950) & 65280) == 3840) {
			((((3950) >> 8) & ~255) | ((3950) & 255))
		} else {
			(3950)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3950) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg64), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3950) & 65280) == 3840) {
			((((3950) >> 8) & ~255) | ((3950) & 255))
		} else {
			(3950)
		})))
		instr_type: u16(((8 | 512) | ((0) << 13) | (if (((3950) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg64), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3951) & 65280) == 3840) {
			((((3951) >> 8) & ~255) | ((3951) & 255))
		} else {
			(3951)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3951) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmx), opt_mmx, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3966) & 65280) == 3840) {
			((((3966) >> 8) & ~255) | ((3966) & 255))
		} else {
			(3966)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3966) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_mmxsse), opt_ea | opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3966) & 65280) == 3840) {
			((((3966) >> 8) & ~255) | ((3966) & 255))
		} else {
			(3966)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3966) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_mmxsse), opt_ea | opt_reg64, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3967) & 65280) == 3840) {
			((((3967) >> 8) & ~255) | ((3967) & 255))
		} else {
			(3967)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3967) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_mmx), opt_ea | opt_mmx, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((6688726) & 65280) == 3840) {
			((((6688726) >> 8) & ~255) | ((6688726) & 255))
		} else {
			(6688726)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((6688726) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_sse), opt_ea | opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((15929214) & 65280) == 3840) {
			((((15929214) >> 8) & ~255) | ((15929214) & 255))
		} else {
			(15929214)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((15929214) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3966) & 65280) == 3840) {
			((((3966) >> 8) & ~255) | ((3966) & 255))
		} else {
			(3966)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3966) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_mmxsse), opt_ea | opt_reg64, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_packssdw)
		opcode: (u16((if (((3947) & 65280) == 3840) {
			((((3947) >> 8) & ~255) | ((3947) & 255))
		} else {
			(3947)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3947) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_packsswb)
		opcode: (u16((if (((3939) & 65280) == 3840) {
			((((3939) >> 8) & ~255) | ((3939) & 255))
		} else {
			(3939)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3939) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_packuswb)
		opcode: (u16((if (((3943) & 65280) == 3840) {
			((((3943) >> 8) & ~255) | ((3943) & 255))
		} else {
			(3943)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3943) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddb)
		opcode: (u16((if (((4092) & 65280) == 3840) {
			((((4092) >> 8) & ~255) | ((4092) & 255))
		} else {
			(4092)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4092) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddw)
		opcode: (u16((if (((4093) & 65280) == 3840) {
			((((4093) >> 8) & ~255) | ((4093) & 255))
		} else {
			(4093)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4093) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddd)
		opcode: (u16((if (((4094) & 65280) == 3840) {
			((((4094) >> 8) & ~255) | ((4094) & 255))
		} else {
			(4094)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4094) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddsb)
		opcode: (u16((if (((4076) & 65280) == 3840) {
			((((4076) >> 8) & ~255) | ((4076) & 255))
		} else {
			(4076)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4076) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddsw)
		opcode: (u16((if (((4077) & 65280) == 3840) {
			((((4077) >> 8) & ~255) | ((4077) & 255))
		} else {
			(4077)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4077) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddusb)
		opcode: (u16((if (((4060) & 65280) == 3840) {
			((((4060) >> 8) & ~255) | ((4060) & 255))
		} else {
			(4060)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4060) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddusw)
		opcode: (u16((if (((4061) & 65280) == 3840) {
			((((4061) >> 8) & ~255) | ((4061) & 255))
		} else {
			(4061)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4061) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pand)
		opcode: (u16((if (((4059) & 65280) == 3840) {
			((((4059) >> 8) & ~255) | ((4059) & 255))
		} else {
			(4059)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4059) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pandn)
		opcode: (u16((if (((4063) & 65280) == 3840) {
			((((4063) >> 8) & ~255) | ((4063) & 255))
		} else {
			(4063)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4063) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpeqb)
		opcode: (u16((if (((3956) & 65280) == 3840) {
			((((3956) >> 8) & ~255) | ((3956) & 255))
		} else {
			(3956)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3956) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpeqw)
		opcode: (u16((if (((3957) & 65280) == 3840) {
			((((3957) >> 8) & ~255) | ((3957) & 255))
		} else {
			(3957)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3957) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpeqd)
		opcode: (u16((if (((3958) & 65280) == 3840) {
			((((3958) >> 8) & ~255) | ((3958) & 255))
		} else {
			(3958)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3958) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpgtb)
		opcode: (u16((if (((3940) & 65280) == 3840) {
			((((3940) >> 8) & ~255) | ((3940) & 255))
		} else {
			(3940)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3940) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpgtw)
		opcode: (u16((if (((3941) & 65280) == 3840) {
			((((3941) >> 8) & ~255) | ((3941) & 255))
		} else {
			(3941)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3941) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpgtd)
		opcode: (u16((if (((3942) & 65280) == 3840) {
			((((3942) >> 8) & ~255) | ((3942) & 255))
		} else {
			(3942)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3942) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmaddwd)
		opcode: (u16((if (((4085) & 65280) == 3840) {
			((((4085) >> 8) & ~255) | ((4085) & 255))
		} else {
			(4085)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4085) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmulhw)
		opcode: (u16((if (((4069) & 65280) == 3840) {
			((((4069) >> 8) & ~255) | ((4069) & 255))
		} else {
			(4069)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4069) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmullw)
		opcode: (u16((if (((4053) & 65280) == 3840) {
			((((4053) >> 8) & ~255) | ((4053) & 255))
		} else {
			(4053)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4053) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_por)
		opcode: (u16((if (((4075) & 65280) == 3840) {
			((((4075) >> 8) & ~255) | ((4075) & 255))
		} else {
			(4075)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4075) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllw)
		opcode: (u16((if (((4081) & 65280) == 3840) {
			((((4081) >> 8) & ~255) | ((4081) & 255))
		} else {
			(4081)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4081) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllw)
		opcode: (u16((if (((3953) & 65280) == 3840) {
			((((3953) >> 8) & ~255) | ((3953) & 255))
		} else {
			(3953)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((3953) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pslld)
		opcode: (u16((if (((4082) & 65280) == 3840) {
			((((4082) >> 8) & ~255) | ((4082) & 255))
		} else {
			(4082)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4082) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pslld)
		opcode: (u16((if (((3954) & 65280) == 3840) {
			((((3954) >> 8) & ~255) | ((3954) & 255))
		} else {
			(3954)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((3954) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllq)
		opcode: (u16((if (((4083) & 65280) == 3840) {
			((((4083) >> 8) & ~255) | ((4083) & 255))
		} else {
			(4083)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4083) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllq)
		opcode: (u16((if (((3955) & 65280) == 3840) {
			((((3955) >> 8) & ~255) | ((3955) & 255))
		} else {
			(3955)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((3955) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psraw)
		opcode: (u16((if (((4065) & 65280) == 3840) {
			((((4065) >> 8) & ~255) | ((4065) & 255))
		} else {
			(4065)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4065) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psraw)
		opcode: (u16((if (((3953) & 65280) == 3840) {
			((((3953) >> 8) & ~255) | ((3953) & 255))
		} else {
			(3953)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((3953) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrad)
		opcode: (u16((if (((4066) & 65280) == 3840) {
			((((4066) >> 8) & ~255) | ((4066) & 255))
		} else {
			(4066)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4066) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrad)
		opcode: (u16((if (((3954) & 65280) == 3840) {
			((((3954) >> 8) & ~255) | ((3954) & 255))
		} else {
			(3954)
		})))
		instr_type: u16(((8) | ((4) << 13) | (if (((3954) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlw)
		opcode: (u16((if (((4049) & 65280) == 3840) {
			((((4049) >> 8) & ~255) | ((4049) & 255))
		} else {
			(4049)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4049) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlw)
		opcode: (u16((if (((3953) & 65280) == 3840) {
			((((3953) >> 8) & ~255) | ((3953) & 255))
		} else {
			(3953)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3953) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrld)
		opcode: (u16((if (((4050) & 65280) == 3840) {
			((((4050) >> 8) & ~255) | ((4050) & 255))
		} else {
			(4050)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4050) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrld)
		opcode: (u16((if (((3954) & 65280) == 3840) {
			((((3954) >> 8) & ~255) | ((3954) & 255))
		} else {
			(3954)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3954) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlq)
		opcode: (u16((if (((4051) & 65280) == 3840) {
			((((4051) >> 8) & ~255) | ((4051) & 255))
		} else {
			(4051)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4051) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlq)
		opcode: (u16((if (((3955) & 65280) == 3840) {
			((((3955) >> 8) & ~255) | ((3955) & 255))
		} else {
			(3955)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3955) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_im8), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubb)
		opcode: (u16((if (((4088) & 65280) == 3840) {
			((((4088) >> 8) & ~255) | ((4088) & 255))
		} else {
			(4088)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4088) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubw)
		opcode: (u16((if (((4089) & 65280) == 3840) {
			((((4089) >> 8) & ~255) | ((4089) & 255))
		} else {
			(4089)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4089) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubd)
		opcode: (u16((if (((4090) & 65280) == 3840) {
			((((4090) >> 8) & ~255) | ((4090) & 255))
		} else {
			(4090)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4090) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubsb)
		opcode: (u16((if (((4072) & 65280) == 3840) {
			((((4072) >> 8) & ~255) | ((4072) & 255))
		} else {
			(4072)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4072) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubsw)
		opcode: (u16((if (((4073) & 65280) == 3840) {
			((((4073) >> 8) & ~255) | ((4073) & 255))
		} else {
			(4073)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4073) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubusb)
		opcode: (u16((if (((4056) & 65280) == 3840) {
			((((4056) >> 8) & ~255) | ((4056) & 255))
		} else {
			(4056)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4056) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubusw)
		opcode: (u16((if (((4057) & 65280) == 3840) {
			((((4057) >> 8) & ~255) | ((4057) & 255))
		} else {
			(4057)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4057) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckhbw)
		opcode: (u16((if (((3944) & 65280) == 3840) {
			((((3944) >> 8) & ~255) | ((3944) & 255))
		} else {
			(3944)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3944) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckhwd)
		opcode: (u16((if (((3945) & 65280) == 3840) {
			((((3945) >> 8) & ~255) | ((3945) & 255))
		} else {
			(3945)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3945) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckhdq)
		opcode: (u16((if (((3946) & 65280) == 3840) {
			((((3946) >> 8) & ~255) | ((3946) & 255))
		} else {
			(3946)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3946) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpcklbw)
		opcode: (u16((if (((3936) & 65280) == 3840) {
			((((3936) >> 8) & ~255) | ((3936) & 255))
		} else {
			(3936)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3936) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpcklwd)
		opcode: (u16((if (((3937) & 65280) == 3840) {
			((((3937) >> 8) & ~255) | ((3937) & 255))
		} else {
			(3937)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3937) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckldq)
		opcode: (u16((if (((3938) & 65280) == 3840) {
			((((3938) >> 8) & ~255) | ((3938) & 255))
		} else {
			(3938)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3938) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pxor)
		opcode: (u16((if (((4079) & 65280) == 3840) {
			((((4079) >> 8) & ~255) | ((4079) & 255))
		} else {
			(4079)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4079) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ldmxcsr)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_stmxcsr)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movups)
		opcode: (u16((if (((3856) & 65280) == 3840) {
			((((3856) >> 8) & ~255) | ((3856) & 255))
		} else {
			(3856)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3856) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg32), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movups)
		opcode: (u16((if (((3857) & 65280) == 3840) {
			((((3857) >> 8) & ~255) | ((3857) & 255))
		} else {
			(3857)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3857) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_sse), opt_ea | opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movaps)
		opcode: (u16((if (((3880) & 65280) == 3840) {
			((((3880) >> 8) & ~255) | ((3880) & 255))
		} else {
			(3880)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3880) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg32), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movaps)
		opcode: (u16((if (((3881) & 65280) == 3840) {
			((((3881) >> 8) & ~255) | ((3881) & 255))
		} else {
			(3881)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3881) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_sse), opt_ea | opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movhps)
		opcode: (u16((if (((3862) & 65280) == 3840) {
			((((3862) >> 8) & ~255) | ((3862) & 255))
		} else {
			(3862)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3862) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg32), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movhps)
		opcode: (u16((if (((3863) & 65280) == 3840) {
			((((3863) >> 8) & ~255) | ((3863) & 255))
		} else {
			(3863)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3863) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_sse), opt_ea | opt_reg32, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addps)
		opcode: (u16((if (((3928) & 65280) == 3840) {
			((((3928) >> 8) & ~255) | ((3928) & 255))
		} else {
			(3928)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3928) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cvtpi2ps)
		opcode: (u16((if (((3882) & 65280) == 3840) {
			((((3882) >> 8) & ~255) | ((3882) & 255))
		} else {
			(3882)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3882) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmx), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cvtps2pi)
		opcode: (u16((if (((3885) & 65280) == 3840) {
			((((3885) >> 8) & ~255) | ((3885) & 255))
		} else {
			(3885)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3885) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_mmx, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cvttps2pi)
		opcode: (u16((if (((3884) & 65280) == 3840) {
			((((3884) >> 8) & ~255) | ((3884) & 255))
		} else {
			(3884)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3884) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_mmx, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_divps)
		opcode: (u16((if (((3934) & 65280) == 3840) {
			((((3934) >> 8) & ~255) | ((3934) & 255))
		} else {
			(3934)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3934) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_maxps)
		opcode: (u16((if (((3935) & 65280) == 3840) {
			((((3935) >> 8) & ~255) | ((3935) & 255))
		} else {
			(3935)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3935) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_minps)
		opcode: (u16((if (((3933) & 65280) == 3840) {
			((((3933) >> 8) & ~255) | ((3933) & 255))
		} else {
			(3933)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3933) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mulps)
		opcode: (u16((if (((3929) & 65280) == 3840) {
			((((3929) >> 8) & ~255) | ((3929) & 255))
		} else {
			(3929)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3929) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pavgb)
		opcode: (u16((if (((4064) & 65280) == 3840) {
			((((4064) >> 8) & ~255) | ((4064) & 255))
		} else {
			(4064)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4064) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pavgw)
		opcode: (u16((if (((4067) & 65280) == 3840) {
			((((4067) >> 8) & ~255) | ((4067) & 255))
		} else {
			(4067)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4067) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmaxsw)
		opcode: (u16((if (((4078) & 65280) == 3840) {
			((((4078) >> 8) & ~255) | ((4078) & 255))
		} else {
			(4078)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4078) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmaxub)
		opcode: (u16((if (((4062) & 65280) == 3840) {
			((((4062) >> 8) & ~255) | ((4062) & 255))
		} else {
			(4062)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4062) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pminsw)
		opcode: (u16((if (((4074) & 65280) == 3840) {
			((((4074) >> 8) & ~255) | ((4074) & 255))
		} else {
			(4074)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4074) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pminub)
		opcode: (u16((if (((4058) & 65280) == 3840) {
			((((4058) >> 8) & ~255) | ((4058) & 255))
		} else {
			(4058)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4058) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_mmxsse), opt_mmxsse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rcpss)
		opcode: (u16((if (((3923) & 65280) == 3840) {
			((((3923) >> 8) & ~255) | ((3923) & 255))
		} else {
			(3923)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3923) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rsqrtps)
		opcode: (u16((if (((3922) & 65280) == 3840) {
			((((3922) >> 8) & ~255) | ((3922) & 255))
		} else {
			(3922)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3922) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sqrtps)
		opcode: (u16((if (((3921) & 65280) == 3840) {
			((((3921) >> 8) & ~255) | ((3921) & 255))
		} else {
			(3921)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3921) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_subps)
		opcode: (u16((if (((3932) & 65280) == 3840) {
			((((3932) >> 8) & ~255) | ((3932) & 255))
		} else {
			(3932)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3932) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_sse), opt_sse, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movnti)
		opcode: (u16((if (((4035) & 65280) == 3840) {
			((((4035) >> 8) & ~255) | ((4035) & 255))
		} else {
			(4035)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4035) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movntil)
		opcode: (u16((if (((4035) & 65280) == 3840) {
			((((4035) >> 8) & ~255) | ((4035) & 255))
		} else {
			(4035)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((4035) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg32), opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movntiq)
		opcode: (u16((if (((4035) & 65280) == 3840) {
			((((4035) >> 8) & ~255) | ((4035) & 255))
		} else {
			(4035)
		})))
		instr_type: u16(((8 | 512) | ((0) << 13) | (if (((4035) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 2
		op_type: [u8(opt_reg64), opt_ea, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_prefetchnta)
		opcode: (u16((if (((3864) & 65280) == 3840) {
			((((3864) >> 8) & ~255) | ((3864) & 255))
		} else {
			(3864)
		})))
		instr_type: u16(((8) | ((0) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_prefetcht0)
		opcode: (u16((if (((3864) & 65280) == 3840) {
			((((3864) >> 8) & ~255) | ((3864) & 255))
		} else {
			(3864)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_prefetcht1)
		opcode: (u16((if (((3864) & 65280) == 3840) {
			((((3864) >> 8) & ~255) | ((3864) & 255))
		} else {
			(3864)
		})))
		instr_type: u16(((8) | ((2) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_prefetcht2)
		opcode: (u16((if (((3864) & 65280) == 3840) {
			((((3864) >> 8) & ~255) | ((3864) & 255))
		} else {
			(3864)
		})))
		instr_type: u16(((8) | ((3) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_prefetchw)
		opcode: (u16((if (((3853) & 65280) == 3840) {
			((((3853) >> 8) & ~255) | ((3853) & 255))
		} else {
			(3853)
		})))
		instr_type: u16(((8) | ((1) << 13) | (if (((3853) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lfence)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((5) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mfence)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((6) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sfence)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 0
		op_type: [u8(0), 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_clflush)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16(((8) | ((7) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 })))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: 0
	},
]!

const op0_codes = [248, 252, 250, 3846, 245, 159, 158, 156, 157, 156, 157, 249, 253, 251, 55, 63,
	39, 47, 54538, 54282, 26264, 26265, 152, 153, 26264, 152, 26265, 153, 18585, 204, 206, 207,
	26319, 207, 18639, 4010, 244, 155, 144, 62352, 215, 240, 243, 243, 243, 242, 242, 3848, 3849,
	4002, 3888, 3889, 3890, 3891, 3845, 3847, 3851, 201, 195, 195, 203, 56041, 55780, 55781, 55784,
	55785, 55786, 55787, 55788, 55789, 55790, 55792, 55793, 55794, 55795, 55796, 55797, 55798,
	55799, 55800, 55801, 55802, 55803, 55804, 55805, 55806, 55807, 55776, 55777, 56291, 56290,
	55760, 155, 55753, 57312, 3959]!

fn get_reg_shift(s1 &TCCState) int {
	shift := 0
	v := 0

	v = asm_int_expr(s1)
	match v {
		1 { // case comp body kind=BinaryOperator is_enum=false
			shift = 0
		}
		2 { // case comp body kind=BinaryOperator is_enum=false
			shift = 1
		}
		4 { // case comp body kind=BinaryOperator is_enum=false
			shift = 2
		}
		8 { // case comp body kind=BinaryOperator is_enum=false
			shift = 3

			shift = 0
		}
		else {
			expect(c'1, 2, 4 or 8 constant')
		}
	}
	return shift
}

fn asm_parse_numeric_reg(t int, type_ &u32) int {
	reg := -1
	if t >= 256 && t < tok_ident {
		s := &char(table_ident[t - 256].str)
		c := rune(0)
		*type_ = (1 << opt_reg64)
		if *s == `c` {
			unsafe { s++ }
			*type_ = (1 << opt_cr)
		}
		if unsafe { *s++ } != `r` {
			return -1
		}
		c = unsafe { *s++ }
		if c >= `1` && c <= `9` {
			reg = c - `0`
		} else {
			return -1
		}
		c = *s
		if c >= `0` && c <= `5` {
			unsafe { s++ }
			reg = reg * 10 + c - `0`
		}
		if reg > 15 {
			return -1
		}
		c = *s
		if c == 0 {
		} else if *type_ != (1 << opt_reg64) {
			return -1
		} else if c == `b` && !s[1] {
			*type_ = (1 << opt_reg8)
		} else if c == `w` && !s[1] {
			*type_ = (1 << opt_reg16)
		} else if c == `d` && !s[1] {
			*type_ = (1 << opt_reg32)
		} else {
			return -1
		}
	}
	return reg
}

fn asm_parse_reg(type_ &u32) int {
	reg := 0
	*type_ = 0
	if tok != `%` {
		goto error_32 // id: 0x7fffe2361bb8
	}
	next()
	if tok >= Tcc_token.tok_asm_eax && tok <= Tcc_token.tok_asm_edi {
		reg = tok - Tcc_token.tok_asm_eax
		*type_ = (1 << opt_reg32)
	} else if tok >= Tcc_token.tok_asm_rax && tok <= Tcc_token.tok_asm_rdi {
		reg = tok - Tcc_token.tok_asm_rax
		*type_ = (1 << opt_reg64)
	} else if tok == Tcc_token.tok_asm_rip {
		reg = -2
		*type_ = (1 << opt_reg64)
	} else if asm_parse_numeric_reg(tok, type_) >= 0 && (*type_ == (1 << opt_reg32)
		|| *type_ == (1 << opt_reg64)) {
		reg = asm_parse_numeric_reg(tok, type_)
	} else {
		// RRRREG error_32 id=0x7fffe2361bb8
		error_32:
		expect(c'register')
	}
	next()
	return reg
}

fn parse_operand(s1 &TCCState, op &Operand) {
	e := ExprValue{}
	reg := 0
	indir := 0

	p := &rune(0)
	indir = 0
	if tok == `*` {
		next()
		indir = (1 << opt_indir)
	}
	if tok == `%` {
		next()
		if tok >= Tcc_token.tok_asm_al && tok <= Tcc_token.tok_asm_db7 {
			reg = tok - Tcc_token.tok_asm_al
			op.type_ = 1 << (reg >> 3)
			op.reg = reg & 7
			if op.type_ & ((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64))
				&& op.reg == treg_rax {
				op.type_ |= (1 << opt_eax)
			} else if op.type_ == (1 << opt_reg8) && op.reg == treg_rcx {
				op.type_ |= (1 << opt_cl)
			} else if op.type_ == (1 << opt_reg16) && op.reg == treg_rdx {
				op.type_ |= (1 << opt_dx)
			}
		} else if tok >= Tcc_token.tok_asm_dr0 && tok <= Tcc_token.tok_asm_dr7 {
			op.type_ = (1 << opt_db)
			op.reg = tok - Tcc_token.tok_asm_dr0
		} else if tok >= Tcc_token.tok_asm_es && tok <= Tcc_token.tok_asm_gs {
			op.type_ = (1 << opt_seg)
			op.reg = tok - Tcc_token.tok_asm_es
		} else if tok == Tcc_token.tok_asm_st {
			op.type_ = (1 << opt_st)
			op.reg = 0
			next()
			if tok == `(` {
				next()
				if tok != 205 {
					goto reg_error // id: 0x7fffe2365088
				}
				p = tokc.str.data
				reg = p[0] - `0`
				if u32(reg) >= 8 || p[1] != `\x00` {
					goto reg_error // id: 0x7fffe2365088
				}
				op.reg = reg
				next()
				skip(`)`)
			}
			if op.reg == 0 {
				op.type_ |= (1 << opt_st0)
			}
			goto no_skip // id: 0x7fffe2365990
		} else if tok >= Tcc_token.tok_asm_spl && tok <= Tcc_token.tok_asm_dil {
			op.type_ = (1 << opt_reg8) | (1 << opt_reg8_low)
			op.reg = 4 + tok - Tcc_token.tok_asm_spl
		} else if asm_parse_numeric_reg(tok, &op.type_) >= 0 {
			op.reg = asm_parse_numeric_reg(tok, &op.type_)
		} else {
			// RRRREG reg_error id=0x7fffe2365088
			reg_error:
			_tcc_error('unknown register ${get_tok_str(tok, &tokc)}')
		}
		next()
		// RRRREG no_skip id=0x7fffe2365990
		no_skip:
		0
	} else if tok == `$` {
		next()
		asm_expr(s1, &e)
		op.type_ = (1 << opt_im32)
		op.e = e
		if !op.e.sym {
			if op.e.v == u8(op.e.v) {
				op.type_ |= (1 << opt_im8)
			}
			if op.e.v == u64(i8(op.e.v)) {
				op.type_ |= (1 << opt_im8s)
			}
			if op.e.v == u16(op.e.v) {
				op.type_ |= (1 << opt_im16)
			}
			if op.e.v != u64(int(op.e.v)) && op.e.v != u32(op.e.v) {
				op.type_ = (1 << opt_im64)
			}
		}
	} else {
		op.type_ = 1073741824
		op.reg = -1
		op.reg2 = -1
		op.shift = 0
		if tok != `(` {
			asm_expr(s1, &e)
			op.e = e
		} else {
			next()
			if tok == `%` {
				unget_tok(`(`)
				op.e.v = 0
				op.e.sym = (unsafe { nil })
			} else {
				asm_expr(s1, &e)
				if tok != `)` {
					expect(c')')
				}
				next()
				op.e.v = e.v
				op.e.sym = e.sym
			}
			op.e.pcrel = 0
		}
		if tok == `(` {
			type_ := 0
			next()
			if tok != `,` {
				op.reg = asm_parse_reg(&type_)
			}
			if tok == `,` {
				next()
				if tok != `,` {
					op.reg2 = asm_parse_reg(&type_)
				}
				if tok == `,` {
					next()
					op.shift = get_reg_shift(s1)
				}
			}
			if type_ & (1 << opt_reg32) {
				op.type_ |= (1073741824 << 1)
			}
			skip(`)`)
		}
		if op.reg == -1 && op.reg2 == -1 {
			op.type_ |= (1 << opt_addr)
		}
	}
	op.type_ |= indir
}

fn gen_expr32(pe &ExprValue) {
	if pe.pcrel {
		gen_addrpc32(512, pe.sym, pe.v)
	} else { // 3
		gen_addr32(if pe.sym { 512 } else { 0 }, pe.sym, pe.v)
	}
}

fn gen_expr64(pe &ExprValue) {
	gen_addr64(if pe.sym { 512 } else { 0 }, pe.sym, pe.v)
}

fn gen_disp32(pe &ExprValue) {
	sym := pe.sym
	esym := elfsym(sym)
	if esym && esym.st_shndx == tcc_state.cur_text_section.sh_num {
		mut val := pe.v + esym.st_value
		val -= ind
		val -= 4
		gen_le32(val)
	} else {
		if sym && sym.type_.t == 0 {
			sym.type_.t = 6
			sym.type_.ref = (unsafe { nil })
		}
		greloca(tcc_state.cur_text_section, sym, ind, 4, pe.v - 4)
		gen_le32(0)
	}
}

fn asm_modrm(reg int, op &Operand) int {
	mod := 0
	reg1 := 0
	reg2 := 0
	sib_reg1 := 0

	if op.type_ & (((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) | (1 << opt_mmx) | (1 << opt_sse)) {
		g(192 + (reg << 3) + op.reg)
	} else if op.reg == -1 && op.reg2 == -1 {
		g(4 + (reg << 3))
		g(37)
		gen_expr32(&op.e)
	} else if op.reg == -2 {
		pe := &op.e
		g(5 + (reg << 3))
		gen_addrpc32(if pe.sym { 512 } else { 0 }, pe.sym, pe.v)
		return ind
	} else {
		sib_reg1 = op.reg
		if sib_reg1 == -1 {
			sib_reg1 = 5
			mod = 0
		} else if op.e.v == 0 && !op.e.sym && op.reg != 5 {
			mod = 0
		} else if !op.e.sym {
			mod = 64
		} else {
			mod = 128
		}
		reg1 = op.reg
		if op.reg2 != -1 {
			reg1 = 4
		}
		g(mod + (reg << 3) + reg1)
		if reg1 == 4 {
			reg2 = op.reg2
			if reg2 == -1 {
				reg2 = 4
			}
			g((op.shift << 6) + (reg2 << 3) + sib_reg1)
		}
		if mod == 64 {
			g(op.e.v)
		} else if mod == 128 || op.reg == -1 {
			gen_expr32(&op.e)
		}
	}
	return 0
}

fn asm_rex(width64 int, ops &Operand, nb_ops int, op_type &int, regi int, rmi int) {
	rex := if width64 { 72 } else { 0 }
	saw_high_8bit := 0
	i := 0
	if rmi == -1 {
		for i = 0; i < nb_ops; i++ {
			if op_type[i] & (((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) | (1 << opt_st)) {
				if ops[i].reg >= 8 {
					rex |= 65
					ops[i].reg -= 8
				} else if ops[i].type_ & (1 << opt_reg8_low) {
					rex |= 64
				} else if ops[i].type_ & (1 << opt_reg8) && ops[i].reg >= 4 {
					saw_high_8bit = ops[i].reg
				}
				break
			}
		}
	} else {
		if regi != -1 {
			if ops[regi].reg >= 8 {
				rex |= 68
				ops[regi].reg -= 8
			} else if ops[regi].type_ & (1 << opt_reg8_low) {
				rex |= 64
			} else if ops[regi].type_ & (1 << opt_reg8) && ops[regi].reg >= 4 {
				saw_high_8bit = ops[regi].reg
			}
		}
		if ops[rmi].type_ & (((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) | (1 << opt_mmx) | (1 << opt_sse) | (1 << opt_cr) | 1073741824) {
			if ops[rmi].reg >= 8 {
				rex |= 65
				ops[rmi].reg -= 8
			} else if ops[rmi].type_ & (1 << opt_reg8_low) {
				rex |= 64
			} else if ops[rmi].type_ & (1 << opt_reg8) && ops[rmi].reg >= 4 {
				saw_high_8bit = ops[rmi].reg
			}
		}
		if ops[rmi].type_ & 1073741824 && ops[rmi].reg2 >= 8 {
			rex |= 66
			ops[rmi].reg2 -= 8
		}
	}
	if rex {
		if saw_high_8bit {
			_tcc_error("can't encode register ${'acdb'[saw_high_8bit - 4]}h when REX prefix is required")
		}
		g(rex)
	}
}

fn maybe_print_stats() {
	already := 0
	if 0 && !already {
		pa := &ASMInstr(0)
		freq := [4]int{}
		op_vals := [500]int{}
		nb_op_vals := 0
		i := 0
		j := 0

		already = 1
		nb_op_vals = 0
		C.memset(freq, 0, sizeof(freq))
		pa = asm_instrs
		for pa.sym != 0 {
			freq[pa.nb_ops]++
			for j = 0; j < nb_op_vals; j++ {
				if pa.instr_type == op_vals[j] {
					goto found // id: 0x7fffe23783c8
				}
			}
			op_vals[nb_op_vals++] = pa.instr_type
			// RRRREG found id=0x7fffe23783c8
			found:
			unsafe { pa++ }
		}
		for i = 0; i < nb_op_vals; i++ {
			v := op_vals[i]
			C.printf(c'%3d: %08x\n', i, v)
		}
		C.printf(c'size=%d nb=%d f0=%d f1=%d f2=%d f3=%d\n', int(sizeof(asm_instrs)),
			int(sizeof(asm_instrs)) / int(sizeof(ASMInstr)), freq[0], freq[1], freq[2],
			freq[3])
	}
}

fn asm_opcode(s1 &TCCState, opcode int) {
	pa := &ASMInstr(0)
	i := 0
	modrm_index := 0
	modreg_index := 0
	reg := 0
	v := 0
	op1 := 0
	seg_prefix := 0
	pc := 0
	p := 0

	nb_ops := 0
	s := 0

	ops := [3]Operand{}
	pop := &Operand(0)

	op_type := [3]int{}
	alltypes := 0
	autosize := 0
	p66 := 0
	rex64 := 0
	maybe_print_stats()
	if opcode >= Tcc_token.tok_asm_wait && opcode <= Tcc_token.tok_asm_repnz {
		unget_tok(`;`)
	}
	pop = ops
	nb_ops = 0
	seg_prefix = 0
	alltypes = 0
	for ; true; {
		if tok == `;` || tok == 10 {
			break
		}
		if nb_ops >= 3 {
			_tcc_error('incorrect number of operands')
		}
		parse_operand(s1, pop)
		if tok == `:` {
			if pop.type_ != (1 << opt_seg) || seg_prefix {
				_tcc_error('incorrect prefix')
			}
			seg_prefix = segment_prefixes[pop.reg]
			next()
			parse_operand(s1, pop)
			if !(pop.type_ & 1073741824) {
				_tcc_error('segment prefix must be followed by memory reference')
			}
		}
		unsafe { pop++ }
		nb_ops++
		if tok != `,` {
			break
		}
		next()
	}
	s = 0
	// RRRREG again id=0x7fffe2380130

	pa = asm_instrs
	again: for pa.sym != 0 {
		it := pa.instr_type & 112
		s = 0
		if it == 64 {
			v = opcode - pa.sym
			if !(u32(v) < 8 * 6 && (v % 6) == 0) {
				unsafe { pa++ }
				continue
			}
		} else if it == 48 {
			if !(opcode >= pa.sym && opcode < pa.sym + 8 * 5) {
				unsafe { pa++ }
				continue
			}
			s = (opcode - pa.sym) % 5
			if (pa.instr_type & (1 | 4096)) == 4096 {
				if ((opcode - pa.sym + 1) % 5) == 0 {
					unsafe { pa++ }
					continue
				}
				s++
			}
		} else if it == 32 {
			if !(opcode >= pa.sym && opcode < pa.sym + 7 * 5) {
				unsafe { pa++ }
				continue
			}
			s = (opcode - pa.sym) % 5
		} else if it == 80 {
			if !(opcode >= pa.sym && opcode < pa.sym + 30) {
				unsafe { pa++ }
				continue
			}
			if pa.instr_type & 4096 {
				s = 5 - 1
			}
		} else if pa.instr_type & 1 {
			if (pa.instr_type & 4096) != 4096 && !(opcode >= pa.sym && opcode < pa.sym + 5 - 1) {
				unsafe { pa++ }
				continue
			}
			if !(opcode >= pa.sym && opcode < pa.sym + 5) {
				unsafe { pa++ }
				continue
			}
			s = opcode - pa.sym
		} else if pa.instr_type & 4096 {
			if !(opcode >= pa.sym && opcode < pa.sym + 5 - 1) {
				unsafe { pa++ }
				continue
			}
			s = opcode - pa.sym + 1
		} else {
			if pa.sym != opcode {
				unsafe { pa++ }
				continue
			}
		}
		if pa.nb_ops != nb_ops {
			unsafe { pa++ }
			continue
		}
		if pa.opcode == 176 && ops[0].type_ != (1 << opt_im64)&& (ops[1].type_ & ((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64))) == (1 << opt_reg64)
			&& !(pa.instr_type & 256) {
			unsafe { pa++ }
			continue
		}
		alltypes = 0
		for i = 0; i < nb_ops; i++ {
			op1 = 0
			op2 := 0

			op1 = pa.op_type[i]
			op2 = op1 & 31
			match op2 {
				opt_im { // case comp body kind=BinaryOperator is_enum=true
					v = (1 << opt_im8) | (1 << opt_im16) | (1 << opt_im32)
				}
				opt_reg { // case comp body kind=BinaryOperator is_enum=true
					v = (1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)
				}
				opt_regw { // case comp body kind=BinaryOperator is_enum=true
					v = (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)
				}
				opt_imw { // case comp body kind=BinaryOperator is_enum=true
					v = (1 << opt_im16) | (1 << opt_im32)
				}
				opt_mmxsse { // case comp body kind=BinaryOperator is_enum=true
					v = (1 << opt_mmx) | (1 << opt_sse)
				}
				opt_disp, opt_disp8 {
					v = (1 << opt_addr)
				}
				else {
					v = 1 << op2
				}
			}
			if op1 & opt_ea {
				v |= 1073741824
			}
			op_type[i] = v
			if (ops[i].type_ & v) == 0 {
				goto next // id: 0x7fffe237fdc0
			}
			alltypes |= ops[i].type_
		}
		break

		// RRRREG next id=0x7fffe237fdc0
		next:
		unsafe { pa++ }
	}
	if pa.sym == 0 {
		if opcode >= Tcc_token.tok_asm_clc && opcode <= Tcc_token.tok_asm_emms {
			b := 0
			b = op0_codes[opcode - int(Tcc_token.tok_asm_clc)]
			if b & 65280 {
				g(b >> 8)
			}
			g(b)
			return
		} else if opcode <= Tcc_token.tok_asm_subps {
			_tcc_error("bad operand with opcode '${get_tok_str(opcode, (unsafe { nil }))}'")
		} else {
			ts := table_ident[opcode - 256]
			if ts.len >= 6 && C.strchr(c'wlq', ts.str[ts.len - 1]) && !C.memcmp(ts.str, c'cmov', 4) {
				opcode = tok_alloc(ts.str, ts.len - 1).tok
				goto again // id: 0x7fffe2380130
			}
			_tcc_error("unknown opcode '${ts.str}'")
		}
	}
	autosize = 5 - 1
	if (pa.instr_type & (1 | 4096)) == 1 {
		autosize = 5 - 2
	}
	if s == autosize {
		for i = nb_ops - 1; s == autosize && i >= 0; i-- {
			if ops[i].type_ & ((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64))
				&& !(op_type[i] & ((1 << opt_cl) | (1 << opt_dx))) {
				s = reg_to_size[ops[i].type_ & ((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64))]
			}
		}
		if s == autosize {
			if (opcode == Tcc_token.tok_asm_push || opcode == Tcc_token.tok_asm_pop)
				&& ops[0].type_ & ((1 << opt_seg) | (1 << opt_im8s) | (1 << opt_im32)) {
				s = 2
			} else if (opcode == Tcc_token.tok_asm_push || opcode == Tcc_token.tok_asm_pop)
				&& ops[0].type_ & 1073741824 {
				s = 5 - 2
			} else { // 3
				_tcc_error('cannot infer opcode suffix')
			}
		}
	}
	rex64 = 0
	if pa.instr_type & 512 {
		rex64 = 1
	} else if s == 3 || alltypes & (1 << opt_reg64) {
		default64 := 0
		for i = 0; i < nb_ops; i++ {
			if op_type[i] == (1 << opt_reg64) && pa.opcode != 184 {
				default64 = 1
				break
			}
		}
		if (opcode != Tcc_token.tok_asm_push && opcode != Tcc_token.tok_asm_pop
			&& opcode != Tcc_token.tok_asm_pushw && opcode != Tcc_token.tok_asm_pushl
			&& opcode != Tcc_token.tok_asm_pushq && opcode != Tcc_token.tok_asm_popw
			&& opcode != Tcc_token.tok_asm_popl && opcode != Tcc_token.tok_asm_popq
			&& opcode != Tcc_token.tok_asm_call && opcode != Tcc_token.tok_asm_jmp) && !default64 {
			rex64 = 1
		}
	}
	if (((pa.instr_type) & 112) == (16)) {
		g(155)
	}
	if seg_prefix {
		g(seg_prefix)
	}
	for i = 0; i < nb_ops; i++ {
		if ops[i].type_ & (1073741824 << 1) {
			g(103)
			break
		}
	}
	p66 = 0
	if s == 1 {
		p66 = 1
	} else {
		for i = 0; i < nb_ops; i++ {
			if (op_type[i] & ((1 << opt_mmx) | (1 << opt_sse))) == ((1 << opt_mmx) | (1 << opt_sse))
				&& ops[i].type_ & (1 << opt_sse) {
				p66 = 1
			}
		}
	}
	if p66 {
		g(102)
	}
	v = pa.opcode
	p = v >> 8
	match p {
		0 { // case comp body kind=BreakStmt is_enum=false
		}
		72 { // case comp body kind=BreakStmt is_enum=false
		}
		102, 103, 242, 243 {
			v = v & 255
			g(p)
		}
		212, 213 {}
		216, 217, 218, 219, 220, 221, 222, 223 {}
		else {
			_tcc_error('bad prefix 0x${p} in opcode table')
		}
	}
	if pa.instr_type & 256 {
		v = ((v & ~255) << 8) | 3840 | (v & 255)
	}
	if (v == 105 || v == 107) && nb_ops == 2 {
		nb_ops = 3
		ops[2] = ops[1]
		op_type[2] = op_type[1]
	} else if v == 205 && ops[0].e.v == 3 && !ops[0].e.sym {
		v--
		nb_ops = 0
	} else if (v == 6 || v == 7) {
		if ops[0].reg >= 4 {
			v = 4000 + (v - 6) + ((ops[0].reg - 4) << 3)
		} else {
			v += ops[0].reg << 3
		}
		nb_ops = 0
	} else if v <= 5 {
		v += ((opcode - Tcc_token.tok_asm_addb) / 5) << 3
	} else if (pa.instr_type & (112 | 8)) == 64 {
		v += ((opcode - pa.sym) / 6) << 3
	}
	modrm_index = -1
	modreg_index = -1
	if pa.instr_type & 8 {
		if !nb_ops {
			i = 0
			ops[i].type_ = ((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64))
			ops[i].reg = 0
			goto modrm_found // id: 0x7fffe2387d90
		}
		for i = 0; i < nb_ops; i++ {
			if op_type[i] & 1073741824 {
				goto modrm_found // id: 0x7fffe2387d90
			}
		}
		for i = 0; i < nb_ops; i++ {
			if op_type[i] & (((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) | (1 << opt_mmx) | (1 << opt_sse) | (1 << opt_indir)) {
				goto modrm_found // id: 0x7fffe2387d90
			}
		}
		// RRRREG modrm_found id=0x7fffe2387d90
		modrm_found:
		modrm_index = i
		for i = 0; i < nb_ops; i++ {
			t := op_type[i]
			if i != modrm_index
				&& t & (((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) | (1 << opt_mmx) | (1 << opt_sse) | (1 << opt_cr) | (1 << opt_tr) | (1 << opt_db) | (1 << opt_seg)) {
				modreg_index = i
				break
			}
		}
	}
	asm_rex(rex64, ops, nb_ops, op_type, modreg_index, modrm_index)
	if pa.instr_type & 4 {
		if v == 176 && s >= 1 {
			v += 7
		}
		for i = 0; i < nb_ops; i++ {
			if op_type[i] & (((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) | (1 << opt_st)) {
				v += ops[i].reg
				break
			}
		}
	}
	if pa.instr_type & 1 {
		v += s >= 1
	}
	if nb_ops == 1 && pa.op_type[0] == opt_disp8 {
		esym := &Elf64_Sym(0)
		jmp_disp := 0
		esym = elfsym(ops[0].e.sym)
		if !esym || esym.st_shndx != tcc_state.cur_text_section.sh_num {
			goto no_short_jump // id: 0x7fffe238a828
		}
		jmp_disp = ops[0].e.v + esym.st_value - ind - 2 - (v >= 255)
		if jmp_disp == i8(jmp_disp) {
			ops[0].e.sym = 0
			ops[0].e.v = jmp_disp
			op_type[0] = (1 << opt_im8s)
		} else {
			// RRRREG no_short_jump id=0x7fffe238a828
			no_short_jump:
			if v == 235 {
				v = 233
			} else if v == 112 {
				v += 3856
			} else { // 3
				_tcc_error('invalid displacement')
			}
		}
	}
	if (((pa.instr_type) & 112) == (80)) {
		v += test_bits[opcode - pa.sym]
	} else if (((pa.instr_type) & 112) == (96)) {
		v |= 983296
	}
	op1 = v >> 16
	if op1 {
		g(op1)
	}
	op1 = (v >> 8) & 255
	if op1 {
		g(op1)
	}
	g(v)
	if (((pa.instr_type) & 112) == (32)) {
		reg = (opcode - pa.sym) / 5
		if reg == 6 {
			reg = 7
		}
	} else if (((pa.instr_type) & 112) == (48)) {
		reg = (opcode - pa.sym) / 5
	} else if (((pa.instr_type) & 112) == (64)) {
		reg = (opcode - pa.sym) / 6
	} else {
		reg = (pa.instr_type >> 13) & 7
	}
	pc = 0
	if pa.instr_type & 8 {
		if modreg_index >= 0 {
			reg = ops[modreg_index].reg
		}
		pc = asm_modrm(reg, &ops[modrm_index])
	}
	for i = 0; i < nb_ops; i++ {
		v = op_type[i]
		if v & ((1 << opt_im8) | (1 << opt_im16) | (1 << opt_im32) | (1 << opt_im64) | (1 << opt_im8s) | (1 << opt_addr)) {
			if (v | (1 << opt_im8) | (1 << opt_im64)) == ((1 << opt_im8) | (1 << opt_im16) | (1 << opt_im32) | (1 << opt_im64)) {
				if s == 0 {
					v = (1 << opt_im8)
				} else if s == 1 {
					v = (1 << opt_im16)
				} else if s == 2 || (v & (1 << opt_im64)) == 0 {
					v = (1 << opt_im32)
				} else { // 3
					v = (1 << opt_im64)
				}
			}
			if v & ((1 << opt_im8) | (1 << opt_im8s) | (1 << opt_im16)) && ops[i].e.sym {
				_tcc_error('cannot relocate')
			}
			if v & ((1 << opt_im8) | (1 << opt_im8s)) {
				g(ops[i].e.v)
			} else if v & (1 << opt_im16) {
				gen_le16(ops[i].e.v)
			} else if v & (1 << opt_im64) {
				gen_expr64(&ops[i].e)
			} else if pa.op_type[i] == opt_disp || pa.op_type[i] == opt_disp8 {
				gen_disp32(&ops[i].e)
			} else {
				gen_expr32(&ops[i].e)
			}
		}
	}
	if pc {
		add32le(tcc_state.cur_text_section.data + pc - 4, pc - ind)
	}
}

fn constraint_priority(str &i8) int {
	priority := 0
	c := 0
	pr := 0

	priority = 0
	for ; true; {
		c = *str
		if c == `\x00` {
			break
		}
		str++
		match rune(c) {
			`A` { // case comp body kind=BinaryOperator is_enum=false
				pr = 0
			}
			`a`, `b`, `c`, `d`, `S`, `D` {
				pr = 1
			}
			`q` { // case comp body kind=BinaryOperator is_enum=false
				pr = 2
			}
			`r`, `R`, `p` {
				pr = 3
			}
			`N`, `M`, `I`, `e`, `i`, `m`, `g` {
				pr = 4

				pr = 0
			}
			else {
				_tcc_error("unknown constraint '${c}'")
			}
		}
		if pr > priority {
			priority = pr
		}
	}
	return priority
}

fn skip_constraint_modifiers(p &rune) &rune {
	for *p == `=` || *p == `&` || *p == `+` || *p == `%` {
		p++
	}
	return p
}

fn asm_parse_regvar(t int) int {
	s := &rune(0)
	op := Operand{}
	if t < 256 || t & 536870912 {
		return -1
	}
	s = table_ident[t - 256].str
	if s[0] != `%` {
		return -1
	}
	t = tok_alloc_const(s + 1)
	unget_tok(t)
	unget_tok(`%`)
	parse_operand(tcc_state, &op)
	if op.type_ & ((1 << opt_reg8) | (1 << opt_reg16) | (1 << opt_reg32) | (1 << opt_reg64)) {
		return op.reg
	} else {
		return -1
	}
}

fn asm_compute_constraints(operands &ASMOperand, nb_operands int, nb_outputs int, clobber_regs &u8, pout_reg &int) {
	op := &ASMOperand(0)
	sorted_op := [30]int{}
	i := 0
	j := 0
	k := 0
	p1 := 0
	p2 := 0
	tmp := 0
	reg := 0
	c := 0
	reg_mask := 0

	str := &rune(0)
	regs_allocated := [16]u8{}
	for i = 0; i < nb_operands; i++ {
		op = &ASMOperand(unsafe { &operands + i })
		op.input_index = -1
		op.ref_index = -1
		op.reg = -1
		op.is_memory = 0
		op.is_rw = 0
	}
	for i = 0; i < nb_operands; i++ {
		op = &ASMOperand(unsafe { &operands + i })
		str = op.constraint
		str = skip_constraint_modifiers(str)
		if isnum(*str) || *str == `[` {
			k = find_constraint(unsafe { &operands + 0 }, nb_operands, str, (unsafe { nil }))
			op_k := unsafe { &operands + k }
			if u32(k) >= i || i < nb_outputs {
				_tcc_error("invalid reference in constraint ${i} ('${str}')")
			}
			op.ref_index = k
			if op_k.input_index >= 0 {
				_tcc_error('cannot reference twice the same operand')
			}
			op_k.input_index = i
			op.priority = 5
		} else if (op.vt.r & 63) == 50 && op.vt.sym && op.vt.sym.r & 63 < 48 {
			reg = op.vt.sym.r & 63
			op.priority = 1
			op.reg = reg
		} else {
			op.priority = constraint_priority(str)
		}
	}
	for i = 0; i < nb_operands; i++ {
		sorted_op[i] = i
	}
	for i = 0; i < nb_operands - 1; i++ {
		for j = i + 1; j < nb_operands; j++ {
			op1 := unsafe { &operands + sorted_op[i] }
			op2 := unsafe { &operands + sorted_op[j] }
			p1 = op1.priority
			p2 = op2.priority
			if p2 < p1 {
				tmp = sorted_op[i]
				sorted_op[i] = sorted_op[j]
				sorted_op[j] = tmp
			}
		}
	}
	for i = 0; i < 16; i++ {
		if clobber_regs[i] {
			regs_allocated[i] = 2 | 1
		} else { // 3
			regs_allocated[i] = 0
		}
	}
	regs_allocated[4] = 2 | 1
	regs_allocated[5] = 2 | 1
	for i = 0; i < nb_operands; i++ {
		j = sorted_op[i]
		op = unsafe { &operands + j }
		str = op.constraint
		if op.ref_index >= 0 {
			continue
		}
		if op.input_index >= 0 {
			reg_mask = 2 | 1
		} else if j < nb_outputs {
			reg_mask = 1
		} else {
			reg_mask = 2
		}
		if op.reg >= 0 {
			if (regs_allocated[op.reg] & reg_mask) {
				_tcc_error("asm regvar requests register that's taken already")
			}
			reg = op.reg
			goto reg_found // id: 0x7fffe2396af8
		}
		// RRRREG try_next id=0x7fffe2396c68
		try_next:
		c = *str++
		match rune(c) {
			`=` { // case comp body kind=GotoStmt is_enum=false
				goto try_next // id: 0x7fffe2396c68
			}
			`+` { // case comp body kind=BinaryOperator is_enum=false
				op.is_rw = 1
			}
			`&` { // case comp body kind=IfStmt is_enum=false
				if j >= nb_outputs {
					_tcc_error("'${c}' modifier can only be applied to outputs")
				}
				reg_mask = 2 | 1
				goto try_next // id: 0x7fffe2396c68
			}
			`A` { // case comp body kind=IfStmt is_enum=false
				if regs_allocated[int(treg_rax)] & reg_mask
					|| regs_allocated[int(treg_rdx)] & reg_mask {
					goto try_next // id: 0x7fffe2396c68
				}
				op.is_llong = 1
				op.reg = treg_rax
				regs_allocated[int(treg_rax)] |= reg_mask
				regs_allocated[int(treg_rdx)] |= reg_mask
			}
			`a` { // case comp body kind=BinaryOperator is_enum=false
				reg = treg_rax
				goto alloc_reg // id: 0x7fffe2397878
			}
			`b` { // case comp body kind=BinaryOperator is_enum=false
				reg = 3
				goto alloc_reg // id: 0x7fffe2397878
			}
			`c` { // case comp body kind=BinaryOperator is_enum=false
				reg = treg_rcx
				goto alloc_reg // id: 0x7fffe2397878
			}
			`d` { // case comp body kind=BinaryOperator is_enum=false
				reg = treg_rdx
				goto alloc_reg // id: 0x7fffe2397878
			}
			`S` { // case comp body kind=BinaryOperator is_enum=false
				reg = 6
				goto alloc_reg // id: 0x7fffe2397878
			}
			`D` { // case comp body kind=BinaryOperator is_enum=false
				reg = 7
				// RRRREG alloc_reg id=0x7fffe2397878
				alloc_reg:
				if (regs_allocated[reg] & reg_mask) {
					goto try_next // id: 0x7fffe2396c68
				}
				goto reg_found // id: 0x7fffe2396af8
			}
			`q` { // case comp body kind=ForStmt is_enum=false
				for reg = 0; reg < 4; reg++ {
					if !(regs_allocated[reg] & reg_mask) {
						goto reg_found // id: 0x7fffe2396af8
					}
				}
				goto try_next // id: 0x7fffe2396c68
			}
			`r`, `R`, `p` {
				for reg = 0; reg < 8; reg++ {
					if !(regs_allocated[reg] & reg_mask) {
						goto reg_found // id: 0x7fffe2396af8
					}
				}
				goto try_next // id: 0x7fffe2396c68
				// RRRREG reg_found id=0x7fffe2396af8
				reg_found:
				op.is_llong = 0
				op.reg = reg
				regs_allocated[reg] |= reg_mask
			}
			`e`, `i` {
				if !((op.vt.r & (63 | 256)) == 48) {
					goto try_next // id: 0x7fffe2396c68
				}
			}
			`I`, `N`, `M` {
				if !((op.vt.r & (63 | 256 | 512)) == 48) {
					goto try_next // id: 0x7fffe2396c68
				}
			}
			`m`, `g` {
				if j < nb_outputs || c == `m` {
					if (op.vt.r & 63) == 49 {
						for reg = 0; reg < 8; reg++ {
							if !(regs_allocated[reg] & 2) {
								goto reg_found1 // id: 0x7fffe23994c0
							}
						}
						goto try_next // id: 0x7fffe2396c68
						// RRRREG reg_found1 id=0x7fffe23994c0
						reg_found1:
						regs_allocated[reg] |= 2
						op.reg = reg
						op.is_memory = 1
					}
				}
			}
			else {
				_tcc_error("asm constraint {${j}} ('${op.constraint}') could not be satisfied")
			}
		}
		if op.input_index >= 0 {
			op1 := unsafe { &operands + op.input_index }
			op1.reg = op.reg
			op1.is_llong = op.is_llong
		}
	}
	*pout_reg = -1
	for i = 0; i < nb_operands; i++ {
		op = unsafe { &operands + i }
		if op.reg >= 0 && (op.vt.r & 63) == 49 && !op.is_memory {
			for reg = 0; reg < 8; reg++ {
				if !(regs_allocated[reg] & 1) {
					goto reg_found2 // id: 0x7fffe239a8c0
				}
			}
			_tcc_error('could not find free output register for reloading')
			// RRRREG reg_found2 id=0x7fffe239a8c0
			reg_found2:
			*pout_reg = reg
			break
		}
	}
}

fn subst_asm_operand(add_str &CString, sv &SValue, modifier int) {
	r := 0
	reg := 0
	size := 0
	val := 0

	buf := [64]i8{}
	r = sv.r
	if (r & 63) == 48 {
		if !(r & 256) && modifier != `c` && modifier != `n` && modifier != `P` {
			cstr_ccat(add_str, `$`)
		}
		if r & 512 {
			name := get_tok_str(sv.sym.v, (unsafe { nil }))
			if sv.sym.v >= 268435456 {
				get_asm_sym(tok_alloc_const(name), sv.sym)
			}
			if tcc_state.leading_underscore {
				cstr_ccat(add_str, `_`)
			}
			cstr_cat(add_str, name, -1)
			if u32(sv.c.i) == 0 {
				goto no_offset // id: 0x7fffe239c2a0
			}
			cstr_ccat(add_str, `+`)
		}
		val = sv.c.i
		if modifier == `n` {
			val = -val
		}
		C.snprintf(buf, sizeof(buf), c'%d', int(sv.c.i))
		cstr_cat(add_str, buf, -1)
		// RRRREG no_offset id=0x7fffe239c2a0
		no_offset:
		0
		if r & 256 {
			cstr_cat(add_str, c'(%rip)', -1)
		}
	} else if (r & 63) == 50 {
		C.snprintf(buf, sizeof(buf), c'%d(%%rbp)', int(sv.c.i))
		cstr_cat(add_str, buf, -1)
	} else if r & 256 {
		reg = r & 63
		if reg >= 48 {
			_tcc_error('internal compiler error\n${@FILE}:${@LINE}: in ${@FN}()')
		}
		C.snprintf(buf, sizeof(buf), c'(%%%s)', get_tok_str(Tcc_token.tok_asm_rax + reg,
			(unsafe { nil })))
		cstr_cat(add_str, buf, -1)
	} else {
		reg = r & 63
		if reg >= 48 {
			_tcc_error('internal compiler error\n${@FILE}:${@LINE}: in ${@FN}(): ')
		}
		if (sv.type_.t & 15) == 1 || (sv.type_.t & 15) == 11 {
			size = 1
		} else if (sv.type_.t & 15) == 2 {
			size = 2
		} else if (sv.type_.t & 15) == 4 || (sv.type_.t & 15) == 5 {
			size = 8
		} else { // 3
			size = 4
		}
		if size == 1 && reg >= 4 {
			size = 4
		}
		if modifier == `b` {
			if reg >= 4 {
				_tcc_error('cannot use byte register')
			}
			size = 1
		} else if modifier == `h` {
			if reg >= 4 {
				_tcc_error('cannot use byte register')
			}
			size = -1
		} else if modifier == `w` {
			size = 2
		} else if modifier == `k` {
			size = 4
		} else if modifier == `q` {
			size = 8
		}
		match size {
			-1 { // case comp body kind=BinaryOperator is_enum=false
				reg = Tcc_token.tok_asm_ah + reg
			}
			1 { // case comp body kind=BinaryOperator is_enum=false
				reg = Tcc_token.tok_asm_al + reg
			}
			2 { // case comp body kind=BinaryOperator is_enum=false
				reg = Tcc_token.tok_asm_ax + reg
			}
			8 { // case comp body kind=BinaryOperator is_enum=false
				reg = Tcc_token.tok_asm_rax + reg
			}
			else {
				reg = Tcc_token.tok_asm_eax + reg
			}
		}
		C.snprintf(buf, sizeof(buf), c'%%%s', get_tok_str(reg, (unsafe { nil })))
		cstr_cat(add_str, buf, -1)
	}
}

fn asm_gen_code(operands &ASMOperand, nb_operands int, nb_outputs int, is_output int, clobber_regs &u8, out_reg int) {
	regs_allocated := [16]u8{}
	op := &ASMOperand(0)
	i := 0
	reg := 0

	reg_saved := [3, 12, 13, 14, 15]!

	C.memcpy(regs_allocated, clobber_regs, sizeof(regs_allocated))
	for i = 0; i < nb_operands; i++ {
		op = unsafe { &operands + i }
		if op.reg >= 0 {
			regs_allocated[op.reg] = 1
		}
	}
	if !is_output {
		for i = 0; i < sizeof(reg_saved) / sizeof(reg_saved[0]); i++ {
			reg = reg_saved[i]
			if regs_allocated[reg] {
				if reg >= 8 {
					g(65)
					reg -= 8
				}
				g(80 + reg)
			}
		}
		for i = 0; i < nb_operands; i++ {
			op = unsafe { &operands + i }
			if op.reg >= 0 {
				if (op.vt.r & 63) == 49 && op.is_memory {
					sv := SValue{}
					sv = *op.vt
					sv.r = (sv.r & ~63) | 50 | 256
					sv.type_.t = 5
					load(op.reg, &sv)
				} else if i >= nb_outputs || op.is_rw {
					load(op.reg, op.vt)
					if op.is_llong {
						sv := SValue{}
						sv = *op.vt
						sv.c.i += 4
						load(treg_rdx, &sv)
					}
				}
			}
		}
	} else {
		for i = 0; i < nb_outputs; i++ {
			op = unsafe { &operands + i }
			if op.reg >= 0 {
				if (op.vt.r & 63) == 49 {
					if !op.is_memory {
						sv := SValue{}
						sv = *op.vt
						sv.r = (sv.r & ~63) | 50
						sv.type_.t = 5
						load(out_reg, &sv)
						sv = *op.vt
						sv.r = (sv.r & ~63) | out_reg
						store(op.reg, &sv)
					}
				} else {
					store(op.reg, op.vt)
					if op.is_llong {
						sv := SValue{}
						sv = *op.vt
						sv.c.i += 4
						store(treg_rdx, &sv)
					}
				}
			}
		}
		for i = sizeof(reg_saved) / sizeof(reg_saved[0]) - 1; i >= 0; i-- {
			reg = reg_saved[i]
			if regs_allocated[reg] {
				if reg >= 8 {
					g(65)
					reg -= 8
				}
				g(88 + reg)
			}
		}
	}
}

fn asm_clobber(clobber_regs &u8, str &i8) {
	reg := 0
	type_ := u32(0)
	if !C.strcmp(str, c'memory') || !C.strcmp(str, c'cc') || !C.strcmp(str, c'flags') {
		return
	}
	reg = tok_alloc_const(str)
	if reg >= Tcc_token.tok_asm_eax && reg <= Tcc_token.tok_asm_edi {
		reg -= Tcc_token.tok_asm_eax
	} else if reg >= Tcc_token.tok_asm_ax && reg <= Tcc_token.tok_asm_di {
		reg -= Tcc_token.tok_asm_ax
	} else if reg >= Tcc_token.tok_asm_rax && reg <= Tcc_token.tok_asm_rdi {
		reg -= Tcc_token.tok_asm_rax
	} else if (asm_parse_numeric_reg(reg, &type_)) >= 0 {
		reg = asm_parse_numeric_reg(reg, &type_)
	} else {
		_tcc_error("invalid clobber register '${str}'")
	}
	clobber_regs[reg] = 1
}
