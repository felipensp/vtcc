@[translated]
module main

fn is_space(ch int) int {
	return ch == ` ` || ch == `	` || ch == `` || ch == `` || ch == `\r`
}

fn isid(c int) int {
	return (c >= `a` && c <= `z`) || (c >= `A` && c <= `Z`) || c == `_`
}

fn isnum(c int) int {
	return c >= `0` && c <= `9`
}

fn isoct(c int) int {
	return c >= `0` && c <= `7`
}

fn toup(c int) int {
	return if (c >= `a` && c <= `z`){ c - `a` + `A` } else {c}
}

@[weak] __global ( global_label_stack &Sym 

)

@[weak] __global ( define_stack &Sym 

)

@[weak] __global ( vtop &SValue 

)

@[weak] __global ( pvtop &SValue 

)

@[weak] __global ( ind int 

)

@[weak] __global ( loc int 

)

@[weak] __global ( last_line_num int 

)

@[weak] __global ( text_section &Section 

)

@[weak] __global ( cur_text_section &Section 

)

@[weak] __global ( hash_ident [16384]&TokenSym 

)

@[weak] __global ( token_buf [1025]i8 

)

@[weak] __global ( cstr_buf CString 

)

@[weak] __global ( macro_equal_buf CString 

)

@[weak] __global ( tokstr_buf TokenString 

)

@[weak] __global ( isidnum_table [257]u8 

)

@[weak] __global ( pp_debug_tok int 

)

@[weak] __global ( pp_debug_symv int 

)

@[weak] __global ( pp_once int 

)

@[weak] __global ( pp_expr int 

)

@[weak] __global ( pp_counter int 

)

fn tok_print(msg &i8, str &int) 

@[weak] __global ( toksym_alloc &TinyAlloc 

)

@[weak] __global ( tokstr_alloc &TinyAlloc 

)

@[weak] __global ( cstr_alloc &TinyAlloc 

)

@[weak] __global ( macro_stack &TokenString 

)

[export:'tcc_keywords']
const (
tcc_keywords   = c'int\000void\000char\000if\000else\000while\000break\000return\000for\000extern\000static\000unsigned\000goto\000do\000continue\000switch\000case\000const\000__const\000__const__\000volatile\000__volatile\000__volatile__\000long\000register\000signed\000__signed\000__signed__\000auto\000inline\000__inline\000__inline__\000restrict\000__restrict\000__restrict__\000__extension__\000_Generic\000_Static_assert\000float\000double\000_Bool\000short\000struct\000union\000typedef\000default\000enum\000sizeof\000__attribute\000__attribute__\000__alignof\000__alignof__\000_Alignof\000_Alignas\000typeof\000__typeof\000__typeof__\000__label__\000asm\000__asm\000__asm__\000define\000include\000include_next\000ifdef\000ifndef\000elif\000endif\000defined\000undef\000error\000warning\000line\000pragma\000__LINE__\000__FILE__\000__DATE__\000__TIME__\000__FUNCTION__\000__VA_ARGS__\000__COUNTER__\000__func__\000__nan__\000__snan__\000__inf__\000section\000__section__\000aligned\000__aligned__\000packed\000__packed__\000weak\000__weak__\000alias\000__alias__\000unused\000__unused__\000cdecl\000__cdecl\000__cdecl__\000stdcall\000__stdcall\000__stdcall__\000fastcall\000__fastcall\000__fastcall__\000regparm\000__regparm__\000cleanup\000__cleanup__\000__mode__\000__QI__\000__DI__\000__HI__\000__SI__\000__word__\000dllexport\000dllimport\000nodecorate\000noreturn\000__noreturn__\000_Noreturn\000visibility\000__visibility__\000__builtin_types_compatible_p\000__builtin_choose_expr\000__builtin_constant_p\000__builtin_frame_address\000__builtin_return_address\000__builtin_expect\000__builtin_va_arg_types\000pack\000comment\000lib\000push_macro\000pop_macro\000once\000option\000memcpy\000memmove\000memset\000__divdi3\000__moddi3\000__udivdi3\000__umoddi3\000__ashrdi3\000__lshrdi3\000__ashldi3\000__floatundisf\000__floatundidf\000__floatundixf\000__fixunsxfdi\000__fixunssfdi\000__fixunsdfdi\000alloca\000__bound_ptr_add\000__bound_ptr_indir1\000__bound_ptr_indir2\000__bound_ptr_indir4\000__bound_ptr_indir8\000__bound_ptr_indir12\000__bound_ptr_indir16\000__bound_main_arg\000__bound_local_new\000__bound_local_delete\000strlen\000strcpy\000.byte\000.word\000.align\000.balign\000.p2align\000.set\000.skip\000.space\000.string\000.asciz\000.ascii\000.file\000.globl\000.global\000.weak\000.hidden\000.ident\000.size\000.type\000.text\000.data\000.bss\000.previous\000.pushsection\000.popsection\000.fill\000.rept\000.endr\000.org\000.quad\000.code64\000.short\000.long\000.int\000.section\000al\000cl\000dl\000bl\000ah\000ch\000dh\000bh\000ax\000cx\000dx\000bx\000sp\000bp\000si\000di\000eax\000ecx\000edx\000ebx\000esp\000ebp\000esi\000edi\000rax\000rcx\000rdx\000rbx\000rsp\000rbp\000rsi\000rdi\000mm0\000mm1\000mm2\000mm3\000mm4\000mm5\000mm6\000mm7\000xmm0\000xmm1\000xmm2\000xmm3\000xmm4\000xmm5\000xmm6\000xmm7\000cr0\000cr1\000cr2\000cr3\000cr4\000cr5\000cr6\000cr7\000tr0\000tr1\000tr2\000tr3\000tr4\000tr5\000tr6\000tr7\000db0\000db1\000db2\000db3\000db4\000db5\000db6\000db7\000dr0\000dr1\000dr2\000dr3\000dr4\000dr5\000dr6\000dr7\000es\000cs\000ss\000ds\000fs\000gs\000st\000rip\000spl\000bpl\000sil\000dil\000movb\000movw\000movl\000movq\000mov\000addb\000addw\000addl\000addq\000add\000orb\000orw\000orl\000orq\000or\000adcb\000adcw\000adcl\000adcq\000adc\000sbbb\000sbbw\000sbbl\000sbbq\000sbb\000andb\000andw\000andl\000andq\000and\000subb\000subw\000subl\000subq\000sub\000xorb\000xorw\000xorl\000xorq\000xor\000cmpb\000cmpw\000cmpl\000cmpq\000cmp\000incb\000incw\000incl\000incq\000inc\000decb\000decw\000decl\000decq\000dec\000notb\000notw\000notl\000notq\000not\000negb\000negw\000negl\000negq\000neg\000mulb\000mulw\000mull\000mulq\000mul\000imulb\000imulw\000imull\000imulq\000imul\000divb\000divw\000divl\000divq\000div\000idivb\000idivw\000idivl\000idivq\000idiv\000xchgb\000xchgw\000xchgl\000xchgq\000xchg\000testb\000testw\000testl\000testq\000test\000rolb\000rolw\000roll\000rolq\000rol\000rorb\000rorw\000rorl\000rorq\000ror\000rclb\000rclw\000rcll\000rclq\000rcl\000rcrb\000rcrw\000rcrl\000rcrq\000rcr\000shlb\000shlw\000shll\000shlq\000shl\000shrb\000shrw\000shrl\000shrq\000shr\000sarb\000sarw\000sarl\000sarq\000sar\000shldw\000shldl\000shldq\000shld\000shrdw\000shrdl\000shrdq\000shrd\000pushw\000pushl\000pushq\000push\000popw\000popl\000popq\000pop\000inb\000inw\000inl\000in\000outb\000outw\000outl\000out\000movzbw\000movzbl\000movzbq\000movzb\000movzwl\000movsbw\000movsbl\000movswl\000movsbq\000movswq\000movzwq\000movslq\000leaw\000leal\000leaq\000lea\000les\000lds\000lss\000lfs\000lgs\000call\000jmp\000lcall\000ljmp\000jo\000jno\000jb\000jc\000jnae\000jnb\000jnc\000jae\000je\000jz\000jne\000jnz\000jbe\000jna\000jnbe\000ja\000js\000jns\000jp\000jpe\000jnp\000jpo\000jl\000jnge\000jnl\000jge\000jle\000jng\000jnle\000jg\000seto\000setno\000setb\000setc\000setnae\000setnb\000setnc\000setae\000sete\000setz\000setne\000setnz\000setbe\000setna\000setnbe\000seta\000sets\000setns\000setp\000setpe\000setnp\000setpo\000setl\000setnge\000setnl\000setge\000setle\000setng\000setnle\000setg\000setob\000setnob\000setbb\000setcb\000setnaeb\000setnbb\000setncb\000setaeb\000seteb\000setzb\000setneb\000setnzb\000setbeb\000setnab\000setnbeb\000setab\000setsb\000setnsb\000setpb\000setpeb\000setnpb\000setpob\000setlb\000setngeb\000setnlb\000setgeb\000setleb\000setngb\000setnleb\000setgb\000cmovo\000cmovno\000cmovb\000cmovc\000cmovnae\000cmovnb\000cmovnc\000cmovae\000cmove\000cmovz\000cmovne\000cmovnz\000cmovbe\000cmovna\000cmovnbe\000cmova\000cmovs\000cmovns\000cmovp\000cmovpe\000cmovnp\000cmovpo\000cmovl\000cmovnge\000cmovnl\000cmovge\000cmovle\000cmovng\000cmovnle\000cmovg\000bsfw\000bsfl\000bsfq\000bsf\000bsrw\000bsrl\000bsrq\000bsr\000btw\000btl\000btq\000bt\000btsw\000btsl\000btsq\000bts\000btrw\000btrl\000btrq\000btr\000btcw\000btcl\000btcq\000btc\000larw\000larl\000larq\000lar\000lslw\000lsll\000lslq\000lsl\000fadd\000faddp\000fadds\000fiaddl\000faddl\000fiadds\000fmul\000fmulp\000fmuls\000fimull\000fmull\000fimuls\000fcom\000fcom_1\000fcoms\000ficoml\000fcoml\000ficoms\000fcomp\000fcompp\000fcomps\000ficompl\000fcompl\000ficomps\000fsub\000fsubp\000fsubs\000fisubl\000fsubl\000fisubs\000fsubr\000fsubrp\000fsubrs\000fisubrl\000fsubrl\000fisubrs\000fdiv\000fdivp\000fdivs\000fidivl\000fdivl\000fidivs\000fdivr\000fdivrp\000fdivrs\000fidivrl\000fdivrl\000fidivrs\000xaddb\000xaddw\000xaddl\000xaddq\000xadd\000cmpxchgb\000cmpxchgw\000cmpxchgl\000cmpxchgq\000cmpxchg\000cmpsb\000cmpsw\000cmpsl\000cmpsq\000cmps\000scmpb\000scmpw\000scmpl\000scmpq\000scmp\000insb\000insw\000insl\000ins\000outsb\000outsw\000outsl\000outs\000lodsb\000lodsw\000lodsl\000lodsq\000lods\000slodb\000slodw\000slodl\000slodq\000slod\000movsb\000movsw\000movsl\000movsq\000movs\000smovb\000smovw\000smovl\000smovq\000smov\000scasb\000scasw\000scasl\000scasq\000scas\000sscab\000sscaw\000sscal\000sscaq\000ssca\000stosb\000stosw\000stosl\000stosq\000stos\000sstob\000sstow\000sstol\000sstoq\000ssto\000clc\000cld\000cli\000clts\000cmc\000lahf\000sahf\000pushfq\000popfq\000pushf\000popf\000stc\000std\000sti\000aaa\000aas\000daa\000das\000aad\000aam\000cbw\000cwd\000cwde\000cdq\000cbtw\000cwtl\000cwtd\000cltd\000cqto\000int3\000into\000iret\000rsm\000hlt\000wait\000nop\000pause\000xlat\000lock\000rep\000repe\000repz\000repne\000repnz\000invd\000wbinvd\000cpuid\000wrmsr\000rdtsc\000rdmsr\000rdpmc\000syscall\000sysret\000ud2\000leave\000ret\000retq\000lret\000fucompp\000ftst\000fxam\000fld1\000fldl2t\000fldl2e\000fldpi\000fldlg2\000fldln2\000fldz\000f2xm1\000fyl2x\000fptan\000fpatan\000fxtract\000fprem1\000fdecstp\000fincstp\000fprem\000fyl2xp1\000fsqrt\000fsincos\000frndint\000fscale\000fsin\000fcos\000fchs\000fabs\000fninit\000fnclex\000fnop\000fwait\000fxch\000fnstsw\000emms\000sysretq\000ljmpw\000ljmpl\000enter\000loopne\000loopnz\000loope\000loopz\000loop\000jecxz\000fld\000fldl\000flds\000fildl\000fildq\000fildll\000fldt\000fbld\000fst\000fstl\000fsts\000fstps\000fstpl\000fist\000fistp\000fistl\000fistpl\000fstp\000fistpq\000fistpll\000fstpt\000fbstp\000fucom\000fucomp\000finit\000fldcw\000fnstcw\000fstcw\000fstsw\000fclex\000fnstenv\000fstenv\000fldenv\000fnsave\000fsave\000frstor\000ffree\000ffreep\000fxsave\000fxrstor\000fxsaveq\000fxrstorq\000arpl\000lgdt\000lgdtq\000lidt\000lidtq\000lldt\000lmsw\000ltr\000sgdt\000sgdtq\000sidt\000sidtq\000sldt\000smsw\000str\000verr\000verw\000swapgs\000bswap\000bswapl\000bswapq\000invlpg\000cmpxchg8b\000cmpxchg16b\000fcmovb\000fcmove\000fcmovbe\000fcmovu\000fcmovnb\000fcmovne\000fcmovnbe\000fcmovnu\000fucomi\000fcomi\000fucomip\000fcomip\000movd\000packssdw\000packsswb\000packuswb\000paddb\000paddw\000paddd\000paddsb\000paddsw\000paddusb\000paddusw\000pand\000pandn\000pcmpeqb\000pcmpeqw\000pcmpeqd\000pcmpgtb\000pcmpgtw\000pcmpgtd\000pmaddwd\000pmulhw\000pmullw\000por\000psllw\000pslld\000psllq\000psraw\000psrad\000psrlw\000psrld\000psrlq\000psubb\000psubw\000psubd\000psubsb\000psubsw\000psubusb\000psubusw\000punpckhbw\000punpckhwd\000punpckhdq\000punpcklbw\000punpcklwd\000punpckldq\000pxor\000movups\000movaps\000movhps\000addps\000cvtpi2ps\000cvtps2pi\000cvttps2pi\000divps\000maxps\000minps\000mulps\000pavgb\000pavgw\000pmaxsw\000pmaxub\000pminsw\000pminub\000rcpss\000rsqrtps\000sqrtps\000subps\000prefetchnta\000prefetcht0\000prefetcht1\000prefetcht2\000prefetchw\000lfence\000mfence\000sfence\000clflush\000'
)

