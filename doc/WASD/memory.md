## hpp

```Cpp
extern byte  M[Msz];  /// main Memory
extern ucell Cp;      /// Compiler Pointer
extern ucell Ip;      /// Instruction Pointer
```
```Cpp
extern void st(uint16_t,  uint8_t);  /// store byte
extern void st(uint16_t,  int16_t);  /// store int
extern void st(uint16_t, uint16_t);  /// store addr
```

## cpp

```Cpp
 uint8_t M[Msz];
uint16_t Cp = 0;
uint16_t Ip = 0;
```
