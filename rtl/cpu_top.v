module cpu_top (
    input clk,
    input reset
);

wire [31:0] pc_q;
reg  [47:0] ir;

wire [4:0] opcode;
wire [1:0] rd;
wire [1:0] rs;
wire [31:0] imm;

wire [31:0] reg_rd1;
wire [31:0] reg_rd2;

wire [31:0] alu_result;
wire [31:0] mem_dout;
wire alu_zero;
wire alu_carry;
wire alu_negative;

reg zero_flag;
reg carry_flag;
reg neg_flag;

wire ir_load;
wire pc_inc;
wire pc_load;
wire reg_write;
wire flag_write;
wire mem_write;
wire [3:0] alu_op;

reg [47:0] rom [0:11];

initial begin
    $readmemh("mem/program.hex", rom);
end




always @(posedge clk or posedge reset) begin
    if (reset)
        ir <= 48'h0;
    else if (ir_load)
        ir <= rom[pc_q];
end

pc pc0 (
    .clk(clk),
    .reset(reset),
    .load(pc_load),
    .inc(pc_inc),
    .din(imm),
    .q(pc_q)
);

decoder dec (
    .instr(ir),
    .opcode(opcode),
    .rd(rd),
    .rs(rs),
    .imm(imm)
);

regfile rf0 (
    .clk(clk),
    .reset(reset),
    .we(reg_write),
    .wa(rd),
    .wd(write_data),
    .ra1(rd),
    .ra2(rs),
    .rd1(reg_rd1),
    .rd2(reg_rd2)
);

alu alu0 (
        .a(reg_rd1),
        .b(reg_rd2),
        .op(alu_op),
        .result(alu_result),
        .zero(alu_zero),
        .carry(alu_carry),
        .negative(alu_negative)
    );

control_unit cu0 (
    .clk(clk),
    .reset(reset),
    .opcode(opcode),
    .zero_flag(zero_flag),
    .neg_flag(neg_flag),
    .ir_load(ir_load),
    .pc_inc(pc_inc),
    .pc_load(pc_load),
    .reg_write(reg_write),
    .flag_write(flag_write),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .state_fetch(),
    .state_decode(),
    .state_execute(),
    .state_writeback(),
    .halted()
);

// Register-indirekte Adressierung: bei LOAD/STORE kommt Adresse aus Rs (reg_rd2)
wire [31:0] ram_addr = ((opcode == 5'b10001) || (opcode == 5'b10010)) ? reg_rd2 : imm;

data_ram ram0 (
    .clk(clk),
    .we(mem_write),
    .addr(ram_addr),
    .din(reg_rd1),
    .dout(mem_dout)
);

reg [31:0] write_data;

always @(*) begin
    case (opcode)
        5'b00000: write_data = imm;         // LDI
        5'b00001: write_data = reg_rd2;     // MOV
        5'b00010: write_data = alu_result;  // ADD
        5'b00011: write_data = alu_result;  // SUB
        5'b00100: write_data = alu_result;  // AND
        5'b00101: write_data = alu_result;  // OR
        5'b00110: write_data = alu_result;  // XOR
        5'b01010: write_data = alu_result;  // SHL
        5'b01011: write_data = alu_result;  // SHR
        5'b01100: write_data = alu_result;  // SRA
        5'b01101: write_data = alu_result;  // NEG
        5'b01110: write_data = alu_result;  // MUL
        5'b01111: write_data = alu_result;  // NOT
        5'b10001: write_data = mem_dout;  // LOAD
        default:  write_data = 32'h0;
    endcase
end

always @(posedge clk or posedge reset) begin
        if (reset) begin
            zero_flag  <= 1'b0;
            carry_flag <= 1'b0;
            neg_flag   <= 1'b0;
        end
        else if (flag_write) begin
            zero_flag  <= alu_zero;
            carry_flag <= alu_carry;
            neg_flag   <= alu_negative;
        end
end

endmodule
