@[translated]
module main

__global disable_trace = bool(0)

// v -d tracecall -w .
@[inline]
pub fn vcc_trace(msg string) {
	if !disable_trace {
		$if tracecall ? {
			eprintln(msg)
		}
	}
}

@[inline]
pub fn vcc_trace_print(msg string) {
	$if tracedebug ? {
		eprintln(msg)
	}
}

@[inline]
pub fn vcc_disable_trace() {
	disable_trace = true
}

@[inline]
pub fn vcc_enable_trace() {
	disable_trace = false
}
