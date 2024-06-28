import os

fn build_btlog() ! {
	eprint('building bt-log.o (tcc_backtrace symbol): ')
	res_btlog := os.execute('v -d no_main -skip-unused -no-builtin -o bt-log.o lib/bt-log.v')
	if res_btlog.exit_code == 0 {
		println('ok')
	} else {
		println('failed ${res_btlog.output}')
		return error('failed')
	}
}

fn build_bcheck() ! {
	eprint('building bcheck.o: ')
	res_bchecklog := os.execute('v -d no_main -skip-unused -no-builtin -o bcheck.o lib/bcheck.v')
	if res_bchecklog.exit_code == 0 {
		println('ok')
	} else {
		println('failed ${res_bchecklog.output}')
		return error('failed')
	}
}

fn build_btexe() ! {
	eprint('building bt-exe.o: ')
	res_btexec := os.execute('v -cg -d no_main -skip-unused -no-builtin -o bt-exe.o lib/bt-exe.v')
	if res_btexec.exit_code == 0 {
		println('ok')
	} else {
		println('failed ${res_btexec.output}')
		return error('failed')
	}
}

fn build_libtcc1() ! {
	eprint('buildind libtcc1.so: ')
	res_libtcc1 := os.execute('v -cg -d no_main -shared -o libtcc1.so lib/libtcc1/')
	if res_libtcc1.exit_code == 0 {
		println('ok')
	} else {
		return error('failed ${res_libtcc1.output}')
	}
}

fn build_vtcc() ! {
	eprint('buildind vtcc: ')
	res_vtcc := os.execute('v -keepc -cg -o vtcc src/')
	if res_vtcc.exit_code == 0 {
		println('ok')
	} else {
		return error('failed ${res_vtcc.output}')
	}
}

fn main() {
	build_bcheck()!
	build_btlog()!
	build_btexe()!
	build_libtcc1()!
	build_vtcc()!
}