[export:'tok_two_chars']
const (
tok_two_chars   = [`<`, `=`, 158, `>`, `=`, 157, `!`, `=`, 149, `&`, `&`, 160, `|`, `|`, 161, `+`, `+`, 164, `-`, `-`, 162, `=`, `=`, 148, `<`, `<`, 1, `>`, `>`, 2, `+`, `=`, 171, `-`, `=`, 173, `*`, `=`, 170, `/`, `=`, 175, `%`, `=`, 165, `&`, `=`, 166, `^`, `=`, 222, `|`, `=`, 252, `-`, `>`, 199, `.`, `.`, 168, `#`, `#`, 202, 0]!

)

fn next_nomacro_spc() 

fn skip(c int)  {
	if tok != c {
	tcc_error(c"'%c' expected (got \"%s\")", c, get_tok_str(tok, &tokc))
	}
	next()
}

fn expect(msg &i8)  {
	tcc_error(c'%s expected', msg)
}

struct TinyAlloc { 
	limit u32
	size u32
	buffer &u8
	p &u8
	nb_allocs u32
	next &TinyAlloc
	top &TinyAlloc
}
struct Tal_header_t { 
	size u32
}
fn tal_new(pal &&TinyAlloc, limit u32, size u32) &TinyAlloc {
	al := tcc_mallocz(sizeof(TinyAlloc))
	al.p = tcc_malloc(size)
	al.buffer = al.p
	al.limit = limit
	al.size = size
	if pal {
	*pal = al
	}
	return al
}

fn tal_delete(al &TinyAlloc)  {
	next := &TinyAlloc(0)
	// RRRREG tail_call id=0x7ffff2073e90
	tail_call: 
	if !al {
	return 
	}
	next = al.next
	tcc_free(al.buffer)
	tcc_free(al)
	al = next
	goto _GOTO_PLACEHOLDER_0x7ffff2073e90 // id: 0x7ffff2073e90
}

fn tal_free_impl(al &TinyAlloc, p voidptr)  {
	if !p {
	return 
	}
	// RRRREG tail_call id=0x7ffff207e470
	tail_call: 
	if al.buffer <= &u8(p) && &u8(p) < al.buffer + al.size {
		al.nb_allocs --
		if !al.nb_allocs {
		al.p = al.buffer
		}
	}
	else if al.next {
		al = al.next
		goto _GOTO_PLACEHOLDER_0x7ffff207e470 // id: 0x7ffff207e470
	}
	else { // 3
	tcc_free(p)
}
}

fn tal_realloc_impl(pal &&TinyAlloc, p voidptr, size u32) voidptr {
	header := &Tal_header_t(0)
	ret := &voidptr(0)
	is_own := 0
	adj_size := (size + 3) & -4
	al := *pal
	// RRRREG tail_call id=0x7ffff207f1b8
	tail_call: 
	is_own = (al.buffer <= &u8(p) && &u8(p) < al.buffer + al.size)
	if (!p || is_own) && size <= al.limit {
		if al.p + adj_size + sizeof(Tal_header_t) < al.buffer + al.size {
			header = &Tal_header_t(al.p)
			header.size = adj_size
			ret = al.p + sizeof(Tal_header_t)
			al.p += adj_size + sizeof(Tal_header_t)
			if is_own {
				header = ((&Tal_header_t(p)) - 1)
				C.memcpy(ret, p, header.size)
			}
			else {
				al.nb_allocs ++
			}
			return ret
		}
		else if is_own {
			al.nb_allocs --
			ret = tal_realloc_impl(&*pal, 0, size)
			header = ((&Tal_header_t(p)) - 1)
			C.memcpy(ret, p, header.size)
			return ret
		}
		if al.next {
			al = al.next
		}
		else {
			bottom := al
next := if al.top{ al.top } else {al}

			al = tal_new(pal, next.limit, next.size * 2)
			al.next = next
			bottom.top = al
		}
		goto tail_call // id: 0x7ffff207f1b8
	}
	if is_own {
		al.nb_allocs --
		ret = tcc_malloc(size)
		header = ((&Tal_header_t(p)) - 1)
		C.memcpy(ret, p, header.size)
	}
	else if al.next {
		al = al.next
		goto tail_call // id: 0x7ffff207f1b8
	}
	else { // 3
	ret = tcc_realloc(p, size)
}
	return ret
}

fn cstr_realloc(cstr &CString, new_size int)  {
	size := 0
	size = cstr.size_allocated
	if size < 8 {
	size = 8
	}
	for size < new_size {
	size = size * 2
	}
	cstr.data = tal_realloc_impl(&cstr_alloc, cstr.data, size)
	cstr.size_allocated = size
}

fn cstr_ccat(cstr &CString, ch int)  {
	size := 0
	size = cstr.size + 1
	if size > cstr.size_allocated {
	cstr_realloc(cstr, size)
	}
	(&u8(cstr.data)) [size - 1]  = ch
	cstr.size = size
}

