import re

no_operand_insts = ['nop', 'ret', 'rti']
one_operand_insts = ['not', 'neg','dec','inc', 'out', 'in', 'jz', 'jmp', 'call', 'protect', 'free', 'push', 'pop']
two_operand_insts = ['swap', 'cmp', 'ldm', 'mov']
three_operand_insts = ['add', 'sub', 'and', 'or', 'xor']
immidiate_insts = ['addi', 'subi', 'ldd', 'std']

regs = ['r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7']


op_code = {

    "nop"     : "000",

    "not"     : "001",
    "neg"     : "001",
    "inc"     : "001",
    "dec"     : "001",
    "mov"     : "001",
    "swap"    : "001",
    "add"     : "001",
    "sub"     : "001",
    "and"     : "001",
    "or"      : "001",
    "xor"     : "001",
    "cmp"     : "001",

    "subi"    : "010",
    "addi"    : "010",

    "out"     : "011",
    "in"      : "011",

    "push"    : "100",
    "pop"     : "100",
    "ldm"     : "100",
    "ldd"     : "100",
    "std"     : "100",

    "protect" : "101",
    "free"    : "101",

    "jz"      : "110",
    "jmp"     : "110",
    "call"    : "110",
    "ret"     : "110",
    "rti"     : "110",

}

# function set is 4 bits long
func = {

    "nop"     : "0000",

    "not"     : "0010",
    "neg"     : "0100",
    "inc"     : "0110",
    "dec"     : "1000",
    "mov"     : "0001",
    "swap"    : "0011",
    "add"     : "0101",
    "sub"     : "0111",
    "and"     : "1001",
    "or"      : "1011",
    "xor"     : "1111",
    "cmp"     : "1101",

    "subi"    : "0010",
    "addi"    : "0100",

    "out"     : "0010",
    "in"      : "0100",

    "push"    : "0010",
    "pop"     : "0100",
    "ldm"     : "0110",
    "ldd"     : "1000",
    "std"     : "1010",

    "protect" : "0010",
    "free"    : "0100",

    "jz"      : "0010",
    "jmp"     : "0100",
    "call"    : "0110",
    "ret"     : "1000",
    "rti"     : "1010",

}

register_bank = {} # binary value of the register
for i in range(8):
    register_bank[f"r{i}"] = f"{i:03b}"
    print(register_bank[f"r{i}"])



def to_binary(decimal_number, width=16):
    n = int(decimal_number)
    if n >= 0:
        binary = bin(n)[2:]
        return binary.zfill(width)
    else:
        binary = bin(n & (2 ** width - 1))[2:]
        return binary.zfill(width)


def hex_to_decimal(hex_string):
    decimal_value = int(hex_string, 16)
    return decimal_value



# cleans instructions from spaces
def clean_instructions(instruction_line):

    # remove spaces and ignore #
    if instruction_line.startswith('.'):
        return None
    cleaned_line = instruction_line.split('#')[0].strip()
    
    print(cleaned_line)
    instructions = []
    words = [word.lower() for word in re.split(r'[,\s]+', instruction_line.split('#')[0].strip())]
    if words[0] == "":
        return None

    if (len(words)==1 or len(words)==2) and cleaned_line.count(',')==0: #no operand/one operand
        None
    elif len(words)==3 and cleaned_line.count(',')==1: #two operand
        None
    elif len(words)==4 and cleaned_line.count(',')==2: #two operand
        None
    else:
        print("syntax error in "+ cleaned_line)

    if not words:
        return None

    return words



# open file and read the instructions
def read_file(file_path):

    with open(file_path, 'r') as file:

        instructions = []

        for line in file:
            if clean_instructions(line):
                instructions.append(clean_instructions(line))
        # print (instructions)

    
    return instructions


def no_operand_instructions(instruction):

    # NOP -> len is 1
    # return binary number (000 xxx xxx xxx xxx x)

    return op_code[instruction[0]] + func[instruction[0]][0:3] + "000000000" + func[instruction[0]][3]

def one_operand_instructions(instruction):

    # NOT R1 -> len is 2
    # return binary number (001 001 001 xxx xxx 0)

    return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + "000000" + func[instruction[0]][3]

def two_operand_instructions(instruction):

    # swap R1 R2 -> len is 3
    # return binary number (001 001 001 002 xxx 1)

    if instruction[0] == 'cmp':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + "000" + register_bank[instruction[1]] + register_bank[instruction[2]] + func[instruction[0]][3]
    elif instruction[0] == 'ldm':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + "000000" + func[instruction[0]][3]

    return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + "000" + func[instruction[0]][3]

def three_operand_instructions(instruction):

    # AND R1, R2, R3 -> len is 
    # return binary number (001 010 001 010 011 1)
    # if instruction[0] == 'addi' or instruction[0] == 'subi':
    #     return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + "xxx" + func[instruction[0]][3]

    return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + register_bank[instruction[3]] + func[instruction[0]][3]




def immediate_operand_instructions(instruction):

    # ADDI R1, R2, 1234
    if instruction[0] == 'addi' or instruction[0] == 'subi':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + "000" + func[instruction[0]][3]
    # elif instruction[0] == 'ldm':
    #     return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + "xxxxxx" + func[instruction[0]][3]
    elif instruction[0] == 'ldd' or instruction[0] == 'std':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + "000" + func[instruction[0]][3]

def save_binary_instructions(binary_instruction):
    
        with open("binary.txt", 'w') as file:
    
            for line in binary_instruction:
                file.write(line + '\n')
    
        print("Binary instructions saved to binary.txt")



instructions = read_file("test.txt")
binary_instruction = []

# for instruction in instructions:
#     print(instruction)

for instruction in instructions:
    
    if instruction[0] in no_operand_insts:
        binary_instruction.append(no_operand_instructions(instruction))
    elif instruction[0] in one_operand_insts:
        binary_instruction.append(one_operand_instructions(instruction))
    elif instruction[0] in two_operand_insts:
        binary_instruction.append(two_operand_instructions(instruction))
        if instruction[0] == 'ldm':
            binary_instruction.append(to_binary(hex_to_decimal(instruction[2]))) 
    elif instruction[0] in three_operand_insts:
        binary_instruction.append(three_operand_instructions(instruction))
    elif instruction[0] in immidiate_insts:
        binary_instruction.append(immediate_operand_instructions(instruction))

    else:
        print ("operand not found: " + instruction[0])

# print(binary_instruction)


save_binary_instructions(binary_instruction)
