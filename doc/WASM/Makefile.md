# Makefile

![[Rust/Makefile#tool]]
![[Rust/Makefile#src]]
![[JS/Makefile#src]]

```Makefile
# \ all

#rust: tmp/$(module).wat
wasm: static/wasm.wasm
	$(MAKE) tmp/format_js
static/%.wasm: target/wasm32-unknown-unknown/debug/%.wasm Makefile
	wasm-strip $<
	wasm-opt -o $@ -Oz $<
	ls -la $< $@
#	wasm-objdump -d $@
target/wasm32-unknown-unknown/debug/$(module).wasm: $(R) Cargo.toml
	$(CARGO) build --lib --target wasm32-unknown-unknown
	$(CARGO) fmt
```

![[make/web]]

![[format_js]]

```Makefile
# \ rule
static/%.wasm: src/%.wat
	wat2wasm -o $@ $<
tmp/%.wat: static/%.wasm
	wasm2wat -o $@ $<
```

![[make/install]]
![[Rust/Makefile#install]]
```Makefile
# \ install
install: $(OS)_install gz $(RUSTUP) $(WP)
	$(MAKE) update
	$(RUSTUP) target add wasm32-unknown-unknown
update: $(OS)_update $(RUSTUP)
	$(RUSTUP) self update ; $(RUSTUP) update
```
![[make/jslib]]
