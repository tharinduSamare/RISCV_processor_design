module pipelineRegister_EX_MEM 
import  definitions::*;
(
    input logic             clk,
    input logic             rstN,
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
    input regName_t         rd_EX_IN,


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
    output regName_t         rd_EX_Out

);
    always_ff @( posedge clk or negedge rstN ) begin : EX_MEM_REGISTER
        if ( ~rstN ) begin
            // from control unit
            // to memory stage
            memWrite_EX_Out         <=  '0;
            memRead_EX_Out          <=  '0;
            
            // to writeback stage
            regWrite_EX_Out         <=  '0;
            memToRegWrite_EX_Out    <=  '0;

            // other signals to mem stage
            func3_EX_Out            <=  '0;
            aluOut_EX_Out           <=  '0;

            aluSrc2_EX_Out          <=  '0;
            rd_EX_Out               <=  '0;
        end
        else begin
            // from control unit
            // to memory stage
            memWrite_EX_Out         <=  memWrite_EX_IN;
            memRead_EX_Out          <=  memRead_EX_IN;
            
            // to writeback stage
            regWrite_EX_Out         <=  regWrite_EX_IN;
            memToRegWrite_EX_Out    <=  memToRegWrite_EX_IN;

            // other signals to mem stage
            func3_EX_Out            <=  func3_EX_IN;
            aluOut_EX_Out           <=  aluOut_EX_IN;

            aluSrc2_EX_Out          <=  aluSrc2_EX_IN;
            rd_EX_Out               <=  rd_EX_IN;
        end
    end
endmodule