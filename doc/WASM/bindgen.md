# `wasm-bindgen`

## [[WASM]] in [[Rust]] without [[NodeJS]]

https://dev.to/dandyvica/wasm-in-rust-without-nodejs-2e0c

In this article, I'll talk about how to call Rust WASM methods from [[JavaScript]], but without using [[NodeJS]]. Almost the examples I googled so far were only describing using [[Rust]] for [[WASM]] in NodeJS (but better explained now in the [[wasm-bindgen]] documentation). I think it's too complicated to grasp the whole idea. It's better (for me at least) to unravel the whole process without bringing too many players in the game.

As Rust is already installed on my Linux machine, I'll be describing how to install Rust and WASM from scratch.

## Prepare Rust

### Reinstall Rust

This is not a mandatory step but as I faced some issues when trying to install WASM, I did reinstall Rust completely:

```
$ rustup self uninstall
```

Then re-install all the toolchain:  

```
$ curl https://sh.rustup.rs -sSf | sh
```

and verify it's correctly installed:  

```
$ rustc --version
rustc 1.34.2 (6c2484dc3 2019-05-13)
```

Install additional utilities:  

- [[rustfmt]]
- [[rls]]
- [[rust-analysis]]
- [[rust-src]]

```
$ rustup component add rustfmt
```

```
$ rustup component add rls rust-analysis rust-src
```

### Install WASM specific extension and utilities

Now it's time to install WASM extension to be able to compile Rust to WASM directly:  

- [[Rust/target]]
- [[wasm32-unknown-unknown]]

```
rustup target add wasm32-unknown-unknown
```

![[Rust/wasm-gc#install]]

