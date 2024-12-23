# MIPS Pipeline Processor

This repository contains the implementation of a fully functional MIPS 32 pipeline processor developed using VHDL. The processor supports advanced hardware features, ensuring efficient handling of data and control flow hazards. Below, you'll find details about the architecture, features, and how to use this project.



![MIPS Full Circuit](https://github.com/AbdulrahmanShokier/MIPS-Pipeline-Processor/blob/main/Data/Full%20MIPS%20.png?raw=true)



# Features

## Core Functionality

- MIPS Instruction Set: Implements a subset of the MIPS instruction set architecture.

- Pipelined Design: Utilizes a 5-stage pipeline architecture (Fetch, Decode, Execute, Memory, Write-back).

## Advanced Hardware Features

- Forwarding Unit: Resolves RAW data hazards by forwarding results from later pipeline stages(memory or write back) to earlier one stage(execute).

- Hazard Detection Unit: Detects and mitigates data and control hazards, ensuring smooth pipeline operation.

- Static Branch Prediction: Implements a static branch prediction mechanism (always not taken) for conditional branch instructions.
  
- CPU Stalling: Introduces a stalling mechanism to pause(stall) the pipeline when a hazard cannot be resolved by forwarding or prediction.

## Additional Features

- Fully synchronous design with clock gating for power optimization.

- Modular and parameterized VHDL code for easy customization.

# Prerequisites

To use this project, you will need:

- A VHDL development environment (e.g., Xilinx Vivado, ModelSim, or Quartus Prime).

- Basic understanding of MIPS architecture and pipelining.

# Getting Started

# Cloning the Repository

Clone this repository to your local machine using:

git clone (https://github.com/AbdulrahmanShokier/MIPS-Pipeline-Processor.git)

## Simulating the Processor

1. Open the project in your VHDL simulator.

2. Navigate to the testbench/ directory and run the provided testbenches.

3. Verify the output in the waveform viewer or simulation logs.

4. You can view a sample simulation screenshot below:

  
![Simulation](https://github.com/AbdulrahmanShokier/MIPS-Pipeline-Processor/blob/main/Stages/Simulation2.png?raw=true)




# Synthesizing the Processor

1. Use your FPGA design tool to synthesize the project.

2. Ensure that all constraints are correctly configured for your target FPGA.

# Usage

This processor can be used to execute a wide range of MIPS instructions. You can write your own programs in assembly, convert them to machine code, and load them into the instruction memory.

## Example Program

Below is a simple example program that demonstrates the functionality of the processor:
 
main:

addi $t0,$0,5

addi $t1,$0,5

addi $t2,$t1,5

lw $t3,3($t0)

add $t4,$t3,$t0

beq $t1,$t0,label

add $t5,$t0,$t1

label: add $t5,$t0,$t1 


# Design Details

## Pipeline Stages

1. Instruction Fetch (IF): Fetches instructions from memory.

2. Instruction Decode (ID): Decodes the instruction and reads register values.

3. Execute (EX): Performs arithmetic or logical operations.

4. Memory Access (MEM): Reads from or writes to memory.

5. Write-back (WB): Writes results back to the register file.

## Forwarding Unit

- Dynamically forwards data from the EX/MEM or MEM/WB pipeline stages to the EX stage to resolve read-after-write (RAW) hazards.

## Hazard Detection Unit

- Stalls the pipeline when dependencies cannot be resolved by forwarding.

## Branch Prediction

- Implements static branch prediction (always not taken), minimizing control hazards while maintaining simplicity.

# Testing and Verification

- Comprehensive testbenches are provided to verify individual modules and the entire processor.

- Test cases include arithmetic operations, data hazards, control hazards, and branch instructions.

![Statics](https://github.com/AbdulrahmanShokier/MIPS-Pipeline-Processor/blob/main/Data/Statics.png?raw=true)


![Clock Cycles](https://github.com/AbdulrahmanShokier/MIPS-Pipeline-Processor/blob/main/Data/Screenshot%202024-12-20%20232822.png?raw=true)


![Code in memory](https://github.com/AbdulrahmanShokier/MIPS-Pipeline-Processor/blob/main/Data/Screenshot%202024-12-20%20153512.png?raw=true)


