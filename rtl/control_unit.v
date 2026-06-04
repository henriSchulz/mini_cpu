module control_unit(
    input clk,
    input reset,
    input [4:0] opcode,
    input zero_flag,
    input neg_flag,

    output reg ir_load,
    output reg pc_inc,
    output reg pc_load,
    output reg reg_write,
    output reg flag_write,
    output reg [3:0] alu_op,
    output reg state_fetch,
    output reg state_decode,
    output reg state_execute,
    output reg state_writeback,
    output reg halted,
    output reg mem_write
);

reg [1:0] state;
reg [1:0] next_state;

localparam FETCH     = 2'b00;
localparam DECODE    = 2'b01;
localparam EXECUTE   = 2'b10;
localparam WRITEBACK = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= FETCH;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        FETCH:     next_state = DECODE;
        DECODE:    next_state = EXECUTE;
        EXECUTE:   next_state = (opcode == 5'b11111) ? EXECUTE : WRITEBACK;
        WRITEBACK: next_state = FETCH;
        default:   next_state = FETCH;
    endcase
end

always @(*) begin
    ir_load         = 1'b0;
    pc_inc          = 1'b0;
    pc_load         = 1'b0;
    reg_write       = 1'b0;
    flag_write      = 1'b0;
    alu_op          = 4'b0000;
    state_fetch     = 1'b0;
    state_decode    = 1'b0;
    state_execute   = 1'b0;
    state_writeback = 1'b0;
    halted          = 1'b0;
    mem_write      = 1'b0;

    case (state)
        FETCH: begin
            state_fetch = 1'b1;
            ir_load     = 1'b1;
        end

        DECODE: begin
            state_decode = 1'b1;
            pc_inc       = 1'b1;
        end

        EXECUTE: begin
            state_execute = 1'b1;

            case (opcode)
                5'b00000: begin // LDI
                    reg_write = 1'b1;
                end

                5'b00001: begin // MOV
                    reg_write = 1'b1;
                end

                5'b00010: begin // ADD
                    alu_op     = 4'b0000;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b00011: begin // SUB
                    alu_op     = 4'b0001;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b00100: begin // AND
                    alu_op     = 4'b0010;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b00101: begin // OR
                    alu_op     = 4'b0011;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b00110: begin // XOR
                    alu_op     = 4'b0100;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b00111: begin // CMP (SUB, nur Flags setzen)
                    alu_op     = 4'b0001;
                    flag_write = 1'b1;
                end

                5'b01000: begin // JMP
                    pc_load = 1'b1;
                end

                5'b01001: begin // JZ
                    if (zero_flag)
                        pc_load = 1'b1;
                end

                5'b01010: begin // SHL
                    alu_op     = 4'b0110;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b01011: begin // SHR
                    alu_op     = 4'b0111;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b01100: begin // SRA
                    alu_op     = 4'b1000;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b01101: begin // NEG
                    alu_op     = 4'b1001;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b01110: begin // MUL
                    alu_op    = 4'b1010;
                    reg_write = 1'b1;
                end

                5'b01111: begin // NOT
                    alu_op     = 4'b0101;
                    flag_write = 1'b1;
                    reg_write  = 1'b1;
                end

                5'b10000: begin // JN
                    if (neg_flag)
                        pc_load = 1'b1;
                end

                5'b10001: begin // LOAD
                    reg_write = 1'b1;
                end

                5'b10010: begin // STORE
                    mem_write = 1'b1;
                end

                5'b11111: begin // HALT
                    halted = 1'b1;
                end

                default: begin
                end
            endcase
        end

        WRITEBACK: begin
            state_writeback = 1'b1;
        end
    endcase
end

endmodule
