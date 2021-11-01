module ins_memory
#(
    INSTRUCTION_WIDTH = 32,
    MEMORY_DEPTH = 256,
    PC_WIDTH = 32
    
)(
    input logic [PC_WIDTH-1:0]address,
    output logic [INSTRUCTION_WIDTH-1:0]instruction
);

localparam ADDRESS_WIDTH = $clog2(MEMORY_DEPTH);
logic [ADDRESS_WIDTH-1:0]address_truncated;

assign address_truncated = (PC_WIDTH>ADDRESS_WIDTH)? {'0,address} : address[ADDRESS_WIDTH-1:0];

logic [INSTRUCTION_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];

assign instruction = memory[address_truncated];   // asynchronously assign data in given memory address

endmodule: ins_memory