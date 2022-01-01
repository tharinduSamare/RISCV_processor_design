# Factorial Recursive
- This program calculates factorial of a number recursively.

- The relevant assembly code for this program is provided in [Factorial_Recursive_assembly_code](Factorial_Recursive_assembly_code.txt) text file.

- The machine code generated for this assembly code is avaiable in the in the [Factorial_Recursive_machine_code](Factorial_Recursive_machine_code.txt) text file.

- The expected instruction memory for this program is shown in [Factorial_Recursive_instruction_memory](Factorial_Recursive_instruction_memory.txt) text file. Copy all the content and replace the content in [ins_mem_init.txt](../../src/ins_mem_init.txt) file.

- Run [top_tb.sv](../../testbench/top_tb.sv).

- The result of the factorial can be checked by;

  - Follow the steps mentioned above in order to add these instructions to the processor instruction memory
  - Viewing the x10 of the register file
  - 1st location of the data memory [(data_mem_final)](../../src/data_mem_final.txt), after the process is over.

- In order test your own inputs for the factorial;
  - Replace the immediate value on line 1 in [Factorial_iterative_assembly_code](Factorial_iterative_assembly_code.txt) assembly code file.
  - Copy the assembly code into [test.asm](../test.asm) file.
  - Run [A-to-M.cpp](../A-to-M.cpp) file.
  - Copy the machine codes generated in [MCode.mc](../MCode.mc) file and paste the relevant lines of [ins_mem_init.txt](../../src/ins_mem_init.txt) file
