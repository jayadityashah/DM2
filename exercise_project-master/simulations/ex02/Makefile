# Makefile for running the GHDL simulation and analyze the resulting signals with GTKWave

# the path of the vhdl directory relative to the Makefile
VHDL_PATH = ../../vhdl/ex02/

# the vhdl files you want to compile
FILES = $(VHDL_PATH)multiplexer.vhd $(VHDL_PATH)tb_ex02.vhd 

# testbench parameters
WORKDIR = work
INPUT_FILE = ../../assets/ex02/input.txt
OUTPUT_FILE = ../../assets/ex02/output.txt

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
