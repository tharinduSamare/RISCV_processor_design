# Steps to follow to Generate instructions to test the processor

If you need to check custom program;

1. Obtain the assembly code of the program that you need to test.
2. Paste the assembly code into [test.asm](test.asm) file in **testing** folder.
3. Run [A-to-M.cpp](A-to-M.cpp) inside the **testing** folder, which will generate the machine code for the assembly code pasted in _test.asm_.
   - The generated machine code can be found in [MCode.mc](MCode.mc) which is also available in the **testing** folder.
4. Copy the generated machine code and replace the relevant lines in the [ins_mem_init.txt](../src/ins_mem_init.txt) file in the **src** folder.
5. Make sure the following lines after the last instruction of the generated machine codes are **_00000000_**.
6. If the program requires to load some data from the data memory make sure that the relevant data is also stored in the locations specified by you in the asembly code.
   - To add the required data you need; edit the [data_mem_init.txt](../src/data_mem_init.txt) file found in the **src** folder at the correct locations.

# Testing the programs provided in the Testing folder

## Factorial Iterative

- The relevant assembly code for this program is provided in [Factorial_iterative_assembly_code](Factorial_iterative/Factorial_iterative_assembly_code.txt) text file.

- The machine code generated for this assembly code is avaiable in the in the [Factorial_iterative_machine_code](Factorial_iterative/Factorial_iterative_machine_code.txt) text file.

- The expected instruction memory for this program is shown in [Factorial_iterative_instruction_memory](Factorial_iterative/Factorial_iterative_instruction_memory.txt) text file.

- The result of the factorial can be checked by;

  - Follow the steps mentioned above in order to add these instructions to the processor instruction memory
  - Viewing the x3 of the register file
  - 1st location of the data memory [(data_mem_final)](../src/data_mem_final.txt), after the process is over.

- In order test your own inputs for the factorial;
  - Replace the immediate value on line 3 in [Factorial_iterative_assembly_code](Factorial_iterative/Factorial_iterative_assembly_code.txt) assembly code file.
  - Copy the assembly code into [test.asm](test.asm) file.
  - Run [A-to-M.cpp](A-to-M.cpp) file.
  - Copy the machine codes generated in [MCode.mc](MCode.mc) file and paste the relevant lines of [ins_mem_init.txt](../src/ins_mem_init.txt) file

---

## Factorial Recursive

- The relevant assembly code for this program is provided in [Factorial_Recursive_assembly_code](Factorial_Recursive/Factorial_Recursive_assembly_code.txt) text file.

- The machine code generated for this assembly code is avaiable in the in the [Factorial_Recursive_machine_code](Factorial_Recursive/Factorial_Recursive_machine_code.txt) text file.

- The expected instruction memory for this program is shown in [Factorial_Recursive_instruction_memory](Factorial_Recursive/Factorial_Recursive_instruction_memory.txt) text file.

- The result of the factorial can be checked by;

  - Follow the steps mentioned above in order to add these instructions to the processor instruction memory
  - Viewing the x10 of the register file
  - 1st location of the data memory [(data_mem_final)](../src/data_mem_final.txt), after the process is over.

- In order test your own inputs for the factorial;
  - Replace the immediate value on line 1 in [Factorial_iterative_assembly_code](Factorial_Recursive/Factorial_iterative_assembly_code.txt) assembly code file.
  - Copy the assembly code into [test.asm](test.asm) file.
  - Run [A-to-M.cpp](A-to-M.cpp) file.
  - Copy the machine codes generated in [MCode.mc](MCode.mc) file and paste the relevant lines of [ins_mem_init.txt](../src/ins_mem_init.txt) file

---

## Fibonacci Iterative

- The relevant assembly code for this program is provided in [Fibonacci_Iterative_assembly_code](Finonacci_iterative/Fibonacci_Iterative_assembly_code.txt) text file.

- The machine code generated for this assembly code is avaiable in the in the [Fibonacci_iterative_machine_code](Finonacci_iterative/Fibonacci_iterative_machine_code.txt) text file.

- The expected instruction memory for this program is shown in [Fibonacci_iterative_instruction_memory](Finonacci_iterative/Fibonacci_iterative_instruction_memory.txt) text file.

- The result of the factorial can be checked by;

  - Follow the steps mentioned above in order to add these instructions to the processor instruction memory
  - Viewing the x7 of the register file
  - 1st location of the data memory [(data_mem_final)](../src/data_mem_final.txt), after the process is over.

- In order test your own inputs for the factorial;
  - Replace the immediate value on line 5 in [Fibonacci_Recursive_assembly_code](Finonacci_iterative/Fibonacci_Recursive_assembly_code.txt) assembly code file.
  - Copy the assembly code into [test.asm](test.asm) file.
  - Run [A-to-M.cpp](A-to-M.cpp) file.
  - Copy the machine codes generated in [MCode.mc](MCode.mc) file and paste the relevant lines of [ins_mem_init.txt](../src/ins_mem_init.txt) file

---

## Fibonacci Recursive

- The relevant assembly code for this program is provided in [Fibonacci_Recursive_assembly_code](Fibonacci_Recursive/Fibonacci_Recursive_assembly_code.txt) text file.

- The machine code generated for this assembly code is avaiable in the in the [Fibonacci_Recursive_machine_code](Fibonacci_Recursive/Fibonacci_Recursive_machine_code.txt) text file.

- The expected instruction memory for this program is shown in [Fibonacci_Recursive_instruction_memory](Fibonacci_Recursive/Fibonacci_Recursive_instruction_memory.txt) text file.

- The result of the factorial can be checked by;

  - Follow the steps mentioned above in order to add these instructions to the processor instruction memory
  - Viewing the x6 of the register file
  - 1st location of the data memory [(data_mem_final)](../src/data_mem_final.txt), after the process is over.

- In order test your own inputs for the factorial;
  - Replace the immediate value on line 1 in [Fibonacci_Recursive_assembly_code](Fibonacci_Recursive/Fibonacci_Recursive_assembly_code.txt) assembly code file.
  - Copy the assembly code into [test.asm](test.asm) file.
  - Run [A-to-M.cpp](A-to-M.cpp) file.
  - Copy the machine codes generated in [MCode.mc](MCode.mc) file and paste the relevant lines of [ins_mem_init.txt](../src/ins_mem_init.txt) file
