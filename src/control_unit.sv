// `include "definitions.sv"

// import definitions::*;

module control_unit(
    input logic [6:0] opCode,
    output logic jump, jumpReg, branch, memRead, memWrite, memtoReg, writeSrc, regWrite, aluSrc1,
    output logic [1:0] aluSrc2, aluOp 
);


localparam LTYPE = 7'b0000011;
localparam ITYPE = 7'b0010011;
localparam AUIPC = 7'b0010111;
localparam STYPE = 7'b0100011;
localparam RTYPE = 7'b0110011;
localparam LUI   = 7'b0110111;
localparam BTYPE = 7'b1100011;
localparam JALR  = 7'b1100111;
localparam JTYPE = 7'b1101111;

// assign opCode2 = opCode_t'(opCode);

always_comb begin : signalGenerator
    jump = '0;
    jumpReg = '0;
    branch = '0;
    aluSrc1 = '0;
    aluSrc2 = 2'b00;
    memRead = '0;
    memWrite = '0;
    memtoReg = '0;
    writeSrc = '0;
    regWrite = '0;
    aluOp = 2'b00;

    unique case (opCode)
        LTYPE : begin
            aluSrc2 = 2'b01;
            memRead  = '1;
            memtoReg = '1;
            regWrite = '1;
        end 
        ITYPE : begin
            aluSrc2 = 2'b01;
            regWrite = '1;
            aluOp = 2'b11;
        end
        AUIPC : begin
            aluSrc1 = '1;
            aluSrc2 = 2'b11;
            regWrite = '1;
        end
        STYPE : begin
            aluSrc2 = 2'b10;
            memWrite = '1;
        end
        RTYPE : begin
            regWrite = '1;
            aluOp = 2'b10;
        end
        LUI   : begin
            aluSrc1 = '1;
            regWrite = '1;
            aluOp = 2'b01;
        end
        BTYPE : begin
            branch = '1;
        end
        JALR  : begin
            jumpReg = '1;
            writeSrc = '1;
            regWrite = '1;
        end
        JTYPE : begin
            jump = '1;
            writeSrc = '1;
            regWrite = '1;
        end
        default: begin
        end 
    endcase
end
endmodule