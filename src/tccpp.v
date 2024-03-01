@[translated]
module main

import strings

#include <math.h>
#include <time.h>

const STRING_MAX_SIZE = 1024
const TOK_HASH_SIZE = 16384 // must be a power of two

const ch_eob = `\\`
const ch_eof = -1

const tok_eof = -1

__global table_ident = &&TokenSym(0)
__global tok_ident = int(0)

__global tok = int(0)
__global tok_flags = int(0)
__global tokc = CValue{}
__global macro_ptr = &int(0)
__global parse_flags = int(0)

__global isidnum_table = [256 - CH_EOF]u8{}

__global toksym_alloc = &TinyAlloc(0)
__global tokstr_alloc = &TinyAlloc(0)

__global tokstr_buf = TokenString{}

__global cstr_buf = strings.new_builder(100)

__global hash_ident = &[TOK_HASH_SIZE]TokenSym{}
__global token_buf = [STRING_MAX_SIZE + 1]char{}
__global macro_stack = &TokenString(0)

__global pp_expr = int(0)
__global pp_counter = int(0)
__global pp_debug_tok = int(0)
__global pp_debug_symv = int(0)

fn C.ldexp(f64, int) f64
fn C.strtof(&char, &char) f64
fn C.strtold(&char, &&char) f64
fn C.strtod(&char, &&char) f64
fn C.time(&C.time_t) C.time_t
fn C.localtime(&C.time_t) C.tm

//@[typedef]
// struct C.time_t {}
type time_t = u64 // C.time_t

struct C.tm {
	tm_sec   int
	tm_min   int
	tm_hour  int
	tm_mday  int
	tm_mon   int
	tm_year  int
	tm_wday  int
	tm_yday  int
	tm_isdst int
}

__global tcc_keywords = ['int', 'void', 'char', 'if', 'else', 'while', 'break', 'return', 'for',
	'extern', 'static', 'unsigned', 'goto', 'do', 'continue', 'switch', 'case', '_Atomic', 'const',
	'__const', '__const__', 'volatile', '__volatile', '__volatile__', 'long', 'register', 'signed',
	'__signed', '__signed__', 'auto', 'inline', '__inline', '__inline__', 'restrict', '__restrict',
	'__restrict__', '__extension__', '_Thread_local', '_Generic', '_Static_assert', 'float', 'double',
	'_Bool', '_Complex', 'short', 'struct', 'union', 'typedef', 'default', 'enum', 'sizeof',
	'__attribute', '__attribute__', '__alignof', '__alignof__', '_Alignof', '_Alignas', 'typeof',
	'__typeof', '__typeof__', '__label__', 'asm', '__asm', '__asm__', 'define', 'include',
	'include_next', 'ifdef', 'ifndef', 'elif', 'endif', 'defined', 'undef', 'error', 'warning',
	'line', 'pragma', '__LINE__', '__FILE__', '__DATE__', '__TIME__', '__FUNCTION__', '__VA_ARGS__',
	'__COUNTER__', '__has_include', '__has_include_next', '__func__', '__nan__', '__snan__',
	'__inf__', '__mzerosf', '__mzerodf', 'section', '__section__', 'aligned', '__aligned__', 'packed',
	'__packed__', 'weak', '__weak__', 'alias', '__alias__', 'unused', '__unused__', 'nodebug',
	'__nodebug__', 'cdecl', '__cdecl', '__cdecl__', 'stdcall', '__stdcall', '__stdcall__', 'fastcall',
	'__fastcall', '__fastcall__', 'regparm', '__regparm__', 'cleanup', '__cleanup__', 'constructor',
	'__constructor__', 'destructor', '__destructor__', 'always_inline', '__always_inline__',
	'__mode__', '__QI__', '__DI__', '__HI__', '__SI__', '__word__', 'dllexport', 'dllimport',
	'nodecorate', 'noreturn', '__noreturn__', '_Noreturn', 'visibility', '__visibility__',
	'__builtin_types_compatible_p', '__builtin_choose_expr', '__builtin_constant_p',
	'__builtin_frame_address', '__builtin_return_address', '__builtin_expect',
	'__builtin_va_arg_types', '__atomic_store', '__atomic_load', '__atomic_exchange',
	'__atomic_compare_exchange', '__atomic_fetch_add', '__atomic_fetch_sub', '__atomic_fetch_or',
	'__atomic_fetch_xor', '__atomic_fetch_and', '__atomic_fetch_nand', '__atomic_add_fetch',
	'__atomic_sub_fetch', '__atomic_or_fetch', '__atomic_xor_fetch', '__atomic_and_fetch',
	'__atomic_nand_fetch', 'pack', 'comment', 'lib', 'push_macro', 'pop_macro', 'once', 'option',
	'memcpy', 'memmove', 'memset', '__divdi3', '__moddi3', '__udivdi3', '__umoddi3', '__ashrdi3',
	'__lshrdi3', '__ashldi3', '__floatundisf', '__floatundidf', '__floatundixf', '__fixunsxfdi',
	'__fixunssfdi', '__fixunsdfdi', 'alloca', '__bound_ptr_add', '__bound_ptr_indir1',
	'__bound_ptr_indir2', '__bound_ptr_indir4', '__bound_ptr_indir8', '__bound_ptr_indir12',
	'__bound_ptr_indir16', '__bound_main_arg', '__bound_local_new', '__bound_local_delete',
	'__bound_setjmp', '__bound_longjmp', '__bound_new_region', 'sigsetjmp', '__sigsetjmp',
	'siglongjmp', 'setjmp', '_setjmp', 'longjmp', '.byte', '.word', '.align', '.balign', '.p2align',
	'.set', '.skip', '.space', '.string', '.asciz', '.ascii', '.file', '.globl', '.global', '.weak',
	'.hidden', '.ident', '.size', '.type', '.text', '.data', '.bss', '.previous', '.pushsection',
	'.popsection', '.fill', '.rept', '.endr', '.org', '.quad', '.code64', '.short', '.long', '.int',
	'.section', 'al', 'cl', 'dl', 'bl', 'ah', 'ch', 'dh', 'bh', 'ax', 'cx', 'dx', 'bx', 'sp', 'bp',
	'si', 'di', 'eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi', 'rax', 'rcx', 'rdx', 'rbx',
	'rsp', 'rbp', 'rsi', 'rdi', 'mm0', 'mm1', 'mm2', 'mm3', 'mm4', 'mm5', 'mm6', 'mm7', 'xmm0',
	'xmm1', 'xmm2', 'xmm3', 'xmm4', 'xmm5', 'xmm6', 'xmm7', 'cr0', 'cr1', 'cr2', 'cr3', 'cr4',
	'cr5', 'cr6', 'cr7', 'tr0', 'tr1', 'tr2', 'tr3', 'tr4', 'tr5', 'tr6', 'tr7', 'db0', 'db1',
	'db2', 'db3', 'db4', 'db5', 'db6', 'db7', 'dr0', 'dr1', 'dr2', 'dr3', 'dr4', 'dr5', 'dr6',
	'dr7', 'es', 'cs', 'ss', 'ds', 'fs', 'gs', 'st', 'rip', 'spl', 'bpl', 'sil', 'dil', 'movb',
	'movw', 'movl', 'movq', 'mov', 'addb', 'addw', 'addl', 'addq', 'add', 'orb', 'orw', 'orl',
	'orq', 'or', 'adcb', 'adcw', 'adcl', 'adcq', 'adc', 'sbbb', 'sbbw', 'sbbl', 'sbbq', 'sbb',
	'andb', 'andw', 'andl', 'andq', 'and', 'subb', 'subw', 'subl', 'subq', 'sub', 'xorb', 'xorw',
	'xorl', 'xorq', 'xor', 'cmpb', 'cmpw', 'cmpl', 'cmpq', 'cmp', 'incb', 'incw', 'incl', 'incq',
	'inc', 'decb', 'decw', 'decl', 'decq', 'dec', 'notb', 'notw', 'notl', 'notq', 'not', 'negb',
	'negw', 'negl', 'negq', 'neg', 'mulb', 'mulw', 'mull', 'mulq', 'mul', 'imulb', 'imulw', 'imull',
	'imulq', 'imul', 'divb', 'divw', 'divl', 'divq', 'div', 'idivb', 'idivw', 'idivl', 'idivq',
	'idiv', 'xchgb', 'xchgw', 'xchgl', 'xchgq', 'xchg', 'testb', 'testw', 'testl', 'testq', 'test',
	'rolb', 'rolw', 'roll', 'rolq', 'rol', 'rorb', 'rorw', 'rorl', 'rorq', 'ror', 'rclb', 'rclw',
	'rcll', 'rclq', 'rcl', 'rcrb', 'rcrw', 'rcrl', 'rcrq', 'rcr', 'shlb', 'shlw', 'shll', 'shlq',
	'shl', 'shrb', 'shrw', 'shrl', 'shrq', 'shr', 'sarb', 'sarw', 'sarl', 'sarq', 'sar', 'shldw',
	'shldl', 'shldq', 'shld', 'shrdw', 'shrdl', 'shrdq', 'shrd', 'pushw', 'pushl', 'pushq', 'push',
	'popw', 'popl', 'popq', 'pop', 'inb', 'inw', 'inl', 'in', 'outb', 'outw', 'outl', 'out', 'movzbw',
	'movzbl', 'movzbq', 'movzb', 'movzwl', 'movsbw', 'movsbl', 'movswl', 'movsbq', 'movswq', 'movzwq',
	'movslq', 'leaw', 'leal', 'leaq', 'lea', 'les', 'lds', 'lss', 'lfs', 'lgs', 'call', 'jmp',
	'lcall', 'ljmp', 'jo', 'jno', 'jb', 'jc', 'jnae', 'jnb', 'jnc', 'jae', 'je', 'jz', 'jne', 'jnz',
	'jbe', 'jna', 'jnbe', 'ja', 'js', 'jns', 'jp', 'jpe', 'jnp', 'jpo', 'jl', 'jnge', 'jnl', 'jge',
	'jle', 'jng', 'jnle', 'jg', 'seto', 'setno', 'setb', 'setc', 'setnae', 'setnb', 'setnc', 'setae',
	'sete', 'setz', 'setne', 'setnz', 'setbe', 'setna', 'setnbe', 'seta', 'sets', 'setns', 'setp',
	'setpe', 'setnp', 'setpo', 'setl', 'setnge', 'setnl', 'setge', 'setle', 'setng', 'setnle',
	'setg', 'setob', 'setnob', 'setbb', 'setcb', 'setnaeb', 'setnbb', 'setncb', 'setaeb', 'seteb',
	'setzb', 'setneb', 'setnzb', 'setbeb', 'setnab', 'setnbeb', 'setab', 'setsb', 'setnsb', 'setpb',
	'setpeb', 'setnpb', 'setpob', 'setlb', 'setngeb', 'setnlb', 'setgeb', 'setleb', 'setngb',
	'setnleb', 'setgb', 'cmovo', 'cmovno', 'cmovb', 'cmovc', 'cmovnae', 'cmovnb', 'cmovnc', 'cmovae',
	'cmove', 'cmovz', 'cmovne', 'cmovnz', 'cmovbe', 'cmovna', 'cmovnbe', 'cmova', 'cmovs', 'cmovns',
	'cmovp', 'cmovpe', 'cmovnp', 'cmovpo', 'cmovl', 'cmovnge', 'cmovnl', 'cmovge', 'cmovle', 'cmovng',
	'cmovnle', 'cmovg', 'bsfw', 'bsfl', 'bsfq', 'bsf', 'bsrw', 'bsrl', 'bsrq', 'bsr', 'btw', 'btl',
	'btq', 'bt', 'btsw', 'btsl', 'btsq', 'bts', 'btrw', 'btrl', 'btrq', 'btr', 'btcw', 'btcl',
	'btcq', 'btc', 'popcntw', 'popcntl', 'popcntq', 'popcnt', 'tzcntw', 'tzcntl', 'tzcntq', 'tzcnt',
	'lzcntw', 'lzcntl', 'lzcntq', 'lzcnt', 'larw', 'larl', 'larq', 'lar', 'lslw', 'lsll', 'lslq',
	'lsl', 'fadd', 'faddp', 'fadds', 'fiaddl', 'faddl', 'fiadds', 'fmul', 'fmulp', 'fmuls', 'fimull',
	'fmull', 'fimuls', 'fcom', 'fcom_1', 'fcoms', 'ficoml', 'fcoml', 'ficoms', 'fcomp', 'fcompp',
	'fcomps', 'ficompl', 'fcompl', 'ficomps', 'fsub', 'fsubp', 'fsubs', 'fisubl', 'fsubl', 'fisubs',
	'fsubr', 'fsubrp', 'fsubrs', 'fisubrl', 'fsubrl', 'fisubrs', 'fdiv', 'fdivp', 'fdivs', 'fidivl',
	'fdivl', 'fidivs', 'fdivr', 'fdivrp', 'fdivrs', 'fidivrl', 'fdivrl', 'fidivrs', 'xaddb', 'xaddw',
	'xaddl', 'xaddq', 'xadd', 'cmpxchgb', 'cmpxchgw', 'cmpxchgl', 'cmpxchgq', 'cmpxchg', 'cmpsb',
	'cmpsw', 'cmpsl', 'cmpsq', 'cmps', 'scmpb', 'scmpw', 'scmpl', 'scmpq', 'scmp', 'insb', 'insw',
	'insl', 'ins', 'outsb', 'outsw', 'outsl', 'outs', 'lodsb', 'lodsw', 'lodsl', 'lodsq', 'lods',
	'slodb', 'slodw', 'slodl', 'slodq', 'slod', 'movsb', 'movsw', 'movsl', 'movsq', 'movs', 'smovb',
	'smovw', 'smovl', 'smovq', 'smov', 'scasb', 'scasw', 'scasl', 'scasq', 'scas', 'sscab', 'sscaw',
	'sscal', 'sscaq', 'ssca', 'stosb', 'stosw', 'stosl', 'stosq', 'stos', 'sstob', 'sstow', 'sstol',
	'sstoq', 'ssto', 'clc', 'cld', 'cli', 'clts', 'cmc', 'lahf', 'sahf', 'pushfq', 'popfq', 'pushf',
	'popf', 'stc', 'std', 'sti', 'aaa', 'aas', 'daa', 'das', 'aad', 'aam', 'cbw', 'cwd', 'cwde',
	'cdq', 'cbtw', 'cwtl', 'cwtd', 'cltd', 'cqto', 'int3', 'into', 'iret', 'iretw', 'iretl', 'iretq',
	'rsm', 'hlt', 'wait', 'nop', 'pause', 'xlat', 'lock', 'rep', 'repe', 'repz', 'repne', 'repnz',
	'invd', 'wbinvd', 'cpuid', 'wrmsr', 'rdtsc', 'rdmsr', 'rdpmc', 'syscall', 'sysret', 'ud2',
	'leave', 'ret', 'retq', 'lret', 'fucompp', 'ftst', 'fxam', 'fld1', 'fldl2t', 'fldl2e', 'fldpi',
	'fldlg2', 'fldln2', 'fldz', 'f2xm1', 'fyl2x', 'fptan', 'fpatan', 'fxtract', 'fprem1', 'fdecstp',
	'fincstp', 'fprem', 'fyl2xp1', 'fsqrt', 'fsincos', 'frndint', 'fscale', 'fsin', 'fcos', 'fchs',
	'fabs', 'fninit', 'fnclex', 'fnop', 'fwait', 'fxch', 'fnstsw', 'emms', 'vmcall', 'vmlaunch',
	'vmresume', 'vmxoff', 'sysretq', 'ljmpw', 'ljmpl', 'enter', 'loopne', 'loopnz', 'loope', 'loopz',
	'loop', 'jecxz', 'fld', 'fldl', 'flds', 'fildl', 'fildq', 'fildll', 'fldt', 'fbld', 'fst',
	'fstl', 'fsts', 'fstps', 'fstpl', 'fist', 'fistp', 'fistl', 'fistpl', 'fstp', 'fistpq', 'fistpll',
	'fstpt', 'fbstp', 'fucom', 'fucomp', 'finit', 'fldcw', 'fnstcw', 'fstcw', 'fstsw', 'fclex',
	'fnstenv', 'fstenv', 'fldenv', 'fnsave', 'fsave', 'frstor', 'ffree', 'ffreep', 'fxsave',
	'fxrstor', 'fxsaveq', 'fxrstorq', 'arpl', 'lgdt', 'lgdtq', 'lidt', 'lidtq', 'lldt', 'lmsw',
	'ltr', 'sgdt', 'sgdtq', 'sidt', 'sidtq', 'sldt', 'smsw', 'str', 'verr', 'verw', 'swapgs', 'bswap',
	'bswapl', 'bswapq', 'invlpg', 'cmpxchg8b', 'cmpxchg16b', 'fcmovb', 'fcmove', 'fcmovbe', 'fcmovu',
	'fcmovnb', 'fcmovne', 'fcmovnbe', 'fcmovnu', 'fucomi', 'fcomi', 'fucomip', 'fcomip', 'movd',
	'packssdw', 'packsswb', 'packuswb', 'paddb', 'paddw', 'paddd', 'paddsb', 'paddsw', 'paddusb',
	'paddusw', 'pand', 'pandn', 'pcmpeqb', 'pcmpeqw', 'pcmpeqd', 'pcmpgtb', 'pcmpgtw', 'pcmpgtd',
	'pmaddwd', 'pmulhw', 'pmullw', 'por', 'psllw', 'pslld', 'psllq', 'psraw', 'psrad', 'psrlw',
	'psrld', 'psrlq', 'psubb', 'psubw', 'psubd', 'psubsb', 'psubsw', 'psubusb', 'psubusw',
	'punpckhbw', 'punpckhwd', 'punpckhdq', 'punpcklbw', 'punpcklwd', 'punpckldq', 'pxor', 'ldmxcsr',
	'stmxcsr', 'movups', 'movaps', 'movhps', 'addps', 'cvtpi2ps', 'cvtps2pi', 'cvttps2pi', 'divps',
	'maxps', 'minps', 'mulps', 'pavgb', 'pavgw', 'pmaxsw', 'pmaxub', 'pminsw', 'pminub', 'rcpss',
	'rsqrtps', 'sqrtps', 'subps', 'movnti', 'movntil', 'movntiq', 'prefetchnta', 'prefetcht0',
	'prefetcht1', 'prefetcht2', 'prefetchw', 'lfence', 'mfence', 'sfence', 'clflush']!

