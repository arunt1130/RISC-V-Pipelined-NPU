# Makefile for Verilator Simulation

# Build directory (override with `make BUILD_DIR=...` if desired)
BUILD_DIR ?= /tmp/obj_dir_riscv

PYTHON ?= python3

# Source files
RTL_COMMON = $(wildcard rtl/common/*.v)
RTL_PIPELINE = $(wildcard rtl/pipeline/*.v)
RTL_NPU = $(wildcard rtl/npu/*.v)
VERILOG_SOURCES = $(RTL_COMMON) $(RTL_PIPELINE) $(RTL_NPU)

SIM_SOURCES = sim/sim_main.cpp
BENCH_SOURCES = sim/benchmark.cpp

# Verilator flags — warnings are fatal; the RTL builds lint-clean
VERILATOR_FLAGS = --cc --exe --build -j 0 --top-module top --Mdir $(BUILD_DIR) -Irtl/common -Irtl/pipeline -Irtl/npu

# Executable name
TARGET = $(BUILD_DIR)/Vtop

all: $(TARGET)

$(TARGET): $(VERILOG_SOURCES) $(SIM_SOURCES)
	mkdir -p $(BUILD_DIR)
	cp sim/sim_main.cpp $(BUILD_DIR)/
	verilator $(VERILATOR_FLAGS) $(VERILOG_SOURCES) $(BUILD_DIR)/sim_main.cpp

run: $(TARGET)
	$(TARGET) +firmware=assembler/firmware.hex

BENCH_TARGET = $(BUILD_DIR)/Vbenchmark

$(BENCH_TARGET): $(VERILOG_SOURCES) $(BENCH_SOURCES)
	mkdir -p $(BUILD_DIR)
	cp sim/benchmark.cpp $(BUILD_DIR)/
	verilator $(VERILATOR_FLAGS) -o Vbenchmark $(VERILOG_SOURCES) $(BUILD_DIR)/benchmark.cpp

bench: $(BENCH_TARGET)
	$(BENCH_TARGET) assembler/matmul_cpu_test.hex assembler/matmul_npu_test.hex

# ── Self-checking testbenches (Verilator --binary --timing) ──

# Single-cycle core
test_single:
	mkdir -p $(BUILD_DIR)/sc
	verilator --binary --timing -j 0 --Mdir $(BUILD_DIR)/sc \
		--top-module tb_single_cycle \
		$(RTL_COMMON) rtl/single_cycle/single_cycle_top.v tb/tb_single_cycle.v
	$(BUILD_DIR)/sc/Vtb_single_cycle

# NPU parameterization + signed + randomized tests (2x2, 4x4, 8x8 instances)
test_param:
	mkdir -p $(BUILD_DIR)/np
	verilator --binary --timing -j 0 --Mdir $(BUILD_DIR)/np \
		--top-module tb_npu_param \
		$(RTL_NPU) tb/tb_npu_param.v
	$(BUILD_DIR)/np/Vtb_npu_param

# CPU-driven NPU integration test (assembler-generated program)
test_npu:
	mkdir -p $(BUILD_DIR)/ni
	verilator --binary --timing -j 0 --Mdir $(BUILD_DIR)/ni \
		--top-module tb_npu_integration \
		$(VERILOG_SOURCES) tb/tb_npu_integration.v
	$(BUILD_DIR)/ni/Vtb_npu_integration

# End-to-end CPU test (assembler-generated cpu_test.hex)
test_cpu_e2e:
	mkdir -p $(BUILD_DIR)/ce
	verilator --binary --timing -j 0 --Mdir $(BUILD_DIR)/ce \
		--top-module tb_cpu_e2e \
		$(VERILOG_SOURCES) tb/tb_cpu_e2e.v
	$(BUILD_DIR)/ce/Vtb_cpu_e2e

# End-to-end NPU test (assembler-generated npu_test.hex)
test_npu_e2e:
	mkdir -p $(BUILD_DIR)/ne
	verilator --binary --timing -j 0 --Mdir $(BUILD_DIR)/ne \
		--top-module tb_npu_e2e \
		$(VERILOG_SOURCES) tb/tb_npu_e2e.v
	$(BUILD_DIR)/ne/Vtb_npu_e2e

# jal/jalr test — same assembled program on both cores
test_jump:
	mkdir -p $(BUILD_DIR)/ju
	verilator --binary --timing -j 0 --Mdir $(BUILD_DIR)/ju \
		--top-module tb_jump \
		$(VERILOG_SOURCES) rtl/single_cycle/single_cycle_top.v tb/tb_jump.v
	$(BUILD_DIR)/ju/Vtb_jump

# Run every self-checking testbench
test: test_single test_param test_npu test_cpu_e2e test_npu_e2e test_jump

# Strict lint over all RTL (both top modules) — warnings are errors
lint:
	verilator --lint-only --top-module top \
		-Irtl/common -Irtl/pipeline -Irtl/npu \
		$(VERILOG_SOURCES)
	verilator --lint-only --top-module Single_Cycle_Top \
		-Irtl/common $(RTL_COMMON) rtl/single_cycle/single_cycle_top.v
	@echo "Lint clean."

# Regenerate all checked-in program hex files from their .s sources
hex:
	$(PYTHON) assembler/assembler.py assembler/firmware.s assembler/firmware.hex
	$(PYTHON) assembler/assembler.py assembler/cpu_test.s assembler/cpu_test.hex
	$(PYTHON) assembler/assembler.py assembler/npu_test.s assembler/npu_test.hex
	$(PYTHON) assembler/assembler.py assembler/matmul_cpu_test.s assembler/matmul_cpu_test.hex
	$(PYTHON) assembler/assembler.py assembler/matmul_npu_test.s assembler/matmul_npu_test.hex
	$(PYTHON) assembler/assembler.py assembler/jump_test.s assembler/jump_test.hex

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run bench hex clean
