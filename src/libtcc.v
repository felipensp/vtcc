@[translated]
module main

import strings

#include <unistd.h>

type uintptr_t = usize

fn C.realloc(voidptr, int) voidptr

fn C.strcpy(&char, &char) &char
fn C.lseek(int, int, int) int
fn C.realpath(&char, &char) &char
fn C.longjmp(&C.jmp_buf, int)

// fn C.setjmp(&C.jmp_buf) int
fn C._setjmp(&C.jmp_buf) int
fn C.open(&char, int) int
fn C.dlopen(&char, int) voidptr
fn C.dlsym(voidptr, &char) voidptr
fn C.dlclose(voidptr) int
fn C.strcat(&char, &char) &char
fn C.strtoul(&char, &&char, int) u32
fn C.strtoull(&char, &&char, int) i64

pub struct Sym_version {
	lib           &i8
	version       &i8
	out_index     int
	prev_same_lib int
}

pub enum Stab_debug_code {
	n_gsym                = 32
	n_fname               = 34
	n_fun                 = 36
	n_stsym               = 38
	n_lcsym               = 40
	n_main                = 42
	n_pc                  = 48
	n_nsyms               = 50
	n_nomap               = 52
	n_obj                 = 56
	n_opt                 = 60
	n_rsym                = 64
	n_m2c                 = 66
	n_sline               = 68
	n_dsline              = 70
	n_bsline              = 72
	n_brows               = 72
	n_defd                = 74
	n_ehdecl              = 80
	n_mod2                = 80
	n_catch               = 84
	n_ssym                = 96
	n_so                  = 100
	n_lsym                = 128
	n_bincl               = 130
	n_sol                 = 132
	n_psym                = 160
	n_eincl               = 162
	n_entry               = 164
	n_lbrac               = 192
	n_excl                = 194
	n_scope               = 196
	n_rbrac               = 224
	n_bcomm               = 226
	n_ecomm               = 228
	n_ecoml               = 232
	n_nbtext              = 240
	n_nbdata              = 242
	n_nbbss               = 244
	n_nbsts               = 246
	n_nblcs               = 248
	n_leng                = 254
	last_unused_stab_code
}

@[weak]
__global (
	tcc_state &TCCState
)

@[weak]
__global (
	stk_data &voidptr
)

@[weak]
__global (
	nb_stk_data int
)

@[weak]
__global (
	file &BufferedFile
)

@[weak]
__global (
	ind int
)

@[weak]
__global (
	loc int
)

@[weak]
__global (
	tcc_compile_sem TCCSem
)

fn wait_sem(p &TCCSem) {
	if !p.init {
		C.sem_init(&p.sem, 0, 1), 1
		p.init = C.sem_init(&p.sem, 0, 1)
	}
	for C.sem_wait(&p.sem) < 0 && C.errno == 4 {
		0
	}
}

fn post_sem(p &TCCSem) {
	C.sem_post(&p.sem)
}

fn tcc_run_free(s1 &TCCState) {
	i := 0
	for i = 0; i < s1.nb_runtime_mem; i += 2 {
		size := u32(Elf64_Addr(s1.runtime_mem[i]))
		ptr := s1.runtime_mem[i + 1]
		set_pages_executable(s1, 2, ptr, size)
		tcc_free(ptr)
	}
	tcc_free(s1.runtime_mem)
}

pub fn tcc_enter_state(s1 &TCCState) {
	if s1.error_set_jmp_enabled {
		return
	}
	wait_sem(&tcc_compile_sem)
	tcc_state = s1
}

pub fn tcc_exit_state(s1 &TCCState) {
	if s1.error_set_jmp_enabled {
		return
	}
	tcc_state = (unsafe { nil })
	post_sem(&tcc_compile_sem)
}

fn pstrcpy(buf &i8, buf_size usize, s &i8) &i8 {
	q := &i8(0)
	q_end := &i8(0)

	c := 0
	if buf_size > 0 {
		q = buf
		q_end = buf + buf_size - 1
		for q < q_end {
			c = *s++
			if c == `\x00` {
				break
			}
			*q++ = c
		}
		*q = `\x00`
	}
	return buf
}

fn pstrcat(buf &i8, buf_size usize, s &i8) &i8 {
	len := usize(0)
	len = C.strlen(buf)
	if len < buf_size {
		pstrcpy(buf + len, buf_size - len, s)
	}
	return buf
}

fn pstrncpy(out &i8, in_ &i8, num usize) &i8 {
	C.memcpy(out, in_, num)
	out[num] = `\x00`
	return out
}

pub fn tcc_basename(name &char) &char {
	p := C.strchr(name, 0)
	for p > name && !(p[-1] == `/`) {
		unsafe { p-- }
	}
	return p
}

pub fn tcc_fileextension(name &char) &char {
	b := tcc_basename(name)
	e := C.strrchr(b, `.`)
	return if e { e } else { C.strchr(b, 0) }
}

pub fn tcc_load_text(fd int) &i8 {
	len := C.lseek(fd, 0, 2)
	buf := load_data(fd, 0, len + 1)
	// buf[len] = 0
	return buf
}

fn default_reallocator(ptr voidptr, size usize) voidptr {
	ptr1 := unsafe { nil }
	if size == 0 {
		C.free(ptr)
		ptr1 = unsafe { nil }
	} else if ptr != unsafe { nil } {
		ptr1 = C.malloc(size)
	} else {
		eprintln('>> ${ptr1} ${size}')
		ptr1 = C.realloc(ptr, size)
		eprintln('>> ${ptr1} ${size}')
		if ptr1 == unsafe { nil } {
			C.fprintf(C.stderr, c'memory full\n')
			C.exit(1)
		}
	}
	return ptr1
}

fn libc_free(ptr voidptr) {
	C.free(ptr)
}

pub type TCCReallocFunc = fn (voidptr, usize) voidptr

__global reallocator = TCCReallocFunc(default_reallocator)

pub fn tcc_set_realloc(realloc TCCReallocFunc) {
	reallocator = realloc
}

pub fn tcc_get_realloc() TCCReallocFunc {
	return reallocator
}

pub fn tcc_free(ptr voidptr) {
	reallocator(ptr, 0)
}

pub fn tcc_malloc(size u32) voidptr {
	return reallocator(0, size)
}

pub fn tcc_realloc(ptr voidptr, size u32) voidptr {
	return reallocator(ptr, size)
}

pub fn tcc_mallocz(size u32) voidptr {
	ptr := &voidptr(tcc_malloc(size))
	if ptr != unsafe { nil } && size {
		C.memset(ptr, 0, size)
	}
	return ptr
}

pub fn tcc_strdup(str &char) &char {
	ptr := &char(tcc_malloc(C.strlen(str) + 1))
	C.strcpy(ptr, str)
	return ptr
}

@[c: 'normalized_PATHCMP']
fn normalized_pathcmp(f1 &i8, f2 &i8) int {
	p1 := &i8(0)
	p2 := &i8(0)

	ret := 1
	p1 = C.realpath(f1, (unsafe { nil }))
	if !!p1 {
		p2 = C.realpath(f2, (unsafe { nil }))
		if !!p2 {
			ret = C.strcmp(p1, p2)
			libc_free(p2)
		}
		libc_free(p1)
	}
	return ret
}

