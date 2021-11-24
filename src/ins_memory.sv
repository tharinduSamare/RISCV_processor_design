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

// assign address_truncated = (PC_WIDTH<ADDRESS_WIDTH)? {'0,address} : address[ADDRESS_WIDTH-1:0];
assign address_truncated = ADDRESS_WIDTH'(address);

logic [INSTRUCTION_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];

initial begin
    $readmemh("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\ins_mem_init.txt", memory);
end

assign instruction = memory[address_truncated];   // asynchronously assign data in given memory address

endmodule: ins_memory