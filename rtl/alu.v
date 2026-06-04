
module alu(
    input [31:0] a, b,
    input [3:0] op,
    output reg [31:0] result,
    output reg zero, carry, negative
);

always @(*) begin
    result   = 32'h0;
    carry    = 1'b0;
    zero     = 1'b0;
    negative = 1'b0;
  case (op)
    4'b0000: {carry, result} = a + b;           // ADD
    4'b0001: {carry, result} = a - b;           // SUB
    4'b0010: result = a & b;                    // AND
    4'b0011: result = a | b;                    // OR
    4'b0100: result = a ^ b;                    // XOR
    4'b0101: result = ~a;                       // NOT
    4'b0110: result = a << b[4:0];              // SHL
    4'b0111: result = a >> b[4:0];              // SHR (logical)
    4'b1000: result = $signed(a) >>> b[4:0];    // SRA (arithmetic)
    4'b1001: result = ~a + 32'h1;              // NEG
    4'b1010: result = a * b;                    // MUL (lower 32-bit)
    default: begin
     result = 32'h0;
     carry = 1'b0;
     zero = 1'b0;
    end
  endcase
  zero     = ~| result;
  negative = result[31];

end


endmodule
