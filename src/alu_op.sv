/*
This module is implemented in the EXECUTE stage 
This module takes the instruction type from the control unit
and decodes the ALU operation using funct7 and funct3 fields in the instruction
*/
module alu_op 
import  definitions::*;   
(
    input  aluOp_t aluOp,           //Input from control unit
    input  logic [6:0] funct7,      //7-bit funct7 field from instruction [25:31]
    input  logic [2:0] funct3,      //3-bit funct3 field from Instruction [12:14]
    output alu_operation_t opSel,   //ALU Operation output to ALU
    output flag_t error             //Raises Error
);

flag_t send_error;

alu_operation_t nextOpSel;

localparam logic [6:0] 
    type_0 = 7'd0,      // RISCV32I - funct7 = 000-0000
    type_1 = 7'd1,      // RISCV32M - funct7 = 000-0001
    type_32 = 7'd32;    // RISCV32I - funct7 = 010-0000

localparam logic [2:0]  // RISCV-32I alu operations
    add_sub = 3'd0,     //Add or Subtract
    sll     = 3'd1,     //Shift Left Logical
    slt     = 3'd2,     //Set Less Than
    sltu    = 3'd3,     //Set Less Than Unsigned
    lxor    = 3'd4,     //Logical XOR
    srl_sra = 3'd5,     //Shift Right Logical or Shift Right Arithmetic
    lor     = 3'd6,     //Logical OR
    land    = 3'd7;     //Logical AND

localparam logic [2:0]  //RISCV-32I M Extension : Includes multiply, divide and remained operations
    mul     = 3'd0,     //Multiply and return lower bits
    mulh    = 3'd1,     //Multiply signed and return upper bits
    mulhsu  = 3'd2,     //Multiply signed-unsigned and return upper bits
    mulhu   = 3'd3,     //Multiply unsigned and return upper bits
    div     = 3'd4,     //Signed division
    divu    = 3'd5,     //Unsigned division
    rem     = 3'd6,     //Signed remainder
    remu    = 3'd7;     //Unsigned remainder

always_comb begin : alu_op_sel
    send_error = LOW;
    case (aluOp)
        TYPE_I: begin
            case (funct7) 
                type_0 : begin 
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
                    case (funct3) 
                        // add_sub :nextOpSel = SUB;  //Uncomment to allow subi instruction
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
                // R-Type RISCV32I alu operations   
                type_0 : begin 
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
                    case (funct3) 
                        add_sub :nextOpSel = SUB;
                        srl_sra :nextOpSel = SRA;
						default : begin
                            nextOpSel = ADD;
                            send_error = HIGH;
                        end
                    endcase
                end
                // RISCV32M alu operations
                type_1: begin 
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