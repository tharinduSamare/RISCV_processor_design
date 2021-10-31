module mux #(
    parameter NO_INPUTS = 4,
    parameter SELECT_WIDTH = $clog2(NO_INPUTS),
    parameter DATA_WIDTH = 32
) (
    input logic [DATA_WIDTH:1] inputs [0:NO_INPUTS-1],
    input logic [SELECT_WIDTH-1:0] select,
    output logic [DATA_WIDTH:1] out
  
);
    assign out = inputs[select];
    
endmodule