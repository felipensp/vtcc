@[translated]
module main

#include <semaphore.h>
#include <setjmp.h>

fn C.strlen(&char) int
fn C.memcpy(&voidptr, &voidptr, int) voidptr

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
	elf_str      &i8
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

fn tcc_pstrcpy(buf &i8, buf_size usize, s &i8) &i8 {
	l := C.strlen(s)
	if l >= buf_size {
		l = buf_size - 1
	}
	C.memcpy(buf, s, l)
	buf[l] = 0
	return buf
}
