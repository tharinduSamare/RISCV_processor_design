module mux #(
    parameter NO_INPUTS = 2,
    parameter SELECT_WIDTH = $clog2(NO_INPUTS),
    parameter DATA_WIDTH = 32
) (
    input logic [DATA_WIDTH:1] dataIn [0:NO_INPUTS-1],
    input logic [SELECT_WIDTH-1:0] selection,
    output logic [DATA_WIDTH:1] dataOut
  
);
    assign dataOut = dataIn[selection];
    
endmodule