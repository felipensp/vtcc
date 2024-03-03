@[translated]
module main

#include <signal.h>
#include <setjmp.h>
#include <sys/mman.h>

const REG_RIP = 16

const __SI_MASK = u64(0xffff_0000)
const __SI_KILL = (0 << 16)
const __SI_TIMER = (1 << 16)
const __SI_POLL = (2 << 16)
const __SI_FAULT = (3 << 16)
const __SI_CHLD = (4 << 16)
const __SI_RT = (5 << 16)
const __SI_MESGQ = (6 << 16)
const __SI_SYS = (7 << 16)

const SI_USER = 0 // sent by kill, sigsend, raise
const SI_KERNEL = 0x80 // sent by the kernel from somewhere
const SI_QUEUE = -1 // sent by sigqueue
const SI_TIMER = -2 // sent by timer expiration
const SI_MESGQ = -3 // sent by real time mesq state change
const SI_ASYNCIO = -4 // sent by AIO completion
const SI_SIGIO = -5 // sent by queued SIGIO
const SI_TKILL = -6 // sent by tkill system call
const SI_DETHREAD = -7 // sent by execve() killing subsidiary threads

const FPE_INTDIV = (__SI_FAULT | 1) // integer divide by zero
const FPE_INTOVF = (__SI_FAULT | 2) // integer overflow
const FPE_FLTDIV = (__SI_FAULT | 3) // floating point divide by zero
const FPE_FLTOVF = (__SI_FAULT | 4) // floating point overflow
const FPE_FLTUND = (__SI_FAULT | 5) // floating point underflow
const FPE_FLTRES = (__SI_FAULT | 6) // floating point inexact result
const FPE_FLTINV = (__SI_FAULT | 7) // floating point invalid operation
const FPE_FLTSUB = (__SI_FAULT | 8) // subscript out of range
const NSIGFPE = 8

struct Rt_context {
	stab_sym       &Stab_Sym
	stab_sym_end   &Stab_Sym
	stab_str       &char
	dwarf_line     &u8
	dwarf_line_end &u8
	dwarf_line_str &u8
	dwarf          Elf64_Addr
	esym_start     &Elf64_Sym
	esym_end       &Elf64_Sym
	elf_str        &char
	prog_base      Elf64_Addr
	bounds_start   voidptr
	next           &Rt_context
	num_callers    int
	ip             Elf64_Addr
	fp             Elf64_Addr
	sp             Elf64_Addr
	top_func       voidptr
	jb             C.jmp_buf
	do_jmp         int
	nr_exit        int
	exitfunc       [32]voidptr
	exitarg        [32]voidptr
}

@[weak]
__global (
	g_rtctxt Rt_context
)

const DIR_TABLE_SIZE = 64
const FILE_TABLE_SIZE = 512

struct C.va_list {}

fn C._setjmp(&C.jmp_buf) int
fn C.mprotect(voidptr, usize, int) int
fn C.vprintf(&char, C.va_list) int
fn C.vfprintf(&C.FILE, &char) int
fn C.strstr(&char, &char) &char

fn rt_exit(code int) {
	rc := &g_rtctxt
	if rc.do_jmp {
		C.longjmp(rc.jb, if code { code } else { 256 })
	}
	C.exit(code)
}

pub fn tcc_relocate(s1 &TCCState, ptr voidptr) int {
	size := 0
	ptr_diff := 0
	if voidptr(1) != ptr {
		return tcc_relocate_ex(s1, ptr, 0)
	}
	size = tcc_relocate_ex(s1, (unsafe { nil }), 0)
	if size < 0 {
		return -1
	}
	ptr = tcc_malloc(size)
	if tcc_relocate_ex(s1, ptr, ptr_diff) {
		return -1
	}
	dynarray_add(&s1.runtime_mem, &s1.nb_runtime_mem, voidptr(Elf64_Addr(u64(size))))
	dynarray_add(&s1.runtime_mem, &s1.nb_runtime_mem, ptr)
	return 0
}

type run_cdtors_fn = fn (int, &&char, &&char)

pub fn run_cdtors(s1 &TCCState, start &char, end &char, argc int, argv &&char, envp &&char) {
	a := &voidptr(get_sym_addr(s1, start, 0, 0))
	b := &voidptr(get_sym_addr(s1, end, 0, 0))
	vcc_trace('${@LOCATION} ${a} ${b}')
	for i := 0; a != b; i++ {
		vcc_trace('${@LOCATION} >')
		fnc := run_cdtors_fn(a[i])

		fnc(argc, argv, envp)
		vcc_trace('${@LOCATION} <')
		a = a[1]
	}
}

