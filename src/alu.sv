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

logic signed [DATA_WIDTH:0] result;
// logic [DATA_WIDTH-1:0] sub_res

logic [DATA_WIDTH*2-1:0] mul_result;
assign mul_result = bus_a * bus_b;

always_comb begin : alu_operation
    unique case (opSel)
        //Arithmetic Operations
        ADD : result = bus_a + bus_b;
        SUB : result = bus_a - bus_b;
        //Comparison Operations
        SLTU: result = (unsigned'(bus_a) < unsigned'(bus_b)) ? 32'd1 : 32'd0;
        SLT : result = (bus_a < bus_b)? 32'd1:32'd0;
        //Shift Operations
        SLL : result = bus_a <<   unsigned'(bus_b[4:0]);
        SRL : result = bus_a >>   unsigned'(bus_b[4:0]);
        SRA : result = bus_a >>>  unsigned'(bus_b[4:0]);
        //Logical Operations
        AND : result = bus_a & bus_b; 
        OR  : result = bus_a | bus_b;
        XOR : result = bus_a ^ bus_b;
        //LUI
        FWD : result = bus_a;   

        //multiplication
        MUL     : result = mul_result[DATA_WIDTH:0];
        MULH    : result = mul_result[DATA_WIDTH*2-1:DATA_WIDTH];
        MULHSU  : result = mul_result[DATA_WIDTH*2-1:DATA_WIDTH];
        MULHU   : result = mul_result[DATA_WIDTH*2-1:DATA_WIDTH];
        //division
        DIV     : result = bus_a / bus_b;
        DIVU    : result = unsigned'(bus_a) / unsigned'(bus_b);
        REM     : result = bus_a % bus_b;
        REMU    : result = unsigned'(bus_a) % unsigned'(bus_b);

        default : result = bus_a + bus_b;  
    endcase
end

assign out = result[DATA_WIDTH-1:0];
assign overflow = (result[DATA_WIDTH] && opSel == ADD) ? HIGH : LOW;
assign Z = (result[DATA_WIDTH-1:0]==0) ? HIGH : LOW;
endmodule: alu