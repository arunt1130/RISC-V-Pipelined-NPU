# NPU Pipeline End-to-End Verification Program
# 
# This program specifically tests memory-mapped I/O
# interacting with the Systolic Array NPU at base address 256.

# 1. Initialize matrices A and B
addi x1, x0, 2       # x1 = 2
sw   x1, 256(x0)     # A[0][0] = 2

addi x2, x0, 4       # x2 = 4
sw   x2, 257(x0)     # A[0][1] = 4

addi x3, x0, 3       # x3 = 3
sw   x3, 272(x0)     # B[0][0] = 3

addi x4, x0, 5       # x4 = 5
sw   x4, 276(x0)     # B[1][0] = 5

# 2. Trigger NPU Start
addi x5, x0, 1       # x5 = 1
sw   x5, 304(x0)     # Start Reg = 1

# 3. Poll NPU Status
poll:
lw   x6, 305(x0)     # Load Status Reg into x6
beq  x6, x0, poll    # If x6 == 0 (not done), loop back to poll

# 4. Read Result Matrix C
lw   x7, 288(x0)     # Read C[0][0] into x7
                     # C[0][0] = A[0][0]*B[0][0] + A[0][1]*B[1][0]
                     # C[0][0] = 2*3 + 4*5 = 6 + 20 = 26

# End of execution
add  x0, x0, x0      # NOP
