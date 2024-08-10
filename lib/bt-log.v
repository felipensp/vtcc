@[translated]
module btlog

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

@[typedef]
struct C.va_list {}

type RtErrorFn = fn (voidptr, voidptr, &char, C.va_list) int

fn C.va_start(C.va_list, voidptr)
fn C.va_end(voidptr)

@[weak]
__global __rt_error = RtErrorFn(unsafe { nil })

fn C.fflush(&C.FILE) int
fn C.vfprintf(&C.FILE, &char, C.va_list) int
fn C.fprintf(&C.FILE, ...) int
fn C.printf(&char, ...) int

fn C.strchr(&char, int) &char

@[weak]
fn C.__builtin_frame_address(int) voidptr

@[weak]
fn C.__builtin_return_address(int) voidptr

@[export: 'tcc_backtrace']
pub fn tcc_backtrace(const_fmt &char, ...) int {
	mut ret := 0
	if __rt_error {
		fp := voidptr(C.__builtin_frame_address(1))
		ip := voidptr(C.__builtin_return_address(0))
		ap := C.va_list{}
		C.va_start(ap, const_fmt)
		ret = __rt_error(fp, ip, const_fmt, ap)
		C.va_end(ap)
	} else {
		mut p := &char(0)
		mut nl := c'\n'
		if *const_fmt == `^` {
			p = C.strchr(const_fmt + 1, *const_fmt)
			if p {
				const_fmt = &char(p) + 1
			}
		}
		if *const_fmt == `\001` {
			unsafe {
				const_fmt += 1
			}
			nl = c''
		}
		ap := C.va_list{}
		C.va_start(ap, const_fmt)
		ret = C.vfprintf(C.stderr, const_fmt, ap)
		C.va_end(ap)
		C.fprintf(C.stderr, c'%s', nl)
		C.fflush(C.stderr)
	}
	return ret
}