type run_on_exit_fn = fn (int, voidptr)

pub fn run_on_exit(ret int) {
	rc := &g_rtctxt
	n := rc.nr_exit
	for n {
		n--
		fnc := run_on_exit_fn(rc.exitfunc[n])
		fnc(ret, rc.exitarg[n])
	}
}

pub fn rt_on_exit(function voidptr, arg voidptr) int {
	rc := &g_rtctxt
	if rc.nr_exit < 32 {
		rc.exitfunc[rc.nr_exit] = function
		rc.exitarg[rc.nr_exit++] = arg
		return 0
	}
	return 1
}

pub fn rt_atexit(function voidptr) int {
	return rt_on_exit(function, (unsafe { nil }))
}

type prog_main_fn = fn (int, &&char, &&char) int

type bound_start_fn = fn (voidptr, int)

pub fn tcc_run(s1 &TCCState, argc int, argv &&char) int {
	prog_main := prog_main_fn(0)
	ret := 0

	rc := &g_rtctxt
	envp := &&char(C.environ)
	s1.runtime_main = if s1.nostdlib { c'_start' } else { c'main' }
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	if s1.dflag & 16 && -1 == get_sym_addr(s1, s1.runtime_main, 0, 1) {
		vcc_trace('${@LOCATION}')
		return 0
	}
	tcc_add_symbol(s1, c'exit', rt_exit)
	tcc_add_symbol(s1, c'atexit', rt_atexit)
	tcc_add_symbol(s1, c'on_exit', rt_on_exit)
	if tcc_relocate(s1, voidptr(1)) < 0 {
		return -1
	}
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	prog_main = voidptr(get_sym_addr(s1, s1.runtime_main, 1, 1))
	if prog_main == -1 {
		return -1
	}
	C.memset(rc, 0, sizeof(*rc))
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	rc.do_jmp = 1
	if s1.do_debug {
		p := &voidptr(0)
		if s1.dwarf {
			rc.dwarf_line = s1.dwarf_line_section.data
			rc.dwarf_line_end = s1.dwarf_line_section.data + s1.dwarf_line_section.data_offset
			if s1.dwarf_line_str_section {
				rc.dwarf_line_str = s1.dwarf_line_str_section.data
			}
		} else {
			rc.stab_sym = &Stab_Sym(s1.stab_section.data)
			rc.stab_sym_end = &Stab_Sym((s1.stab_section.data + s1.stab_section.data_offset))
			rc.stab_str = &char(s1.stab_section.link.data)
		}
		rc.dwarf = s1.dwarf
		rc.esym_start = &Elf64_Sym((s1.symtab_section.data))
		rc.esym_end = &Elf64_Sym((s1.symtab_section.data + s1.symtab_section.data_offset))
		rc.elf_str = &char(s1.symtab_section.link.data)
		rc.prog_base = s1.text_section.sh_addr & u64(0xffffffff00000000)
		rc.top_func = tcc_get_symbol(s1, c'main')
		rc.num_callers = s1.rt_num_callers
		p = tcc_get_symbol(s1, c'__rt_error')
		if p {
			*&voidptr(p) = _rt_error
		}
		if s1.do_bounds_check {
			rc.bounds_start = voidptr(s1.bounds_section.sh_addr)
			p = tcc_get_symbol(s1, c'__bound_init')
			if p {
				fnc := bound_start_fn(p)
				fnc(rc.bounds_start, 1)
			}
		}
		set_exception_handler()
	}
	C.errno = 0
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	C.fflush(C.stdout)
	C.fflush(C.stderr)
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	run_cdtors(s1, c'__init_array_start', c'__init_array_end', argc, argv, envp)
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	ret = C._setjmp(rc.jb)
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	if 0 == ret {
		vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()} ${prog_main != unsafe { nil }}')
		ret = prog_main(argc, argv, envp)
	} else if 256 == ret {
		ret = 0
	}
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	run_cdtors(s1, c'__fini_array_start', c'__fini_array_end', 0, (unsafe { nil }), (unsafe { nil }))
	run_on_exit(ret)
	if s1.dflag & 16 && ret {
		C.fprintf(s1.ppfp, c'[returns %d]\n', ret)
		C.fflush(s1.ppfp)
	}
	vcc_trace('${@LOCATION} ${s1.runtime_main.vstring()}')
	return ret
}

