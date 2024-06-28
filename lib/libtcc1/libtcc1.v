@[translated]
module libtcc1

#flag bcheck.o
#flag bt-exe.o
#flag bt-log.o

__global __mzerosf = f32(-0.0)
__global __mzerodf = f64(-0.0)

type Wtype = int
type UWtype = u32
type USItype = u32
type DWtype = i64
type UDWtype = i64

struct DWstruct {
	low  Wtype
	high Wtype
}

union DWunion {
	s  DWstruct
	ll DWtype
}

type XFtype = f64

union Ldouble_long {
	ld f64
	l  struct {
		lower i64
		upper u16
	}
}

union Double_long {
	d f64
	l struct {
		lower u32
		upper int
	}

	ll i64
}

union Float_long {
	f f32
	l u32
}

@[export: '__floatundisf']
fn __floatundisf(a i64) f32 {
	uu := DWunion{}
	r := XFtype(0)
	uu.ll = a
	if uu.s.high >= 0 {
		return f32(uu.ll)
	} else {
		r = XFtype(uu.ll)
		r += 1.8446744073709552E+19
		return f32(r)
	}
}

@[export: '__floatundidf']
fn __floatundidf(a i64) f64 {
	uu := DWunion{}
	r := XFtype(0)
	uu.ll = a
	if uu.s.high >= 0 {
		return f64(uu.ll)
	} else {
		r = XFtype(uu.ll)
		r += 1.8446744073709552E+19
		return f64(r)
	}
}

@[export: '__floatundixf']
fn __floatundixf(a i64) f64 {
	uu := DWunion{}
	r := XFtype(0)
	uu.ll = a
	if uu.s.high >= 0 {
		return f64(uu.ll)
	} else {
		r = XFtype(uu.ll)
		r += 1.8446744073709552E+19
		return f64(r)
	}
}

@[export: '__fixunssfdi']
fn __fixunssfdi(a1 f32) i64 {
	fl1 := Float_long{}
	exp := 0
	l := i64(0)
	fl1.f = a1
	if fl1.l == 0 {
		return 0
	}
	exp = (((fl1.l) >> 23) & 255) - 126 - 24
	l = (((fl1.l) & 8388607) | (1 << 23))
	if exp >= 41 {
		return 1 << 63
	} else if exp >= 0 {
		l <<= exp
	} else if exp >= -23 {
		l >>= -exp
	} else {
		return 0
	}
	if ((fl1.l) & 2147483648) {
		l = i64(-l)
	}
	return l
}

@[export: '__fixsfdi']
fn __fixsfdi(a1 f32) i64 {
	ret := i64(0)
	s := a1 >= 0
	ret = __fixunssfdi(if s { a1 } else { -a1 })
	return if s { ret } else { -ret }
}

@[export: '__fixunsdfdi']
fn __fixunsdfdi(a1 f64) i64 {
	dl1 := Double_long{}
	exp := 0
	l := i64(0)
	dl1.d = a1
	if dl1.ll == 0 {
		return 0
	}
	exp = (((dl1.l.upper) >> 20) & 2047) - 1022 - 53
	l = ((dl1.ll & ((i64(1) << 52) - 1)) | (i64(1) << 52))
	if exp >= 12 {
		return 1 << 63
	} else if exp >= 0 {
		l <<= exp
	} else if exp >= -52 {
		l >>= -exp
	} else {
		return 0
	}
	if ((dl1.l.upper) & 2147483648) {
		l = i64(-l)
	}
	return l
}

@[export: '__fixdfdi']
fn __fixdfdi(a1 f64) i64 {
	ret := i64(0)
	s := a1 >= 0
	ret = __fixunsdfdi(if s { a1 } else { -a1 })
	return if s { ret } else { -ret }
}

@[export: '__fixunsxfdi']
fn __fixunsxfdi(a1 f64) i64 {
	dl1 := Ldouble_long{}
	exp := 0
	l := i64(0)
	dl1.ld = a1
	if dl1.l.lower == 0 && dl1.l.upper == 0 {
		return 0
	}
	exp = (dl1.l.upper & 32767) - 16382 - 64
	l = dl1.l.lower
	if exp > 0 {
		return 1 << 63
	}
	if exp < -63 {
		return 0
	}
	l >>= -exp
	if ((dl1.l.upper) & 32768) {
		l = i64(-l)
	}
	return l
}

@[export: '__fixxfdi']
fn __fixxfdi(a1 f64) i64 {
	ret := i64(0)
	s := a1 >= 0
	ret = __fixunsxfdi(if s { a1 } else { -a1 })
	return if s { ret } else { -ret }
}
