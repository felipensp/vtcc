# vtcc
TCC compiler translated to V lang (thanks to `vlang/c2v`)

Official TCC repo: https://repo.or.cz/tinycc.git

TCC commit reference: _76d605192dae84c172722c3d73bf546a064b7e1c_

*Currently it is x86-64 only.*

### Building vtcc

`v .`

(warnings are being fixed yet, but you can use `-cc gcc|tcc|clang_`)

### How to use

`./vtcc hello.c && ./a.out` or `./vtcc -run hello.c`

For full help (just like `tcc -h`), use `./vtcc -h`.

### Building it self

```
$ v -w -o test.c . 
$ ./vtcc test.c -ltcc1 -lgc -ldl  -lc -lm -lmvec -lpthread
$ ./a.out hello.c
```