fn tcc_relocate_ex(s1 &TCCState, ptr voidptr, ptr_diff Elf64_Addr) int {
	s := &Section(0)
	offset := u32(0)
	length := u32(0)
	align := u32(0)
	max_align := u32(0)
	i := u32(0)
	k := u32(0)
	f := u32(0)

	n := u32(0)
	copy := u32(0)

	mem := Elf64_Addr(0)
	addr := Elf64_Addr(0)

	if (unsafe { nil }) == ptr {
		s1.nb_errors = 0
		tcc_add_runtime(s1)
		resolve_common_syms(s1)
		build_got_entries(s1, 0)
		if s1.nb_errors {
			return -1
		}
	}
	mem = Elf64_Addr(ptr)
	max_align = offset
	offset = 0
	copy = 0
	// RRRREG redo id=0x7fffd8cd7c78

	redo: for k = 0; k < 3; k++ {
		n = 0
		addr = 0
		for i = 1; i < s1.nb_sections; i++ {
			shf := [(1 << 1) | (1 << 2), (1 << 1), (1 << 1) | (1 << 0)]!

			s = s1.sections[i]
			if shf[k] != (s.sh_flags & ((1 << 1) | (1 << 0) | (1 << 2))) {
				continue
			}
			length = s.data_offset
			if copy {
				if addr == 0 {
					addr = s.sh_addr
				}
				n = (s.sh_addr - addr) + length
				ptr = voidptr(s.sh_addr)
				if k == 0 {
					ptr = voidptr((s.sh_addr - ptr_diff))
				}
				if (unsafe { nil }) == s.data || s.sh_type == 8 {
					C.memset(ptr, 0, length)
				} else { // 3
					C.memcpy(ptr, s.data, length)
				}
				if s.data {
					tcc_free(s.data)
					s.data = (unsafe { nil })
					s.data_allocated = 0
				}
				s.data_offset = 0
				continue
			}
			align = s.sh_addralign - 1
			if (n++ + 1) == 1 && align < (C.sysconf(C._SC_PAGESIZE) - 1) {
				align = (C.sysconf(C._SC_PAGESIZE) - 1)
			}
			if max_align < align {
				max_align = align
			}
			addr = if k { mem } else { mem + ptr_diff }
			offset += -(addr + offset) & align
			s.sh_addr = if mem { addr + offset } else { 0 }
			offset += length
		}
		if copy {
			if k == 0 && ptr_diff {
				continue
			}
			f = k
			if n {
				if set_pages_executable(s1, f, voidptr(addr), n) {
					return -1
				}
			}
		}
	}
	if copy {
		return 0
	}
	relocate_syms(s1, s1.symtab, !(s1.nostdlib))
	if s1.nb_errors {
		return -1
	}
	if 0 == mem {
		return offset + max_align
	}
	relocate_plt(s1)
	relocate_sections(s1)
	copy = 1
	goto redo // id: 0x7fffd8cd7c78
	return 0
}

fn set_pages_executable(s1 &TCCState, mode int, ptr voidptr, length u32) int {
	protect := [1 | 4, 1, 1 | 2, 1 | 2 | 4]!

	start := Elf64_Addr(0)
	end := Elf64_Addr(0)

	start = Elf64_Addr(ptr) & ~(C.sysconf(C._SC_PAGESIZE) - 1)
	end = Elf64_Addr(ptr) + length
	end = (end + C.sysconf(C._SC_PAGESIZE) - 1) & ~(C.sysconf(C._SC_PAGESIZE) - 1)
	if C.mprotect(voidptr(start), end - start, protect[mode]) {
		return _tcc_error_noabort(s1, 'mprotect failed: did you mean to configure --with-selinux?')
	}
	return 0
}

fn rt_vprintf(msg string) int {
	ret := C.fputs(msg.str, C.stderr)
	C.fflush(C.stderr)
	return ret
}

fn rt_printf(msg string) int {
	r := 0
	r = rt_vprintf(msg)
	return r
}

fn rt_elfsym(rc &Rt_context, wanted_pc Elf64_Addr, func_addr &Elf64_Addr) &char {
	esym := &Elf64_Sym(0)
	unsafe {
		for esym = rc.esym_start + 1; voidptr(esym) < voidptr(rc.esym_end); esym++ {
			type_ := ((esym.st_info) & 15)
			if (type_ == 2 || type_ == 10) && wanted_pc >= esym.st_value
				&& wanted_pc < esym.st_value + esym.st_size {
				*func_addr = esym.st_value
				return rc.elf_str + esym.st_name
			}
		}
	}
	return unsafe { nil }
}

