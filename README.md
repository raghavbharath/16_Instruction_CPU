# 16 Instruction CPU 

Introduction:

For this project, I created a CPU similar to the Relatively Simple CPU, containing 16 instructions. I completed this project in _**VHDL**_ (using _**Intel's Quartus Prime Lite Software**_) and partly in _**Verilog**_ and _**Multisim (for circuit testing)**_. To test the CPU, I created individual _**test benches (tb)**_ for each section (ALU, Registers, and Control Unit) and ran the _**waveform simulations**_ in _**NativeLink ModelSim**_. 

The CPU has a 64K x 8 memory with Address Pins A[15:0] and Data Pins D[7:0], an 8-bit Accumulator, an 8-bit General Purpose Register R, and a 1-bit Flag Register Z. The Z flag will be used for conditional instructions such as JMPZ. This project consists of many parts, with the 2 headers being the design and the VHDL simulation. 

The control unit is coded as a hardwired control unit, but is also implemented using vertical microcode through a 4:16 instruction decoder and time-based control signal generation to interface with memory, registers, and the ALU. Core components include a Wallace Tree-based multiplier, an accumulator (AC) register, a general-purpose register (R), and a zero flag (Z) for conditional execution logic. The CPU architecture is fully described in VHDL and verified through simulation using ModelSim.

The 16-instruction CPU is a challenging task to simulate, as it is part of the ECE 495 curriculum. This project will perform individual simulations for each of the components (e.g., ALU, Register section, and Control Unit) and will demonstrate how the design works. Thorough video demonstrations that explain the code and show the simulations are attached to the doc, and they are on their own page, so it is easier to find them. 


The entire code base is located in this current GitHub repo. 
This code contains the ALU, Register, and Control Unit codes with their working test benches, as well as the final CPU integration design code. 

## Here is the State Diagram for this CPU:

![Image](https://github.com/user-attachments/assets/ea1bc239-898c-4167-a912-a286e65f7295)

### CPU Execute Cycles & Micro-Operations

| Instruction | Step     | Micro-Operation                             |
|-------------|----------|---------------------------------------------|
| FETCH       | FETCH1   | AR ← PC                                     |
|             | FETCH2   | DR ← M, PC ← PC+1                           |
|             | FETCH3   | IR ← DR, AR ← PC                            |
| NOP         | NOP1     |                                             |
| AND         | AND1     | AC ← AC^R, Z ← 1 if AC^R = 0 else 0         |
| OR          | OR1      | AC ← AC∨R, Z ← 1 if AC∨R = 0 else 0         |
| XOR         | XOR1     | AC ← AC⊕R, Z ← 1 if AC⊕R = 0 else 0         |
| NOT         | NOT1     | AC ← AC’, Z ← 1 if AC’ = 0 else 0           |
| NAND        | NAND1    | AC ← (AC^R)’, Z ← 1 if (AC^R)’ = 0 else 0   |
| ADD         | ADD1     | AC ← AC+R, Z ← 1 if AC+R = 0 else 0         |
| MULT        | MULT1    | AC ← AC×R, Z ← 1 if AC×R = 0 else 0         |
| SUB         | SUB1     | AC ← AC–R, Z ← 1 if AC–R = 0 else 0         |
| MOVR        | MOVR1    | AC ← R                                      |
| MVAC        | MVAC1    | R ← AC                                      |
| JUMP        | JUMP1    | DR ← M, AR ← AR+1                           |
|             | JUMP2    | TR ← DR, DR ← M                             |
|             | JUMP3    | PC ← DR,TR                                  |
| JMPZ (Z=1)  | JMPZY1   | DR ← M, AR ← AR+1                           |
|             | JMPZY2   | TR ← DR, DR ← M                             |
|             | JMPZY3   | PC ← DR,TR                                  |
| JMPZ (Z≠1)  | JMPZN1   | PC ← PC+1                                   |
|             | JMPZN2   | PC ← PC+1                                   |
| JPNZ (Z=0)  | JPNZY1   | DR ← M, AR ← AR+1                           |
|             | JPNZY2   | TR ← DR, DR ← M                             |
|             | JPNZY3   | PC ← DR,TR                                  |
| JPNZ (Z≠0)  | JPNZN1   | PC ← PC+1                                   |
|             | JPNZN2   | PC ← PC+1                                   |
| LDAC        | LDAC1    | DR ← M, PC ← PC+1, AR ← AR+1                |
|             | LDAC2    | TR ← DR, DR ← M, PC ← PC+1                  |
|             | LDAC3    | AR ← DR,TR                                  |
|             | LDAC4    | DR ← M                                      |
|             | LDAC5    | AC ← DR                                     |
| STAC        | STAC1    | DR ← M, PC ← PC+1, AR ← AR+1                |
|             | STAC2    | TR ← DR, DR ← M, PC ← PC+1                  |
|             | STAC3    | AR ← DR,TR                                  |
|             | STAC4    | DR ← AC                                     |
|             | STAC5    | M ← DR                                      |



## Here are the Data Paths:
AR: AR ← PC,  AR ← DR,TR,  AR ← AR+1

PC: PC ← PC+1, PC ← DR, TR

DR: DR ← M

IR: IR ← DR

R: R ← AC

TR: TR ← DR

AC: AC ← AC^R, AC ← AC v R, AC ← (AC^R)’, AC ← AC ⊕ R, AC ← AC’, AC ← AC+R, AC ← AC-R, AC ← AC*R, AC ← R

Z: Z ← 1, Z ← 0

M: M ← DR


## Hardware Components:
The CPU will require several hardware components, including a register section for storage purposes, an ALU to do calculations, and a control unit to coordinate the execution of instructions.

## Hardwired Control Unit:
For the simulation, I decided to design the CPU with a hardwired control unit. Since I have 16 instructions, I use a 4:16 decoder to denote which instruction is being run. Separately, a counter is used to increment a 3:8 decoder which tells the CPU which execute cycle of the instruction is being run. T0, T1, and T2 are for FETCH1, FETCH2, and FETCH3, while the remaining are used for the cycles of the actual instruction. For example, LDAC1 would have T3 as the value for the 3:8 decoder, LDAC2 would have T4… and LDAC5 would have T7.
Below is a diagram of what the hardwired control unit looks like:

![Image](https://github.com/user-attachments/assets/98d2d5f9-91e1-4f7d-82bd-a9b7f52faa20)

![Image](https://github.com/user-attachments/assets/ed262d50-ae3e-4ce2-8ff4-4b07d0e2ffb9)

## Microcoded Control Unit:
An alternative to the hardwired control unit that was explored was a microcoded control unit. The reason it was not implemented into the simulation was because it was much more complex than implementing the simulation for the hardwired control unit. Nevertheless, here is the design for how our CPU could use a microcoded control unit.

Here are the Field Assignments: 

![Image](https://github.com/user-attachments/assets/fa729a30-ec1c-4d71-99d3-6c8e63d40cb5)

[Vertical_Microcode_Table.csv](https://github.com/user-attachments/files/20257994/Vertical_Microcode_Table.csv)

| **State** | **Address**     | **SEL** | **M1**  | **M2**  | **M3** | **ADDR**  |
|-----------|----------------|---------|--------|--------|--------|-----------|
| FETCH1    | 000000 (0)     | 0       | 0001   | 000    | 00     | 000001    |
| FETCH2    | 000001 (1)     | 0       | 0000   | 001    | 01     | 000010    |
| FETCH3    | 000010 (2)     | 1       | 0001   | 010    | 00     | XXXXXX    |
| AND1      | 000011 (3)     | 0       | 0111   | 011    | 00     | 000000    |
| OR1       | 000100 (4)     | 0       | 1000   | 011    | 00     | 000000    |
| XOR1      | 000101 (5)     | 0       | 1010   | 011    | 00     | 000000    |
| NOT1      | 000110 (6)     | 0       | 1011   | 011    | 00     | 000000    |
| NAND1     | 000111 (7)     | 0       | 1001   | 011    | 00     | 000000    |
| ADD1      | 001000 (8)     | 0       | 1100   | 011    | 00     | 000000    |
| MULT1     | 001001 (9)     | 0       | 1110   | 011    | 00     | 000000    |
| SUB1      | 001010 (10)    | 0       | 1101   | 011    | 00     | 000000    |
| JUMP1     | 001011 (11)    | 0       | 0010   | 001    | 00     | 001100    |
| JUMP2     | 001100 (12)    | 0       | 0100   | 001    | 00     | 001101    |
| JUMP3     | 001101 (13)    | 0       | 0000   | 000    | 10     | 000000    |
| JMPZY1    | 001110 (14)    | 0       | 0010   | 001    | 00     | 001111    |
| JMPZY2    | 001111 (15)    | 0       | 0100   | 001    | 00     | 010000    |
| JMPZY3    | 010000 (16)    | 0       | 0000   | 000    | 10     | 000000    |
| JMPZN1    | 010001 (17)    | 0       | 0000   | 000    | 01     | 010010    |
| JMPZN2    | 010010 (18)    | 0       | 0000   | 000    | 01     | 000000    |
| JPNZY1    | 010011 (19)    | 0       | 0010   | 001    | 00     | 010100    |
| JPNZY2    | 010100 (20)    | 0       | 0100   | 001    | 00     | 010101    |
| JPNZY3    | 010101 (21)    | 0       | 0000   | 000    | 10     | 000000    |
| JPNZN1    | 010110 (22)    | 0       | 0000   | 000    | 01     | 010111    |
| JPNZN2    | 010111 (23)    | 0       | 0000   | 000    | 01     | 000000    |
| LDAC1     | 011000 (24)    | 0       | 0010   | 001    | 01     | 011001    |
| LDAC2     | 011001 (25)    | 0       | 0100   | 001    | 01     | 011010    |
| LDAC3     | 011010 (26)    | 0       | 0011   | 000    | 00     | 011011    |
| LDAC4     | 011011 (27)    | 0       | 0000   | 001    | 00     | 011100    |
| LDAC5     | 011100 (28)    | 0       | 1111   | 000    | 00     | 000000    |
| MOVR1     | 011101 (29)    | 0       | 0101   | 000    | 00     | 000000    |
| MVAC1     | 011110 (30)    | 0       | 0110   | 000    | 00     | 000000    |
| STAC1     | 011111 (31)    | 0       | 0010   | 001    | 01     | 100000    |
| STAC2     | 100000 (32)    | 0       | 0100   | 001    | 01     | 100001    |
| STAC3     | 100001 (33)    | 0       | 0011   | 000    | 00     | 100010    |
| STAC4     | 100010 (34)    | 0       | 0000   | 100    | 00     | 100011    |
| STAC5     | 100011 (35)    | 0       | 0000   | 000    | 11     | 000000    |


Mnemonics | Micro-operations

ARPC: AR ← PC

ARDT: AR ← DR, TR

PCDT: PC ← DR, TR

PCIN: PC ← PC+1

DRM: DR ← M

IRDR: IR ← DR

RAC: R ← AC

TRDR: TR ← DR

ARIN: AR ← AR + 1

ACR: AC ← R

ACDR: AC ← DR

AND: AC ← AC^R

OR: AC ← AC v R

NAND: AC ← (AC^R)’

XOR: AC ← AC ⊕ R

NOT: AC ← AC’

ADD: AC ← AC+R

SUB: AC ← AC-R

MULT:  AC ← AC*R

ZALU: Z ← 1, Z ← 0

MDR: M ← DR




## ALU 
ALU:
For my ALU, I needed a parallel adder to handle addition and subtraction, a Wallace tree made of carry save adders to handle multiplication, as well as an AND, NAND, OR, XOR, and NOT gate. Since 

Below is a diagram of my ALU:

![Image](https://github.com/user-attachments/assets/798df395-5ded-4a69-847b-e0b884680a1b)

## Register Section:
Based on the information about our CPU mentioned at the beginning of the report, here is the diagram of my Register Section. The 8 registers I implemented are the AR (Address Register), AC (Accumulator), PC (Program Counter), 
DR (Data Register), TR (Temporary Register), IR (Instruction Register), R (General Purpose Register), and Z (The 1-bit Flag Register). 

![Image](https://github.com/user-attachments/assets/89a84eba-38a8-42ba-ac00-d9a947b31f2a)


## Pictures
![Image](https://github.com/user-attachments/assets/a1a34ed2-8591-469c-b3ba-28b81f238f6d)

![Image](https://github.com/user-attachments/assets/f4557422-670b-42af-a445-70638493d3ba)






## Conclusion 

In this honors project, I successfully designed and implemented a basic Central Processing Unit (CPU), gaining hands-on experience with the fundamental principles of computer architecture. The project reinforced key concepts such as instruction fetching, decoding, execution, and control logic. By integrating components like the ALU, registers, and control unit, I developed a functional datapath and control scheme capable of executing a predefined instruction set. Throughout the design process, I encountered and overcame challenges related to timing, synchronization, and component interfacing. Ultimately, this lab provided valuable insight into how hardware and control logic interact to execute instructions, bridging the gap between theoretical architecture and practical digital design.

Overall, the project involved creative problem solving as well as a strong foundation in CPU design. The most challenging part of the project was the simulation, but luckily, I was able to get each section working, and the simulation checked out with the theoretical values. I encountered a lot of struggles, whether it be not loading values in the simulations, a lack of data populating the waveforms, having to download external licenses to get the simulations to display, or debugging the VHDL code. However, out of these struggles came learning, and I was able to delve deeper into application design, which I wouldn’t have had the opportunity to do had I not signed up for this project. 
