module pipelineRegister_MEM_WB 
import  definitions::*;
( 
    input logic             clk,
    input logic             rstN,
    // from control unit
    // to writeback stage
    input logic             regWrite_Mem_In,
    input logic             memToRegWrite_Mem_In,

    // other signals to wb stage
    input logic [31 : 0]    readD_Mem_In,
    input logic [31 : 0]    aluOut_Mem_In,
    input regName_t       rd_Mem_In,
    
    // from control unit
    // to writeback stage
    output logic             regWrite_Mem_Out,
    output logic             memToRegWrite_Mem_Out,

    // other signals to wb stage
    output logic [31 : 0]    readD_Mem_Out,
    output logic [31 : 0]    aluOut_Mem_Out,
    output regName_t       rd_Mem_Out
);

    always_ff @( posedge clk or negedge rstN ) begin : MEM_WB_REGISTER
        if (~rstN) begin
            // from control unit
            // to writeback stage
            regWrite_Mem_Out        <=  '0;
            memToRegWrite_Mem_Out   <=  '0;

            // other signals to wb stage
            readD_Mem_Out           <=  '0;
            aluOut_Mem_Out          <=  '0;
            rd_Mem_Out              <=  zero;
        end
        else begin
            // from control unit
            // to writeback stage
            regWrite_Mem_Out        <=  regWrite_Mem_In;
            memToRegWrite_Mem_Out   <=  memToRegWrite_Mem_In;

            // other signals to wb stage
            readD_Mem_Out           <=  readD_Mem_In;
            aluOut_Mem_Out          <=  aluOut_Mem_In;
            rd_Mem_Out              <=  rd_Mem_In;
        end
    end
    
endmodule