fn rt_printline(rc &Rt_context, wanted_pc Elf64_Addr, msg &char, skip &char) Elf64_Addr {
	func_name := [128]char{}
	func_addr := Elf64_Addr(0)
	last_pc := Elf64_Addr(0)
	pc := Elf64_Addr(0)

	incl_files := [32]&char{}
	incl_index := 0
	last_incl_index := 0
	len := 0
	last_line_num := 0
	i := 0

	str := &char(0)
	p := &char(0)

	sym := &Stab_Sym(0)
	// RRRREG next id=0x7fffd8ce44c8
	next:
	func_name[0] = `\x00`
	func_addr = 0
	incl_index = 0
	last_pc = Elf64_Addr(-1)
	last_line_num = 1
	last_incl_index = 0
	unsafe {
		for sym = rc.stab_sym + 1; voidptr(sym) < voidptr(rc.stab_sym_end); sym++ {
			str = rc.stab_str + sym.n_strx
			pc = sym.n_value
			match Stab_debug_code(sym.n_type) {
				.n_sline { // case comp body kind=IfStmt is_enum=true
					if func_addr {
						goto rel_pc // id: 0x7fffd8ce4f18
					}
				}
				.n_so, .n_sol {
					goto abs_pc // id: 0x7fffd8ce5060
				}
				.n_fun { // case comp body kind=IfStmt is_enum=true
					if sym.n_strx == 0 {
						goto rel_pc // id: 0x7fffd8ce4f18
					}
					// RRRREG abs_pc id=0x7fffd8ce5060
					abs_pc:
					pc += rc.prog_base
					goto check_pc // id: 0x7fffd8ce5328
					// RRRREG rel_pc id=0x7fffd8ce4f18
					rel_pc:
					pc += func_addr
					// RRRREG check_pc id=0x7fffd8ce5328
					check_pc:
					if pc >= wanted_pc && wanted_pc >= last_pc {
						goto found // id: 0x7fffd8ce5578
					}
				}
				else {}
			}
			match Stab_debug_code(sym.n_type) {
				.n_fun { // case comp body kind=IfStmt is_enum=true
					if sym.n_strx == 0 {
						goto reset_func // id: 0x7fffd8ce5870
					}
					p = C.strchr(str, `:`)
					len = p - str + 1
					if 0 == p || len > sizeof(func_name) {
						len = sizeof(func_name)
					}
					pstrcpy(func_name, len, str)
					func_addr = pc
				}
				.n_sline { // case comp body kind=BinaryOperator is_enum=true
					last_pc = pc
					last_line_num = sym.n_desc
					last_incl_index = incl_index
				}
				.n_bincl { // case comp body kind=IfStmt is_enum=true
					if incl_index < 32 {
						incl_files[incl_index++] = str
					}
				}
				.n_eincl { // case comp body kind=IfStmt is_enum=true
					if incl_index > 1 {
						incl_index--
					}
				}
				.n_so { // case comp body kind=BinaryOperator is_enum=true
					incl_index = 0
					if sym.n_strx {
						len = C.strlen(str)
						if len > 0 && str[len - 1] != `/` {
							incl_files[incl_index++] = str
						}
					}
					// RRRREG reset_func id=0x7fffd8ce5870
					reset_func:
					func_name[0] = `\x00`
					func_addr = 0
					last_pc = Elf64_Addr(-1)
				}
				.n_sol { // case comp body kind=IfStmt is_enum=true
					if incl_index {
						incl_files[incl_index - 1] = str
					}
				}
				else {}
			}
		}
	}
	func_name[0] = `\x00`
	func_addr = 0
	last_incl_index = 0
	p = rt_elfsym(rc, wanted_pc, &func_addr)
	if p {
		pstrcpy(func_name, sizeof(func_name), p)
		goto found // id: 0x7fffd8ce5578
	}
	rc = rc.next
	if rc {
		goto next // id: 0x7fffd8ce44c8
	}
	// RRRREG found id=0x7fffd8ce5578
	found:
	i = last_incl_index
	if i > 0 {
		str = incl_files[i-- - 1]
		if skip[0] && C.strstr(str, skip) {
			return Elf64_Addr(-1)
		}
		rt_printf('${str}:${last_line_num}: ')
	} else { // 3
		rt_printf('${i64(wanted_pc)} : ')
	}
	if func_name[0] {
		rt_printf('${msg} ${func_name}')
	} else {
		rt_printf('${msg} ???')
	}

	return func_addr
}

