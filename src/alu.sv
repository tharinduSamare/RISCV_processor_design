module alu 
import alu_definitions::*;
#(
    parameter D_WIDTH = 32
)(
    input  [D_WIDTH-1:0] bus_a, bus_b,
    input  operation_t  opSel, 
    output logic [D_WIDTH-1:0] out,
    output flag_t overflow, Z
);

logic [D_WIDTH:0] result;
wire  [D_WIDTH-1:0] sub_res = bus_a - bus_b;
// logic [D_WIDTH-1:0] nextOut;
// logic nextCarry;

always_comb begin : alu_operation
    case (opSel)
        //Arithmetic Operations
        ADD : result <= bus_a + bus_b;
        SUB : result <= sub_res;
        //Comparison Operations
        SLTU: result <= (bus_a < bus_b) ? 32'd0 : 32'd1;
        SLT : begin
            if (bus_a[D_WIDTH-1] == bus_b[D_WIDTH-1])  result <= (bus_a < bus_b) ? 32'd0 : 32'd1;
            else result <= (sub_res[D_WIDTH-1]) ? 32'd1 : 32'd0;
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

assign out = result[D_WIDTH-1:0];
assign overflow = (result[D_WIDTH]) ? HIGH : LOW;
assign Z = (result[D_WIDTH-1:0]==0) ? HIGH : LOW;
endmodule: alu