module data_memory
#(
    DATA_WIDTH = 32,
    MEMORY_DEPTH = 4096,
    ADDRESS_WIDTH =30
)
(
    input logic clk, read_En, write_En,
    input logic [ADDRESS_WIDTH-1:0]address,
    input logic [DATA_WIDTH-1:0]data_in,
    input logic process_done,

    output logic [DATA_WIDTH-1:0]data_out
);

logic [DATA_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];

// memory initialization
initial begin
    // $readmemh("C:\\Xilinx\\SoC_project\\src\\data_mem_init.txt", memory);
    // $readmemh("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\data_mem_init.txt", memory);
	//  $readmemh("C:\\Users\\Ravindu\\Documents\\Github\\SoC_project\\src\\ins_mem_init.txt", memory);
    $readmemh("F:\\ads-bus\\SoC_project\\src\\data_mem_init.txt", memory);
end

always_ff @(posedge clk) begin
    if (write_En) begin
        memory[address] <= data_in;  // memory write 
    end
    else if (read_En) begin
        data_out <= memory[address]; // memory read
    end
end

// write the final memory content to a text file
always_ff @( posedge clk ) begin 
    if (process_done) ;
        // $writememh("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\data_mem_final.txt", memory);
        // $writememh("C:\\Xilinx\\SoC_project\\src\\data_mem_final.txt", memory);
        // $writememh("F:\\ads-bus\\SoC_project\\src\\data_mem_init.txt", memory);
end

endmodule :data_memory