const tok_two_chars = [u8(`<`), `=`, 158, `>`, `=`, 157, `!`, `=`, 149, `&`, `&`, 144, `|`, `|`,
	145, `+`, `+`, 130, `-`, `-`, 128, `=`, `=`, 148, `<`, `<`, `<`, `>`, `>`, `>`, `+`, `=`, 176,
	`-`, `=`, 177, `*`, `=`, 178, `/`, `=`, 179, `%`, `=`, 180, `&`, `=`, 181, `^`, `=`, 183, `|`,
	`=`, 182, `-`, `>`, 160, `.`, `.`, 162, `#`, `#`, 163, `#`, `#`, 166, 0]!

fn skip(c int) {
	if tok != c {
		// vcc_trace('${@LOCATION}')
		tmp := [40]char{}
		// vcc_trace('${@LOCATION}')
		a := get_tok_str(c, &tokc)
		pstrcpy(tmp, sizeof(tmp), get_tok_str(c, &tokc))
		// vcc_trace('${@LOCATION}')
		_tcc_error('\'${(&char(tmp)).vstring()}\' expected (got "${get_tok_str(tok, &tokc).vstring()}")')
	}
	// vcc_trace('${@LOCATION}')
	next()
	vcc_trace('${@LOCATION}')
}

fn expect(msg &char) {
	_tcc_error('${msg.vstring()} expected')
}

struct TinyAlloc {
	limit     u32
	size      u32
	buffer    &u8
	p         &u8
	nb_allocs u32
	next      &TinyAlloc
	top       &TinyAlloc
}

struct Tal_header_t {
	size u32
}

fn tal_new(pal &&TinyAlloc, limit u32, size u32) &TinyAlloc {
	al := &TinyAlloc(tcc_mallocz(sizeof(TinyAlloc)))
	al.p = tcc_malloc(size)
	al.buffer = al.p
	al.limit = limit
	al.size = size
	if pal {
		*pal = al
	}
	return al
}

fn tal_delete(al &TinyAlloc) {
	next := &TinyAlloc(0)
	// RRRREG tail_call id=0x7fffd88846b0
	tail_call:
	if !al {
		return
	}
	next = al.next
	tcc_free(al.buffer)
	tcc_free(al)
	al = next
	goto tail_call // id: 0x7fffd88846b0
}

fn tal_free_impl(al &TinyAlloc, p voidptr) {
	if !p {
		return
	}
	// RRRREG tail_call id=0x7fffd8885400
	tail_call:
	if al.buffer <= &u8(p) && &u8(p) < al.buffer + al.size {
		al.nb_allocs--
		if !al.nb_allocs {
			al.p = al.buffer
		}
	} else if al.next {
		al = al.next
		goto tail_call // id: 0x7fffd8885400
	} else { // 3
		tcc_free(p)
	}
}

fn tal_realloc_impl(pal &&TinyAlloc, p voidptr, size u32) voidptr {
	// vcc_trace('${@LOCATION}')
	header := &Tal_header_t(0)
	ret := unsafe { nil }
	is_own := 0
	adj_size := (size + 3) & -4
	al := *pal
	// RRRREG tail_call id=0x7fffd886f110
	tail_call:
	// vcc_trace('${@LOCATION}')
	is_own = (al.buffer <= p && p < al.buffer + al.size)
	if (!p || is_own) && size <= al.limit {
		// vcc_trace('${@LOCATION}')
		if al.p - al.buffer + adj_size + sizeof(Tal_header_t) < al.size {
			// vcc_trace('${@LOCATION}')
			header = &Tal_header_t(al.p)
			header.size = adj_size
			ret = al.p + sizeof(Tal_header_t)
			al.p += adj_size + sizeof(Tal_header_t)
			// vcc_trace('${@LOCATION}')
			if is_own {
				// vcc_trace('${@LOCATION}')
				header = unsafe { ((&Tal_header_t(p)) - 1) }
				if p {
					// vcc_trace('${@LOCATION}')
					C.memcpy(ret, p, header.size)
				}
			} else {
				// vcc_trace('${@LOCATION}')
				al.nb_allocs++
			}
			// vcc_trace('${@LOCATION}')
			return ret
		} else if is_own {
			al.nb_allocs--
			vcc_trace('${@LOCATION}')
			ret = tal_realloc_impl(&&TinyAlloc(pal), 0, size)
			header = unsafe { ((&Tal_header_t(p)) - 1) }
			if p {
				C.memcpy(ret, p, header.size)
			}
			return ret
		}
		if al.next {
			// vcc_trace('${@LOCATION}')
			al = al.next
		} else {
			bottom := al
			next := if al.top { al.top } else { al }
			// vcc_trace('${@LOCATION}')

			al = tal_new(pal, next.limit, next.size * 2)
			al.next = next
			bottom.top = al
		}
		goto tail_call // id: 0x7fffd886f110
	}
	if is_own {
		al.nb_allocs--
		// vcc_trace('${@LOCATION}')
		ret = tcc_malloc(size)
		header = unsafe { ((&Tal_header_t(p)) - 1) }
		if p {
			C.memcpy(ret, p, header.size)
		}
	} else if al.next {
		// vcc_trace('${@LOCATION}')
		al = al.next
		goto tail_call // id: 0x7fffd886f110
	} else { // 3
		// vcc_trace('${@LOCATION}')
		ret = tcc_realloc(p, size)
	}
	vcc_trace('${@LOCATION}')
	return ret
}

fn cstr_realloc(cstr &CString, new_size int) {
	// size := 0
	// size = cstr.size_allocated
	// if size < 8 {
	// 	size = 8
	// }
	// for size < new_size {
	// 	size = size * 2
	// }
	// cstr.data = tcc_realloc(cstr.data, size)
	// cstr.size_allocated = size
}

fn cstr_ccat(cstr &strings.Builder, ch u8) {
	// size := 0
	// size = cstr.size + 1
	// if size > cstr.size_allocated {
	// 	cstr_realloc(cstr, size)
	// }
	cstr.write_byte(ch)
	//(&u8(cstr.data))[size - 1] = ch
	// cstr.size = size
}

fn unicode_to_utf8(b &char, uc u32) &char {
	if uc < 128 {
		unsafe {
			*b++ = uc
		}
	} else if uc < 2048 {
		unsafe {
			*b++ = 192 + uc / 64
			*b++ = 128 + uc % 64
		}
	} else if uc - 55296 < 2048 {
		goto error // id: 0x7fffd88752c8
	} else if uc < 65536 {
		unsafe {
			*b++ = 224 + uc / 4096
			*b++ = 128 + uc / 64 % 64
			*b++ = 128 + uc % 64
		}
	} else if uc < 1114112 {
		unsafe {
			*b++ = 240 + uc / 262144
			*b++ = 128 + uc / 4096 % 64
			*b++
			128 + uc / 64 % 64
			*b++ = 128 + uc % 64
		}
	} else { // 3
		error:
		_tcc_error('0x${uc} is not a valid universal character')
	}
	return b
}

fn cstr_u8cat(cstr &CString, ch int) {
	buf := [4]char{}
	e := &char(0)

	e = unicode_to_utf8(buf, u32(ch))
	cstr_cat(cstr, buf, e - buf)
}

fn cstr_cat(cstr &strings.Builder, str &u8, len int) {
	// size := 0
	// if len <= 0 {
	// 	len = C.strlen(str) + 1 + len
	// }
	// size = cstr.size + len
	// if size > cstr.size_allocated {
	// 	cstr_realloc(cstr, size)
	// }
	if len <= 0 {
		cstr.write_ptr(str, C.strlen(str))
	} else {
		cstr.write_ptr(str, len)
	}
	// C.memmove((&u8(cstr.data)) + cstr.size, str, len)
	// cstr.size = size
}

fn cstr_wccat(cstr &strings.Builder, ch u8) {
	// size := 0
	// size = cstr.size + sizeof(Nwchar_t)
	// if size > cstr.size_allocated {
	// 	cstr_realloc(cstr, size)
	// }
	cstr.write_byte(ch)
	// *&Nwchar_t(((&u8(cstr.data)) + size - sizeof(Nwchar_t))) = ch
	// cstr.size = size
}

fn cstr_new(cstr &strings.Builder) {
	// C.memset(cstr, 0, sizeof(CString))
	cstr.clear()
}

fn cstr_free(cstr &CString) {
	// tcc_free(cstr.data)
	cstr.clear()
}

fn cstr_reset(cstr &CString) {
	// cstr.size = 0
	cstr.clear()
}

fn cstr_vprintf(cstr &strings.Builder, msg string) int {
	// len := 0
	// size := 80

	// for ; true; {
	// 	size += cstr.size
	// 	if size > cstr.size_allocated {
	// 		cstr_realloc(cstr, size)
	// 	}
	// 	size = cstr.size_allocated - cstr.size

	cstr.write_string(msg)
	// 	len = C.vsnprintf(&i8(cstr.data) + cstr.size, size, msg)
	// 	if len >= 0 && len < size {
	// 		break
	// 	}
	// 	size *= 2
	// }
	// cstr.size += len
	return msg.len
}

fn cstr_printf(cstr &CString, msg string) int {
	len := cstr_vprintf(cstr, msg)
	return len
}

fn add_char(cstr &CString, c int) {
	if c == `'` || c == `"` || c == `\\` {
		cstr_ccat(cstr, `\\`)
	}
	if c >= 32 && c <= 126 {
		cstr_ccat(cstr, c)
	} else {
		cstr_ccat(cstr, `\\`)
		if c == `\n` {
			cstr_ccat(cstr, `n`)
		} else {
			cstr_ccat(cstr, `0` + ((c >> 6) & 7))
			cstr_ccat(cstr, `0` + ((c >> 3) & 7))
			cstr_ccat(cstr, `0` + (c & 7))
		}
	}
}

fn tok_alloc_new(pts &&TokenSym, str &char, len int) &TokenSym {
	vcc_trace('${@LOCATION} ${pts != unsafe { nil }}')
	ts := &TokenSym(0)
	ptable := &&TokenSym(0)

	i := 0
	if tok_ident >= sym_first_anom {
		_tcc_error('memory full (symbols)')
	}
	i = tok_ident - TOK_IDENT
	if (i % 512) == 0 {
		ptable = &&TokenSym(tcc_realloc(table_ident, (i + 512) * sizeof(&TokenSym)))
		table_ident = ptable
		vcc_trace_print('${@LOCATION} realloc table_ident')
	}
	// vcc_trace('${@LOCATION}')
	ts = &TokenSym(tal_realloc_impl(&toksym_alloc, unsafe { nil }, sizeof(TokenSym) + len))
	// vcc_trace('${@LOCATION}')
	table_ident[i] = ts
	vcc_trace_print('${@LOCATION} i=${i} new token=${str.vstring()[0..len]}')
	// vcc_trace('${@LOCATION}')
	ts.tok = tok_ident++
	ts.sym_define = unsafe { nil }
	ts.sym_label = unsafe { nil }
	ts.sym_struct = unsafe { nil }
	ts.sym_identifier = unsafe { nil }
	ts.len = len
	ts.hash_next = unsafe { nil }
	// vcc_trace('${@LOCATION} ${str.vstring()} ${len} ${ts.str}')
	C.memcpy(&ts.str[0], str, len)
	// vcc_trace('${@LOCATION}')
	*(&ts.str[0] + len) = `\x00`
	// vcc_trace('${@LOCATION}')
	*pts = ts
	vcc_trace('${@LOCATION}')
	return ts
}

fn tok_alloc(str &char, len int) &TokenSym {
	// vcc_trace('${@LOCATION}')
	ts := &TokenSym(0)
	pts := &&TokenSym(0)

	i := 0
	h := u32(0)
	h = 1
	for i = 0; i < len; i++ {
		h = (h + (h << 5) + (h >> 27) + ((&char(str))[i]))
	}
	// vcc_trace('${@LOCATION}')
	h &= (16384 - 1)
	pts = unsafe { &&TokenSym(hash_ident) + h }
	for {
		ts = *pts
		if !ts {
			break
		}
		if ts.len == len && !C.memcmp(ts.str, str, len) {
			return ts
		}
		pts = &ts.hash_next
	}
	// vcc_trace('${@LOCATION}')
	return tok_alloc_new(pts, str, len)
}

fn tok_alloc_const(str &char) int {
	return tok_alloc(str, C.strlen(str)).tok
}

fn get_tok_str(v int, cv &CValue) &char {
	p := &char(0)
	i := 0
	len := 0

	cstr_reset(&cstr_buf)
	p = cstr_buf.data
	match v {
		194, 195, 198, 199, 196, 197 {
			C.sprintf(p, c'%llu', u64(cv.i))
		}
		193 { // case comp body kind=CallExpr is_enum=false
			cstr_ccat(&cstr_buf, `L`)
		}
		192 { // case comp body kind=CallExpr is_enum=false
			cstr_ccat(&cstr_buf, `'`)
			add_char(&cstr_buf, cv.i)
			cstr_ccat(&cstr_buf, `'`)
			cstr_ccat(&cstr_buf, `\x00`)
		}
		205, 206 {
			return &char(cv.str.data)
		}
		201 { // case comp body kind=CallExpr is_enum=false
			cstr_ccat(&cstr_buf, `L`)
		}
		200 { // case comp body kind=CallExpr is_enum=false
			cstr_ccat(&cstr_buf, `"`)
			if v == 200 {
				len = cv.str.size - 1
				for i = 0; i < len; i++ {
					add_char(&cstr_buf, (&u8(cv.str.data))[i])
				}
			} else {
				len = (cv.str.size / sizeof(Nwchar_t)) - 1
				for i = 0; i < len; i++ {
					add_char(&cstr_buf, (&Nwchar_t(cv.str.data))[i])
				}
			}
			cstr_ccat(&cstr_buf, `"`)
			cstr_ccat(&cstr_buf, `\x00`)
		}
		202 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<float>')
		}
		203 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<double>')
		}
		204 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<long double>')
		}
		207 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<linenumber')
		}
		156 { // case comp body kind=BinaryOperator is_enum=false
			v = `<`
			goto addv // id: 0x7fffd888e800
		}
		159 { // case comp body kind=BinaryOperator is_enum=false
			v = `>`
			goto addv // id: 0x7fffd888e800
		}
		161 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'...')
		}
		184 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<<=')
		}
		185 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'>>=')
		}
		(-1) { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<eof>')
		}
		0 { // case comp body kind=ReturnStmt is_enum=false
			return C.strcpy(p, c'<no name>')
		}
		else {
			vcc_trace('${@LOCATION}')
			if v < 256 {
				vcc_trace('${@LOCATION}')
				q := &tok_two_chars[0]
				vcc_trace('${@LOCATION} ${rune(*q)}')
				for *q {
					vcc_trace('${@LOCATION} ${rune(*q)}')
					if q[2] == v {
						unsafe {
							vcc_trace('${@LOCATION}')
							*p++ = q[0]
							*p++ = q[1]
							*p = `\x00`
						}
						return cstr_buf.data
					}
					vcc_trace('${@LOCATION}')
					q += 3
				}
				if v >= 127 || (v < 32 && !is_space(v) && v != `\n`) {
					C.sprintf(p, c'<\\x%02x>', v)
				}
				// RRRREG addv id=0x7fffd888e800
				addv:
				unsafe {
					*p++ = v
					*p = `\x00`
				}
			} else if v < tok_ident {
				return &char(table_ident[v - TOK_IDENT].str)
			} else if v >= sym_first_anom {
				C.sprintf(p, c'L.%u', v - sym_first_anom)
			} else {
				return unsafe { nil }
			}
		}
	}
	return cstr_buf.data
}

@[inline]
fn check_space(t int, spc &int) int {
	if t < 256 && isidnum_table[t - ch_eof] & 1 {
		if *spc {
			return 1
		}
		*spc = 1
	} else { // 3
		*spc = 0
	}
	return 0
}

fn handle_eob() int {
	vcc_trace('${@LOCATION}')
	bf := file
	len := 0
	if bf.buf_ptr >= bf.buf_end {
		if bf.fd >= 0 {
			len = 8192
			vcc_trace('${@LOCATION}')
			len = C.read(bf.fd, bf.buffer, len)
			if len < 0 {
				len = 0
			}
		} else {
			vcc_trace('${@LOCATION}')
			len = 0
		}
		tcc_state.total_bytes += len
		vcc_trace('${@LOCATION}')
		bf.buf_ptr = &bf.buffer[0]
		bf.buf_end = &bf.buffer[0] + len
		*bf.buf_end = `\\`
		vcc_trace('${@LOCATION}')
	}
	if bf.buf_ptr < bf.buf_end {
		vcc_trace('${@LOCATION} ${rune(bf.buf_ptr[0])}')
		return bf.buf_ptr[0]
	} else {
		bf.buf_ptr = &bf.buf_end[0]
		vcc_trace('${@LOCATION} ${bf.buf_ptr.vstring()}')
		return -1
	}
}

fn next_c() int {
	file.buf_ptr++
	ch := int(*file.buf_ptr)
	// vcc_trace('${@LOCATION} ${rune(ch)}')
	if ch == `\\` && file.buf_ptr >= file.buf_end {
		// vcc_trace('${@LOCATION}')
		ch = handle_eob()
		// vcc_trace('${@LOCATION} ${rune(ch)}')
	}
	return ch
}

fn handle_stray_noerror(err int) int {
	ch := 0
	for {
		ch = next_c()
		if ch != `\\` {
			break
		}
		vcc_trace('${@LOCATION} ${rune(ch)}')
		ch = next_c()
		// vcc_trace('${@LOCATION} ${rune(ch)}')
		if ch == `\n` {
			// RRRREG newl id=0x7fffd88967f0
			newl:
			file.line_num++
		} else {
			if ch == `\r` {
				ch = next_c()
				// vcc_trace('${@LOCATION} ${rune(ch)}')
				if ch == `\n` {
					goto newl // id: 0x7fffd88967f0
				}
				file.buf_ptr--
				*file.buf_ptr = `\r`
			}
			if err {
				_tcc_error("stray '\\' in program")
			}
			file.buf_ptr--
			*file.buf_ptr = `\\`
			// vcc_trace('${@LOCATION} ${file.buf_ptr.vstring()}')
			return *file.buf_ptr
		}
	}
	// vcc_trace('${@LOCATION} ${rune(ch)}')
	return ch
}

fn handle_bs(p &&u8) int {
	c := 0
	file.buf_ptr = *p - 1
	c = handle_stray_noerror(0)
	*p = file.buf_ptr
	return c
}

fn handle_stray(p &&u8) int {
	c := 0
	file.buf_ptr = *p - 1
	c = handle_stray_noerror(!(parse_flags & 32))
	*p = file.buf_ptr
	return c
}

fn skip_spaces() int {
	ch := 0
	file.buf_ptr--
	for {
		ch = handle_stray_noerror(0)
		// while()
		if !(isidnum_table[ch - (-1)] & 1) {
			break
		}
	}
	return ch
}

