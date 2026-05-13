import sys
import os
from parser import parse_file
from encoder import encode_instruction

def main():
    if len(sys.argv) < 3:
        print("Usage: python assembler.py <input.s> <output.hex>")
        sys.exit(1)
        
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    if not os.path.exists(input_file):
        print(f"Error: Input file {input_file} not found.")
        sys.exit(1)
        
    print(f"Assembling {input_file} ...")
    
    try:
        # Parse pass
        instructions, labels = parse_file(input_file)
        
        # Encode pass
        hex_output = []
        for instr in instructions:
            binary_val = encode_instruction(instr, labels)
            # Format as 8-character hex, lowercase
            hex_str = f"{binary_val:08x}"
            hex_output.append(hex_str)
            
            # Print debug info
            print(f"0x{instr['pc']:04x}: {hex_str}  # {instr['line']}")
            
        # Write to file
        with open(output_file, 'w') as f:
            f.write("\n".join(hex_output) + "\n")
            
        print(f"\nSuccess! Wrote {len(hex_output)} instructions to {output_file}")
        
    except Exception as e:
        print(f"\nAssembly Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
