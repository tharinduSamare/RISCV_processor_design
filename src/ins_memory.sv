module ins_memory
#(
    INSTRUCTION_WIDTH = 32, // if address width is larger than $clog2(MEMORY_DEPTH) only consider the [$clog2(MEMORY_DEPTH-1:0] of the input address.
    MEMORY_DEPTH = 256,
    PC_WIDTH = 32
    
)(
    input logic [PC_WIDTH-1:0]address,
    output logic [INSTRUCTION_WIDTH-1:0]instruction
);

localparam ADDRESS_WIDTH = $clog2(MEMORY_DEPTH);
logic [ADDRESS_WIDTH-1:0]address_truncated;

assign address_truncated = ADDRESS_WIDTH'(address[PC_WIDTH-1:2]); // remove last 2 bits to address at 32bit level

logic [INSTRUCTION_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];


// initialize the memory
initial begin
    // $readmemh("C:\\Xilinx\\SoC_project\\src\\ins_mem_init.txt", memory);
    $readmemh("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\ins_mem_init.txt", memory);
	// $readmemh("C:\\Users\\Ravindu\\Documents\\Github\\SoC_project\\src\\ins_mem_init.txt", memory);
//    $readmemh("F:\\ads-bus\\SoC_project\\src\\ins_mem_init.txt", memory);
end

// memory read
assign instruction = memory[address_truncated];   // asynchronously assign data in given memory address

endmodule: ins_memory