fn dynarray_add(ptab voidptr, nb_ptr &int, data voidptr) {
	nb := 0
	nb_alloc := 0

	pp := &voidptr(0)
	nb = *nb_ptr
	pp = *&&&voidptr(ptab)
	if (nb & (nb - 1)) == 0 {
		if !nb {
			nb_alloc = 1
		} else { // 3
			nb_alloc = nb * 2
		}
		pp = tcc_realloc(pp, nb_alloc * sizeof(voidptr))
		*&&&voidptr(ptab) = pp
	}
	pp[nb++] = data
	*nb_ptr = nb
}

fn dynarray_reset(pp voidptr, n &int) {
	p := &voidptr(0)
	mut idx := 0
	for p = *&&voidptr(pp); *n; {
		if *p {
			tcc_free(*p)
		}
		p = p[idx++]
		unsafe { *n-- }
	}
	tcc_free(*&voidptr(pp))
	*&voidptr(pp) = (unsafe { nil })
}

pub fn tcc_split_path(s &TCCState, p_ary voidptr, p_nb_ary &int, in_ &i8) {
	p := &rune(0)
	for {
		c := 0
		str := strings.new_builder(0)
		cstr_new(&str)
		for p = in_; c != `\x00` && c != c':'[0]; p++ {
			if c == `{` && p[1] && p[2] == `}` {
				c = p[1]
				p += 2
				if c == `B` {
					cstr_cat(&str, s.tcc_lib_path, -1)
				}
				if c == `R` {
					cstr_cat(&str, c'', -1)
				}
				if c == `f` && file {
					f := file.truefilename
					b := tcc_basename(f)
					if b > f {
						cstr_cat(&str, f, b - f - 1)
					} else { // 3
						cstr_cat(&str, c'.', 1)
					}
				}
			} else {
				cstr_ccat(&str, c)
			}
			c = *p
		}
		if str.len {
			cstr_ccat(&str, `\x00`)
			dynarray_add(p_ary, p_nb_ary, tcc_strdup(str.data))
		}
		cstr_free(&str)
		in_ = p + 1
		// while()
		if !(*p) {
			break
		}
	}
}

// empty enum
const error_warn = 0
const error_noabort = 1
const error_error = 2

fn error1(mode int, message string) {
	f := &BufferedFile(0)

	s1 := tcc_state
	cs := strings.new_builder(100)
	tcc_exit_state(s1)
	if mode == error_warn {
		if s1.warn_error {
			mode = error_error
		}
		if s1.warn_num {
			wopt := *(&s1.warn_none + s1.warn_num)
			s1.warn_num = 0
			if 0 == (wopt & 1) {
				return
			}
			if wopt & 2 {
				mode = error_error
			}
			if wopt & 4 {
				mode = error_warn
			}
		}
		if s1.warn_none {
			return
		}
	}
	cstr_new(&cs)
	f = (unsafe { nil })
	if s1.error_set_jmp_enabled {
		f = file
		for f && f.filename[0] == c':' {
			f = f.prev
		}
	}
	if f {
		// for pf = s1.include_stack; pf < s1.include_stack_ptr; pf++ {
		// 	cstr_printf(&cs, c'In file included from %s:%d:\n', (*pf).filename, (*pf).line_num - 1)
		// }
		cstr_printf(&cs, '${f.filename}:${f.line_num - !!(tok_flags & 1)}: ')
	} else if s1.current_filename {
		cstr_printf(&cs, '${s1.current_filename}: ')
	} else {
		cstr_printf(&cs, 'tcc: ')
	}
	if mode == error_warn {
		cstr_printf(&cs, 'warning: ')
	} else {
		cstr_printf(&cs, 'error: ')
	}

	// cstr_vprintf(&cs, fmt, ap)
	if !s1 || !s1.error_func {
		if s1 && s1.output_type == 5 && s1.ppfp == C.stdout {
			C.printf(c'\n')
		}
		C.fflush(C.stdout)
		C.fprintf(C.stderr, c'%s\n', &i8(cs.data))
		C.fflush(C.stderr)
	} else {
		s1.error_func(s1.error_opaque, &char(cs.data))
	}
	cstr_free(&cs)
	if mode != error_warn {
		s1.nb_errors++
	}
	if mode == error_error && s1.error_set_jmp_enabled {
		for nb_stk_data {
			tcc_free(*&voidptr(stk_data[nb_stk_data--$]))
		}
		C.longjmp(s1.error_jmp_buf, 1)
	}
}

pub fn tcc_set_error_func(s &TCCState, error_opaque voidptr, error_func TCCErrorFunc) {
	s.error_opaque = error_opaque
	s.error_func = error_func
}

pub fn tcc_get_error_func(s &TCCState) TCCErrorFunc {
	return s.error_func
}

pub fn tcc_get_error_opaque(s &TCCState) voidptr {
	return s.error_opaque
}

fn _tcc_error_noabort(message string) int {
	error1(error_noabort, message)
	return -1
}

@[noreturn]
fn _tcc_error(message string) {
	error1(error_error, message)
	C.exit(1)
}

fn _tcc_warning(message string) {
	error1(error_warn, message)
}

pub fn tcc_open_bf(s1 &TCCState, filename &i8, initlen int) {
	bf := &BufferedFile(0)
	buflen := if initlen { initlen } else { 8192 }
	bf = tcc_mallocz(sizeof(BufferedFile) + buflen)
	bf.buf_ptr = bf.buffer
	bf.buf_end = bf.buffer + initlen
	bf.buf_end[0] = `\\`
	pstrcpy(bf.filename, sizeof(bf.filename), filename)
	bf.truefilename = bf.filename
	bf.line_num = 1
	bf.ifdef_stack_ptr = s1.ifdef_stack_ptr
	bf.fd = -1
	bf.prev = file
	file = bf
	tok_flags = 1 | 2
}

pub fn tcc_close() {
	s1 := tcc_state
	bf := file
	if bf.fd > 0 {
		C.close(bf.fd)
		s1.total_lines += bf.line_num - 1
	}
	if bf.truefilename != bf.filename {
		tcc_free(bf.truefilename)
	}
	file = bf.prev
	tcc_free(bf)
}

fn _tcc_open(s1 &TCCState, filename &i8) int {
	fd := 0
	if C.strcmp(filename, c'-') == 0 {
		fd = 0
		filename = c'<stdin>'
	} else { // 3
		fd = C.open(filename, 0 | 0)
	}
	if (s1.verbose == 2 && fd >= 0) || s1.verbose == 3 {
		val := int(*(s1.include_stack_ptr) - s1.include_stack)
		if fd < 0 {
			C.printf(c'%s %*s%s\n', c'nf', val, c'', filename)
		} else {
			C.printf(c'%s %*s%s\n', c'->', val, c'', filename)
		}
	}
	return fd
}

pub fn tcc_open(s1 &TCCState, filename &i8) int {
	fd := _tcc_open(s1, filename)
	if fd < 0 {
		return -1
	}
	tcc_open_bf(s1, filename, 0)
	file.fd = fd
	return 0
}

