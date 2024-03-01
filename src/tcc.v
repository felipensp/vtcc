@[translated]
module main

import os

#flag -ldl

#include <dlfcn.h>

const help = "Tiny C Compiler 0.9.28rc - Copyright (C) 2001-2006 Fabrice Bellard\nUsage: tcc [options...] [-o outfile] [-c] infile(s)...\n       tcc [options...] -run infile (or --) [arguments...]\nGeneral options:\n  -c           compile only - generate an object file\n  -o outfile   set output filename\n  -run         run compiled source\n  -fflag       set or reset (with 'no-' prefix) 'flag' (see tcc -hh)\n  -std=c99     Conform to the ISO 1999 C standard (default).\n  -std=c11     Conform to the ISO 2011 C standard.\n  -Wwarning    set or reset (with 'no-' prefix) 'warning' (see tcc -hh)\n  -w           disable all warnings\n  -v --version show version\n  -vv          show search paths or loaded files\n  -h -hh       show this, show more help\n  -bench       show compilation statistics\n  -            use stdin pipe as infile\n  @listfile    read arguments from listfile\nPreprocessor options:\n  -Idir        add include path 'dir'\n  -Dsym[=val]  define 'sym' with value 'val'\n  -Usym        undefine 'sym'\n  -E           preprocess only\nLinker options:\n  -Ldir        add library path 'dir'\n  -llib        link with dynamic or static library 'lib'\n  -r           generate (relocatable) object file\n  -shared      generate a shared library/dll\n  -rdynamic    export all global symbols to dynamic linker\n  -soname      set name for shared library to be used at runtime\n  -Wl,-opt[=val]  set linker option (see tcc -hh)\nDebugger options:\n  -g           generate stab runtime debug info\n  -gdwarf[-x]  generate dwarf runtime debug info\n  -b           compile with built-in memory and bounds checker (implies -g)\n  -bt[N]       link with backtrace (stack dump) support [show max N callers]\nMisc. options:\n  -x[c|a|b|n]  specify type of the next infile (C,ASM,BIN,NONE)\n  -nostdinc    do not use standard system include paths\n  -nostdlib    do not link with standard crt and libraries\n  -Bdir        set tcc's private include/library dir\n  -M[M]D       generate make dependency file [ignore system files]\n  -M[M]        as above but no other output\n  -MF file     specify dependency file name\n  -m32/64      defer to i386/x86_64 cross compiler\nTools:\n  create library  : tcc -ar [crstvx] lib [files]\n"

const help2 = "Tiny C Compiler 0.9.28rc - More Options\nSpecial options:\n  -P -P1                        with -E: no/alternative #line output\n  -dD -dM                       with -E: output #define directives\n  -pthread                      same as -D_REENTRANT and -lpthread\n  -On                           same as -D__OPTIMIZE__ for n > 0\n  -Wp,-opt                      same as -opt\n  -include file                 include 'file' above each input file\n  -isystem dir                  add 'dir' to system include path\n  -static                       link to static libraries (not recommended)\n  -dumpversion                  print version\n  -print-search-dirs            print search paths\n  -dt                           with -run/-E: auto-define 'test_...' macros\nIgnored options:\n  -arch -C --param -pedantic -pipe -s -traditional\n-W[no-]... warnings:\n  all                           turn on some (*) warnings\n  error[=warning]               stop after warning (any or specified)\n  write-strings                 strings are const\n  unsupported                   warn about ignored options, pragmas, etc.\n  implicit-function-declaration warn for missing prototype (*)\n  discarded-qualifiers          warn when const is dropped (*)\n-f[no-]... flags:\n  unsigned-char                 default char is unsigned\n  signed-char                   default char is signed\n  common                        use common section instead of bss\n  leading-underscore            decorate extern symbols\n  ms-extensions                 allow anonymous struct in struct\n  dollars-in-identifiers        allow '$' in C symbols\n  test-coverage                 create code coverage code\n-m... target specific options:\n  ms-bitfields                  use MSVC bitfield layout\n  no-sse                        disable floats on x86_64\n-Wl,... linker options:\n  -nostdlib                     do not link with standard crt/libs\n  -[no-]whole-archive           load lib(s) fully/only as needed\n  -export-all-symbols           same as -rdynamic\n  -export-dynamic               same as -rdynamic\n  -image-base= -Ttext=          set base address of executable\n  -section-alignment=           set section alignment in executable\n  -rpath=                       set dynamic library search path\n  -enable-new-dtags             set DT_RUNPATH instead of DT_RPATH\n  -soname=                      set DT_SONAME elf tag\n  -Bsymbolic                    set DT_SYMBOLIC elf tag\n  -oformat=[elf32/64-* binary]  set executable output format\n  -init= -fini= -Map= -as-needed -O   (ignored)\nPredefined macros:\n  tcc -E -dM - < /dev/null\nSee also the manual for more details.\n"

