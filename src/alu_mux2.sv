module alu_mux2 (
    input  aluSrc1,
    input  [15:0] imm, rs1,
    output [15:0] bus_b
);

assign bus_b = (aluSrc1) ? imm : rs1;
    
endmodule:alu_mux2