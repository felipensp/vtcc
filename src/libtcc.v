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
	lib           &char
	version       &char
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

//__global tcc_state = &TCCState{}
__global stk_data = &voidptr(0)
__global nb_stk_data int
__global file = &BufferedFile(0)

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
	vcc_trace('${@LOCATION}')
	if s1.error_set_jmp_enabled {
		vcc_trace('${@LOCATION}')
		return
	}
	vcc_trace('${@LOCATION}')
	wait_sem(&tcc_compile_sem)
	tcc_state = s1
	vcc_trace('${@LOCATION} symtab: ${s1.symtab != unsafe { nil }}')
}

pub fn tcc_exit_state(s1 &TCCState) {
	vcc_trace('${@LOCATION} ${s1 != unsafe { nil }}')
	if s1.error_set_jmp_enabled {
		return
	}
	tcc_state = unsafe { nil }
	vcc_trace('${@LOCATION}')
	post_sem(&tcc_compile_sem)
	vcc_trace('${@LOCATION}')
}

fn pstrcpy(buf &char, buf_size usize, s &char) &char {
	q := &char(0)
	q_end := &char(0)

	c := 0
	if buf_size > 0 {
		q = &char(buf)
		q_end = &char(buf) + buf_size - 1
		unsafe {
			for q < q_end {
				c = *s++
				if c == `\x00` {
					break
				}
				*q++ = c
			}
			*q = `\x00`
		}
	}
	return buf
}

fn pstrcat(buf &char, buf_size usize, s &char) &char {
	len := usize(0)
	len = C.strlen(buf)
	if len < buf_size {
		pstrcpy(buf + len, buf_size - len, s)
	}
	return buf
}

