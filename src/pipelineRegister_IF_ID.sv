module pipelineRegister_IF_ID( 
    input logic             clk,
    input logic             rstN,

    input logic [31 : 0]    pcIn,
    input logic [31 : 0]    instructionIn,

    input logic             harzardIF_ID_Write,

    output logic [31 : 0]   pcOut,
    output logic [31 : 0]   instructionOut
);

    always_ff @( posedge clk or negedge rstN ) begin : IF_ID_REGISTER
        if (~rstN) begin
            pcOut               <=      '0;
            instructionOut      <=      {25'b0, 7'b0010011}; // addi x0 x0 0
        end
        else begin
		  if (~harzardIF_ID_Write) begin
			// pcOut               <=      '0;
            // instructionOut      <=      {25'b0, 7'b0010011}; // addi x0 x0 0
            // instructionOut      <=      32'hFF5FF06F; // addi x0 x0 0
			pcOut               <=      pcOut;
            instructionOut      <=      instructionOut; // addi x0 x0 0
		  end
		  else begin
            pcOut               <=      pcIn;
            instructionOut      <=      instructionIn;
            end
		end
    end
endmodule