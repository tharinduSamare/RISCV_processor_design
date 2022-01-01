## Architecture
The system includes 5 pipeline stages:
1. IF - Instruction Fetch
2. ID - Instruction Decode
3. EX - Execute
4. MEM - Memory (Read/Write)
5. WB - (Register) Write-Back

Each stage is divided by a pipeline register, which forwards control instructions and data.

The main components and their function are briefly described stagewise below.
1. Instruction Memory: This is an 32 bit asynchronous memory unit. Keeps the RV32I and RV32M machine codes. 
2. PC : A register that contains the current read address of the instruction memory.
3. Control Unit : Identifies the instruction type and generate control signals from the instruction. The control signals include:
    - regWrite : to write in the register file
    - memWrite : to write in to data memory
    - memRead : to read from data memory
    - branch : to branch to a different instruction if the conditions are satisfied
    - jump : to jump to a different instruction.
4. Register file : Register access
5. Immediate extend : Get the immediate part of the instruction and extends it into 32 bit inputs for use in the next stage. (Outputs 5 different outputs for 5 instruction types.)
6. ALU Op : This unit uses the instruction (funct7 and funct3) components and Control Unit input. It generates the control signals (add, sub, mul etc.) for ALU unit. 
7. ALU : Carries out Riscv32-I and M extension alu operations
8. Data Memory 
9. Hazard Unit : Stall or flush the pipeline when:
    - Waiting during memory is busy. (During memory read and memrory write operations.)
    - Branching occurs
    - Instruction jump occurs