const version = 'tcc version 0.9.28rc (x86_64 Linux)\n'

fn print_dirs(msg &char, paths &&char, nb_paths int) {
	i := 0
	C.printf(c'%s:\n%s', msg, if nb_paths { c'' } else { c'  -\n' })
	for i = 0; i < nb_paths; i++ {
		C.printf(c'  %s\n', paths[i])
	}
}

fn print_search_dirs(s &TCCState) {
	C.printf(c'install: %s\n', s.tcc_lib_path)
	print_dirs(c'include', s.sysinclude_paths, s.nb_sysinclude_paths)
	print_dirs(c'libraries', s.library_paths, s.nb_library_paths)
	C.printf(c'libtcc1:\n  %s/%s\n', s.library_paths[0], c'libtcc1.a')
	print_dirs(c'crt', s.crt_paths, s.nb_crt_paths)
	C.printf(c'elfinterp:\n  %s\n', c'/lib64/ld-linux-x86-64.so.2')
}

fn set_environment(s &TCCState) {
	vcc_trace('${@LOCATION}')
	path := C.getenv(c'C_INCLUDE_PATH')
	if path != unsafe { nil } {
		vcc_trace('${@LOCATION}')
		tcc_add_sysinclude_path(s, path)
	}
	path = C.getenv(c'CPATH')
	if path != unsafe { nil } {
		vcc_trace('${@LOCATION}')
		tcc_add_include_path(s, path)
	}
	path = C.getenv(c'LIBRARY_PATH')
	if path != unsafe { nil } {
		vcc_trace('${@LOCATION}')
		tcc_add_library_path(s, path)
	}
	vcc_trace('${@LOCATION}')
}

fn default_outputfile(s &TCCState, first_file &char) &char {
	buf := [1024]char{}
	ext := &char(0)
	name := c'a'
	if first_file && unsafe { C.strcmp(first_file, c'-') } {
		name = tcc_basename(first_file)
	}
	unsafe { C.snprintf(buf, sizeof(buf), c'%s', name) }
	ext = tcc_fileextension(buf)
	if (s.just_deps || s.output_type == 3) && !s.option_r && *ext {
		C.strcpy(ext, c'.o')
	} else { // 3
		C.strcpy(buf, c'a.out')
	}
	return tcc_strdup(buf)
}

fn getclock_ms() u64 {
	tv := C.timeval{}
	C.gettimeofday(&tv, (unsafe { nil }))
	return tv.tv_sec * 1000 + (tv.tv_usec + 500) / 1000
}

