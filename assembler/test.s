# Test program for the Python RV32I Assembler
# Tests all supported instructions (R, I, S, SB types)

    # I-Type: addi
    addi x1, x0, 10      # x1 = 10
    addi x2, x0, 20      # x2 = 20

    # R-Type: add, sub, and, or
    add  x3, x1, x2      # x3 = 10 + 20 = 30
    sub  x4, x2, x1      # x4 = 20 - 10 = 10
    and  x5, x1, x2      # x5 = 10 & 20
    or   x6, x1, x2      # x6 = 10 | 20

    # S-Type: sw
    sw   x3, 0(x0)       # Mem[0] = x3 (30)
    sw   x4, 4(x0)       # Mem[4] = x4 (10)

    # I-Type: lw
    lw   x7, 0(x0)       # x7 = Mem[0] (30)
    lw   x8, 4(x0)       # x8 = Mem[4] (10)

    # SB-Type: beq (Branch Forward)
    beq  x7, x8, end     # 30 == 10? False, don't branch

    # Pseudoinstruction test
    nop                  # Translates to addi x0, x0, 0
    
loop:
    addi x8, x8, 10      # x8 = x8 + 10
    # SB-Type: beq (Branch Backward)
    beq  x8, x7, loop    # 20 == 30? Loop until equal

end:
    add  x9, x0, x7      # Reached the end
