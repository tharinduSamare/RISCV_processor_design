module pipelineRegister_ID_EX
import  definitions::*;
(  
    input logic             clk,
    input logic             rstN,
    // from control unit
    // to execution stage

    input logic [31:0]      pcIn,
    input alu_sel1_t         aluSrc1_IDIn,
    input alu_sel2_t         aluSrc2_IDIn,
    input aluOp_t           aluOp_IDIn,

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

    input regName_t         rd_IDIn,
    input regName_t         rs1_IDIn,
    input regName_t         rs2_IDIn,

    
    //pipelined outputs
    //to execution stage
    output logic [31:0]     pcOut,
    output alu_sel1_t               aluSrc1_IDOut,
    output alu_sel2_t               aluSrc2_IDOut,
    output aluOp_t                 aluOp_IDOut,

    
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
    
    output logic [31 : 0]   I_imme_IDOut,
    output logic [31 : 0]   S_imme_IDOut,
    output logic [31 : 0]   U_imme_IDOut,

    output regName_t        rd_IDOut,
    output regName_t        rs1_IDOut,
    output regName_t        rs2_IDOut
);

    always_ff @( posedge clk or negedge rstN) begin : ID_EX_REGISTER
        if (~rstN) begin
            //  pipelined outputs
            //  to execution stage
            pcOut                   <= '0;
            aluSrc1_IDOut           <=  MUX_FORWARD1; 
            aluSrc2_IDOut           <=  MUX_FORWARD2;
            aluOp_IDOut             <=  DEF_ADD;  


            
            // to memory stage
            memWrite_IDOut          <=  '0;
            memRead_IDOut           <=  '0;
            
            // to writeback stage
            regWrite_IDOut          <=  '0;
            memToRegWrite_IDOut     <=  '0;

            // other signals to exe stage
            func7_IDOut             <=  '0; 
            func3_IDOut             <=  '0;
            read1_IDOut             <=  '0;
            read2_IDOut             <=  '0;
            
            I_imme_IDOut            <=  '0;
            S_imme_IDOut            <=  '0;
            U_imme_IDOut            <=  '0;

            rd_IDOut                <=  zero;
            rs1_IDOut               <=  zero;
            rs2_IDOut               <=  zero;  
        end
        else begin    
            //  pipelined outputs
            //  to execution stage
            pcOut                   <=  pcIn;   
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
    end
    
endmodule