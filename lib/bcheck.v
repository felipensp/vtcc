@[translated]
module bcheck

#include <pthread.h>

@[typedef]
struct C.pthread_spinlock_t {}

fn C.pthread_spin_unlock(&C.pthread_spinlock_t)
fn C.pthread_spin_lock(&C.pthread_spinlock_t)
fn C.pthread_spin_init(&C.pthread_spinlock_t, int)

__global bounds_spin = C.pthread_spinlock_t{}
__global use_sem = u8(0)
__global inited = u8(0)

@[export: '__bound_checking_lock']
pub fn __bound_checking_lock() {
	wait_sem()
}

@[export: '__bound_checking_unlock']
pub fn __bound_checking_unlock() {
	post_sem()
}

@[inline]
fn wait_sem() {
	if use_sem {
		C.pthread_spin_lock(&bounds_spin)
	}
}

@[inline]
fn post_sem() {
	if use_sem {
		C.pthread_spin_unlock(&bounds_spin)
	}
}

@[inline]
fn init_sem() {
	C.pthread_spin_init(&bounds_spin, 0)
}

@[export: '__bound_exit_dll']
pub fn __bound_exit_dll(p &usize) {
}
