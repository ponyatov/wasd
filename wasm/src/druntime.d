/// @file
/// @brief `druntime` port

module druntime;

/// @defgroup wasm wasm
/// @brief WebAssembly runtime for D language

extern (C): // disable D mangling

/// @defgroup druntime druntime
/// @ingroup wasm
/// @brief `druntime` port
/// @{

/// @brief seems to be the required entry point
void _start() {
    log("WASD init");
}

/// @brief logging callback to `console.log(string)`
extern void log(string msg);

/// @}