fn pstrncpy(out &char, in_ &char, num usize) &char {
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

pub fn tcc_load_text(fd int) &char {
	len := C.lseek(fd, 0, 2)
	buf := load_data(fd, 0, len + 1)
	// buf[len] = 0
	return buf
}

fn default_reallocator(ptr voidptr, size usize) voidptr {
	ptr1 := unsafe { nil }
	if size == 0 {
		$if tracealloc ? {
			vcc_trace('${@LOCATION} free ${ptr} ${size}')
		}
		C.free(ptr)
		ptr1 = unsafe { nil }
	} else if ptr == unsafe { nil } {
		ptr1 = C.malloc(size)
		$if tracealloc ? {
			vcc_trace('${@LOCATION} malloc ${ptr} ${size}')
		}
	} else {
		$if tracealloc ? {
			vcc_trace('${@LOCATION} realloc ${ptr} ${size}')
		}
		ptr1 = C.realloc(ptr, size)
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
	return reallocator(unsafe { nil }, size)
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
fn normalized_pathcmp(f1 &char, f2 &char) int {
	p1 := &char(0)
	p2 := &char(0)

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

	nb = *nb_ptr
	pp := &voidptr(0)

	pp = *&&voidptr(ptab)
	if (nb & (nb - 1)) == 0 {
		if !nb {
			nb_alloc = 1
		} else { // 3
			nb_alloc = nb * 2
		}
		pp = tcc_realloc(pp, nb_alloc * sizeof(voidptr))
		*&&voidptr(ptab) = pp
	}
	pp[nb++] = data
	*nb_ptr = nb
}

fn dynarray_reset(pp voidptr, n &int) {
	vcc_trace('${@LOCATION}')
	p := &voidptr(0)
	vcc_trace('${@LOCATION}')
	for p = *&&voidptr(pp); *n != 0; {
		if *p {
			vcc_trace('${@LOCATION}')
			tcc_free(*p)
		}
		unsafe {
			p = &p[0] + 1
			(*n)--
		}
	}
	vcc_trace('${@LOCATION}')
	tcc_free(*&voidptr(pp))
	vcc_trace('${@LOCATION}')
	*&voidptr(pp) = unsafe { nil }
	vcc_trace('${@LOCATION}')
}

pub fn tcc_split_path(s &TCCState, p_ary voidptr, p_nb_ary &int, in_ &char) {
	p := &char(0)
	for {
		vcc_trace('${@LOCATION}: ${in_.vstring()}')
		str := strings.new_builder(40)
		cstr_new(&str)
		unsafe {
			p = in_
			c := *p
			for ; c != `\x00` && c != `:`; p++ {
				if c == `{` && p[1] && p[2] == `}` {
					c = p[1]
					p += 2
					if c == `B` {
						vcc_trace('${@LOCATION} ${s.tcc_lib_path.vstring()}')
						cstr_cat(&str, s.tcc_lib_path, -1)
					}
					if c == `R` {
						sysroot := CONFIG_SYSROOT
						vcc_trace('${@LOCATION} ${sysroot}')
						cstr_cat(&str, sysroot.str, -1)
					}
					if c == `f` && file != nil {
						f := file.truefilename
						b := tcc_basename(f)
						if b > f {
							// vcc_trace('${@LOCATION}')
							cstr_cat(&str, f, b - f - 1)
						} else { // 3
							cstr_cat(&str, c'.', 1)
						}
					}
				} else {
					// vcc_trace('${@LOCATION} - ${c:c}')
					cstr_ccat(&str, c)
				}
				c = p[1]
			}
		}
		if str.len {
			cstr_ccat(&str, `\x00`)
			a := tcc_strdup(&char(str.data))
			vcc_trace('${@LOCATION} ${s.tcc_lib_path.vstring()} - ${str.len} ${str.data} - ${a}')
			dynarray_add(p_ary, p_nb_ary, a)
		}
		vcc_trace('${@LOCATION} - ${str.len}')
		cstr_free(&str)
		vcc_trace('${@LOCATION}  ${str.str()}')
		in_ = p + 1
		vcc_trace('${@LOCATION}')
		// while()
		if !(*p) {
			break
		}
	}
	vcc_trace('${@LOCATION}')
}

// empty enum
const error_warn = 0
const error_noabort = 1
const error_error = 2

fn error1(mode int, message string) {
	vcc_trace('${@LOCATION} ${message} ${tcc_state != unsafe { nil }}')
	f := &BufferedFile(0)
	s1 := &TCCState(tcc_state)
	cs := strings.new_builder(100)
	vcc_trace('${@LOCATION} ${tcc_state != unsafe { nil }}')
	tcc_exit_state(s1)
	vcc_trace('${@LOCATION}')
	if mode == error_warn {
		if s1.warn_error {
			mode = error_error
		}
		if s1.warn_num {
			vcc_trace('${@LOCATION}')
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
	vcc_trace('${@LOCATION}')
	cstr_new(&cs)
	vcc_trace('${@LOCATION}')
	f = &char(unsafe { nil })
	if s1.error_set_jmp_enabled {
		f = &char(file)
		for f && f.filename[0] == `:` {
			f = &char(f.prev)
		}
	}
	if f != unsafe { nil } {
		vcc_trace('${f.buf_ptr.vstring()}')
		unsafe {
			for pf := &s1.include_stack[0]; &char(pf) < &char(s1.include_stack_ptr); pf++ {
				cstr_printf(&cs, 'In file included from ${(&char(&(*pf).filename[0])).vstring()}:${(*pf).line_num - 1}:\n')
			}
		}
		cstr_printf(&cs, '${(&char(&f.filename[0])).vstring()}:${f.line_num - !!(tok_flags & 1)}: ')
	} else if s1.current_filename {
		cstr_printf(&cs, '${(&char(s1.current_filename)).vstring()}: ')
	} else {
		cstr_printf(&cs, 'tcc: ')
	}
	if mode == error_warn {
		cstr_printf(&cs, 'warning: ')
	} else {
		cstr_printf(&cs, 'error: ')
	}

	cstr_printf(&cs, message)
	if !s1 || !s1.error_func {
		if s1 && s1.output_type == 5 && s1.ppfp == C.stdout {
			C.printf(c'\n')
		}
		C.fflush(C.stdout)
		vcc_trace('${@LOCATION}')
		C.fprintf(C.stderr, c'%s\n', cs.str().str)
		C.fflush(C.stderr)
	} else {
		s1.error_func(s1.error_opaque, cs.str().str)
	}
	cstr_free(&cs)
	if mode != error_warn {
		s1.nb_errors++
	}
	if mode == error_error && s1.error_set_jmp_enabled {
		for nb_stk_data {
			tcc_free(*&voidptr(stk_data[nb_stk_data-- - 1]))
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

fn _tcc_error_noabort(s &TCCState, message string) int {
	vcc_trace('${@LOCATION} ${tcc_state != unsafe { nil }}')
	tcc_enter_state(s)
	error1(error_noabort, message)
	return -1
}

@[noreturn]
fn _tcc_error(message string) {
	// tcc_enter_state(s)
	error1(error_error, message)
	C.exit(1)
}

fn _tcc_warning(message string) {
	// tcc_enter_state(s)
	error1(error_warn, message)
}

pub fn tcc_open_bf(s1 &TCCState, filename &char, initlen int) {
	buflen := if initlen { initlen } else { 8192 }
	bf := &BufferedFile(tcc_mallocz(sizeof(BufferedFile) + buflen))
	vcc_trace('${@LOCATION} ${filename.vstring()}')
	bf.buf_ptr = &bf.buffer[0]
	bf.buf_end = &bf.buffer[0] + initlen
	vcc_trace('${@LOCATION} ${bf.buf_ptr} ${bf.buf_end}')
	bf.buf_end[0] = `\\`
	pstrcpy(bf.filename, sizeof(bf.filename), filename)
	bf.truefilename = &char(bf.filename)
	bf.line_num = 1
	bf.ifdef_stack_ptr = s1.ifdef_stack_ptr
	bf.fd = -1
	bf.prev = file
	file = bf
	tok_flags = 1 | 2
	vcc_trace('${@LOCATION} ${bf.buf_ptr} ${bf.buf_end}')
}

pub fn tcc_close() {
	// vcc_trace('${@LOCATION}')
	s1 := tcc_state
	bf := file
	vcc_trace('${@LOCATION} ${bf.fd} ${bf.truefilename.vstring()} ${bf.line_num}')
	if bf.fd > 0 {
		// vcc_trace('${@LOCATION} ${bf.truefilename.vstring()}')
		C.close(bf.fd)
		// vcc_trace('${@LOCATION}')
		s1.total_lines += bf.line_num - 1
	}
	// vcc_trace('${@LOCATION}')
	if bf.truefilename != bf.filename {
		tcc_free(bf.truefilename)
	}
	// vcc_trace('${@LOCATION}')
	file = bf.prev
	// vcc_trace('${@LOCATION} ${bf == unsafe { nil }}')
	tcc_free(bf)
	vcc_trace('${@LOCATION}')
}

fn _tcc_open(s1 &TCCState, filename &char) int {
	fd := 0
	if C.strcmp(filename, c'-') == 0 {
		fd = 0
		filename = c'<stdin>'
	} else { // 3
		fd = C.open(filename, 0 | 0)
	}
	if (s1.verbose == 2 && fd >= 0) || s1.verbose == 3 {
		val := (&char(s1.include_stack_ptr) - &char(&s1.include_stack[0])) / sizeof(&BufferedFile)
		if fd < 0 {
			C.printf(c'%s %*s%s\n', c'nf', val, c'', filename)
		} else {
			C.printf(c'%s %*s%s\n', c'->', val, c'', filename)
		}
	}
	return fd
}

pub fn tcc_open(s1 &TCCState, filename &char) int {
	fd := _tcc_open(s1, filename)
	if fd < 0 {
		return -1
	}
	tcc_open_bf(s1, filename, 0)
	file.fd = fd
	return 0
}

pub fn tcc_compile(s1 &TCCState, filetype int, str &char, fd int) int {
	vcc_trace('${@LOCATION} ${s1.symtab != unsafe { nil }} ${str.vstring()}')
	tcc_enter_state(s1)
	s1.error_set_jmp_enabled = 1
	if C._setjmp(s1.error_jmp_buf) == 0 {
		vcc_trace('${@LOCATION}')
		s1.nb_errors = 0
		if fd == -1 {
			len := C.strlen(str)
			vcc_trace('${@LOCATION} ${str}')
			tcc_open_bf(s1, c'<string>', len)
			C.memcpy(file.buffer, str, len)
			vcc_trace('${@LOCATION}')
		} else {
			vcc_trace('${@LOCATION} ${str.vstring()}')
			tcc_open_bf(s1, str, 0)
			file.fd = fd
		}
		vcc_trace('${@LOCATION} ${s1.symtab != unsafe { nil }}')
		preprocess_start(s1, filetype)
		vcc_trace('${@LOCATION} ${s1.symtab != unsafe { nil }}')
		tccgen_init(s1)
		vcc_trace('${@LOCATION} ${s1.symtab != unsafe { nil }}')
		if s1.output_type == 5 {
			vcc_trace('${@LOCATION}')
			tcc_preprocess(s1)
		} else {
			vcc_trace('${@LOCATION} ${s1.symtab != unsafe { nil }}')
			tccelf_begin_file(s1)
			vcc_trace('${@LOCATION}')
			if filetype & (2 | 4) {
				vcc_trace('${@LOCATION}')
				tcc_assemble(s1, !!(filetype & 4))
			} else {
				vcc_trace('${@LOCATION}')
				tccgen_compile(s1)
			}
			vcc_trace('${@LOCATION}')
			tccelf_end_file(s1)
		}
	}
	vcc_trace('${@LOCATION}')
	tccgen_finish(s1)
	vcc_trace('${@LOCATION}')
	preprocess_end(s1)
	vcc_trace('${@LOCATION}')
	s1.error_set_jmp_enabled = 0
	tcc_exit_state(s1)
	return if s1.nb_errors != 0 { -1 } else { 0 }
}

pub fn tcc_compile_string(s &TCCState, str &char) int {
	return tcc_compile(s, s.filetype, str, -1)
}

pub fn tcc_define_symbol(s1 &TCCState, sym &char, value &char) {
	eq := &char(0)
	eq = C.strchr(sym, `=`)
	if unsafe { nil } == eq {
		eq = C.strchr(sym, 0)
	}
	if (unsafe { nil }) == value {
		value = if *eq { eq + 1 } else { c'1' }
	}
	cstr_printf(&s1.cmdline_defs, '#define ${int((eq - sym))} ${value}\n')
}

pub fn tcc_undefine_symbol(s1 &TCCState, sym &char) {
	cstr_printf(&s1.cmdline_defs, '#undef ${sym}\n')
}

pub fn tcc_new() &TCCState {
	vcc_trace('${@LOCATION}')
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
	tcc_set_lib_path(s, c'/home/felipe/github/tcc')

	return s
}

pub fn tcc_delete(s1 &TCCState) {
	vcc_trace('${@LOCATION}')
	tccelf_delete(s1)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.library_paths, &s1.nb_library_paths)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.crt_paths, &s1.nb_crt_paths)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.include_paths, &s1.nb_include_paths)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.sysinclude_paths, &s1.nb_sysinclude_paths)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.tcc_lib_path)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.soname)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.rpath)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.elf_entryname)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.init_symbol)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.fini_symbol)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.mapfile)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.outfile)
	vcc_trace('${@LOCATION}')
	tcc_free(s1.deps_outfile)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.files, &s1.nb_files)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.target_deps, &s1.nb_target_deps)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.pragma_libs, &s1.nb_pragma_libs)
	vcc_trace('${@LOCATION}')
	dynarray_reset(&s1.argv, &s1.argc)
	vcc_trace('${@LOCATION}')
	cstr_free(&s1.cmdline_defs)
	cstr_free(&s1.cmdline_incl)
	cstr_free(&s1.linker_arg)
	vcc_trace('${@LOCATION}')
	tcc_run_free(s1)
	tcc_free(s1.dState)
	tcc_free(s1)
	vcc_trace('${@LOCATION}')
}

