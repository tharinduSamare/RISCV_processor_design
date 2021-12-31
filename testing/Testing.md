# Steps to follow to Generate instructions to test processor

If you need to check custom program;

1. Obtain the assembly code of the program that you need to test.
2. Paste the assembly code into [test.asm](test.asm) file in **testing** folder.
3. Run [A-to-M.cpp](A-to-M.cpp) inside the **testing** folder, which will generate the machine code for the assembly code pasted in _test.asm_.
   - The generated machine code can be found in [MCode.mc](MCode.mc) which is also available in the **testing** folder.
4. Copy the generated machine code and replace the relevant lines in the [ins_mem_init.txt](../src/ins_mem_init.txt) file in the **src** folder.
5. Make sure the following lines after the last instruction of the generated machine codes are **_00000000_**.
6. If the program requires to load some data from the data memory make sure that the relevant data is also stored in the locations specified by you in the asembly code.
   - To add the required data you need; edit the [data_mem_init.txt](../src/data_mem_init.txt) file found in the **src** folder at the correct locations.
