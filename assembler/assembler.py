import re

# list of instructions based of number of operands 
no_operand_insts = ['nop', 'ret', 'rti', 'int']
one_operand_insts = ['not', 'neg','dec','inc', 'out', 'in', 'jz', 'jmp', 'call', 'protect', 'free', 'push', 'pop', 'call']
two_operand_insts = ['swap', 'cmp', 'ldm', 'mov']
three_operand_insts = ['add', 'sub', 'and', 'or', 'xor']


immidiate_insts = ['addi', 'subi', 'ldd', 'std']

# register names
regs = ['r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7']


# opcode is 3 bit long
op_code = {

    # NOP
    "nop"     : "000",

    # ALU operations
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

    # Immediate Value Operations
    "subi"    : "010",
    "addi"    : "010",

    # I/O Operations
    "out"     : "011",
    "in"      : "011",

    # Memory Operations
    "push"    : "100",
    "pop"     : "100",
    "ldm"     : "100",
    "ldd"     : "100",
    "std"     : "100",

    # Protect / Free 
    "protect" : "101",
    "free"    : "101",

    # Branching
    "jz"      : "110",
    "jmp"     : "110",
    "call"    : "110",
    "ret"     : "110",
    "rti"     : "110",

    # Int
    "int"     : "111",

}

# function set is 4 bits long
func = {

    # NOP
    "nop"     : "0000",

    # ALU operations
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

    # Immediate Value Operations
    "subi"    : "0010",
    "addi"    : "0100",

    # I/O Operations
    "out"     : "0010",
    "in"      : "0100",

    # Memory Operations
    "push"    : "0010",
    "pop"     : "0100",
    "ldm"     : "0110",
    "ldd"     : "1000",
    "std"     : "1010",

    # Protect / Free 
    "protect" : "0010",
    "free"    : "0100",

    # Branching
    "jz"      : "0010",
    "jmp"     : "0100",
    "call"    : "0110",
    "ret"     : "1000",
    "rti"     : "1010",
    
    # Int
    "int"     : "1000",

}

register_bank = {} # binary value of the register
for i in range(8):
    register_bank[f"r{i}"] = f"{i:03b}"


# # convert decimal number to binary
# def to_binary(decimal_number, width=16):
#     n = int(decimal_number)
#     if n >= 0:
#         binary = bin(n)[2:]
#         return binary.zfill(width)
#     else:
#         binary = bin(n & (2 ** width - 1))[2:]
#         return binary.zfill(width)


# convert hex to binary
def hex_to_binary(hex_string):
    decimal_value = int(hex_string, 16)
    n = int(decimal_value)
    if n >= 0:
        binary = bin(n)[2:]
        return binary.zfill(16)
    else:
        binary = bin(n & (2 ** 16 - 1))[2:]
        return binary.zfill(16)



def no_operand_check(instruction):
    if len(instruction)==1:
        return True
    else: 
        return False
    
def one_operand_check(instruction):
     if len(instruction)==2 and len(instruction[1])==2 and instruction[1][0]=='r' and 0 <= int(instruction[1][1]) <= 7:
        return True
     else: 
        return False
def two_operand_check(instruction):
     if len(instruction)==3 and len(instruction[1])==2 and instruction[1][0]=='r' and len(instruction[2])==2  and instruction[2][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= int(instruction[2][1]) <= 7 :
        return True
     else: 
        return False

def three_operand_check(instruction):
     if len(instruction)==4 and len(instruction[1])==2 and len(instruction[2])==2 and len(instruction[3])==2 and instruction[1][0]=='r' and instruction[2][0]=='r' and instruction[3][0]=='r' and 0 <= int(instruction[1][1]) <= 7 and 0 <= int(instruction[2][1]) <= 7 and 0 <= int(instruction[3][1]) <= 7:
        return True
     else: 
        return False



# cleans instructions from spaces
def clean_instructions(instruction_line):

    # remove spaces and ignore #
    if instruction_line.startswith('.'):
        return None
    cleaned_line = instruction_line.split('#')[0].strip()
    
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

    
    return instructions


def no_operand_instructions(instruction):

    # NOP -> len is 1
    # return binary number (000 xxx xxx xxx xxx x)

    return op_code[instruction[0]] + func[instruction[0]][0:3] + "000000000" + func[instruction[0]][3]

def one_operand_instructions(instruction):

    # NOT R1 -> len is 2
    # return binary number (001 001 001 xxx xxx 0)

    if instruction[0] == 'protect' or instruction[0] == 'free':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + "000" + register_bank[instruction[1]] + "000" + func[instruction[0]][3]

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














instructions = read_file("Instructions.txt")
binary_instruction = []

# convert each instruction to binary instruction

for instruction in instructions:
    
    if instruction[0] in no_operand_insts:
        if no_operand_check(instruction):
            binary_instruction.append(no_operand_instructions(instruction))
        else:
            print("Error in assembly instruction")


    elif instruction[0] in one_operand_insts:
        if one_operand_check(instruction):
            binary_instruction.append(one_operand_instructions(instruction))
        else:
            print("Error in assembly instruction")
    

    elif instruction[0] in two_operand_insts:
        if two_operand_check(instruction):
            binary_instruction.append(two_operand_instructions(instruction))
            if instruction[0] == 'ldm':
                binary_instruction.append(hex_to_binary(instruction[2])) 
        else:
            print("Error in assembly instruction")
    
       
    elif instruction[0] in three_operand_insts:
        if two_operand_check(instruction):
            binary_instruction.append(three_operand_instructions(instruction))
            if instruction[0] == 'ldm':
                binary_instruction.append(hex_to_binary(instruction[2])) 
        else:
            print("Error in assembly instruction")


    elif instruction[0] in immidiate_insts:
        binary_instruction.append(immediate_operand_instructions(instruction))
        binary_instruction.append(hex_to_binary(instruction[3])) 

    else:
        print ("operand not found: " + instruction[0])


# save instruction to binary.txt
save_binary_instructions(binary_instruction)