pub fn tcc_set_output_type(s &TCCState, output_type int) int {
	s.output_type = output_type
	if !s.nostdinc {
		vcc_trace('${@LOCATION}')
		tcc_add_sysinclude_path(s, c'{B}/include:/usr/include/x86_64-linux-gnu:/usr/include')
	}
	if output_type == 5 {
		s.do_debug = 0
		return 0
	}
	vcc_trace('${@LOCATION} ${s.symtab != unsafe { nil }}')
	tccelf_new(s)
	vcc_trace('${@LOCATION} ${s.nb_sections} ${s.symtab != unsafe { nil }}')
	if output_type == 3 {
		s.output_format = 0
		return 0
	}
	vcc_trace('${@LOCATION}')
	tcc_add_library_path(s, c'{B}:{R}:/usr/lib:/lib/x86_64-linux-gnu:/usr/local/lib')
	vcc_trace('${@LOCATION}')
	tcc_split_path(s, &s.crt_paths, &s.nb_crt_paths, c'{R}')
	vcc_trace('${@LOCATION}')
	if output_type != 1 && !s.nostdlib {
		vcc_trace('${@LOCATION}')
		tccelf_add_crtbegin(s)
	}
	vcc_trace('${@LOCATION}')
	return 0
}

pub fn tcc_add_include_path(s &TCCState, pathname &char) int {
	tcc_split_path(s, &s.include_paths, &s.nb_include_paths, pathname)
	return 0
}

