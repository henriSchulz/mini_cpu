`timescale 1ns/1ps

module register_tb;

    reg [31:0] d;
    reg reset;
    reg we;
    reg clk;
    wire [31:0] q;

    register dut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .d(d),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/waves/register_tb.vcd");
        $dumpvars(0, register_tb);

       clk = 1'b0;

        reset = 1'b0;
        d     = 32'h0000000C;
        we    = 1'b1;


        @(posedge clk);
        #1;
        $display("q=%h", q);

        we=1'b0;

        reset = 1'b1;
        @(posedge clk);
        #1;
        $display("q=%h", q);


        we = 1'b1;
        d = 32'hFFFFFFFF;
        reset = 1'b0;

        @(posedge clk);
        #1;
        $display("q=%h", q);

        $finish;
    end

endmodule
