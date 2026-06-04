`timescale 1ns/1ps

module cpu_tb;

// ─── DUT signals ──────────────────────────────────────────────────────────────
reg clk;
reg reset;

cpu_top dut (
    .clk   (clk),
    .reset (reset)
);

// ─── Clock: 10 ns period ──────────────────────────────────────────────────────
initial clk = 0;
always #5 clk = ~clk;

// Timeout nach 10000 ns
// initial begin
//     #100000;
//     $display("TIMEOUT: HALT nie erreicht");
//     $finish;
// end




initial begin
    $dumpfile("sim/waves/cpu_tb.vcd");
    $dumpvars(0, cpu_tb);

    // Reset
    reset = 1;
    #20;
    reset = 0;

    // Warte bis HALT
    @(posedge dut.cu0.halted);

    // Register ausgeben
    $display("R0: %d", dut.rf0.q0);
    $display("R1: %d", dut.rf0.q1);
    $display("R2: %d", dut.rf0.q2);
    $display("R3: %d", dut.rf0.q3);

    $finish;
end

endmodule