pub fn tcc_add_sysinclude_path(s &TCCState, pathname &char) int {
	vcc_trace('${@LOCATION} - ${pathname.vstring()}')
	tcc_split_path(s, &s.sysinclude_paths, &s.nb_sysinclude_paths, pathname)
	return 0
}

pub fn tcc_add_dllref(s1 &TCCState, dllname &char, level int) &DLLReference {
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

pub fn tcc_add_file_internal(s1 &TCCState, filename &char, flags int) int {
	fd := 0
	ret := -1

	if s1.output_type == 5 && flags & 64 {
		return 0
	}
	vcc_trace('${@LOCATION}')
	fd = _tcc_open(s1, filename)
	vcc_trace('${@LOCATION}')
	if fd < 0 {
		if flags & 16 {
			vcc_trace('${@LOCATION}')
			_tcc_error_noabort(s1, "file '${filename.vstring()}' not found")
		}
		return -2
	}
	s1.current_filename = filename
	if flags & 64 {
		ehdr := Elf64_Ehdr{}
		obj_type := 0
		vcc_trace('${@LOCATION}')
		obj_type = tcc_object_type(fd, &ehdr)
		C.lseek(fd, 0, 0)
		vcc_trace('${@LOCATION}')
		match obj_type {
			1 { // case comp body kind=BinaryOperator is_enum=false
				vcc_trace('${@LOCATION}')
				ret = tcc_load_object_file(s1, fd, 0)
				vcc_trace('${@LOCATION}')
			}
			3 { // case comp body kind=BinaryOperator is_enum=false
				vcc_trace('${@LOCATION}')
				ret = tcc_load_archive(s1, fd, !(flags & 128))
				vcc_trace('${@LOCATION}')
			}
			2 { // case comp body kind=IfStmt is_enum=false
				if s1.output_type == 1 {
					vcc_trace('${@LOCATION}')
					dl := C.dlopen(filename, 256 | 1)
					vcc_trace('${@LOCATION}')
					if dl {
						vcc_trace('${@LOCATION} - ${filename.vstring()}')
						tcc_add_dllref(s1, filename, 0).handle = dl
						vcc_trace('${@LOCATION}')
						ret = 0
					}
				} else { // 3
					vcc_trace('${@LOCATION}')
					ret = tcc_load_dll(s1, fd, filename, (flags & 32) != 0)
					vcc_trace('${@LOCATION}')
				}

				unsafe {
					vcc_trace('${@LOCATION}')
					goto check_success
				} // id: 0x7fffbf587aa8
				// RRRREG check_success id=0x7fffbf587aa8
				check_success:
				if ret < 0 {
					_tcc_error_noabort(s1, '${filename}: unrecognized file type')
				}
			}
			else {
				vcc_trace('${@LOCATION}')
				ret = tcc_load_ldscript(s1, fd)
				vcc_trace('${@LOCATION}')
			}
		}
		vcc_trace('${@LOCATION}')
		C.close(fd)
		vcc_trace('${@LOCATION}')
	} else {
		vcc_trace('${@LOCATION}')
		dynarray_add(&s1.target_deps, &s1.nb_target_deps, tcc_strdup(filename))
		vcc_trace('${@LOCATION}')
		ret = tcc_compile(s1, flags, filename, fd)
		vcc_trace('${@LOCATION}')
	}
	vcc_trace('${@LOCATION}')
	s1.current_filename = unsafe { nil }
	return ret
}

pub fn tcc_add_file(s &TCCState, filename &char) int {
	vcc_trace('${@LOCATION}')
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
	vcc_trace('${@LOCATION}')
	return tcc_add_file_internal(s, filename, filetype | 16)
}

pub fn tcc_add_library_path(s &TCCState, pathname &char) int {
	tcc_split_path(s, &s.library_paths, &s.nb_library_paths, pathname)
	return 0
}

pub fn tcc_add_library_internal(s1 &TCCState, fmt &char, filename &char, flags int, paths &&char, nb_paths int) int {
	buf := [1024]char{}
	i := 0
	ret := 0
	vcc_trace('${@LOCATION} ${nb_paths} ${paths} ${fmt.vstring()} ${filename.vstring()}')
	for i = 0; i < nb_paths; i++ {
		vcc_trace('${@LOCATION} - ${paths[i].vstring()}')
		C.snprintf(buf, sizeof(buf), fmt, paths[i], filename)
		ret = tcc_add_file_internal(s1, buf, (flags & ~16) | 64)
		vcc_trace('${@LOCATION} - ${(&char(buf)).vstring()} ${filename.vstring()} ${ret}')
		vcc_trace('${@LOCATION} - ${paths[i].vstring()}')
		if ret != -2 {
			vcc_trace('${@LOCATION} - ${paths[i].vstring()} - found')
			return ret
		}
	}
	if flags & 16 {
		vcc_trace('${@LOCATION} ${s1 != unsafe { nil }}')
		_tcc_error_noabort(s1, "file '${filename.vstring()}' not found")
	}
	vcc_trace('${@LOCATION} - not found')
	return -2
}

pub fn tcc_add_dll(s &TCCState, filename &char, flags int) int {
	vcc_trace('${@LOCATION} - ${filename.vstring()}')
	return tcc_add_library_internal(s, c'%s/%s', filename, flags, s.library_paths, s.nb_library_paths)
}

pub fn tcc_add_support(s1 &TCCState, filename &char) {
	buf := [100]char{}
	if c''[0] {
		filename = C.strcat(C.strcpy(buf, c''), filename)
	}
	vcc_trace('${@LOCATION} - ${filename.vstring()}')
	tcc_add_dll(s1, filename, 16)
}

pub fn tcc_add_crt(s1 &TCCState, filename &char) int {
	vcc_trace('${@LOCATION}')
	return tcc_add_library_internal(s1, c'%s/%s', filename, 16, s1.crt_paths, s1.nb_crt_paths)
}

pub fn tcc_add_library(s &TCCState, libraryname &char) int {
	vcc_trace('${@LOCATION}')
	pp := [3]&u8{}
	if s.static_link {
		pp = [c'%s/lib%s.a', unsafe { nil }, unsafe { nil }]!
	} else {
		pp = [c'%s/lib%s.so', c'%s/lib%s.a', unsafe { nil }]!
	}
	flags := s.filetype & 128
	idx := 0
	vcc_trace('${@LOCATION}')
	for pp[idx] {
		vcc_trace('>> ${pp[idx].vstring()} ${s.static_link} ${idx} ${libraryname.vstring()} ')
		ret := tcc_add_library_internal(s, pp[idx], libraryname, flags, s.library_paths,
			s.nb_library_paths)
		vcc_trace('${@LOCATION}')
		if ret != -2 {
			return ret
		}
		idx++
		vcc_trace('${@LOCATION}')
	}
	return -2
}

pub fn tcc_add_library_err(s1 &TCCState, libname &char) int {
	ret := tcc_add_library(s1, libname)
	if ret == -2 {
		_tcc_error_noabort(s1, "library '${libname.vstring()}' not found")
	}
	return ret
}

pub fn tcc_add_pragma_libs(s1 &TCCState) {
	i := 0
	for i = 0; i < s1.nb_pragma_libs; i++ {
		tcc_add_library_err(s1, s1.pragma_libs[i])
	}
}

pub fn tcc_add_symbol(s1 &TCCState, name &char, val voidptr) int {
	buf := [256]char{}
	if s1.leading_underscore {
		buf[0] = `_`
		pstrcpy(buf + 1, sizeof(buf) - 1, name)
		name = buf
	}
	set_global_sym(s1, name, (unsafe { nil }), Elf64_Addr(uintptr_t(val)))
	return 0
}

pub fn tcc_set_lib_path(s &TCCState, path &char) {
	tcc_free(s.tcc_lib_path)
	s.tcc_lib_path = tcc_strdup(path)
}

fn strstart(val &char, str &&char) int {
	p := &char(0)
	q := &char(0)

	p = *str
	q = val
	for q && *q {
		if p && *p != *q {
			return 0
		}
		unsafe { p++ }
		unsafe { q++ }
	}
	*str = p

	return 1
}

fn link_option(str &char, val &char, ptr &&char) int {
	p := &char(0)
	q := &char(0)

	ret := 0
	unsafe {
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
	}
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

fn copy_linker_arg(pp &&u8, s &char, sep int) {
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

fn args_parser_add_file(s &TCCState, filename &char, filetype int) {
	vcc_trace('${@LOCATION} ${C.strlen(filename)}')
	f := &Filespec(tcc_malloc(sizeof(Filespec) + C.strlen(filename)))
	f.type_ = filetype
	vcc_trace('${@LOCATION} ${filename.vstring()}')
	C.strcpy(f.name, filename)
	dynarray_add(&s.files, &s.nb_files, f)
	vcc_trace('${@LOCATION}')
}

pub fn tcc_set_linker(s &TCCState, option &char) int {
	s1 := s
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
			return _tcc_error_noabort(s1, "unsupported linker option '${option}'")
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
	name  &char
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
	name   &char
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

fn set_flag(s &TCCState, flags &FlagDef, name &char) int {
	value := 0
	mask := 0
	ret := 0

	p := &FlagDef(0)
	r := &char(0)
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

fn args_parser_make_argv(r &rune, argc &int, argv &&&char) int {
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
		cstr_ccat(&str, `\x00`)
		dynarray_add(argv, argc, tcc_strdup(str.data))
		cstr_free(&str)
		ret++
	}
	return ret
}

fn args_parser_listfile(s &TCCState, filename &char, optind int, pargc &int, pargv &&&char) int {
	s1 := s
	fd := 0
	i := 0

	p := &char(0)
	argc := 0
	argv := (unsafe { nil })
	fd = C.open(filename, 0 | 0)
	if fd < 0 {
		return _tcc_error_noabort(s1, "listfile '${filename.vstring()}' not found")
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
	vcc_trace('>> ${@LOCATION}')
	s1 := s
	popt := &TCCOption(0)
	optarg := &char(0)
	r := &char(0)

	run := unsafe { nil }
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
		vcc_trace('>> ${@LOCATION} ${optind} ${argv} ${r.vstring()}')
		if r[0] == `@` && r[1] != `\x00` {
			if args_parser_listfile(s, r + 1, optind, &argc, &argv) {
				return -1
			}
			vcc_trace('>> ${@LOCATION} ${optind}')
			continue
		}
		optind++
		vcc_trace('>> ${@LOCATION} ${optind} ${r.vstring()}')
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
		vcc_trace('>> ${@LOCATION} ${optind} ${r.vstring()} ${run}')
		if r[1] == `-` && r[2] == `\x00` && run {
			unsafe {
				goto dorun
			} // id: 0x7fffbf5aa788
		}
		vcc_trace('>> ${@LOCATION} ${optind} ${r.vstring()} ${run}')
		popt = &tcc_options
		for {
			p1 := &char(popt.name)
			r1 := r + 1
			if p1 == unsafe { nil } {
				return _tcc_error_noabort(s1, "invalid option -- '${r.vstring()}'")
			}
			vcc_trace('>> ${@LOCATION} ${optind} ${p1.vstring()} ${r1.vstring()}')
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
						return _tcc_error_noabort(s1, "argument to '${r.vstring()}' is missing")
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
					s.verbose++
					// while()
					unsafe {
						if !(*optarg++ == `v`) {
							break
						}
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
					(&char(s.linker_arg.data))[s.linker_arg.len - 1] = `,`
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
					return _tcc_error_noabort(s1, 'cannot parse ${r} here')
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

pub fn tcc_set_options(s &TCCState, r &char) int {
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
