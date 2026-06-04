module register(
    input clk,
    input reset, // async reset
    input we, // write enabled
    input [31:0] d,
    output reg [31:0] q
);

    always @(posedge clk or posedge reset) begin
        if(reset) q<=32'h0;
        else if (we) q<=d;
    end

endmodule