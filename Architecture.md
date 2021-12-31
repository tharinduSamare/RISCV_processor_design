## Architecture
The system includes 5 pipeline stages:
1. IF - Instruction Fetch
2. ID - Instruction Decode
3. EX - Execute
4. MEM - Memory (Read/Write)
5. WB - (Register) Write-Back

Each stage is divided by a pipeline register, which forwards control instructions and data.

The main components and their function are briefly described stagewise below.
1. Instruction Memory: This is an asynchronous memory unit
2. PC : A register that contains the current read address of the instruction memory
3. Control Unit : Identifies the instruction type and control signals from the instruction. The control signals include:
    - regWrite : to write in the register file
    - memWrite : to write in to data memory
    - memRead : to read from data memory
4. Register file : Register access
5. Immediate extend : Converts immediate type inputs into 32 bit inputs for use in the next stage
6. ALU Op : This unit uses the instruction (funct7 and funct3) components and CU input
7. ALU : Carries out Riscv32-I and M extension alu operations
8. Data Memory 
9. Hazard Unit : Stalls the pipeline when:
    - Waiting for output from data memory
    - Branching occurs
    - Instruction jump occurs