fn cstr_cat(cstr &CString, str &i8, len int)  {
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

fn cstr_wccat(cstr &CString, ch int)  {
	size := 0
	size = cstr.size + sizeof(Nwchar_t)
	if size > cstr.size_allocated {
	cstr_realloc(cstr, size)
	}
	*&Nwchar_t(((&u8(cstr.data)) + size - sizeof(Nwchar_t))) = ch
	cstr.size = size
}

fn cstr_new(cstr &CString)  {
	C.memset(cstr, 0, sizeof(CString))
}

fn cstr_free(cstr &CString)  {
	tal_free_impl(cstr_alloc, cstr.data)
	cstr_new(cstr)
}

fn cstr_reset(cstr &CString)  {
	cstr.size = 0
}

fn add_char(cstr &CString, c int)  {
	if c == `'` || c == `"` || c == `\\` {
		cstr_ccat(cstr, `\\`)
	}
	if c >= 32 && c <= 126 {
		cstr_ccat(cstr, c)
	}
	else {
		cstr_ccat(cstr, `\\`)
		if c == `\n` {
			cstr_ccat(cstr, `n`)
		}
		else {
			cstr_ccat(cstr, `0` + ((c >> 6) & 7))
			cstr_ccat(cstr, `0` + ((c >> 3) & 7))
			cstr_ccat(cstr, `0` + (c & 7))
		}
	}
}

fn tok_alloc_new(pts &&TokenSym, str &i8, len int) &TokenSym {
	ts := &TokenSym(0)
	ptable := &&TokenSym(0)
	
	i := 0
	if tok_ident >= 268435456 {
	tcc_error(c'memory full (symbols)')
	}
	i = tok_ident - 256
	if (i % 512) == 0 {
		ptable = tcc_realloc(table_ident, (i + 512) * sizeof(&TokenSym))
		table_ident = ptable
	}
	ts = tal_realloc_impl(&toksym_alloc, 0, sizeof(TokenSym) + len)
	table_ident [i]  = ts
	ts.tok = tok_ident ++
	ts.sym_define = (voidptr(0))
	ts.sym_label = (voidptr(0))
	ts.sym_struct = (voidptr(0))
	ts.sym_identifier = (voidptr(0))
	ts.len = len
	ts.hash_next = (voidptr(0))
	C.memcpy(ts.str, str, len)
	ts.str [len]  = ` `
	*pts = ts
	return ts
}

fn tok_alloc(str &i8, len int) &TokenSym {
	ts := &TokenSym(0)
	pts := &&TokenSym(0)
	
	i := 0
	h := u32(0)
	h = 1
	for i = 0 ; i < len ; i ++ {
	h = ((h) + ((h) << 5) + ((h) >> 27) + ((&u8(str)) [i] ))
	}
	h &= (16384 - 1)
	pts = &hash_ident [h] 
	for  ;  ;  {
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

fn get_tok_str(v int, cv &CValue) &i8 {
	p := &i8(0)
	i := 0
	len := 0
	
	cstr_reset(&cstr_buf)
	p = cstr_buf.data
	match v {
	 181, 182, 206, 207, 183, 184{
	sprintf(p, c'%llu', i64(cv.i))
	
	}
	 180{ // case comp body kind=CallExpr is_enum=false
	cstr_ccat(&cstr_buf, `L`)
	}
	 179{ // case comp body kind=CallExpr is_enum=false
	cstr_ccat(&cstr_buf, `'`)
	add_char(&cstr_buf, cv.i)
	cstr_ccat(&cstr_buf, `'`)
	cstr_ccat(&cstr_buf, ` `)
	
	}
	 190, 191{
	return &i8(cv.str.data)
	}
	 186{ // case comp body kind=CallExpr is_enum=false
	cstr_ccat(&cstr_buf, `L`)
	}
	 185{ // case comp body kind=CallExpr is_enum=false
	cstr_ccat(&cstr_buf, `"`)
	if v == 185 {
		len = cv.str.size - 1
		for i = 0 ; i < len ; i ++ {
		add_char(&cstr_buf, (&u8(cv.str.data)) [i] )
		}
	}
	else {
		len = (cv.str.size / sizeof(Nwchar_t)) - 1
		for i = 0 ; i < len ; i ++ {
		add_char(&cstr_buf, (&Nwchar_t(cv.str.data)) [i] )
		}
	}
	cstr_ccat(&cstr_buf, `"`)
	cstr_ccat(&cstr_buf, ` `)
	
	}
	 187{ // case comp body kind=CallExpr is_enum=false
	cstr_cat(&cstr_buf, c'<float>', 0)
	
	}
	 188{ // case comp body kind=CallExpr is_enum=false
	cstr_cat(&cstr_buf, c'<double>', 0)
	
	}
	 189{ // case comp body kind=CallExpr is_enum=false
	cstr_cat(&cstr_buf, c'<long double>', 0)
	
	}
	 192{ // case comp body kind=CallExpr is_enum=false
	cstr_cat(&cstr_buf, c'<linenumber>', 0)
	
	}
	 156{ // case comp body kind=BinaryOperator is_enum=false
	v = `<`
	goto addv // id: 0x7ffff2095f70
	}
	 159{ // case comp body kind=BinaryOperator is_enum=false
	v = `>`
	goto addv // id: 0x7ffff2095f70
	}
	 200{ // case comp body kind=ReturnStmt is_enum=false
	return strcpy(p, c'.')
	}
	 129{ // case comp body kind=ReturnStmt is_enum=false
	return strcpy(p, c'<<=')
	}
	 130{ // case comp body kind=ReturnStmt is_enum=false
	return strcpy(p, c'>>=')
	}
	 (-1){ // case comp body kind=ReturnStmt is_enum=false
	return strcpy(p, c'<eof>')
	
	}
	else {
	if v < 256 {
		q := tok_two_chars
		for *q {
			if q [2]  == v {
				*p ++ = q [0] 
				*p ++ = q [1] 
				*p = ` `
				return cstr_buf.data
			}
			q += 3
		}
		if v >= 127 {
			sprintf(cstr_buf.data, c'<%02x>', v)
			return cstr_buf.data
		}
		// RRRREG addv id=0x7ffff2095f70
		addv: 
		*p ++ = v
		*p = ` `
	}
	else if v < tok_ident {
		return table_ident [v - 256] .str
	}
	else if v >= 268435456 {
		sprintf(p, c'L.%u', v - 268435456)
	}
	else {
		return (voidptr(0))
	}
	}
	}
	return cstr_buf.data
}

fn handle_eob() int {
	bf := file
	len := 0
	if bf.buf_ptr >= bf.buf_end {
		if bf.fd >= 0 {
			len = 8192
			len = C.read(bf.fd, bf.buffer, len)
			if len < 0 {
			len = 0
			}
		}
		else {
			len = 0
		}
		total_bytes += len
		bf.buf_ptr = bf.buffer
		bf.buf_end = bf.buffer + len
		*bf.buf_end = `\\`
	}
	if bf.buf_ptr < bf.buf_end {
		return bf.buf_ptr [0] 
	}
	else {
		bf.buf_ptr = bf.buf_end
		return (-1)
	}
}

fn inp()  {
	ch = *((file.buf_ptr) ++$)
	if ch == `\\` {
	ch = handle_eob()
	}
}

fn handle_stray_noerror() int {
	for ch == `\\` {
		inp()
		if ch == `\n` {
			file.line_num ++
			inp()
		}
		else if ch == `\r` {
			inp()
			if ch != `\n` {
			goto fail // id: 0x7ffff20995e0
			}
			file.line_num ++
			inp()
		}
		else {
			// RRRREG fail id=0x7ffff20995e0
			fail: 
			return 1
		}
	}
	return 0
}

fn handle_stray()  {
	if handle_stray_noerror() {
	tcc_error(c"stray '\\' in program")
	}
}

fn handle_stray1(p &u8) int {
	c := 0
	file.buf_ptr = p
	if p >= file.buf_end {
		c = handle_eob()
		if c != `\\` {
		return c
		}
		p = file.buf_ptr
	}
	ch = *p
	if handle_stray_noerror() {
		if !(parse_flags & 32) {
		tcc_error(c"stray '\\' in program")
		}
		*file.buf_ptr --$ = `\\`
	}
	p = file.buf_ptr
	c = *p
	return c
}

fn minp()  {
	inp()
	if ch == `\\` {
	handle_stray()
	}
}

fn parse_line_comment(p &u8) &u8 {
	c := 0
	p ++
	for  ;  ;  {
		c = *p
		// RRRREG redo id=0x7ffff209c508
		redo: 
		if c == `\n` || c == (-1) {
			break
			
		}
		else if c == `\\` {
			file.buf_ptr = p
			c = handle_eob()
			p = file.buf_ptr
			if c == `\\` {
				{
					p ++
					c = *p
					if c == `\\` {
						file.buf_ptr = p
						c = handle_eob()
						p = file.buf_ptr
					}
				}
				0
				if c == `\n` {
					file.line_num ++
					{
						p ++
						c = *p
						if c == `\\` {
							file.buf_ptr = p
							c = handle_eob()
							p = file.buf_ptr
						}
					}
					0
				}
				else if c == `\r` {
					{
						p ++
						c = *p
						if c == `\\` {
							file.buf_ptr = p
							c = handle_eob()
							p = file.buf_ptr
						}
					}
					0
					if c == `\n` {
						file.line_num ++
						{
							p ++
							c = *p
							if c == `\\` {
								file.buf_ptr = p
								c = handle_eob()
								p = file.buf_ptr
							}
						}
						0
					}
				}
			}
			else {
				goto _GOTO_PLACEHOLDER_0x7ffff209c508 // id: 0x7ffff209c508
			}
		}
		else {
			p ++
		}
	}
	return p
}

fn parse_comment(p &u8) &u8 {
	c := 0
	p ++
	for  ;  ;  {
		for  ;  ;  {
			c = *p
			if c == `\n` || c == `*` || c == `\\` {
			break
			
			}
			p ++
			c = *p
			if c == `\n` || c == `*` || c == `\\` {
			break
			
			}
			p ++
		}
		if c == `\n` {
			file.line_num ++
			p ++
		}
		else if c == `*` {
			p ++
			for  ;  ;  {
				c = *p
				if c == `*` {
					p ++
				}
				else if c == `/` {
					goto end_of_comment // id: 0x7ffff209d398
				}
				else if c == `\\` {
					file.buf_ptr = p
					c = handle_eob()
					p = file.buf_ptr
					if c == (-1) {
					tcc_error(c'unexpected end of file in comment')
					}
					if c == `\\` {
						for c == `\\` {
							{
								p ++
								c = *p
								if c == `\\` {
									file.buf_ptr = p
									c = handle_eob()
									p = file.buf_ptr
								}
							}
							0
							if c == `\n` {
								file.line_num ++
								{
									p ++
									c = *p
									if c == `\\` {
										file.buf_ptr = p
										c = handle_eob()
										p = file.buf_ptr
									}
								}
								0
							}
							else if c == `\r` {
								{
									p ++
									c = *p
									if c == `\\` {
										file.buf_ptr = p
										c = handle_eob()
										p = file.buf_ptr
									}
								}
								0
								if c == `\n` {
									file.line_num ++
									{
										p ++
										c = *p
										if c == `\\` {
											file.buf_ptr = p
											c = handle_eob()
											p = file.buf_ptr
										}
									}
									0
								}
							}
							else {
								goto after_star // id: 0x7ffff209ec20
							}
						}
					}
				}
				else {
					break
					
				}
			}
			// RRRREG after_star id=0x7ffff209ec20
			after_star: 
			0
		}
		else {
			file.buf_ptr = p
			c = handle_eob()
			p = file.buf_ptr
			if c == (-1) {
				tcc_error(c'unexpected end of file in comment')
			}
			else if c == `\\` {
				p ++
			}
		}
	}
	// RRRREG end_of_comment id=0x7ffff209d398
	end_of_comment: 
	p ++
	return p
}

fn set_idnum(c int, val int) int {
	prev := isidnum_table [c - (-1)] 
	isidnum_table [c - (-1)]  = val
	return prev
}

fn skip_spaces()  {
	for isidnum_table [ch - (-1)]  & 1 {
	minp()
	}
}

fn check_space(t int, spc &int) int {
	if t < 256 && (isidnum_table [t - (-1)]  & 1) {
		if *spc {
		return 1
		}
		*spc = 1
	}
	else { // 3
	*spc = 0
}
	return 0
}

fn parse_pp_string(p &u8, sep int, str &CString) &u8 {
	c := 0
	p ++
	for  ;  ;  {
		c = *p
		if c == sep {
			break
			
		}
		else if c == `\\` {
			file.buf_ptr = p
			c = handle_eob()
			p = file.buf_ptr
			if c == (-1) {
				// RRRREG unterminated_string id=0x7ffff20a0f00
				unterminated_string: 
				tcc_error(c'missing terminating %c character', sep)
			}
			else if c == `\\` {
				{
					p ++
					c = *p
					if c == `\\` {
						file.buf_ptr = p
						c = handle_eob()
						p = file.buf_ptr
					}
				}
				0
				if c == `\n` {
					file.line_num ++
					p ++
				}
				else if c == `\r` {
					{
						p ++
						c = *p
						if c == `\\` {
							file.buf_ptr = p
							c = handle_eob()
							p = file.buf_ptr
						}
					}
					0
					if c != `\n` {
					expect(c"'\n' after '\r'")
					}
					file.line_num ++
					p ++
				}
				else if c == (-1) {
					goto unterminated_string // id: 0x7ffff20a0f00
				}
				else {
					if str {
						cstr_ccat(str, `\\`)
						cstr_ccat(str, c)
					}
					p ++
				}
			}
		}
		else if c == `\n` {
			file.line_num ++
			goto add_char // id: 0x7ffff20a2170
		}
		else if c == `\r` {
			{
				p ++
				c = *p
				if c == `\\` {
					file.buf_ptr = p
					c = handle_eob()
					p = file.buf_ptr
				}
			}
			0
			if c != `\n` {
				if str {
				cstr_ccat(str, `\r`)
				}
			}
			else {
				file.line_num ++
				goto add_char // id: 0x7ffff20a2170
			}
		}
		else {
			// RRRREG add_char id=0x7ffff20a2170
			add_char: 
			if str {
			cstr_ccat(str, c)
			}
			p ++
		}
	}
	p ++
	return p
}

fn preprocess_skip()  {
	a := 0
	start_of_line := 0
	c := 0
	in_warn_or_error := 0
	
	p := &u8(0)
	p = file.buf_ptr
	a = 0
	// RRRREG redo_start id=0x7ffff20a3218
	redo_start: 
	start_of_line = 1
	in_warn_or_error = 0
	for  ;  ;  {
		// RRRREG redo_no_start id=0x7ffff20a33a8
		redo_no_start: 
		c = *p
		match c {
		 ` `, `	`, ``, ``, `\r`{
		p ++
		goto _GOTO_PLACEHOLDER_0x7ffff20a33a8 // id: 0x7ffff20a33a8
		}
		 `\n`{ // case comp body kind=UnaryOperator is_enum=false
		file.line_num ++
		p ++
		goto redo_start // id: 0x7ffff20a3218
		}
		 `\\`{ // case comp body kind=BinaryOperator is_enum=false
		file.buf_ptr = p
		c = handle_eob()
		if c == (-1) {
			expect(c'#endif')
		}
		else if c == `\\` {
			ch = file.buf_ptr [0] 
			handle_stray_noerror()
		}
		p = file.buf_ptr
		goto _GOTO_PLACEHOLDER_0x7ffff20a33a8 // id: 0x7ffff20a33a8
		}
		 `"`, `'`{
		if in_warn_or_error {
		goto _default // id: 0x7ffff20a3ef8
		}
		p = parse_pp_string(p, c, (voidptr(0)))
		
		}
		 `/`{ // case comp body kind=IfStmt is_enum=false
		if in_warn_or_error {
		goto _default // id: 0x7ffff20a3ef8
		}
		file.buf_ptr = p
		ch = *p
		minp()
		p = file.buf_ptr
		if ch == `*` {
			p = parse_comment(p)
		}
		else if ch == `/` {
			p = parse_line_comment(p)
		}
		
		}
		 `#`{ // case comp body kind=UnaryOperator is_enum=false
		p ++
		if start_of_line {
			file.buf_ptr = p
			next_nomacro()
			p = file.buf_ptr
			if a == 0 && (tok == Tcc_token.tok_else || tok == Tcc_token.tok_elif || tok == Tcc_token.tok_endif) {
			goto _GOTO_PLACEHOLDER_0x7ffff20a4d88 // id: 0x7ffff20a4d88
			}
			if tok == Tcc_token.tok_if || tok == Tcc_token.tok_ifdef || tok == Tcc_token.tok_ifndef {
			a ++
			}
			else if tok == Tcc_token.tok_endif {
			a --
			}
			else if tok == Tcc_token.tok_error || tok == Tcc_token.tok_warning {
			in_warn_or_error = 1
			}
			else if tok == 10 {
			goto redo_start // id: 0x7ffff20a3218
			}
			else if parse_flags & 8 {
			p = parse_line_comment(p - 1)
			}
		}
		else if parse_flags & 8 {
		p = parse_line_comment(p - 1)
		}
		
		// RRRREG _default id=0x7ffff20a3ef8
		_default: 
		
		
		}
		else{}
		}
		start_of_line = 0
	}
	// RRRREG the_end id=0x7ffff20a4d88
	the_end: 
	0
	file.buf_ptr = p
}

fn tok_str_new(s &TokenString)  {
	s.str = (voidptr(0))
	s.len = 0
	s.lastlen = s.len
	s.allocated_len = 0
	s.last_line_num = -1
}

fn tok_str_alloc() &TokenString {
	str := tal_realloc_impl(&tokstr_alloc, 0, sizeof(*str))
	tok_str_new(str)
	return str
}

fn tok_str_dup(s &TokenString) &int {
	str := &int(0)
	str = tal_realloc_impl(&tokstr_alloc, 0, s.len * sizeof(int))
	C.memcpy(str, s.str, s.len * sizeof(int))
	return str
}

fn tok_str_free_str(str &int)  {
	tal_free_impl(tokstr_alloc, str)
}

fn tok_str_free(str &TokenString)  {
	tok_str_free_str(str.str)
	tal_free_impl(tokstr_alloc, str)
}

fn tok_str_realloc(s &TokenString, new_size int) &int {
	str := &int(0)
	size := 0
	
	size = s.allocated_len
	if size < 16 {
	size = 16
	}
	for size < new_size {
	size = size * 2
	}
	if size > s.allocated_len {
		str = tal_realloc_impl(&tokstr_alloc, s.str, size * sizeof(int))
		s.allocated_len = size
		s.str = str
	}
	return s.str
}

fn tok_str_add(s &TokenString, t int)  {
	len := 0
	str := &int(0)
	
	len = s.len
	str = s.str
	if len >= s.allocated_len {
	str = tok_str_realloc(s, len + 1)
	}
	str [len ++]  = t
	s.len = len
}

fn begin_macro(str &TokenString, alloc int)  {
	str.alloc = alloc
	str.prev = macro_stack
	str.prev_ptr = macro_ptr
	str.save_line_num = file.line_num
	macro_ptr = str.str
	macro_stack = str
}

fn end_macro()  {
	str := macro_stack
	macro_stack = str.prev
	macro_ptr = str.prev_ptr
	file.line_num = str.save_line_num
	if str.alloc != 0 {
		if str.alloc == 2 {
		str.str = (voidptr(0))
		}
		tok_str_free(str)
	}
}

fn tok_str_add2(s &TokenString, t int, cv &CValue)  {
	len := 0
	str := &int(0)
	
	len = s.len
	s.lastlen = len
	str = s.str
	if len + 4 >= s.allocated_len {
	str = tok_str_realloc(s, len + 4 + 1)
	}
	str [len ++]  = t
	match t {
	 181, 182, 179, 180, 187, 192{
	str [len ++]  = cv.tab [0] 
	
	}
	 190, 191, 185, 186{
	{
		nb_words := 1 + (cv.str.size + sizeof(int) - 1) / sizeof(int)
		if len + nb_words >= s.allocated_len {
		str = tok_str_realloc(s, len + nb_words + 1)
		}
		str [len]  = cv.str.size
		C.memcpy(&str [len + 1] , cv.str.data, cv.str.size)
		len += nb_words
	}
	
	}
	 188, 183, 184, 206, 207{
	str [len ++]  = cv.tab [0] 
	str [len ++]  = cv.tab [1] 
	
	}
	 189{ // case comp body kind=BinaryOperator is_enum=false
	str [len ++]  = cv.tab [0] 
	str [len ++]  = cv.tab [1] 
	str [len ++]  = cv.tab [2] 
	str [len ++]  = cv.tab [3] 
	
	}
	else {
	
	}
	}
	s.len = len
}

fn tok_str_add_tok(s &TokenString)  {
	cval := CValue{}
	if file.line_num != s.last_line_num {
		s.last_line_num = file.line_num
		cval.i = s.last_line_num
		tok_str_add2(s, 192, &cval)
	}
	tok_str_add2(s, tok, &tokc)
}

[c:'TOK_GET']
fn tok_get(t &int, pp &&int, cv &CValue)  {
	p := *pp
	n := 0
	tab := &int(0)
	
	tab = cv.tab
	*t = *p ++
	match *t {
	 181, 179, 180, 192{
	cv.i = *p ++
	
	}
	 182{ // case comp body kind=BinaryOperator is_enum=false
	cv.i = u32(*p ++)
	
	}
	 187{ // case comp body kind=BinaryOperator is_enum=false
	tab [0]  = *p ++
	
	}
	 185, 186, 190, 191{
	cv.str.size = *p ++
	cv.str.data = p
	p += (cv.str.size + sizeof(int) - 1) / sizeof(int)
	
	}
	 188, 183, 184, 206, 207{
	n = 2
	goto copy // id: 0x7ffff20add18
	}
	 189{ // case comp body kind=BinaryOperator is_enum=false
	n = 4
	// RRRREG copy id=0x7ffff20add18
	copy: 
	for {
	*tab ++
	*p ++
	// while()
	if ! (n --$ ) { break }
	}
	
	}
	else {
	
	}
	}
	*pp = p
}

fn macro_is_equal(a &int, b &int) int {
	cv := CValue{}
	t := 0
	if !a || !b {
	return 1
	}
	for *a && *b {
		cstr_reset(&macro_equal_buf)
		tok_get(&t, &a, &cv)
		cstr_cat(&macro_equal_buf, get_tok_str(t, &cv), 0)
		tok_get(&t, &b, &cv)
		if C.strcmp(macro_equal_buf.data, get_tok_str(t, &cv)) {
		return 0
		}
	}
	return !(*a || *b)
}

fn define_push(v int, macro_type int, str &int, first_arg &Sym)  {
	s := &Sym(0)
	o := &Sym(0)
	
	o = define_find(v)
	s = sym_push2(&define_stack, v, macro_type, 0)
	s.d = str
	s.next = first_arg
	table_ident [v - 256] .sym_define = s
	if o && !macro_is_equal(o.d, s.d) {
	tcc_warning(c'%s redefined', get_tok_str(v, (voidptr(0))))
	}
}

fn define_undef(s &Sym)  {
	v := s.v
	if v >= 256 && v < tok_ident {
	table_ident [v - 256] .sym_define = (voidptr(0))
	}
}

fn define_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
	return (voidptr(0))
	}
	return table_ident [v] .sym_define
}

fn free_defines(b &Sym)  {
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
			d := &table_ident [v - 256] .sym_define
			if !*d && b.d {
			*d = b
			}
		}
		b = b.prev
	}
}