pub fn tcc_compile(s1 &TCCState, filetype int, str &i8, fd int) int {
	eprintln('>> ${@FN}')
	tcc_enter_state(s1)
	s1.error_set_jmp_enabled = 1
	if C._setjmp(s1.error_jmp_buf) == 0 {
		s1.nb_errors = 0
		if fd == -1 {
			len := C.strlen(str)
			tcc_open_bf(s1, c'<string>', len)
			C.memcpy(file.buffer, str, len)
		} else {
			tcc_open_bf(s1, str, 0)
			file.fd = fd
		}
		preprocess_start(s1, filetype)
		tccgen_init(s1)
		if s1.output_type == 5 {
			tcc_preprocess(s1)
		} else {
			tccelf_begin_file(s1)
			if filetype & (2 | 4) {
				tcc_assemble(s1, !!(filetype & 4))
			} else {
				tccgen_compile(s1)
			}
			tccelf_end_file(s1)
		}
	}
	tccgen_finish(s1)
	preprocess_end(s1)
	s1.error_set_jmp_enabled = 0
	tcc_exit_state(s1)
	return if s1.nb_errors != 0 { -1 } else { 0 }
}

pub fn tcc_compile_string(s &TCCState, str &i8) int {
	return tcc_compile(s, s.filetype, str, -1)
}

pub fn tcc_define_symbol(s1 &TCCState, sym &i8, value &i8) {
	eq := &i8(0)
	eq = C.strchr(sym, `=`)
	if unsafe { nil } == eq {
		eq = C.strchr(sym, 0)
	}
	if (unsafe { nil }) == value {
		value = if *eq { eq + 1 } else { c'1' }
	}
	cstr_printf(&s1.cmdline_defs, '#define ${int((eq - sym))} ${value}\n')
}

pub fn tcc_undefine_symbol(s1 &TCCState, sym &i8) {
	cstr_printf(&s1.cmdline_defs, '#undef ${sym}\n')
}

pub fn vcc_trace(msg string) {
	$if tracecall ? {
		eprintln(msg)
	}
}

pub fn tcc_new() &TCCState {
	vcc_trace('>> ${@FN}')
	s := &TCCState(tcc_mallocz(sizeof(TCCState)))
	if !s {
		return unsafe { nil }
	}
	s.gnu_ext = 1
	s.tcc_ext = 1
	s.nocommon = 1
	s.dollars_in_identifiers = 1
	s.cversion = 199901
	s.warn_implicit_function_declaration = 1
	s.warn_discarded_qualifiers = 1
	s.ms_extensions = 1
	s.ppfp = C.stdout
	s.include_stack_ptr = &s.include_stack[0]
	tcc_set_lib_path(s, c'/usr/local/lib/tcc')

	return s
}

pub fn tcc_delete(s1 &TCCState) {
	tccelf_delete(s1)
	dynarray_reset(&s1.library_paths, &s1.nb_library_paths)
	dynarray_reset(&s1.crt_paths, &s1.nb_crt_paths)
	dynarray_reset(&s1.include_paths, &s1.nb_include_paths)
	dynarray_reset(&s1.sysinclude_paths, &s1.nb_sysinclude_paths)
	tcc_free(s1.tcc_lib_path)
	tcc_free(s1.soname)
	tcc_free(s1.rpath)
	tcc_free(s1.elf_entryname)
	tcc_free(s1.init_symbol)
	tcc_free(s1.fini_symbol)
	tcc_free(s1.mapfile)
	tcc_free(s1.outfile)
	tcc_free(s1.deps_outfile)
	dynarray_reset(&s1.files, &s1.nb_files)
	dynarray_reset(&s1.target_deps, &s1.nb_target_deps)
	dynarray_reset(&s1.pragma_libs, &s1.nb_pragma_libs)
	dynarray_reset(&s1.argv, &s1.argc)
	cstr_free(&s1.cmdline_defs)
	cstr_free(&s1.cmdline_incl)
	cstr_free(&s1.linker_arg)
	tcc_run_free(s1)
	tcc_free(s1.dState)
	tcc_free(s1)
}

pub fn tcc_set_output_type(s &TCCState, output_type int) int {
	s.output_type = output_type
	if !s.nostdinc {
		tcc_add_sysinclude_path(s, c'{B}/include:/usr/local/include:/usr/include')
	}
	if output_type == 5 {
		s.do_debug = 0
		return 0
	}
	tccelf_new(s)
	if output_type == 3 {
		s.output_format = 0
		return 0
	}
	tcc_add_library_path(s, c'{B}:/usr/lib:/lib:/usr/local/lib')
	tcc_split_path(s, &s.crt_paths, &s.nb_crt_paths, c'/usr/lib')
	if output_type != 1 && !s.nostdlib {
		tccelf_add_crtbegin(s)
	}
	return 0
}

pub fn tcc_add_include_path(s &TCCState, pathname &i8) int {
	tcc_split_path(s, &s.include_paths, &s.nb_include_paths, pathname)
	return 0
}

pub fn tcc_add_sysinclude_path(s &TCCState, pathname &i8) int {
	tcc_split_path(s, &s.sysinclude_paths, &s.nb_sysinclude_paths, pathname)
	return 0
}

pub fn tcc_add_dllref(s1 &TCCState, dllname &i8, level int) &DLLReference {
	ref := &DLLReference(0)
	i := 0
	for i = 0; i < s1.nb_loaded_dlls; i++ {
		if 0 == C.strcmp(s1.loaded_dlls[i].name, dllname) {
			ref = s1.loaded_dlls[i]
			break
		}
	}
	if level == -1 {
		return ref
	}
	if ref {
		if level < ref.level {
			ref.level = level
		}
		ref.found = 1
		return ref
	}
	ref = tcc_mallocz(sizeof(DLLReference) + C.strlen(dllname))
	C.strcpy(ref.name, dllname)
	dynarray_add(&s1.loaded_dlls, &s1.nb_loaded_dlls, ref)
	ref.level = level
	ref.index = s1.nb_loaded_dlls
	return ref
}

pub fn tcc_add_file_internal(s1 &TCCState, filename &i8, flags int) int {
	fd := 0
	ret := -1

	if s1.output_type == 5 && flags & 64 {
		return 0
	}
	fd = _tcc_open(s1, filename)
	if fd < 0 {
		if flags & 16 {
			_tcc_error_noabort("file '${filename}' not found")
		}
		return -2
	}
	s1.current_filename = filename
	if flags & 64 {
		ehdr := Elf64_Ehdr{}
		obj_type := 0
		obj_type = tcc_object_type(fd, &ehdr)
		C.lseek(fd, 0, 0)
		match obj_type {
			1 { // case comp body kind=BinaryOperator is_enum=false
				ret = tcc_load_object_file(s1, fd, 0)
			}
			3 { // case comp body kind=BinaryOperator is_enum=false
				ret = tcc_load_archive(s1, fd, !(flags & 128))
			}
			2 { // case comp body kind=IfStmt is_enum=false
				if s1.output_type == 1 {
					dl := C.dlopen(filename, 256 | 1)
					if dl {
						tcc_add_dllref(s1, filename, 0).handle = dl
						ret = 0
					}
				} else { // 3
					ret = tcc_load_dll(s1, fd, filename, (flags & 32) != 0)
				}

				unsafe {
					goto check_success
				} // id: 0x7fffbf587aa8
				// RRRREG check_success id=0x7fffbf587aa8
				check_success:
				if ret < 0 {
					_tcc_error_noabort('${filename}: unrecognized file type')
				}
			}
			else {
				ret = tcc_load_ldscript(s1, fd)
			}
		}
		C.close(fd)
	} else {
		dynarray_add(&s1.target_deps, &s1.nb_target_deps, tcc_strdup(filename))
		ret = tcc_compile(s1, flags, filename, fd)
	}
	s1.current_filename = (unsafe { nil })
	return ret
}

