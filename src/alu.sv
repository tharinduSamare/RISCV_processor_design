module alu 
// import alu_definitions::*;
import definitions::*;
#(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0] bus_a, bus_b,
    input  alu_operation_t  opSel, 
    output logic [DATA_WIDTH-1:0] out,
    output flag_t overflow, Z
);

alu_operation_t curOpSel;
assign curOpSel = opSel;

logic [DATA_WIDTH:0] result;
// logic [DATA_WIDTH-1:0] sub_res
logic comp;

assign comp = (bus_a < bus_b) ? 1'b1: 1'b0;

always_comb begin : alu_operation
    case (curOpSel)
        //Arithmetic Operations
        ADD : result <= bus_a + bus_b;
        SUB : result <= bus_a - bus_b;
        //Comparison Operations
        SLTU: result <= (bus_a < bus_b) ? 32'd0 : 32'd1;
        SLT : begin
            if (bus_a[DATA_WIDTH-1] == bus_b[DATA_WIDTH-1])  result <= (bus_a < bus_b) ? 32'd0 : 32'd1;
            else result <= (comp) ? 32'd0 : 32'd1;
        end
        //Shift Operations
        SLL : result <= bus_a <<   bus_b;
        SRL : result <= bus_a >>   bus_b;
        SRA : result <= bus_a >>>  bus_b;
        //Logical Operations
        AND : result <= bus_a & bus_b; 
        OR  : result <= bus_a | bus_b;
        XOR : result <= bus_a ^ bus_b;
        //LUI
        FWD : result <= bus_a;   
        default : result <= bus_a + bus_b;  
    endcase
end

assign out = result[DATA_WIDTH-1:0];
assign overflow = (result[DATA_WIDTH] && curOpSel == ADD) ? HIGH : LOW;
assign Z = (result[DATA_WIDTH-1:0]==0) ? HIGH : LOW;
endmodule: alu