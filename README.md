# vtcc
TCC compiler translated to V lang (thanks to `vlang/c2v`)

Official TCC repo: https://repo.or.cz/tinycc.git

TCC commit reference: _76d605192dae84c172722c3d73bf546a064b7e1c_

*Currently it is x86-64 only.*

### Building vtcc

`v run make.vsh`

This will generate `bt-exe.o`, `bt-log.o`, `libtcc1.so` and `vtcc` executable.

### How to use

`./vtcc -Iinclude hello.c && ./a.out` or `./vtcc -Iinclude -run hello.c`

For full help (just like `tcc -h`), use `./vtcc -h`.

### Building itself

```
$ v -o test.c . 
$ ./vtcc test.c -Iinclude -L. -ltcc1 -lgc -ldl  -lc -lm -lmvec -lpthread bt-log.o bt-exe.o bcheck.o
$ ./a.out -Iinclude -run hello.c
```

### Building Vlang (with original libtcc1)

```
$ v -o vlang.c cmd/v # on vlang dir
$ export tccdir=/path/to/tcc/build/dir
$ vtcc vlang.c -lc -ldl -lpthread -ltcc1 -L$tccdir -L.
```

### Building Vlang (with libtcc1 from vtcc)

```
$ v -o vlang.c cmd/v # on vlang dir
$ export vtccdir=/path/to/vtcc/dir
$ vtcc -Iinclude -o ./vlang -ldl -lc -lpthread -I$vtccdir/include -L$vtccdir -ltcc1 $vtccdir/bt-exe.o $vtccdir/bt-log.o $vtccdir/bcheck.o vlang.c
```