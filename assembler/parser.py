import re
from isa import INSTRUCTIONS

def parse_line(line):
    """
    Strips comments and whitespace.
    Returns:
      - None if empty line or comment
      - ('label', name) if the line is just a label (e.g. 'loop:')
      - ('instr', name, args_list) if it's an instruction
    """
    # Remove comments (# or //)
    line = re.split(r'#|//', line)[0].strip()
    if not line:
        return None
        
    # Check if it's a label
    if line.endswith(':'):
        return ('label', line[:-1].strip())
        
    # Parse instruction
    # e.g., "add x1, x2, x3" or "lw x1, 4(x0)"
    parts = line.split(None, 1)
    instr_name = parts[0].lower()
    
    if len(parts) == 1:
        # Instruction with no arguments (e.g., nop)
        return ('instr', instr_name, [])
        
    # Split arguments by comma
    args_raw = parts[1].split(',')
    args = []
    
    for arg in args_raw:
        arg = arg.strip()
        # Handle offset(reg) syntax for loads/stores
        # e.g., "4(x0)" -> "4", "x0"
        match = re.match(r'(-?\d+)\((.+)\)', arg)
        if match:
            args.append(match.group(1)) # offset
            args.append(match.group(2)) # base reg
        else:
            args.append(arg)
            
    return ('instr', instr_name, args)

def parse_file(filepath):
    """
    Reads file, resolves labels, and returns a list of instructions ready for encoding.
    Returns: [{'name': 'add', 'args': ['x1', 'x2', 'x3'], 'pc': 0}, ...]
    """
    labels = {}
    instructions = []
    pc = 0
    
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    # Pass 1: Resolve pseudoinstructions and labels
    for raw_line in lines:
        parsed = parse_line(raw_line)
        if not parsed:
            continue
            
        type_ = parsed[0]
        if type_ == 'label':
            labels[parsed[1]] = pc
        elif type_ == 'instr':
            name = parsed[1]
            args = parsed[2]
            
            # Handle pseudoinstructions
            if name in INSTRUCTIONS and INSTRUCTIONS[name]['fmt'] == 'pseudo':
                pseudo = INSTRUCTIONS[name]
                name = pseudo['real']
                args = pseudo['args']
                
            instructions.append({'name': name, 'args': args, 'pc': pc, 'line': raw_line.strip()})
            pc += 4  # Each instruction is 4 bytes
            
    return instructions, labels
