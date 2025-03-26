# Makefile for running the GHDL simulation and analyze the resulting signals with GTKWave

# the path of the vhdl directory relative to the Makefile
VHDL_PATH = ../../vhdl/ex04/

# the vhdl files you want to compile
FILES = $(VHDL_PATH)ALU_Pkg.vhd $(VHDL_PATH)ALU.vhd $(VHDL_PATH)tb_ex04.vhd

FILES_PKG = $(VHDL_PATH)ALU_Pkg.vhd
FILES_ALU = $(VHDL_PATH)ALU.vhd
FILES_TB  = $(VHDL_PATH)tb_ex04.vhd

# testbench parameters
WORKDIR = work
input_file = /input.txt
output_file = /output.txt

# GHDL config
GHDL_CMD 	= ghdl
GHDL_FLAGS 	= --std=08 --workdir=$(WORKDIR)

# wave viewer config
WAVEFORM_VIEWER = gtkwave

all: clean make run view

make:
ifeq ($(strip $(TESTBENCH)),)
	echo "TESTBENCH missing. Call with TESTBENCH=<tb_entity_name>."
	exit 1
endif

	mkdir -p $(WORKDIR)
	$(GHDL_CMD) -a $(GHDL_FLAGS) $(FILES)
	$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCH)

run:
	$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=$(WORKDIR) $(TESTBENCH) --vcd=$(TESTBENCH).vcd 
	mv $(TESTBENCH).vcd $(WORKDIR)/

view:
	$(WAVEFORM_VIEWER) --dump=$(WORKDIR)/$(TESTBENCH).vcd

clean:
	rm -rf $(WORKDIR)

