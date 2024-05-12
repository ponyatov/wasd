/// @file
/// @brief `druntime` port

module druntime;

import forth;
import hello;

/// @defgroup wasm wasm
/// @brief WebAssembly runtime for D language

extern (C): // disable D mangling
@nogc:

/// @defgroup druntime druntime
/// @ingroup wasm
/// @brief `druntime` port
/// @{

/// @brief seems to be the required entry point
void _start() {
    log("WASD init");
    forth.init();
    hello.init();
}

/// @brief logging callback to `console.log(string)`
void log(string msg);

/// @}
