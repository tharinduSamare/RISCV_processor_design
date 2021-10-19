module alu_mux2 #(
    parameter DATA_WIDTH = 32;
)(
    input  aluSrc2,
    input  [DATA_WIDTH-1:0] imm, read2,
    output [DATA_WIDTH-1:0] bus_b
);

assign bus_b = (aluSrc2) ? imm : read2;
    
endmodule:alu_mux2