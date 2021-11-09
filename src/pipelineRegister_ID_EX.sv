<<<<<<< HEAD:src/pipilineRegister_ID_EX.sv
<<<<<<< HEAD
module pipilineRegister_ID_EX(
=======
module pipelineRegister_ID_EX(  
>>>>>>> 2fd7694 (added complete top module):src/pipelineRegister_ID_EX.sv
    input logic             clk,
    // from control unit
    // to execution stage

    input logic [31:0]      pcIn,
=======
module pipilineRegister_ID_EX(  
    input logic             clk,
    // from control unit
    // to execution stage
>>>>>>> f6aaff5 (Add removed pipeline registers)
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
<<<<<<< HEAD
    output logic [31:0] pcOut,
    output logic [1:0]      aluSrc1_IDOut,
=======
    output logic [1:0]      aluSrc_ID1Out,
>>>>>>> f6aaff5 (Add removed pipeline registers)
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

    always_ff @( posedge clk ) begin : ID_EX_REGISTER
        //pipelined outputs
        //to execution stage
        aluSrc1_IDOut           <=  aluSrc1_IDIn;
        aluSrc2_IDOut           <=  aluSrc2_IDIn;
        aluOp_IDOut             <=  aluOp_IDIn;

        
        // to memory stage
        memWrite_IDOut          <=  memWrite_IDIn;
        memRead_IDOut           <=  memRead_IDIn;
        
        // to writeback stage
        regWrite_IDOut          <=  regWrite_IDIn;
        memToRegWrite_IDOut     <=  memToRegWrite_IDIn;

        // other signals to exe stage
        func7_IDOut             <=  func7_IDIn; 
        func3_IDOut             <=  func3_IDIn;
        read1_IDOut             <=  read1_IDIn;
        read2_IDOut             <=  read2_IDIn;
        
        I_imme_IDOut            <=  I_imme_IDIn;
        S_imme_IDOut            <=  S_imme_IDIn;
        U_imme_IDOut            <=  U_imme_IDIn;

        rd_IDOut                <=  rd_IDIn;
        rs1_IDOut               <=  rs1_IDIn;
        rs2_IDOut               <=  rs2_IDIn;      
    end
    
endmodule