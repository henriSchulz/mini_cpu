`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] op;
    wire [31:0] result;
    wire zero;
    wire carry;


    alu dut(
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );


    initial begin
        $dumpfile("sim/waves/alu_tb.vcd");
        $dumpvars(0, alu_tb);
        // add 5 + 11

        a = 32'h0;
        b = 32'h0;
        op = 3'b000;
        #10;

        $display("carry=%b, sum=%h, zero=%b", carry, result, zero);




        $finish;

    end



endmodule
