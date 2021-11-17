module alu_op 
import  alu_definitions::*,
		definitions::*;   
(
    input  aluOp_t aluOp,
    input  logic [6:0] funct7, 
    input  logic [2:0] funct3,
    output operation_t opSel,
    output flag_t error
);

flag_t send_error;

operation_t nextOpSel;

typedef enum logic [2:0] { //12-14 in ISA
    add_sub = 3'd0,
    sll     = 3'd1,
    slt     = 3'd2,
    sltu    = 3'd3,
    lxor    = 3'd4,
    srl_sra = 3'd5,
    lor     = 3'd6,
    land    = 3'd7
} funct3_op;

typedef enum logic [6:0] { 
    type1 = 7'd0,
    type2 = 7'd32
} funct7_op;

always_comb begin : alu_op_sel
    send_error = LOW;
    case (aluOp)
        TYPE_I: begin
            case (funct3)
                add_sub : nextOpSel = ADD;
                slt     : nextOpSel = SLT;
                lxor    : nextOpSel = XOR;
                lor     : nextOpSel = OR;
                land    : nextOpSel = AND;  
                default : begin
                    nextOpSel = ADD;
                    send_error = HIGH;
                end
            endcase
        end
        TYPE_R: begin
            case (funct7)
                type1 : begin
                    case (funct3)
                        add_sub :nextOpSel = ADD;
                        slt     :nextOpSel = SLT;
                        sltu    :nextOpSel = SLTU;
                        lxor    :nextOpSel = XOR;                        
                        lor     :nextOpSel = OR;
                        land    :nextOpSel = AND;
                        sll     :nextOpSel = SLL;
                        srl_sra :nextOpSel = SRL;
                    endcase
                end
                type2 : begin
                    case (funct3)
                        add_sub :nextOpSel = SUB;
                        srl_sra :nextOpSel = SRA;
						default : begin
                            nextOpSel = ADD;
                            send_error = HIGH;
                        end
                    endcase
                end
                default: begin
                    nextOpSel = ADD;
                    send_error = HIGH;
                end
            endcase
        end
        DEF_ADD : nextOpSel = ADD;
        PASS_S1 : nextOpSel = FWD;
    endcase
end

assign opSel = nextOpSel;
assign error = send_error;

endmodule :alu_op