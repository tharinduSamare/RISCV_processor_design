//`include "alu_definitions.sv"
//import alu_definitions::*;

module alu #(
    parameter DATA_WIDTH = 32
)(
    input  [DATA_WIDTH-1:0] bus_a, bus_b,
    input  logic [3:0] opSel, 
    output logic [DATA_WIDTH-1:0] out,
    output logic overflow, Z
);

/*
EXT imm ---|\_ bus_b
REG rs1 ---|/
*/
typedef enum logic [3:0] { 
    ADD, SUB,
    SLT, SLTU,
    SLL, SRL, SRA,
    AND, OR , XOR,  
    LUI
} alu_op;

logic [DATA_WIDTH:0] result;
wire  [DATA_WIDTH-1:0] sub_res = bus_a - bus_b;
// logic [DATA_WIDTH-1:0] nextOut;
// logic nextCarry;

always_comb begin : alu_operation
    case (opSel)
        //Arithmetic Operations
        ADD : result <= bus_a + bus_b;
        SUB : result <= sub_res;
        //Comparison Operations
        SLTU: result <= (bus_a < bus_b) ? 32'd0 : 32'd1;
        SLT : begin
            if (bus_a[DATA_WIDTH-1] == bus_b[DATA_WIDTH-1])  result <= (bus_a < bus_b) ? 32'd0 : 32'd1;
            else result <= (sub_res[DATA_WIDTH-1]) ? 32'd1 : 32'd0;
        end
        //Shift Operations
        SLL : result <= bus_a <<   bus_b;
        SRL : result <= bus_a >>   bus_b;
        SRA : result <= bus_a >>>  bus_b;
        //Logical Operations
        AND : result <= bus_a & bus_b; 
        OR  : result <= bus_a | bus_b;
        XOR : result <= bus_a ^ bus_b;     
        default: result <= bus_a;
    endcase
end

assign out = result[DATA_WIDTH-1:0];
assign overflow = (result[DATA_WIDTH]) ? 1'b1 : 1'b0;
assign Z = (result[DATA_WIDTH-1:0]==0) ? 1'b1 : 1'b0;
endmodule: alu