module(
    // from control unit
    // to execution stage
    input logic [1:0]       aluSrc1,
    input logic [1:0]       aluSrc2,
    input logic [1:0]       aluOp,

    // to memory stage
    input logic             memWrite,
    input logic             memRead,
    
    // to memory stage
    input logic             regWrite,
    input logic             memToRegWrite,


    // other signals
    input logic [7 : 0]     func7In,
    input logic [2 : 0]     func3In,
    input logic [15 : 0]    read1,
    input logic [15 : 0]    read2,
    
    input logic [31 : 0]    I_imme,
    input logic [31 : 0]    S_imme,
    input logic [31 : 0]    U_imme,

    input logic [4 : 0]     rd,
    input logic [4 : 0]     rs1,
    input logic [4 : 0]     rs2,

    
    //pipelined outputs
    //to execution stage
    output logic [1:0]      aluSrc1,
    output logic [1:0]      aluSrc2,
    output logic [1:0]      aluOp,

    
    // to memory stage
    output logic             memWrite,
    output logic             memRead,
    
    // to memory stage
    output logic             regWrite,
    output logic             memToRegWrite,

    // other signals
    output logic [7 : 0]    func7In,
    output logic [2 : 0]    func3In,
    output logic [15 : 0]   read1,
    output logic [15 : 0]   read2,
    
    output logic [31 : 0] I_imme,
    output logic [31 : 0] S_imme,
    output logic [31 : 0] U_imme,

    output logic [4 : 0] rd,
    output logic [4 : 0] rs1,
    output logic [4 : 0] rs2
);

endmodule