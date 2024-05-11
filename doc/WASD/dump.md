```Cpp
void dump() {
    printf("\n");
    // label{}
    for (auto const &[name, addr] : label) {
        printf("%.4X\t%s\n", addr, name.toStdString().c_str());
    }
    // M[]
    for (uint16_t addr = 0; addr < Cp; addr++) {
        if (addr % 0x10 == 0) printf("\n%.4X\t", addr);
        printf("%.2X ", M[addr]);
    }
    //
    printf("\n\n");
}
```