fn main() {
	// vcc_disable_trace()
	s := &TCCState(0)
	s1 := &TCCState(0)

	ret := 0
	opt := 0
	n := 0
	t := 0
	done := 0

	start_time := 0
	end_time := 0

	first_file := &char(0)
	ppfp := &C.FILE(C.stdout)
	// RRRREG redo id=0x7ffff0d74558
	redo:
	argc := os.args.len
	argv := os.args

	s = tcc_new()
	s1 = s
	vcc_trace('${@LOCATION} ${argv}')
	opt = tcc_parse_args(s, argc, argv, 1)
	if opt < 0 {
		return
	}
	if n == 0 {
		if opt == 1 {
			vcc_trace('${@LOCATION} ${opt}')
			eprintln(help)
			if !s.verbose {
				vcc_trace('${@LOCATION} ${opt}')
				return
			}
			opt++
		}
		vcc_trace('${@LOCATION} ${opt}')
		if opt == 2 {
			eprintln(help2)
			return
		}
		if opt == 32 || opt == 64 {
			return
		}
		if s.verbose {
			C.printf(c'%s', version)
		}
		if opt == 5 {
			return
		}
		if opt == 3 {
			return
		}
		vcc_trace('${@LOCATION}')
		if opt == 4 {
			vcc_trace('${@LOCATION}')
			set_environment(s)
			vcc_trace('${@LOCATION}')
			tcc_set_output_type(s, 1)
			vcc_trace('${@LOCATION}')
			print_search_dirs(s)
			vcc_trace('${@LOCATION}')
			return
		}
		vcc_trace('${@LOCATION}')
		if s.nb_files == 0 {
			_tcc_error_noabort(s1, 'no input files')
		} else if s.output_type == 5 {
			eprintln('>> -1')
			if s.outfile && 0 != unsafe { C.strcmp(c'-', s.outfile) } {
				ppfp = C.fopen(s.outfile, c'w')
				if !ppfp {
					_tcc_error_noabort(s1, "could not write '${s.outfile}'")
				}
			}
		} else if s.output_type == 3 && !s.option_r {
			if s.nb_libraries {
				_tcc_error_noabort(s1, 'cannot specify libraries with -c')
			} else if s.nb_files > 1 && s.outfile {
				_tcc_error_noabort(s1, 'cannot specify output file with -c many files')
			}
		}
		if s.nb_errors {
			return
		}
		if s.do_bench {
			start_time = getclock_ms()
		}
	}
	vcc_trace('${@LOCATION}')
	set_environment(s)
	if s.output_type == 0 {
		s.output_type = 2
	}
	vcc_trace('${@LOCATION}')
	tcc_set_output_type(s, s.output_type)
	vcc_trace('${@LOCATION}')
	s.ppfp = ppfp
	if (s.output_type == 1 || s.output_type == 5) && s.dflag & 16 {
		if t {
			s.dflag |= 32
		}
		t++
		s.run_test = t
		if n {
			n--
		}
	}
	vcc_trace('${@LOCATION}')
	first_file = &char(unsafe { nil })
	ret = 0
	for {
		vcc_trace('${@LOCATION}')
		f := s.files[n]
		vcc_trace('${@LOCATION}')
		s.filetype = f.type_
		vcc_trace('${@LOCATION}')
		if f.type_ & 8 {
			vcc_trace('${@LOCATION}')
			if tcc_add_library_err(s, f.name) < 0 {
				ret = 1
			}
		} else {
			vcc_trace('${@LOCATION}')
			if 1 == s.verbose {
				vcc_trace('${@LOCATION}')
				C.printf(c'-> %s\n', f.name)
			}
			if !first_file {
				vcc_trace('${@LOCATION} ${f.name}')
				first_file = &char(f.name)
				vcc_trace('${@LOCATION} ${first_file.vstring()}')
			}
			vcc_trace_print('${@LOCATION}')
			if tcc_add_file(s, f.name) < 0 {
				ret = 1
			}
		}
		done = ret || (n++ + 1) >= s.nb_files
		// while()
		if !(!done && (s.output_type != 3 || s.option_r)) {
			break
		}
		vcc_trace_print('${@LOCATION}')
	}
	vcc_trace_print('${@LOCATION}')
	if s.do_bench {
		vcc_trace_print('${@LOCATION}')
		end_time = getclock_ms()
	}
	if s.run_test {
		t = 0
	} else if s.output_type == 5 {
	} else if 0 == ret {
		if s.output_type == 1 {
			vcc_trace_print('${@LOCATION}')
			ret = tcc_run(s, argc, argv)
		} else {
			if !s.outfile {
				vcc_trace('${@LOCATION}')
				s.outfile = default_outputfile(s, first_file)
			}
			vcc_trace_print('${@LOCATION}')
			if !s.just_deps && tcc_output_file(s, s.outfile) {
				ret = 1
			} else if s.gen_deps {
				vcc_trace_print('${@LOCATION}')
				ret = gen_makedeps(s, s.outfile, s.deps_outfile)
			}
		}
	}
	if done && 0 == t && 0 == ret && s.do_bench {
		vcc_trace_print('${@LOCATION}')
		tcc_print_stats(s, end_time - start_time)
	}
	vcc_trace_print('${@LOCATION}')
	tcc_delete(s)
	vcc_trace('${@LOCATION}')
	if !done {
		unsafe {
			vcc_trace('${@LOCATION}')
			goto redo
		} // id: 0x7ffff0d74558
	}
	if t {
		unsafe {
			vcc_trace('${@LOCATION}')
			goto redo
		} // id: 0x7ffff0d74558
	}
	if ppfp && ppfp != C.stdout {
		vcc_trace('${@LOCATION} ${ppfp}')
		C.fclose(ppfp)
		vcc_trace('${@LOCATION}')
	}
	vcc_trace('${@LOCATION}')
	return
}
