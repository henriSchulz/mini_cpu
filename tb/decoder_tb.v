`timescale 1ns/1ps

module decoder_tb;

    reg  [47:0] instr;
    wire [4:0] opcode;
    wire [1:0] rd;
    wire [1:0] rs;
    wire [31:0] imm;

    decoder dut (
        .instr(instr),
        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .imm(imm)
    );

    initial begin
        $dumpfile("sim/waves/decoder_tb.vcd");
        $dumpvars(0, decoder_tb);

        // LDI R1, 0x2A  -> opcode=00000, rd=01, rs=00, imm=0x0000002A
        // OO=0x00, DD=(rd=01<<2|rs=00)=0x04
        instr = 48'h00_04_0000002A;
        #1;
        $display("LDI: opcode=%b rd=%b rs=%b imm=%h", opcode, rd, rs, imm);

        // ADD R0, R1  -> opcode=00010, rd=00, rs=01, imm=0
        // OO=0x02, DD=(rd=00<<2|rs=01)=0x01
        instr = 48'h02_01_00000000;
        #1;
        $display("ADD: opcode=%b rd=%b rs=%b imm=%h", opcode, rd, rs, imm);

        // JMP 0x10  -> opcode=01000, rd=00, rs=00, imm=0x00000010
        // OO=0x08, DD=0x00
        instr = 48'h08_00_00000010;
        #1;
        $display("JMP: opcode=%b rd=%b rs=%b imm=%h", opcode, rd, rs, imm);

        // NOT R2  -> opcode=01111, rd=10, rs=10, imm=0
        // OO=0x0F, DD=(rd=10<<2|rs=10)=0x0A
        instr = 48'h0F_0A_00000000;
        #1;
        $display("NOT: opcode=%b rd=%b rs=%b imm=%h", opcode, rd, rs, imm);

        $finish;
    end

endmodule
