// module L1_cache_tb import definitions::*;
// ();

// timeunit 1ns;
// timeprecision 1ns;

// localparam CLK_PERIOD = 20;  // set to the correct value of the FPGA board

// logic clk;
// initial begin
//     clk = 1'b0;
//     forever begin
//         #(CLK_PERIOD/2);
//         clk = ~clk;
//     end
// end

// localparam WORD_LENGTH = 4;  // length of a register in bytes (32 bit -> 4  64 bit -> 8)
// localparam CACHE_WIDTH = 4;  // number of words in a row
// localparam DEPTH = 256; //number of rows 
// localparam ADDRESS_WIDTH = $clog2(DEPTH * CACHE_WIDTH * WORD_LENGTH);// byte addressable

// mem_operation_t mem_operation;
// logic [ADDRESS_WIDTH-1:0]address;
// logic [WORD_LENGTH*8-1:0]data_in;
// logic [WORD_LENGTH*8-1:0]data_out;
// logic stall;

// L1_cache #(.WORD_LENGTH(WORD_LENGTH), .CACHE_WIDTH(CACHE_WIDTH), .DEPTH(DEPTH), .ADDRESS_WIDTH(ADDRESS_WIDTH)) dut (.*);


// initial begin
//     @(posedge clk);
//     $stop;
// end

// endmodule : L1_cache_tb