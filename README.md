# Pipeline Processor

The vhdl implementation of 5-stage pipelined Processor

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
