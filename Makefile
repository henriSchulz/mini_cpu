# Alu Files

ALU_SIM=sim/build/alu_tb
ALU_SRC=tb/alu_tb.v rtl/alu.v
ALU_VCD=sim/waves/alu_tb.vcd

# Register Files

REG_SIM=sim/build/register_tb
REG_SRC=tb/register_tb.v rtl/register.v
REG_VCD=sim/waves/register_tb.vcd

# Regfile Files

REGFILE_SIM=sim/build/regfile_tb
REGFILE_SRC=tb/regfile_tb.v rtl/regfile.v rtl/register.v
REGFILE_VCD=sim/waves/regfile_tb.vcd

# PC files 

PC_SIM=sim/build/pc_tb
PC_SRC=tb/pc_tb.v rtl/pc.v
PC_VCD=sim/waves/pc_tb.vcd

# Decode Files 

DECODER_SIM=sim/build/decoder_tb
DECODER_SRC=tb/decoder_tb.v rtl/decoder.v
DECODER_VCD=sim/waves/decoder_tb.vcd



CTRL_SIM=sim/build/control_unit_tb
CTRL_SRC=tb/control_unit_tb.v rtl/control_unit.v

CPU_SIM=sim/build/cpu_tb
CPU_SRC=tb/cpu_tb.v rtl/cpu_top.v rtl/pc.v rtl/decoder.v rtl/regfile.v rtl/register.v rtl/alu.v rtl/control_unit.v rtl/data_ram.v


all: alu

alu:
	mkdir -p sim/build sim/waves
	iverilog -o $(ALU_SIM) $(ALU_SRC)
	vvp $(ALU_SIM)

register:
	mkdir -p sim/build sim/waves
	iverilog -o $(REG_SIM) $(REG_SRC)
	vvp $(REG_SIM)

regfile:
	mkdir -p sim/build sim/waves
	iverilog -o $(REGFILE_SIM) $(REGFILE_SRC)
	vvp $(REGFILE_SIM)

pc:
	mkdir -p sim/build sim/waves
	iverilog -o $(PC_SIM) $(PC_SRC)
	vvp $(PC_SIM)

decoder:
	mkdir -p sim/build sim/waves
	iverilog -o $(DECODER_SIM) $(DECODER_SRC)
	vvp $(DECODER_SIM)


cpu:
	mkdir -p sim/build sim/waves
	iverilog -o $(CPU_SIM) $(CPU_SRC)
	vvp $(CPU_SIM)


control:
	mkdir -p sim/build sim/waves
	iverilog -o $(CTRL_SIM) $(CTRL_SRC)
	vvp $(CTRL_SIM)


clean:
	rm -f sim/build/* sim/waves/*