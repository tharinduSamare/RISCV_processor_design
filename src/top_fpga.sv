/* the top module of the entire pipeline processor*/
module top_fpga #(
    parameter IM_MEM_DEPTH = 8,
    parameter DM_MEM_DEPTH = 4096
)(
    input logic CLOCK_50,
    input logic [1:0]KEY,
    output logic [1:0]LEDG
    // input logic clk, rstN, startProcess,
    // output logic endProcess
);

localparam INSTRUCTION_WIDTH = 32;
localparam DATA_WIDTH = 32;
localparam FUNC3_WIDTH = 3;
localparam DM_ADDRESS_WIDTH = 32;


logic clk, rstN, startProcess, endProcess;

assign clk = CLOCK_50;
assign startProcess = ~KEY[1];
assign rstN = KEY[0];
assign LEDG[0] = ~endProcess;
assign LEDG[1] = endProcess;


///// IRAM /////
logic [INSTRUCTION_WIDTH-1:0] instructionIF;
logic [INSTRUCTION_WIDTH-1:0] pcIF;

ins_memory #(
    .INSTRUCTION_WIDTH (INSTRUCTION_WIDTH),
    .MEMORY_DEPTH (IM_MEM_DEPTH)
) IRAM (
    .address(pcIF),

    .instruction(instructionIF)
);


////// Data Memory /////
logic memReadMeM, memWriteMeM; 
logic [FUNC3_WIDTH-1:0] func3MeM;
logic [DATA_WIDTH-1:0] aluOutMeM;
logic [DATA_WIDTH-1:0] rs2DataMeM;

logic [DATA_WIDTH-1:0] dMOutMem;
logic dMReadyMem;

mem_controller #(
    .MEMORY_DEPTH(DM_MEM_DEPTH),
    .ADDRESS_WIDTH(DM_ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) DRAM (
    .clk,
    .rstN,

    .write_En(memWriteMeM),
    .read_En(memReadMeM),
    .func3_in(func3MeM),
    .address(aluOutMeM),
    .data_in(rs2DataMeM),
    .process_done(endProcess),

    .data_out(dMOutMem),
    .ready(dMReadyMem)
);

////// Processor ////////////
processor #(
    .IM_MEM_DEPTH(IM_MEM_DEPTH),
    .DM_MEM_DEPTH(DM_MEM_DEPTH),
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
    .FUNC3_WIDTH(FUNC3_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) CPU (
    .*
);

endmodule: top_fpga