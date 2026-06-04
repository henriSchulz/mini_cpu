`timescale 1ns/1ps

module pc_tb;

    reg clk;
    reg reset;
    reg load;
    reg inc;
    reg [31:0] din;
    wire [31:0] q;

    pc dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .inc(inc),
        .din(din),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/waves/pc_tb.vcd");
        $dumpvars(0, pc_tb);

        clk   = 1'b0;
        reset = 1'b1;
        load  = 1'b0;
        inc   = 1'b0;
        din   = 32'h0;

        #1;
        $display("nach reset q=%h", q);

        reset = 1'b0;
        inc   = 1'b1;

        @(posedge clk);
        #1;
        $display("nach 1. inc q=%h", q);

        @(posedge clk);
        #1;
        $display("nach 2. inc q=%h", q);

        load = 1'b1;
        inc  = 1'b0;
        din  = 32'h00000020;

        @(posedge clk);
        #1;
        $display("nach load q=%h", q);

        load = 1'b0;
        inc  = 1'b1;

        @(posedge clk);
        #1;
        $display("nach weiterem inc q=%h", q);

        load = 1'b1;
        inc  = 1'b1;
        din  = 32'h00000055;

        @(posedge clk);
        #1;
        $display("bei load+inc q=%h", q);

        $finish;
    end

endmodule
