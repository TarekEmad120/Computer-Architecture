# Pipeline Processor

The vhdl implementation of 5-stage pipelined Processor 🦾

### Processor Design

![Image](Design/5-stage-processor-design.png)

## ISA

### 🤔 Instruction Categories

- NOP
- ALU
  - One Operand
    1. **NOT** Rdst
    2. **NEG** Rdst
    3. **INC** Rdst
    4. **DEC** Rdst
  - Two Operands
    1. **ADD** Rdst, Rsrc1, Rsrc2
    2. **SUB** Rdst, Rsrc1, Rsrc2
    3. **AND** Rdst, Rsrc1, Rsrc2
    4. **OR** Rdst, Rsrc1, Rsrc2
    5. **XOR** Rdst, Rsrc1, Rsrc2
    6. **CMP** Rsrc1, Rsrc2 (110)
    7. **SWAP** Rdst, Rsrc (111)
- Immediate
  1. **ADDI** Rdst, Rsrc1, Imm
  2. **BITSET** Rdst, Imm
  3. **RCL** Rdst, Imm
  4. **RCR** Rdst, Imm
  5. **LDM** Rdst, Imm
- Conditional JMP
  1. **JZ** Rdst
- Unconditional JMP
  1. **JMP** Rdst
  2. **CALL** Rdst
  3. **RET** Rdst
  4. **RTI** Rdst
- DATA Operations
  1. **IN** Rdst
  2. **OUT** Rdst
  3. **PUSH** Rdst
  4. **POP** Rdst
  5. **LDD** Rdst, EA
  6. **STD** Rdst, EA
- Memory Security (FREE/PROTECT)
  1. **FREE** Rsrc
  2. **PROTECT** Rsrc
- Input Signals (RESET/INT)
  1. **Reset**
  2. **Interrupt**

### Instruction Bits details 🔍

# ALU Operations

| Operation              | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | Rsc1 b(6-4) | b(3-1) | One/Two attributes |
| ---------------------- | ----------------- | ------------- | ------------- | ----------- | ------ | ------------------ |
| NOT Rdst               | 001               | 001           | Rdst          | xxx         | xxx    | 0                  |
| NEG Rdst               | 001               | 010           | Rdst          | xxx         | xxx    | 0                  |
| INC Rdst               | 001               | 011           | Rdst          | xxx         | xxx    | 0                  |
| DEC Rdst               | 001               | 100           | Rdst          | xxx         | xxx    | 0                  |
| MOV Rdst, Rsrc         | 001               | 000           | Rdst          | Rsrc        | xxx    | 1                  |
| SWAP Rdst, Rsrc1       | 001               | 001           | Rdst          | Rsrc        | xxx    | 1                  |
| ADD Rdst, Rsrc1, Rsrc2 | 001               | 010           | Rdst          | Rsrc        | Rsrc2  | 1                  |
| SUB Rdst, Rsrc1, Rsrc2 | 001               | 011           | Rdst          | Rsrc        | Rsrc2  | 1                  |
| AND Rdst, Rsrc1, Rsrc2 | 001               | 100           | Rdst          | Rsrc        | Rsrc2  | 1                  |
| OR Rdst, Rsrc1, Rsrc2  | 001               | 101           | Rdst          | Rsrc        | Rsrc2  | 1                  |
| XOR Rdst, Rsrc1, Rsrc2 | 001               | 111           | Rdst          | Rsrc        | Rsrc2  | 1                  |
| CMP Rsrc1, Rsrc2       | 001               | 110           | xxx           | Rsrc        | Rsrc2  | 1                  |

# Immediate Value Operations

| Operation             | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | Rsc1 b(6-4) | b(3-1) | b(0) |
| --------------------- | ----------------- | ------------- | ------------- | ----------- | ------ | ---- |
| SUBI Rdst, Rsrc1, Imm | 010               | 001           | Rdst          | Rsrc        | xxx    | x    |
| ADDI Rdst, Rsrc1, Imm | 010               | 010           | Rdst          | Rsrc        | xxx    | x    |

# Input/Output Operations

| Operation | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | b(6-4) | b(3-1) | b(0) |
| --------- | ----------------- | ------------- | ------------- | ------ | ------ | ---- |
| OUT Rdst  | 011               | 001           | Rdst          | xxx    | xxx    | x    |
| IN Rdst   | 011               | 010           | Rdst          | xxx    | xxx    | x    |

# Memory Operations

| Operation           | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | Rsc1 b(6-4) | b(3-1) | b(0) |
| ------------------- | ----------------- | ------------- | ------------- | ----------- | ------ | ---- |
| PUSH Rdst           | 100               | 001           | Rdst          | xxx         | xxx    | x    |
| POP Rdst            | 100               | 010           | Rdst          | xxx         | xxx    | x    |
| LDM Rdst, Imm       | 100               | 011           | Rdst          | xxx         | xxx    | x    |
| LDD Rdst, EA(Rsrc1) | 100               | 100           | Rdst          | Rsrc1       | xxx    | x    |
| STD Rdst, EA(Rsrc1) | 100               | 101           | Rdst          | Rsrc1       | xxx    | x    |

# Protect / Free Operations

| Operation    | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | b(6-4) | Rsrc b(3-1) | b(0) |
| ------------ | ----------------- | ------------- | ------------- | ------ | ----------- | ---- |
| PROTECT Rsrc | 101               | 001           | xxx           | xxx    | Rsrc        | x    |
| FREE Rsrc    | 101               | 010           | xxx           | xxx    | Rsrc        | x    |

# Branching

| Operation | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | b(6-4) | b(3-1) | b(0) |
| --------- | ----------------- | ------------- | ------------- | ------ | ------ | ---- |
| JZ Rdst   | 110               | 001           | Rdst          | xxx    | xxx    | x    |
| JMP Rdst  | 110               | 010           | Rdst          | xxx    | xxx    | x    |
| CALL Rdst | 110               | 011           | Rdst          | xxx    | xxx    | x    |
| RET       | 110               | 100           | xxx           | xxx    | xxx    | x    |
| RTI       | 110               | 101           | xxx           | xxx    | xxx    | x    |

# Nop

| Operation | Opp Code (3 bits) | Func (3 bits) | Rdst (3 bits) | b(6-4) | b(3-1) | b(0) |
| --------- | ----------------- | ------------- | ------------- | ------ | ------ | ---- |
| NOP       | 000               | xxx           | xxx           | xxx    | xxx    | x    |