fn dwarf_read_uleb128(ln &&u8, end &u8) i64 {
	cp := *ln
	retval := 0
	i := 0
	for i = 0; i < ((8 * sizeof(i64) + 6) / 7); i++ {
		byte_ := (if cp < end { *cp++ } else { 0 })
		retval |= (byte_ & 127) << (i * 7)
		if (byte_ & 128) == 0 {
			break
		}
	}
	*ln = cp
	return retval
}

fn dwarf_read_sleb128(ln &&u8, end &u8) i64 {
	cp := *ln
	retval := 0
	i := 0
	for i = 0; i < ((8 * sizeof(i64) + 6) / 7); i++ {
		byte_ := (if cp < end { *cp++ } else { 0 })
		retval |= (byte_ & 127) << (i * 7)
		if (byte_ & 128) == 0 {
			if byte_ & 64 && (i + 1) * 7 < 64 {
				retval |= -1 << ((i + 1) * 7)
			}
			break
		}
	}
	*ln = cp
	return retval
}

struct enry_format_struct {
	type_ u32
	form  u32
}

fn rt_printline_dwarf(rc &Rt_context, wanted_pc Elf64_Addr, msg &char, skip &char) Elf64_Addr {
	ln := &u8(0)
	cp := &u8(0)
	end := &u8(0)
	opcode_length := &u8(0)
	size := i64(0)
	length := u32(0)
	version := u8(0)
	min_insn_length := u32(0)
	max_ops_per_insn := u32(0)
	line_base := 0
	line_range := u32(0)
	opcode_base := u32(0)
	opindex := u32(0)
	col := u32(0)
	i := u32(0)
	j := u32(0)
	len := u32(0)
	value := i64(0)
	entry_format := [256]enry_format_struct{}
	dir_size := u32(0)
	filename_size := u32(0)
	filename_table := [FILE_TABLE_SIZE]Dwarf_filename_struct{}
	last_pc := Elf64_Addr(0)
	pc := Elf64_Addr(0)
	func_addr := Elf64_Addr(0)
	line := 0
	filename := &char(0)
	function := &char(0)
	// RRRREG next id=0x7fffd8cedcc0
	next:
	ln = rc.dwarf_line
	for ln < rc.dwarf_line_end {
		dir_size = 0
		filename_size = 0
		last_pc = 0
		pc = 0
		func_addr = 0
		line = 1
		filename = (unsafe { nil })
		function = (unsafe { nil })
		length = 4
		size = if ln + 4 < (rc.dwarf_line_end) {
			ln += 4
			read32le(ln - 4)
		} else {
			0
		}
		if size == 4294967295 {
			length = 8
			size = if ln + 8 < (rc.dwarf_line_end) {
				ln += 8
				read64le(ln - 8)
			} else {
				0
			}
		}
		end = ln + size
		if end < ln || end > rc.dwarf_line_end {
			break
		}
		version = if ln + 2 < end {
			ln += 2
			read16le(ln - 2)
		} else {
			0
		}
		if version >= 5 {
			ln += length + 2
		} else { // 3
			ln += length
		}
		min_insn_length = (if ln < end { *ln++ } else { 0 })
		if version >= 4 {
			max_ops_per_insn = (if ln < end { *ln++ } else { 0 })
		} else { // 3
			max_ops_per_insn = 1
		}
		ln++
		line_base = (if ln < end { *ln++ } else { 0 })
		line_base |= if line_base >= 128 { ~255 } else { 0 }
		line_range = (if ln < end { *ln++ } else { 0 })
		opcode_base = (if ln < end { *ln++ } else { 0 })
		opcode_length = ln
		ln += opcode_base - 1
		opindex = 0
		if version >= 5 {
			col = (if ln < end { *ln++ } else { 0 })
			for i = 0; i < col; i++ {
				entry_format[i].type_ = dwarf_read_uleb128(&ln, end)
				entry_format[i].form = dwarf_read_uleb128(&ln, end)
			}
			dir_size = dwarf_read_uleb128(&ln, end)
			for i = 0; i < dir_size; i++ {
				for j = 0; j < col; j++ {
					if entry_format[j].type_ == dw_lnct_path {
						if entry_format[j].form != dw_form_line_strp {
							goto next_line // id: 0x7fffd8cf3458
						}
						if length == 4 {
							if ln + 4 < end {
								ln += 4
								read32le(ln - 4)
							}
						} else {
							if ln + 8 < end {
								ln += 8
								read64le(ln - 8)
							}
						}
					} else { // 3
					}
				}
			}
			col = (if ln < end { *ln++ } else { 0 })
			for i = 0; i < col; i++ {
				entry_format[i].type_ = dwarf_read_uleb128(&ln, end)
				entry_format[i].form = dwarf_read_uleb128(&ln, end)
			}
			filename_size = dwarf_read_uleb128(&ln, end)
			for i = 0; i < filename_size; i++ {
				for j = 0; j < col; j++ {
					if entry_format[j].type_ == dw_lnct_path {
						if entry_format[j].form != dw_form_line_strp {
							goto next_line // id: 0x7fffd8cf3458
						}
						value = if length == 4 {
							if ln + 4 < end {
								ln += 4
								read32le(ln - 4)
							} else {
								0
							}
						} else {
							if ln + 8 < end {
								ln += 8
								read64le(ln - 8)
							} else {
								0
							}
						}
						if i < (512) {
							filename_table[i].name = &char(rc.dwarf_line_str) + value
						}
					} else if entry_format[j].type_ == dw_lnct_directory_index {
						match entry_format[j].form {
							dw_form_data1 { // case comp body kind=BinaryOperator is_enum=true
								value = (if ln < end { *ln++ } else { 0 })
							}
							dw_form_data2 { // case comp body kind=BinaryOperator is_enum=true
								value = (if ln + 2 < end {
									ln += 2
									read16le(ln - 2)
								} else {
									0
								})
							}
							dw_form_data4 { // case comp body kind=BinaryOperator is_enum=true
								value = (if ln + 4 < end {
									ln += 4
									read32le(ln - 4)
								} else {
									0
								})
							}
							dw_form_udata { // case comp body kind=BinaryOperator is_enum=true
								value = dwarf_read_uleb128(&ln, end)
							}
							else {
								goto next_line // id: 0x7fffd8cf3458
							}
						}
						if i < (512) {
							filename_table[i].dir_entry = value
						}
					} else { // 3
					}
					0
				}
			}
		} else {
			for (if ln < end {
				*ln++
			} else {
				0
			}) {
				for (if ln < end {
					*ln++
				} else {
					0
				}) {
				}
			}
			for (if ln < end {
				*ln++
			} else {
				0
			}) {
				if (filename_size++ + 1) < (512) {
					filename_table[filename_size - 1].name = &char(ln) - 1
					for (if ln < end {
						*ln++
					} else {
						0
					}) {
					}
					filename_table[filename_size - 1].dir_entry = dwarf_read_uleb128(&ln,
						end)
				} else {
					for (if ln < end {
						*ln++
					} else {
						0
					}) {
					}
					dwarf_read_uleb128(&ln, end)
				}
				dwarf_read_uleb128(&ln, end)
				dwarf_read_uleb128(&ln, end)
			}
		}
		if filename_size >= 1 {
			filename = filename_table[0].name
		}
		for ln < end {
			last_pc = pc
			i = (if ln < end { *ln++ } else { 0 })
			if i >= opcode_base {
				if max_ops_per_insn == 1 {
					pc += ((i - opcode_base) / line_range) * min_insn_length
				} else {
					pc += (opindex + (i - opcode_base) / line_range) / max_ops_per_insn * min_insn_length
					opindex = (opindex + (i - opcode_base) / line_range) % max_ops_per_insn
				}
				i = int(((i - opcode_base) % line_range)) + line_base
				// RRRREG check_pc id=0x7fffd8cf9e20
				check_pc:
				if pc >= wanted_pc && wanted_pc >= last_pc {
					goto found // id: 0x7fffd8cf9d98
				}
				line += i
			} else {
				match i {
					0 { // case comp body kind=BinaryOperator is_enum=true
						len = dwarf_read_uleb128(&ln, end)
						cp = ln
						ln += len
						if len == 0 {
							goto next_line // id: 0x7fffd8cf3458
						}
						z := if cp < end {
							*cp++
						} else {
							0
						}
						match z {
							dw_lne_end_sequence { // case comp body kind=BreakStmt is_enum=true
							}
							dw_lne_set_address { // case comp body kind=BinaryOperator is_enum=true
								pc = (if cp + 8 < end {
									cp += 8
									read64le(cp - 8)
								} else {
									0
								})
								opindex = 0
							}
							dw_lne_define_file { // case comp body kind=IfStmt is_enum=true
								if (filename_size++ + 1) < (512) {
									filename_table[filename_size - 1].name = &char(ln) - 1
									for (if ln < end {
										*ln++
									} else {
										0
									}) {
									}
									filename_table[filename_size - 1].dir_entry = dwarf_read_uleb128(&ln,
										end)
								} else {
									for (if ln < end {
										*ln++
									} else {
										0
									}) {
									}
									dwarf_read_uleb128(&ln, end)
								}
								dwarf_read_uleb128(&ln, end)
								dwarf_read_uleb128(&ln, end)
							}
							dw_lne_hi_user - 1 { // case comp body kind=BinaryOperator is_enum=true
								function = &char(cp)
								func_addr = pc
							}
							else {}
						}
					}
					dw_lns_advance_pc { // case comp body kind=IfStmt is_enum=true
						if max_ops_per_insn == 1 {
							pc += dwarf_read_uleb128(&ln, end) * min_insn_length
						} else {
							off := dwarf_read_uleb128(&ln, end)
							pc += (opindex + off) / max_ops_per_insn * min_insn_length
							opindex = (opindex + off) % max_ops_per_insn
						}
						i = 0
						goto check_pc // id: 0x7fffd8cf9e20
					}
					dw_lns_advance_line { // case comp body kind=CompoundAssignOperator is_enum=true
						line += dwarf_read_sleb128(&ln, end)
					}
					dw_lns_set_file { // case comp body kind=BinaryOperator is_enum=true
						i = dwarf_read_uleb128(&ln, end)
						i -= i > 0 && version < 5
						if i < (512) && i < filename_size {
							filename = filename_table[i].name
						}
					}
					dw_lns_const_add_pc { // case comp body kind=IfStmt is_enum=true
						if max_ops_per_insn == 1 {
							pc += ((255 - opcode_base) / line_range) * min_insn_length
						} else {
							off := (255 - opcode_base) / line_range
							pc += ((opindex + off) / max_ops_per_insn) * min_insn_length
							opindex = (opindex + off) % max_ops_per_insn
						}
						i = 0
						goto check_pc // id: 0x7fffd8cf9e20
					}
					dw_lns_fixed_advance_pc { // case comp body kind=BinaryOperator is_enum=true
						i = (if ln + 2 < end {
							ln += 2
							read16le(ln - 2)
						} else {
							0
						})
						pc += i
						opindex = 0
						i = 0
						goto check_pc // id: 0x7fffd8cf9e20
					}
					else {
						for j = 0; j < opcode_length[i - 1]; j++ {
							dwarf_read_uleb128(&ln, end)
						}
					}
				}
			}
		}
		// RRRREG next_line id=0x7fffd8cf3458
		next_line:
		ln = end
	}
	filename = (unsafe { nil })
	func_addr = 0
	function = rt_elfsym(rc, wanted_pc, &func_addr)
	if function {
		goto found // id: 0x7fffd8cf9d98
	}
	rc = rc.next
	if rc {
		goto next // id: 0x7fffd8cedcc0
	}
	// RRRREG found id=0x7fffd8cf9d98
	found:
	if filename {
		if skip[0] && C.strstr(filename, skip) {
			return Elf64_Addr(-1)
		}
		rt_printf('${filename.vstring()}:${line}: ')
	} else { // 3
		rt_printf('0x${i64(wanted_pc)} : ')
	}
	if function {
		rt_printf('${msg.vstring()} ${function.vstring()}')
	} else {
		rt_printf('${msg.vstring()} ???')
	}
	return Elf64_Addr(func_addr)
}

