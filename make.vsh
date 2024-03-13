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

fn build_btexe() ! {
	eprint('building bt-exe.o: ')
	res_btexec := os.execute('v -d no_main -skip-unused -no-builtin -o bt-exe.o lib/bt-exe.v')
	if res_btexec.exit_code == 0 {
		println('ok')
	} else {
		println('failed ${res_btexec.output}')
		return error('failed')
	}
}

fn build_vtcc() {
	eprint('buildind vtcc: ')
	res_vtcc := os.execute('v src')
	if res_vtcc.exit_code == 0 {
		println('ok')
	} else {
		println('failed ${res_vtcc.output}')
	}
}

fn main() {
	build_btlog()!
	build_btexe()!
	build_vtcc()
}
