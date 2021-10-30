module ins_memory
#(
    INSTRUCTION_WIDTH = 32,
    MEMORY_DEPTH = 256,
    ADDRESS_WIDTH = $clog2(MEMORY_DEPTH)
)(
    input logic [ADDRESS_WIDTH-1:0]address,
    output logic [INSTRUCTION_WIDTH-1:0]instruction
);

logic [INSTRUCTION_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];

assign instruction = memory[address];   // asynchronously assign data in given memory address

endmodule: ins_memory