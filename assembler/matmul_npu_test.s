# ═══════════════════════════════════════════════════════════════
# NPU-side benchmark program: 4x4 matrix multiply offloaded to the
# systolic array via real memory-mapped sw/lw instructions.
#
# This is the honest offload cost: the measured window includes
# copying A and B from data memory into the NPU register bank,
# starting the NPU, polling the status register until done, and
# copying the results back into data memory. No testbench
# shortcuts — every transfer goes through the CPU pipeline.
#
# Memory layout (data memory is word-addressed: one word per addr):
#   dmem[ 0..15]  Matrix A, row-major
#   dmem[16..31]  Matrix B, row-major
#   dmem[32..47]  Matrix C (result), row-major
#   256..271      NPU Matrix A registers   (dmem addr + 256)
#   272..287      NPU Matrix B registers
#   288..303      NPU Matrix C results     (dmem addr + 256)
#   304           NPU control (write 1 to start)
#   305           NPU status  (bit 0 = done)
#   addr 512      Host MMIO TX port (sw here raises host_tx_valid)
#
# Protocol with the C++ harness (sim/benchmark.cpp):
#   1. Initialize A and B in data memory     (NOT measured)
#   2. sw marker -> 512                      (starts cycle counter)
#   3. Copy A,B -> NPU, start, poll, copy C  (measured)
#   4. sw marker -> 512                      (stops cycle counter)
#   5. Stream the 16 C values -> 512         (harness verifies them)
# ═══════════════════════════════════════════════════════════════

# ── Initialize Matrix A = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
init:
    addi x1, x0, 0          # ptr = 0
    addi x2, x0, 1          # val = 1
    addi x3, x0, 17         # stop value
init_a:
    sw   x2, 0(x1)          # dmem[ptr] = val
    addi x1, x1, 1
    addi x2, x2, 1
    beq  x2, x3, init_b     # done when val == 17
    beq  x0, x0, init_a

# ── Initialize Matrix B = [[2,0,1,3],[1,1,0,2],[0,2,1,1],[3,0,2,0]]
init_b:
    addi x2, x0, 2
    sw   x2, 16(x0)         # B[0][0] = 2
    addi x2, x0, 0
    sw   x2, 17(x0)         # B[0][1] = 0
    addi x2, x0, 1
    sw   x2, 18(x0)         # B[0][2] = 1
    addi x2, x0, 3
    sw   x2, 19(x0)         # B[0][3] = 3
    addi x2, x0, 1
    sw   x2, 20(x0)         # B[1][0] = 1
    addi x2, x0, 1
    sw   x2, 21(x0)         # B[1][1] = 1
    addi x2, x0, 0
    sw   x2, 22(x0)         # B[1][2] = 0
    addi x2, x0, 2
    sw   x2, 23(x0)         # B[1][3] = 2
    addi x2, x0, 0
    sw   x2, 24(x0)         # B[2][0] = 0
    addi x2, x0, 2
    sw   x2, 25(x0)         # B[2][1] = 2
    addi x2, x0, 1
    sw   x2, 26(x0)         # B[2][2] = 1
    addi x2, x0, 1
    sw   x2, 27(x0)         # B[2][3] = 1
    addi x2, x0, 3
    sw   x2, 28(x0)         # B[3][0] = 3
    addi x2, x0, 0
    sw   x2, 29(x0)         # B[3][1] = 0
    addi x2, x0, 2
    sw   x2, 30(x0)         # B[3][2] = 2
    addi x2, x0, 0
    sw   x2, 31(x0)         # B[3][3] = 0

# ── Start marker: harness begins counting cycles here ──
    addi x13, x0, 1
    sw   x13, 512(x0)

# ── Copy A and B into the NPU register bank via MMIO stores ──
#    dmem[0..31] maps 1:1 onto NPU offsets 256..287 (addr + 256),
#    so one loop moves both matrices.
    addi x1, x0, 0
    addi x14, x0, 32
xfer:
    lw   x4, 0(x1)          # read matrix element from data memory
    sw   x4, 256(x1)        # write it to the NPU register bank
    addi x1, x1, 1
    beq  x1, x14, xfer_done
    beq  x0, x0, xfer
xfer_done:

# ── Kick off the NPU ──
    addi x4, x0, 1
    sw   x4, 304(x0)        # control register: start = 1

# ── Poll the status register until done ──
poll:
    lw   x4, 305(x0)        # status register, bit 0 = done
    beq  x4, x0, poll

# ── Copy results back: NPU 288..303 -> dmem[32..47] ──
    addi x1, x0, 32
    addi x14, x0, 48
read_c:
    lw   x4, 256(x1)        # read C element from NPU (addr 288..303)
    sw   x4, 0(x1)          # store into data memory
    addi x1, x1, 1
    beq  x1, x14, read_done
    beq  x0, x0, read_c
read_done:

# ── End marker: harness stops counting cycles here ──
    addi x13, x0, 2
    sw   x13, 512(x0)

# ── Stream C out to the host for verification (not measured) ──
    addi x1, x0, 32
    addi x14, x0, 48
stream:
    lw   x13, 0(x1)
    sw   x13, 512(x0)
    addi x1, x1, 1
    beq  x1, x14, stream_done
    beq  x0, x0, stream
stream_done:

end:
    beq  x0, x0, end        # park