fn label_find(v int) &Sym {
	v -= 256
	if u32(v) >= u32((tok_ident - 256)) {
	return (voidptr(0))
	}
	return table_ident [v] .sym_label
}

fn label_push(ptop &&Sym, v int, flags int) &Sym {
	s := &Sym(0)
	ps := &&Sym(0)
	
	s = sym_push2(ptop, v, 0, 0)
	s.r = flags
	ps = &table_ident [v - 256] .sym_label
	if ptop == &global_label_stack {
		for *ps != (voidptr(0)) {
		ps = &(*ps).prev_tok
		}
	}
	s.prev_tok = *ps
	*ps = s
	return s
}

fn label_pop(ptop &&Sym, slast &Sym, keep int)  {
	s := &Sym(0)
	s1 := &Sym(0)
	
	for s = *ptop ; s != slast ; s = s1 {
		s1 = s.prev
		if s.r == 2 {
			tcc_warning(c"label '%s' declared but not used", get_tok_str(s.v, (voidptr(0))))
		}
		else if s.r == 1 {
			tcc_error(c"label '%s' used but not defined", get_tok_str(s.v, (voidptr(0))))
		}
		else {
			if s.c {
				put_extern_sym(s, cur_text_section, s.jnext, 1)
			}
		}
		table_ident [s.v - 256] .sym_label = s.prev_tok
		if !keep {
		sym_free(s)
		}
	}
	if !keep {
	*ptop = slast
	}
}

fn maybe_run_test(s &TCCState)  {
	p := &i8(0)
	if s.include_stack_ptr != s.include_stack {
	return 
	}
	p = get_tok_str(tok, (voidptr(0)))
	if 0 != C.memcmp(p, c'test_', 5) {
	return 
	}
	if 0 != s.run_test --$ {
	return 
	}
	C.fprintf(s.ppfp, c'\n[%s]\n' + !(s.dflag & 32), p) , C.fflush(s.ppfp)
	define_push(tok, 0, (voidptr(0)), (voidptr(0)))
}

fn expr_preprocess() int {
	c := 0
	t := 0
	
	str := &TokenString(0)
	str = tok_str_alloc()
	pp_expr = 1
	for tok != 10 && tok != (-1) {
		next()
		if tok == Tcc_token.tok_defined {
			next_nomacro()
			t = tok
			if t == `(` {
			next_nomacro()
			}
			if tok < 256 {
			expect(c'identifier')
			}
			if tcc_state.run_test {
			maybe_run_test(tcc_state)
			}
			c = define_find(tok) != 0
			if t == `(` {
				next_nomacro()
				if tok != `)` {
				expect(c"')'")
				}
			}
			tok = 181
			tokc.i = c
		}
		else if tok >= 256 {
			tok = 181
			tokc.i = 0
		}
		tok_str_add_tok(str)
	}
	pp_expr = 0
	tok_str_add(str, -1)
	tok_str_add(str, 0)
	begin_macro(str, 1)
	next()
	c = expr_const()
	end_macro()
	return c != 0
}

fn parse_define()  {
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
	first = (voidptr(0))
	t = 0
	parse_flags = ((parse_flags & ~8) | 16)
	next_nomacro_spc()
	if tok == `(` {
		dotid := set_idnum(`.`, 0)
		next_nomacro()
		ps = &first
		if tok != `)` {
		for  ;  ;  {
			varg = tok
			next_nomacro()
			is_vaargs = 0
			if varg == 200 {
				varg = Tcc_token.tok___va_args__
				is_vaargs = 1
			}
			else if tok == 200 && gnu_ext {
				is_vaargs = 1
				next_nomacro()
			}
			if varg < 256 {
			// RRRREG bad_list id=0x7ffff20bb4b0
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
			goto bad_list // id: 0x7ffff20bb4b0
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
			goto bad_twosharp // id: 0x7ffff20bc190
			}
			if 1 == spc {
			tokstr_buf.len --$
			}
			spc = 3
			tok = 205
		}
		else if `#` == tok {
			spc = 4
		}
		else if check_space(tok, &spc) {
			goto skip // id: 0x7ffff20bc5f8
		}
		tok_str_add2(&tokstr_buf, tok, &tokc)
		// RRRREG skip id=0x7ffff20bc5f8
		skip: 
		next_nomacro_spc()
	}
	parse_flags = saved_parse_flags
	if spc == 1 {
	tokstr_buf.len --$
	}
	tok_str_add(&tokstr_buf, 0)
	if 3 == spc {
	// RRRREG bad_twosharp id=0x7ffff20bc190
	bad_twosharp: 
	tcc_error(c"'##' cannot appear at either end of macro")
	}
	define_push(v, t, tok_str_dup(&tokstr_buf), first)
}

fn search_cached_include(s1 &TCCState, filename &i8, add int) &CachedInclude {
	s := &u8(0)
	h := u32(0)
	e := &CachedInclude(0)
	i := 0
	h = 1
	s = &u8(filename)
	for *s {
		h = ((h) + ((h) << 5) + ((h) >> 27) + (*s))
		s ++
	}
	h &= (32 - 1)
	i = s1.cached_includes_hash [h] 
	for  ;  ;  {
		if i == 0 {
		break
		
		}
		e = s1.cached_includes [i - 1] 
		if 0 == C.strcmp(e.filename, filename) {
		return e
		}
		i = e.hash_next
	}
	if !add {
	return (voidptr(0))
	}
	e = tcc_malloc(sizeof(CachedInclude) + C.strlen(filename))
	strcpy(e.filename, filename)
	e.ifndef_macro = 0
	e.once = e.ifndef_macro
	dynarray_add(&s1.cached_includes, &s1.nb_cached_includes, e)
	e.hash_next = s1.cached_includes_hash [h] 
	s1.cached_includes_hash [h]  = s1.nb_cached_includes
	return e
}

fn pragma_parse(s1 &TCCState)  {
	next_nomacro()
	if tok == Tcc_token.tok_push_macro || tok == Tcc_token.tok_pop_macro {
		t := tok
v := 0
		
		s := &Sym(0)
		if next() , tok != `(` {
		goto pragma_err // id: 0x7ffff20bf2d0
		}
		if next() , tok != 185 {
		goto pragma_err // id: 0x7ffff20bf2d0
		}
		v = tok_alloc(tokc.str.data, tokc.str.size - 1).tok
		if next() , tok != `)` {
		goto pragma_err // id: 0x7ffff20bf2d0
		}
		if t == Tcc_token.tok_push_macro {
			for (voidptr(0)) == (s = define_find(v)) {
			define_push(v, 0, (voidptr(0)), (voidptr(0)))
			}
			s.type_.ref = s
		}
		else {
			for s = define_stack ; s ; s = s.prev {
			if s.v == v && s.type_.ref == s {
				s.type_.ref = (voidptr(0))
				break
				
			}
			}
		}
		if s {
		table_ident [v - 256] .sym_define = if s.d{ s } else {(voidptr(0))}
		}
		else { // 3
		tcc_warning(c'unbalanced #pragma pop_macro')
}
		pp_debug_tok = t , v
		pp_debug_symv = pp_debug_tok = t
	}
	else if tok == Tcc_token.tok_once {
		search_cached_include(s1, file.filename, 1).once = pp_once
	}
	else if s1.output_type == 5 {
		unget_tok(` `)
		unget_tok(Tcc_token.tok_pragma)
		unget_tok(`#`)
		unget_tok(10)
	}
	else if tok == Tcc_token.tok_pack {
		next()
		skip(`(`)
		if tok == Tcc_token.tok_asm_pop {
			next()
			if s1.pack_stack_ptr <= s1.pack_stack {
				// RRRREG stk_error id=0x7ffff20c1378
				stk_error: 
				tcc_error(c'out of pack stack')
			}
			s1.pack_stack_ptr --
		}
		else {
			val := 0
			if tok != `)` {
				if tok == Tcc_token.tok_asm_push {
					next()
					if s1.pack_stack_ptr >= s1.pack_stack + 8 - 1 {
					goto stk_error // id: 0x7ffff20c1378
					}
					s1.pack_stack_ptr ++
					skip(`,`)
				}
				if tok != 181 {
				goto pragma_err // id: 0x7ffff20bf2d0
				}
				val = tokc.i
				if val < 1 || val > 16 || (val & (val - 1)) != 0 {
				goto pragma_err // id: 0x7ffff20bf2d0
				}
				next()
			}
			*s1.pack_stack_ptr = val
		}
		if tok != `)` {
		goto pragma_err // id: 0x7ffff20bf2d0
		}
	}
	else if tok == Tcc_token.tok_comment {
		p := &i8(0)
		t := 0
		next()
		skip(`(`)
		t = tok
		next()
		skip(`,`)
		if tok != 185 {
		goto pragma_err // id: 0x7ffff20bf2d0
		}
		p = tcc_strdup(&i8(tokc.str.data))
		next()
		if tok != `)` {
		goto pragma_err // id: 0x7ffff20bf2d0
		}
		if t == Tcc_token.tok_lib {
			dynarray_add(&s1.pragma_libs, &s1.nb_pragma_libs, p)
		}
		else {
			if t == Tcc_token.tok_option {
			tcc_set_options(s1, p)
			}
			tcc_free(p)
		}
	}
	else if s1.warn_unsupported {
		tcc_warning(c'#pragma %s is ignored', get_tok_str(tok, &tokc))
	}
	return 
	// RRRREG pragma_err id=0x7ffff20bf2d0
	pragma_err: 
	tcc_error(c'malformed #pragma directive')
	return 
}

fn preprocess(is_bof int)  {
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
	// RRRREG redo id=0x7ffff20cadf8
	redo: 
	match (tok) {
	 .tok_define{ // case comp body kind=BinaryOperator is_enum=true
	pp_debug_tok = tok
	next_nomacro()
	pp_debug_symv = tok
	parse_define()
	
	}
	 .tok_undef{ // case comp body kind=BinaryOperator is_enum=true
	pp_debug_tok = tok
	next_nomacro()
	pp_debug_symv = tok
	s = define_find(tok)
	if s {
	define_undef(s)
	}
	
	}
	 .tok_include, .tok_include_next{
	ch = file.buf_ptr [0] 
	skip_spaces()
	if ch == `<` {
		c = `>`
		goto read_name // id: 0x7ffff20c44b0
	}
	else if ch == `"` {
		c = ch
		// RRRREG read_name id=0x7ffff20c44b0
		read_name: 
		inp()
		q = buf
		for ch != c && ch != `\n` && ch != (-1) {
			if (q - buf) < sizeof(buf) - 1 {
			*q ++ = ch
			}
			if ch == `\\` {
				if handle_stray_noerror() == 0 {
				q --$
				}
			}
			else { // 3
			inp()
}
		}
		*q = ` `
		minp()
	}
	else {
		len := 0
		parse_flags = (1 | 4 | (parse_flags & 8))
		next()
		buf [0]  = ` `
		for tok != 10 {
			pstrcat(buf, sizeof(buf), get_tok_str(tok, &tokc))
			next()
		}
		len = C.strlen(buf)
		if (len < 2 || ((buf [0]  != `"` || buf [len - 1]  != `"`) && (buf [0]  != `<` || buf [len - 1]  != `>`))) {
		tcc_error(c"'#include' expects \"FILENAME\" or <FILENAME>")
		}
		c = buf [len - 1] 
		C.memmove(buf, buf + 1, len - 2)
		buf [len - 2]  = ` `
	}
	if s1.include_stack_ptr >= s1.include_stack + 32 {
	tcc_error(c'#include recursion too deep')
	}
	*s1.include_stack_ptr ++ = file
	i = if tok == Tcc_token.tok_include_next{ file.include_next_index } else {0}
	n = 2 + s1.nb_include_paths + s1.nb_sysinclude_paths
	for  ; i < n ; i ++ {
		buf1 := [1024]i8{}
		e := &CachedInclude(0)
		path := &i8(0)
		if i == 0 {
			if !(buf [0]  == `/`) {
			continue
			
			}
			buf1 [0]  = 0
		}
		else if i == 1 {
			if c != `"` {
			continue
			
			}
			path = file.truefilename
			pstrncpy(buf1, path, tcc_basename(path) - path)
		}
		else {
			j := i - 2
k := j - s1.nb_include_paths

			path = if k < 0{ s1.include_paths [j]  } else {s1.sysinclude_paths [k] }
			pstrcpy(buf1, sizeof(buf1), path)
			pstrcat(buf1, sizeof(buf1), c'/')
		}
		pstrcat(buf1, sizeof(buf1), buf)
		e = search_cached_include(s1, buf1, 0)
		if e && (define_find(e.ifndef_macro) || e.once == pp_once) {
			goto include_done // id: 0x7ffff20c8130
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
		ch = file.buf_ptr [0] 
		goto the_end // id: 0x7ffff20c8be0
	}
	tcc_error(c"include file '%s' not found", buf)
	// RRRREG include_done id=0x7ffff20c8130
	include_done: 
	s1.include_stack_ptr --$
	
	}
	 .tok_ifndef{ // case comp body kind=BinaryOperator is_enum=true
	c = 1
	goto do_ifdef // id: 0x7ffff20c8f70
	}
	 .tok_if{ // case comp body kind=BinaryOperator is_enum=true
	c = expr_preprocess()
	goto do_if // id: 0x7ffff20c90d0
	}
	 .tok_ifdef{ // case comp body kind=BinaryOperator is_enum=true
	c = 0
	// RRRREG do_ifdef id=0x7ffff20c8f70
	do_ifdef: 
	next_nomacro()
	if tok < 256 {
	tcc_error(c"invalid argument for '#if%sdef'", if c{ c'n' } else {c''})
	}
	if is_bof {
		if c {
			file.ifndef_macro = tok
		}
	}
	c = (define_find(tok) != 0) ^ c
	// RRRREG do_if id=0x7ffff20c90d0
	do_if: 
	if s1.ifdef_stack_ptr >= s1.ifdef_stack + 64 {
	tcc_error(c'memory full (ifdef)')
	}
	*s1.ifdef_stack_ptr ++ = c
	goto test_skip // id: 0x7ffff20c9b40
	}
	 .tok_else{ // case comp body kind=IfStmt is_enum=true
	if s1.ifdef_stack_ptr == s1.ifdef_stack {
	tcc_error(c'#else without matching #if')
	}
	if s1.ifdef_stack_ptr [-1]  & 2 {
	tcc_error(c'#else after #else')
	}
	c = (s1.ifdef_stack_ptr [-1]  ^= 3)
	goto test_else // id: 0x7ffff20ca1e8
	}
	 .tok_elif{ // case comp body kind=IfStmt is_enum=true
	if s1.ifdef_stack_ptr == s1.ifdef_stack {
	tcc_error(c'#elif without matching #if')
	}
	c = s1.ifdef_stack_ptr [-1] 
	if c > 1 {
	tcc_error(c'#elif after #else')
	}
	if c == 1 {
		c = 0
	}
	else {
		c = expr_preprocess()
		s1.ifdef_stack_ptr [-1]  = c
	}
	// RRRREG test_else id=0x7ffff20ca1e8
	test_else: 
	if s1.ifdef_stack_ptr == file.ifdef_stack_ptr + 1 {
	file.ifndef_macro = 0
	}
	// RRRREG test_skip id=0x7ffff20c9b40
	test_skip: 
	if !(c & 1) {
		preprocess_skip()
		is_bof = 0
		goto _GOTO_PLACEHOLDER_0x7ffff20cadf8 // id: 0x7ffff20cadf8
	}
	
	}
	 .tok_endif{ // case comp body kind=IfStmt is_enum=true
	if s1.ifdef_stack_ptr <= file.ifdef_stack_ptr {
	tcc_error(c'#endif without matching #if')
	}
	s1.ifdef_stack_ptr --
	if file.ifndef_macro && s1.ifdef_stack_ptr == file.ifdef_stack_ptr {
		file.ifndef_macro_saved = file.ifndef_macro
		file.ifndef_macro = 0
		for tok != 10 {
		next_nomacro()
		}
		tok_flags |= 4
		goto the_end // id: 0x7ffff20c8be0
	}
	
	}
	 190{ // case comp body kind=BinaryOperator is_enum=true
	n = strtoul(&i8(tokc.str.data), &q, 10)
	goto _line_num // id: 0x7ffff20cb998
	}
	 .tok_line{ // case comp body kind=CallExpr is_enum=true
	next()
	if tok != 181 {
	// RRRREG _line_err id=0x7ffff20cbc28
	_line_err: 
	tcc_error(c'wrong #line format')
	}
	n = tokc.i
	// RRRREG _line_num id=0x7ffff20cb998
	_line_num: 
	next()
	if tok != 10 {
		if tok == 185 {
			if file.truefilename == file.filename {
			file.truefilename = tcc_strdup(file.filename)
			}
			pstrcpy(file.filename, sizeof(file.filename), &i8(tokc.str.data))
		}
		else if parse_flags & 8 {
		
		}
		else { // 3
		goto _line_err // id: 0x7ffff20cbc28
		
}
		n --$
	}
	if file.fd > 0 {
	total_lines += file.line_num - n
	}
	file.line_num = n
	if s1.do_debug {
	put_stabs(file.filename, __stab_debug_code.n_bincl, 0, 0, 0)
	}
	
	}
	 .tok_error, .tok_warning{
	c = tok
	ch = file.buf_ptr [0] 
	skip_spaces()
	q = buf
	for ch != `\n` && ch != (-1) {
		if (q - buf) < sizeof(buf) - 1 {
		*q ++ = ch
		}
		if ch == `\\` {
			if handle_stray_noerror() == 0 {
			q --$
			}
		}
		else { // 3
		inp()
}
	}
	*q = ` `
	if c == Tcc_token.tok_error {
	tcc_error(c'#error %s', buf)
	}
	else { // 3
	tcc_warning(c'#warning %s', buf)
}
	
	}
	 .tok_pragma{ // case comp body kind=CallExpr is_enum=true
	pragma_parse(s1)
	
	}
	 10{ // case comp body kind=GotoStmt is_enum=true
	goto the_end // id: 0x7ffff20c8be0
	if tok == `!` && is_bof {
	goto ignore // id: 0x7ffff20cf9b0
	}
	tcc_warning(c'Ignoring unknown preprocessing directive #%s', get_tok_str(tok, &tokc))
	// RRRREG ignore id=0x7ffff20cf9b0
	ignore: 
	file.buf_ptr = parse_line_comment(file.buf_ptr - 1)
	goto the_end // id: 0x7ffff20c8be0
	}
	else {
	if saved_parse_flags & 8 {
	goto ignore // id: 0x7ffff20cf9b0
	}
	}
	}
	for tok != 10 {
	next_nomacro()
	}
	// RRRREG the_end id=0x7ffff20c8be0
	the_end: 
	parse_flags = saved_parse_flags
}

fn parse_escape_string(outstr &CString, buf &u8, is_long int)  {
	c := 0
	n := 0
	
	p := &u8(0)
	p = buf
	for  ;  ;  {
		c = *p
		if c == ` ` {
		break
		
		}
		if c == `\\` {
			p ++
			c = *p
			match c {
			 `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`{
			n = c - `0`
			p ++
			c = *p
			if isoct(c) {
				n = n * 8 + c - `0`
				p ++
				c = *p
				if isoct(c) {
					n = n * 8 + c - `0`
					p ++
				}
			}
			c = n
			goto add_char_nonext // id: 0x7ffff20d1690
			}
			 `x`, `u`, `U`{
			p ++
			n = 0
			for  ;  ;  {
				c = *p
				if c >= `a` && c <= `f` {
				c = c - `a` + 10
				}
				else if c >= `A` && c <= `F` {
				c = c - `A` + 10
				}
				else if isnum(c) {
				c = c - `0`
				}
				else { // 3
				
}
				n = n * 16 + c
				p ++
			}
			c = n
			goto add_char_nonext // id: 0x7ffff20d1690
			}
			 `a`{ // case comp body kind=BinaryOperator is_enum=false
			c = ``
			
			}
			 `b`{ // case comp body kind=BinaryOperator is_enum=false
			c = ``
			
			}
			 `f`{ // case comp body kind=BinaryOperator is_enum=false
			c = ``
			
			}
			 `n`{ // case comp body kind=BinaryOperator is_enum=false
			c = `\n`
			
			}
			 `r`{ // case comp body kind=BinaryOperator is_enum=false
			c = `\r`
			
			}
			 `t`{ // case comp body kind=BinaryOperator is_enum=false
			c = `	`
			
			}
			 `v`{ // case comp body kind=BinaryOperator is_enum=false
			c = ``
			
			}
			 `e`{ // case comp body kind=IfStmt is_enum=false
			if !gnu_ext {
			goto invalid_escape // id: 0x7ffff20d2720
			}
			c = 27
			
			}
			 `'`, `"`, `\\`, `?`{
			
			
			}
			else {
			// RRRREG invalid_escape id=0x7ffff20d2720
			invalid_escape: 
			if c >= `!` && c <= `~` {
			tcc_warning(c"unknown escape sequence: '\\%c'", c)
			}
			else { // 3
			tcc_warning(c"unknown escape sequence: '\\x%x'", c)
}
			}
			}
		}
		else if is_long && c >= 128 {
			cont := 0
			skip := 0
			i := 0
			if c < 194 {
				skip = 1
				goto invalid_utf8_sequence // id: 0x7ffff20d31e0
			}
			else if c <= 223 {
				cont = 1
				n = c & 31
			}
			else if c <= 239 {
				cont = 2
				n = c & 15
			}
			else if c <= 244 {
				cont = 3
				n = c & 7
			}
			else {
				skip = 1
				goto invalid_utf8_sequence // id: 0x7ffff20d31e0
			}
			for i = 1 ; i <= cont ; i ++ {
				l := 128
h := 191

				if i == 1 {
					match c {
					 224{ // case comp body kind=BinaryOperator is_enum=false
					l = 160
					
					}
					 237{ // case comp body kind=BinaryOperator is_enum=false
					h = 159
					
					}
					 240{ // case comp body kind=BinaryOperator is_enum=false
					l = 144
					
					}
					 244{ // case comp body kind=BinaryOperator is_enum=false
					h = 143
					
					}
					else{}
					}
				}
				if p [i]  < l || p [i]  > h {
					skip = i
					goto invalid_utf8_sequence // id: 0x7ffff20d31e0
				}
				n = (n << 6) | (p [i]  & 63)
			}
			p += 1 + cont
			c = n
			goto add_char_nonext // id: 0x7ffff20d1690
			// RRRREG invalid_utf8_sequence id=0x7ffff20d31e0
			invalid_utf8_sequence: 
			tcc_warning(c"ill-formed UTF-8 subsequence starting with: '\\x%x'", c)
			c = 65533
			p += skip
			goto add_char_nonext // id: 0x7ffff20d1690
		}
		p ++
		// RRRREG add_char_nonext id=0x7ffff20d1690
		add_char_nonext: 
		if !is_long {
		cstr_ccat(outstr, c)
		}
		else {
			cstr_wccat(outstr, c)
		}
	}
	if !is_long {
	cstr_ccat(outstr, ` `)
	}
	else { // 3
	cstr_wccat(outstr, ` `)
}
}

fn parse_string(s &i8, len int)  {
	buf := [1000]u8{}
	p := buf

	is_long := 0
	sep := 0
	
	if (is_long = *s == `L`) {
	s ++$ , len --$
	}
	sep = *s ++
	len -= 2
	if len >= sizeof(buf) {
	p = tcc_malloc(len + 1)
	}
	C.memcpy(p, s, len)
	p [len]  = 0
	cstr_reset(&tokcstr)
	parse_escape_string(&tokcstr, p, is_long)
	if p != buf {
	tcc_free(p)
	}
	if sep == `'` {
		char_size := 0
		i := 0
		n := 0
		c := 0
		
		if !is_long {
		tok = 179 , 1
		char_size = tok = 179
		}
		else { // 3
		tok = 180 , sizeof(Nwchar_t)
		char_size = tok = 180
}
		n = tokcstr.size / char_size - 1
		if n < 1 {
		tcc_error(c'empty character constant')
		}
		if n > 1 {
		tcc_warning(c'multi-character character constant')
		}
		for c = 0
		i = c ; i < n ; i ++ {
			if is_long {
			c = (&Nwchar_t(tokcstr.data)) [i] 
			}
			else { // 3
			c = (c << 8) | (&i8(tokcstr.data)) [i] 
}
		}
		tokc.i = c
	}
	else {
		tokc.str.size = tokcstr.size
		tokc.str.data = tokcstr.data
		if !is_long {
		tok = 185
		}
		else { // 3
		tok = 186
}
	}
}

fn bn_lshift(bn &u32, shift int, or_val int)  {
	i := 0
	v := u32(0)
	for i = 0 ; i < 2 ; i ++ {
		v = bn [i] 
		bn [i]  = (v << shift) | or_val
		or_val = v >> (32 - shift)
	}
}

fn bn_zero(bn &u32)  {
	i := 0
	for i = 0 ; i < 2 ; i ++ {
		bn [i]  = 0
	}
}

fn parse_number(p &i8)  {
	b := 0
	t := 0
	shift := 0
	frac_bits := 0
	s := 0
	exp_val := 0
	ch := 0
	
	q := &i8(0)
	bn := [2]u32{}
	d := 0.0
	q = token_buf
	ch = *p ++
	t = ch
	ch = *p ++
	*q ++ = t
	b = 10
	if t == `.` {
		goto float_frac_parse // id: 0x7ffff20d8dd0
	}
	else if t == `0` {
		if ch == `x` || ch == `X` {
			q --
			ch = *p ++
			b = 16
		}
		else if tcc_ext && (ch == `b` || ch == `B`) {
			q --
			ch = *p ++
			b = 2
		}
	}
	for 1 {
		if ch >= `a` && ch <= `f` {
		t = ch - `a` + 10
		}
		else if ch >= `A` && ch <= `F` {
		t = ch - `A` + 10
		}
		else if isnum(ch) {
		t = ch - `0`
		}
		else { // 3
		break
		
}
		if t >= b {
		break
		
		}
		if q >= token_buf + 1024 {
			// RRRREG num_too_long id=0x7ffff20d9d10
			num_too_long: 
			tcc_error(c'number too long')
		}
		*q ++ = ch
		ch = *p ++
	}
	if ch == `.` || ((ch == `e` || ch == `E`) && b == 10) || ((ch == `p` || ch == `P`) && (b == 16 || b == 2)) {
		if b != 10 {
			*q = ` `
			if b == 16 {
			shift = 4
			}
			else { // 3
			shift = 1
}
			bn_zero(bn)
			q = token_buf
			for 1 {
				t = *q ++
				if t == ` ` {
					break
					
				}
				else if t >= `a` {
					t = t - `a` + 10
				}
				else if t >= `A` {
					t = t - `A` + 10
				}
				else {
					t = t - `0`
				}
				bn_lshift(bn, shift, t)
			}
			frac_bits = 0
			if ch == `.` {
				ch = *p ++
				for 1 {
					t = ch
					if t >= `a` && t <= `f` {
						t = t - `a` + 10
					}
					else if t >= `A` && t <= `F` {
						t = t - `A` + 10
					}
					else if t >= `0` && t <= `9` {
						t = t - `0`
					}
					else {
						break
						
					}
					if t >= b {
					tcc_error(c'invalid digit')
					}
					bn_lshift(bn, shift, t)
					frac_bits += shift
					ch = *p ++
				}
			}
			if ch != `p` && ch != `P` {
			expect(c'exponent')
			}
			ch = *p ++
			s = 1
			exp_val = 0
			if ch == `+` {
				ch = *p ++
			}
			else if ch == `-` {
				s = -1
				ch = *p ++
			}
			if ch < `0` || ch > `9` {
			expect(c'exponent digits')
			}
			for ch >= `0` && ch <= `9` {
				exp_val = exp_val * 10 + ch - `0`
				ch = *p ++
			}
			exp_val = exp_val * s
			d = f64(bn [1] ) * 4294967296 + f64(bn [0] )
			d = ldexp(d, exp_val - frac_bits)
			t = toup(ch)
			if t == `F` {
				ch = *p ++
				tok = 187
				tokc.f = f32(d)
			}
			else if t == `L` {
				ch = *p ++
				tok = 189
				tokc.ld = f64(d)
			}
			else {
				tok = 188
				tokc.d = d
			}
		}
		else {
			if ch == `.` {
				if q >= token_buf + 1024 {
				goto num_too_long // id: 0x7ffff20d9d10
				}
				*q ++ = ch
				ch = *p ++
				// RRRREG float_frac_parse id=0x7ffff20d8dd0
				float_frac_parse: 
				for ch >= `0` && ch <= `9` {
					if q >= token_buf + 1024 {
					goto num_too_long // id: 0x7ffff20d9d10
					}
					*q ++ = ch
					ch = *p ++
				}
			}
			if ch == `e` || ch == `E` {
				if q >= token_buf + 1024 {
				goto num_too_long // id: 0x7ffff20d9d10
				}
				*q ++ = ch
				ch = *p ++
				if ch == `-` || ch == `+` {
					if q >= token_buf + 1024 {
					goto num_too_long // id: 0x7ffff20d9d10
					}
					*q ++ = ch
					ch = *p ++
				}
				if ch < `0` || ch > `9` {
				expect(c'exponent digits')
				}
				for ch >= `0` && ch <= `9` {
					if q >= token_buf + 1024 {
					goto num_too_long // id: 0x7ffff20d9d10
					}
					*q ++ = ch
					ch = *p ++
				}
			}
			*q = ` `
			t = toup(ch)
			(*__errno_location()) = 0
			if t == `F` {
				ch = *p ++
				tok = 187
				tokc.f = strtof(token_buf, (voidptr(0)))
			}
			else if t == `L` {
				ch = *p ++
				tok = 189
				tokc.ld = strtold(token_buf, (voidptr(0)))
			}
			else {
				tok = 188
				tokc.d = strtod(token_buf, (voidptr(0)))
			}
		}
	}
	else {
		n := i64(0)
		n1 := i64(0)
		
		lcount := 0
		ucount := 0
		ov := 0

		p1 := &i8(0)
		*q = ` `
		q = token_buf
		if b == 10 && *q == `0` {
			b = 8
			q ++
		}
		n = 0
		for 1 {
			t = *q ++
			if t == ` ` {
			break
			
			}
			else if t >= `a` {
			t = t - `a` + 10
			}
			else if t >= `A` {
			t = t - `A` + 10
			}
			else { // 3
			t = t - `0`
}
			if t >= b {
			tcc_error(c'invalid digit')
			}
			n1 = n
			n = n * b + t
			if n1 >= 1152921504606846976 && n / b != n1 {
			ov = 1
			}
		}
		lcount = 0
		ucount = lcount
		p1 = p
		for  ;  ;  {
			t = toup(ch)
			if t == `L` {
				if lcount >= 2 {
				tcc_error(c"three 'l's in integer constant")
				}
				if lcount && *(p - 1) != ch {
				tcc_error(c'incorrect integer suffix: %s', p1)
				}
				lcount ++
				ch = *p ++
			}
			else if t == `U` {
				if ucount >= 1 {
				tcc_error(c"two 'u's in integer constant")
				}
				ucount ++
				ch = *p ++
			}
			else {
				break
				
			}
		}
		if ucount == 0 && b == 10 {
			if lcount <= (8 == 4) {
				if n >= 2147483648 {
				lcount = (8 == 4) + 1
				}
			}
			if n >= 9223372036854775808 {
			ov = 1 , 1
			ucount = ov = 1
			}
		}
		else {
			if lcount <= (8 == 4) {
				if n >= 4294967296 {
				lcount = (8 == 4) + 1
				}
				else if n >= 2147483648 {
				ucount = 1
				}
			}
			if n >= 9223372036854775808 {
			ucount = 1
			}
		}
		if ov {
		tcc_warning(c'integer constant overflow')
		}
		tok = 181
		if lcount {
			tok = 206
			if lcount == 2 {
			tok = 183
			}
		}
		if ucount {
		tok ++$
		}
		tokc.i = n
	}
	if ch {
	tcc_error(c'invalid number\n')
	}
}

fn next_nomacro1()  {
	t := 0
	c := 0
	is_long := 0
	len := 0
	
	ts := &TokenSym(0)
	p := &u8(0)
	p1 := &u8(0)
	
	h := u32(0)
	p = file.buf_ptr
	// RRRREG redo_no_start id=0x7ffff20e2e98
	redo_no_start: 
	c = *p
	match c {
	 ` `, `	`{
	tok = c
	p ++
	if parse_flags & 16 {
	goto keep_tok_flags // id: 0x7ffff20e3140
	}
	for isidnum_table [*p - (-1)]  & 1 {
	p ++$
	}
	goto redo_no_start // id: 0x7ffff20e2e98
	}
	 ``, ``, `\r`{
	p ++
	goto redo_no_start // id: 0x7ffff20e2e98
	}
	 `\\`{ // case comp body kind=BinaryOperator is_enum=false
	c = handle_stray1(p)
	p = file.buf_ptr
	if c == `\\` {
	goto parse_simple // id: 0x7ffff20e3810
	}
	if c != (-1) {
	goto redo_no_start // id: 0x7ffff20e2e98
	}
	{
		s1 := tcc_state
		if (parse_flags & 4) && !(tok_flags & 8) {
			tok_flags |= 8
			tok = 10
			goto keep_tok_flags // id: 0x7ffff20e3140
		}
		else if !(parse_flags & 1) {
			tok = (-1)
		}
		else if s1.ifdef_stack_ptr != file.ifdef_stack_ptr {
			tcc_error(c'missing #endif')
		}
		else if s1.include_stack_ptr == s1.include_stack {
			tok = (-1)
		}
		else {
			tok_flags &= ~8
			if tok_flags & 4 {
				search_cached_include(s1, file.filename, 1).ifndef_macro = file.ifndef_macro_saved
				tok_flags &= ~4
			}
			if tcc_state.do_debug {
				put_stabd(__stab_debug_code.n_eincl, 0, 0)
			}
			tcc_close()
			s1.include_stack_ptr --
			p = file.buf_ptr
			if p == file.buffer {
			tok_flags = 2 | 1
			}
			goto redo_no_start // id: 0x7ffff20e2e98
		}
	}
	
	}
	 `\n`{ // case comp body kind=UnaryOperator is_enum=false
	file.line_num ++
	tok_flags |= 1
	p ++
	// RRRREG maybe_newline id=0x7ffff20e4ee0
	maybe_newline: 
	if 0 == (parse_flags & 4) {
	goto redo_no_start // id: 0x7ffff20e2e98
	}
	tok = 10
	goto keep_tok_flags // id: 0x7ffff20e3140
	}
	 `#`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if (tok_flags & 1) && (parse_flags & 1) {
		file.buf_ptr = p
		preprocess(tok_flags & 2)
		p = file.buf_ptr
		goto maybe_newline // id: 0x7ffff20e4ee0
	}
	else {
		if c == `#` {
			p ++
			tok = 202
		}
		else {
			if parse_flags & 8 {
				p = parse_line_comment(p - 1)
				goto redo_no_start // id: 0x7ffff20e2e98
			}
			else {
				tok = `#`
			}
		}
	}
	
	}
	 `$`{ // case comp body kind=IfStmt is_enum=false
	if !(isidnum_table [c - (-1)]  & 2) || (parse_flags & 8) {
	goto parse_simple // id: 0x7ffff20e3810
	}
	}
	 `a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`, `s`, `t`, `u`, `v`, `w`, `x`, `y`, `z`, `A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`, `I`, `J`, `K`, `M`, `N`, `O`, `P`, `Q`, `R`, `S`, `T`, `U`, `V`, `W`, `X`, `Y`, `Z`, `_`{
	// RRRREG parse_ident_fast id=0x7ffff20e7108
	parse_ident_fast: 
	p1 = p
	h = 1
	h = ((h) + ((h) << 5) + ((h) >> 27) + (c))
	for c = *p ++$ , isidnum_table [c - (-1)]  & (2 | 4) {
	h = ((h) + ((h) << 5) + ((h) >> 27) + (c))
	}
	len = p - p1
	if c != `\\` {
		pts := &&TokenSym(0)
		h &= (16384 - 1)
		pts = &hash_ident [h] 
		for  ;  ;  {
			ts = *pts
			if !ts {
			
			}
			if ts.len == len && !C.memcmp(ts.str, p1, len) {
			goto token_found // id: 0x7ffff20e8298
			}
			pts = &(ts.hash_next)
		}
		ts = tok_alloc_new(pts, &i8(p1), len)
		// RRRREG token_found id=0x7ffff20e8298
		token_found: 
	}
	else {
		cstr_reset(&tokcstr)
		cstr_cat(&tokcstr, &i8(p1), len)
		p --
		{
			p ++
			c = *p
			if c == `\\` {
				c = handle_stray1(p)
				p = file.buf_ptr
			}
		}
		0
		// RRRREG parse_ident_slow id=0x7ffff20e9298
		parse_ident_slow: 
		for isidnum_table [c - (-1)]  & (2 | 4) {
			cstr_ccat(&tokcstr, c)
			{
				p ++
				c = *p
				if c == `\\` {
					c = handle_stray1(p)
					p = file.buf_ptr
				}
			}
			0
		}
		ts = tok_alloc(tokcstr.data, tokcstr.size)
	}
	tok = ts.tok
	
	}
	 `L`{ // case comp body kind=BinaryOperator is_enum=false
	t = p [1] 
	if t != `\\` && t != `'` && t != `"` {
		goto parse_ident_fast // id: 0x7ffff20e7108
	}
	else {
		{
			p ++
			c = *p
			if c == `\\` {
				c = handle_stray1(p)
				p = file.buf_ptr
			}
		}
		0
		if c == `'` || c == `"` {
			is_long = 1
			goto str_const // id: 0x7ffff20e9dd0
		}
		else {
			cstr_reset(&tokcstr)
			cstr_ccat(&tokcstr, `L`)
			goto parse_ident_slow // id: 0x7ffff20e9298
		}
	}
	
	}
	 `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`{
	t = c
	{
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	// RRRREG parse_num id=0x7ffff20ea868
	parse_num: 
	cstr_reset(&tokcstr)
	for  ;  ;  {
		cstr_ccat(&tokcstr, t)
		if !((isidnum_table [c - (-1)]  & (2 | 4)) || c == `.` || ((c == `+` || c == `-`) && (((t == `e` || t == `E`) && !(parse_flags & 8 && (&i8(tokcstr.data)) [0]  == `0` && toup((&i8(tokcstr.data)) [1] ) == `X`)) || t == `p` || t == `P`))) {
		
		}
		t = c
		{
			p ++
			c = *p
			if c == `\\` {
				c = handle_stray1(p)
				p = file.buf_ptr
			}
		}
		0
	}
	cstr_ccat(&tokcstr, ` `)
	tokc.str.size = tokcstr.size
	tokc.str.data = tokcstr.data
	tok = 190
	
	}
	 `.`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if isnum(c) {
		t = `.`
		goto parse_num // id: 0x7ffff20ea868
	}
	else if (isidnum_table [`.` - (-1)]  & 2) && (isidnum_table [c - (-1)]  & (2 | 4)) {
		*p --$ = c = `.`
		goto parse_ident_fast // id: 0x7ffff20e7108
	}
	else if c == `.` {
		{
			p ++
			c = *p
			if c == `\\` {
				c = handle_stray1(p)
				p = file.buf_ptr
			}
		}
		0
		if c == `.` {
			p ++
			tok = 200
		}
		else {
			*p --$ = `.`
			tok = `.`
		}
	}
	else {
		tok = `.`
	}
	
	}
	 `'`, `"`{
	is_long = 0
	// RRRREG str_const id=0x7ffff20e9dd0
	str_const: 
	cstr_reset(&tokcstr)
	if is_long {
	cstr_ccat(&tokcstr, `L`)
	}
	cstr_ccat(&tokcstr, c)
	p = parse_pp_string(p, c, &tokcstr)
	cstr_ccat(&tokcstr, c)
	cstr_ccat(&tokcstr, ` `)
	tokc.str.size = tokcstr.size
	tokc.str.data = tokcstr.data
	tok = 191
	
	}
	 `<`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 158
	}
	else if c == `<` {
		{
			p ++
			c = *p
			if c == `\\` {
				c = handle_stray1(p)
				p = file.buf_ptr
			}
		}
		0
		if c == `=` {
			p ++
			tok = 129
		}
		else {
			tok = 1
		}
	}
	else {
		tok = 156
	}
	
	}
	 `>`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 157
	}
	else if c == `>` {
		{
			p ++
			c = *p
			if c == `\\` {
				c = handle_stray1(p)
				p = file.buf_ptr
			}
		}
		0
		if c == `=` {
			p ++
			tok = 130
		}
		else {
			tok = 2
		}
	}
	else {
		tok = 159
	}
	
	}
	 `&`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `&` {
		p ++
		tok = 160
	}
	else if c == `=` {
		p ++
		tok = 166
	}
	else {
		tok = `&`
	}
	
	}
	 `|`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `|` {
		p ++
		tok = 161
	}
	else if c == `=` {
		p ++
		tok = 252
	}
	else {
		tok = `|`
	}
	
	}
	 `+`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `+` {
		p ++
		tok = 164
	}
	else if c == `=` {
		p ++
		tok = 171
	}
	else {
		tok = `+`
	}
	
	}
	 `-`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `-` {
		p ++
		tok = 162
	}
	else if c == `=` {
		p ++
		tok = 173
	}
	else if c == `>` {
		p ++
		tok = 199
	}
	else {
		tok = `-`
	}
	
	}
	 `!`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 149
	}
	else {
		tok = `!`
	}
	
	}
	 `=`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 148
	}
	else {
		tok = `=`
	}
	
	}
	 `*`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 170
	}
	else {
		tok = `*`
	}
	
	}
	 `%`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 165
	}
	else {
		tok = `%`
	}
	
	}
	 `^`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `=` {
		p ++
		tok = 222
	}
	else {
		tok = `^`
	}
	
	}
	 `/`// case comp stmt
		p ++
		c = *p
		if c == `\\` {
			c = handle_stray1(p)
			p = file.buf_ptr
		}
	}
	0
	if c == `*` {
		p = parse_comment(p)
		tok = ` `
		goto keep_tok_flags // id: 0x7ffff20e3140
	}
	else if c == `/` {
		p = parse_line_comment(p)
		tok = ` `
		goto keep_tok_flags // id: 0x7ffff20e3140
	}
	else if c == `=` {
		p ++
		tok = 175
	}
	else {
		tok = `/`
	}
	
	}
	 `(`, `)`, `[`, `]`, `{`, `}`, `,`, `;`, `:`, `?`, `~`, `@`{
	// RRRREG parse_simple id=0x7ffff20e3810
	parse_simple: 
	tok = c
	p ++
	
	if parse_flags & 8 {
	goto parse_simple // id: 0x7ffff20e3810
	}
	tcc_error(c'unrecognized character \\x%02x', c)
	
	}
	else {
	if c >= 128 && c <= 255 {
	goto parse_ident_fast // id: 0x7ffff20e7108
	}
	}
	}
	tok_flags = 0
	// RRRREG keep_tok_flags id=0x7ffff20e3140
	keep_tok_flags: 
	file.buf_ptr = p
}

