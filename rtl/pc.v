module pc (
    input clk,
    input reset,
    input load,
    input inc,
    input [31:0] din, // data input
    output reg [31:0] q // data output
);


    always @(posedge clk or posedge reset) begin
        if(reset) q<=32'h0;
        else if(load) q<=din;
        else if(inc) q<=q+1;
    end


endmodule