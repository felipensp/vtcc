# vtcc
TCC compiler translated to V lang (thanks to `vlang/c2v`)

Official TCC repo: https://repo.or.cz/tinycc.git

TCC commit reference: _76d605192dae84c172722c3d73bf546a064b7e1c_

*Currently it is x86-64 only.*

### Building (with gcc or tcc)

`v -w .`

### How to use

`./vtcc hello.c -Iinclude -L/path/to/libtcc1.a`
