# `bcx()`
## bytecode interpreter
## `интерпретатор байткода`

## hpp

```Cpp
extern void bcx();   /// ByteCode eXecutor
extern void step();  /// do one command
```

## cpp

```Cpp
void step() {
    // fetch
    assert(Ip < Cp); uint8_t op = M[Ip++];
    // trace
    printf("\n%.4X\t%.2x", Ip - 1, op);
    // decode -> execute
    switch ((Cmd)op) {
        case Cmd::nop:
            nop(); break;
        case Cmd::halt:
            halt(); break;
        default:  // unknown command
            printf("\t???\n\n"); abort();
    }
}

void bcx() { while (true) { step(); } }
```

[[WASD/commands]]
