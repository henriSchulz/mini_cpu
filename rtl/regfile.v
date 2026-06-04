module regfile (
    input clk,
    input reset,  //asny reset 
    input we,
    input [1:0] wa, // write adreess
    input [31:0] wd, // write data
    input [1:0] ra1, // read address 1
    input [1:0] ra2, // read address 2
    output reg [31:0] rd1, // read data 1
    output reg [31:0] rd2 // read data
);

    wire [31:0] q0, q1, q2, q3;
    wire we0, we1, we2, we3;

    assign we0 = we & (wa == 2'b00);
    assign we1 = we & (wa == 2'b01);
    assign we2 = we & (wa == 2'b10);
    assign we3 = we & (wa == 2'b11);

    register reg0 (.clk(clk), .reset(reset), .we(we0), .d(wd), .q(q0));
    register reg1 (.clk(clk), .reset(reset), .we(we1), .d(wd), .q(q1));
    register reg2 (.clk(clk), .reset(reset), .we(we2), .d(wd), .q(q2));
    register reg3 (.clk(clk), .reset(reset), .we(we3), .d(wd), .q(q3));

    always @(*) begin
        case (ra1)
            2'b00: rd1 = q0;
            2'b01: rd1 = q1;
            2'b10: rd1 = q2;
            2'b11: rd1 = q3;
        endcase
    end

    always @(*) begin
        case (ra2)
            2'b00: rd2 = q0;
            2'b01: rd2 = q1;
            2'b10: rd2 = q2;
            2'b11: rd2 = q3;
        endcase
    end

endmodule