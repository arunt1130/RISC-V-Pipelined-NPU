from isa import INSTRUCTIONS, get_reg_num

def int_to_bin(val, bits):
    """Convert integer to binary string, handling two's complement for negatives."""
    val = int(val)
    if val < 0:
        val = (1 << bits) + val
    # Mask to desired bits just in case
    val &= (1 << bits) - 1
    return format(val, f'0{bits}b')

def encode_r_type(instr, args):
    """Encode R-type: funct7 | rs2 | rs1 | funct3 | rd | opcode"""
    rd = get_reg_num(args[0])
    rs1 = get_reg_num(args[1])
    rs2 = get_reg_num(args[2])
    
    opcode = int_to_bin(INSTRUCTIONS[instr]['opcode'], 7)
    funct3 = int_to_bin(INSTRUCTIONS[instr]['funct3'], 3)
    funct7 = int_to_bin(INSTRUCTIONS[instr]['funct7'], 7)
    
    binary = funct7 + int_to_bin(rs2, 5) + int_to_bin(rs1, 5) + funct3 + int_to_bin(rd, 5) + opcode
    return int(binary, 2)

def encode_i_type(instr, args):
    """Encode I-type: imm[11:0] | rs1 | funct3 | rd | opcode"""
    # Note: args could be [rd, rs1, imm] (addi) OR [rd, imm, rs1] (lw)
    if instr == 'lw':
        rd = get_reg_num(args[0])
        imm = int(args[1])
        rs1 = get_reg_num(args[2])
    else: # addi
        rd = get_reg_num(args[0])
        rs1 = get_reg_num(args[1])
        imm = int(args[2])
        
    opcode = int_to_bin(INSTRUCTIONS[instr]['opcode'], 7)
    funct3 = int_to_bin(INSTRUCTIONS[instr]['funct3'], 3)
    
    binary = int_to_bin(imm, 12) + int_to_bin(rs1, 5) + funct3 + int_to_bin(rd, 5) + opcode
    return int(binary, 2)

def encode_s_type(instr, args):
    """Encode S-type: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode"""
    # args: [rs2, imm, rs1] (sw)
    rs2 = get_reg_num(args[0])
    imm = int(args[1])
    rs1 = get_reg_num(args[2])
    
    opcode = int_to_bin(INSTRUCTIONS[instr]['opcode'], 7)
    funct3 = int_to_bin(INSTRUCTIONS[instr]['funct3'], 3)
    
    imm_bin = int_to_bin(imm, 12)
    imm_11_5 = imm_bin[0:7]
    imm_4_0 = imm_bin[7:12]
    
    binary = imm_11_5 + int_to_bin(rs2, 5) + int_to_bin(rs1, 5) + funct3 + imm_4_0 + opcode
    return int(binary, 2)

def encode_sb_type(instr, args, current_pc, labels):
    """Encode SB-type: imm[12] | imm[10:5] | rs2 | rs1 | funct3 | imm[4:1] | imm[11] | opcode"""
    # args: [rs1, rs2, label]
    rs1 = get_reg_num(args[0])
    rs2 = get_reg_num(args[1])
    target = args[2]
    
    # Resolve label or direct offset
    if target in labels:
        offset = labels[target] - current_pc
    else:
        offset = int(target)
        
    if offset % 2 != 0:
        raise ValueError(f"Branch offset must be a multiple of 2 (got {offset})")
        
    opcode = int_to_bin(INSTRUCTIONS[instr]['opcode'], 7)
    funct3 = int_to_bin(INSTRUCTIONS[instr]['funct3'], 3)
    
    imm_bin = int_to_bin(offset, 13) # Need 13 bits to extract indices 12 down to 1
    # imm_bin is string, index 0 is MSB (bit 12)
    imm_12 = imm_bin[0]
    imm_11 = imm_bin[1]
    imm_10_5 = imm_bin[2:8]
    imm_4_1 = imm_bin[8:12]
    
    binary = imm_12 + imm_10_5 + int_to_bin(rs2, 5) + int_to_bin(rs1, 5) + funct3 + imm_4_1 + imm_11 + opcode
    return int(binary, 2)

def encode_instruction(instr_dict, labels):
    """Takes a parsed instruction dict and routes to the correct encoder."""
    name = instr_dict['name']
    args = instr_dict['args']
    pc = instr_dict['pc']
    
    if name not in INSTRUCTIONS:
        raise ValueError(f"Unsupported instruction: {name}")
        
    fmt = INSTRUCTIONS[name]['fmt']
    
    if fmt == 'R':
        return encode_r_type(name, args)
    elif fmt == 'I':
        return encode_i_type(name, args)
    elif fmt == 'S':
        return encode_s_type(name, args)
    elif fmt == 'SB':
        return encode_sb_type(name, args, pc, labels)
    else:
        raise NotImplementedError(f"Format {fmt} not implemented")
