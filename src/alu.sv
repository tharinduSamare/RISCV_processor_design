`include "alu_definitions.sv"
import alu_definitions::*;

module alu #(
    parameter DATA_WIDTH = 32
)(
    input  [15:0] bus_a, bus_b,
    input logic [1:0] opSel, 
    output logic [DATA_WIDTH-1:0] out,
    output logic overflow, Z
)

/*
EXT imm ---|\_ bus_b
REG rs1 ---|/
*/

logic [15:0] nextOut;
logic [11:0] carry;

always_comb begin : alu_operation
    case (opSel)
        //Arithmetic Operations
        ADD : {carry, nextOut} <= bus_a + bus_b;
        SUB : {carry, nextOut} <= bus_a - bus_b;
        //Comparison Operations
        LTU : nextOut <= (unsigned(bus_a) < unsigned(bus_b)) ? 16'd0 : 16'd1;
        //Shift Operations
        SLL : nextOut <= bus_a <<   bus_b;
        SRL : nextOut <= bus_a >>   bus_b;
        SRA : nextOut <= bus_a >>>  bus_b;
        //Logical Operations
        AND : {carry, nextOut} <= bus_a & bus_b; 
        OR  : {carry, nextOut} <= bus_a | bus_b;
        XOR : {carry, nextOut} <= bus_a ^ bus_b;
        //Special Computation Operations
        LUI : nextOut <= bus_b[19:0] + 4'h0;
        // AUIPC
        default: nextOut <= bus_a;
    endcase
end

assign out = nextOut;
assign overflow = (carry) ? 1'b1 : 1'b0;
assign Z = (nextOut==0) ? 1'b1 : 1'b0;