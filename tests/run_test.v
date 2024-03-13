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