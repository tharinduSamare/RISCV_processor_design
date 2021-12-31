module alu_op 
import  definitions::*;   
(
    input  aluOp_t aluOp,
    input  logic [6:0] funct7, 
    input  logic [2:0] funct3,
    output alu_operation_t opSel,
    output flag_t error
);

flag_t send_error;

alu_operation_t nextOpSel;

localparam logic [6:0] 
    type_0 = 7'd0,  // RISCV32I 
    type_1 = 7'd1,  // RISCV32M
    type_32 = 7'd32; // RISCV32I

localparam logic [2:0]  // RISCV-32I alu operations
    add_sub = 3'd0,
    sll     = 3'd1,
    slt     = 3'd2,
    sltu    = 3'd3,
    lxor    = 3'd4,
    srl_sra = 3'd5,
    lor     = 3'd6,
    land    = 3'd7;

localparam logic [2:0]
    mul     = 3'd0,
    mulh    = 3'd1,
    mulhsu  = 3'd2,
    mulhu   = 3'd3,
    div     = 3'd4,
    divu    = 3'd5,
    rem     = 3'd6,
    remu    = 3'd7;

// typedef enum logic [2:0] { //12-14 in ISA
//     add_sub = 3'd0,
//     sll     = 3'd1,
//     slt     = 3'd2,
//     sltu    = 3'd3,
//     lxor    = 3'd4,
//     srl_sra = 3'd5,
//     lor     = 3'd6,
//     land    = 3'd7
// } funct3_op;

// typedef enum logic [6:0] { 
//     type_0 = 7'd0,
//     type_1 = 7'd1,
//     type_32 = 7'd32
// } funct7_op;

always_comb begin : alu_op_sel
    send_error = LOW;
    case (aluOp)
        TYPE_I: begin
            case (funct7)  
                type_0 : begin // RISCV32I alu operations
                    case (funct3)
                        add_sub : nextOpSel = ADD;
                        slt     : nextOpSel = SLT;
                        lxor    : nextOpSel = XOR;
                        lor     : nextOpSel = OR;
                        land    : nextOpSel = AND; 
                        sll     : nextOpSel = SLL;
                        srl_sra : nextOpSel = SRL; 
                        default : begin
                            nextOpSel = ADD;
                            send_error = HIGH;
                        end
                    endcase
                end
                type_32 : begin
                    case (funct3) // RISCV32I alu operations
                        // add_sub :nextOpSel = SUB;
                        srl_sra : nextOpSel = SRA;
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
        TYPE_R: begin
            case (funct7)  
                type_0 : begin // RISCV32I alu operations
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
                type_32 : begin
                    case (funct3) // RISCV32I alu operations
                        add_sub :nextOpSel = SUB;
                        srl_sra :nextOpSel = SRA;
						default : begin
                            nextOpSel = ADD;
                            send_error = HIGH;
                        end
                    endcase
                end
                type_1: begin // RISCV32M alu operations
                    case (funct3)
                        mul    :nextOpSel = MUL;
                        mulh   :nextOpSel = MULH;
                        mulhsu :nextOpSel = MULHSU;
                        mulhu  :nextOpSel = MULHU;
                        div    :nextOpSel = DIV;
                        divu   :nextOpSel = DIVU;
                        rem    :nextOpSel = REM;
                        remu   :nextOpSel = REMU;
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