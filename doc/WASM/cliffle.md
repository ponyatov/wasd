# cliffle

- http://cliffle.com/blog/bare-metal-wasm/
	- https://github.com/cbiffle/bare-metal-wasm-example/

also: [[WASM/no-bindgen]]

```shell
apt install -yu wabt binaryen
rustup target add wasm32-unknown-unknown
```

-   [wabt](https://github.com/WebAssembly/wabt) for the `wasm-strip` and `wasm-objdump` tools.
-   [binaryen](https://github.com/WebAssembly/binaryen) for the `wasm-opt` tool.

To get the program loaded into the browser, we’ll compile it as a WebAssembly module. A WebAssembly module is essentially a dynamic (shared) library. 

the WebAssembly environment doesn’t have a concept of “graphics.” The only things a module can do to interact with the outside world (including the browser) are
-  Compute things in functions that are exported to JavaScript.
- Call functions that are imported from JavaScript (or other WebAssembly modules).
	- We could write a bunch of JavaScript functions wrapping `canvas` or something, and provide them to the WebAssembly module as imports.
		- without using tools like [`wasm-bindgen`](https://rustwasm.github.io/wasm-bindgen/), that would be complicated and tedious.
- deposit pixels into a region of memory from the WebAssembly program, and then tell JavaScript from where to blit it into a `canvas`.

## .vscode/settings.json [[Rust/settings]]

```json
// \ rust
"rust-analyzer.cargo.target": "wasm32-unknown-unknown",
"rust-analyzer.cargo.allTargets": false,
"rust-analyzer.checkOnSave.allTargets": false,
```

## Makefile

![[make/var#module]]
```Makefile
# \ var
MODULE = $(notdir $(CURDIR))
module = $(shell echo $(MODULE) | tr A-Z a-z)

# \ dir
CAR = $(HOME)/.cargo/bin

# \ tool
CURL   = curl -L -o
CF     = clang-format
RUSTUP = $(CAR)/rustup
CARGO  = $(CAR)/cargo

# \ src
R += src/main.rs src/lib.rs
S += $(R) Cargo.toml
J += static/js.js
S += $(JS)

wasm: static/$(module).wasm
	$(MAKE) tmp/format_js

static/$(module).wasm: target/wasm32-unknown-unknown/debug/$(module).wasm
	wasm-strip $<
	wasm-opt -o $@ -Oz $<
    ls -la $< $@

target/wasm32-unknown-unknown/debug/$(module).wasm: $(R) Cargo.toml
	$(CARGO) build --lib --target wasm32-unknown-unknown
	$(CARGO) fmt

tmp/format_js: $(J)
	$(CF) -style=google -i $? && touch $@

install: pharo-ui doc $(RUSTUP)
	$(MAKE) update
	$(RUSTUP) target add wasm32-unknown-unknown
update:
	sudo apt update
	sudo apt install `cat apt.dev apt.txt`
	$(RUSTUP) self update


```

[[rustup]]

## http server required

```Makefile
web:
	python3 -m http.server --directory static --bind 127.0.0.1 12345
```

## ![[Web/index.html]]
## ![[jQuery#install]]
## ![[WASM/js.js]]
## ![[WASM/css.css]]
## ![[wasm.rs]]

## Making some pixels

As I mentioned above, we’re going to generate an image in the memory of the WebAssembly module, and then transfer it onto a [[Web/canvas]] using JavaScript. This takes a surprisingly small amount of code, but there is a subtle part: how we lay out the image in memory.

We are going to use JavaScript’s [[JS/ImageData]] class to hold the image. That class has opinions about how image data should be formatted: each pixel consists of exactly four bytes, in the order R, G, B, A. (“A” is alpha, or opacity. We’ll always set A to 0xFF, or “fully opaque.”) These four-byte pixels are organized in the common raster order: left to right, top to bottom, like English text.

We’ll represent the four-byte pixels using [[Rust/u32]] in Rust. Because [[JS/ImageData]] thinks of pixels as an array of four bytes, and we’re treating it as a `u32`, we have to consider endianness. WebAssembly is little-endian, so the `u32` contains the pixel components in the _reversed_ order `0xAA_BB_GG_RR`.

- [[JS/ImageData]]
- [[JS/Uint8ClampedArray]]

![[js.js]]

## Adding animation

Static images are fine, but _moving_ images — that’s a whole different medium. Our strategy to animate the program will rely on JavaScript and the browser’s event loop.

1.  The Rust program will keep track of its state frame-to-frame. Initially, this will mean keeping track of a frame number, but it might also derive the next frame from the previous contents of `BUFFER` — up to you.
    
2.  The JavaScript wrapper will invoke the Rust `go` function once per frame to update the contents of `BUFFER`, and then display those contents.
    
3.  We’ll use the [[JS/requestAnimationFrame]] JavaScript API to schedule updates at each frame.

First: let’s add some global state to the WebAssembly module to keep track of the frame number. The last global state we added was `BUFFER`, which required [[Rust/unsafe]] code to access (because it’s a `static mut` and Rust is suspicious of our ability to write thread-safe code). If we just want to store a single number, we can use a much easier tool: [[Rust/atomic]]s.

![[Rust/paint]]