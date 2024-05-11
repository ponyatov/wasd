## WASM without wasm-bindgen
- https://vmx.cx/cgi-bin/blog/index.cgi/webassembly-multi-value-return-in-todays-rust-without-wasm-bindgen
- [[cliffle]]

The goal was to run some WebAssembly within different host languages. I needed a WASM file that is independent of the host language, hence I decided to code the [[Rust/FFI]] manually, without using any tooling like [[wasm-bindgen]], which is JavaScript specific. It needed a bit of custom tooling, but in the end I succeeded in having a [[WASM]] binary that has a multi-value return, generated with today's Rust compiler, without using wasm-bindgen annotations.

In my case I wanted to pass some bytes into the WASM module, do some processing and returning some other bytes. I found all information I needed in this excellent **A practical guide to WebAssembly** [[WASM/memory]] from radu. There he mentions the WebAssembly multi-value proposal and links to a blog post from 2019 called Multi-Value All The Wasm! which explains its implementation for the Rust ecosystem.