fn next_nomacro_spc()  {
	if macro_ptr {
		// RRRREG redo id=0x7ffff20f40d8
		redo: 
		tok = *macro_ptr
		if tok {
			tok_get(&tok, &macro_ptr, &tokc)
			if tok == 192 {
				file.line_num = tokc.i
				goto _GOTO_PLACEHOLDER_0x7ffff20f40d8 // id: 0x7ffff20f40d8
			}
		}
	}
	else {
		next_nomacro1()
	}
}

fn next_nomacro()  {
	for {
	next_nomacro_spc()
	// while()
	if ! (tok < 256 && (isidnum_table [tok - (-1)]  & 1) ) { break }
	}
}

fn macro_subst(tok_str &TokenString, nested_list &&Sym, macro_str &int) 

fn macro_arg_subst(nested_list &&Sym, macro_str &int, args &Sym) &int {
	t := 0
	t0 := 0
	t1 := 0
	spc := 0
	
	st := &int(0)
	s := &Sym(0)
	cval := CValue{}
	str := TokenString{}
	cstr := CString{}
	tok_str_new(&str)
	t0 = 0
	t1 = t0
	for 1 {
		tok_get(&t, &macro_str, &cval)
		if !t {
		break
		
		}
		if t == `#` {
			tok_get(&t, &macro_str, &cval)
			if !t {
			goto bad_stringy // id: 0x7ffff20f5980
			}
			s = sym_find2(args, t)
			if s {
				cstr_new(&cstr)
				cstr_ccat(&cstr, `"`)
				st = s.d
				spc = 0
				for *st >= 0 {
					tok_get(&t, &st, &cval)
					if t != 203 && t != 204 && 0 == check_space(t, &spc) {
						s := get_tok_str(t, &cval)
						for *s {
							if t == 191 && *s != `'` {
							add_char(&cstr, *s)
							}
							else { // 3
							cstr_ccat(&cstr, *s)
}
							s ++$
						}
					}
				}
				cstr.size -= spc
				cstr_ccat(&cstr, `"`)
				cstr_ccat(&cstr, ` `)
				cval.str.size = cstr.size
				cval.str.data = cstr.data
				tok_str_add2(&str, 191, &cval)
				cstr_free(&cstr)
			}
			else {
				// RRRREG bad_stringy id=0x7ffff20f5980
				bad_stringy: 
				expect(c"macro parameter after '#'")
			}
		}
		else if t >= 256 {
			s = sym_find2(args, t)
			if s {
				l0 := str.len
				st = s.d
				if *macro_str == 205 || t1 == 205 {
					if t1 == 205 && t0 == `,` && gnu_ext && s.type_.t {
						if *st <= 0 {
							str.len -= 2
						}
						else {
							str.len --
							goto add_var // id: 0x7ffff20ffa08
						}
					}
				}
				else {
					// RRRREG add_var id=0x7ffff20ffa08
					add_var: 
					if !s.next {
						str2 := TokenString{}
						sym_push2(&s.next, s.v, s.type_.t, 0)
						tok_str_new(&str2)
						macro_subst(&str2, nested_list, st)
						tok_str_add(&str2, 0)
						s.next.d = str2.str
					}
					st = s.next.d
				}
				for  ;  ;  {
					t2 := 0
					tok_get(&t2, &st, &cval)
					if t2 <= 0 {
					break
					
					}
					tok_str_add2(&str, t2, &cval)
				}
				if str.len == l0 {
				tok_str_add(&str, 203)
				}
			}
			else {
				tok_str_add(&str, t)
			}
		}
		else {
			tok_str_add2(&str, t, &cval)
		}
		t0 = t1 , t
		t1 = t0 = t1
	}
	tok_str_add(&str, 0)
	return str.str
}

