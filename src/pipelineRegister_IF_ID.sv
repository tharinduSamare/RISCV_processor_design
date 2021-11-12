module pipelineRegister_IF_ID( 
    input logic             clk,
    input logic             rstN,

    input logic [31 : 0]    pcIn,
    input logic [31 : 0]    instructionIn,

    input logic             harzardIF_ID_Write,
    input logic             flush,

    output logic [31 : 0]   pcOut,
    output logic [31 : 0]   instructionOut
);

    always_ff @( posedge clk or negedge rstN ) begin : IF_ID_REGISTER
        if (~rstN) begin
            pcOut               <=      '0;
            instructionOut      <=      '0;
        end
        else begin
            pcOut               <=      pcIn;
            instructionOut      <=      instructionIn;
        end
    end
endmodule