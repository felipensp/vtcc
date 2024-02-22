@[translated]
module main

struct ArHdr {
	ar_name [16]char
	ar_date [12]char
	ar_uid  [6]char
	ar_gid  [6]char
	ar_mode [8]char
	ar_size [10]char
	ar_fmag [2]char
}

fn le2belong(ul u32) u32 {
	return ((ul & 16711680) >> 8) + ((ul & 4278190080) >> 24) + ((ul & 255) << 24) +
		((ul & 65280) << 8)
}

fn contains_any(s &i8, list &i8) int {
	l := &i8(0)
	for ; *s; s++ {
		for l = list; *l; l++ {
			if *s == *l {
				return 1
			}
		}
	}
	return 0
}

fn ar_usage(ret int) int {
	C.fprintf(C.stderr, c'usage: tcc -ar [crstvx] lib [files]\n')
	C.fprintf(C.stderr, c'create library ([abdiopN] not supported).\n')
	return ret
}

fn tcc_tool_ar(s1 &TCCState, argc int, argv &&u8) int {
	arhdr_init := ArHdr{}
	C.memcpy(arhdr_init.ar_name, c'/               ', sizeof(c'/               '))
	C.memcpy(arhdr_init.ar_date, c'0           ', sizeof(c'0           '))
	C.memcpy(arhdr_init.ar_uid, c'0     ', sizeof(c'0     '))
	C.memcpy(arhdr_init.ar_gid, c'0     ', sizeof(c'0     '))
	C.memcpy(arhdr_init.ar_mode, c'0       ', sizeof(c'0       '))
	C.memcpy(arhdr_init.ar_size, c'0         ', sizeof(c'0         '))
	C.memcpy(arhdr_init.ar_fmag, c'`\n', sizeof(c'`\n'))

	arhdr := arhdr_init
	arhdro := arhdr_init
	fi := &C.FILE(0)
	fh := (unsafe { nil })
	fo := (unsafe { nil })

	created_file := (unsafe { nil })
	ehdr := &Elf64_Ehdr(0)
	shdr := &Elf64_Shdr(0)
	sym := &Elf64_Sym(0)
	i := 0
	fsize := 0
	i_lib := 0
	i_obj := 0

	buf := &i8(0)
	shstr := &i8(0)
	symtab := &u8(unsafe { nil })
	strtab := &u8(unsafe { nil })

	symtabsize := 0
	anames := &u8(unsafe { nil })
	afpos := &int(unsafe { nil })
	istrlen := 0
	strpos := 0
	fpos := 0
	funccnt := 0
	funcmax := 0
	hofs := 0

	tfile := [260]i8{}
	stmp := [20]i8{}

	file := &i8(0)
	name := &i8(0)

	ret := 2
	ops_conflict := c'habdiopN'
	extract := 0
	table := 0
	verbose := 0
	i_lib = 0
	i_obj = 0
	for i = 1; i < argc; i++ {
		a := argv[i]
		if *a == `-` && C.strstr(a, c'.') {
			ret = 1
		}
		if *a == `-` || (i == 1 && !C.strstr(a, c'.')) {
			if contains_any(a, ops_conflict) {
				ret = 1
			}
			if C.strstr(a, c'x') {
				extract = 1
			}
			if C.strstr(a, c't') {
				table = 1
			}
			if C.strstr(a, c'v') {
				verbose = 1
			}
		} else {
			if !i_lib {
				i_lib = i
			} else if !i_obj {
				i_obj = i
			}
		}
	}
	if !i_lib {
		ret = 1
	}
	i_obj = if i_obj { i_obj } else { argc }
	if ret == 1 {
		return ar_usage(ret)
	}
	if extract || table {
		fh = C.fopen(argv[i_lib], c'rb')
		if fh == (unsafe { nil }) {
			C.fprintf(C.stderr, c"tcc: ar: can't open file %s\n", argv[i_lib])
			goto finish // id: 0x7ffff3215730
		}
		C.fread(stmp, 1, 8, fh)
		if C.memcmp(stmp, c'!<arch>\n', 8) {
			// RRRREG no_ar id=0x7ffff3215da0
			no_ar:
			C.fprintf(C.stderr, c'tcc: ar: not an ar archive %s\n', argv[i_lib])
			goto finish // id: 0x7ffff3215730
		}
		for C.fread(&arhdr, 1, sizeof(arhdr), fh) == sizeof(arhdr) {
			p := &i8(0)
			e := &i8(0)

			if C.memcmp(arhdr.ar_fmag, c'`\n', 2) {
				goto no_ar // id: 0x7ffff3215da0
			}
			p = arhdr.ar_name
			for e = p + sizeof(arhdr.ar_name); e > p && e[-1] == c' '; {
				e--
			}
			*e = `\x00`
			arhdr.ar_size[sizeof(arhdr.ar_size) - 1] = 0
			fsize = C.atoi(arhdr.ar_size)
			buf = tcc_malloc(fsize + 1)
			C.fread(buf, fsize, 1, fh)
			if C.strcmp(arhdr.ar_name, c'/') && C.strcmp(arhdr.ar_name, c'/SYM64/') {
				if e > p && e[-1] == c'/' {
					e[-1] = `\x00`
				}
				if table || verbose {
					C.printf(c'%s%s\n', if extract { c'x - ' } else { c'' }, arhdr.ar_name)
				}
				if extract {
					fo = C.fopen(arhdr.ar_name, c'wb')
					if fo == (unsafe { nil }) {
						C.fprintf(C.stderr, c"tcc: ar: can't create file %s\n", arhdr.ar_name)
						tcc_free(buf)
						goto finish // id: 0x7ffff3215730
					}
					C.fwrite(buf, fsize, 1, fo)
					C.fclose(fo)
				}
			}
			tcc_free(buf)
		}
		ret = 0
		// RRRREG finish id=0x7ffff3215730
		finish:
		if fh {
			C.fclose(fh)
		}
		return ret
	}
	fh = C.fopen(argv[i_lib], c'wb')
	if fh == (unsafe { nil }) {
		C.fprintf(C.stderr, c"tcc: ar: can't create file %s\n", argv[i_lib])
		goto the_end // id: 0x7ffff3218a30
	}
	created_file = argv[i_lib]
	C.sprintf(tfile, c'%s.tmp', argv[i_lib])
	fo = C.fopen(tfile, c'wb+')
	if fo == (unsafe { nil }) {
		C.fprintf(C.stderr, c"tcc: ar: can't create temporary file %s\n", tfile)
		goto the_end // id: 0x7ffff3218a30
	}
	funcmax = 250
	afpos = tcc_realloc((unsafe { nil }), funcmax * sizeof(*afpos))
	C.memcpy(&arhdro.ar_mode, c'100644', 6)
	for i_obj < argc {
		if *argv[i_obj] == `-` {
			i_obj++
			continue
		}
		fi = C.fopen(argv[i_obj], c'rb')
		if fi == (unsafe { nil }) {
			C.fprintf(C.stderr, c"tcc: ar: can't open file %s \n", argv[i_obj])
			goto the_end // id: 0x7ffff3218a30
		}
		if verbose {
			C.printf(c'a - %s\n', argv[i_obj])
		}
		C.fseek(fi, 0, 2)
		fsize = C.ftell(fi)
		C.fseek(fi, 0, 0)
		buf = tcc_malloc(fsize + 1)
		C.fread(buf, fsize, 1, fi)
		C.fclose(fi)
		ehdr = &Elf64_Ehdr(buf)
		if ehdr.e_ident[4] != 2 {
			C.fprintf(C.stderr, c'tcc: ar: Unsupported Elf Class: %s\n', argv[i_obj])
			goto the_end // id: 0x7ffff3218a30
		}
		shdr = &Elf64_Shdr((buf + ehdr.e_shoff + ehdr.e_shstrndx * ehdr.e_shentsize))
		shstr = &i8((buf + shdr.sh_offset))
		for i = 0; i < ehdr.e_shnum; i++ {
			shdr = &Elf64_Shdr((buf + ehdr.e_shoff + i * ehdr.e_shentsize))
			if !shdr.sh_offset {
				continue
			}
			if shdr.sh_type == 2 {
				symtab = &i8((buf + shdr.sh_offset))
				symtabsize = shdr.sh_size
			}
			if shdr.sh_type == 3 {
				if !C.strcmp(shstr + shdr.sh_name, c'.strtab') {
					strtab = &i8((buf + shdr.sh_offset))
				}
			}
		}
		if symtab && symtabsize {
			nsym := symtabsize / sizeof(Elf64_Sym)
			for i = 1; i < nsym; i++ {
				sym = &Elf64_Sym((symtab + i * sizeof(Elf64_Sym)))
				if sym.st_shndx && (sym.st_info == 16 || sym.st_info == 17
					|| sym.st_info == 18 || sym.st_info == 32 || sym.st_info == 33
					|| sym.st_info == 34) {
					istrlen = C.strlen(strtab + sym.st_name) + 1
					anames = &u8(tcc_realloc(anames, strpos + istrlen))
					C.strcpy(anames + strpos, strtab + sym.st_name)
					strpos += istrlen
					if (funccnt++ + 1) >= funcmax {
						funcmax += 250
						afpos = tcc_realloc(afpos, funcmax * sizeof(*afpos))
					}
					afpos[funccnt] = fpos
				}
			}
		}
		file = argv[i_obj]
		for name = C.strchr(file, 0); name > file && name[-1] != c'/' && name[-1] != c'\\'; name-- {
			0
		}
		istrlen = C.strlen(name)
		if istrlen >= sizeof(arhdro.ar_name) {
			istrlen = sizeof(arhdro.ar_name) - 1
		}
		C.memset(arhdro.ar_name, ` `, sizeof(arhdro.ar_name))
		C.memcpy(arhdro.ar_name, name, istrlen)
		arhdro.ar_name[istrlen] = `/`
		C.sprintf(stmp, c'%-10d', fsize)
		C.memcpy(&arhdro.ar_size, stmp, 10)
		C.fwrite(&arhdro, sizeof(arhdro), 1, fo)
		C.fwrite(buf, fsize, 1, fo)
		tcc_free(buf)
		i_obj++
		fpos += (fsize + sizeof(arhdro))
	}
	hofs = 8 + sizeof(arhdr) + strpos + (funccnt + 1) * sizeof(int)
	fpos = 0
	if (hofs & 1) {
		hofs++, 1
		fpos = hofs++
	}
	C.fwrite(c'!<arch>\n', 8, 1, fh)
	if !funccnt {
		ret = 0
		goto the_end // id: 0x7ffff3218a30
	}
	C.sprintf(stmp, c'%-10d', int((strpos + (funccnt + 1) * sizeof(int))) + fpos)
	C.memcpy(&arhdr.ar_size, stmp, 10)
	C.fwrite(&arhdr, sizeof(arhdr), 1, fh)
	afpos[0] = le2belong(funccnt)
	for i = 1; i <= funccnt; i++ {
		afpos[i] = le2belong(afpos[i] + hofs)
	}
	C.fwrite(afpos, (funccnt + 1) * sizeof(int), 1, fh)
	C.fwrite(anames, strpos, 1, fh)
	if fpos {
		C.fwrite(c'', 1, 1, fh)
	}
	C.fseek(fo, 0, 2)
	fsize = C.ftell(fo)
	C.fseek(fo, 0, 0)
	buf = tcc_malloc(fsize + 1)
	C.fread(buf, fsize, 1, fo)
	C.fwrite(buf, fsize, 1, fh)
	tcc_free(buf)
	ret = 0
	// RRRREG the_end id=0x7ffff3218a30
	the_end:
	if anames {
		tcc_free(anames)
	}
	if afpos {
		tcc_free(afpos)
	}
	if fh {
		C.fclose(fh)
	}
	if created_file && ret != 0 {
		C.remove(created_file)
	}
	if fo {
		C.fclose(fo), C.remove(tfile)
	}
	return ret
}

