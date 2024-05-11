# lib.rs

## also: [[WASM/js.js]]


```Rust
#![cfg(target_arch = "wasm32")]

#![no_std]

#[panic_handler]
fn panic_handler(_: &core::panic::PanicInfo) -> ! { loop {} }

#[no_mangle]
fn none() {}
```
```Rust
const W: usize = 640;
const H: usize = 480;

#[no_mangle]
pub fn w() -> usize { W }

#[no_mangle]
pub fn h() -> usize { H }

#[no_mangle]
fn size() -> (usize, usize) {
	return (W, H);
}
```

## paint

![[paint#canvas]]
![[paint#tartan]]