pub fn tcc_add_file(s &TCCState, filename &i8) int {
	filetype := s.filetype
	if 0 == (filetype & (15 | 64)) {
		ext := tcc_fileextension(filename)
		if ext[0] {
			unsafe { ext++ }
			if !C.strcmp(ext, c'S') {
				filetype = 4
			} else if !C.strcmp(ext, c's') {
				filetype = 2
			} else if !C.strcmp(ext, c'c') || !C.strcmp(ext, c'h') || !C.strcmp(ext, c'i') {
				filetype = 1
			} else { // 3
				filetype |= 64
			}
		} else {
			filetype = 1
		}
	}
	return tcc_add_file_internal(s, filename, filetype | 16)
}

pub fn tcc_add_library_path(s &TCCState, pathname &i8) int {
	tcc_split_path(s, &s.library_paths, &s.nb_library_paths, pathname)
	return 0
}

pub fn tcc_add_library_internal(s1 &TCCState, fmt &i8, filename &i8, flags int, paths &&u8, nb_paths int) int {
	buf := [1024]i8{}
	i := 0
	ret := 0

	for i = 0; i < nb_paths; i++ {
		C.snprintf(buf, sizeof(buf), fmt, paths[i], filename)
		ret = tcc_add_file_internal(s1, buf, (flags & ~16) | 64)
		if ret != -2 {
			return ret
		}
	}
	if flags & 16 {
		_tcc_error_noabort("file '${filename}' not found")
	}
	return -2
}

pub fn tcc_add_dll(s &TCCState, filename &i8, flags int) int {
	return tcc_add_library_internal(s, c'%s/%s', filename, flags, s.library_paths, s.nb_library_paths)
}

pub fn tcc_add_support(s1 &TCCState, filename &i8) {
	buf := [100]i8{}
	if c''[0] {
		filename = C.strcat(C.strcpy(buf, c''), filename)
	}
	tcc_add_dll(s1, filename, 16)
}

pub fn tcc_add_crt(s1 &TCCState, filename &i8) int {
	return tcc_add_library_internal(s1, c'%s/%s', filename, 16, s1.crt_paths, s1.nb_crt_paths)
}

pub fn tcc_add_library(s &TCCState, libraryname &i8) int {
	// libs :=
	// static_libs :=
	pp := [3]&u8{}
	(unsafe { nil })
	if s.static_link {
		pp = [c'%s/lib%s.a', unsafe { nil }, unsafe { nil }]!
	} else {
		pp = [c'%s/lib%s.so', c'%s/lib%s.a', unsafe { nil }]!
	}
	flags := s.filetype & 128
	idx := 0
	for *pp[idx] {
		ret := tcc_add_library_internal(s, *pp[idx], libraryname, flags, s.library_paths,
			s.nb_library_paths)
		if ret != -2 {
			return ret
		}
		idx++
	}
	return -2
}

pub fn tcc_add_library_err(s1 &TCCState, libname &i8) int {
	ret := tcc_add_library(s1, libname)
	if ret == -2 {
		_tcc_error_noabort("library '${libname}' not found")
	}
	return ret
}

pub fn tcc_add_pragma_libs(s1 &TCCState) {
	i := 0
	for i = 0; i < s1.nb_pragma_libs; i++ {
		tcc_add_library_err(s1, s1.pragma_libs[i])
	}
}

pub fn tcc_add_symbol(s1 &TCCState, name &i8, val voidptr) int {
	buf := [256]i8{}
	if s1.leading_underscore {
		buf[0] = `_`
		pstrcpy(buf + 1, sizeof(buf) - 1, name)
		name = buf
	}
	set_global_sym(s1, name, (unsafe { nil }), Elf64_Addr(uintptr_t(val)))
	return 0
}

pub fn tcc_set_lib_path(s &TCCState, path &i8) {
	tcc_free(s.tcc_lib_path)
	s.tcc_lib_path = tcc_strdup(path)
}

fn strstart(val &char, str &&char) int {
	vcc_trace('${@FN}')
	p := &char(0)
	q := &char(0)

	p = *str
	q = val
	for q && *q {
		if p && *p != *q {
			vcc_trace('${@FN}')
			return 0
		}
		unsafe { p++ }
		unsafe { q++ }
	}
	vcc_trace('${@FN}')
	*str = p

	return 1
}

fn link_option(str &rune, val &i8, ptr &&u8) int {
	p := &rune(0)
	q := &rune(0)

	ret := 0
	if *str++ != `-` {
		return 0
	}
	if *str == `-` {
		str++
	}
	p = str
	q = val
	ret = 1
	if q[0] == `?` {
		q++
		if strstart(c'no-', &p) {
			ret = -1
		}
	}
	for *q != `\x00` && *q != `=` {
		if *p != *q {
			return 0
		}
		p++
		q++
	}
	if *q == `=` {
		if *p == 0 {
			*ptr = p
		}
		if *p != `,` && *p != `=` {
			return 0
		}
		p++
	} else if *p {
		return 0
	}
	*ptr = p
	return ret
}

fn skip_linker_arg(str &&char) &char {
	s1 := *str
	s2 := C.strchr(s1, `,`)
	*str = if s2 {
		unsafe { s2++ }
	} else {
		s2 = s1 + C.strlen(s1)
		s2
	}
	return s2
}

fn copy_linker_arg(pp &&u8, s &i8, sep int) {
	q := s
	p := *pp
	l := 0
	if p && sep {
		l = C.strlen(p)
		p[l] = sep
		l++
	}
	skip_linker_arg(&q)
	*pp = tcc_realloc(p, q - s + l + 1)
	pstrncpy(l + pp, s, q - s)
}

fn args_parser_add_file(s &TCCState, filename &i8, filetype int) {
	f := &Filespec(tcc_malloc(sizeof(Filespec) + C.strlen(filename)))
	f.type_ = filetype
	C.strcpy(f.name, filename)
	dynarray_add(&s.files, &s.nb_files, f)
}

