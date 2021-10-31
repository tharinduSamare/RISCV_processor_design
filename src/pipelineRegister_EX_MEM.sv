module pipilineRegister_EX_MEM (
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

    input logic [15 : 0]    aluSrc2_EX_IN,
    input logic [4 : 0]     rd_EX_IN,


    // from control unit
    // to memory stage
    input logic             memWrite_EX_Out,
    input logic             memRead_EX_Out,
    
    // to writeback stage
    input logic             regWrite_EX_Out,
    input logic             memToRegWrite_EX_Out,

    // other signals to mem stage
    input logic [2 : 0]     func3_EX_Out,
    input logic [31 : 0]    aluOut_EX_Out,

    input logic [15 : 0]    aluSrc2_EX_Out,
    input logic [4 : 0]     rd_EX_Out

);
    
endmodule