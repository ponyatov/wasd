module forth;

import druntime;

/// @file
/// @brief FORTH engine

extern (C): // disable D mangling
@nogc:

/// @defgroup FORTH FORTH
/// @brief FORTH engine
/// @{

extern (D) void init() {
}

const ushort Msz = 0x1000;
const ushort Rsz = 0x100;
const ushort Dsz = 0x10;

__gshared byte[Msz] M;
__gshared ushort Cp = 0;
__gshared ushort Ip = 0;

__gshared ushort[Rsz] R;
__gshared ushort Rp = 0;

__gshared int[Dsz] D;
__gshared ushort Dp = 0;

void nop() {
    version (log)
        log("nop");
}

/// @}