[export:'ab_month_name']
const (
ab_month_name   = [c'Jan', c'Feb', c'Mar', c'Apr', c'May', c'Jun', c'Jul', c'Aug', c'Sep', c'Oct', c'Nov', c'Dec']!

)

fn paste_tokens(t1 int, v1 &CValue, t2 int, v2 &CValue) int {
	cstr := CString{}
	n := 0
	ret := 1

	cstr_new(&cstr)
	if t1 != 203 {
	cstr_cat(&cstr, get_tok_str(t1, v1), -1)
	}
	n = cstr.size
	if t2 != 203 {
	cstr_cat(&cstr, get_tok_str(t2, v2), -1)
	}
	cstr_ccat(&cstr, ` `)
	tcc_open_bf(tcc_state, c':paste:', cstr.size)
	C.memcpy(file.buffer, cstr.data, cstr.size)
	tok_flags = 0
	for  ;  ;  {
		next_nomacro1()
		if 0 == *file.buf_ptr {
		break
		
		}
		if is_space(tok) {
		continue
		
		}
		tcc_warning(c'pasting \"%.*s\" and \"%s\" does not give a valid preprocessing token', n, cstr.data, &i8(cstr.data) + n)
		ret = 0
		break
		
	}
	tcc_close()
	cstr_free(&cstr)
	return ret
}

fn macro_twosharps(ptr0 &int) &int {
	t := 0
	cval := CValue{}
	macro_str1 := TokenString{}
	start_of_nosubsts := -1
	ptr := &int(0)
	for ptr = ptr0 ;  ;  {
		tok_get(&t, &ptr, &cval)
		if t == 205 {
		break
		
		}
		if t == 0 {
		return (voidptr(0))
		}
	}
	tok_str_new(&macro_str1)
	for ptr = ptr0 ;  ;  {
		tok_get(&t, &ptr, &cval)
		if t == 0 {
		break
		
		}
		if t == 205 {
		continue
		
		}
		for *ptr == 205 {
			t1 := 0
			cv1 := CValue{}
			if start_of_nosubsts >= 0 {
			macro_str1.len = start_of_nosubsts
			}
			for (t1 = *ptr ++$) == 204 {
			0
			}
			if t1 && t1 != 205 {
				tok_get(&t1, &ptr, &cv1)
				if t != 203 || t1 != 203 {
					if paste_tokens(t, &cval, t1, &cv1) {
						t = tok , tokc
						cval = t = tok
					}
					else {
						tok_str_add2(&macro_str1, t, &cval)
						t = t1 , cv1
						cval = t = t1
					}
				}
			}
		}
		if t == 204 {
			if start_of_nosubsts < 0 {
			start_of_nosubsts = macro_str1.len
			}
		}
		else {
			start_of_nosubsts = -1
		}
		tok_str_add2(&macro_str1, t, &cval)
	}
	tok_str_add(&macro_str1, 0)
	return macro_str1.str
}

fn next_argstream(nested_list &&Sym, ws_str &TokenString) int {
	t := 0
	p := &int(0)
	sa := &Sym(0)
	for  ;  ;  {
		if macro_ptr {
			p = macro_ptr , *p
			t = p = macro_ptr
			if ws_str {
				for is_space(t) || 10 == t || 203 == t {
				tok_str_add(ws_str, t) , *p ++$
				t = tok_str_add(ws_str, t)
				}
			}
			if t == 0 {
				end_macro()
				sa = *nested_list
				for sa && sa.v == 0 {
				sa = sa.prev
				}
				if sa {
				sa.v = 0
				}
				continue
				
			}
		}
		else {
			ch = handle_eob()
			if ws_str {
				for is_space(ch) || ch == `\n` || ch == `/` {
					if ch == `/` {
						c := 0
						p := file.buf_ptr
						{
							p ++
							c = *p
							if c == `\\` {
								c = handle_stray1(p)
								p = file.buf_ptr
							}
						}
						0
						if c == `*` {
							p = parse_comment(p)
							file.buf_ptr = p - 1
						}
						else if c == `/` {
							p = parse_line_comment(p)
							file.buf_ptr = p - 1
						}
						else { // 3
						break
						
}
						ch = ` `
					}
					if ch == `\n` {
					file.line_num ++
					}
					if !(ch == `` || ch == `` || ch == `\r`) {
					tok_str_add(ws_str, ch)
					}
					minp()
				}
			}
			t = ch
		}
		if ws_str {
		return t
		}
		next_nomacro_spc()
		return tok
	}
}

