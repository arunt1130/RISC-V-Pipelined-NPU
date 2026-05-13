# CPU Pipeline End-to-End Verification Program
# 
# This program specifically avoids NPU memory addresses (256+)
# and purely tests the RISC-V CPU pipeline functionality.

# 1. I-Type: Initialization
addi x1, x0, 10      # x1 = 10
addi x2, x0, 20      # x2 = 20

# 2. R-Type: Arithmetic and Logic with Forwarding
add  x3, x1, x2      # x3 = 10 + 20 = 30
sub  x4, x3, x1      # x4 = 30 - 10 = 20  (tests forwarding from EX/MEM)
and  x5, x3, x2      # x5 = 30 & 20 = 20  (30 is 11110, 20 is 10100)
or   x6, x4, x1      # x6 = 20 | 10 = 30  (20 is 10100, 10 is 01010)

# 3. Memory & Load-Use Hazard Stall
sw   x6, 4(x0)       # Mem[4] = 30
lw   x7, 4(x0)       # x7 = Mem[4] = 30
add  x8, x7, x1      # x8 = 30 + 10 = 40  (load-use hazard: inserts 1 stall cycle!)

# 4. Branch Not Taken
beq  x1, x2, fail    # 10 == 20? False, falls through

# 5. Loops, Branch Taken, and Pseudoinstructions
addi x9, x0, 3       # Loop counter: x9 = 3
addi x10, x0, 0      # Sum: x10 = 0

loop:
beq  x9, x0, end     # Exit loop if x9 == 0 (Forward branch taken on 4th iteration)
add  x10, x10, x1    # x10 += 10
addi x9, x9, -1      # x9 -= 1
nop                  # Pseudoinstruction -> addi x0, x0, 0
beq  x0, x0, loop    # Unconditional jump (Backward branch taken)

fail:
addi x10, x0, 999    # If branch resolution failed, sum is corrupted

end:
add  x0, x0, x0      # End of execution.

# FINAL EXPECTED STATE:
# x1 = 10
# x2 = 20
# x3 = 30
# x4 = 20
# x5 = 20
# x6 = 30
# x7 = 30
# x8 = 40
# x9 = 0
# x10 = 30
# Mem[4] = 30