fn _rt_error(fp voidptr, ip voidptr, fmt &char) int {
	rc := &g_rtctxt
	pc := Elf64_Addr(0)
	skip := [100]char{}
	i := 0
	level := 0
	ret := 0
	n := 0
	one := 0

	a := &char(0)
	b := &char(0)
	msg := &char(0)

	if fp {
		rc.fp = Elf64_Addr(fp)
		rc.ip = Elf64_Addr(ip)
		msg = c''
	} else {
		msg = c'RUNTIME ERROR: '
	}
	skip[0] = 0
	a = fmt + 1
	b = C.strchr(a, fmt[0])
	if fmt[0] == `^` && b {
		C.memcpy(skip, a, b - a)
		skip[b - a] = 0
		fmt = b + 1
	}
	one = 0
	if fmt[0] == `\x01` {
		unsafe { fmt++ }
		one = 1
	}
	n = if rc.num_callers { rc.num_callers } else { 6 }
	i = 0
	for level = i; level < n; i++ {
		ret = rt_get_caller_pc(&pc, rc, i)
		a = c'%s'
		if ret != -1 {
			if rc.dwarf {
				pc = rt_printline_dwarf(rc, pc, if level { c'by' } else { c'at' }, skip)
			} else { // 3
				pc = rt_printline(rc, pc, if level { c'by' } else { c'at' }, skip)
			}
			if pc == Elf64_Addr(-1) {
				continue
			}
			a = c': %s'
		}
		if level == 0 {
			rt_printf('${msg}')
			rt_vprintf('${fmt}')
		} else if ret == -1 {
			break
		}
		if one {
			break
		}
		rt_printf('\n')
		if ret == -1 || (pc == Elf64_Addr(rc.top_func) && pc) {
			break
		}
		level++
	}
	rc.ip = 0
	rc.fp = rc.ip
	return 0
}

