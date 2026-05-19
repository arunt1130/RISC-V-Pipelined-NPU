# Makefile for Verilator Simulation

# Source files
RTL_COMMON = $(wildcard rtl/common/*.v)
RTL_PIPELINE = $(wildcard rtl/pipeline/*.v)
RTL_NPU = $(wildcard rtl/npu/*.v)
VERILOG_SOURCES = $(RTL_COMMON) $(RTL_PIPELINE) $(RTL_NPU)

SIM_SOURCES = sim/sim_main.cpp
BENCH_SOURCES = sim/benchmark.cpp

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

BENCH_TARGET = /tmp/obj_dir_riscv/Vbenchmark

$(BENCH_TARGET): $(VERILOG_SOURCES) $(BENCH_SOURCES)
	mkdir -p /tmp/obj_dir_riscv
	cp sim/benchmark.cpp /tmp/obj_dir_riscv/
	verilator $(VERILATOR_FLAGS) -o Vbenchmark $(VERILOG_SOURCES) /tmp/obj_dir_riscv/benchmark.cpp

bench: $(BENCH_TARGET)
	$(BENCH_TARGET)


clean:
	rm -rf /tmp/obj_dir_riscv
