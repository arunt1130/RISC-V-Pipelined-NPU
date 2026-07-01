# ═══════════════════════════════════════════════════════════════
# jal/jalr test — function calls and returns
#
# Calls the `double` subroutine twice via jal (link in x1/ra),
# returns via jalr, does a plain unconditional jump (jal x0),
# and verifies the skipped instruction never executes.
#
# Expected final state:
#   x1  = 16   (link left by the SECOND jal, at PC 12: 12+4)
#   x10 = 20   (5 doubled twice)
#   x11 = 11   (10 + 1, computed between the two calls)
#   x12 = 22   (20 + 2)
#   x13 = 0    (instruction after `jal x0` must be skipped)
#   x14 = 7    (jump landing point)
# ═══════════════════════════════════════════════════════════════

main:
    addi x10, x0, 5         # PC 0:  argument = 5
    jal  x1, double         # PC 4:  call double -> x10 = 10, x1 = 8
    addi x11, x10, 1        # PC 8:  x11 = 11 (runs after return)
    jal  x1, double         # PC 12: call double -> x10 = 20, x1 = 16
    addi x12, x10, 2        # PC 16: x12 = 22
    jal  x0, skip           # PC 20: plain jump, no link
    addi x13, x0, 99        # PC 24: MUST BE SKIPPED (x13 stays 0)
skip:
    addi x14, x0, 7         # PC 28: x14 = 7
end:
    beq  x0, x0, end        # PC 32: park

double:
    add  x10, x10, x10      # PC 36: x10 *= 2
    jalr x0, 0(x1)          # PC 40: return to caller