fn parse_line_comment(p &u8) &u8 {
	c := 0
	for {
		for {
			p++
			c = *p
			redo:
			if c == `\n` || c == `\\` {
				break
			}
			p++
			c = *p
			if c == `\n` || c == `\\` {
				break
			}
		}
		if c == `\n` {
			break
		}
		c = handle_bs(&p)
		if c == (-1) {
			break
		}
		if c != `\\` {
			goto redo // id: 0x7fffd8899480
		}
	}
	return p
}

fn parse_comment(p &u8) &u8 {
	c := 0
	for {
		for {
			p++
			c = *p
			redo:
			if c == `\n` || c == `*` || c == `\\` {
				break
			}
			p++
			c = *p
			if c == `\n` || c == `*` || c == `\\` {
				break
			}
		}
		if c == `\n` {
			file.line_num++
		} else if c == `*` {
			for {
				p++
				c = *p
				// while()
				if !(c == `*`) {
					break
				}
			}
			if c == `\\` {
				c = handle_bs(&p)
			}
			if c == `/` {
				break
			}
			goto check_eof // id: 0x7fffd889a808
		} else {
			c = handle_bs(&p)
			// RRRREG check_eof id=0x7fffd889a808
			check_eof:
			if c == (-1) {
				_tcc_error('unexpected end of file in comment')
			}
			if c != `\\` {
				goto redo // id: 0x7fffd8899fd8
			}
		}
	}
	return p + 1
}

fn parse_pp_string(p &u8, sep int, str &CString) &u8 {
	c := 0
	for {
		p++
		c = *p
		redo:
		if c == sep {
			break
		} else if c == `\\` {
			c = handle_bs(&p)
			if c == ch_eof {
				// RRRREG unterminated_string id=0x7fffd889b538
				unterminated_string:
				tok_flags &= ~1
				_tcc_error('missing terminating ${sep} character')
			} else if c == `\\` {
				if str {
					cstr_ccat(str, c)
				}
				p++
				c = *p
				if c == `\\` {
					c = handle_bs(&p)
					if c == (-1) {
						goto unterminated_string // id: 0x7fffd889b538
					}
				}
				goto add_char // id: 0x7fffd889bbf0
			} else {
				goto redo // id: 0x7fffd889bc88
			}
		} else if c == `\n` {
			// RRRREG add_lf id=0x7fffd889bff8
			add_lf:
			if 0 {
				file.line_num++
				goto add_char // id: 0x7fffd889bbf0
			} else if str {
				goto unterminated_string // id: 0x7fffd889b538
			} else {
				return p
			}
		} else if c == `\r` {
			p++
			c = *p
			if c == `\\` {
				c = handle_bs(&p)
			}
			if c == `\n` {
				goto add_lf // id: 0x7fffd889bff8
			}
			if c == (-1) {
				goto unterminated_string // id: 0x7fffd889b538
			}
			if str {
				cstr_ccat(str, `\r`)
			}
			goto redo // id: 0x7fffd889bc88
		} else {
			// RRRREG add_char id=0x7fffd889bbf0
			add_char:
			if str {
				cstr_ccat(str, c)
			}
		}
	}
	p++
	return p
}

fn preprocess_skip() {
	vcc_trace('${@LOCATION}')
	a := 0
	start_of_line := 0
	c := 0
	in_warn_or_error := 0

	p := &u8(0)
	p = file.buf_ptr
	a = 0

	redo_start:
	start_of_line = 1
	in_warn_or_error = 0
	vcc_trace('${@LOCATION}')
	for {
		redo_no_start:
		c = *p
		match rune(c) {
			` `, `\t`, `\f`, `\v`, `\r` {
				vcc_trace('${@LOCATION}')
				p++
				vcc_trace('${@LOCATION}')
				goto redo_no_start // id: 0x7fffd889d088
			}
			`\n` { // case comp body kind=UnaryOperator is_enum=false
				vcc_trace('${@LOCATION}')
				file.line_num++
				p++
				vcc_trace('${@LOCATION}')
				goto redo_start // id: 0x7fffd889cef8
			}
			`\\` { // case comp body kind=BinaryOperator is_enum=false
				vcc_trace('${@LOCATION}')
				c = handle_bs(&p)
				if c == (-1) {
					expect(c'#endif')
				}
				if c == `\\` {
					p++
				}
				vcc_trace('${@LOCATION}')
				goto redo_no_start // id: 0x7fffd889d088
			}
			`"`, `'` {
				if in_warn_or_error {
					vcc_trace('${@LOCATION}')
					goto _default // id: 0x7fffd889d970
				}
				tok_flags &= ~1
				vcc_trace('${@LOCATION}')
				p = parse_pp_string(p, c, unsafe { nil })
			}
			`/` { // case comp body kind=IfStmt is_enum=false
				vcc_trace('${@LOCATION}')
				if in_warn_or_error {
					vcc_trace('${@LOCATION}')
					goto _default // id: 0x7fffd889d970
				}
				p++
				vcc_trace('${@LOCATION}')
				c = handle_bs(&p)
				if c == `*` {
					vcc_trace('${@LOCATION}')
					p = parse_comment(p)
				} else if c == `/` {
					vcc_trace('${@LOCATION}')
					p = parse_line_comment(p)
				}
			}
			`#` { // case comp body kind=UnaryOperator is_enum=false
				vcc_trace('${@LOCATION}')
				p++
				if start_of_line {
					file.buf_ptr = p
					vcc_trace('${@LOCATION}')
					next_nomacro()
					vcc_trace('${@LOCATION}')
					p = file.buf_ptr
					vcc_trace('${@LOCATION}')
					if a == 0 && (tok == Tcc_token.tok_else
						|| tok == Tcc_token.tok_elif || tok == Tcc_token.tok_endif) {
						vcc_trace('${@LOCATION}')
						goto the_end // id: 0x7fffd889e6e0
					}
					vcc_trace('${@LOCATION}')
					if tok == Tcc_token.tok_if || tok == Tcc_token.tok_ifdef
						|| tok == Tcc_token.tok_ifndef {
						vcc_trace('${@LOCATION}')
						a++
					} else if tok == Tcc_token.tok_endif {
						vcc_trace('${@LOCATION}')
						a--
					} else if tok == Tcc_token.tok_error || tok == Tcc_token.tok_warning {
						in_warn_or_error = 1
					} else if tok == 10 {
						goto redo_start // id: 0x7fffd889cef8
					} else if parse_flags & 8 {
						vcc_trace('${@LOCATION}')
						p = parse_line_comment(p - 1)
					}
					vcc_trace('${@LOCATION}')
				} else if parse_flags & 8 {
					vcc_trace('${@LOCATION}')
					p = parse_line_comment(p - 1)
				}
			}
			else {
				_default:
				vcc_trace('${@LOCATION}')
				p++
			}
		}
		start_of_line = 0
	}
	the_end:
	vcc_trace('${@LOCATION}')
	file.buf_ptr = p
}

fn tok_str_new(s &TokenString) {
	s.str = unsafe { nil }
	s.len = 0
	s.lastlen = s.len
	s.allocated_len = 0
	s.last_line_num = -1
}

fn tok_str_alloc() &TokenString {
	str := &TokenString(tal_realloc_impl(&tokstr_alloc, unsafe { nil }, sizeof(TokenString)))
	tok_str_new(str)
	return str
}

fn tok_str_dup(s &TokenString) &int {
	str := &int(tal_realloc_impl(&tokstr_alloc, unsafe { nil }, s.len * sizeof(int)))
	C.memcpy(str, s.str, s.len * sizeof(int))
	return str
}

fn tok_str_free_str(str &int) {
	tal_free_impl(tokstr_alloc, str)
}

fn tok_str_free(str &TokenString) {
	tok_str_free_str(str.str)
	tal_free_impl(tokstr_alloc, str)
}

fn tok_str_realloc(s &TokenString, new_size int) &int {
	// vcc_trace('${@LOCATION}')
	str := &int(0)
	size := s.allocated_len
	// vcc_trace('${@LOCATION}')
	if size < 16 {
		size = 16
	}
	for size < new_size {
		size = size * 2
	}
	if size > s.allocated_len {
		// vcc_trace('${@LOCATION}')
		str = tal_realloc_impl(&tokstr_alloc, s.str, size * sizeof(int))
		s.allocated_len = size
		s.str = str
	}
	// vcc_trace('${@LOCATION}')
	return s.str
}

fn tok_str_add(s &TokenString, t int) {
	len := 0
	str := &int(0)

	len = s.len
	str = s.str
	if len >= s.allocated_len {
		str = tok_str_realloc(s, len + 1)
	}
	str[len++] = t
	s.len = len
}

fn begin_macro(str &TokenString, alloc int) {
	vcc_trace_print('${@LOCATION} 1')
	str.alloc = alloc
	str.prev = macro_stack
	str.prev_ptr = macro_ptr
	str.save_line_num = file.line_num
	vcc_trace_print('${@LOCATION} 2')
	macro_ptr = str.str
	macro_stack = str
	vcc_trace_print('${@LOCATION} beginmacro')
}

fn end_macro() {
	str := macro_stack
	macro_stack = str.prev
	macro_ptr = str.prev_ptr
	file.line_num = str.save_line_num
	str.len = 0
	if str.alloc != 0 {
		if str.alloc == 2 {
			str.str = unsafe { nil }
		}
		tok_str_free(str)
	}
	vcc_trace_print('${@LOCATION} endmacro')
}

fn tok_str_add2(s &TokenString, t int, cv &CValue) {
	len := 0
	str := &int(0)

	s.lastlen = s.len
	len = s.lastlen
	str = s.str

	if len + 4 >= s.allocated_len {
		str = tok_str_realloc(s, len + 4 + 1)
	}
	str[len++] = t
	match t {
		194, 195, 192, 193, 202, 207 {
			str[len++] = cv.tab[0]
		}
		205, 206, 200, 201 {
			{
				nb_words := 1 + (cv.str.size + sizeof(int) - 1) / sizeof(int)
				if len + nb_words >= s.allocated_len {
					str = tok_str_realloc(s, len + nb_words + 1)
				}
				str[len] = cv.str.size
				C.memcpy(&str[len + 1], cv.str.data, cv.str.size)
				len += nb_words
			}
		}
		203, 196, 197, 198, 199 {
			str[len++] = cv.tab[0]
			str[len++] = cv.tab[1]
		}
		204 { // case comp body kind=BinaryOperator is_enum=false
			str[len++] = cv.tab[0]
			str[len++] = cv.tab[1]
			str[len++] = cv.tab[2]
			str[len++] = cv.tab[3]
		}
		else {}
	}
	s.len = len
}

fn tok_str_add_tok(s &TokenString) {
	cval := CValue{}
	if file.line_num != s.last_line_num {
		s.last_line_num = file.line_num
		cval.i = s.last_line_num
		tok_str_add2(s, 207, &cval)
	}
	tok_str_add2(s, tok, &tokc)
}

fn tok_get(t &int, pp &&int, cv &CValue) {
	vcc_trace_print('${@LOCATION} -- begin -- ${tok} ${int(file.buf_ptr[0])}')
	p := &int(*pp)
	n := 0

	// vcc_trace('${@LOCATION} ${cv != unsafe { nil }}')
	tab := &int(&cv.tab[0])
	// vcc_trace('${@LOCATION}')
	*t = *p++
	vcc_trace('${@LOCATION} ${*t}')
	match *t {
		194, 192, 193, 207 {
			// vcc_trace('${@LOCATION}')
			cv.i = *p++
		}
		195 { // case comp body kind=BinaryOperator is_enum=false
			// vcc_trace('${@LOCATION}')
			cv.i = u32(*p++)
		}
		202 { // case comp body kind=BinaryOperator is_enum=false
			// vcc_trace('${@LOCATION}')
			tab[0] = *p++
		}
		200, 201, 205, 206 {
			vcc_trace('${@LOCATION}')
			cv.str.size = *p++
			cv.str.data = p
			p += (cv.str.size + sizeof(int) - 1) / sizeof(int)
			vcc_trace('${@LOCATION}')
		}
		203, 196, 197, 198, 199 {
			n = 2
			goto copy // id: 0x7fffd88af850
		}
		204 { // case comp body kind=BinaryOperator is_enum=false
			n = 4
			// RRRREG copy id=0x7fffd88af850

			copy: for {
				vcc_trace('${@LOCATION}')
				vcc_trace('${@LOCATION} ${n} ${tab == unsafe { nil }} ${p == unsafe { nil }}')
				*tab++ = *p++
				// while()
				n--
				if !n {
					break
				}
			}
		}
		else {}
	}
	// vcc_trace('${@LOCATION}')
	*pp = p
	vcc_trace_print('${@LOCATION} --end-- p=${*p} ${tok} ${int(file.buf_ptr[0])}')
}

type intpp = &int

@[inline]
fn tok_get_macro(mut t &int, mut p intpp, mut cv CValue) {
	_t := int(**p)
	if (_t >= 192 && _t <= 207) {
		// vcc_trace_print('${@LOCATION} 1 ${_t}')
		tok_get(t, p, cv)
		// vcc_trace('${@LOCATION}')
	} else { // 3
		// vcc_trace_print('${@LOCATION} 2 ${_t}')
		*t = _t
		*p = &int(*p) + 1
		// vcc_trace('${@LOCATION}')
	}
}

fn macro_is_equal(a &int, b &int) int {
	cv := CValue{}
	t := 0
	if !a || !b {
		return 1
	}
	for *a && *b {
		cstr_reset(&tokcstr)
		tok_get_macro(mut &t, mut &a, mut &cv)
		cstr_cat(&tokcstr, get_tok_str(t, &cv), 0)
		tok_get_macro(mut &t, mut &b, mut &cv)
		if C.strcmp(tokcstr.data, get_tok_str(t, &cv)) {
			vcc_trace_print('${@LOCATION}')
			return 0
		}
	}
	return !(*a || *b)
}

fn define_push(v int, macro_type int, str &int, first_arg &Sym) {
	vcc_trace('${@LOCATION}')
	o := define_find(v)
	vcc_trace('${@LOCATION} ${o != unsafe { nil }}')
	s := sym_push2(&define_stack, v, macro_type, 0)
	vcc_trace('${@LOCATION} ${s != unsafe { nil }} ${str} ${s.d}')
	s.d = &int(str)
	vcc_trace('${@LOCATION}')
	s.next = first_arg
	table_ident[v - TOK_IDENT].sym_define = s
	vcc_trace_print('${@LOCATION} - v=${v}')
	if o != unsafe { nil } && !macro_is_equal(o.d, s.d) {
		_tcc_warning('${get_tok_str(v, (unsafe { nil })).vstring()} redefined')
	}
	vcc_trace('${@LOCATION}')
}

fn define_undef(s &Sym) {
	v := int(s.v)
	if v >= TOK_IDENT && v < tok_ident {
		table_ident[v - TOK_IDENT].sym_define = unsafe { nil }
	}
}

fn define_find(v int) &Sym {
	v -= TOK_IDENT
	if u32(v) >= u32((tok_ident - TOK_IDENT)) {
		vcc_trace('${@LOCATION}')
		return unsafe { nil }
	}
	vcc_trace('${@LOCATION}')
	return table_ident[v].sym_define
}

fn free_defines(b &Sym) {
	for voidptr(define_stack) != voidptr(b) {
		top := define_stack
		define_stack = top.prev
		tok_str_free_str(top.d)
		define_undef(top)
		sym_free(top)
		vcc_trace_print('${@LOCATION}')
	}
}

fn maybe_run_test(s &TCCState) {
	vcc_trace('${@LOCATION}')
	p := &char(0)
	if &char(s.include_stack_ptr) != &char(s.include_stack[0]) {
		return
	}
	p = get_tok_str(tok, unsafe { nil })
	if 0 != C.memcmp(p, c'test_', 5) {
		return
	}
	s.run_test--
	if 0 != s.run_test {
		return
	}
	C.fprintf(s.ppfp, &c'\n[%s]\n'[!(s.dflag & 32)], p)
	C.fflush(s.ppfp)
	define_push(tok, 0, unsafe { nil }, unsafe { nil })
}

fn parse_include(s1 &TCCState, do_next int, test int) int {
	c := 0
	i := 0

	name := [1024]char{}
	buf := [1024]char{}
	p := &char(0)

	e := &CachedInclude(0)
	c = skip_spaces()
	if c == `<` || c == `"` {
		cstr_reset(&tokcstr)
		file.buf_ptr = parse_pp_string(file.buf_ptr, if c == `<` { `>` } else { c }, &tokcstr)
		i = tokcstr.len
		pstrncpy(name, tokcstr.data, if i >= sizeof(name) { sizeof(name) - 1 } else { i })
		next_nomacro()
	} else {
		parse_flags = 1 | 4 | (parse_flags & 8)
		vcc_trace_print('${@LOCATION} include.0 ${parse_flags}')
		name[0] = 0
		for {
			next()
			p = name
			i = C.strlen(p) - 1
			if i > 0 && ((p[0] == `"` && p[i] == `"`) || (p[0] == `<` && p[i] == `>`)) {
				break
			}
			if tok == 10 {
				_tcc_error('\'#include\' expects "FILENAME" or <FILENAME>')
			}
			pstrcat(name, sizeof(name), get_tok_str(tok, &tokc))
		}
		c = p[0]
		C.memmove(p, p + 1, i - 1)
		p[i - 1] = 0
	}
	i = if do_next { file.include_next_index } else { -1 }
	for {
		i++
		if i == 0 {
			if !(name[0] == `/`) {
				continue
			}
			buf[0] = `\x00`
		} else if i == 1 {
			if c != `"` {
				continue
			}
			p = file.truefilename
			pstrncpy(buf, p, tcc_basename(p) - p)
		} else {
			j := i - 2
			k := j - s1.nb_include_paths

			if k < 0 {
				p = s1.include_paths[j]
			} else if k < s1.nb_sysinclude_paths {
				p = s1.sysinclude_paths[k]
			} else if test {
				return 0
			} else { // 3
				_tcc_error("include file '${(&char(name)).vstring()}' not found")
			}
			pstrcpy(buf, sizeof(buf), p)
			pstrcat(buf, sizeof(buf), c'/')
		}
		pstrcat(buf, sizeof(buf), name)
		e = search_cached_include(s1, buf, 0)
		vcc_trace('${@LOCATION}')
		if e != unsafe { nil } && (define_find(e.ifndef_macro) || e.once != unsafe { nil }) {
			vcc_trace('${@LOCATION}')
			return 1
		}
		vcc_trace('${@LOCATION}')
		if tcc_open(s1, buf) >= 0 {
			vcc_trace('${@LOCATION}')
			break
		}
	}
	if test {
		vcc_trace('${@LOCATION}')
		tcc_close()
	} else {
		vcc_trace('${@LOCATION}')
		unsafe {
			if voidptr(s1.include_stack_ptr) >= voidptr(&BufferedFile(&s1.include_stack[0]) + 32) {
				_tcc_error('#include recursion too deep')
			}
			vcc_trace('${@LOCATION}')
			*s1.include_stack_ptr++ = file.prev
		}
		file.include_next_index = i
		vcc_trace('${@LOCATION}')
		if s1.gen_deps {
			vcc_trace('${@LOCATION}')
			bf := file
			bf = bf.prev
			for i == 1 && bf {
				i = bf.include_next_index
				bf = bf.prev
			}
			if s1.include_sys_deps || i - 2 < s1.nb_include_paths {
				vcc_trace('${@LOCATION}')
				dynarray_add(&s1.target_deps, &s1.nb_target_deps, tcc_strdup(buf))
			}
		}
		vcc_trace('${@LOCATION}')
		tcc_debug_bincl(s1)
		tok_flags |= 2 | 1
	}
	vcc_trace('${@LOCATION}')
	return 1
}

