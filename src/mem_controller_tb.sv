// module mem_controller_tb();

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

// localparam [3:0]
//     LB  = 3'b000,
//     LH  = 3'b001,
//     LW  = 3'b010,
//     LBU = 3'b100,
//     LHU = 3'b101,
//     SB  = 3'b000,
//     SH  = 3'b001,
//     SW  = 3'b010;

// localparam MEMORY_DEPTH = 4096;
// localparam ADDRESS_WIDTH = 32;
// localparam DATA_WIDTH = 32;

// logic write_En,read_En;
// logic [2:0]func3;
// logic [ADDRESS_WIDTH-1:0]address;
// logic [DATA_WIDTH-1:0]data_in;
// logic [DATA_WIDTH-1:0]data_out;
// logic ready;

// dut #(.MEMORY_DEPTH(MEMORY_DEPTH), .ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH)) mem_controller(.*);

// initial begin
    
// end



// endmodule : mem_controller_tb