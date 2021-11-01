// `include "definitions.sv"
// import definitions::*;

// module memory
// #(
//     parameter MEM_DEPTH = 256,
//     parameter DATA_WIDTH = 32,
//     parameter LS_WIDTH = $clog2(DATA_WIDTH),
//     parameter MS_WIDTH = $clog2(MEM_DEPTH),
//     parameter ADDR_WIDTH = MS_WIDTH + LS_WIDTH  // byte addressible, one word has several bytes
    
// )
// (
//     input logic clk,
//     input mem_operation_t mem_operation,
//     input logic [ADDR_WIDTH-1:0]address,
//     input logic [DATA_WIDTH-1:0]data_in,
//     output logic [DATA_WIDTH-1:0]data_out,
//     output logic stall
// );

// logic [ADDR_WIDTH-1:0]reg_address;
// logic [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];

// always_ff @(posedge clk) begin
//     reg_address <= address;
//     if (wrEn) begin
//         memory[address] <= data_in;
//     end
// end

// assign data_out = memory[reg_address];

// endmodule : memory
