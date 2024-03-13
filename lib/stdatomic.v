@[translated]
const atomic_relaxed = 0
const atomic_consume = 1
const atomic_acquire = 2
const atomic_release = 3
const atomic_acq_rel = 4
const atomic_seq_cst = 5

fn atomic_thread_fence(memorder int) {
	$if i386 ? {
		// asm i386 { lock orl 0, (%esp) }
	} $else $if amd64 ? {
		// asm amd64 { lock orq 0, (%rsp) }
	} $else $if arm ? {
		asm arm32 {
			.int 0xee070fba
		} // mcr p15, 0, r0, c7, c10, 5
	} $else $if aarch64 ? {
		asm arm64 {
			.int 0xd5033bbf
		} // dmb ish
		//} $else $if riscv {
		//		asm riscv { .int 0x0ff0000f } // fence iorw,iorw
	}
}

// load, store, compare exchange

// u8
@[export: '__atomic_load_1']
fn atomic_load_1(atom voidptr, memorder int) u8 {
	atomic_thread_fence(atomic_acquire)
	return *&u8(atom)
}

@[export: '__atomic_store_1']
fn atomic_store_1(atom voidptr, value u8, memorder int) {
	unsafe {
		*&u8(atom) = value
	}
	atomic_thread_fence(atomic_acq_rel)
}

@[export: '__atomic_compare_exchange_1']
fn atomic_compare_exchange_1(atom voidptr, ref voidptr, xchg u8, weak bool, success_memorder int, failure_memorder int) bool {
	rv := u8(0)
	cmp := *&u8(ref)
	// asm amd64 {
	// 	lock cmpxchgb %2,%1
	// 	: "=a" (rv), "+m" (*&u8(atom))
	// 	: "q" (xchg), "0" (cmp)
	// 	: "memory"
	// }
	unsafe {
		*&u8(ref) = rv
	}
	return rv == cmp
}

// u16
@[export: '__atomic_load_2']
fn atomic_load_2(atom voidptr, memorder int) u16 {
	atomic_thread_fence(atomic_acquire)
	return *&u16(atom)
}

@[export: '__atomic_store_2']
fn atomic_store_2(atom voidptr, value u16, memorder int) {
	unsafe {
		*&u16(atom) = value
	}
	atomic_thread_fence(atomic_acq_rel)
}

@[export: '__atomic_compare_exchange_2']
fn atomic_compare_exchange_2(atom voidptr, ref voidptr, xchg u16, weak bool, success_memorder int, failure_memorder int) bool {
	rv := u16(0)
	cmp := *&u16(ref)
	// asm amd64 {
	// 	lock cmpxchgb %2,%1
	// 	: "=a" (rv), "+m" (*&u8(atom))
	// 	: "q" (xchg), "0" (cmp)
	// 	: "memory"
	// }
	unsafe {
		*&u16(ref) = rv
	}
	return rv == cmp
}

// u32
@[export: '__atomic_load_4']
fn atomic_load_4(atom voidptr, memorder int) u32 {
	atomic_thread_fence(atomic_acquire)
	return *&u32(atom)
}

@[export: '__atomic_store_4']
fn atomic_store_4(atom voidptr, value u32, memorder int) {
	unsafe {
		*&u32(atom) = value
	}
	atomic_thread_fence(atomic_acq_rel)
}

@[export: '__atomic_compare_exchange_4']
fn atomic_compare_exchange_4(atom voidptr, ref voidptr, xchg u32, weak bool, success_memorder int, failure_memorder int) bool {
	rv := u32(0)
	cmp := *&u32(ref)
	// asm amd64 {
	// 	lock cmpxchgb %2,%1
	// 	: "=a" (rv), "+m" (*&u8(atom))
	// 	: "q" (xchg), "0" (cmp)
	// 	: "memory"
	// }
	unsafe {
		*&u32(ref) = rv
	}
	return rv == cmp
}

// u64
@[export: '__atomic_load_8']
fn atomic_load_8(atom voidptr, memorder int) u64 {
	atomic_thread_fence(atomic_acquire)
	return *&u64(atom)
}

@[export: '__atomic_store_8']
fn atomic_store_8(atom voidptr, value u64, memorder int) {
	unsafe {
		*&u64(atom) = value
	}
	atomic_thread_fence(atomic_acq_rel)
}

@[export: '__atomic_compare_exchange_8']
fn atomic_compare_exchange_8(atom voidptr, ref voidptr, xchg u64, weak bool, success_memorder int, failure_memorder int) bool {
	rv := u64(0)
	cmp := *&u64(ref)
	// asm amd64 {
	// 	lock cmpxchgb %2,%1
	// 	: "=a" (rv), "+m" (*&u8(atom))
	// 	: "q" (xchg), "0" (cmp)
	// 	: "memory"
	// }
	unsafe {
		*&u64(ref) = rv
	}
	return rv == cmp
}