fn expr_preprocess(s1 &TCCState) int {
	c := 0
	t := 0

	str := &TokenString(tok_str_alloc())
	pp_expr = 1
	vcc_trace_print('${@LOCATION} - start - ${tok}')
	for tok != 10 && tok != tok_eof {
		next()
		// RRRREG redo id=0x7fffd88bbd88
		redo:
		if tok < 256 {
			if tok >= 200 && tok <= 204 {
				_tcc_error('invalid constant in preprocessor expression')
			}
		} else if tok == Tcc_token.tok_defined {
			next_nomacro()
			t = tok
			if t == `(` {
				next_nomacro()
			}
			if tok < 256 {
				expect(c'identifier')
			}
			if s1.run_test {
				maybe_run_test(s1)
			}
			c = 0
			vcc_trace_print('${@LOCATION} - check defined - tok=${tok}')
			if define_find(tok) || tok == Tcc_token.tok___has_include
				|| tok == Tcc_token.tok___has_include_next {
				c = 1
			}
			if t == `(` {
				next_nomacro()
				if tok != `)` {
					expect(c"')'")
				}
			}
			tok = 194
			tokc.i = c
		} else if tok == Tcc_token.tok___has_include || tok == Tcc_token.tok___has_include_next {
			t = tok
			next_nomacro()
			if tok != `(` {
				expect(c'(')
			}
			c = parse_include(s1, t - Tcc_token.tok___has_include, 1)
			if tok != `)` {
				expect(c"')'")
			}
			tok = 194
			tokc.i = c
		} else {
			vcc_trace_print('${@LOCATION} - preprocess.else tok=${tok}')
			t = tok
			tok = 194
			tokc.i = 0
			tok_str_add_tok(str)
			next()
			if tok == `(` {
				_tcc_error("function-like macro '${get_tok_str(t, (unsafe { nil }))}' is not defined")
			}
			goto redo // id: 0x7fffd88bbd88
		}
		tok_str_add_tok(str)
	}
	vcc_trace_print('${@LOCATION} pp_expr=0 ${tok}')
	pp_expr = 0
	tok_str_add(str, -1)
	tok_str_add(str, 0)
	begin_macro(str, 1)
	next()
	c = expr_const()
	vcc_trace_print('${@LOCATION} c=${c}')
	end_macro()
	vcc_trace('${@LOCATION}')
	return int(c != 0)
}

fn parse_define() {
	vcc_trace('${@LOCATION}')
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
		_tcc_error("invalid macro name '${get_tok_str(tok, &tokc)}'")
	}
	first = unsafe { nil }
	t = 0
	parse_flags = ((parse_flags & ~8) | 16)
	vcc_trace('${@LOCATION}')
	next_nomacro()
	vcc_trace('${@LOCATION}')
	parse_flags &= ~16
	if tok == `(` {
		dotid := set_idnum(`.`, 0)
		vcc_trace('${@LOCATION}')
		next_nomacro()
		vcc_trace('${@LOCATION}')
		ps = &first
		if tok != `)` {
			for {
				varg = tok
				vcc_trace('${@LOCATION}')
				next_nomacro()
				is_vaargs = 0
				if varg == 161 {
					varg = Tcc_token.tok___va_args__
					is_vaargs = 1
				} else if tok == 161 && tcc_state.gnu_ext {
					is_vaargs = 1
					vcc_trace('${@LOCATION}')
					next_nomacro()
					vcc_trace('${@LOCATION}')
				}
				if varg < 256 {
					// RRRREG bad_list id=0x7fffd88bdbd0
					bad_list:
					_tcc_error('bad macro parameter list')
				}
				vcc_trace('${@LOCATION}')
				s = sym_push2(&define_stack, varg | sym_field, is_vaargs, 0)
				vcc_trace('${@LOCATION}')
				*ps = s
				vcc_trace('${@LOCATION}')
				ps = &s.next
				vcc_trace('${@LOCATION}')
				if tok == `)` {
					break
				}
				if tok != `,` || is_vaargs {
					vcc_trace('${@LOCATION}')
					goto bad_list // id: 0x7fffd88bdbd0
				}
				vcc_trace('${@LOCATION}')
				next_nomacro()
				vcc_trace('${@LOCATION}')
			}
		}
		parse_flags |= 16
		vcc_trace('${@LOCATION}')
		next_nomacro()
		vcc_trace('${@LOCATION}')
		t = 1
		vcc_trace('${@LOCATION}')
		set_idnum(`.`, dotid)
	}
	tokstr_buf.len = 0
	spc = 2
	parse_flags |= 32 | 16 | 4
	for tok != 10 && tok != (-1) {
		vcc_trace('${@LOCATION}')
		if 163 == tok {
			if 2 == spc {
				goto bad_twosharp // id: 0x7fffd88be918
			}
			if 1 == spc {
				tokstr_buf.len--
			}
			spc = 3
			tok = 166
		} else if `#` == tok {
			spc = 4
		} else if check_space(tok, &spc) {
			goto skip // id: 0x7fffd88bed78
		}
		vcc_trace('${@LOCATION}')
		tok_str_add2(&tokstr_buf, tok, &tokc)
		// RRRREG skip id=0x7fffd88bed78
		skip:
		vcc_trace('${@LOCATION}')
		next_nomacro()
	}
	parse_flags = saved_parse_flags
	vcc_trace_print('${@LOCATION} restore flags ${parse_flags}')
	if spc == 1 {
		tokstr_buf.len--
	}
	vcc_trace('${@LOCATION}')
	tok_str_add(&tokstr_buf, 0)
	if 3 == spc {
		// RRRREG bad_twosharp id=0x7fffd88be918
		bad_twosharp:
		_tcc_error("'##' cannot appear at either end of macro")
	}
	vcc_trace('${@LOCATION}')
	define_push(v, t, tok_str_dup(&tokstr_buf), first)
	vcc_trace('${@LOCATION}')
}

fn search_cached_include(s1 &TCCState, filename &char, add int) &CachedInclude {
	vcc_trace('${@LOCATION}')
	s := &char(0)
	basename := &char(0)

	h := u32(0)
	e := &CachedInclude(0)
	c := 0
	i := 0
	len := 0

	s = tcc_basename(filename)
	basename = s
	h = 1
	c = u8(*s)
	for c != 0 {
		h = (h + (h << 5) + (h >> 27) + c)
		unsafe { s++ }
		c = u8(*s)
	}
	h &= (32 - 1)
	i = s1.cached_includes_hash[h]
	for ; true; {
		if i == 0 {
			break
		}
		e = s1.cached_includes[i - 1]
		if 0 == C.strcmp(filename, e.filename) {
			return e
		}
		if e.once && 0 == C.strcmp(basename, tcc_basename(e.filename))
			&& 0 == normalized_pathcmp(filename, e.filename) {
			return e
		}
		i = e.hash_next
	}
	if !add {
		return unsafe { nil }
	}
	len = C.strlen(filename)
	e = tcc_malloc(sizeof(CachedInclude) + len)
	C.memcpy(e.filename, filename, len + 1)
	e.ifndef_macro = 0
	e.once = e.ifndef_macro
	dynarray_add(&s1.cached_includes, &s1.nb_cached_includes, e)
	e.hash_next = s1.cached_includes_hash[h]
	s1.cached_includes_hash[h] = s1.nb_cached_includes
	return e
}

fn pragma_parse(s1 &TCCState) {
	vcc_trace('${@LOCATION}')
	next_nomacro()
	if tok == Tcc_token.tok_push_macro || tok == Tcc_token.tok_pop_macro {
		t := tok
		v := 0
		s := &Sym(0)

		next()
		if tok != `(` {
			goto pragma_err // id: 0x7fffd88c22b8
		}
		next()
		if tok != 200 {
			goto pragma_err // id: 0x7fffd88c22b8
		}
		v = tok_alloc(tokc.str.data, tokc.str.size - 1).tok
		next()
		if tok != `)` {
			goto pragma_err // id: 0x7fffd88c22b8
		}
		if t == Tcc_token.tok_push_macro {
			vcc_trace('${@LOCATION}')
			s = define_find(v)
			for unsafe { nil } == s {
				define_push(v, 0, unsafe { nil }, unsafe { nil })
				s = define_find(v)
			}
			s.type_.ref = s
		} else {
			for s = define_stack; s; s = s.prev {
				if s.v == v && voidptr(s.type_.ref) == voidptr(s) {
					s.type_.ref = unsafe { nil }
					break
				}
			}
		}
		if s != unsafe { nil } {
			table_ident[v - TOK_IDENT].sym_define = if s.d != unsafe { nil } {
				s
			} else {
				unsafe { nil }
			}
		} else { // 3
			_tcc_warning('unbalanced #pragma pop_macro')
		}
		pp_debug_tok = t
		pp_debug_symv = v
	} else if tok == Tcc_token.tok_once {
		search_cached_include(s1, file.filename, 1).once = 1
	} else if s1.output_type == 5 {
		unget_tok(` `)
		unget_tok(Tcc_token.tok_pragma)
		unget_tok(`#`)
		unget_tok(10)
	} else if tok == Tcc_token.tok_pack {
		next()
		skip(`(`)
		if tok == Tcc_token.tok_asm_pop {
			next()
			if s1.pack_stack_ptr <= s1.pack_stack {
				// RRRREG stk_error id=0x7fffd88c4298
				stk_error:
				_tcc_error('out of pack stack')
			}
			s1.pack_stack_ptr--
		} else {
			val := 0
			if tok != `)` {
				if tok == Tcc_token.tok_asm_push {
					next()
					if s1.pack_stack_ptr >= s1.pack_stack + 8 - 1 {
						goto stk_error // id: 0x7fffd88c4298
					}
					val = *s1.pack_stack_ptr++
					if tok != `,` {
						goto pack_set // id: 0x7fffd88c4918
					}
					next()
				}
				if tok != 194 {
					goto pragma_err // id: 0x7fffd88c22b8
				}
				val = tokc.i
				if val < 1 || val > 16 || (val & (val - 1)) != 0 {
					goto pragma_err // id: 0x7fffd88c22b8
				}
				next()
			}
			// RRRREG pack_set id=0x7fffd88c4918
			pack_set:
			*s1.pack_stack_ptr = val
		}
		if tok != `)` {
			goto pragma_err // id: 0x7fffd88c22b8
		}
	} else if tok == Tcc_token.tok_comment {
		p := &char(0)
		t := 0
		next()
		skip(`(`)
		t = tok
		next()
		skip(`,`)
		if tok != 200 {
			goto pragma_err // id: 0x7fffd88c22b8
		}
		p = tcc_strdup(&char(tokc.str.data))
		next()
		if tok != `)` {
			goto pragma_err // id: 0x7fffd88c22b8
		}
		if t == Tcc_token.tok_lib {
			dynarray_add(&s1.pragma_libs, &s1.nb_pragma_libs, p)
		} else {
			if t == Tcc_token.tok_option {
				tcc_set_options(s1, p)
			}
			tcc_free(p)
		}
	} else { // 3
		tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
		_tcc_warning('#pragma ${get_tok_str(tok, &tokc)} ignored')
	}
	return

	pragma_err:
	_tcc_error('malformed #pragma directive')
	return
}

fn preprocess(is_bof int) {
	vcc_trace('${@LOCATION}')
	s1 := tcc_state
	c := 0
	n := 0
	saved_parse_flags := 0

	buf := [1024]char{}
	q := &char(0)

	s := &Sym(0)
	saved_parse_flags = parse_flags
	parse_flags = 1 | 2 | 64 | 4 | (parse_flags & 8)

	vcc_trace_print('${@LOCATION} parse_flags=${parse_flags}')

	next_nomacro()
	redo:
	vcc_trace('${@LOCATION} ${tok}')
	match tok {
		int(Tcc_token.tok_define) { // case comp body kind=BinaryOperator is_enum=true
			vcc_trace('${@LOCATION}')
			pp_debug_tok = tok
			next_nomacro()
			pp_debug_symv = tok
			parse_define()
		}
		int(Tcc_token.tok_undef) { // case comp body kind=BinaryOperator is_enum=true
			vcc_trace('${@LOCATION}')
			pp_debug_tok = tok
			next_nomacro()
			pp_debug_symv = tok
			vcc_trace('${@LOCATION}')
			s = define_find(tok)
			if s {
				define_undef(s)
			}
		}
		int(Tcc_token.tok_include), int(Tcc_token.tok_include_next) {
			vcc_trace('${@LOCATION}')
			parse_include(s1, tok - Tcc_token.tok_include, 0)
		}
		int(Tcc_token.tok_ifndef) { // case comp body kind=BinaryOperator is_enum=true
			vcc_trace('${@LOCATION}')
			c = 1
			goto do_ifdef // id: 0x7fffd88c7650
		}
		int(Tcc_token.tok_if) { // case comp body kind=BinaryOperator is_enum=true
			vcc_trace('${@LOCATION}')
			c = expr_preprocess(s1)
			vcc_trace_print('${@LOCATION} - preprocess.2 c=${c}')
			goto do_if // id: 0x7fffd88c7850
		}
		int(Tcc_token.tok_ifdef) { // case comp body kind=BinaryOperator is_enum=true
			c = 0
			// RRRREG do_ifdef id=0x7fffd88c7650
			do_ifdef:
			vcc_trace('${@LOCATION}')
			next_nomacro()
			if tok < 256 {
				if c {
					_tcc_error("invalid argument for '#ifndef'")
				} else {
					_tcc_error("invalid argument for '#ifdef'")
				}
			}
			if is_bof {
				if c {
					file.ifndef_macro = tok
				}
			}
			if define_find(tok) || tok == Tcc_token.tok___has_include
				|| tok == Tcc_token.tok___has_include_next {
				c ^= 1
				vcc_trace_print('${@LOCATION} defined ${c}')
			}
			// RRRREG do_if id=0x7fffd88c7850
			do_if:
			vcc_trace('${@LOCATION}')
			if &s1.ifdef_stack_ptr[0] >= &char(&s1.ifdef_stack[0] + 64) {
				vcc_trace('${@LOCATION}')
				_tcc_error('memory full (ifdef)')
			}
			*s1.ifdef_stack_ptr++ = c
			vcc_trace_print('${@LOCATION} - preprocess.0 c=${c}')
			vcc_trace('${@LOCATION}')
			goto test_skip // id: 0x7fffd88c8390
		}
		int(Tcc_token.tok_else) { // case comp body kind=IfStmt is_enum=true
			vcc_trace('${@LOCATION}')
			if s1.ifdef_stack_ptr == &s1.ifdef_stack[0] {
				_tcc_error('#else without matching #if')
			}
			if s1.ifdef_stack_ptr[-1] & 2 {
				_tcc_error('#else after #else')
			}
			s1.ifdef_stack_ptr[-1] ^= 3
			c = s1.ifdef_stack_ptr[-1]
			goto test_else // id: 0x7fffd88c8a38
		}
		int(Tcc_token.tok_elif) { // case comp body kind=IfStmt is_enum=true
			vcc_trace('${@LOCATION}')
			if s1.ifdef_stack_ptr == &s1.ifdef_stack[0] {
				_tcc_error('#elif without matching #if')
			}
			c = s1.ifdef_stack_ptr[-1]
			if c > 1 {
				_tcc_error('#elif after #else')
			}
			if c == 1 {
				c = 0
			} else {
				c = expr_preprocess(s1)
				s1.ifdef_stack_ptr[-1] = c
				vcc_trace_print('${@LOCATION} - preprocess.1 c=${c}')
			}
			// RRRREG test_else id=0x7fffd88c8a38
			test_else:
			if s1.ifdef_stack_ptr == file.ifdef_stack_ptr + 1 {
				file.ifndef_macro = 0
				vcc_trace_print('${@LOCATION} - test_else')
			}
			// RRRREG test_skip id=0x7fffd88c8390
			test_skip:
			if !(c & 1) {
				vcc_trace_print('${@LOCATION} - preprocess_skip')
				preprocess_skip()
				vcc_trace('${@LOCATION}')
				is_bof = 0
				goto redo // id: 0x7fffd88c9688
			}
		}
		int(Tcc_token.tok_endif) { // case comp body kind=IfStmt is_enum=true
			vcc_trace('${@LOCATION}')
			if s1.ifdef_stack_ptr <= file.ifdef_stack_ptr {
				_tcc_error('#endif without matching #if')
			}
			vcc_trace('${@LOCATION}')
			s1.ifdef_stack_ptr--
			vcc_trace('${@LOCATION}')
			if file.ifndef_macro && s1.ifdef_stack_ptr == file.ifdef_stack_ptr {
				vcc_trace_print('${@LOCATION} stack_ptr')
				file.ifndef_macro_saved = file.ifndef_macro
				file.ifndef_macro = 0
				for tok != 10 {
					vcc_trace('${@LOCATION}')
					next_nomacro()
				}
				vcc_trace('${@LOCATION}')
				tok_flags |= 4
				goto the_end // id: 0x7fffd88c9f18
			}
		}
		205 { // case comp body kind=BinaryOperator is_enum=true
			vcc_trace('${@LOCATION}')
			n = C.strtoul(&char(tokc.str.data), &q, 10)
			vcc_trace('${@LOCATION}')
			goto _line_num // id: 0x7fffd88ca278
		}
		int(Tcc_token.tok_line) { // case comp body kind=CallExpr is_enum=true
			vcc_trace('${@LOCATION}')
			next()
			if tok != 194 {
				_line_err:
				_tcc_error('wrong #line format')
			}
			n = tokc.i
			vcc_trace_print('${@LOCATION} n=${n}')
			// RRRREG _line_num id=0x7fffd88ca278
			_line_num:
			vcc_trace('${@LOCATION}')
			next()
			if tok != 10 {
				if tok == 200 {
					if file.truefilename == file.filename {
						file.truefilename = tcc_strdup(file.filename)
					}
					q = &char(tokc.str.data)
					buf[0] = 0
					if !(q[0] == `/`) {
						pstrcpy(buf, sizeof(buf), file.truefilename)
						mut tmp := tcc_basename(buf)
						*tmp = 0
					}
					pstrcat(buf, sizeof(buf), q)
					vcc_trace('${@LOCATION}')
					tcc_debug_putfile(s1, buf)
				} else if parse_flags & 8 {
					vcc_trace_print('${@LOCATION} go out')
					unsafe {
						goto out
					}
				} else { // 3
					vcc_trace_print('${@LOCATION} line err')
					goto _line_err // id: 0x7fffd88ca4d0
				}
				n--
			}
			if file.fd > 0 {
				tcc_state.total_lines += file.line_num - n
			}
			file.line_num = n
		}
		int(Tcc_token.tok_error), int(Tcc_token.tok_warning) {
			vcc_trace('${@LOCATION}')
			q = buf
			vcc_trace('${@LOCATION}')
			c = skip_spaces()
			vcc_trace('${@LOCATION}')
			for c != `\n` && c != ch_eof {
				if (q - buf) < sizeof(buf) - 1 {
					unsafe {
						*q++ = c
					}
				}
				vcc_trace('${@LOCATION} ${rune(c)}')
				c = handle_stray_noerror(0)
			}
			*q = `\x00`
			if tok == Tcc_token.tok_error {
				_tcc_error('#error ${(&char(buf)).vstring()}')
			} else { // 3
				_tcc_warning('#warning ${(&char(buf)).vstring()}')
			}
		}
		int(Tcc_token.tok_pragma) { // case comp body kind=CallExpr is_enum=true
			vcc_trace('${@LOCATION}')
			pragma_parse(s1)
		}
		10 { // case comp body kind=GotoStmt is_enum=true
			vcc_trace('${@LOCATION}')
			goto the_end // id: 0x7fffd88c9f18
		}
		else {
			vcc_trace('${@LOCATION}')
			if saved_parse_flags & 8 {
				goto ignore // id: 0x7fffd88cc340
			}

			if tok == `!` && is_bof {
				goto ignore // id: 0x7fffd88cc340
			}
			_tcc_warning('Ignoring unknown preprocessing directive #${get_tok_str(tok,
				&tokc)}')
			// RRRREG ignore id=0x7fffd88cc340
			ignore:
			file.buf_ptr = parse_line_comment(file.buf_ptr - 1)
			goto the_end // id: 0x7fffd88c9f18
		}
	}

	out:
	vcc_trace_print('${@LOCATION} out')
	for tok != 10 {
		vcc_trace('${@LOCATION}')
		next_nomacro()
	}
	the_end:
	parse_flags = saved_parse_flags
	vcc_trace_print('${@LOCATION} the_end parse_flags.1 = ${parse_flags}')
}

