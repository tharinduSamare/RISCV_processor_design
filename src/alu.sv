/*
This module is implemented in the EXECUTE stage
This module carries out arithmetic/logical operations
*/
module alu 
import definitions::*;
#(
    parameter DATA_WIDTH = 32
)(
    input  logic signed [DATA_WIDTH-1:0] bus_a, bus_b,
    input  alu_operation_t  opSel, 
    output logic signed [DATA_WIDTH-1:0] out,
    output flag_t overflow, Z
);

logic signed [DATA_WIDTH:0] result;     //{overflow bit, databits}

logic signed [DATA_WIDTH*2-1:0] mul_result, mul_result_su;
logic [DATA_WIDTH*2-1:0] mul_result_u;
logic signed [DATA_WIDTH-1:0] bus_b_u;

//Get multiplication results
assign bus_b_u = unsigned'(bus_b);      //Unsigned bus_b 
assign mul_result    = bus_a * bus_b;   //Multiply signed 
assign mul_result_su = bus_a * bus_b_u; //Multiply signed-unsigned
assign mul_result_u  = unsigned'(bus_a) * unsigned'(bus_b); //Multiply unsigned

always_comb begin : alu_operation
    unique case (opSel)
        //Arithmetic Operations
        ADD : result = bus_a + bus_b;
        SUB : result = bus_a - bus_b;
        //Comparison Operations (Set Less Than)
        SLTU: result = (unsigned'(bus_a) < unsigned'(bus_b)) ? 32'd1 : 32'd0;
        SLT : result = (bus_a < bus_b)? 32'd1:32'd0;
        //Shift Operations (Shift Left/Right Logical/Arithmetic)
        SLL : result = bus_a <<   unsigned'(bus_b[4:0]);
        SRL : result = bus_a >>   unsigned'(bus_b[4:0]);
        SRA : result = bus_a >>>  unsigned'(bus_b[4:0]);
        //Logical Operations
        AND : result = bus_a & bus_b; 
        OR  : result = bus_a | bus_b;
        XOR : result = bus_a ^ bus_b;
        //LUI instruction - Load Upper Immediate - ALU forwards
        FWD : result = bus_a;   

        //Multiplication
        MUL     : result = mul_result[DATA_WIDTH:0];                    //Multiply signed and return lower bits
        MULH    : result = mul_result[DATA_WIDTH*2-1:DATA_WIDTH];       //Multiply signed and return upper bits
        MULHSU  : result = mul_result_su[DATA_WIDTH*2-1:DATA_WIDTH];    //Multiply signed-unsigned and return upper bits
        MULHU   : result = mul_result_u[DATA_WIDTH*2-1:DATA_WIDTH];     //Multiply unsigned and return upper bits
        //Division
        DIV     : result = bus_a / bus_b;
        DIVU    : result = unsigned'(bus_a) / unsigned'(bus_b);
        //Remainder
        REM     : result = bus_a % bus_b;
        REMU    : result = unsigned'(bus_a) % unsigned'(bus_b);

        default : result = bus_a + bus_b;    //Default operation is to add
    endcase
end

assign out = result[DATA_WIDTH-1:0];
//Overflow flag
assign overflow = (result[DATA_WIDTH] && opSel == ADD) ? HIGH : LOW;
//Zero flag
assign Z = (result[DATA_WIDTH-1:0]==0) ? HIGH : LOW;
endmodule: alu