// `include "definitions.sv"

module control_unit import definitions::*;(
    input logic [6:0] opCode, 
    input logic enable, 
    
    output logic error,
    output logic endProcess,

    output logic jump, jumpReg, branch, memRead, memWrite, memtoReg, regWrite,
    output alu_sel1_t aluSrc1,
    output alu_sel2_t aluSrc2,
    output aluOp_t aluOp
     
);

opCode_t opCodeEnum;

always_comb begin
    case (opCode)
        7'b0000011 : opCodeEnum = LTYPE; 
        7'b0010011 : opCodeEnum = ITYPE; 
        7'b0010111 : opCodeEnum = AUIPC; 
        7'b0100011 : opCodeEnum = STYPE; 
        7'b0110011 : opCodeEnum = RTYPE; 
        7'b0110111 : opCodeEnum = LUI  ; 
        7'b1100011 : opCodeEnum = BTYPE; 
        7'b1100111 : opCodeEnum = JALR ; 
        7'b1101111 : opCodeEnum = JTYPE;
         default:    opCodeEnum = ERROR;
    endcase
end
// opCode |jump|jumpReg|branch|memRead|memWrite|memtoReg|regWrite|aluSrc1|aluSrc2|aluOp|
// 
// LTYPE  | 0  |  0    |  0   |   1   |   0    |    1   |   1    |  00   |  01   | 00  |
// rd <- mem(32'(rs1+imm_i)) 
// ITYPE  | 0  |  0    |  0   |   0   |   0    |    0   |   1    |  00   |  01   | 10  |
// rd <- rs1 + imm_i
// AUIPC  | 0  |  0    |  0   |   0   |   0    |    0   |   1    |  01   |  11   | 00  | 
// rd <- imm_u + pc
// STYPE  | 0  |  0    |  0   |   0   |   1    |    0   |   0    |  00   |  10   | 00  |
// mem(rs1+imm_s) <- rs2[31:0]
// RTYPE  | 0  |  0    |  0   |   0   |   0    |    0   |   1    |  00   |  00   | 11  |
// rd <- rs1 + rs2
// LUI    | 0  |  0    |  0   |   0   |   0    |    0   |   1    |  01   |  00   | 01  |
// rd <- imm u
// BTYPE  | 0  |  0    |  1   |   0   |   0    |    0   |   0    |  00   |  00   | 00  | 
// pc <- pc + ((rs1==rs2) ? imm_b : 4)
// JALR   | 0  |  1    |  0   |   0   |   0    |    0   |   1    |  10   |  11   | 00  |
// rd <- 4 + pc, pc <- (rs1+imm_i)&~1 
// JTYPE  | 1  |  0    |  0   |   0   |   0    |    0   |   1    |  10   |  11   | 00  |
// rd <- 4 + pc, pc <- pc+imm_j

always_comb begin : signalGenerator
    jump = '0;
    jumpReg = '0;
    branch = '0;
    aluSrc1 = MUX_FORWARD1;  //2'b00;
    aluSrc2 = MUX_FORWARD2; //2'b00;
    memRead = '0;
    memtoReg = '0;
    regWrite = '0;
    aluOp = DEF_ADD; //2'b00;
    error = '0;
    endProcess = '0;

    if (!(enable)) memWrite = '0;
    else begin
    memWrite = '0;   
    case (opCodeEnum)
        LTYPE : begin
            aluSrc2 = MUX_ITYPE; //2'b01;
            memRead  = '1;
            memtoReg = '1;
            regWrite = '1;
        end 
        ITYPE : begin
            aluSrc2 = MUX_ITYPE; //2'b01;
            regWrite = '1;
            aluOp = TYPE_I; //2'b10;
        end
        AUIPC : begin
            aluSrc1 = MUX_UTYPE; //2'b01;
            aluSrc2 = MUX_PC; //2'b11;
            regWrite = '1;
        end
        STYPE : begin
            aluSrc2 = MUX_STYPE; //2'b10;
            memWrite = '1;
        end
        RTYPE : begin
            regWrite = '1;      
            aluOp = TYPE_R; //2'b11;
        end
        LUI   : begin
            aluSrc1 = MUX_UTYPE; //2'b01;
            regWrite = '1;
            aluOp = PASS_S1; //2'b01;
        end
        BTYPE : begin
            branch = '1;
        end
        JALR  : begin
            jumpReg = '1;
            aluSrc1 = MUX_INC; //2'b10;
            aluSrc2 = MUX_PC; //2'b11;
            regWrite = '1;
        end
        JTYPE : begin
            jump = '1;
            aluSrc1 = MUX_INC; //2'b10;
            aluSrc2 = MUX_PC; //2'b11;
            regWrite = '1;
        end
        ERROR : begin 
            error = '1;
            endProcess = '1;
        end
        default: begin
        end 
    endcase
    end
end
endmodule : control_unit