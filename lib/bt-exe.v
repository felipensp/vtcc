@[translated]
module main

#include <semaphore.h>
#include <setjmp.h>

#insert "lib/bcheck.h"

fn C.strlen(&char) int
fn C.memcpy(voidptr, voidptr, int) voidptr

@[typedef]
struct C.va_list {}

type RtErrorFn = fn (voidptr, voidptr, &char, C.va_list) int

__global __rt_error = RtErrorFn(unsafe { nil })

@[weak]
fn C.__bound_checking_lock()

@[weak]
fn C.__bound_checking_unlock()

@[weak]
fn C.__bound_init(voidptr, int)

@[weak]
fn C.__bound_exit_dll(voidptr)

@[typedef]
struct C.jmp_buf {
}

@[typedef]
struct C.sem_t {
}

struct TCCSem {
	init int
	sem  C.sem_t
}

type Elf64_Addr = u64
type Elf64_Word = u32
type Elf64_Xword = u64
type Elf64_Section = u16

struct Elf64_Sym {
	st_name  Elf64_Word
	st_info  u8
	st_other u8
	st_shndx Elf64_Section
	st_value Elf64_Addr
	st_size  Elf64_Xword
}

struct Rt_context {
	dwarf        Elf64_Addr
	esym_start   &Elf64_Sym
	esym_end     &Elf64_Sym
	elf_str      &char
	prog_base    Elf64_Addr
	bounds_start voidptr
	next         &Rt_context
	num_callers  int
	ip           Elf64_Addr
	fp           Elf64_Addr
	sp           Elf64_Addr
	top_func     voidptr
	jb           C.jmp_buf
	do_jmp       int
	nr_exit      int
	exitfunc     [32]voidptr
	exitarg      [32]voidptr
}

@[weak]
__global (
	g_rtctxt Rt_context
)

@[export: '__bt_init']
fn __bt_init(p &Rt_context, num_callers int) {
	main := C.main
	__bound_init := C.__bound_init
	rc := &g_rtctxt
	if p.bounds_start {
		__bound_init(p.bounds_start, -1)
		C.__bound_checking_lock()
	}
	if num_callers {
		C.memcpy(rc, p, __offsetof(Rt_context, next))
		rc.num_callers = num_callers - 1
		rc.top_func = main
		__rt_error = _rt_error
		// set_exception_handler()
	} else {
		p.next = rc.next
		rc.next = p
	}
	if p.bounds_start {
		C.__bound_checking_unlock()
	}
}

fn _rt_error(fp voidptr, ip voidptr, fmt &char) int {
	return 0
}

@[export: '__bt_exit']
fn __bt_exit(p &Rt_context) {
	bound_exit_dll := C.__bound_exit_dll
	rc := &g_rtctxt
	if p.bounds_start {
		bound_exit_dll(p.bounds_start)
		C.__bound_checking_lock()
	}
	for rc {
		if voidptr(rc.next) == voidptr(p) {
			rc.next = rc.next.next
			break
		}
		rc = rc.next
	}
	if p.bounds_start {
		C.__bound_checking_unlock()
	}
}

fn tcc_pstrcpy(buf &char, buf_size usize, s &char) &char {
	l := C.strlen(s)
	if l >= buf_size {
		l = buf_size - 1
	}
	C.memcpy(buf, s, l)
	buf[l] = 0
	return buf
}
