/// @file
/// @brief Hello World

module hello;

extern (C): // disable D mangling

/// @defgroup hello hello
/// @ingroup wasm
/// @{

// seems to be the required entry point
void _start() {
}

void nop() {
}

int add(int a, int b) {
    return a + b;
}

/// @}
