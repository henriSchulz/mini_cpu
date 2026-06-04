// Instruction format (48-bit):
// [47:40] = {3'b0, opcode[4:0]}             — Byte 5
// [39:32] = {4'b0, rd[1:0], rs[1:0]}        — Byte 4
// [31:0]  = imm (32 bits)                   — Bytes 3-0
//
// Byte 4 detail: bits[39:36]=0, bits[35:34]=rd, bits[33:32]=rs
// Hex encoding: OO DD IIIIIIII  (12 hex digits, DD = (rd<<2)|rs)
module decoder(
    input  [47:0] instr,
    output [4:0] opcode,
    output [1:0] rd,
    output [1:0] rs,
    output [31:0] imm
);

assign opcode = instr[44:40];
assign rd     = instr[35:34];
assign rs     = instr[33:32];
assign imm    = instr[31:0];




endmodule
