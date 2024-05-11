## hpp

```Cpp
extern std::map<QString, uint16_t> label;  /// vocabulary (CFA only)
```
```Cpp
extern void c(Cmd);       /// compile command
extern void c( uint8_t);  /// compile byte
extern void c( int16_t);  /// compile int
extern void c(uint16_t);  /// compile addr
```

## cpp

```Cpp
std::map<QString, uint16_t> label;
```
```Cpp
void c(Cmd cmd)       { c((uint8_t)cmd); }
void c(uint8_t  byte) { st(Cp, byte); Cp += sizeof(byte); }
void c(uint16_t cell) { st(Cp, cell); Cp += sizeof(cell); }
```
