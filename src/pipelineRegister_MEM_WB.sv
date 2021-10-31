module pipelineRegister_MEM_WB (
    input logic             clk,
    // from control unit
    // to writeback stage
    input logic             regWrite_Mem_In,
    input logic             memToRegWrite_Mem_In,

    // other signals to wb stage
    input logic [31 : 0]    readD_Mem_In,
    input logic [31 : 0]    aluOut_Mem_In,
    input logic [4:0]       rd_Mem_In,
    
    // from control unit
    // to writeback stage
    output logic             regWrite_Mem_Out,
    output logic             memToRegWrite_Mem_Out,

    // other signals to wb stage
    output logic [31 : 0]    readD_Mem_Out,
    output logic [31 : 0]    aluOut_Mem_Out,
    output logic [4:0]       rd_Mem_Out
);
    
endmodule