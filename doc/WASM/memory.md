# A practical guide to [[WebAssembly]] memory 
## from [[people/radu]]

- https://radu-matei.com/blog/practical-guide-to-wasm-memory/
	- https://github.com/radu-matei/wasm-memory
- https://wasmbyexample.dev/examples/webassembly-linear-memory/webassembly-linear-memory.rust.en-us.html

## WebAssembly Linear Memory 
### Overview 

Another feature of WebAssembly, is its linear memory. Linear memory is a continuous buffer of unsigned bytes that can be read from and stored into by both Wasm and Javascript. In other words, Wasm memory is an expandable array of bytes that Javascript and Wasm can synchronously read and modify. Linear memory can be used for many things, one of them being passing values back and forth between Wasm and Javascript. 

In Rust, tools like [[wasm-bindgen]], which is part of [[wasm-pack]] workflow, abstracts away linear memory, and allows using native data structures between rust and Javascript. But for this example, we will use simple byte (Unsigned 8-bit integer) buffers and pointers (Wasm memory array indexes) as a simple(r) way to pass memory back and forth, and show off the concept. Let's see how we can use linear memory:
