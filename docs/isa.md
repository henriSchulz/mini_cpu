# Mini CPU ISA

## Datenbreite
32 Bit

## Register
R0, R1, R2, R3

## Instruktionsbreite
48 Bit

## Format

```
Byte 5  [47:40] = { 3'b0, opcode[4:0] }
Byte 4  [39:32] = { 4'b0, rd[1:0], rs[1:0] }
Bytes 3–0 [31:0] = immediate (32 Bit)
```

Hex-Kodierung: `OO DD IIIIIIII` (12 Hex-Zeichen)
- `OO` = Opcode-Byte (Opcode in den unteren 5 Bit)
- `DD` = Register-Byte: `(rd << 2) | rs`
- `IIIIIIII` = 32-Bit Immediate (big-endian)

## Registercodierung
| Code | Register |
|------|----------|
| 00   | R0       |
| 01   | R1       |
| 10   | R2       |
| 11   | R3       |

## Opcodes

| Opcode  | Hex  | Mnemonic | Operation                        | Flags       |
|---------|------|----------|----------------------------------|-------------|
| 00000   | 0x00 | LDI      | rd ← imm                         | —           |
| 00001   | 0x01 | MOV      | rd ← rs                          | —           |
| 00010   | 0x02 | ADD      | rd ← rd + rs                     | Z, C, N     |
| 00011   | 0x03 | SUB      | rd ← rd − rs                     | Z, C, N     |
| 00100   | 0x04 | AND      | rd ← rd & rs                     | Z, N        |
| 00101   | 0x05 | OR       | rd ← rd \| rs                    | Z, N        |
| 00110   | 0x06 | XOR      | rd ← rd ^ rs                     | Z, N        |
| 00111   | 0x07 | CMP      | rd − rs (nur Flags, kein Write)  | Z, C, N     |
| 01000   | 0x08 | JMP      | PC ← imm                         | —           |
| 01001   | 0x09 | JZ       | if Z: PC ← imm                   | —           |
| 01010   | 0x0A | SHL      | rd ← rd << rs[4:0]               | Z, N        |
| 01011   | 0x0B | SHR      | rd ← rd >> rs[4:0]  (logical)    | Z, N        |
| 01100   | 0x0C | SRA      | rd ← rd >>> rs[4:0] (arithmetic) | Z, N        |
| 01101   | 0x0D | NEG      | rd ← ~rd + 1                     | Z, N        |
| 01110   | 0x0E | MUL      | rd ← rd * rs  (untere 32 Bit)    | —           |
| 01111   | 0x0F | NOT      | rd ← ~rd                         | Z, N        |
| 10000   | 0x10 | JN       | if N: PC ← imm                   | —           |
| 10001   | 0x11 | LOAD     | rd ← mem[imm]                       | —           |
| 10010   | 0x12 | STORE    | mem[imm] ← rd                       | —           |
| 11111   | 0x1F | HALT     | CPU anhalten                     | —           |

## Flags

| Flag | Bedeutung                        | Gesetzt von                    |
|------|----------------------------------|-------------------------------|
| Z    | Zero — Ergebnis ist 0            | ADD, SUB, AND, OR, XOR, CMP, SHL, SHR, SRA, NEG, NOT |
| C    | Carry — Übertrag / Unterlauf     | ADD, SUB, CMP                 |
| N    | Negative — MSB des Ergebnisses   | ADD, SUB, AND, OR, XOR, CMP, SHL, SHR, SRA, NEG, NOT |


