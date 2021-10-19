//`include "alu_definitions.sv"
//import alu_definitions::*;

module alu_op #(
    parameter DATA_WIDTH=32
) (
    input  logic [1:0] aluOp,
    input  logic [6:0] funct7, 
    input  logic [2:0] funct3,
    output logic [3:0] opSel
);

typedef enum logic [3:0] { 
    ADD, SUB,
    SLT, SLTU,
    SLL, SRL, SRA,
    AND, OR , XOR,  
    LUI, AUIPC
} alu_op;

    
typedef enum logic [1:0] { 
    i_type = 2'b11, 
    r_type = 2'b10, 
    u_type = 2'b01,
    no_op  = 2'b00
} ins_type;

logic [3:0] nextOpSel;

typedef enum logic [2:0] { //12-14 in ISA
    add_sub = 3'd0,
    sll     = 3'd1,
    slt     = 3'd2,
    sltu    = 3'd3,
    lxor     = 3'd4,
    srl_sra = 3'd5,
    lor      = 3'd6,
    land     = 3'd7
} funct3_op;

typedef enum logic [6:0] { 
    type1 = 7'd0,
    type2 = 7'd32
} funct7_op;

always_comb begin : alu_op_sel
    case (aluOp)
        i_type: begin
            case (funct3)
                add_sub : nextOpSel <= ADD;
                slt     : nextOpSel <= SLT;
                lxor     : nextOpSel <= XOR;
                lor      : nextOpSel <= OR;
                land     : nextOpSel <= AND;  

                default : nextOpSel <= ADD;              
            endcase
        end
        r_type: begin
            case (funct7)
                type1 : begin
                    case (funct3)
                        add_sub :nextOpSel <= ADD;
                        slt     :nextOpSel <= SLT;
                        sltu    :nextOpSel <= SLTU;
                        lxor    :nextOpSel <= XOR;                        
                        lor     :nextOpSel <= OR;
                        land    :nextOpSel <= AND;
                        sll     :nextOpSel <= SLL;
                        srl_sra :nextOpSel <= SRL;
                    endcase
                end
                type2 : begin
                    case (funct3)
                        add_sub :nextOpSel <= SUB;
                        srl_sra :nextOpSel <= SRA;
                    endcase
                end
                default: nextOpSel <= ADD;
            endcase
        end
        u_type : nextOpSel <= LUI;
        default : nextOpSel <= ADD;
    endcase
end

assign opSel = nextOpSel;

endmodule :alu_op