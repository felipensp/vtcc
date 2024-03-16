import os

fn test_run_helloworld() {
	res := os.execute('./vtcc -Iinclude -run hello.c')
	assert res.exit_code == 0
	assert res.output.trim_space() == 'hello world!'
}

fn test_build_helloworld() {
	res := os.execute('./vtcc -Iinclude -o ./hello hello.c')
	assert res.exit_code == 0

	res2 := os.execute('./hello')
	os.rm('./hello')!
	assert res2.output.trim_space() == 'hello world!'
}

fn test_vlang() {
	res := os.execute('./vtcc -Iinclude -o ./vlang -ldl -lc -lpthread -Iinclude -L. -ltcc1 bt-exe.o bt-log.o bcheck.o vlang.c')
	assert res.exit_code == 0
	res_v := os.execute('LD_LIBRARY_PATH=. ./vlang -v')
	assert res_v.exit_code == 0
	assert res_v.output.starts_with('V ')

	os.rm('./vlang')!
}

fn test_build_itself() {
	res := os.execute('v -o test.c .')
	assert res.exit_code == 0
	res_aout := os.execute('./vtcc test.c -Iinclude -L. -ltcc1 -lgc -ldl -lc -lm -lpthread bt-log.o bt-exe.o bcheck.o')
	assert res_aout.exit_code == 0
	res_vtcc := os.execute('LD_LIBRARY_PATH=. ./a.out -v')
	assert res_vtcc.exit_code == 0
	assert res_vtcc.output.starts_with('tcc version')

	os.rm('./a.out')!
	os.rm('./test.c')!
}