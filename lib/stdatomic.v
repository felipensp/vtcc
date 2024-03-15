@[translated]
const atomic_relaxed = 0
const atomic_consume = 1
const atomic_acquire = 2
const atomic_release = 3
const atomic_acq_rel = 4
const atomic_seq_cst = 5

fn C.__atomic_load(voidptr, voidptr, int)
fn C.__atomic_compare_exchange(voidptr, voidptr, voidptr, bool, int, int) bool

@[inline]
fn atomic_thread_fence(memorder int) {
	$if i386 {
		asm i386 {
			lock orl '(%esp)', 0
		}
	} $else $if amd64 {
		asm amd64 {
			lock orq '(%rsp)', 0
		}
	} $else $if arm32 {
		asm arm32 {
			.int 0xee070fba
		} // mcr p15, 0, r0, c7, c10, 5
	} $else $if arm64 {
		asm arm64 {
			.int 0xd5033bbf
		} // dmb ish
	} $else $if rv64 {
		asm rv64 {
			.int 0x0ff0000f
		} // fence iorw,iorw
	}
}

// load, store, compare exchange, exchange
// add_fetch, sub_fetch, and_fetch, or_fetch, xor_fetch
// nand_fetch, fetch_add, fetch_sub, fetch_and, fetch_or
// fetch_xor, fetch_nand

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
	mut rv := u8(0)
	cmp := *&u8(ref)
	asm amd64 {
		lock cmpxchgb '%1', '%2'
		; =a (rv)
		  +m (*&u8(atom))
		; q (xchg)
		  0 (cmp)
		; memory
	}
	unsafe {
		*&u8(ref) = rv
	}
	return rv == cmp
}

@[export: '__atomic_exchange_1']
fn atomic_exchange_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_add_fetch_1']
fn atomic_add_fetch_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_sub_fetch_1']
fn atomic_sub_fetch_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_and_fetch_1']
fn atomic_and_fetch_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_or_fetch_1']
fn atomic_or_fethc_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_xor_fetch_1']
fn atomic_xor_fetch_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_nand_fetch_1']
fn atomic_nand_fetch_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_fetch_add_1']
fn atomic_fetch_add_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_sub_1']
fn atomic_fetch_sub_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_and_1']
fn atomic_fetch_and_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_or_1']
fn atomic_fetch_or_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_xor_1']
fn atomic_fetch_xor_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_nand_1']
fn atomic_fetch_nand_1(atom voidptr, value u8, memorder int) u8 {
	mut xchg := u8(0)
	cmp := u8(0)
	C.__atomic_load(&u8(atom), &u8(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u8(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
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
	mut rv := u16(0)
	cmp := *&u16(ref)
	asm amd64 {
		lock cmpxchgw '%1', '%2'
		; =a (rv)
		  +m (*&u16(atom))
		; q (xchg)
		  0 (cmp)
		; memory
	}
	unsafe {
		*&u16(ref) = rv
	}
	return rv == cmp
}

@[export: '__atomic_exchange_2']
fn atomic_exchange_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_add_fetch_2']
fn atomic_add_fetch_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_sub_fetch_2']
fn atomic_sub_fetch_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_and_fetch_2']
fn atomic_and_fetch_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_or_fetch_2']
fn atomic_or_fethc_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_xor_fetch_2']
fn atomic_xor_fetch_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_nand_fetch_2']
fn atomic_nand_fetch_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_fetch_add_2']
fn atomic_fetch_add_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_sub_2']
fn atomic_fetch_sub_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_and_2']
fn atomic_fetch_and_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_or_2']
fn atomic_fetch_or_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_xor_2']
fn atomic_fetch_xor_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_nand_2']
fn atomic_fetch_nand_2(atom voidptr, value u16, memorder int) u16 {
	mut xchg := u16(0)
	cmp := u16(0)
	C.__atomic_load(&u16(atom), &u16(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u16(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
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
	mut rv := u32(0)
	cmp := *&u32(ref)
	asm amd64 {
		lock cmpxchgl '%1', '%2'
		; =a (rv)
		  +m (*&u32(atom))
		; q (xchg)
		  0 (cmp)
		; memory
	}
	unsafe {
		*&u32(ref) = rv
	}
	return rv == cmp
}

@[export: '__atomic_exchange_4']
fn atomic_exchange_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_add_fetch_4']
fn atomic_add_fetch_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_sub_fetch_4']
fn atomic_sub_fetch_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_and_fetch_4']
fn atomic_and_fetch_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_or_fetch_4']
fn atomic_or_fethc_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_xor_fetch_4']
fn atomic_xor_fetch_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_nand_fetch_4']
fn atomic_nand_fetch_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_fetch_add_4']
fn atomic_fetch_add_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_sub_4']
fn atomic_fetch_sub_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_and_4']
fn atomic_fetch_and_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_or_4']
fn atomic_fetch_or_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_xor_4']
fn atomic_fetch_xor_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_nand_4']
fn atomic_fetch_nand_4(atom voidptr, value u32, memorder int) u32 {
	mut xchg := u32(0)
	cmp := u32(0)
	C.__atomic_load(&u32(atom), &u32(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u32(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
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
	mut rv := u64(0)
	cmp := *&u64(ref)
	$if amd64 {
		asm amd64 {
			lock cmpxchgq '%1', '%2'
			; =a (rv)
			  +m (*&u64(atom))
			; q (xchg)
			  0 (cmp)
			; memory
		}
	}
	unsafe {
		*&u64(ref) = rv
	}
	return rv == cmp
}

@[export: '__atomic_exchange_8']
fn atomic_exchange_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_add_fetch_8']
fn atomic_add_fetch_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_sub_fetch_8']
fn atomic_sub_fetch_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_and_fetch_8']
fn atomic_and_fetch_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_or_fetch_8']
fn atomic_or_fethc_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_xor_fetch_8']
fn atomic_xor_fetch_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_nand_fetch_8']
fn atomic_nand_fetch_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return xchg
}

@[export: '__atomic_fetch_add_8']
fn atomic_fetch_add_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp + value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_sub_8']
fn atomic_fetch_sub_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp - value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_and_8']
fn atomic_fetch_and_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp & value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_or_8']
fn atomic_fetch_or_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp | value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_xor_8']
fn atomic_fetch_xor_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = cmp ^ value
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}

@[export: '__atomic_fetch_nand_8']
fn atomic_fetch_nand_8(atom voidptr, value u64, memorder int) u64 {
	mut xchg := u64(0)
	cmp := u64(0)
	C.__atomic_load(&u64(atom), &u64(&cmp), atomic_relaxed)
	for {
		xchg = ~(cmp & value)
		if (C.__atomic_compare_exchange(&u64(atom), &cmp, &xchg, true, atomic_seq_cst,
			atomic_seq_cst)) {
			break
		}
	}
	return cmp
}
