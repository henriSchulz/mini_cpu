module data_ram(
    input clk,
    input we,
    input [31:0] addr,
    input [31:0] din,
    output [31:0] dout
);

    reg [31:0] mem [0:255];

    initial begin
        $readmemh("mem/data.hex", mem);
    end

    assign dout = mem[addr[7:0]];

    always @(posedge clk) begin
        if (we)
            mem[addr[7:0]] <= din;
    end

endmodule