fn rt_error(msg &char) int {
	ret := _rt_error(0, 0, msg)
	return ret
}

@[typedef]
struct C.sighandler_t {
}

@[typedef]
struct C.sigset_t {
}

union Sigval {
	sival_int int
	sival_ptr voidptr
}

@[typedef]
struct C.siginfo_t {
	si_signo  int
	si_code   int
	si_errno  int
	si_pid    u64
	si_uid    u64
	s_addr    voidptr
	si_status int
	si_band   int
}

struct C.sigaction {
	sa_handler   fn (int)
	sa_mask      C.sigset_t
	sa_flags     int
	sa_sigaction fn (int, &C.siginfo_t, voidptr)
}

const NGREG = 19

@[typedef]
struct C.mcontext_t {
	gregs [NGREG]C.gregset_t
}

@[typedef]
struct C.ucontext_t {
	uc_link     &C.ucontext_t
	uc_sigmask  C.sigset_t
	uc_stack    C.stack_t
	uc_mcontext C.mcontext_t
}

type sigaction_struct = C.sigaction

fn C.signal(__sig int, __handler C.sighandler_t) C.sighandler_t

fn C.sigemptyset(__set &C.sigset_t) int

fn C.sigaction(int, &sigaction_struct, &sigaction_struct) int

fn rt_getcontext(uc &C.ucontext_t, rc &Rt_context) {
	rc.ip = uc.uc_mcontext.gregs[REG_RIP]
	rc.fp = uc.uc_mcontext.gregs[REG_RIP]
}