fn parse_escape_string(outstr &CString, buf &u8, is_long int) {
	c := 0
	n := 0
	i := 0

	p := &u8(0)
	p = buf
	for ; true; {
		c = *p
		if c == `\x00` {
			break
		}
		if c == `\\` {
			p++
			c = *p
			match rune(c) {
				`0`, `1`, `2`, `3`, `4`, `5`, `6`, `7` {
					n = c - `0`
					p++
					c = *p
					if isoct(c) {
						n = n * 8 + c - `0`
						p++
						c = *p
						if isoct(c) {
							n = n * 8 + c - `0`
							p++
						}
					}
					c = n
					goto add_char_nonext // id: 0x7fffd88ce020
				}
				`x` { // case comp body kind=BinaryOperator is_enum=false
					i = 0
					goto parse_hex_or_ucn // id: 0x7fffd88ce140
				}
				`u` { // case comp body kind=BinaryOperator is_enum=false
					i = 4
					goto parse_hex_or_ucn // id: 0x7fffd88ce140
				}
				`U` { // case comp body kind=BinaryOperator is_enum=false
					i = 8
					goto parse_hex_or_ucn // id: 0x7fffd88ce140
					// RRRREG parse_hex_or_ucn id=0x7fffd88ce140
					parse_hex_or_ucn:
					p++
					n = 0
					for {
						c = *p
						if c >= `a` && c <= `f` {
							c = c - `a` + 10
						} else if c >= `A` && c <= `F` {
							c = c - `A` + 10
						} else if isnum(c) {
							c = c - `0`
						} else if i > 0 {
							expect(c'more hex digits in universal-character-name')
						} else { // 3
							goto add_hex_or_ucn // id: 0x7fffd88ceb38
						}
						n = n * 16 + c
						p++
						// while()
						i--
						if !i {
							break
						}
					}
					if is_long {
						add_hex_or_ucn:
						c = n
						goto add_char_nonext // id: 0x7fffd88ce020
					}
					cstr_u8cat(outstr, n)
					continue
				}
				`a` { // case comp body kind=BinaryOperator is_enum=false
					c = `\a`
				}
				`b` { // case comp body kind=BinaryOperator is_enum=false
					c = `\b`
				}
				`f` { // case comp body kind=BinaryOperator is_enum=false
					c = `\f`
				}
				`n` { // case comp body kind=BinaryOperator is_enum=false
					c = `\n`
				}
				`r` { // case comp body kind=BinaryOperator is_enum=false
					c = `\r`
				}
				`t` { // case comp body kind=BinaryOperator is_enum=false
					c = `\t`
				}
				`v` { // case comp body kind=BinaryOperator is_enum=false
					c = `\v`
				}
				`e` { // case comp body kind=IfStmt is_enum=false
					if !tcc_state.gnu_ext {
						goto invalid_escape // id: 0x7fffd88cf630
					}
					c = 27
				}
				`'`, `"`, `\\`, `?` {}
				else {
					// RRRREG invalid_escape id=0x7fffd88cf630
					invalid_escape:
					if c >= `!` && c <= `~` {
						_tcc_warning("unknown escape sequence: '\\${c}'")
					} else { // 3
						_tcc_warning("unknown escape sequence: '\\x${c}")
					}
				}
			}
		} else if is_long && c >= 128 {
			cont := 0
			skip := 0
			i = 0
			if c < 194 {
				skip = 1
				goto invalid_utf8_sequence // id: 0x7fffd88d0150
			} else if c <= 223 {
				cont = 1
				n = c & 31
			} else if c <= 239 {
				cont = 2
				n = c & 15
			} else if c <= 244 {
				cont = 3
				n = c & 7
			} else {
				skip = 1
				goto invalid_utf8_sequence // id: 0x7fffd88d0150
			}
			for i = 1; i <= cont; i++ {
				l := 128
				h := 191

				if i == 1 {
					match c {
						224 { // case comp body kind=BinaryOperator is_enum=false
							l = 160
						}
						237 { // case comp body kind=BinaryOperator is_enum=false
							h = 159
						}
						240 { // case comp body kind=BinaryOperator is_enum=false
							l = 144
						}
						244 { // case comp body kind=BinaryOperator is_enum=false
							h = 143
						}
						else {}
					}
				}
				if p[i] < l || p[i] > h {
					skip = i
					goto invalid_utf8_sequence // id: 0x7fffd88d0150
				}
				n = (n << 6) | (p[i] & 63)
			}
			p += 1 + cont
			c = n
			goto add_char_nonext // id: 0x7fffd88ce020
			invalid_utf8_sequence:
			_tcc_warning("ill-formed UTF-8 subsequence starting with: '\\x${c}'")
			c = 65533
			p += skip
			goto add_char_nonext // id: 0x7fffd88ce020
		}
		p++
		add_char_nonext:
		if !is_long {
			cstr_ccat(outstr, c)
		} else {
			cstr_wccat(outstr, c)
		}
	}
	if !is_long {
		cstr_ccat(outstr, `\x00`)
	} else { // 3
		cstr_wccat(outstr, `\x00`)
	}
}

fn parse_string(s &char, len int) {
	buf := [1000]u8{}
	p := unsafe { &buf[0] }

	is_long := 0
	sep := 0

	is_long = *s == `L`
	if is_long {
		unsafe {
			s++
			len--
		}
	}
	unsafe {
		sep = *s++
	}
	len -= 2
	if len >= sizeof(buf) {
		p = &char(tcc_malloc(len + 1))
	}
	C.memcpy(p, s, len)
	p[len] = 0
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
			tok = 192
			char_size = 1
		} else { // 3
			tok = 193
			char_size = sizeof(Nwchar_t)
		}
		n = tokcstr.len / char_size - 1
		if n < 1 {
			_tcc_error('empty character constant')
		}
		if n > 1 {
			tcc_state.warn_num = __offsetof(TCCState, warn_all) - __offsetof(TCCState, warn_none)
			_tcc_warning('multi-character character constant')
		}
		c = 0
		for i = c; i < n; i++ {
			if is_long {
				c = (&Nwchar_t(tokcstr.data))[i]
			} else { // 3
				c = (c << 8) | (&char(tokcstr.data))[i]
			}
		}
		tokc.i = c
	} else {
		tokc.str.size = tokcstr.len
		tokc.str.data = tokcstr.data
		if !is_long {
			tok = 200
		} else { // 3
			tok = 201
		}
	}
}

fn bn_lshift(bn &u32, shift int, or_val int) {
	i := 0
	v := u32(0)
	for i = 0; i < 2; i++ {
		v = bn[i]
		bn[i] = (v << shift) | or_val
		or_val = v >> (32 - shift)
	}
}

fn bn_zero(bn &u32) {
	i := 0
	for i = 0; i < 2; i++ {
		bn[i] = 0
	}
}

fn parse_number(p &char) {
	vcc_trace('${@LOCATION}')
	b := 0
	t := 0
	shift := 0
	frac_bits := 0
	s := 0
	exp_val := 0
	ch := 0

	q := &char(0)
	bn := [2]u32{}
	d := f64(0.0)
	q = &token_buf[0]
	vcc_trace('${@LOCATION}')
	unsafe {
		vcc_trace('${@LOCATION}')
		ch = *p++
		vcc_trace('${@LOCATION}')
		t = ch
		vcc_trace('${@LOCATION}')
		ch = *p++
		vcc_trace('${@LOCATION}')
		*q++ = t
		vcc_trace('${@LOCATION}')
		b = 10
	}
	vcc_trace('${@LOCATION}')
	if t == `.` {
		vcc_trace('${@LOCATION}')
		goto float_frac_parse // id: 0x7fffd88d6070
	} else if t == `0` {
		if ch == `x` || ch == `X` {
			unsafe {
				q--
				ch = *p++
				b = 16
			}
		} else if tcc_state.tcc_ext && (ch == `b` || ch == `B`) {
			unsafe {
				q--
				ch = *p++
				b = 2
			}
		}
	}
	for {
		if ch >= `a` && ch <= `f` {
			t = ch - `a` + 10
		} else if ch >= `A` && ch <= `F` {
			t = ch - `A` + 10
		} else if isnum(ch) {
			t = ch - `0`
		} else { // 3
			break
		}
		if t >= b {
			break
		}
		if q >= &token_buf[0] + 1024 {
			// RRRREG num_too_long id=0x7fffd88d7010
			num_too_long:
			_tcc_error('number too long')
		}
		unsafe {
			*q++ = ch
			ch = *p++
		}
	}
	vcc_trace('${@LOCATION}')
	if ch == `.` || ((ch == `e` || ch == `E`) && b == 10)
		|| ((ch == `p` || ch == `P`) && (b == 16 || b == 2)) {
		if b != 10 {
			*q = `\x00`
			if b == 16 {
				shift = 4
			} else { // 3
				shift = 1
			}
			bn_zero(bn)
			q = &token_buf[0]
			for 1 {
				unsafe {
					t = *q++
				}
				if t == `\x00` {
					break
				} else if t >= `a` {
					t = t - `a` + 10
				} else if t >= `A` {
					t = t - `A` + 10
				} else {
					t = t - `0`
				}
				bn_lshift(bn, shift, t)
			}
			frac_bits = 0
			if ch == `.` {
				unsafe {
					ch = *p++
				}
				for 1 {
					t = ch
					if t >= `a` && t <= `f` {
						t = t - `a` + 10
					} else if t >= `A` && t <= `F` {
						t = t - `A` + 10
					} else if t >= `0` && t <= `9` {
						t = t - `0`
					} else {
						break
					}
					if t >= b {
						_tcc_error('invalid digit')
					}
					bn_lshift(bn, shift, t)
					frac_bits += shift
					unsafe {
						ch = *p++
					}
				}
			}
			if ch != `p` && ch != `P` {
				expect(c'exponent')
			}
			unsafe {
				ch = *p++
			}
			s = 1
			exp_val = 0
			if ch == `+` {
				unsafe {
					ch = *p++
				}
			} else if ch == `-` {
				s = -1
				unsafe {
					ch = *p++
				}
			}
			if ch < `0` || ch > `9` {
				expect(c'exponent digits')
			}
			for ch >= `0` && ch <= `9` {
				exp_val = exp_val * 10 + ch - `0`
				unsafe {
					ch = *p++
				}
			}
			exp_val = exp_val * s
			d = f64(bn[1]) * 4294967296.0 + f64(bn[0])
			d = C.ldexp(d, exp_val - frac_bits)
			t = toup(ch)
			if t == `F` {
				unsafe {
					ch = *p++
				}
				tok = 202
				tokc.f = f32(d)
			} else if t == `L` {
				unsafe {
					ch = *p++
				}
				tok = 204
				tokc.ld = f64(d)
			} else {
				tok = 203
				tokc.d = d
			}
		} else {
			if ch == `.` {
				if q >= &token_buf[0] + 1024 {
					goto num_too_long // id: 0x7fffd88d7010
				}
				unsafe {
					*q++ = ch
					ch = *p++
				}
				float_frac_parse: for ch >= `0` && ch <= `9` {
					if q >= &token_buf[0] + 1024 {
						goto num_too_long // id: 0x7fffd88d7010
					}
					unsafe {
						*q++ = ch
						ch = *p++
					}
				}
			}
			if ch == `e` || ch == `E` {
				if q >= &token_buf[0] + 1024 {
					goto num_too_long // id: 0x7fffd88d7010
				}
				unsafe {
					*q++ = ch
					ch = *p++
				}
				if ch == `-` || ch == `+` {
					if q >= &token_buf[0] + 1024 {
						goto num_too_long // id: 0x7fffd88d7010
					}
					unsafe {
						*q++ = ch
						ch = *p++
					}
				}
				if ch < `0` || ch > `9` {
					expect(c'exponent digits')
				}
				for ch >= `0` && ch <= `9` {
					if q >= &token_buf[0] + 1024 {
						goto num_too_long // id: 0x7fffd88d7010
					}
					unsafe {
						*q++ = ch
						ch = *p++
					}
				}
			}
			*q = `\x00`
			t = toup(ch)
			C.errno = 0
			if t == `F` {
				unsafe {
					ch = *p++
				}
				tok = 202
				tokc.f = C.strtof(&token_buf[0], unsafe { nil })
			} else if t == `L` {
				unsafe {
					ch = *p++
				}
				tok = 204
				tokc.ld = C.strtold(&token_buf[0], unsafe { nil })
			} else {
				tok = 203
				tokc.d = C.strtod(&token_buf[0], unsafe { nil })
			}
		}
	} else {
		n := u64(0)
		n1 := u64(0)

		lcount := 0
		ucount := 0
		ov := 0

		p1 := &char(0)
		*q = `\x00`
		q = &token_buf[0]
		if b == 10 && *q == `0` {
			b = 8
			unsafe { q++ }
		}
		n = 0
		for 1 {
			unsafe {
				t = *q++
			}
			if t == `\x00` {
				break
			} else if t >= `a` {
				t = t - `a` + 10
			} else if t >= `A` {
				t = t - `A` + 10
			} else { // 3
				t = t - `0`
			}
			if t >= b {
				_tcc_error('invalid digit')
			}
			n1 = n
			n = n * b + t
			if n1 >= u64(0x1000000000000000) && n / b != n1 {
				ov = 1
			}
		}
		lcount = 0
		ucount = lcount
		p1 = p
		for {
			t = toup(ch)
			if t == `L` {
				if lcount >= 2 {
					_tcc_error("three 'l's in integer constant")
				}
				if lcount && *(p - 1) != ch {
					_tcc_error('incorrect integer suffix: ${p1}')
				}
				lcount++
				unsafe {
					ch = *p++
				}
			} else if t == `U` {
				if ucount >= 1 {
					_tcc_error("two 'u's in integer constant")
				}
				ucount++
				unsafe {
					ch = *p++
				}
			} else {
				break
			}
		}
		if ucount == 0 && b == 10 {
			if lcount <= (8 == 4) {
				if n >= u64(0x80000000) {
					lcount = int(8 == 4) + 1
				}
			}
			if n >= u64(0x8000000000000000) {
				ov = 1
				ucount = 1
			}
		} else {
			if lcount <= (8 == 4) {
				if n >= u64(0x100000000) {
					lcount = int(8 == 4) + 1
				} else if n >= 2147483648 {
					ucount = 1
				}
			}
			if n >= u64(0x8000000000000000) {
				ucount = 1
			}
		}
		if ov {
			_tcc_warning('integer constant overflow')
		}
		tok = 194
		if lcount {
			tok = 198
			if lcount == 2 {
				tok = 196
			}
		}
		if ucount {
			unsafe { tok++ }
		}
		tokc.i = n
	}
	if ch {
		_tcc_error('invalid number')
	}
}

