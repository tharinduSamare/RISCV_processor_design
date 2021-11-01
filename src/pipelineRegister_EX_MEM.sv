module pipelineRegister_EX_MEM (
    input logic             clk,
    // from control unit
    // to memory stage
    input logic             memWrite_EX_IN,
    input logic             memRead_EX_IN,
    
    // to writeback stage
    input logic             regWrite_EX_IN,
    input logic             memToRegWrite_EX_IN,

    // other signals to mem stage
    input logic [2 : 0]     func3_EX_IN,
    input logic [31 : 0]    aluOut_EX_IN,

    input logic [31 : 0]    aluSrc2_EX_IN,
    input logic [4 : 0]     rd_EX_IN,


    // from control unit
    // to memory stage
    output logic             memWrite_EX_Out,
    output logic             memRead_EX_Out,
    
    // to writeback stage
    output logic             regWrite_EX_Out,
    output logic             memToRegWrite_EX_Out,

    // other signals to mem stage
    output logic [2 : 0]     func3_EX_Out,
    output logic [31 : 0]    aluOut_EX_Out,

    output logic [31 : 0]    aluSrc2_EX_Out,
    output logic [4 : 0]     rd_EX_Out

);
    always_ff @( posedge clk ) begin : blockName
        
    end
endmodule