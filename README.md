# SoC_Project

## Simulation
### Setup
1. Add path to src/ins_mem_init.txt file to line 122 of src/mem_controller.sv
2. Run Quartus Project project/soc

### Run a compiled code
1. Generate assembly code (use an online compiler) 
2. Copy and paste assembly code into ./Assembly-To-Machine-Code-Risc-V/test.asm
3. Run ./Assembly-To-Machine-Code-Risc-V/A-to_M.cpp
4. Copy and paste the resultant content of MCode.mc into the ins_mem_init.txt
5. Run the RTL simulation from Quartus 

## Verification
