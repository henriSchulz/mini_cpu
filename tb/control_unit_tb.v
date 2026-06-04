`timescale 1ns/1ps

module control_unit_tb;

    reg clk;
    reg reset;
    reg [3:0] opcode;
    reg zero_flag;

    wire ir_load;
    wire pc_inc;
    wire pc_load;
    wire reg_write;
    wire flag_write;
    wire [2:0] alu_op;
    wire state_fetch;
    wire state_decode;
    wire state_execute;
    wire state_writeback;

    control_unit dut (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .zero_flag(zero_flag),
        .ir_load(ir_load),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .reg_write(reg_write),
        .flag_write(flag_write),
        .alu_op(alu_op),
        .state_fetch(state_fetch),
        .state_decode(state_decode),
        .state_execute(state_execute),
        .state_writeback(state_writeback)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/waves/control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);

        clk = 1'b0;
        reset = 1'b1;
        opcode = 4'b0010;   // ADD
        zero_flag = 1'b0;

        #1;
        $display("RESET: fetch=%b decode=%b execute=%b writeback=%b",
                 state_fetch, state_decode, state_execute, state_writeback);

        reset = 1'b0;

        // FETCH
        @(posedge clk);
        #1;
        $display("FETCH: ir_load=%b pc_inc=%b pc_load=%b reg_write=%b flag_write=%b alu_op=%b",
                 ir_load, pc_inc, pc_load, reg_write, flag_write, alu_op);

        // DECODE
        @(posedge clk);
        #1;
        $display("DECODE: ir_load=%b pc_inc=%b pc_load=%b reg_write=%b flag_write=%b alu_op=%b",
                 ir_load, pc_inc, pc_load, reg_write, flag_write, alu_op);

        // EXECUTE ADD
        @(posedge clk);
        #1;
        $display("EXECUTE ADD: ir_load=%b pc_inc=%b pc_load=%b reg_write=%b flag_write=%b alu_op=%b",
                 ir_load, pc_inc, pc_load, reg_write, flag_write, alu_op);

        // WRITEBACK ADD
        @(posedge clk);
        #1;
        $display("WRITEBACK ADD: ir_load=%b pc_inc=%b pc_load=%b reg_write=%b flag_write=%b alu_op=%b",
                 ir_load, pc_inc, pc_load, reg_write, flag_write, alu_op);

        // Test JMP
        opcode = 4'b1000;   // JMP

        @(posedge clk); #1; // FETCH
        @(posedge clk); #1; // DECODE
        @(posedge clk); #1; // EXECUTE
        $display("EXECUTE JMP: pc_load=%b", pc_load);

        // Test JZ with zero_flag = 1
        opcode = 4'b1001;   // JZ
        zero_flag = 1'b1;

        @(posedge clk); #1; // WRITEBACK from old flow / next state
        @(posedge clk); #1; // FETCH
        @(posedge clk); #1; // DECODE
        @(posedge clk); #1; // EXECUTE
        $display("EXECUTE JZ with zero=1: pc_load=%b", pc_load);

        // Test JZ with zero_flag = 0
        zero_flag = 1'b0;

        @(posedge clk); #1; // WRITEBACK / next state
        @(posedge clk); #1; // FETCH
        @(posedge clk); #1; // DECODE
        @(posedge clk); #1; // EXECUTE
        $display("EXECUTE JZ with zero=0: pc_load=%b", pc_load);

        $finish;
    end

endmodule