fn sig_error(signum int, siginf &C.siginfo_t, puc voidptr) {
	rc := &g_rtctxt
	rt_getcontext(puc, rc)
	match signum {
		8 { // case comp body kind=SwitchStmt is_enum=false
			match siginf.si_code {
				int(FPE_INTDIV), int(FPE_FLTDIV) {
					rt_error(c'division by zero')
				}
				else {
					rt_error(c'floating point exception')
				}
			}
		}
		7, 11 {
			rt_error(c'invalid memory access')
		}
		4 { // case comp body kind=CallExpr is_enum=false
			rt_error(c'illegal instruction')
		}
		6 { // case comp body kind=CallExpr is_enum=false
			rt_error(c'abort() called')
		}
		else {
			rt_error('caught signal ${signum}'.str)
		}
	}
	rt_exit(255)
}

fn set_exception_handler() {
	sigact := C.sigaction{}
	C.sigemptyset(&sigact.sa_mask)
	sigact.sa_flags = 4 | 2147483648
	sigact.sa_sigaction = sig_error
	C.sigemptyset(&sigact.sa_mask)
	C.sigaction(8, &sigact, (unsafe { nil }))
	C.sigaction(4, &sigact, (unsafe { nil }))
	C.sigaction(11, &sigact, (unsafe { nil }))
	C.sigaction(7, &sigact, (unsafe { nil }))
	C.sigaction(6, &sigact, (unsafe { nil }))
}

fn rt_get_caller_pc(paddr &Elf64_Addr, rc &Rt_context, level int) int {
	ip := Elf64_Addr(0)
	fp := Elf64_Addr(0)

	if level == 0 {
		ip = rc.ip
	} else {
		ip = 0
		fp = rc.fp
		for (level-- - 1) {
			if fp <= 4096 {
				break
			}
			fp = (&Elf64_Addr(fp))[0]
		}
		if fp > 4096 {
			ip = (&Elf64_Addr(fp))[1]
		}
	}
	if ip <= 4096 {
		return -1
	}
	*paddr = ip
	return 0
}
