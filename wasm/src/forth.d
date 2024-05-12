module forth;

/// @file
/// @brief FORTH engine

extern (C): // disable D mangling
@nogc:

/// @defgroup FORTH FORTH
/// @brief FORTH engine
/// @{

__gshared int Msz = 0x1000;
__gshared int Rsz = 0x100;
__gshared int Dsz = 0x10;

__gshared int Cp = 0;
__gshared int ip = 0;
__gshared int Rp = 0;
__gshared int Dp = 0;

void init() {
    // Dp = 0;
}

void nop() {
}

/// @}