fn tcc_tool_cross(s1 &TCCState, argv &&char, target int) int {
	program := [4096]i8{}
	a0 := argv[0]
	prefix := tcc_basename(a0) - a0
	if target == 64 {
		C.snprintf(program, sizeof(program), c'%.*s%s-tcc', prefix, a0, c'x86_64')
	} else {
		C.snprintf(program, sizeof(program), c'%.*s%s-tcc', prefix, a0, c'i386')
	}
	if C.strcmp(a0, program) {
		argv[0] = program
		C.execvp(program, argv)
	}
	_tcc_error_noabort(s1, "could not run '${program}'")
	return 1
}

fn escape_target_dep(s &i8) &i8 {
	res := &u8(tcc_malloc(C.strlen(s) * 2 + 1))
	j := 0
	for j = 0; *s; s++, j++ {
		if is_space(*s) {
			res[j++] = `\\`
		}
		res[j] = *s
	}
	res[j] = `\x00`
	return res
}

fn gen_makedeps(s1 &TCCState, target &char, filename &char) int {
	depout := &C.FILE(0)
	buf := [1024]char{}
	escaped_targets := &&char(0)
	i := 0
	k := 0
	num_targets := 0

	if !filename {
		C.snprintf(buf, sizeof(buf), c'%.*s.d', int((tcc_fileextension(target) - target)),
			target)
		filename = buf
	}
	if !C.strcmp(filename, c'-') {
		depout = C.fdopen(1, c'w')
	} else { // 3
		depout = C.fopen(filename, c'w')
	}
	if !depout {
		return _tcc_error_noabort(s1, "could not open '${filename}'")
	}
	if s1.verbose {
		C.printf(c'<- %s\n', filename)
	}
	escaped_targets = tcc_malloc(s1.nb_target_deps * sizeof(*escaped_targets))
	num_targets = 0
	for i = 0; i < s1.nb_target_deps; i++ {
		for k = 0; k < i; k++ {
			if 0 == C.strcmp(s1.target_deps[i], s1.target_deps[k]) {
				goto next // id: 0x7ffff32253a0
			}
		}
		escaped_targets[num_targets++] = escape_target_dep(s1.target_deps[i])
		// RRRREG next id=0x7ffff32253a0
		next:
		0
	}
	C.fprintf(depout, c'%s:', target)
	for i = 0; i < num_targets; i++ {
		C.fprintf(depout, c' \\\n  %s', escaped_targets[i])
	}
	C.fprintf(depout, c'\n')
	if s1.gen_phony_deps {
		for i = 1; i < num_targets; i++ {
			C.fprintf(depout, c'%s:\n', escaped_targets[i])
		}
	}
	for i = 0; i < num_targets; i++ {
		tcc_free(escaped_targets[i])
	}
	tcc_free(escaped_targets)
	C.fclose(depout)
	return 0
}