pub fn tcc_set_linker(s &TCCState, option &i8) int {
	for *option {
		p := (unsafe { nil })
		end := (unsafe { nil })
		ignoring := 0
		if link_option(option, c'Bsymbolic', &p) {
			s.symbolic = 1
		} else if link_option(option, c'nostdlib', &p) {
			s.nostdlib = 1
		} else if link_option(option, c'e=', &p) || link_option(option, c'entry=', &p) {
			copy_linker_arg(&s.elf_entryname, p, 0)
		} else if link_option(option, c'fini=', &p) {
			copy_linker_arg(&s.fini_symbol, p, 0)
			ignoring = 1
		} else if link_option(option, c'image-base=', &p) || link_option(option, c'Ttext=', &p) {
			s.text_addr = C.strtoull(p, &end, 16)
			s.has_text_addr = 1
		} else if link_option(option, c'init=', &p) {
			copy_linker_arg(&s.init_symbol, p, 0)
			ignoring = 1
		} else if link_option(option, c'Map=', &p) {
			copy_linker_arg(&s.mapfile, p, 0)
			ignoring = 1
		} else if link_option(option, c'oformat=', &p) {
			if strstart(c'elf64-', &p) {
				s.output_format = 0
			} else if !C.strcmp(p, c'binary') {
				s.output_format = 1
			} else { // 3
				unsafe {
					goto err
				} // id: 0x7fffbf5942e8
			}
		} else if link_option(option, c'as-needed', &p) {
			ignoring = 1
		} else if link_option(option, c'O', &p) {
			ignoring = 1
		} else if link_option(option, c'export-all-symbols', &p) {
			s.rdynamic = 1
		} else if link_option(option, c'export-dynamic', &p) {
			s.rdynamic = 1
		} else if link_option(option, c'rpath=', &p) {
			copy_linker_arg(&s.rpath, p, `:`)
		} else if link_option(option, c'enable-new-dtags', &p) {
			s.enable_new_dtags = 1
		} else if link_option(option, c'section-alignment=', &p) {
			s.section_align = C.strtoul(p, &end, 16)
		} else if link_option(option, c'soname=', &p) {
			copy_linker_arg(&s.soname, p, 0)
		} else if link_option(option, c'install_name=', &p) {
			copy_linker_arg(&s.soname, p, 0)
		} else if link_option(option, c'?whole-archive', &p) {
			ret2 := link_option(option, c'?whole-archive', &p)
			if ret2 > 0 {
				s.filetype |= 128
			} else { // 3
				s.filetype &= ~128
			}
		} else if link_option(option, c'z=', &p) {
			ignoring = 1
		} else if p {
			return 0
		} else {
			// RRRREG err id=0x7fffbf5942e8
			err:
			return _tcc_error_noabort("unsupported linker option '${option}'")
		}
		if ignoring {
			tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
			_tcc_warning("unsupported linker option '${option}'")
		}
		option = skip_linker_arg(&p)
	}
	return 1
}

struct TCCOption {
	name  &i8
	index u16
	flags u16
}

// empty enum
const tcc_option_ignored = 0
const tcc_option_help = 1
const tcc_option_help2 = 2
const tcc_option_v = 3
const tcc_option_i = 4
const tcc_option_dd = 5
const tcc_option_u = 6
const tcc_option_p = 7
const tcc_option_ll = 8
const tcc_option_bb = 9
const tcc_option_l = 10
const tcc_option_bench = 11
const tcc_option_bt = 12
const tcc_option_b = 13
const tcc_option_ba = 14
const tcc_option_g = 15
const tcc_option_c = 16
const tcc_option_dumpmachine = 17
const tcc_option_dumpversion = 18
const tcc_option_d = 19
const tcc_option_static = 20
const tcc_option_std = 21
const tcc_option_shared = 22
const tcc_option_soname = 23
const tcc_option_o = 24
const tcc_option_r = 25
const tcc_option_wl = 26
const tcc_option_wp = 27
const tcc_option_ww = 28
const tcc_option_oo = 29
const tcc_option_mfloat_abi = 30
const tcc_option_m = 31
const tcc_option_f = 32
const tcc_option_isystem = 33
const tcc_option_iwithprefix = 34
const tcc_option_include = 35
const tcc_option_nostdinc = 36
const tcc_option_nostdlib = 37
const tcc_option_print_search_dirs = 38
const tcc_option_rdynamic = 39
const tcc_option_pthread = 40
const tcc_option_run = 41
const tcc_option_w = 42
const tcc_option_e = 43
const tcc_option_m2 = 44
const tcc_option_md = 45
const tcc_option_mf = 46
const tcc_option_mm = 47
const tcc_option_mmd = 48
const tcc_option_mp = 49
const tcc_option_x = 50
const tcc_option_ar = 51
const tcc_option_impdef = 52
const tcc_option_dynamiclib = 53
const tcc_option_flat_namespace = 54
const tcc_option_two_levelnamespace = 55
const tcc_option_undefined = 56
const tcc_option_install_name = 57
const tcc_option_compatibility_version = 58
const tcc_option_current_version = 59

__global tcc_options = [TCCOption{
	name: c'h'
	index: tcc_option_help
	flags: 0
}, TCCOption{
	name: c'-help'
	index: tcc_option_help
	flags: 0
}, TCCOption{
	name: c'?'
	index: tcc_option_help
	flags: 0
}, TCCOption{
	name: c'hh'
	index: tcc_option_help2
	flags: 0
}, TCCOption{
	name: c'v'
	index: tcc_option_v
	flags: 1 | 2
}, TCCOption{
	name: c'-version'
	index: tcc_option_v
	flags: 0
}, TCCOption{
	name: c'I'
	index: tcc_option_i
	flags: 1
}, TCCOption{
	name: c'D'
	index: tcc_option_dd
	flags: 1
}, TCCOption{
	name: c'U'
	index: tcc_option_u
	flags: 1
}, TCCOption{
	name: c'P'
	index: tcc_option_p
	flags: 1 | 2
}, TCCOption{
	name: c'L'
	index: tcc_option_ll
	flags: 1
}, TCCOption{
	name: c'B'
	index: tcc_option_bb
	flags: 1
}, TCCOption{
	name: c'l'
	index: tcc_option_l
	flags: 1
}, TCCOption{
	name: c'bench'
	index: tcc_option_bench
	flags: 0
}, TCCOption{
	name: c'bt'
	index: tcc_option_bt
	flags: 1 | 2
}, TCCOption{
	name: c'b'
	index: tcc_option_b
	flags: 0
}, TCCOption{
	name: c'g'
	index: tcc_option_g
	flags: 1 | 2
}, TCCOption{
	name: c'c'
	index: tcc_option_c
	flags: 0
}, TCCOption{
	name: c'dumpmachine'
	index: tcc_option_dumpmachine
	flags: 0
}, TCCOption{
	name: c'dumpversion'
	index: tcc_option_dumpversion
	flags: 0
}, TCCOption{
	name: c'd'
	index: tcc_option_d
	flags: 1 | 2
}, TCCOption{
	name: c'static'
	index: tcc_option_static
	flags: 0
}, TCCOption{
	name: c'std'
	index: tcc_option_std
	flags: 1 | 2
}, TCCOption{
	name: c'shared'
	index: tcc_option_shared
	flags: 0
}, TCCOption{
	name: c'soname'
	index: tcc_option_soname
	flags: 1
}, TCCOption{
	name: c'o'
	index: tcc_option_o
	flags: 1
}, TCCOption{
	name: c'pthread'
	index: tcc_option_pthread
	flags: 0
}, TCCOption{
	name: c'run'
	index: tcc_option_run
	flags: 1 | 2
}, TCCOption{
	name: c'rdynamic'
	index: tcc_option_rdynamic
	flags: 0
}, TCCOption{
	name: c'r'
	index: tcc_option_r
	flags: 0
}, TCCOption{
	name: c'Wl,'
	index: tcc_option_wl
	flags: 1 | 2
}, TCCOption{
	name: c'Wp,'
	index: tcc_option_wp
	flags: 1 | 2
}, TCCOption{
	name: c'W'
	index: tcc_option_ww
	flags: 1 | 2
}, TCCOption{
	name: c'O'
	index: tcc_option_oo
	flags: 1 | 2
}, TCCOption{
	name: c'm'
	index: tcc_option_m
	flags: 1 | 2
}, TCCOption{
	name: c'f'
	index: tcc_option_f
	flags: 1 | 2
}, TCCOption{
	name: c'isystem'
	index: tcc_option_isystem
	flags: 1
}, TCCOption{
	name: c'include'
	index: tcc_option_include
	flags: 1
}, TCCOption{
	name: c'nostdinc'
	index: tcc_option_nostdinc
	flags: 0
}, TCCOption{
	name: c'nostdlib'
	index: tcc_option_nostdlib
	flags: 0
}, TCCOption{
	name: c'print-search-dirs'
	index: tcc_option_print_search_dirs
	flags: 0
}, TCCOption{
	name: c'w'
	index: tcc_option_w
	flags: 0
}, TCCOption{
	name: c'E'
	index: tcc_option_e
	flags: 0
}, TCCOption{
	name: c'M'
	index: tcc_option_m2
	flags: 0
}, TCCOption{
	name: c'MD'
	index: tcc_option_md
	flags: 0
}, TCCOption{
	name: c'MF'
	index: tcc_option_mf
	flags: 1
}, TCCOption{
	name: c'MM'
	index: tcc_option_mm
	flags: 0
}, TCCOption{
	name: c'MMD'
	index: tcc_option_mmd
	flags: 0
}, TCCOption{
	name: c'MP'
	index: tcc_option_mp
	flags: 0
}, TCCOption{
	name: c'x'
	index: tcc_option_x
	flags: 1
}, TCCOption{
	name: c'ar'
	index: tcc_option_ar
	flags: 0
}, TCCOption{
	name: c'arch'
	index: 0
	flags: 1
}, TCCOption{
	name: c'C'
	index: 0
	flags: 0
}, TCCOption{
	name: c'-param'
	index: 0
	flags: 1
}, TCCOption{
	name: c'pedantic'
	index: 0
	flags: 0
}, TCCOption{
	name: c'pipe'
	index: 0
	flags: 0
}, TCCOption{
	name: c's'
	index: 0
	flags: 0
}, TCCOption{
	name: c'traditional'
	index: 0
	flags: 0
}, TCCOption{
	name: (unsafe { nil })
	index: 0
	flags: 0
}]!

