import re

no_operand_insts = ['nop', 'ret', 'rti']
one_operand_insts = ['not', 'neg','dec','inc', 'out', 'in', 'jz', 'jmp', 'call', 'protect', 'free', 'push', 'pop']
two_operand_insts = ['swap', 'cmp', 'ldm', 'ldd', 'std']
three_operand_insts = ['add', 'addi', 'sub', 'subi', 'and', 'or', 'xor']
thirty2_bit_inst=  ['addi','subi', 'ldm','std','ldd','ldm', 'ldd']

is_immidiate = ['addi', 'rcl', 'rcr', 'ldm', 'ldd', 'std']

regs = ['r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7']

rdest= ['not', 'neg', 'dec', 'inc', 'add', 'addi', 'sub', 'and', 'or', 'xor', 'bitset', 'rcl', 'rcr', 'ldm', 'ldd', 'pop', 'in']

rscr1= ['swap', 'add', 'addi', 'sub', 'and', 'or', 'xor', 'cmp', 'rcl', 'rcr', 'std', 'push', 'out', 'jz', 'jmp', 'call', 'protect', 'free']
rdst_eq_rsrc1 = ['not', 'neg', 'dec', 'inc']
rdst_eq_rsrc_imm = ['bitset', 'rcl', 'rcr']

rscr2= ['add', 'sub', 'and', 'or', 'xor', 'cmp','swap']
ealow = ['std','ldd']
eacat=['push', 'pop','std','ldd','protect','free']


op_code = {

    "nop" : "000",

    "not" : "001",
    "neg" : "001",
    "inc" : "001",
    "dec" : "001",
    "swap" : "001",
    "add" : "001",
    "sub" : "001",
    "and" : "001",
    "or" : "001",
    "xor" : "001",
    "cmp" : "001",

    "subi" : "010",
    "addi" : "010",

    "out" : "011",
    "in" : "011",

    "push" : "100",
    "pop" : "100",
    "ldm" : "100",
    "ldd" : "100",
    "std" : "100",

    "protect" : "101",
    "free" : "101",

    "jz" : "110",
    "jmp" : "110",
    "call" : "110",
    "ret" : "110",
    "rti" : "110",







    # "not": "001",
    # "neg": "001",
    # "inc": "001",
    # "dec": "001",
    # "add": "00",
    # "addi": "00",
    # "sub": "00",
    # "and": "00",
    # "xor": "00",
    # "or": "00",
    # "cmp": "00",
    # "bitset": "00",
    # "rcr": "00",
    # "rcl": "00",
    # "swap": "00",
    # "ldm": "00",
    # "push":"01",
    # "pop":"01",
    # "std":"01",
    # "ldd":"01",
    # "protect":"01",
    # "free":"01",
    # "in":"10",
    # "out":"10",
    # "call":"11",
    # "jmp":"11",
    # "jz":"11",
    # "ret":"11",
    # "rti":"11",
    # "nop": "11",
}

# function set is 4 bits long
func = {

    "nop" : "xxxx",

    "not" : "0010",
    "neg" : "0100",
    "inc" : "0110",
    "dec" : "1000",
    "swap" : "0011",
    "add" : "0101",
    "sub" : "0111",
    "and" : "1001",
    "or" : "1011",
    "xor" : "1111",
    "cmp" : "1101",

    "subi" : "001x",
    "addi" : "010x",

    "out" : "001x",
    "in" : "010x",

    "push" : "001x",
    "pop" : "010x",
    "ldm" : "011x",
    "ldd" : "100x",
    "std" : "101x",

    "protect" : "001x",
    "free" : "010x",

    "jz" : "001x",
    "jmp" : "010x",
    "call" : "011x",
    "ret" : "100x",
    "rti" : "101x",




    # "not": "0010",
    # "neg": "0001",
    # "inc": "0010",
    # "dec": "0011",
    # "add": "0100",
    # "addi": "0101",
    # "sub": "0110",
    # "and": "0111",
    # "xor": "1000",
    # "or": "1001",
    # "cmp": "1010",
    # "bitset": "1011",
    # "rcr": "1100",
    # "rcl": "1101",
    # "swap": "1110",
    # "ldm": "1111",
    # "push":"110",
    # "pop":"111",
    # "std":"010",
    # "ldd":"011",
    # "protect":"100",
    # "free":"000",
    # "in":"000",
    # "out":"001",
    # "call":"000",
    # "jmp":"110",
    # "jz":"010",
    # "ret":"101",
    # "rti":"001"
}

register_bank = {} # binary value of the register
for i in range(8):
    register_bank[f"r{i}"] = f"{i:03b}"
    print(register_bank[f"r{i}"])


# cleans instructions from spaces
def clean_instructions(instruction_line):

    # remove spaces and ignore #
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

    return op_code[instruction[0]] + func[instruction[0]][0:3] + "xxxxxxxxx" + func[instruction[0]][3]

def one_operand_instructions(instruction):

    # NOT R1 -> len is 2
    # return binary number (001 001 001 xxx xxx 0)

    return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + "xxxxxx" + func[instruction[0]][3]

def two_operand_instructions(instruction):

    # swap R1 R2 -> len is 3
    # return binary number (001 001 001 002 xxx 1)

    if instruction[0] == 'cmp':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + "xxx" + register_bank[instruction[1]] + register_bank[instruction[2]] + func[instruction[0]][3]
    elif instruction[0] == 'ldm':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + "xxxxxx" + func[instruction[0]][3]

    return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + "xxx" + func[instruction[0]][3]

def three_operand_instructions(instruction):

    # AND R1, R2, R3 -> len is 
    # return binary number (001 010 001 010 011 1)
    if instruction[0] == 'addi' or instruction[0] == 'subi':
        return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + "xxx" + func[instruction[0]][3]

    return op_code[instruction[0]] + func[instruction[0]][0:3] + register_bank[instruction[1]] + register_bank[instruction[2]] + register_bank[instruction[3]] + func[instruction[0]][3]





def save_binary_instructions(binary_instruction):
    
        with open("binary.txt", 'w') as file:
    
            for line in binary_instruction:
                file.write(line + '\n')
    
        print("Binary instructions saved to binary.txt")



instructions = read_file("test.txt")
binary_instruction = []

for instruction in instructions:
    print(instruction)

for instruction in instructions:
    
    if instruction[0] in no_operand_insts:
        binary_instruction.append(no_operand_instructions(instruction))
    elif instruction[0] in one_operand_insts:
        binary_instruction.append(one_operand_instructions(instruction))
    elif instruction[0] in two_operand_insts:
        binary_instruction.append(two_operand_instructions(instruction))
    elif instruction[0] in three_operand_insts:
        binary_instruction.append(three_operand_instructions(instruction))
    else:
        print ("operand not found: " + instruction[0])

# print(binary_instruction)


save_binary_instructions(binary_instruction)




