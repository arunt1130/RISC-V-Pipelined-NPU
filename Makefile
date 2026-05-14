# Makefile for Verilator Simulation

# Source files
RTL_COMMON = $(wildcard rtl/common/*.v)
RTL_PIPELINE = $(wildcard rtl/pipeline/*.v)
RTL_NPU = $(wildcard rtl/npu/*.v)
VERILOG_SOURCES = $(RTL_COMMON) $(RTL_PIPELINE) $(RTL_NPU)

SIM_SOURCES = sim/sim_main.cpp

# Verilator flags
VERILATOR_FLAGS = -Wno-fatal --cc --exe --build -j 0 --top-module top --Mdir /tmp/obj_dir_riscv -Irtl/common -Irtl/pipeline -Irtl/npu

# Executable name
TARGET = /tmp/obj_dir_riscv/Vtop

all: $(TARGET)

$(TARGET): $(VERILOG_SOURCES) $(SIM_SOURCES)
	mkdir -p /tmp/obj_dir_riscv
	cp sim/sim_main.cpp /tmp/obj_dir_riscv/
	verilator $(VERILATOR_FLAGS) $(VERILOG_SOURCES) /tmp/obj_dir_riscv/sim_main.cpp

run: $(TARGET)
	$(TARGET) +firmware=assembler/firmware.hex

clean:
	rm -rf /tmp/obj_dir_riscv