struct FlagDef {
	offset u32
	flags  u16
	name   &i8
}

const options_W = [
	FlagDef{
		offset: __offsetof(TCCState, warn_all)
		flags: 1
		name: c'all'
	},
	FlagDef{
		offset: __offsetof(TCCState, warn_error)
		flags: 0
		name: c'error'
	},
	FlagDef{
		offset: __offsetof(TCCState, warn_write_strings)
		flags: 0
		name: c'write-strings'
	},
	FlagDef{
		offset: __offsetof(TCCState, warn_unsupported)
		flags: 0
		name: c'unsupported'
	},
	FlagDef{
		offset: __offsetof(TCCState, warn_implicit_function_declaration)
		flags: 1
		name: c'implicit-function-declaration'
	},
	FlagDef{
		offset: __offsetof(TCCState, warn_discarded_qualifiers)
		flags: 1
		name: c'discarded-qualifiers'
	},
	FlagDef{
		offset: 0
		flags: 0
		name: (unsafe { nil })
	},
]!

const options_f = [
	FlagDef{
		offset: __offsetof(TCCState, char_is_unsigned)
		flags: 0
		name: c'unsigned-char'
	},
	FlagDef{
		offset: __offsetof(TCCState, char_is_unsigned)
		flags: 2
		name: c'signed-char'
	},
	FlagDef{
		offset: __offsetof(TCCState, nocommon)
		flags: 2
		name: c'common'
	},
	FlagDef{
		offset: __offsetof(TCCState, leading_underscore)
		flags: 0
		name: c'leading-underscore'
	},
	FlagDef{
		offset: __offsetof(TCCState, ms_extensions)
		flags: 0
		name: c'ms-extensions'
	},
	FlagDef{
		offset: __offsetof(TCCState, dollars_in_identifiers)
		flags: 0
		name: c'dollars-in-identifiers'
	},
	FlagDef{
		offset: __offsetof(TCCState, test_coverage)
		flags: 0
		name: c'test-coverage'
	},
	FlagDef{
		offset: 0
		flags: 0
		name: (unsafe { nil })
	},
]!

const options_m = [
	FlagDef{
		offset: __offsetof(TCCState, ms_bitfields)
		flags: 0
		name: c'ms-bitfields'
	},
	FlagDef{
		offset: __offsetof(TCCState, nosse)
		flags: 2
		name: c'sse'
	},
	FlagDef{
		offset: 0
		flags: 0
		name: (unsafe { nil })
	},
]!

fn set_flag(s &TCCState, flags &FlagDef, name &i8) int {
	value := 0
	mask := 0
	ret := 0

	p := &FlagDef(0)
	r := &i8(0)
	f := &u8(0)
	r = name
	value = !strstart(c'no-', &r)
	mask = 0
	if flags.flags & 1 && strstart(c'error=', &r) {
		value = if value { 1 | 2 } else { 4 }
		mask = 1
	}
	ret = -1
	for p = flags; p.name != unsafe { nil }; {
		if ret {
			if C.strcmp(r, p.name) {
				unsafe { p++ }
				continue
			}
		} else {
			if 0 == (p.flags & 1) {
				unsafe { p++ }
				continue
			}
		}
		f = &u8(s) + p.offset
		*f = (*f & mask) | (value ^ !!(p.flags & 2))
		if ret {
			ret = 0
			if C.strcmp(r, c'all') {
				break
			}
		}
		unsafe { p++ }
	}
	return ret
}

const dumpmachine_str = 'x86_64-pc-linux-gnu'

fn args_parser_make_argv(r &rune, argc &int, argv &&&i8) int {
	ret := 0
	q := 0
	c := 0

	str := strings.new_builder(100)
	for {
		for {
			c = u8(*r)
			if !(c && c <= ` `) {
				break
			}
			r++
		}
		if c == 0 {
			break
		}
		q = 0
		cstr_new(&str)
		for {
			c = u8(*r)
			if !c {
				break
			}
			r++
			if c == `\\` && (*r == `"` || *r == `\\`) {
				c = *r++
			} else if c == `"` {
				q = !q
				continue
			} else if q == 0 && c <= ` ` {
				break
			}
			cstr_ccat(&str, c)
		}
		cstr_ccat(&str, 0)
		dynarray_add(argv, argc, tcc_strdup(str.data))
		cstr_free(&str)
		ret++
	}
	return ret
}

fn args_parser_listfile(s &TCCState, filename &i8, optind int, pargc &int, pargv &&&i8) int {
	fd := 0
	i := 0

	p := &i8(0)
	argc := 0
	argv := (unsafe { nil })
	fd = C.open(filename, 0 | 0)
	if fd < 0 {
		return _tcc_error_noabort("listfile '${filename}' not found")
	}
	p = tcc_load_text(fd)
	for i = 0; i < *pargc; i++ {
		if i == optind {
			args_parser_make_argv(p, &argc, &argv)
		} else { // 3
			dynarray_add(&argv, &argc, tcc_strdup((*pargv)[i]))
		}
	}
	tcc_free(p)
	dynarray_reset(&s.argv, &s.argc)
	s.argc = argc
	*pargc = s.argc
	s.argv = argv
	*pargv = s.argv
	return 0
}

