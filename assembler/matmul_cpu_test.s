# ═══════════════════════════════════════════════════════════════
# CPU-side benchmark program: 4x4 matrix multiply in pure software
#
# The ISA has no multiply instruction, so each A[i][k] * B[k][j]
# product is computed by repeated addition (add A to the product,
# B times). This is what "matrix multiply on this CPU" honestly
# costs.
#
# Memory layout (data memory is word-addressed: one word per addr):
#   dmem[ 0..15]  Matrix A, row-major
#   dmem[16..31]  Matrix B, row-major
#   dmem[32..47]  Matrix C (result), row-major
#   addr 512      Host MMIO TX port (sw here raises host_tx_valid)
#
# Protocol with the C++ harness (sim/benchmark.cpp):
#   1. Initialize A and B in data memory   (NOT measured)
#   2. sw marker  -> 512                   (starts cycle counter)
#   3. Compute C = A x B into dmem[32..47] (measured)
#   4. sw marker  -> 512                   (stops cycle counter)
#   5. Stream the 16 C values -> 512       (harness verifies them)
#
# Register allocation:
#   x1  A row base pointer      x8   a = A[i][k]
#   x2  B column base pointer   x9   b = B[k][j] (mul counter)
#   x3  a_ptr                   x10  product accumulator
#   x4  b_ptr                   x11  sum (C[i][j])
#   x5  i loop counter          x12  C write pointer
#   x6  j loop counter          x13  scratch / markers
#   x7  k loop counter          x14  loop bound scratch
# ═══════════════════════════════════════════════════════════════

# ── Initialize Matrix A = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
#    Values are sequential 1..16, so a loop suffices.
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

# ── C = A x B, software triple loop with repeated-addition multiply ──
    addi x5, x0, 4          # i = 4 (counts down)
    addi x1, x0, 0          # A row base = 0
    addi x12, x0, 32        # C write pointer
i_loop:
    addi x6, x0, 4          # j = 4 (counts down)
    addi x2, x0, 16         # B column base = 16 (column 0)
j_loop:
    addi x11, x0, 0         # sum = 0
    add  x3, x1, x0         # a_ptr = A row base
    add  x4, x2, x0         # b_ptr = B column base
    addi x7, x0, 4          # k = 4 (counts down)
k_loop:
    lw   x8, 0(x3)          # a = A[i][k]
    lw   x9, 0(x4)          # b = B[k][j]
    addi x10, x0, 0         # product = 0
mul_loop:                   # product = a * b via repeated addition
    beq  x9, x0, mul_done
    add  x10, x10, x8
    addi x9, x9, -1
    beq  x0, x0, mul_loop
mul_done:
    add  x11, x11, x10      # sum += product
    addi x3, x3, 1          # next A element in row
    addi x4, x4, 4          # next B element in column (stride 4)
    addi x7, x7, -1
    beq  x7, x0, k_done
    beq  x0, x0, k_loop
k_done:
    sw   x11, 0(x12)        # C[i][j] = sum
    addi x12, x12, 1
    addi x2, x2, 1          # next B column
    addi x6, x6, -1
    beq  x6, x0, j_done
    beq  x0, x0, j_loop
j_done:
    addi x1, x1, 4          # next A row
    addi x5, x5, -1
    beq  x5, x0, compute_done
    beq  x0, x0, i_loop
compute_done:

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
