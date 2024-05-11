# What Is WebAssembly?

The WebAssembly [home page](https://webassembly.org/) says that it is a 
- binary instruction format for a 
- stack-based virtual machine. 

[[WASM]] (a contraction, not an acronym, for [[WebAssembly]]) is 
- designed to be [[WASM/portable]] (capable of running on different OSes, architectures, and environments without modification), and 
- used as a compilation target for higher-level languages like C++, Rust, Go, and many others. 
- The website also claims that Wasm enables [[WASM/zero-cost deployment]] on the web for client and server applications alike.

Let’s pick this definition apart a bit, because it’s rather dense.

![[WASM/portable]]
![[VM/stack]]

Finally, there’s a spot in the definition on which I fundamentally disagree. The phrase “[[Web/deployment]] on the web” might limit your thinking and your imagination. This is a portable format that can run anywhere you can build a host, which you’ll also be learning about later. Limiting WebAssembly’s scope to the web (despite its name) does it a disservice.