fn next_nomacro1() {
	vcc_trace('${@LOCATION}')
	t := 0
	c := 0
	is_long := 0
	len := 0

	ts := &TokenSym(0)
	p := &u8(0)
	p1 := &u8(0)

	h := u32(0)
	p = file.buf_ptr
	nested := 0
	redo_no_start:
	c = u8(*p)

	vcc_trace_print('${@LOCATION} *p=${rune(c)} parse_flags=${parse_flags}')

	match rune(c) {
		` `, `\t` {
			vcc_trace('${@LOCATION}')
			tok = c
			p++
			maybe_space:
			vcc_trace_print('${@LOCATION} tok=${tok} maybe_space ${parse_flags}')
			if parse_flags & 16 {
				goto keep_tok_flags // id: 0x7fffd88e04d8
			}
			for isidnum_table[*p - (-1)] & 1 {
				p++
			}
			goto redo_no_start // id: 0x7fffd88e0230
		}
		`\f`, `\v`, `\r` {
			vcc_trace('${@LOCATION}')
			p++
			goto redo_no_start // id: 0x7fffd88e0230
		}
		`\\` { // case comp body kind=BinaryOperator is_enum=false
			vcc_trace('${@LOCATION} ${rune(c)} ${rune(*p)}')
			c = handle_stray(&p)
			vcc_trace('${@LOCATION} ${rune(c)} ${rune(*p)}')
			if c == `\\` {
				vcc_trace('${@LOCATION} ${rune(c)}')
				goto parse_simple // id: 0x7fffd88e0af8
			}
			vcc_trace('${@LOCATION} ${c == -1}')
			if c == (-1) {
				s1 := tcc_state
				if parse_flags & 4 && !(tok_flags & 8) {
					vcc_trace_print('${@LOCATION} ch_eof')
					tok_flags |= 8
					tok = 10
					vcc_trace('${@LOCATION}')
					goto keep_tok_flags // id: 0x7fffd88e04d8
				} else if !(parse_flags & 1) {
					vcc_trace_print('${@LOCATION} eof2')
					tok = tok_eof
					vcc_trace('${@LOCATION}')
				} else if voidptr(s1.ifdef_stack_ptr) != voidptr(file.ifdef_stack_ptr) {
					_tcc_error('missing #endif')
				} else if voidptr(s1.include_stack_ptr) == voidptr(&s1.include_stack[0]) {
					vcc_trace_print('${@LOCATION} eof')
					tok = tok_eof
					vcc_trace('${@LOCATION}')
				} else {
					vcc_trace('${@LOCATION}')
					tok_flags &= ~8
					if tok_flags & 4 {
						vcc_trace('${@LOCATION}')
						search_cached_include(s1, file.filename, 1).ifndef_macro = file.ifndef_macro_saved
						tok_flags &= ~4
					}
					vcc_trace('${@LOCATION}')
					tcc_debug_eincl(tcc_state)
					tcc_close()
					unsafe { s1.include_stack_ptr-- }
					p = file.buf_ptr
					if p == file.buffer {
						tok_flags = 2
					}
					tok_flags |= 1
					goto redo_no_start // id: 0x7fffd88e0230
				}
				vcc_trace('${@LOCATION} ${rune(c)}')
			} else {
				vcc_trace('${@LOCATION} ${rune(c)}')
				goto redo_no_start // id: 0x7fffd88e0230
			}
		}
		`\n` { // case comp body kind=UnaryOperator is_enum=false
			vcc_trace('${@LOCATION}')
			file.line_num++
			tok_flags |= 1
			p++
			// RRRREG maybe_newline id=0x7fffd88e20d0
			maybe_newline:
			if 0 == (parse_flags & 4) {
				vcc_trace_print('${@LOCATION} redostart')
				goto redo_no_start // id: 0x7fffd88e0230
			}
			tok = 10
			vcc_trace_print('${@LOCATION} linefeed ${parse_flags}')
			goto keep_tok_flags // id: 0x7fffd88e04d8
		}
		`#` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if tok_flags & 1 && parse_flags & 1 {
				vcc_trace('${@LOCATION} ${rune(c)}')
				file.buf_ptr = p
				preprocess(tok_flags & 2)
				p = file.buf_ptr
				vcc_trace('${@LOCATION} ${rune(c)}')
				goto maybe_newline // id: 0x7fffd88e20d0
			} else {
				if c == `#` {
					p++
					tok = 163
				} else {
					if parse_flags & 8 {
						vcc_trace('${@LOCATION} ${rune(c)}')
						p = parse_line_comment(p - 1)
						goto redo_no_start // id: 0x7fffd88e0230
					} else {
						tok = `#`
					}
				}
			}
		}
		`$` { // case comp body kind=IfStmt is_enum=false
			if !(isidnum_table[c - (-1)] & 2) || parse_flags & 8 {
				vcc_trace('${@LOCATION} ${rune(c)}')
				goto parse_simple // id: 0x7fffd88e0af8
			}
		}
		`a`, `b`, `c`, `d`, `e`, `f`, `g`, `h`, `i`, `j`, `k`, `l`, `m`, `n`, `o`, `p`, `q`, `r`,
		`s`, `t`, `u`, `v`, `w`, `x`, `y`, `z`, `A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`, `I`, `J`,
		`K`, `M`, `N`, `O`, `P`, `Q`, `R`, `S`, `T`, `U`, `V`, `W`, `X`, `Y`, `Z`, `_` {
			// RRRREG parse_ident_fast id=0x7fffd88e41e0
			parse_ident_fast:
			// vcc_trace('${@LOCATION}')
			p1 = p
			h = 1
			h = (h + (h << 5) + (h >> 27) + c)
			p++
			c = *p
			for isidnum_table[c - (-1)] & (2 | 4) {
				h = (h + (h << 5) + (h >> 27) + c)
				p++
				c = *p
			}
			// vcc_trace('${@LOCATION}')
			len = p - p1
			if c != `\\` {
				pts := &&TokenSym(0)
				h &= (16384 - 1)
				pts = unsafe { &&TokenSym(hash_ident) + h }
				// vcc_trace('${@LOCATION}')
				for {
					ts = *pts
					// vcc_trace('${@LOCATION}')
					if !ts {
						break
					}
					if ts.len == len && !C.memcmp(ts.str, p1, len) {
						goto token_found // id: 0x7fffd88e5370
					}
					pts = &(ts.hash_next)
				}
				vcc_trace('${@LOCATION}')
				ts = tok_alloc_new(pts, &char(p1), len)
				// RRRREG token_found id=0x7fffd88e5370
				token_found:
			} else {
				// vcc_trace('${@LOCATION}')
				cstr_reset(&tokcstr)
				cstr_cat(&tokcstr, &char(p1), len)
				p--
				{
					p++
					c = *p
					if c == `\\` {
						c = handle_stray(&p)
					}
				}
				// RRRREG parse_ident_slow id=0x7fffd88e6130

				// vcc_trace('${@LOCATION}')
				parse_ident_slow: for isidnum_table[c - (-1)] & (2 | 4) {
					cstr_ccat(&tokcstr, c)
					{
						p++
						c = *p
						if c == `\\` {
							c = handle_stray(&p)
						}
					}
				}
				ts = tok_alloc(tokcstr.data, tokcstr.len)
			}
			tok = ts.tok
			// vcc_trace('${@LOCATION}')
		}
		`L` { // case comp body kind=BinaryOperator is_enum=false
			// vcc_trace('${@LOCATION}')
			t = p[1]
			if t != `\\` && t != `'` && t != `"` {
				// vcc_trace('${@LOCATION}')
				goto parse_ident_fast // id: 0x7fffd88e41e0
			} else {
				// vcc_trace('${@LOCATION}')
				{
					p++
					c = *p
					if c == `\\` {
						c = handle_stray(&p)
					}
				}
				if c == `'` || c == `"` {
					is_long = 1
					goto str_const // id: 0x7fffd88e6b20
				} else {
					cstr_reset(&tokcstr)
					cstr_ccat(&tokcstr, `L`)
					goto parse_ident_slow // id: 0x7fffd88e6130
				}
			}
		}
		`0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9` {
			vcc_trace('${@LOCATION}')
			t = c
			{
				p++
				c = *p
				if c == `\\` {
					c = handle_stray(&p)
				}
			}
			// RRRREG parse_num id=0x7fffd88e7498
			parse_num:
			vcc_trace('${@LOCATION}')
			cstr_reset(&tokcstr)
			for {
				vcc_trace('${@LOCATION}')
				cstr_ccat(&tokcstr, t)
				if !(isidnum_table[c - (-1)] & (2 | 4) || c == `.`
					|| ((c == `+` || c == `-`) && (((t == `e` || t == `E`) && !(parse_flags & 8
					&& (&char(tokcstr.data))[0] == `0` && toup((&char(tokcstr.data))[1]) == `X`))
					|| t == `p` || t == `P`))) {
					break
				}
				t = c
				{
					p++
					c = *p
					if c == `\\` {
						vcc_trace('${@LOCATION}')
						c = handle_stray(&p)
					}
				}
			}
			cstr_ccat(&tokcstr, `\x00`)
			tokc.str.size = tokcstr.len
			tokc.str.data = tokcstr.data
			tok = 205
		}
		`.` {
			// case comp stmt
			vcc_trace('${@LOCATION}')
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}
			if isnum(c) {
				t = `.`
				goto parse_num // id: 0x7fffd88e7498
			} else if isidnum_table[`.` - (-1)] & 2 && isidnum_table[c - (-1)] & (2 | 4) {
				c = `.`
				p--
				*p = c
				goto parse_ident_fast // id: 0x7fffd88e41e0
			} else if c == `.` {
				{
					p++
					c = *p
					if c == `\\` {
						c = handle_stray(&p)
					}
				}
				if c == `.` {
					p++
					tok = 161
				} else {
					p--
					*p = `.`
					tok = `.`
				}
			} else {
				tok = `.`
			}
		}
		`'`, `"` {
			vcc_trace('${@LOCATION}')
			is_long = 0
			// RRRREG str_const id=0x7fffd88e6b20
			str_const:
			cstr_reset(&tokcstr)
			if is_long {
				cstr_ccat(&tokcstr, `L`)
			}
			cstr_ccat(&tokcstr, c)
			p = parse_pp_string(p, c, &tokcstr)
			cstr_ccat(&tokcstr, c)
			cstr_ccat(&tokcstr, `\x00`)
			tokc.str.size = tokcstr.len
			tokc.str.data = tokcstr.data
			tok = 206
		}
		`<` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 158
			} else if c == `<` {
				{
					p++
					c = *p
					if c == `\\` {
						c = handle_stray(&p)
					}
				}
				if c == `=` {
					p++
					tok = 184
				} else {
					tok = `<`
				}
			} else {
				tok = 156
			}
		}
		`>` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 157
			} else if c == `>` {
				{
					p++
					c = *p
					if c == `\\` {
						c = handle_stray(&p)
					}
				}
				if c == `=` {
					p++
					tok = 185
				} else {
					tok = `>`
				}
			} else {
				tok = 159
			}
		}
		`&` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `&` {
				p++
				tok = 144
			} else if c == `=` {
				p++
				tok = 181
			} else {
				tok = `&`
			}
		}
		`|` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `|` {
				p++
				tok = 145
			} else if c == `=` {
				p++
				tok = 182
			} else {
				tok = `|`
			}
		}
		`+` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `+` {
				p++
				tok = 130
			} else if c == `=` {
				p++
				tok = 176
			} else {
				tok = `+`
			}
		}
		`-` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `-` {
				p++
				tok = 128
			} else if c == `=` {
				p++
				tok = 177
			} else if c == `>` {
				p++
				tok = 160
			} else {
				tok = `-`
			}
		}
		`!` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 149
			} else {
				tok = `!`
			}
		}
		`=` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 148
			} else {
				tok = `=`
			}
		}
		`*` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 178
			} else {
				tok = `*`
			}
		}
		`%` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 180
			} else {
				tok = `%`
			}
		}
		`^` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `=` {
				p++
				tok = 183
			} else {
				tok = `^`
			}
		}
		`/` {
			vcc_trace('${@LOCATION}')
			// case comp stmt
			p++
			c = *p
			if c == `\\` {
				c = handle_stray(&p)
			}

			if c == `*` {
				p = parse_comment(p)
				tok = ` `
				goto maybe_space // id: 0x7fffd88e0560
			} else if c == `/` {
				p = parse_line_comment(p)
				tok = ` `
				goto maybe_space // id: 0x7fffd88e0560
			} else if c == `=` {
				p++
				tok = 179
			} else {
				tok = `/`
			}
		}
		`(`, `)`, `[`, `]`, `{`, `}`, `,`, `;`, `:`, `?`, `~`, `@` {
			// vcc_trace('${@LOCATION}')
			// RRRREG parse_simple id=0x7fffd88e0af8
			parse_simple:
			vcc_trace_print('${@LOCATION} parse_simple ${c}')
			tok = c
			p++
		}
		else {
			// vcc_trace('${@LOCATION}')
			if c >= 128 && c <= 255 {
				goto parse_ident_fast // id: 0x7fffd88e41e0
			}
			if parse_flags & 8 {
				goto parse_simple // id: 0x7fffd88e0af8
			}
			_tcc_error('unrecognized character \\x${c}')
		}
	}
	tok_flags = 0
	keep_tok_flags:
	file.buf_ptr = p
	vcc_trace_print('${@LOCATION} p=${int(*p)}')
}

fn macro_arg_subst(nested_list &&Sym, macro_str &int, args &Sym) &int {
	t := 0
	t0 := 0
	t1 := 0
	spc := 0
	st := &int(0)
	s := &Sym(0)
	cval := CValue{}
	str := TokenString{}

	tok_str_new(&str)
	t0 = 0
	t1 = 0

	for {
		tok_get_macro(mut &t, mut &macro_str, mut &cval)
		vcc_trace_print('${@LOCATION} t=${t}')
		if !t {
			break
		}
		if t == `#` {
			vcc_trace('${@LOCATION}')
			tok_get_macro(mut &t, mut &macro_str, mut &cval)
			if !t {
				goto bad_stringy // id: 0x7fffd88f10a0
			}
			s = sym_find2(args, t)
			if s != unsafe { nil } {
				vcc_trace('${@LOCATION}')
				cstr_reset(&tokcstr)
				cstr_ccat(&tokcstr, `"`)
				st = s.d
				spc = 0
				for *st >= 0 {
					vcc_trace('${@LOCATION}')
					tok_get_macro(mut &t, mut &st, mut &cval)
					if t != 165 && 0 == check_space(t, &spc) {
						s2 := get_tok_str(t, &cval)
						for *s2 {
							vcc_trace('${@LOCATION}')
							if t == 206 && *s2 != `'` {
								add_char(&tokcstr, *s2)
							} else { // 3
								cstr_ccat(&tokcstr, *s2)
							}
							unsafe { s2++ }
						}
					}
				}
				vcc_trace('${@LOCATION} -= spc')
				tokcstr.go_back(spc)
				cstr_ccat(&tokcstr, `"`)
				cstr_ccat(&tokcstr, `\x00`)
				cval.str.size = tokcstr.len
				cval.str.data = tokcstr.data
				vcc_trace('${@LOCATION}')
				tok_str_add2(&str, 206, &cval)
			} else {
				// RRRREG bad_stringy id=0x7fffd88f10a0
				bad_stringy:
				expect(c"macro parameter after '#'")
			}
		} else if t >= 256 {
			vcc_trace('${@LOCATION}')
			s = sym_find2(args, t)
			if s != unsafe { nil } {
				st = s.d
				if *macro_str == 166 || t1 == 166 {
					if t1 == 166 && t0 == `,` && tcc_state.gnu_ext && s.type_.t {
						if *st <= 0 {
							str.len -= 2
							vcc_trace('${@LOCATION} -= 2')
						} else {
							str.len--
							vcc_trace('${@LOCATION} len--')
							goto add_var // id: 0x7fffd88f33c0
						}
					} else {
						if *st <= 0 {
							tok_str_add(&str, 164)
						}
					}
				} else {
					// RRRREG add_var id=0x7fffd88f33c0
					add_var:
					vcc_trace_print('${@LOCATION} add_var')
					if !s.next {
						str2 := TokenString{}
						sym_push2(&s.next, s.v, s.type_.t, 0)
						tok_str_new(&str2)
						macro_subst(&str2, nested_list, st)
						tok_str_add(&str2, 0)
						s.next.d = str2.str
						vcc_trace_print('${@LOCATION} st2')
					}
					st = s.next.d
				}
				vcc_trace_print('${@LOCATION} t2')
				for {
					t2 := 0
					tok_get_macro(mut &t2, mut &st, mut &cval)
					if t2 <= 0 {
						break
					}
					tok_str_add2(&str, t2, &cval)
				}
			} else {
				vcc_trace_print('${@LOCATION} else ${t} ${*macro_str}')
				tok_str_add(&str, t)
			}
		} else {
			tok_str_add2(&str, t, &cval)
			vcc_trace_print('${@LOCATION} else2')
		}
		t0 = t1
		t1 = t
	}
	tok_str_add(&str, 0)
	return str.str
}

const ab_month_name = [c'Jan', c'Feb', c'Mar', c'Apr', c'May', c'Jun', c'Jul', c'Aug', c'Sep',
	c'Oct', c'Nov', c'Dec']!

fn paste_tokens(t1 int, v1 &CValue, t2 int, v2 &CValue) int {
	vcc_trace('${@LOCATION}')
	n := 0
	ret := 1

	cstr_reset(&tokcstr)
	if t1 != 164 {
		cstr_cat(&tokcstr, get_tok_str(t1, v1), -1)
	}
	n = tokcstr.len
	if t2 != 164 {
		cstr_cat(&tokcstr, get_tok_str(t2, v2), -1)
	}
	cstr_ccat(&tokcstr, `\x00`)
	tcc_open_bf(tcc_state, c':paste:', tokcstr.len)
	C.memcpy(file.buffer, tokcstr.data, tokcstr.len)
	tok_flags = 0
	for {
		next_nomacro1()
		if 0 == *file.buf_ptr {
			break
		}
		if is_space(tok) {
			continue
		}
		_tcc_warning('pasting "${file.buffer}" and "${file.buffer + n}" does not give a valid preprocessing token')
		ret = 0
		break
	}
	tcc_close()
	vcc_trace('${@LOCATION}')
	return ret
}

fn macro_twosharps(ptr0 &int) &int {
	vcc_trace('${@LOCATION}')
	t := 0
	cval := CValue{}
	macro_str1 := TokenString{}
	start_of_nosubsts := -1
	ptr := &int(0)
	for ptr = ptr0; true; {
		// vcc_trace('${@LOCATION}')
		tok_get_macro(mut &t, mut &ptr, mut &cval)
		// vcc_trace('${@LOCATION}')
		if t == 166 {
			vcc_trace('${@LOCATION}')
			break
		}
		if t == 0 {
			vcc_trace('${@LOCATION}')
			return unsafe { nil }
		}
	}
	// vcc_trace('${@LOCATION}')
	tok_str_new(&macro_str1)
	// vcc_trace('${@LOCATION}')
	for ptr = ptr0; true; {
		// vcc_trace('${@LOCATION}')
		tok_get_macro(mut &t, mut &ptr, mut &cval)
		// vcc_trace('${@LOCATION}')
		if t == 0 {
			break
		}
		if t == 166 {
			continue
		}
		for *ptr == 166 {
			t1 := 0
			cv1 := CValue{}
			if start_of_nosubsts >= 0 {
				macro_str1.len = start_of_nosubsts
			}
			ptr++
			t1 = *ptr
			for t1 == 165 {
				ptr++
				t1 = *ptr
			}
			if t1 && t1 != 166 {
				// vcc_trace('${@LOCATION}')
				tok_get_macro(mut &t1, mut &ptr, mut &cv1)
				// vcc_trace('${@LOCATION}')
				if t != 164 || t1 != 164 {
					// vcc_trace('${@LOCATION}')
					if paste_tokens(t, &cval, t1, &cv1) {
						t = tok
						cval = tokc
					} else {
						// vcc_trace('${@LOCATION}')
						tok_str_add2(&macro_str1, t, &cval)
						t = t1
						cval = cv1
					}
				}
			}
		}
		if t == 165 {
			if start_of_nosubsts < 0 {
				start_of_nosubsts = macro_str1.len
			}
		} else {
			start_of_nosubsts = -1
		}
		if t != 164 {
			tok_str_add2(&macro_str1, t, &cval)
		}
	}
	// vcc_trace('${@LOCATION}')
	tok_str_add(&macro_str1, 0)
	vcc_trace('${@LOCATION}')
	return macro_str1.str
}

fn next_argstream(nested_list &&Sym, ws_str &TokenString) int {
	vcc_trace('${@LOCATION}')
	t := 0
	p := &int(0)
	sa := &Sym(0)
	for {
		// vcc_trace('${@LOCATION}')
		if macro_ptr {
			// vcc_trace('${@LOCATION}')
			p = macro_ptr
			// vcc_trace('${@LOCATION}')
			t = *p
			vcc_trace_print('${@LOCATION} t=${t}')
			if ws_str {
				vcc_trace_print('${@LOCATION} ws_str!=null t=${t}')
				for is_space(t) || 10 == t {
					// vcc_trace('${@LOCATION}')
					tok_str_add(ws_str, t)
					*p++
					t = *p
				}
			}
			if t == 0 {
				vcc_trace_print('${@LOCATION} endmacro')
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
		} else {
			p2 := &u8(file.buf_ptr)
			ch := handle_bs(&p2)
			if ws_str {
				vcc_trace_print('${@LOCATION} space - ${ch}')
				for is_space(ch) || ch == `\n` || ch == `/` {
					if ch == `/` {
						c := 0
						{
							p2++
							c = *p2
							if c == `\\` {
								c = handle_stray(&p2)
							}
						}
						if c == `*` {
							p2 = parse_comment(p2) - 1
						} else if c == `/` {
							p2 = parse_line_comment(p2) - 1
						} else {
							p2--
							*p2 = ch
							break
						}
						ch = ` `
					}
					if ch == `\n` {
						file.line_num++
					}
					if !(ch == `\f` || ch == `\v` || ch == `\r`) {
						tok_str_add(ws_str, ch)
					}
					{
						p2++
						ch = *p2
						if ch == `\\` {
							ch = handle_stray(&p2)
						}
					}
				}
			}
			file.buf_ptr = p2
			t = ch
		}
		if ws_str {
			vcc_trace_print('${@LOCATION} space end - ${t}')
			return t
		}
		next_nomacro()
		vcc_trace('${@LOCATION}')
		return tok
	}
	vcc_trace('${@LOCATION}')
	return 0
}

fn macro_subst_tok(tok_str &TokenString, nested_list &&Sym, s &Sym) int {
	vcc_trace_print('${@LOCATION}')
	args := &Sym(0)
	sa := &Sym(0)
	sa1 := &Sym(0)
	parlevel := 0
	t := 0
	t1 := 0
	spc := 0

	str := TokenString{}
	cstrval := &char(0)
	cval := CValue{}
	buf := [32]char{}
	// vcc_trace('${@LOCATION}')
	if tok == Tcc_token.tok___line__ || tok == Tcc_token.tok___counter__ {
		// vcc_trace('${@LOCATION}')
		t = if tok == Tcc_token.tok___line__ { file.line_num } else { pp_counter++ }
		C.snprintf(buf, sizeof(buf), c'%d', t)
		vcc_trace('${@LOCATION}')
		cstrval = buf
		t1 = 205
		goto add_cstr1 // id: 0x7fffd88fccf8
	} else if tok == Tcc_token.tok___file__ {
		// vcc_trace('${@LOCATION}')
		cstrval = file.filename
		goto add_cstr // id: 0x7fffd88fced0
	} else if tok == Tcc_token.tok___date__ || tok == Tcc_token.tok___time__ {
		///vcc_trace('${@LOCATION}')
		ti := u64(0)
		tm := &C.tm(0)
		C.time(&ti)
		tm = C.localtime(&ti)
		if tok == Tcc_token.tok___date__ {
			C.snprintf(buf, sizeof(buf), c'%s %2d %d', ab_month_name[tm.tm_mon], tm.tm_mday,
				tm.tm_year + 1900)
		} else {
			C.snprintf(buf, sizeof(buf), c'%02d:%02d:%02d', tm.tm_hour, tm.tm_min, tm.tm_sec)
		}
		cstrval = buf
		// RRRREG add_cstr id=0x7fffd88fced0
		add_cstr:
		t1 = 200
		// RRRREG add_cstr1 id=0x7fffd88fccf8
		add_cstr1:
		cstr_reset(&tokcstr)
		cstr_cat(&tokcstr, cstrval, 0)
		cval.str.size = tokcstr.len
		cval.str.data = tokcstr.data
		tok_str_add2(tok_str, t1, &cval)
	} else if s.d {
		// vcc_trace('${@LOCATION}')
		saved_parse_flags := parse_flags
		joined_str := &int(unsafe { nil })
		// vcc_trace('${@LOCATION}')
		mstr := &int(s.d)
		// vcc_trace('${@LOCATION}')
		if s.type_.t == 1 {
			ws_str := TokenString{}
			// vcc_trace('${@LOCATION}')
			tok_str_new(&ws_str)
			spc = 0
			vcc_trace_print('${@LOCATION} - parseflag before ${parse_flags}')
			parse_flags |= 16 | 4 | 32
			vcc_trace_print('${@LOCATION} - parseflag after ${parse_flags}')
			t = next_argstream(nested_list, &ws_str)
			if t != `(` {
				parse_flags = saved_parse_flags
				vcc_trace_print('${@LOCATION} - parseflag.saved ${parse_flags}')
				// vcc_trace('${@LOCATION}')
				tok_str_add(tok_str, tok)
				if parse_flags & 16 {
					i := 0
					for i = 0; i < ws_str.len; i++ {
						tok_str_add(tok_str, ws_str.str[i])
					}
				}
				if ws_str.len && ws_str.str[ws_str.len - 1] == `\n` {
					tok_flags |= 1
					vcc_trace_print('${@LOCATION} - parseflag.nl ${tok_flags}')
				}
				// vcc_trace('${@LOCATION}')
				tok_str_free_str(ws_str.str)
				return 0
			} else {
				// vcc_trace('${@LOCATION}')
				tok_str_free_str(ws_str.str)
			}
			// vcc_trace('${@LOCATION}')
			for {
				next_nomacro()
				// while()
				if !(is_space(tok)) {
					break
				}
			}
			// vcc_trace('${@LOCATION}')
			args = unsafe { nil }
			sa = s.next
			// vcc_trace('${@LOCATION}')
			for {
				for {
					// vcc_trace('${@LOCATION}')
					next_argstream(nested_list, unsafe { nil })
					// while()
					if !(is_space(tok) || 10 == tok) {
						break
					}
				}
				// RRRREG empty_arg id=0x7fffd88ffdc8
				empty_arg:
				if !args && !sa && tok == `)` {
					break
				}
				if !sa {
					_tcc_error("macro '${get_tok_str(s.v, unsafe { nil })}' used with too many args")
				}
				tok_str_new(&str)
				parlevel = 0
				spc = parlevel
				for (parlevel > 0 || (tok != `)` && (tok != `,` || sa.type_.t))) {
					if tok == tok_eof || tok == 0 {
						break
					}
					if tok == `(` {
						parlevel++
					} else if tok == `)` {
						parlevel--
					}
					if tok == 10 {
						tok = ` `
					}
					// vcc_trace('${@LOCATION}')
					if !check_space(tok, &spc) {
						tok_str_add2(&str, tok, &tokc)
					}
					// vcc_trace('${@LOCATION}')
					next_argstream(nested_list, unsafe { nil })
				}
				if parlevel {
					expect(c')')
				}
				str.len -= spc
				tok_str_add(&str, -1)
				tok_str_add(&str, 0)
				vcc_trace('${@LOCATION}')
				sa1 = sym_push2(&args, sa.v & ~sym_field, sa.type_.t, 0)
				vcc_trace('${@LOCATION}')
				sa1.d = str.str
				vcc_trace('${@LOCATION}')
				sa = sa.next
				if tok == `)` {
					if sa != unsafe { nil } && sa.type_.t && tcc_state.gnu_ext {
						// vcc_trace('${@LOCATION}')
						vcc_trace('${@LOCATION}')
						goto empty_arg // id: 0x7fffd88ffdc8
					}
					vcc_trace('${@LOCATION}')
					break
				}
				if tok != `,` {
					expect(c',')
				}
			}
			if sa {
				_tcc_error("macro '${get_tok_str(s.v, unsafe { nil })}' used with too few args")
			}
			vcc_trace('${@LOCATION}')
			mstr = macro_arg_subst(nested_list, mstr, args)
			sa = args
			vcc_trace('${@LOCATION}')
			for sa {
				vcc_trace('${@LOCATION}')
				sa1 = sa.prev
				vcc_trace('${@LOCATION}')
				tok_str_free_str(sa.d)
				if sa.next {
					vcc_trace('${@LOCATION}')
					tok_str_free_str(sa.next.d)
					sym_free(sa.next)
				}
				vcc_trace('${@LOCATION}')
				sym_free(sa)
				sa = sa1
			}
			parse_flags = saved_parse_flags
			vcc_trace_print('${@LOCATION} saved.0 ${parse_flags}')
		}
		vcc_trace('${@LOCATION}')
		sym_push2(nested_list, s.v, 0, 0)
		vcc_trace('${@LOCATION}')
		parse_flags = saved_parse_flags
		vcc_trace_print('${@LOCATION} saved.1 ${parse_flags}')
		joined_str = macro_twosharps(mstr)
		vcc_trace('${@LOCATION}')
		macro_subst(tok_str, nested_list, if joined_str { joined_str } else { mstr })
		// vcc_trace('${@LOCATION}')
		sa1 = *nested_list
		*nested_list = sa1.prev
		// vcc_trace('${@LOCATION}')
		sym_free(sa1)
		// vcc_trace('${@LOCATION}')
		if joined_str {
			vcc_trace('${@LOCATION}')
			tok_str_free_str(joined_str)
		}
		// vcc_trace('${@LOCATION}')
		if mstr != s.d {
			vcc_trace('${@LOCATION}')
			tok_str_free_str(mstr)
			// vcc_trace('${@LOCATION}')
		}
	}
	vcc_trace('${@LOCATION}')
	return 0
}

fn macro_subst(tok_str &TokenString, nested_list &&Sym, macro_str &int) {
	s := &Sym(0)
	t := 0
	spc := 0
	nosubst := 0
	cval := CValue{}
	spc = 0
	nosubst = 0

	vcc_trace_print('${@LOCATION} - begin')

	for {
		tok_get_macro(mut &t, mut &macro_str, mut &cval)
		vcc_trace_print('${@LOCATION} t=${t}')
		if t <= 0 {
			break
		}
		if t >= 256 && 0 == nosubst {
			// vcc_trace('${@LOCATION}')
			s = define_find(t)
			if s == unsafe { nil } {
				vcc_trace_print('${@LOCATION} - sym not found')
				goto no_subst // id: 0x7fffd8904130
			}
			if sym_find2(*nested_list, t) {
				tok_str_add2(tok_str, 165, unsafe { nil })
				vcc_trace_print('${@LOCATION} - nosubsts')
				goto no_subst // id: 0x7fffd8904130
			}
			{
				vcc_trace_print('${@LOCATION} a')
				str := tok_str_alloc()
				str.str = &int(macro_str)
				vcc_trace_print('${@LOCATION} b')
				begin_macro(str, 2)
				tok = t
				vcc_trace_print('${@LOCATION} c')
				macro_subst_tok(tok_str, nested_list, s)
				vcc_trace_print('${@LOCATION} d')
				if voidptr(macro_stack) != voidptr(str) {
					break
				}
				macro_str = macro_ptr
				vcc_trace_print('${@LOCATION} e')
				end_macro()
			}
			if tok_str.len {
				t = tok_str.str[tok_str.lastlen]
				spc = is_space(t)
			}
		} else {
			// RRRREG no_subst id=0x7fffd8904130
			no_subst:
			if !check_space(t, &spc) {
				// vcc_trace('${@LOCATION}')
				tok_str_add2(tok_str, t, &cval)
				// vcc_trace('${@LOCATION}')
			}
			// vcc_trace('${@LOCATION}')
			if nosubst {
				if nosubst > 1 && (spc || ((1 + nosubst++) == 3 && t == `(`)) {
					continue
				}
				nosubst = 0
			}
			if t == 165 {
				nosubst = 1
			}
		}
		if t == Tcc_token.tok_defined && pp_expr {
			nosubst = 2
		}
	}
	vcc_trace('${@LOCATION}')
}

fn next_nomacro() {
	vcc_trace('${@LOCATION}')
	t := 0
	if macro_ptr {
		redo:
		// vcc_trace('${@LOCATION}')
		t = *macro_ptr
		vcc_trace_print('${@LOCATION} *macro_ptr=${t}')
		// vcc_trace('${@LOCATION}')
		if (t >= 192 && t <= 207) {
			vcc_trace_print('${@LOCATION} *macro_ptr=${t} has_value')
			tok_get(&tok, &macro_ptr, &tokc)
			if t == 207 {
				file.line_num = tokc.i
				vcc_trace_print('${@LOCATION} *macro_ptr=${t} redo1')
				goto redo // id: 0x7fffd8905950
			}
		} else {
			vcc_trace('${@LOCATION}')
			macro_ptr++
			if t < 256 {
				vcc_trace_print('${@LOCATION} *macro_ptr=${t} t < tok_ident ${(parse_flags & 16)} ${(isidnum_table[t - ch_eof] & 1)}')
				if (!(parse_flags & 16)) && isidnum_table[t - ch_eof] & 1 {
					vcc_trace_print('${@LOCATION} *macro_ptr=${t} redo2')
					goto redo // id: 0x7fffd8905950
				}
			}
			tok = t
			vcc_trace_print('${@LOCATION} tok=${t}')
		}
		// vcc_trace('${@LOCATION}')
	} else {
		vcc_trace_print('${@LOCATION} call nomacro1')
		next_nomacro1()
		// vcc_trace('${@LOCATION}')
	}
	vcc_trace('${@LOCATION}')
}

fn next() {
	t := 0
	n := 0
	redo:
	n++
	vcc_trace_print('${@LOCATION} ${tok} [${n}] ${int(file.buf_ptr[0])}')
	next_nomacro()
	t = tok
	if macro_ptr != unsafe { nil } {
		if !(t >= 192 && t <= 207) {
			if t == 165 {
				vcc_trace('${@LOCATION}')
				goto redo // id: 0x7fffd8906568
			} else if t == 0 {
				vcc_trace('${@LOCATION}')
				end_macro()
				vcc_trace('${@LOCATION}')
				goto redo // id: 0x7fffd8906568
			} else if t == `\\` {
				vcc_trace('${@LOCATION}')
				if !(parse_flags & 32) {
					_tcc_error("stray '\\' in program")
				}
			}
			vcc_trace('${@LOCATION}')
			return
		}
	} else if t >= 256 && parse_flags & 1 {
		s := define_find(t)
		if s != unsafe { nil } {
			vcc_trace('${@LOCATION}')
			nested_list := &Sym(unsafe { nil })
			vcc_trace('${@LOCATION} ${tokstr_buf.len}')
			tokstr_buf.len = 0
			vcc_trace('${@LOCATION}')
			macro_subst_tok(&tokstr_buf, &nested_list, s)
			vcc_trace('${@LOCATION}')
			tok_str_add(&tokstr_buf, 0)
			vcc_trace('${@LOCATION}')
			begin_macro(&tokstr_buf, 0)
			vcc_trace('${@LOCATION}')
			goto redo // id: 0x7fffd8906568
		}
		vcc_trace('${@LOCATION}')
		return
	}
	if t == 205 {
		if parse_flags & 2 {
			vcc_trace_print('${@LOCATION} parse_number')
			parse_number(&char(tokc.str.data))
		}
	} else if t == 206 {
		if parse_flags & 64 {
			vcc_trace_print('${@LOCATION} parse_string')
			parse_string(&char(tokc.str.data), tokc.str.size - 1)
		}
	}
	vcc_trace('${@LOCATION}')
}

fn unget_tok(last_tok int) {
	vcc_trace_print('${@LOCATION}')
	str := tok_str_alloc()
	tok_str_add2(str, tok, &tokc)
	tok_str_add(str, 0)
	begin_macro(str, 1)
	tok = last_tok
}

const target_os_defs = ['__linux__', '__linux', '__unix__', '__unix']

fn putdef(cs &strings.Builder, p string) {
	vcc_trace('${@LOCATION} - #define ${p}')
	// cs.write_string('#define ${p}${' 1'[int(!!C.strchr(p.str, ` `)) * 2]}\n')
	cs.write_string('#define ${p} 1\n')
}

fn putdefs(cs &CString, strs []string) {
	vcc_trace('${@LOCATION}')
	for str in strs {
		putdef(cs, str)
	}
}

fn tcc_predefs(s1 &TCCState, cs &CString, is_asm int) {
	vcc_trace('${@LOCATION}')
	a := 0
	b := 0
	c := 0

	C.sscanf(c'0_9_28', c'%d_%d_%d', &a, &b, &c)
	cstr_printf(cs, '#define __TINYC__ ${a * 10000 + b * 100 + c}\n')
	putdefs(cs, target_machine_defs)
	putdefs(cs, target_os_defs)
	if is_asm {
		putdef(cs, '__ASSEMBLER__')
	}
	if s1.output_type == 5 {
		putdef(cs, '__TCC_PP__')
	}
	if s1.output_type == 1 {
		putdef(cs, '__TCC_RUN__')
	}
	if s1.do_backtrace {
		putdef(cs, '__TCC_BACKTRACE__')
	}
	if s1.do_bounds_check {
		putdef(cs, '__TCC_BCHECK__')
	}
	if s1.char_is_unsigned {
		putdef(cs, '__CHAR_UNSIGNED__')
	}
	if s1.optimize > 0 {
		putdef(cs, '__OPTIMIZE__')
	}
	if s1.option_pthread {
		putdef(cs, '_REENTRANT')
	}
	if s1.leading_underscore {
		putdef(cs, '__leading_underscore')
	}
	cstr_printf(cs, '#define __SIZEOF_POINTER__ 8\n')
	cstr_printf(cs, '#define __SIZEOF_LONG__ 8\n')
	if !is_asm {
		putdef(cs, '__STDC__')
		cstr_printf(cs, '#define __STDC_VERSION__ ${s1.cversion}L\n')
		cstr_cat(cs, c'#include <tccdefs.h>\n', -1)
		// cstr_cat(cs, c'#define __SIZE_TYPE__ unsigned long\n#define __PTRDIFF_TYPE__ long\n#define __LP64__ 1\n#define __INT64_TYPE__ long\n#define __SIZEOF_INT__ 4\n#define __INT_MAX__ 0x7fffffff\n#define __LONG_MAX__ 0x7fffffffffffffffL\n#define __SIZEOF_LONG_LONG__ 8\n#define __LONG_LONG_MAX__ 0x7fffffffffffffffLL\n#define __CHAR_BIT__ 8\n#define __ORDER_LITTLE_ENDIAN__ 1234\n#define __ORDER_BIG_ENDIAN__ 4321\n#define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__\n#define __WCHAR_TYPE__ int\n#define __WINT_TYPE__ unsigned int\n#if __STDC_VERSION__>=201112L\n#define __STDC_NO_ATOMICS__ 1\n#define __STDC_NO_COMPLEX__ 1\n#define __STDC_NO_THREADS__ 1\n#define __STDC_UTF_16__ 1\n#define __STDC_UTF_32__ 1\n#endif\n#define __UINTPTR_TYPE__ unsigned __PTRDIFF_TYPE__\n#define __INTPTR_TYPE__ __PTRDIFF_TYPE__\n#define __INT32_TYPE__ int\n#define __REDIRECT(name,proto,alias) name proto __asm__(#alias)\n#define __REDIRECT_NTH(name,proto,alias) name proto __asm__(#alias)__THROW\n#define __REDIRECT_NTHNL(name,proto,alias) name proto __asm__(#alias)__THROWNL\n#define __PRETTY_FUNCTION__ __FUNCTION__\n#define __has_builtin(x) 0\n#define __has_feature(x) 0\n#define _Nonnull\n#define _Nullable\n#define _Nullable_result\n#define _Null_unspecified\n#ifndef __TCC_PP__\n#define __builtin_offsetof(type,field) ((__SIZE_TYPE__)&((type*)0)->field)\n#define __builtin_extract_return_addr(x) x\ntypedef struct{\nunsigned gp_offset,fp_offset;\nunion{\nunsigned overflow_offset;\nchar*overflow_arg_area;\n};\nchar*reg_save_area;\n}__builtin_va_list[1];\nvoid*__va_arg(__builtin_va_list ap,int arg_type,int size,int align);\n#define __builtin_va_start(ap,last) (*(ap)=*(__builtin_va_list)((char*)__builtin_frame_address(0)-24))\n#define __builtin_va_arg(ap,t) (*(t*)(__va_arg(ap,__builtin_va_arg_types(t),sizeof(t),__alignof__(t))))\n#define __builtin_va_copy(dest,src) (*(dest)=*(src))\n#define __builtin_va_end(ap) (void)(ap)\n#ifndef __builtin_va_copy\n#define __builtin_va_copy(dest,src) (dest)=(src)\n#endif\n#ifdef __leading_underscore\n#define __RENAME(X) __asm__(\"_\"X)\n#else\n#define __RENAME(X) __asm__(X)\n#endif\n#ifdef __TCC_BCHECK__\n#define __BUILTINBC(ret,name,params) ret __builtin_##name params __RENAME(\"__bound_\"#name);\n#define __BOUND(ret,name,params) ret name params __RENAME(\"__bound_\"#name);\n#else\n#define __BUILTINBC(ret,name,params) ret __builtin_##name params __RENAME(#name);\n#define __BOUND(ret,name,params)\n#endif\n#define __BOTH(ret,name,params) __BUILTINBC(ret,name,params)__BOUND(ret,name,params)\n#define __BUILTIN(ret,name,params) ret __builtin_##name params __RENAME(#name);\n__BOTH(void*,memcpy,(void*,const void*,__SIZE_TYPE__))\n__BOTH(void*,memmove,(void*,const void*,__SIZE_TYPE__))\n__BOTH(void*,memset,(void*,int,__SIZE_TYPE__))\n__BOTH(int,memcmp,(const void*,const void*,__SIZE_TYPE__))\n__BOTH(__SIZE_TYPE__,strlen,(const char*))\n__BOTH(char*,strcpy,(char*,const char*))\n__BOTH(char*,strncpy,(char*,const char*,__SIZE_TYPE__))\n__BOTH(int,strcmp,(const char*,const char*))\n__BOTH(int,strncmp,(const char*,const char*,__SIZE_TYPE__))\n__BOTH(char*,strcat,(char*,const char*))\n__BOTH(char*,strncat,(char*,const char*,__SIZE_TYPE__))\n__BOTH(char*,strchr,(const char*,int))\n__BOTH(char*,strrchr,(const char*,int))\n__BOTH(char*,strdup,(const char*))\n#define __MAYBE_REDIR __BUILTIN\n__MAYBE_REDIR(void*,malloc,(__SIZE_TYPE__))\n__MAYBE_REDIR(void*,realloc,(void*,__SIZE_TYPE__))\n__MAYBE_REDIR(void*,calloc,(__SIZE_TYPE__,__SIZE_TYPE__))\n__MAYBE_REDIR(void*,memalign,(__SIZE_TYPE__,__SIZE_TYPE__))\n__MAYBE_REDIR(void,free,(void*))\n__BOTH(void*,alloca,(__SIZE_TYPE__))\n__BUILTIN(void,abort,(void))\n__BOUND(void,longjmp,())\n__BOUND(void*,mmap,())\n__BOUND(int,munmap,())\n#undef __BUILTINBC\n#undef __BUILTIN\n#undef __BOUND\n#undef __BOTH\n#undef __MAYBE_REDIR\n#undef __RENAME\n#define __BUILTIN_EXTERN(name,u) int __builtin_##name(u int);int __builtin_##name##l(u long);int __builtin_##name##ll(u long long);\n__BUILTIN_EXTERN(ffs,)\n__BUILTIN_EXTERN(clz,unsigned)\n__BUILTIN_EXTERN(ctz,unsigned)\n__BUILTIN_EXTERN(clrsb,)\n__BUILTIN_EXTERN(popcount,unsigned)\n__BUILTIN_EXTERN(parity,unsigned)\n#undef __BUILTIN_EXTERN\n#endif\n', -1)
	}
	cstr_printf(cs, "#define __BASE_FILE__ \"${(&char(file.filename)).vstring()}\"\n")
}

fn preprocess_start(s1 &TCCState, filetype int) {
	is_asm := !!(filetype & (2 | 4))
	vcc_trace('${@LOCATION}')
	tccpp_new(s1)
	vcc_trace('${@LOCATION}')
	s1.include_stack_ptr = &s1.include_stack[0]
	s1.ifdef_stack_ptr = &s1.ifdef_stack[0]
	file.ifdef_stack_ptr = s1.ifdef_stack_ptr
	vcc_trace('${@LOCATION}')
	pp_expr = 0
	pp_counter = 0
	pp_debug_tok = 0
	pp_debug_symv = pp_debug_tok
	s1.pack_stack[0] = 0
	s1.pack_stack_ptr = &s1.pack_stack[0]
	vcc_trace('${@LOCATION}')
	set_idnum(`$`, if !is_asm && s1.dollars_in_identifiers { 2 } else { 0 })
	set_idnum(`.`, if is_asm { 2 } else { 0 })
	vcc_trace('${@LOCATION} - ${s1.nb_sections}')
	if !(filetype & 2) {
		vcc_trace('${@LOCATION} - ${s1.nb_sections}')
		cstr := strings.new_builder(100)
		cstr_new(&cstr)
		vcc_trace('${@LOCATION} - ${s1.nb_sections}')
		tcc_predefs(s1, &cstr, is_asm)
		vcc_trace('${@LOCATION} - ${s1.nb_sections}')
		// vcc_trace('${@LOCATION} ${(&char(cstr.data)).vstring()}')
		if s1.cmdline_defs.len {
			vcc_trace('${@LOCATION} - ${s1.nb_sections}')
			cstr_cat(&cstr, s1.cmdline_defs.data, s1.cmdline_defs.len)
		}
		if s1.cmdline_incl.len {
			vcc_trace('${@LOCATION} - ${s1.nb_sections}')
			cstr_cat(&cstr, s1.cmdline_incl.data, s1.cmdline_incl.len)
		}
		vcc_trace('${@LOCATION} - ${s1.nb_sections}')
		unsafe {
			vcc_trace('${@LOCATION} - ${s1.nb_sections}')
			*s1.include_stack_ptr++ = file
			vcc_trace('${@LOCATION} - ${s1.nb_sections}')
		}
		vcc_trace('${@LOCATION} - ${s1.nb_sections}')
		tcc_open_bf(s1, c'<command line>', cstr.len)
		C.memcpy(file.buffer, cstr.data, cstr.len)
		cstr_free(&cstr)
		vcc_trace('${@LOCATION} - ${s1.nb_sections}')
	}
	parse_flags = if is_asm { 8 } else { 0 }
	tok_flags = 1 | 2
}

fn preprocess_end(s1 &TCCState) {
	vcc_trace('${@LOCATION}')
	for macro_stack != unsafe { nil } {
		end_macro()
	}
	vcc_trace('${@LOCATION}')
	macro_ptr = unsafe { nil }
	for file != unsafe { nil } {
		vcc_trace('${@LOCATION}')
		tcc_close()
	}
	vcc_trace('${@LOCATION}')
	tccpp_delete(s1)
}

fn set_idnum(c int, val int) int {
	prev := isidnum_table[c - ch_eof]
	isidnum_table[c - ch_eof] = val
	return prev
}

const is_spc = 1
const is_id = 2
const is_num = 4

fn tccpp_new(s &TCCState) {
	i := 0
	c := 0

	for i = (-1); i < 128; i++ {
		val := if is_space(i) {
			is_spc
		} else {
			if isid(i) {
				is_id
			} else {
				if isnum(i) { is_num } else { 0 }
			}
		}
		vcc_trace_print('isisdnum_table[${i}]=${val}')
		set_idnum(i, val)
	}
	vcc_trace('${@LOCATION}')
	for i = 128; i < 256; i++ {
		set_idnum(i, is_id)
	}
	vcc_trace('${@LOCATION}')
	tal_new(&toksym_alloc, 256, (768 * 1024))
	tal_new(&tokstr_alloc, 128, (768 * 1024))
	vcc_trace('${@LOCATION}')
	C.memset(hash_ident, 0, TOK_HASH_SIZE * sizeof(&TokenSym))
	C.memset(s.cached_includes_hash, 0, sizeof(s.cached_includes_hash))
	vcc_trace('${@LOCATION}')
	cstr_new(&tokcstr)
	cstr_new(&cstr_buf)
	vcc_trace('${@LOCATION}')
	cstr_realloc(&cstr_buf, 1024)
	vcc_trace('${@LOCATION}')
	tok_str_new(&tokstr_buf)
	vcc_trace('${@LOCATION}')
	tok_str_realloc(&tokstr_buf, 256)
	vcc_trace('${@LOCATION}')
	tok_ident = 256

	vcc_trace('${@LOCATION} ${table_ident != unsafe { nil }}')
	for keyword in tcc_keywords {
		// vcc_trace('${@LOCATION} ${keyword}')
		tok_alloc(keyword.str, keyword.len)
	}
	vcc_trace('${@LOCATION} ${table_ident[77] != unsafe { nil }}')
	unsafe {
		define_push(Tcc_token.tok___line__, 0, nil, nil)
		define_push(Tcc_token.tok___file__, 0, nil, nil)
		define_push(Tcc_token.tok___date__, 0, nil, nil)
		define_push(Tcc_token.tok___time__, 0, nil, nil)
		define_push(Tcc_token.tok___counter__, 0, nil, nil)
	}
	vcc_trace('${@LOCATION}')
}

fn tccpp_delete(s &TCCState) {
	i := 0
	n := 0

	vcc_trace('${@LOCATION}')
	dynarray_reset(&s.cached_includes, &s.nb_cached_includes)
	n = tok_ident - TOK_IDENT
	if n > tcc_state.total_idents {
		tcc_state.total_idents = n
	}
	vcc_trace('${@LOCATION}')
	for i = 0; i < n; i++ {
		tal_free_impl(toksym_alloc, table_ident[i])
	}
	vcc_trace('${@LOCATION}')
	tcc_free(table_ident)
	table_ident = unsafe { nil }
	vcc_trace('${@LOCATION}')
	cstr_free(&tokcstr)
	cstr_free(&cstr_buf)
	vcc_trace('${@LOCATION}')
	tok_str_free_str(tokstr_buf.str)
	tal_delete(toksym_alloc)
	toksym_alloc = unsafe { nil }
	tal_delete(tokstr_alloc)
	tokstr_alloc = unsafe { nil }
	vcc_trace('${@LOCATION}')
}

fn tok_print(msg &char, str &int) {
	vcc_trace('${@LOCATION}')
	fp := &C.FILE(0)
	t := 0
	s := 0
	cval := CValue{}

	fp = tcc_state.ppfp
	C.fprintf(fp, c'%s', msg)
	for str {
		tok_get_macro(mut &t, mut &str, mut &cval)
		if !t {
			break
		}
		C.fprintf(fp, &c' %s'[s], get_tok_str(t, &cval))
		s = 1
	}
	C.fprintf(fp, c'\n')
}

fn pp_line(s1 &TCCState, f &BufferedFile, level int) {
	vcc_trace('${@LOCATION}')
	d := f.line_num - f.line_ref
	if s1.dflag & 4 {
		return
	}
	if s1.pflag == Line_macro_output_format.line_macro_output_format_none {
	} else if level == 0 && f.line_ref && d < 8 {
		for d > 0 {
			C.fputs(c'\n', s1.ppfp)
			d--
		}
	} else if s1.pflag == Line_macro_output_format.line_macro_output_format_std {
		C.fprintf(s1.ppfp, c'#line %d "%s"\n', f.line_num, f.filename)
	} else {
		C.fprintf(s1.ppfp, c'# %d "%s"%s\n', f.line_num, f.filename, if level > 0 {
			c' 1'
		} else {
			if level < 0 { c' 2' } else { c'' }
		})
	}
	f.line_ref = f.line_num
}

fn define_print(s1 &TCCState, v int) {
	vcc_trace('${@LOCATION}')
	fp := &C.FILE(0)
	s := &Sym(0)
	vcc_trace('${@LOCATION}')

	s = define_find(v)
	if unsafe { nil } == s || unsafe { nil } == s.d {
		return
	}
	fp = s1.ppfp
	C.fprintf(fp, c'#define %s', get_tok_str(v, (unsafe { nil })))
	if s.type_.t == 1 {
		a := s.next
		C.fprintf(fp, c'(')
		if a {
			for {
				C.fprintf(fp, c'%s', get_tok_str(a.v & ~sym_field, unsafe { nil }))
				a = a.next
				if !a {
					break
				}
				C.fprintf(fp, c',')
			}
		}
		C.fprintf(fp, c')')
	}
	tok_print(c'', s.d)
}

fn pp_debug_defines(s1 &TCCState) {
	vcc_trace('${@LOCATION}')
	v := 0
	t := 0
	vs := &char(0)
	fp := &C.FILE(0)

	t = pp_debug_tok
	if t == 0 {
		return
	}

	file.line_num--
	pp_line(s1, file, 0)
	file.line_num++
	file.line_ref = file.line_num

	fp = s1.ppfp
	v = pp_debug_symv
	vs = get_tok_str(v, unsafe { nil })
	if t == Tcc_token.tok_define {
		define_print(s1, v)
	} else if t == Tcc_token.tok_undef {
		C.fprintf(fp, c'#undef %s\n', vs)
	} else if t == Tcc_token.tok_push_macro {
		C.fprintf(fp, c'#pragma push_macro("%s")\n', vs)
	} else if t == Tcc_token.tok_pop_macro {
		C.fprintf(fp, c'#pragma pop_macro("%s")\n', vs)
	}
	pp_debug_tok = 0
}

fn pp_debug_builtins(s1 &TCCState) {
	vcc_trace('${@LOCATION}')
	v := 0
	for v = TOK_IDENT; v < tok_ident; v++ {
		define_print(s1, v)
	}
}

fn pp_need_space(a int, b int) bool {
	vcc_trace('${@LOCATION}')
	return if `E` == a {
		`+` == b || `-` == b
	} else {
		if `+` == a {
			130 == b || `+` == b
		} else {
			if `-` == a {
				128 == b || `-` == b
			} else {
				if a >= 256 {
					b >= 256
				} else {
					if a == 205 {
						b >= 256
					} else {
						0
					}
				}
			}
		}
	}
}

fn pp_check_he0xe(t int, p &char) int {
	vcc_trace('${@LOCATION}')
	if t == 205 && toup(C.strchr(p, 0)[-1]) == `E` {
		return int(`E`)
	}
	return t
}

fn tcc_preprocess(s1 &TCCState) int {
	vcc_trace('${@LOCATION}')
	iptr := &&BufferedFile(0)
	token_seen := 0
	spcs := 0
	level := 0
	p := &char(0)
	white := [400]char{}

	parse_flags = 1 | (parse_flags & 8) | 4 | 16 | 32
	if s1.pflag == Line_macro_output_format.line_macro_output_format_p10 {
		parse_flags |= 2
		s1.pflag = 1
	}
	if s1.do_bench {
		for {
			next()
			// while()
			if !(tok != (-1)) {
				break
			}
		}
		return 0
	}
	if s1.dflag & 1 {
		pp_debug_builtins(s1)
		s1.dflag &= ~1
	}
	token_seen = 10
	spcs = 0
	level = 0
	if file.prev {
		pp_line(s1, file.prev, level++)
	}
	pp_line(s1, file, level)
	for {
		iptr = &s1.include_stack_ptr[0]
		next()
		if tok == tok_eof {
			break
		}
		level = unsafe { (&char(s1.include_stack_ptr) - &char(iptr)) / sizeof(&BufferedFile) }
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
			file.line_ref++
		} else if token_seen == 10 {
			pp_line(s1, file, 0)
		} else if spcs == 0 && pp_need_space(token_seen, tok) {
			white[spcs++] = ` `
		}
		white[spcs] = 0
		C.fputs(white, s1.ppfp)
		spcs = 0
		p = get_tok_str(tok, &tokc)
		C.fputs(p, s1.ppfp)
		token_seen = pp_check_he0xe(tok, p)
	}
	return 0
}
