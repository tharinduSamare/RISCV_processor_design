module alu_mux1 (
    input  wire aluSrc1,
    input  wire [15:0] pc, rs1,
    output wire [15:0] bus_a
);

assign bus_a = (aluSrc1) ? pc : rs1;
    
endmodule:alu_mux1