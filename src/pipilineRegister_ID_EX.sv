module pipilineRegister_ID_EX(
    input logic             clk,
    // from control unit
    // to execution stage

    input logic [31:0]      pcIn,
    input logic [1:0]       aluSrc1_IDIn,
    input logic [1:0]       aluSrc2_IDIn,
    input logic [1:0]       aluOp_IDIn,

    // to memory stage
    input logic             memWrite_IDIn,
    input logic             memRead_IDIn,
    
    // to writeback stage
    input logic             regWrite_IDIn,
    input logic             memToRegWrite_IDIn,


    // other signals to exe stage
    input logic [6 : 0]     func7_IDIn,
    input logic [2 : 0]     func3_IDIn,
    input logic [31 : 0]    read1_IDIn,
    input logic [31 : 0]    read2_IDIn,
    
    input logic [31 : 0]    I_imme_IDIn,
    input logic [31 : 0]    S_imme_IDIn,
    input logic [31 : 0]    U_imme_IDIn,

    input logic [4 : 0]     rd_IDIn,
    input logic [4 : 0]     rs1_IDIn,
    input logic [4 : 0]     rs2_IDIn,

    
    //pipelined outputs
    //to execution stage
    output logic [31:0] pcOut,
    output logic [1:0]      aluSrc1_IDOut,
    output logic [1:0]      aluSrc2_IDOut,
    output logic [1:0]      aluOp_IDOut,

    
    // to memory stage
    output logic             memWrite_IDOut,
    output logic             memRead_IDOut,
    
    // to writeback stage
    output logic             regWrite_IDOut,
    output logic             memToRegWrite_IDOut,

    // other signals to exe stage
    output logic [6 : 0]    func7_IDOut,
    output logic [2 : 0]    func3_IDOut,
    output logic [31 : 0]   read1_IDOut,
    output logic [31 : 0]   read2_IDOut,
    
    output logic [31 : 0] I_imme_IDOut,
    output logic [31 : 0] S_imme_IDOut,
    output logic [31 : 0] U_imme_IDOut,

    output logic [4 : 0] rd_IDOut,
    output logic [4 : 0] rs1_IDOut,
    output logic [4 : 0] rs2_IDOut
);

endmodule