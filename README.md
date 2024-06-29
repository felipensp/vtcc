# vtcc
TCC compiler translated to V lang (thanks to `vlang/c2v`)

Official TCC repo: https://repo.or.cz/tinycc.git

TCC commit reference: _76d605192dae84c172722c3d73bf546a064b7e1c_

*Currently it is x86-64 only.*

### Building vtcc

`v run make.vsh [vtcc src path]`

This will generate `bt-exe.o`, `bt-log.o`, `dso.o`, `libtcc1.o`, `libtcc1.a` and `vtcc` executable.

### How to use

`./vtcc hello.c && ./a.out` or `./vtcc -run hello.c`

For full help (just like `tcc -h`), use `./vtcc -h`.

### Building itself

```
$ v -d vtcc_dir=`pwd` -o test.c .
$ ./vtcc test.c -lgc -ldl -lpthread
$ ./a.out -run hello.c
```

### Building Vlang

```
$ v -o vlang.c cmd/v # on vlang dir
$ vtcc vlang.c -lpthread
```
