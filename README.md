# IITB-RISC-23: A Pipelined 16-bit RISC Processor

## Project Overview

This project is part of the EE-309 Microprocessors course at the Indian Institute of Technology Bombay. The goal is to design a 6-stage pipelined processor, IITB-RISC-23, which follows a specific 16-bit instruction set architecture. The processor is based on a simplified model designed for educational purposes, emulating the Little Computer Architecture.

## Project Objectives

1. **Design a 6-Stage Pipelined Processor:**
   - Instruction Fetch
   - Instruction Decode
   - Register Read
   - Execute
   - Memory Access
   - Write Back

2. **Optimize for Performance:**
   - Implement hazard mitigation techniques.
   - Include forwarding mechanisms.

3. **Optional:**
   - Implement a branch predictor.

## Architecture Details

### General Information
- **Architecture:** 16-bit
- **Registers:** 8 general-purpose registers (R0 to R7)
- **Program Counter:** R0
- **Condition Code Register:** Carry flag (C) and Zero flag (Z)
- **Instruction Length:** 2 bytes
- **Addressing:** Byte addressing
- **Predicated Execution:** Supported

### Instruction Set

The IITB-RISC-23 supports 14 instructions divided into three formats: R, I, and J.

#### R-Type Instructions
- **Format:** Opcode (4 bits) | Register A (3 bits) | Register B (3 bits) | Register C (3 bits) | Complement (1 bit) | Condition (2 bits)
- **Examples:**
  - `ADA`: Add content of RegB to RegA and store the result in RegC.
  - `ADC`: Add content of RegB to RegA and store the result in RegC if the carry flag is set.

#### I-Type Instructions
- **Format:** Opcode (4 bits) | Register A (3 bits) | Register C (3 bits) | Immediate (6 bits signed)
- **Examples:**
  - `ADI`: Add content of RegA with an immediate value and store the result in RegB.
  - `LW`: Load value from memory into RegA. Memory address is formed by adding an immediate value with the content of RegB.

#### J-Type Instructions
- **Format:** Opcode (4 bits) | Register A (3 bits) | Immediate (9 bits signed)
- **Examples:**
  - `LLI`: Load lower immediate into RegA.
  - `JAL`: Jump and link to an address offset by an immediate value, storing the return address in RegA.

## Project Group

This project is to be completed by a group of four students.
- Jay Mehta
- Jainam Ravani
- Kshitij Vaidya
- Adit Srivastava