pub fn tcc_parse_args(s &TCCState, pargc &int, pargv []string, optind int) int {
	vcc_trace('>> ${@FN}')
	popt := &TCCOption(0)
	optarg := &u8(0)
	r := &u8(0)

	run := (unsafe { nil })
	x := 0
	tool := 0
	arg_start := 0
	noaction := optind

	argv := pargv
	argc := pargc
	vcc_trace('>> ${@LOCATION}')
	cstr_reset(&s.linker_arg)
	for optind < argc {
		r = argv[optind].str
		vcc_trace('>> ${@LOCATION} ${optind} ${argv}')
		if r[0] == `@` && r[1] != `\x00` {
			if args_parser_listfile(s, r + 1, optind, &argc, &argv) {
				return -1
			}
			vcc_trace('>> ${@LOCATION} ${optind}')
			continue
		}
		vcc_trace('>> ${@LOCATION} ${optind}')
		optind++
		vcc_trace('>> ${@LOCATION} ${optind} ${r}')
		if tool {
			if r[0] == `-` && r[1] == `v` && r[2] == 0 {
				s.verbose++
			}
			continue
		}
		vcc_trace('>> ${@LOCATION} ${optind}')
		// RRRREG reparse id=0x7fffbf5aa950
		reparse:
		if r[0] != `-` || r[1] == `\x00` {
			args_parser_add_file(s, r, s.filetype)
			if run {
				// RRRREG dorun id=0x7fffbf5aa788
				dorun:
				if tcc_set_options(s, run) {
					return -1
				}
				arg_start = optind - 1
				break
			}
			continue
		}
		vcc_trace('>> ${@LOCATION} ${optind}')
		if r[1] == `-` && r[2] == `\x00` && run {
			unsafe {
				goto dorun
			} // id: 0x7fffbf5aa788
		}
		popt = tcc_options
		for {
			p1 := popt.name
			r1 := r + 1
			if p1 == (unsafe { nil }) {
				return _tcc_error_noabort("invalid option -- '${r}'")
			}
			vcc_trace('>> ${@LOCATION} ${optind} ${p1} ${r1}')
			if !strstart(p1, &r1) {
				unsafe { popt++ }
				vcc_trace('>> ${@LOCATION} ${optind} ${optarg}')
				continue
			}
			vcc_trace('>> ${@LOCATION} ${optind} ${optarg}')
			optarg = r1
			if popt.flags & 1 {
				if *r1 == `\x00` && !(popt.flags & 2) {
					if optind >= argc {
						// RRRREG arg_err id=0x7fffbf5ab8d0
						arg_err:
						return _tcc_error_noabort("argument to '${r}' is missing")
					}
					optarg = argv[optind++].str
				}
			} else if *r1 != `\x00` {
				unsafe { popt++ }
				continue
			}
			break
		}
		vcc_trace('>> ${@LOCATION} ${optind}')
		match popt.index {
			tcc_option_help { // case comp body kind=BinaryOperator is_enum=true
				x = 1
				unsafe {
					goto extra_action
				} // id: 0x7fffbf5abdd0
			}
			tcc_option_help2 { // case comp body kind=BinaryOperator is_enum=true
				x = 2
				unsafe {
					goto extra_action
				} // id: 0x7fffbf5abdd0
			}
			tcc_option_i { // case comp body kind=CallExpr is_enum=true
				tcc_add_include_path(s, optarg)
			}
			tcc_option_dd { // case comp body kind=CallExpr is_enum=true
				tcc_define_symbol(s, optarg, (unsafe { nil }))
			}
			tcc_option_u { // case comp body kind=CallExpr is_enum=true
				tcc_undefine_symbol(s, optarg)
			}
			tcc_option_ll { // case comp body kind=CallExpr is_enum=true
				tcc_add_library_path(s, optarg)
			}
			tcc_option_bb { // case comp body kind=CallExpr is_enum=true
				tcc_set_lib_path(s, optarg)
				noaction++
			}
			tcc_option_l { // case comp body kind=CallExpr is_enum=true
				args_parser_add_file(s, optarg, 8 | (s.filetype & ~(15 | 64)))
				s.nb_libraries++
			}
			tcc_option_pthread { // case comp body kind=BinaryOperator is_enum=true
				s.option_pthread = 1
			}
			tcc_option_bench { // case comp body kind=BinaryOperator is_enum=true
				s.do_bench = 1
			}
			tcc_option_bt { // case comp body kind=BinaryOperator is_enum=true
				s.rt_num_callers = C.atoi(optarg)
				// RRRREG enable_backtrace id=0x7fffbf5ace88
				enable_backtrace:
				s.do_backtrace = 1
				s.do_debug = if s.do_debug { s.do_debug } else { 1 }
				s.dwarf = 0
			}
			tcc_option_b { // case comp body kind=BinaryOperator is_enum=true
				s.do_bounds_check = 1
				unsafe {
					goto enable_backtrace
				} // id: 0x7fffbf5ace88
			}
			tcc_option_g { // case comp body kind=BinaryOperator is_enum=true
				s.do_debug = 2
				s.dwarf = 0
				if strstart(c'dwarf', &optarg) {
					s.dwarf = if (*optarg) { (0 - C.atoi(optarg)) } else { 5 }
				} else if isnum(*optarg) {
					x = *optarg - `0`
					s.do_debug = if x > 2 {
						2
					} else {
						if x == 0 && s.do_backtrace { 1 } else { x }
					}
				}
			}
			tcc_option_c { // case comp body kind=BinaryOperator is_enum=true
				x = 3
				// RRRREG set_output_type id=0x7fffbf5ae198
				set_output_type:
				if s.output_type {
					_tcc_warning('-${popt.name}: overriding compiler action already specified')
				}
				s.output_type = x
			}
			tcc_option_d { // case comp body kind=IfStmt is_enum=true
				if *optarg == `D` {
					s.dflag = 3
				} else if *optarg == `M` {
					s.dflag = 7
				} else if *optarg == `t` {
					s.dflag = 16
				} else if isnum(*optarg) {
					s.g_debug |= C.atoi(optarg)
				} else { // 3
					unsafe {
						goto unsupported_option
					} // id: 0x7fffbf5ae9a8
				}
			}
			tcc_option_static { // case comp body kind=BinaryOperator is_enum=true
				s.static_link = 1
			}
			tcc_option_std { // case comp body kind=IfStmt is_enum=true
				if C.strcmp(optarg, c'=c11') == 0 {
					s.cversion = 201112
				}
			}
			tcc_option_shared { // case comp body kind=BinaryOperator is_enum=true
				x = 4
				unsafe {
					goto set_output_type
				} // id: 0x7fffbf5ae198
			}
			tcc_option_soname { // case comp body kind=BinaryOperator is_enum=true
				s.soname = tcc_strdup(optarg)
			}
			tcc_option_o { // case comp body kind=IfStmt is_enum=true
				if s.outfile {
					_tcc_warning('multiple -o option')
					tcc_free(s.outfile)
				}
				s.outfile = tcc_strdup(optarg)
			}
			tcc_option_r { // case comp body kind=BinaryOperator is_enum=true
				s.option_r = 1
				x = 3
				unsafe {
					goto set_output_type
				} // id: 0x7fffbf5ae198
			}
			tcc_option_isystem { // case comp body kind=CallExpr is_enum=true
				tcc_add_sysinclude_path(s, optarg)
			}
			tcc_option_include { // case comp body kind=CallExpr is_enum=true
				cstr_printf(&s.cmdline_incl, '#include "${optarg}"\n')
			}
			tcc_option_nostdinc { // case comp body kind=BinaryOperator is_enum=true
				s.nostdinc = 1
			}
			tcc_option_nostdlib { // case comp body kind=BinaryOperator is_enum=true
				s.nostdlib = 1
			}
			tcc_option_run { // case comp body kind=BinaryOperator is_enum=true
				run = optarg
				x = 1
				unsafe {
					goto set_output_type
				} // id: 0x7fffbf5ae198
			}
			tcc_option_v { // case comp body kind=DoStmt is_enum=true
				vcc_trace('>> ${@LOCATION} ${optind}')
				for {
					s.verbose
					// while()
					if !(*optarg++ == `v`) {
						break
					}
				}
				noaction++
			}
			tcc_option_f { // case comp body kind=IfStmt is_enum=true
				if set_flag(s, options_f, optarg) < 0 {
					unsafe {
						goto unsupported_option
					} // id: 0x7fffbf5ae9a8
				}
			}
			tcc_option_m { // case comp body kind=IfStmt is_enum=true
				if set_flag(s, options_m, optarg) < 0 {
					x = C.atoi(optarg)
					if x != 32 && x != 64 {
						unsafe {
							goto unsupported_option
						} // id: 0x7fffbf5ae9a8
					}
					if 8 != x / 8 {
						return x
					}
					noaction++
				}
			}
			tcc_option_ww { // case comp body kind=BinaryOperator is_enum=true
				s.warn_none = 0
				if optarg[0] && set_flag(s, options_W, optarg) < 0 {
					unsafe {
						goto unsupported_option
					} // id: 0x7fffbf5ae9a8
				}
			}
			tcc_option_w { // case comp body kind=BinaryOperator is_enum=true
				s.warn_none = 1
			}
			tcc_option_rdynamic { // case comp body kind=BinaryOperator is_enum=true
				s.rdynamic = 1
			}
			tcc_option_wl { // case comp body kind=IfStmt is_enum=true
				if s.linker_arg.len {
					(&i8(s.linker_arg.data))[s.linker_arg.len - 1] = `,`
				}
				cstr_cat(&s.linker_arg, optarg, 0)
				x = tcc_set_linker(s, s.linker_arg.data)
				if x {
					cstr_reset(&s.linker_arg)
				}
				if x < 0 {
					return -1
				}
			}
			tcc_option_wp { // case comp body kind=BinaryOperator is_enum=true
				r = optarg
				unsafe {
					goto reparse
				} // id: 0x7fffbf5aa950
			}
			tcc_option_e { // case comp body kind=BinaryOperator is_enum=true
				x = 5
				unsafe {
					goto set_output_type
				} // id: 0x7fffbf5ae198
			}
			tcc_option_p { // case comp body kind=BinaryOperator is_enum=true
				s.pflag = C.atoi(optarg) + 1
			}
			tcc_option_m2 { // case comp body kind=BinaryOperator is_enum=true
				s.include_sys_deps = 1
			}
			tcc_option_mm { // case comp body kind=BinaryOperator is_enum=true
				s.just_deps = 1
				if !s.deps_outfile {
					s.deps_outfile = tcc_strdup(c'-')
				}
			}
			tcc_option_mmd { // case comp body kind=BinaryOperator is_enum=true
				s.gen_deps = 1
			}
			tcc_option_md { // case comp body kind=BinaryOperator is_enum=true
				s.gen_deps = 1
				s.include_sys_deps = 1
			}
			tcc_option_mf { // case comp body kind=BinaryOperator is_enum=true
				s.deps_outfile = tcc_strdup(optarg)
			}
			tcc_option_mp { // case comp body kind=BinaryOperator is_enum=true
				s.gen_phony_deps = 1
			}
			tcc_option_dumpmachine { // case comp body kind=CallExpr is_enum=true
				C.printf(c'%s\n', dumpmachine_str.str)
				C.exit(0)
			}
			tcc_option_dumpversion { // case comp body kind=CallExpr is_enum=true
				C.printf(c'%s\n', c'0.9.28rc')
				C.exit(0)
			}
			tcc_option_x { // case comp body kind=BinaryOperator is_enum=true
				x = 0
				if *optarg == `c` {
					x = 1
				} else if *optarg == `a` {
					x = 4
				} else if *optarg == `b` {
					x = 64
				} else if *optarg == `n` {
					x = 0
				} else { // 3
					_tcc_warning("unsupported language '${optarg}'")
				}
				s.filetype = x | (s.filetype & ~(15 | 64))
			}
			tcc_option_oo { // case comp body kind=BinaryOperator is_enum=true
				s.optimize = C.atoi(optarg)
			}
			tcc_option_print_search_dirs { // case comp body kind=BinaryOperator is_enum=true
				x = 4
				unsafe {
					goto extra_action
				} // id: 0x7fffbf5abdd0
			}
			tcc_option_impdef { // case comp body kind=BinaryOperator is_enum=true
				x = 6
				unsafe {
					goto extra_action
				} // id: 0x7fffbf5abdd0
			}
			tcc_option_ar { // case comp body kind=BinaryOperator is_enum=true
				x = 5
				// RRRREG extra_action id=0x7fffbf5abdd0
				extra_action:
				arg_start = optind - 1
				if arg_start != noaction {
					return _tcc_error_noabort('cannot parse ${r} here')
				}
				tool = x
			}
			else {
				// RRRREG unsupported_option id=0x7fffbf5ae9a8
				unsupported_option:
				tcc_state.warn_num = __offsetof(TCCState, warn_unsupported) - __offsetof(TCCState, warn_none)
				_tcc_warning("unsupported option '${r}'")
			}
		}
		vcc_trace('>> ${@LOCATION} ${optind}')
	}
	if s.linker_arg.len {
		r = s.linker_arg.data
		unsafe {
			goto arg_err
		} // id: 0x7fffbf5ab8d0
	}
	vcc_trace('>> ${@LOCATION}')
	unsafe {
		*pargc = *argc - arg_start
		pargv = argv[arg_start..]
	}
	if tool {
		return tool
	}
	if optind != noaction {
		return 0
	}
	if s.verbose == 2 {
		return 4
	}
	if s.verbose {
		return 3
	}
	return 1
}

pub fn tcc_set_options(s &TCCState, r &i8) int {
	argv := []string{}
	argc := 0
	ret := 0

	args_parser_make_argv(r, &argc, &argv)
	ret = tcc_parse_args(s, &argc, &argv, 0)
	dynarray_reset(&argv, &argc)
	return if ret < 0 { ret } else { 0 }
}

pub fn tcc_print_stats(s1 &TCCState, total_time u32) {
	if !total_time {
		total_time = 1
	}
	C.fprintf(C.stderr, c'# %d idents, %d lines, %u bytes\n# %0.3f s, %u lines/s, %0.1f MB/s\n',
		s1.total_idents, s1.total_lines, s1.total_bytes, f64(total_time) / 1000, u32(s1.total_lines) * 1000 / total_time,
		f64(s1.total_bytes) / 1000 / total_time)
	C.fprintf(C.stderr, c'# text %u, data.rw %u, data.ro %u, bss %u bytes\n', s1.total_output[0],
		s1.total_output[1], s1.total_output[2], s1.total_output[3])
}
