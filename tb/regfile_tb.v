`timescale 1ns/1ps

module regfile_tb;

    reg clk;
    reg reset;
    reg we;
    reg [1:0] wa;
    reg [31:0] wd;
    reg [1:0] ra1;
    reg [1:0] ra2;

    wire [31:0] rd1;
    wire [31:0] rd2;

    regfile dut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .wa(wa),
        .wd(wd),
        .ra1(ra1),
        .ra2(ra2),
        .rd1(rd1),
        .rd2(rd2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/waves/regfile_tb.vcd");
        $dumpvars(0, regfile_tb);

        clk   = 1'b0;
        reset = 1'b1;
        we    = 1'b0;
        wa    = 2'b00;
        wd    = 32'h0;
        ra1   = 2'b00;
        ra2   = 2'b01;

        #1;
        $display("nach reset: rd1=%h rd2=%h", rd1, rd2);

        reset = 1'b0;


        we = 1'b1;
        wa = 2'b00;
        wd = 32'h00000012;
        @(posedge clk);
        #1;


        wa = 2'b01;
        wd = 32'h00000034;
        @(posedge clk);
        #1;


        wa = 2'b10;
        wd = 32'h00000056;
        @(posedge clk);
        #1;


        we  = 1'b0;
        ra1 = 2'b00;
        ra2 = 2'b01;
        #1;
        $display("R0/R1: rd1=%h rd2=%h", rd1, rd2);


        ra1 = 2'b10;
        ra2 = 2'b00;
        #1;
        $display("R2/R0: rd1=%h rd2=%h", rd1, rd2);


        we = 1'b0;
        wa = 2'b01;
        wd = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        ra1 = 2'b01;
        ra2 = 2'b10;
        #1;
        $display("nach we=0: rd1=%h rd2=%h", rd1, rd2);

        $finish;
    end

endmodule
