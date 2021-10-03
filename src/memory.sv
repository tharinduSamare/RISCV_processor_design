module memory 
#(
    parameter MEM_DEPTH = 256,
    parameter ADDR_WIDTH = $clog2(MEM_DEPTH),
    parameter DATA_WIDTH = 32
)
(
    input logic clk,wrEn,
    input logic [ADDR_WIDTH-1:0]address,
    input logic [DATA_WIDTH-1:0]data_in,
    output logic [DATA_WIDTH-1:0]data_out
);

logic [ADDR_WIDTH-1:0]reg_address;
logic [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];

always_ff @(posedge clk) begin
    reg_address <= address;
    if (wrEn) begin
        memory[address] <= data_in;
    end
end

assign data_out = memory[reg_address];

endmodule : memory