module main

pub struct ASMInstr {
	sym        u16
	opcode     u16
	instr_type u16
	nb_ops     u8
	op_type    [3]u8
}

pub struct Operand {
	type_ u32
	reg   Int8_t
	reg2  Int8_t
	shift u8
	e     ExprValue
}

@[export: 'asm_instrs']
pub const asm_instrs = [
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmpsb)
		opcode: (u16((if (((166) & 65280) == 3840) {
			((((166) >> 8) & ~255) | ((166) & 255))
		} else {
			(166)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((166) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_scmpb)
		opcode: (u16((if (((166) & 65280) == 3840) {
			((((166) >> 8) & ~255) | ((166) & 255))
		} else {
			(166)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((166) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_insb)
		opcode: (u16((if (((108) & 65280) == 3840) {
			((((108) >> 8) & ~255) | ((108) & 255))
		} else {
			(108)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((108) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outsb)
		opcode: (u16((if (((110) & 65280) == 3840) {
			((((110) >> 8) & ~255) | ((110) & 255))
		} else {
			(110)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((110) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lodsb)
		opcode: (u16((if (((172) & 65280) == 3840) {
			((((172) >> 8) & ~255) | ((172) & 255))
		} else {
			(172)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((172) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_slodb)
		opcode: (u16((if (((172) & 65280) == 3840) {
			((((172) >> 8) & ~255) | ((172) & 255))
		} else {
			(172)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((172) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsb)
		opcode: (u16((if (((164) & 65280) == 3840) {
			((((164) >> 8) & ~255) | ((164) & 255))
		} else {
			(164)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((164) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_smovb)
		opcode: (u16((if (((164) & 65280) == 3840) {
			((((164) >> 8) & ~255) | ((164) & 255))
		} else {
			(164)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((164) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_scasb)
		opcode: (u16((if (((174) & 65280) == 3840) {
			((((174) >> 8) & ~255) | ((174) & 255))
		} else {
			(174)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((174) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sscab)
		opcode: (u16((if (((174) & 65280) == 3840) {
			((((174) >> 8) & ~255) | ((174) & 255))
		} else {
			(174)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((174) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_stosb)
		opcode: (u16((if (((170) & 65280) == 3840) {
			((((170) >> 8) & ~255) | ((170) & 255))
		} else {
			(170)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((170) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sstob)
		opcode: (u16((if (((170) & 65280) == 3840) {
			((((170) >> 8) & ~255) | ((170) & 255))
		} else {
			(170)
		})))
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((170) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bsfw)
		opcode: (u16((if (((4028) & 65280) == 3840) {
			((((4028) >> 8) & ~255) | ((4028) & 255))
		} else {
			(4028)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4028) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bsrw)
		opcode: (u16((if (((4029) & 65280) == 3840) {
			((((4029) >> 8) & ~255) | ((4029) & 255))
		} else {
			(4029)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4029) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btw)
		opcode: (u16((if (((4003) & 65280) == 3840) {
			((((4003) >> 8) & ~255) | ((4003) & 255))
		} else {
			(4003)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4003) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16((8 | 4096) | ((4) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btsw)
		opcode: (u16((if (((4011) & 65280) == 3840) {
			((((4011) >> 8) & ~255) | ((4011) & 255))
		} else {
			(4011)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4011) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btsw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16((8 | 4096) | ((5) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btrw)
		opcode: (u16((if (((4019) & 65280) == 3840) {
			((((4019) >> 8) & ~255) | ((4019) & 255))
		} else {
			(4019)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4019) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btrw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16((8 | 4096) | ((6) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btcw)
		opcode: (u16((if (((4027) & 65280) == 3840) {
			((((4027) >> 8) & ~255) | ((4027) & 255))
		} else {
			(4027)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4027) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_btcw)
		opcode: (u16((if (((4026) & 65280) == 3840) {
			((((4026) >> 8) & ~255) | ((4026) & 255))
		} else {
			(4026)
		})))
		instr_type: u16((8 | 4096) | ((7) << 13) | (if (((4026) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sysretq)
		opcode: (u16((if (((4722439) & 65280) == 3840) {
			((((4722439) >> 8) & ~255) | ((4722439) & 255))
		} else {
			(4722439)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((4722439) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((136) & 65280) == 3840) {
			((((136) >> 8) & ~255) | ((136) & 255))
		} else {
			(136)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((136) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((138) & 65280) == 3840) {
			((((138) >> 8) & ~255) | ((138) & 255))
		} else {
			(138)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((138) & 65280) == 3840) {
			256
		} else {
			0
		}))
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
		instr_type: u16((4 | (1 | 4096)) | ((0) << 13) | (if (((176) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im, opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mov)
		opcode: (u16((if (((184) & 65280) == 3840) {
			((((184) >> 8) & ~255) | ((184) & 255))
		} else {
			(184)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((184) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im64, opt_reg64]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((184) & 65280) == 3840) {
			((((184) >> 8) & ~255) | ((184) & 255))
		} else {
			(184)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((184) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im64, opt_reg64]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movb)
		opcode: (u16((if (((198) & 65280) == 3840) {
			((((198) >> 8) & ~255) | ((198) & 255))
		} else {
			(198)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((198) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im, opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((140) & 65280) == 3840) {
			((((140) >> 8) & ~255) | ((140) & 255))
		} else {
			(140)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((140) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_seg, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((142) & 65280) == 3840) {
			((((142) >> 8) & ~255) | ((142) & 255))
		} else {
			(142)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((142) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_reg, opt_seg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3872) & 65280) == 3840) {
			((((3872) >> 8) & ~255) | ((3872) & 255))
		} else {
			(3872)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((3872) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_cr, opt_reg64]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3873) & 65280) == 3840) {
			((((3873) >> 8) & ~255) | ((3873) & 255))
		} else {
			(3873)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((3873) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_db, opt_reg64]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3874) & 65280) == 3840) {
			((((3874) >> 8) & ~255) | ((3874) & 255))
		} else {
			(3874)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((3874) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg64, opt_cr]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movw)
		opcode: (u16((if (((3875) & 65280) == 3840) {
			((((3875) >> 8) & ~255) | ((3875) & 255))
		} else {
			(3875)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((3875) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg64, opt_db]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsbw)
		opcode: (u16((if (((6688702) & 65280) == 3840) {
			((((6688702) >> 8) & ~255) | ((6688702) & 255))
		} else {
			(6688702)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((6688702) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg8 | opt_ea, opt_reg16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsbl)
		opcode: (u16((if (((4030) & 65280) == 3840) {
			((((4030) >> 8) & ~255) | ((4030) & 255))
		} else {
			(4030)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4030) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg8 | opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movsbq)
		opcode: (u16((if (((4030) & 65280) == 3840) {
			((((4030) >> 8) & ~255) | ((4030) & 255))
		} else {
			(4030)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4030) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg8 | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movswl)
		opcode: (u16((if (((4031) & 65280) == 3840) {
			((((4031) >> 8) & ~255) | ((4031) & 255))
		} else {
			(4031)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4031) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg16 | opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movswq)
		opcode: (u16((if (((4031) & 65280) == 3840) {
			((((4031) >> 8) & ~255) | ((4031) & 255))
		} else {
			(4031)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4031) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg16 | opt_ea, opt_reg, 0, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movslq)
		opcode: (u16((if (((99) & 65280) == 3840) {
			((((99) >> 8) & ~255) | ((99) & 255))
		} else {
			(99)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((99) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg32 | opt_ea, opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movzbw)
		opcode: (u16((if (((4022) & 65280) == 3840) {
			((((4022) >> 8) & ~255) | ((4022) & 255))
		} else {
			(4022)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4022) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg8 | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movzwl)
		opcode: (u16((if (((4023) & 65280) == 3840) {
			((((4023) >> 8) & ~255) | ((4023) & 255))
		} else {
			(4023)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4023) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg16 | opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movzwq)
		opcode: (u16((if (((4023) & 65280) == 3840) {
			((((4023) >> 8) & ~255) | ((4023) & 255))
		} else {
			(4023)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4023) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg16 | opt_ea, opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushq)
		opcode: (u16((if (((106) & 65280) == 3840) {
			((((106) >> 8) & ~255) | ((106) & 255))
		} else {
			(106)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((106) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im8s]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_push)
		opcode: (u16((if (((106) & 65280) == 3840) {
			((((106) >> 8) & ~255) | ((106) & 255))
		} else {
			(106)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((106) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im8s]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((26218) & 65280) == 3840) {
			((((26218) >> 8) & ~255) | ((26218) & 255))
		} else {
			(26218)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((26218) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im8s]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((80) & 65280) == 3840) {
			((((80) >> 8) & ~255) | ((80) & 255))
		} else {
			(80)
		})))
		instr_type: u16((4 | 4096) | ((0) << 13) | (if (((80) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4 | 4096) | ((0) << 13) | (if (((80) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16((8 | 4096) | ((6) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((0) | ((0) << 13) | (if (((26216) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((104) & 65280) == 3840) {
			((((104) >> 8) & ~255) | ((104) & 255))
		} else {
			(104)
		})))
		instr_type: u16((4096) | ((0) << 13) | (if (((104) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pushw)
		opcode: (u16((if (((6) & 65280) == 3840) { ((((6) >> 8) & ~255) | ((6) & 255)) } else { (6) })))
		instr_type: u16((4096) | ((0) << 13) | (if (((6) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_seg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((88) & 65280) == 3840) {
			((((88) >> 8) & ~255) | ((88) & 255))
		} else {
			(88)
		})))
		instr_type: u16((4 | 4096) | ((0) << 13) | (if (((88) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4 | 4096) | ((0) << 13) | (if (((88) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((143) & 65280) == 3840) {
			((((143) >> 8) & ~255) | ((143) & 255))
		} else {
			(143)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((143) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_regw | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_popw)
		opcode: (u16((if (((7) & 65280) == 3840) { ((((7) >> 8) & ~255) | ((7) & 255)) } else { (7) })))
		instr_type: u16((4096) | ((0) << 13) | (if (((7) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_seg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgw)
		opcode: (u16((if (((144) & 65280) == 3840) {
			((((144) >> 8) & ~255) | ((144) & 255))
		} else {
			(144)
		})))
		instr_type: u16((4 | 4096) | ((0) << 13) | (if (((144) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgw)
		opcode: (u16((if (((144) & 65280) == 3840) {
			((((144) >> 8) & ~255) | ((144) & 255))
		} else {
			(144)
		})))
		instr_type: u16((4 | 4096) | ((0) << 13) | (if (((144) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_eax, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgb)
		opcode: (u16((if (((134) & 65280) == 3840) {
			((((134) >> 8) & ~255) | ((134) & 255))
		} else {
			(134)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((134) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_xchgb)
		opcode: (u16((if (((134) & 65280) == 3840) {
			((((134) >> 8) & ~255) | ((134) & 255))
		} else {
			(134)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((134) & 65280) == 3840) {
			256
		} else {
			0
		}))
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
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((228) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((228) & 65280) == 3840) {
			((((228) >> 8) & ~255) | ((228) & 255))
		} else {
			(228)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((228) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((236) & 65280) == 3840) {
			((((236) >> 8) & ~255) | ((236) & 255))
		} else {
			(236)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((236) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_dx, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_inb)
		opcode: (u16((if (((236) & 65280) == 3840) {
			((((236) >> 8) & ~255) | ((236) & 255))
		} else {
			(236)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((236) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_dx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((230) & 65280) == 3840) {
			((((230) >> 8) & ~255) | ((230) & 255))
		} else {
			(230)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((230) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_eax, opt_im8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((230) & 65280) == 3840) {
			((((230) >> 8) & ~255) | ((230) & 255))
		} else {
			(230)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((230) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((238) & 65280) == 3840) {
			((((238) >> 8) & ~255) | ((238) & 255))
		} else {
			(238)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((238) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_eax, opt_dx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_outb)
		opcode: (u16((if (((238) & 65280) == 3840) {
			((((238) >> 8) & ~255) | ((238) & 255))
		} else {
			(238)
		})))
		instr_type: u16((1 | 2) | ((0) << 13) | (if (((238) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_dx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_leaw)
		opcode: (u16((if (((141) & 65280) == 3840) {
			((((141) >> 8) & ~255) | ((141) & 255))
		} else {
			(141)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((141) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea, opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_les)
		opcode: (u16((if (((196) & 65280) == 3840) {
			((((196) >> 8) & ~255) | ((196) & 255))
		} else {
			(196)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((196) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lds)
		opcode: (u16((if (((197) & 65280) == 3840) {
			((((197) >> 8) & ~255) | ((197) & 255))
		} else {
			(197)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((197) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lss)
		opcode: (u16((if (((4018) & 65280) == 3840) {
			((((4018) >> 8) & ~255) | ((4018) & 255))
		} else {
			(4018)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4018) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lfs)
		opcode: (u16((if (((4020) & 65280) == 3840) {
			((((4020) >> 8) & ~255) | ((4020) & 255))
		} else {
			(4020)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4020) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lgs)
		opcode: (u16((if (((4021) & 65280) == 3840) {
			((((4021) >> 8) & ~255) | ((4021) & 255))
		} else {
			(4021)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4021) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea, opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((0) & 65280) == 3840) { ((((0) >> 8) & ~255) | ((0) & 255)) } else { (0) })))
		instr_type: u16((48 | 8 | (1 | 4096)) | ((0) << 13) | (if (((0) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [u8(opt_reg), opt_ea | opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((2) & 65280) == 3840) { ((((2) >> 8) & ~255) | ((2) & 255)) } else { (2) })))
		instr_type: u16((48 | 8 | (1 | 4096)) | ((0) << 13) | (if (((2) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [u8(opt_ea | opt_reg), opt_reg, 0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((4) & 65280) == 3840) { ((((4) >> 8) & ~255) | ((4) & 255)) } else { (4) })))
		instr_type: u16((48 | (1 | 4096)) | ((0) << 13) | (if (((4) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addw)
		opcode: (u16((if (((131) & 65280) == 3840) {
			((((131) >> 8) & ~255) | ((131) & 255))
		} else {
			(131)
		})))
		instr_type: u16((48 | 8 | 4096) | ((0) << 13) | (if (((131) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im8s, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addb)
		opcode: (u16((if (((128) & 65280) == 3840) {
			((((128) >> 8) & ~255) | ((128) & 255))
		} else {
			(128)
		})))
		instr_type: u16((48 | 8 | (1 | 4096)) | ((0) << 13) | (if (((128) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((132) & 65280) == 3840) {
			((((132) >> 8) & ~255) | ((132) & 255))
		} else {
			(132)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((132) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((132) & 65280) == 3840) {
			((((132) >> 8) & ~255) | ((132) & 255))
		} else {
			(132)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((132) & 65280) == 3840) {
			256
		} else {
			0
		}))
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
		instr_type: u16((1 | 4096) | ((0) << 13) | (if (((168) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_testb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_incb)
		opcode: (u16((if (((254) & 65280) == 3840) {
			((((254) >> 8) & ~255) | ((254) & 255))
		} else {
			(254)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((254) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_decb)
		opcode: (u16((if (((254) & 65280) == 3840) {
			((((254) >> 8) & ~255) | ((254) & 255))
		} else {
			(254)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((1) << 13) | (if (((254) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_notb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((2) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_negb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((3) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mulb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((4) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((5) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((4015) & 65280) == 3840) {
			((((4015) >> 8) & ~255) | ((4015) & 255))
		} else {
			(4015)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4015) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg | opt_ea, opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((107) & 65280) == 3840) {
			((((107) >> 8) & ~255) | ((107) & 255))
		} else {
			(107)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((107) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 3
		op_type: [opt_im8s, opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((107) & 65280) == 3840) {
			((((107) >> 8) & ~255) | ((107) & 255))
		} else {
			(107)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((107) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8s, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((105) & 65280) == 3840) {
			((((105) >> 8) & ~255) | ((105) & 255))
		} else {
			(105)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((105) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 3
		op_type: [opt_imw, opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_imulw)
		opcode: (u16((if (((105) & 65280) == 3840) {
			((((105) >> 8) & ~255) | ((105) & 255))
		} else {
			(105)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((105) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_imw, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_divb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((6) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_divb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((6) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg | opt_ea, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_idivb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((7) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_idivb)
		opcode: (u16((if (((246) & 65280) == 3840) {
			((((246) >> 8) & ~255) | ((246) & 255))
		} else {
			(246)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((7) << 13) | (if (((246) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg | opt_ea, opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rolb)
		opcode: (u16((if (((192) & 65280) == 3840) {
			((((192) >> 8) & ~255) | ((192) & 255))
		} else {
			(192)
		})))
		instr_type: u16((8 | (1 | 4096) | 32) | ((0) << 13) | (if (((192) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_im8, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rolb)
		opcode: (u16((if (((210) & 65280) == 3840) {
			((((210) >> 8) & ~255) | ((210) & 255))
		} else {
			(210)
		})))
		instr_type: u16((8 | (1 | 4096) | 32) | ((0) << 13) | (if (((210) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_cl, opt_ea | opt_reg]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rolb)
		opcode: (u16((if (((208) & 65280) == 3840) {
			((((208) >> 8) & ~255) | ((208) & 255))
		} else {
			(208)
		})))
		instr_type: u16((8 | (1 | 4096) | 32) | ((0) << 13) | (if (((208) & 65280) == 3840) {
			256
		} else {
			0
		}))
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
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4004) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 3
		op_type: [opt_im8, opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shldw)
		opcode: (u16((if (((4005) & 65280) == 3840) {
			((((4005) >> 8) & ~255) | ((4005) & 255))
		} else {
			(4005)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4005) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 3
		op_type: [opt_cl, opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shldw)
		opcode: (u16((if (((4005) & 65280) == 3840) {
			((((4005) >> 8) & ~255) | ((4005) & 255))
		} else {
			(4005)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4005) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shrdw)
		opcode: (u16((if (((4012) & 65280) == 3840) {
			((((4012) >> 8) & ~255) | ((4012) & 255))
		} else {
			(4012)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4012) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 3
		op_type: [opt_im8, opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shrdw)
		opcode: (u16((if (((4013) & 65280) == 3840) {
			((((4013) >> 8) & ~255) | ((4013) & 255))
		} else {
			(4013)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4013) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 3
		op_type: [opt_cl, opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_shrdw)
		opcode: (u16((if (((4013) & 65280) == 3840) {
			((((4013) >> 8) & ~255) | ((4013) & 255))
		} else {
			(4013)
		})))
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((4013) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_regw, opt_ea | opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_call)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16((8) | ((2) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_indir]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_call)
		opcode: (u16((if (((232) & 65280) == 3840) {
			((((232) >> 8) & ~255) | ((232) & 255))
		} else {
			(232)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((232) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jmp)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16((8) | ((4) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_indir]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jmp)
		opcode: (u16((if (((235) & 65280) == 3840) {
			((((235) >> 8) & ~255) | ((235) & 255))
		} else {
			(235)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((235) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lcall)
		opcode: (u16((if (((255) & 65280) == 3840) {
			((((255) >> 8) & ~255) | ((255) & 255))
		} else {
			(255)
		})))
		instr_type: u16((8) | ((3) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((26367) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((255) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((0) | ((0) << 13) | (if (((205) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_seto)
		opcode: (u16((if (((3984) & 65280) == 3840) {
			((((3984) >> 8) & ~255) | ((3984) & 255))
		} else {
			(3984)
		})))
		instr_type: u16((8 | 80) | ((0) << 13) | (if (((3984) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg8 | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_setob)
		opcode: (u16((if (((3984) & 65280) == 3840) {
			((((3984) >> 8) & ~255) | ((3984) & 255))
		} else {
			(3984)
		})))
		instr_type: u16((8 | 80) | ((0) << 13) | (if (((3984) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg8 | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_enter)
		opcode: (u16((if (((200) & 65280) == 3840) {
			((((200) >> 8) & ~255) | ((200) & 255))
		} else {
			(200)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((200) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im16, opt_im8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_retq)
		opcode: (u16((if (((194) & 65280) == 3840) {
			((((194) >> 8) & ~255) | ((194) & 255))
		} else {
			(194)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((194) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ret)
		opcode: (u16((if (((194) & 65280) == 3840) {
			((((194) >> 8) & ~255) | ((194) & 255))
		} else {
			(194)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((194) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_lret)
		opcode: (u16((if (((202) & 65280) == 3840) {
			((((202) >> 8) & ~255) | ((202) & 255))
		} else {
			(202)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((202) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_im16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jo)
		opcode: (u16((if (((112) & 65280) == 3840) {
			((((112) >> 8) & ~255) | ((112) & 255))
		} else {
			(112)
		})))
		instr_type: u16((80) | ((0) << 13) | (if (((112) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loopne)
		opcode: (u16((if (((224) & 65280) == 3840) {
			((((224) >> 8) & ~255) | ((224) & 255))
		} else {
			(224)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((224) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loopnz)
		opcode: (u16((if (((224) & 65280) == 3840) {
			((((224) >> 8) & ~255) | ((224) & 255))
		} else {
			(224)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((224) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loope)
		opcode: (u16((if (((225) & 65280) == 3840) {
			((((225) >> 8) & ~255) | ((225) & 255))
		} else {
			(225)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((225) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loopz)
		opcode: (u16((if (((225) & 65280) == 3840) {
			((((225) >> 8) & ~255) | ((225) & 255))
		} else {
			(225)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((225) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_loop)
		opcode: (u16((if (((226) & 65280) == 3840) {
			((((226) >> 8) & ~255) | ((226) & 255))
		} else {
			(226)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((226) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_jecxz)
		opcode: (u16((if (((26595) & 65280) == 3840) {
			((((26595) >> 8) & ~255) | ((26595) & 255))
		} else {
			(26595)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((26595) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_disp8]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcomp)
		opcode: (u16((if (((55513) & 65280) == 3840) {
			((((55513) >> 8) & ~255) | ((55513) & 255))
		} else {
			(55513)
		})))
		instr_type: u16((0) | ((0) << 13) | (if (((55513) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((55488) & 65280) == 3840) {
			((((55488) >> 8) & ~255) | ((55488) & 255))
		} else {
			(55488)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((55488) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((55488) & 65280) == 3840) {
			((((55488) >> 8) & ~255) | ((55488) & 255))
		} else {
			(55488)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((55488) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((56512) & 65280) == 3840) {
			((((56512) >> 8) & ~255) | ((56512) & 255))
		} else {
			(56512)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((56512) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st0, opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fmul)
		opcode: (u16((if (((56520) & 65280) == 3840) {
			((((56520) >> 8) & ~255) | ((56520) & 255))
		} else {
			(56520)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((56520) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st0, opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadd)
		opcode: (u16((if (((57025) & 65280) == 3840) {
			((((57025) >> 8) & ~255) | ((57025) & 255))
		} else {
			(57025)
		})))
		instr_type: u16((64) | ((0) << 13) | (if (((57025) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57024) & 65280) == 3840) {
			((((57024) >> 8) & ~255) | ((57024) & 255))
		} else {
			(57024)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((57024) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57024) & 65280) == 3840) {
			((((57024) >> 8) & ~255) | ((57024) & 255))
		} else {
			(57024)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((57024) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57024) & 65280) == 3840) {
			((((57024) >> 8) & ~255) | ((57024) & 255))
		} else {
			(57024)
		})))
		instr_type: u16((64 | 4) | ((0) << 13) | (if (((57024) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st0, opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_faddp)
		opcode: (u16((if (((57025) & 65280) == 3840) {
			((((57025) >> 8) & ~255) | ((57025) & 255))
		} else {
			(57025)
		})))
		instr_type: u16((64) | ((0) << 13) | (if (((57025) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fadds)
		opcode: (u16((if (((216) & 65280) == 3840) {
			((((216) >> 8) & ~255) | ((216) & 255))
		} else {
			(216)
		})))
		instr_type: u16((64 | 8) | ((0) << 13) | (if (((216) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((64 | 8) | ((0) << 13) | (if (((218) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((64 | 8) | ((0) << 13) | (if (((220) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((64 | 8) | ((0) << 13) | (if (((222) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4) | ((0) << 13) | (if (((55744) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldl)
		opcode: (u16((if (((55744) & 65280) == 3840) {
			((((55744) >> 8) & ~255) | ((55744) & 255))
		} else {
			(55744)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((55744) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_flds)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((0) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((0) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((4) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4) | ((0) << 13) | (if (((56784) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstl)
		opcode: (u16((if (((56784) & 65280) == 3840) {
			((((56784) >> 8) & ~255) | ((56784) & 255))
		} else {
			(56784)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56784) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fsts)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16((8) | ((2) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4) | ((0) << 13) | (if (((56792) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fistpq)
		opcode: (u16((if (((223) & 65280) == 3840) {
			((((223) >> 8) & ~255) | ((223) & 255))
		} else {
			(223)
		})))
		instr_type: u16((8) | ((7) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((7) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((7) << 13) | (if (((219) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((6) << 13) | (if (((223) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4) | ((0) << 13) | (if (((55752) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucom)
		opcode: (u16((if (((56800) & 65280) == 3840) {
			((((56800) >> 8) & ~255) | ((56800) & 255))
		} else {
			(56800)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56800) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucomp)
		opcode: (u16((if (((56808) & 65280) == 3840) {
			((((56808) >> 8) & ~255) | ((56808) & 255))
		} else {
			(56808)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56808) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_finit)
		opcode: (u16((if (((56291) & 65280) == 3840) {
			((((56291) >> 8) & ~255) | ((56291) & 255))
		} else {
			(56291)
		})))
		instr_type: u16((16) | ((0) << 13) | (if (((56291) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fldcw)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16((8) | ((5) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((7) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 16) | ((7) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((0) | ((0) << 13) | (if (((57312) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnstsw)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16((8) | ((7) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((16) | ((0) << 13) | (if (((57312) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_eax]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstsw)
		opcode: (u16((if (((57312) & 65280) == 3840) {
			((((57312) >> 8) & ~255) | ((57312) & 255))
		} else {
			(57312)
		})))
		instr_type: u16((16) | ((0) << 13) | (if (((57312) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fstsw)
		opcode: (u16((if (((221) & 65280) == 3840) {
			((((221) >> 8) & ~255) | ((221) & 255))
		} else {
			(221)
		})))
		instr_type: u16((8 | 16) | ((7) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((16) | ((0) << 13) | (if (((56290) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fnstenv)
		opcode: (u16((if (((217) & 65280) == 3840) {
			((((217) >> 8) & ~255) | ((217) & 255))
		} else {
			(217)
		})))
		instr_type: u16((8) | ((6) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 16) | ((6) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((4) << 13) | (if (((217) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((6) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 16) | ((6) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((4) << 13) | (if (((221) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4) | ((4) << 13) | (if (((56768) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_ffreep)
		opcode: (u16((if (((57280) & 65280) == 3840) {
			((((57280) >> 8) & ~255) | ((57280) & 255))
		} else {
			(57280)
		})))
		instr_type: u16((4) | ((4) << 13) | (if (((57280) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_st]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fxsave)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((1) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 512) | ((0) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 512) | ((1) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((0) << 13) | (if (((99) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((3842) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((6) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 4096) | ((0) << 13) | (if (((3843) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_ea | opt_reg16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sgdt)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((0) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((1) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((1) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((0) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_smsw)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16((8) | ((4) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_str)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16((8) | ((1) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg32 | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_str)
		opcode: (u16((if (((6688512) & 65280) == 3840) {
			((((6688512) >> 8) & ~255) | ((6688512) & 255))
		} else {
			(6688512)
		})))
		instr_type: u16((8) | ((1) << 13) | (if (((6688512) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg16]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_str)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16((8 | 512) | ((1) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((4) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_verw)
		opcode: (u16((if (((3840) & 65280) == 3840) {
			((((3840) >> 8) & ~255) | ((3840) & 255))
		} else {
			(3840)
		})))
		instr_type: u16((8) | ((5) << 13) | (if (((3840) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_swapgs)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16((8) | ((7) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((4) | ((0) << 13) | (if (((4040) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bswapl)
		opcode: (u16((if (((4040) & 65280) == 3840) {
			((((4040) >> 8) & ~255) | ((4040) & 255))
		} else {
			(4040)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((4040) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_bswapq)
		opcode: (u16((if (((4040) & 65280) == 3840) {
			((((4040) >> 8) & ~255) | ((4040) & 255))
		} else {
			(4040)
		})))
		instr_type: u16((4 | 512) | ((0) << 13) | (if (((4040) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((4032) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg, opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cmpxchgb)
		opcode: (u16((if (((4016) & 65280) == 3840) {
			((((4016) >> 8) & ~255) | ((4016) & 255))
		} else {
			(4016)
		})))
		instr_type: u16((8 | (1 | 4096)) | ((0) << 13) | (if (((4016) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_reg, opt_reg | opt_ea]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_invlpg)
		opcode: (u16((if (((3841) & 65280) == 3840) {
			((((3841) >> 8) & ~255) | ((3841) & 255))
		} else {
			(3841)
		})))
		instr_type: u16((8) | ((7) << 13) | (if (((3841) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((1) << 13) | (if (((4039) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 512) | ((1) << 13) | (if (((4039) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8 | 80 | 4096) | ((0) << 13) | (if (((3904) & 65280) == 3840) {
			256
		} else {
			0
		}))
		nb_ops: 2
		op_type: [opt_regw | opt_ea, opt_regw]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovb)
		opcode: (u16((if (((56000) & 65280) == 3840) {
			((((56000) >> 8) & ~255) | ((56000) & 255))
		} else {
			(56000)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56000) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmove)
		opcode: (u16((if (((56008) & 65280) == 3840) {
			((((56008) >> 8) & ~255) | ((56008) & 255))
		} else {
			(56008)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56008) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovbe)
		opcode: (u16((if (((56016) & 65280) == 3840) {
			((((56016) >> 8) & ~255) | ((56016) & 255))
		} else {
			(56016)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56016) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovu)
		opcode: (u16((if (((56024) & 65280) == 3840) {
			((((56024) >> 8) & ~255) | ((56024) & 255))
		} else {
			(56024)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56024) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovnb)
		opcode: (u16((if (((56256) & 65280) == 3840) {
			((((56256) >> 8) & ~255) | ((56256) & 255))
		} else {
			(56256)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56256) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovne)
		opcode: (u16((if (((56264) & 65280) == 3840) {
			((((56264) >> 8) & ~255) | ((56264) & 255))
		} else {
			(56264)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56264) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovnbe)
		opcode: (u16((if (((56272) & 65280) == 3840) {
			((((56272) >> 8) & ~255) | ((56272) & 255))
		} else {
			(56272)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56272) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcmovnu)
		opcode: (u16((if (((56280) & 65280) == 3840) {
			((((56280) >> 8) & ~255) | ((56280) & 255))
		} else {
			(56280)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56280) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucomi)
		opcode: (u16((if (((56296) & 65280) == 3840) {
			((((56296) >> 8) & ~255) | ((56296) & 255))
		} else {
			(56296)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56296) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcomi)
		opcode: (u16((if (((56304) & 65280) == 3840) {
			((((56304) >> 8) & ~255) | ((56304) & 255))
		} else {
			(56304)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((56304) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fucomip)
		opcode: (u16((if (((57320) & 65280) == 3840) {
			((((57320) >> 8) & ~255) | ((57320) & 255))
		} else {
			(57320)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((57320) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_fcomip)
		opcode: (u16((if (((57328) & 65280) == 3840) {
			((((57328) >> 8) & ~255) | ((57328) & 255))
		} else {
			(57328)
		})))
		instr_type: u16((4) | ((0) << 13) | (if (((57328) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_st, opt_st0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3950) & 65280) == 3840) {
			((((3950) >> 8) & ~255) | ((3950) & 255))
		} else {
			(3950)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3950) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_reg32, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3950) & 65280) == 3840) {
			((((3950) >> 8) & ~255) | ((3950) & 255))
		} else {
			(3950)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3950) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_reg64, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3950) & 65280) == 3840) {
			((((3950) >> 8) & ~255) | ((3950) & 255))
		} else {
			(3950)
		})))
		instr_type: u16((8 | 512) | ((0) << 13) | (if (((3950) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_reg64, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3951) & 65280) == 3840) {
			((((3951) >> 8) & ~255) | ((3951) & 255))
		} else {
			(3951)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3951) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmx, opt_mmx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3966) & 65280) == 3840) {
			((((3966) >> 8) & ~255) | ((3966) & 255))
		} else {
			(3966)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3966) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_mmxsse, opt_ea | opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movd)
		opcode: (u16((if (((3966) & 65280) == 3840) {
			((((3966) >> 8) & ~255) | ((3966) & 255))
		} else {
			(3966)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3966) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_mmxsse, opt_ea | opt_reg64]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3967) & 65280) == 3840) {
			((((3967) >> 8) & ~255) | ((3967) & 255))
		} else {
			(3967)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3967) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_mmx, opt_ea | opt_mmx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((6688726) & 65280) == 3840) {
			((((6688726) >> 8) & ~255) | ((6688726) & 255))
		} else {
			(6688726)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((6688726) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_sse, opt_ea | opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((15929214) & 65280) == 3840) {
			((((15929214) >> 8) & ~255) | ((15929214) & 255))
		} else {
			(15929214)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((15929214) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movq)
		opcode: (u16((if (((3966) & 65280) == 3840) {
			((((3966) >> 8) & ~255) | ((3966) & 255))
		} else {
			(3966)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3966) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_mmxsse, opt_ea | opt_reg64]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_packssdw)
		opcode: (u16((if (((3947) & 65280) == 3840) {
			((((3947) >> 8) & ~255) | ((3947) & 255))
		} else {
			(3947)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3947) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_packsswb)
		opcode: (u16((if (((3939) & 65280) == 3840) {
			((((3939) >> 8) & ~255) | ((3939) & 255))
		} else {
			(3939)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3939) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_packuswb)
		opcode: (u16((if (((3943) & 65280) == 3840) {
			((((3943) >> 8) & ~255) | ((3943) & 255))
		} else {
			(3943)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3943) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddb)
		opcode: (u16((if (((4092) & 65280) == 3840) {
			((((4092) >> 8) & ~255) | ((4092) & 255))
		} else {
			(4092)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4092) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddw)
		opcode: (u16((if (((4093) & 65280) == 3840) {
			((((4093) >> 8) & ~255) | ((4093) & 255))
		} else {
			(4093)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4093) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddd)
		opcode: (u16((if (((4094) & 65280) == 3840) {
			((((4094) >> 8) & ~255) | ((4094) & 255))
		} else {
			(4094)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4094) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddsb)
		opcode: (u16((if (((4076) & 65280) == 3840) {
			((((4076) >> 8) & ~255) | ((4076) & 255))
		} else {
			(4076)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4076) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddsw)
		opcode: (u16((if (((4077) & 65280) == 3840) {
			((((4077) >> 8) & ~255) | ((4077) & 255))
		} else {
			(4077)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4077) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddusb)
		opcode: (u16((if (((4060) & 65280) == 3840) {
			((((4060) >> 8) & ~255) | ((4060) & 255))
		} else {
			(4060)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4060) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_paddusw)
		opcode: (u16((if (((4061) & 65280) == 3840) {
			((((4061) >> 8) & ~255) | ((4061) & 255))
		} else {
			(4061)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4061) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pand)
		opcode: (u16((if (((4059) & 65280) == 3840) {
			((((4059) >> 8) & ~255) | ((4059) & 255))
		} else {
			(4059)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4059) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pandn)
		opcode: (u16((if (((4063) & 65280) == 3840) {
			((((4063) >> 8) & ~255) | ((4063) & 255))
		} else {
			(4063)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4063) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpeqb)
		opcode: (u16((if (((3956) & 65280) == 3840) {
			((((3956) >> 8) & ~255) | ((3956) & 255))
		} else {
			(3956)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3956) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpeqw)
		opcode: (u16((if (((3957) & 65280) == 3840) {
			((((3957) >> 8) & ~255) | ((3957) & 255))
		} else {
			(3957)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3957) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpeqd)
		opcode: (u16((if (((3958) & 65280) == 3840) {
			((((3958) >> 8) & ~255) | ((3958) & 255))
		} else {
			(3958)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3958) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpgtb)
		opcode: (u16((if (((3940) & 65280) == 3840) {
			((((3940) >> 8) & ~255) | ((3940) & 255))
		} else {
			(3940)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3940) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpgtw)
		opcode: (u16((if (((3941) & 65280) == 3840) {
			((((3941) >> 8) & ~255) | ((3941) & 255))
		} else {
			(3941)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3941) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pcmpgtd)
		opcode: (u16((if (((3942) & 65280) == 3840) {
			((((3942) >> 8) & ~255) | ((3942) & 255))
		} else {
			(3942)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3942) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmaddwd)
		opcode: (u16((if (((4085) & 65280) == 3840) {
			((((4085) >> 8) & ~255) | ((4085) & 255))
		} else {
			(4085)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4085) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmulhw)
		opcode: (u16((if (((4069) & 65280) == 3840) {
			((((4069) >> 8) & ~255) | ((4069) & 255))
		} else {
			(4069)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4069) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmullw)
		opcode: (u16((if (((4053) & 65280) == 3840) {
			((((4053) >> 8) & ~255) | ((4053) & 255))
		} else {
			(4053)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4053) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_por)
		opcode: (u16((if (((4075) & 65280) == 3840) {
			((((4075) >> 8) & ~255) | ((4075) & 255))
		} else {
			(4075)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4075) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllw)
		opcode: (u16((if (((4081) & 65280) == 3840) {
			((((4081) >> 8) & ~255) | ((4081) & 255))
		} else {
			(4081)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4081) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllw)
		opcode: (u16((if (((3953) & 65280) == 3840) {
			((((3953) >> 8) & ~255) | ((3953) & 255))
		} else {
			(3953)
		})))
		instr_type: u16((8) | ((6) << 13) | (if (((3953) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pslld)
		opcode: (u16((if (((4082) & 65280) == 3840) {
			((((4082) >> 8) & ~255) | ((4082) & 255))
		} else {
			(4082)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4082) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pslld)
		opcode: (u16((if (((3954) & 65280) == 3840) {
			((((3954) >> 8) & ~255) | ((3954) & 255))
		} else {
			(3954)
		})))
		instr_type: u16((8) | ((6) << 13) | (if (((3954) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllq)
		opcode: (u16((if (((4083) & 65280) == 3840) {
			((((4083) >> 8) & ~255) | ((4083) & 255))
		} else {
			(4083)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4083) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psllq)
		opcode: (u16((if (((3955) & 65280) == 3840) {
			((((3955) >> 8) & ~255) | ((3955) & 255))
		} else {
			(3955)
		})))
		instr_type: u16((8) | ((6) << 13) | (if (((3955) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psraw)
		opcode: (u16((if (((4065) & 65280) == 3840) {
			((((4065) >> 8) & ~255) | ((4065) & 255))
		} else {
			(4065)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4065) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psraw)
		opcode: (u16((if (((3953) & 65280) == 3840) {
			((((3953) >> 8) & ~255) | ((3953) & 255))
		} else {
			(3953)
		})))
		instr_type: u16((8) | ((4) << 13) | (if (((3953) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrad)
		opcode: (u16((if (((4066) & 65280) == 3840) {
			((((4066) >> 8) & ~255) | ((4066) & 255))
		} else {
			(4066)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4066) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrad)
		opcode: (u16((if (((3954) & 65280) == 3840) {
			((((3954) >> 8) & ~255) | ((3954) & 255))
		} else {
			(3954)
		})))
		instr_type: u16((8) | ((4) << 13) | (if (((3954) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlw)
		opcode: (u16((if (((4049) & 65280) == 3840) {
			((((4049) >> 8) & ~255) | ((4049) & 255))
		} else {
			(4049)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4049) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlw)
		opcode: (u16((if (((3953) & 65280) == 3840) {
			((((3953) >> 8) & ~255) | ((3953) & 255))
		} else {
			(3953)
		})))
		instr_type: u16((8) | ((2) << 13) | (if (((3953) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrld)
		opcode: (u16((if (((4050) & 65280) == 3840) {
			((((4050) >> 8) & ~255) | ((4050) & 255))
		} else {
			(4050)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4050) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrld)
		opcode: (u16((if (((3954) & 65280) == 3840) {
			((((3954) >> 8) & ~255) | ((3954) & 255))
		} else {
			(3954)
		})))
		instr_type: u16((8) | ((2) << 13) | (if (((3954) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlq)
		opcode: (u16((if (((4051) & 65280) == 3840) {
			((((4051) >> 8) & ~255) | ((4051) & 255))
		} else {
			(4051)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4051) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psrlq)
		opcode: (u16((if (((3955) & 65280) == 3840) {
			((((3955) >> 8) & ~255) | ((3955) & 255))
		} else {
			(3955)
		})))
		instr_type: u16((8) | ((2) << 13) | (if (((3955) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_im8, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubb)
		opcode: (u16((if (((4088) & 65280) == 3840) {
			((((4088) >> 8) & ~255) | ((4088) & 255))
		} else {
			(4088)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4088) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubw)
		opcode: (u16((if (((4089) & 65280) == 3840) {
			((((4089) >> 8) & ~255) | ((4089) & 255))
		} else {
			(4089)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4089) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubd)
		opcode: (u16((if (((4090) & 65280) == 3840) {
			((((4090) >> 8) & ~255) | ((4090) & 255))
		} else {
			(4090)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4090) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubsb)
		opcode: (u16((if (((4072) & 65280) == 3840) {
			((((4072) >> 8) & ~255) | ((4072) & 255))
		} else {
			(4072)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4072) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubsw)
		opcode: (u16((if (((4073) & 65280) == 3840) {
			((((4073) >> 8) & ~255) | ((4073) & 255))
		} else {
			(4073)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4073) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubusb)
		opcode: (u16((if (((4056) & 65280) == 3840) {
			((((4056) >> 8) & ~255) | ((4056) & 255))
		} else {
			(4056)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4056) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_psubusw)
		opcode: (u16((if (((4057) & 65280) == 3840) {
			((((4057) >> 8) & ~255) | ((4057) & 255))
		} else {
			(4057)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4057) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckhbw)
		opcode: (u16((if (((3944) & 65280) == 3840) {
			((((3944) >> 8) & ~255) | ((3944) & 255))
		} else {
			(3944)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3944) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckhwd)
		opcode: (u16((if (((3945) & 65280) == 3840) {
			((((3945) >> 8) & ~255) | ((3945) & 255))
		} else {
			(3945)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3945) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckhdq)
		opcode: (u16((if (((3946) & 65280) == 3840) {
			((((3946) >> 8) & ~255) | ((3946) & 255))
		} else {
			(3946)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3946) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpcklbw)
		opcode: (u16((if (((3936) & 65280) == 3840) {
			((((3936) >> 8) & ~255) | ((3936) & 255))
		} else {
			(3936)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3936) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpcklwd)
		opcode: (u16((if (((3937) & 65280) == 3840) {
			((((3937) >> 8) & ~255) | ((3937) & 255))
		} else {
			(3937)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3937) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_punpckldq)
		opcode: (u16((if (((3938) & 65280) == 3840) {
			((((3938) >> 8) & ~255) | ((3938) & 255))
		} else {
			(3938)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3938) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pxor)
		opcode: (u16((if (((4079) & 65280) == 3840) {
			((((4079) >> 8) & ~255) | ((4079) & 255))
		} else {
			(4079)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4079) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movups)
		opcode: (u16((if (((3856) & 65280) == 3840) {
			((((3856) >> 8) & ~255) | ((3856) & 255))
		} else {
			(3856)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3856) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_reg32, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movups)
		opcode: (u16((if (((3857) & 65280) == 3840) {
			((((3857) >> 8) & ~255) | ((3857) & 255))
		} else {
			(3857)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3857) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_sse, opt_ea | opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movaps)
		opcode: (u16((if (((3880) & 65280) == 3840) {
			((((3880) >> 8) & ~255) | ((3880) & 255))
		} else {
			(3880)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3880) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_reg32, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movaps)
		opcode: (u16((if (((3881) & 65280) == 3840) {
			((((3881) >> 8) & ~255) | ((3881) & 255))
		} else {
			(3881)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3881) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_sse, opt_ea | opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movhps)
		opcode: (u16((if (((3862) & 65280) == 3840) {
			((((3862) >> 8) & ~255) | ((3862) & 255))
		} else {
			(3862)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3862) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_reg32, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_movhps)
		opcode: (u16((if (((3863) & 65280) == 3840) {
			((((3863) >> 8) & ~255) | ((3863) & 255))
		} else {
			(3863)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3863) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_sse, opt_ea | opt_reg32]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_addps)
		opcode: (u16((if (((3928) & 65280) == 3840) {
			((((3928) >> 8) & ~255) | ((3928) & 255))
		} else {
			(3928)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3928) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cvtpi2ps)
		opcode: (u16((if (((3882) & 65280) == 3840) {
			((((3882) >> 8) & ~255) | ((3882) & 255))
		} else {
			(3882)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3882) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmx, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cvtps2pi)
		opcode: (u16((if (((3885) & 65280) == 3840) {
			((((3885) >> 8) & ~255) | ((3885) & 255))
		} else {
			(3885)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3885) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_mmx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_cvttps2pi)
		opcode: (u16((if (((3884) & 65280) == 3840) {
			((((3884) >> 8) & ~255) | ((3884) & 255))
		} else {
			(3884)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3884) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_mmx]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_divps)
		opcode: (u16((if (((3934) & 65280) == 3840) {
			((((3934) >> 8) & ~255) | ((3934) & 255))
		} else {
			(3934)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3934) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_maxps)
		opcode: (u16((if (((3935) & 65280) == 3840) {
			((((3935) >> 8) & ~255) | ((3935) & 255))
		} else {
			(3935)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3935) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_minps)
		opcode: (u16((if (((3933) & 65280) == 3840) {
			((((3933) >> 8) & ~255) | ((3933) & 255))
		} else {
			(3933)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3933) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mulps)
		opcode: (u16((if (((3929) & 65280) == 3840) {
			((((3929) >> 8) & ~255) | ((3929) & 255))
		} else {
			(3929)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3929) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pavgb)
		opcode: (u16((if (((4064) & 65280) == 3840) {
			((((4064) >> 8) & ~255) | ((4064) & 255))
		} else {
			(4064)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4064) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pavgw)
		opcode: (u16((if (((4067) & 65280) == 3840) {
			((((4067) >> 8) & ~255) | ((4067) & 255))
		} else {
			(4067)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4067) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmaxsw)
		opcode: (u16((if (((4078) & 65280) == 3840) {
			((((4078) >> 8) & ~255) | ((4078) & 255))
		} else {
			(4078)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4078) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pmaxub)
		opcode: (u16((if (((4062) & 65280) == 3840) {
			((((4062) >> 8) & ~255) | ((4062) & 255))
		} else {
			(4062)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4062) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pminsw)
		opcode: (u16((if (((4074) & 65280) == 3840) {
			((((4074) >> 8) & ~255) | ((4074) & 255))
		} else {
			(4074)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4074) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_pminub)
		opcode: (u16((if (((4058) & 65280) == 3840) {
			((((4058) >> 8) & ~255) | ((4058) & 255))
		} else {
			(4058)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((4058) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_mmxsse, opt_mmxsse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rcpss)
		opcode: (u16((if (((3923) & 65280) == 3840) {
			((((3923) >> 8) & ~255) | ((3923) & 255))
		} else {
			(3923)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3923) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_rsqrtps)
		opcode: (u16((if (((3922) & 65280) == 3840) {
			((((3922) >> 8) & ~255) | ((3922) & 255))
		} else {
			(3922)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3922) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sqrtps)
		opcode: (u16((if (((3921) & 65280) == 3840) {
			((((3921) >> 8) & ~255) | ((3921) & 255))
		} else {
			(3921)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3921) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_subps)
		opcode: (u16((if (((3932) & 65280) == 3840) {
			((((3932) >> 8) & ~255) | ((3932) & 255))
		} else {
			(3932)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3932) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 2
		op_type: [opt_ea | opt_sse, opt_sse]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_prefetchnta)
		opcode: (u16((if (((3864) & 65280) == 3840) {
			((((3864) >> 8) & ~255) | ((3864) & 255))
		} else {
			(3864)
		})))
		instr_type: u16((8) | ((0) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((1) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((2) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((3) << 13) | (if (((3864) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((1) << 13) | (if (((3853) & 65280) == 3840) { 256 } else { 0 }))
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
		instr_type: u16((8) | ((5) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_mfence)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16((8) | ((6) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_sfence)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16((8) | ((7) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 0
		op_type: [0]!
	},
	ASMInstr{
		sym: u16(Tcc_token.tok_asm_clflush)
		opcode: (u16((if (((4014) & 65280) == 3840) {
			((((4014) >> 8) & ~255) | ((4014) & 255))
		} else {
			(4014)
		})))
		instr_type: u16((8) | ((7) << 13) | (if (((4014) & 65280) == 3840) { 256 } else { 0 }))
		nb_ops: 1
		op_type: [u8(opt_ea), 0, 0]!
	},
	ASMInstr{
		sym: 0
	},
]!
