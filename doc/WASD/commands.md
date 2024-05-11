## hpp

```Cpp
/// @name commands
```
![[bcx#hpp]]
```Cpp
enum class Cmd {
    nop  = 0x00,
    halt = 0xFF,
    jmp  = 0x01,
    qjmp = 0x02,
    call = 0x03,
    ret  = 0x04,
    lit  = 0x05,
	// debug
    dump = 0x70,
	// gui
	gui  = 0x80,
};
```
```Cpp
extern void nop ();  /// ( -- )        do nothing
extern void halt();  /// ( -- )        stop system
extern void jmp ();  /// ( -- )        unconditional jump
extern void qjmp();  /// ( false -- )  jump on false
extern void call();  /// (R: -- addr ) nested call
extern void ret ();  /// (R: addr -- ) return from call
extern void lit ();  /// ( -- n )      push number (literal)
extern void dump();  /// ( -- )        dump memory
```

## cpp

```Cpp
int main(int argc, char *argv[]) {
		...
	}
	dump(); bcx();
	return fini();
}
```

![[WASD/dump]]
![[WASD/bcx]]
![[WASD/nop]]
![[WASD/halt]]

[[WASD/gui]]
