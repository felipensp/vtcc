@[translated]
module main

__global disable_trace = bool(0)

// v -d tracecall -w .
@[if tracecall ?]
pub fn vcc_trace(msg string) {
	if !disable_trace {
		eprintln(msg)
	}
}

// v -d tracedebug
@[if tracedebug ?]
pub fn vcc_trace_print(msg string) {
	$if tracedebug ? {
		eprintln(msg)
	}
}

// v -d tracecall
@[if tracecall ?]
pub fn vcc_disable_trace() {
	disable_trace = true
}

// v -d tracecall
@[if tracecall ?]
pub fn vcc_enable_trace() {
	disable_trace = false
}
