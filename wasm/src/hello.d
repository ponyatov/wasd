/// @file
/// @brief Hello World

module hello;

extern (C): // disable D mangling
@nogc:

/// @defgroup hello hello
/// @ingroup wasm
/// @{

int add(int a, int b) {
    return a + b;
}

extern (D) void init() {
}

/// @}
