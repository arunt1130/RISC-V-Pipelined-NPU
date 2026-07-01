"""
RISC-V RV32I ISA Definitions for the Assembler.
Contains opcodes, funct3, funct7, and register mappings.
"""

# Format types: 'R', 'I', 'S', 'SB'
INSTRUCTIONS = {
    'add':  {'fmt': 'R',  'opcode': 0x33, 'funct3': 0x0, 'funct7': 0x00},
    'sub':  {'fmt': 'R',  'opcode': 0x33, 'funct3': 0x0, 'funct7': 0x20},
    'and':  {'fmt': 'R',  'opcode': 0x33, 'funct3': 0x7, 'funct7': 0x00},
    'or':   {'fmt': 'R',  'opcode': 0x33, 'funct3': 0x6, 'funct7': 0x00},
    
    'addi': {'fmt': 'I',  'opcode': 0x13, 'funct3': 0x0},
    'lw':   {'fmt': 'I',  'opcode': 0x03, 'funct3': 0x2},
    
    'sw':   {'fmt': 'S',  'opcode': 0x23, 'funct3': 0x2},
    
    'beq':  {'fmt': 'SB', 'opcode': 0x63, 'funct3': 0x0},

    # Jumps (function calls / returns)
    'jal':  {'fmt': 'UJ', 'opcode': 0x6F},                # jal rd, label
    'jalr': {'fmt': 'I',  'opcode': 0x67, 'funct3': 0x0}, # jalr rd, imm(rs1)

    # Pseudoinstructions
    'nop':  {'fmt': 'pseudo', 'real': 'addi', 'args': ['x0', 'x0', '0']},
}

# ABI Register mapping to integer (0-31)
REGISTERS = {
    # Standard x0-x31
    **{f'x{i}': i for i in range(32)},
    
    # Common ABI names
    'zero': 0,
    'ra':   1,
    'sp':   2,
    'gp':   3,
    'tp':   4,
    't0':   5,
    't1':   6,
    't2':   7,
    's0':   8,
    'fp':   8,
    's1':   9,
    'a0':   10,
    'a1':   11,
    'a2':   12,
    'a3':   13,
    'a4':   14,
    'a5':   15,
    'a6':   16,
    'a7':   17,
    's2':   18,
    's3':   19,
    's4':   20,
    's5':   21,
    's6':   22,
    's7':   23,
    's8':   24,
    's9':   25,
    's10':  26,
    's11':  27,
    't3':   28,
    't4':   29,
    't5':   30,
    't6':   31,
}

def get_reg_num(reg_str):
    """Convert a register string like 'x1' or 'sp' to its integer value."""
    reg_str = reg_str.strip().lower()
    if reg_str not in REGISTERS:
        raise ValueError(f"Unknown register: {reg_str}")
    return REGISTERS[reg_str]