fn macro_subst_tok(tok_str &TokenString, nested_list &&Sym, s &Sym) int {
	args := &Sym(0)
	sa := &Sym(0)
	sa1 := &Sym(0)
	
	parlevel := 0
	t := 0
	t1 := 0
	spc := 0
	
	str := TokenString{}
	cstrval := &i8(0)
	cval := CValue{}
	cstr := CString{}
	buf := [32]i8{}
	if tok == Tcc_token.tok___line__ || tok == Tcc_token.tok___counter__ {
		t = if tok == Tcc_token.tok___line__{ file.line_num } else {pp_counter ++}
		C.snprintf(buf, sizeof(buf), c'%d', t)
		cstrval = buf
		t1 = 190
		goto add_cstr1 // id: 0x7ffff2108188
	}
	else if tok == Tcc_token.tok___file__ {
		cstrval = file.filename
		goto add_cstr // id: 0x7ffff2108360
	}
	else if tok == Tcc_token.tok___date__ || tok == Tcc_token.tok___time__ {
		ti := Time_t{}
		tm := &Tm(0)
		time(&ti)
		tm = localtime(&ti)
		if tok == Tcc_token.tok___date__ {
			C.snprintf(buf, sizeof(buf), c'%s %2d %d', ab_month_name [tm.tm_mon] , tm.tm_mday, tm.tm_year + 1900)
		}
		else {
			C.snprintf(buf, sizeof(buf), c'%02d:%02d:%02d', tm.tm_hour, tm.tm_min, tm.tm_sec)
		}
		cstrval = buf
		// RRRREG add_cstr id=0x7ffff2108360
		add_cstr: 
		t1 = 185
		// RRRREG add_cstr1 id=0x7ffff2108188
		add_cstr1: 
		cstr_new(&cstr)
		cstr_cat(&cstr, cstrval, 0)
		cval.str.size = cstr.size
		cval.str.data = cstr.data
		tok_str_add2(tok_str, t1, &cval)
		cstr_free(&cstr)
	}
	else if s.d {
		saved_parse_flags := parse_flags
		joined_str := (voidptr(0))
		mstr := s.d
		if s.type_.t == 1 {
			ws_str := TokenString{}
			tok_str_new(&ws_str)
			spc = 0
			parse_flags |= 16 | 4 | 32
			t = next_argstream(nested_list, &ws_str)
			if t != `(` {
				parse_flags = saved_parse_flags
				tok_str_add(tok_str, tok)
				if parse_flags & 16 {
					i := 0
					for i = 0 ; i < ws_str.len ; i ++ {
					tok_str_add(tok_str, ws_str.str [i] )
					}
				}
				tok_str_free_str(ws_str.str)
				return 0
			}
			else {
				tok_str_free_str(ws_str.str)
			}
			for {
			next_nomacro()
			// while()
			if ! (tok == 203 ) { break }
			}
			args = (voidptr(0))
			sa = s.next
			for  ;  ;  {
				for {
				next_argstream(nested_list, (voidptr(0)))
				// while()
				if ! (is_space(tok) || 10 == tok ) { break }
				}
				// RRRREG empty_arg id=0x7ffff210b030
				empty_arg: 
				if !args && !sa && tok == `)` {
				break
				
				}
				if !sa {
				tcc_error(c"macro '%s' used with too many args", get_tok_str(s.v, 0))
				}
				tok_str_new(&str)
				parlevel = 0
				spc = parlevel
				for (parlevel > 0 || (tok != `)` && (tok != `,` || sa.type_.t))) {
					if tok == (-1) || tok == 0 {
					break
					
					}
					if tok == `(` {
					parlevel ++
					}
					else if tok == `)` {
					parlevel --
					}
					if tok == 10 {
					tok = ` `
					}
					if !check_space(tok, &spc) {
					tok_str_add2(&str, tok, &tokc)
					}
					next_argstream(nested_list, (voidptr(0)))
				}
				if parlevel {
				expect(c')')
				}
				str.len -= spc
				tok_str_add(&str, -1)
				tok_str_add(&str, 0)
				sa1 = sym_push2(&args, sa.v & ~536870912, sa.type_.t, 0)
				sa1.d = str.str
				sa = sa.next
				if tok == `)` {
					if sa && sa.type_.t && gnu_ext {
					goto empty_arg // id: 0x7ffff210b030
					}
					break
					
				}
				if tok != `,` {
				expect(c',')
				}
			}
			if sa {
				tcc_error(c"macro '%s' used with too few args", get_tok_str(s.v, 0))
			}
			parse_flags = saved_parse_flags
			mstr = macro_arg_subst(nested_list, mstr, args)
			sa = args
			for sa {
				sa1 = sa.prev
				tok_str_free_str(sa.d)
				if sa.next {
					tok_str_free_str(sa.next.d)
					sym_free(sa.next)
				}
				sym_free(sa)
				sa = sa1
			}
		}
		sym_push2(nested_list, s.v, 0, 0)
		parse_flags = saved_parse_flags
		joined_str = macro_twosharps(mstr)
		macro_subst(tok_str, nested_list, if joined_str{ joined_str } else {mstr})
		sa1 = *nested_list
		*nested_list = sa1.prev
		sym_free(sa1)
		if joined_str {
		tok_str_free_str(joined_str)
		}
		if mstr != s.d {
		tok_str_free_str(mstr)
		}
	}
	return 0
}

fn macro_subst(tok_str &TokenString, nested_list &&Sym, macro_str &int)  {
	s := &Sym(0)
	t := 0
	spc := 0
	nosubst := 0
	
	cval := CValue{}
	spc = 0
	nosubst = spc
	for 1 {
		tok_get(&t, &macro_str, &cval)
		if t <= 0 {
		break
		
		}
		if t >= 256 && 0 == nosubst {
			s = define_find(t)
			if s == (voidptr(0)) {
			goto no_subst // id: 0x7ffff210eeb0
			}
			if sym_find2(*nested_list, t) {
				tok_str_add2(tok_str, 204, (voidptr(0)))
				goto no_subst // id: 0x7ffff210eeb0
			}
			{
				str := tok_str_alloc()
				str.str = &int(macro_str)
				begin_macro(str, 2)
				tok = t
				macro_subst_tok(tok_str, nested_list, s)
				if macro_stack != str {
					break
					
				}
				macro_str = macro_ptr
				end_macro()
			}
			if tok_str.len {
			spc = is_space(t = tok_str.str [tok_str.lastlen] )
			}
		}
		else {
			if t == `\\` && !(parse_flags & 32) {
			tcc_error(c"stray '\\' in program")
			}
			// RRRREG no_subst id=0x7ffff210eeb0
			no_subst: 
			if !check_space(t, &spc) {
			tok_str_add2(tok_str, t, &cval)
			}
			if nosubst {
				if nosubst > 1 && (spc || (nosubst ++$ == 3 && t == `(`)) {
				continue
				
				}
				nosubst = 0
			}
			if t == 204 {
			nosubst = 1
			}
		}
		if t == Tcc_token.tok_defined && pp_expr {
		nosubst = 2
		}
	}
}

fn next()  {
	if tcc_state.do_debug {
	tcc_debug_line(tcc_state)
	}
	// RRRREG redo id=0x7ffff2110a10
	redo: 
	if parse_flags & 16 {
	next_nomacro_spc()
	}
	else { // 3
	next_nomacro()
}
	if macro_ptr {
		if tok == 204 || tok == 203 {
			goto redo // id: 0x7ffff2110a10
		}
		else if tok == 0 {
			end_macro()
			goto redo // id: 0x7ffff2110a10
		}
	}
	else if tok >= 256 && (parse_flags & 1) {
		s := &Sym(0)
		s = define_find(tok)
		if s {
			nested_list := (voidptr(0))
			tokstr_buf.len = 0
			macro_subst_tok(&tokstr_buf, &nested_list, s)
			tok_str_add(&tokstr_buf, 0)
			begin_macro(&tokstr_buf, 0)
			goto redo // id: 0x7ffff2110a10
		}
	}
	if tok == 190 {
		if parse_flags & 2 {
		parse_number(&i8(tokc.str.data))
		}
	}
	else if tok == 191 {
		if parse_flags & 64 {
		parse_string(&i8(tokc.str.data), tokc.str.size - 1)
		}
	}
}

fn unget_tok(last_tok int)  {
	str := tok_str_alloc()
	tok_str_add2(str, tok, &tokc)
	tok_str_add(str, 0)
	begin_macro(str, 1)
	tok = last_tok
}

fn preprocess_start(s1 &TCCState, is_asm int)  {
	cstr := CString{}
	i := 0
	s1.include_stack_ptr = s1.include_stack
	s1.ifdef_stack_ptr = s1.ifdef_stack
	file.ifdef_stack_ptr = s1.ifdef_stack_ptr
	pp_expr = 0
	pp_counter = 0
	pp_debug_tok = 0
	pp_debug_symv = pp_debug_tok
	pp_once ++
	pvtop = (__vstack + 1) - 1
	vtop = pvtop
	C.memset(vtop, 0, sizeof*vtop)
	s1.pack_stack [0]  = 0
	s1.pack_stack_ptr = s1.pack_stack
	set_idnum(`$`, if s1.dollars_in_identifiers{ 2 } else {0})
	set_idnum(`.`, if is_asm{ 2 } else {0})
	cstr_new(&cstr)
	cstr_cat(&cstr, c'\"', -1)
	cstr_cat(&cstr, file.filename, -1)
	cstr_cat(&cstr, c'\"', 0)
	tcc_define_symbol(s1, c'__BASE_FILE__', cstr.data)
	cstr_reset(&cstr)
	for i = 0 ; i < s1.nb_cmd_include_files ; i ++ {
		cstr_cat(&cstr, c'#include \"', -1)
		cstr_cat(&cstr, s1.cmd_include_files [i] , -1)
		cstr_cat(&cstr, c'\"\n', -1)
	}
	if cstr.size {
		*s1.include_stack_ptr ++ = file
		tcc_open_bf(s1, c'<command line>', cstr.size)
		C.memcpy(file.buffer, cstr.data, cstr.size)
	}
	cstr_free(&cstr)
	if is_asm {
	tcc_define_symbol(s1, c'__ASSEMBLER__', (voidptr(0)))
	}
	parse_flags = if is_asm{ 8 } else {0}
	tok_flags = 1 | 2
}

fn preprocess_end(s1 &TCCState)  {
	for macro_stack {
	end_macro()
	}
	macro_ptr = (voidptr(0))
}

fn tccpp_new(s &TCCState)  {
	i := 0
	c := 0
	
	p := &i8(0)
	r := &i8(0)
	
	s.include_stack_ptr = s.include_stack
	s.ppfp = C.stdout
	for i = (-1) ; i < 128 ; i ++ {
	set_idnum(i, if is_space(i){ 1 } else {if isid(i){ 2 } else {if isnum(i){ 4 } else {0}}})
	}
	for i = 128 ; i < 256 ; i ++ {
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
		for  ;  ;  {
			c = *r ++
			if c == ` ` {
			break
			
			}
		}
		tok_alloc(p, r - p - 1)
		p = r
	}
}

fn tccpp_delete(s &TCCState)  {
	i := 0
	n := 0
	
	free_defines((voidptr(0)))
	n = tok_ident - 256
	for i = 0 ; i < n ; i ++ {
	tal_free_impl(toksym_alloc, table_ident [i] )
	}
	tcc_free(table_ident)
	table_ident = (voidptr(0))
	cstr_free(&tokcstr)
	cstr_free(&cstr_buf)
	cstr_free(&macro_equal_buf)
	tok_str_free_str(tokstr_buf.str)
	tal_delete(toksym_alloc)
	toksym_alloc = (voidptr(0))
	tal_delete(tokstr_alloc)
	tokstr_alloc = (voidptr(0))
	tal_delete(cstr_alloc)
	cstr_alloc = (voidptr(0))
}

fn tok_print(msg &i8, str &int)  {
	fp := &C.FILE(0)
	t := 0
	s := 0

	cval := CValue{}
	fp = tcc_state.ppfp
	C.fprintf(fp, c'%s', msg)
	for str {
		tok_get(&t, &str, &cval)
		if !t {
		break
		
		}
		C.fprintf(fp, c' %s' + s, get_tok_str(t, &cval)) , 1
		s = C.fprintf(fp, c' %s' + s, get_tok_str(t, &cval))
	}
	C.fprintf(fp, c'\n')
}

fn pp_line(s1 &TCCState, f &BufferedFile, level int)  {
	d := f.line_num - f.line_ref
	if s1.dflag & 4 {
	return 
	}
	if s1.Pflag == line_macro_output_format_none {
		0
	}
	else if level == 0 && f.line_ref && d < 8 {
		for d > 0 {
		fputs(c'\n', s1.ppfp) , d --$
		}
	}
	else if s1.Pflag == line_macro_output_format_std {
		C.fprintf(s1.ppfp, c'#line %d \"%s\"\n', f.line_num, f.filename)
	}
	else {
		C.fprintf(s1.ppfp, c'# %d \"%s\"%s\n', f.line_num, f.filename, if level > 0{ c' 1' } else {if level < 0{ c' 2' } else {c''}})
	}
	f.line_ref = f.line_num
}

fn define_print(s1 &TCCState, v int)  {
	fp := &C.FILE(0)
	s := &Sym(0)
	s = define_find(v)
	if (voidptr(0)) == s || (voidptr(0)) == s.d {
	return 
	}
	fp = s1.ppfp
	C.fprintf(fp, c'#define %s', get_tok_str(v, (voidptr(0))))
	if s.type_.t == 1 {
		a := s.next
		C.fprintf(fp, c'(')
		if a {
		for  ;  ;  {
			C.fprintf(fp, c'%s', get_tok_str(a.v & ~536870912, (voidptr(0))))
			if !(a = a.next) {
			break
			
			}
			C.fprintf(fp, c',')
		}
		}
		C.fprintf(fp, c')')
	}
	tok_print(c'', s.d)
}

fn pp_debug_defines(s1 &TCCState)  {
	v := 0
	t := 0
	
	vs := &i8(0)
	fp := &C.FILE(0)
	t = pp_debug_tok
	if t == 0 {
	return 
	}
	file.line_num --
	pp_line(s1, file, 0)
	file.line_ref = file.line_num ++$
	fp = s1.ppfp
	v = pp_debug_symv
	vs = get_tok_str(v, (voidptr(0)))
	if t == Tcc_token.tok_define {
		define_print(s1, v)
	}
	else if t == Tcc_token.tok_undef {
		C.fprintf(fp, c'#undef %s\n', vs)
	}
	else if t == Tcc_token.tok_push_macro {
		C.fprintf(fp, c'#pragma push_macro(\"%s\")\n', vs)
	}
	else if t == Tcc_token.tok_pop_macro {
		C.fprintf(fp, c'#pragma pop_macro(\"%s\")\n', vs)
	}
	pp_debug_tok = 0
}

fn pp_debug_builtins(s1 &TCCState)  {
	v := 0
	for v = 256 ; v < tok_ident ; v ++ {
	define_print(s1, v)
	}
}

fn pp_need_space(a int, b int) int {
	return if `E` == a{ `+` == b || `-` == b } else {if `+` == a{ 164 == b || `+` == b } else {if `-` == a{ 162 == b || `-` == b } else {if a >= 256{ b >= 256 } else {if a == 190{ b >= 256 } else {0}}}}}
}

[c:'pp_check_he0xE']
fn pp_check_he0xe(t int, p &i8) int {
	if t == 190 && toup(C.strchr(p, 0) [-1] ) == `E` {
	return `E`
	}
	return t
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
	parse_flags |= 2 , 1
	s1.Pflag = parse_flags |= 2
	}
	if s1.dflag & 1 {
		pp_debug_builtins(s1)
		s1.dflag &= ~1
	}
	token_seen = 10 , 0
	spcs = token_seen = 10
	pp_line(s1, file, 0)
	for  ;  ;  {
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
			white [spcs ++]  = tok
			}
			continue
			
		}
		else if tok == 10 {
			spcs = 0
			if token_seen == 10 {
			continue
			
			}
			file.line_ref ++$
		}
		else if token_seen == 10 {
			pp_line(s1, file, 0)
		}
		else if spcs == 0 && pp_need_space(token_seen, tok) {
			white [spcs ++]  = ` `
		}
		white [spcs]  = 0 , fputs(white, s1.ppfp) , 0
		spcs = white [spcs]  = 0 , fputs(white, s1.ppfp)
		fputs(p = get_tok_str(tok, &tokc), s1.ppfp)
		token_seen = pp_check_he0xe(tok, p)
	}
	return 0
}

