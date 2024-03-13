import os

fn test_helloworld() {
	res := os.execute('./vtcc -Iinclude -run hello.c')
	assert res.exit_code == 0
	assert res.output.trim_space() == 'hello world!'
}
