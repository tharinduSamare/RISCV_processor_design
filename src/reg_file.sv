module reg_file 
    // import reg_names::*;
    import definitions::*;
#(
    parameter DATA_WIDTH = 32
)
(
    input  logic clk, rstN, wen, 
    input  regName_t rs1, rs2, rd,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] regA_out, regB_out 
);

logic [DATA_WIDTH-1:0] reg_f [0:REG_COUNT-1];

logic [REG_COUNT-1:0] wen_sel= 32'h073fc00f; //write everything except pointers and saved registers

logic [DATA_WIDTH-1:0] data_to_A, data_to_B;

assign regA_out = data_to_A;
assign regB_out = data_to_B;

always_ff @(negedge clk) begin : write  // write at the first half of the cycle **********
	if (rstN == 0) begin
        for (int i = 0; i<32; i=i+1) begin
            if (wen_sel[i]==1)  reg_f [i] <= 32'd0;    
        end
        reg_f[2] <= 32'hff0;  //4080 th address of the data memory
	end
	else begin
		if (wen) begin
            if (rd == 0) reg_f [rd] <= 0; //error - can't write to zero
            else reg_f [rd] <= data_in; 
        end
		// data_to_B <= reg_f [rs2];
		// data_to_A <= reg_f [rs1];

        // if (rs2 == 0) data_to_B <= 0;
		// else data_to_B <= reg_f [rs2];
		// if (rs1 == 0) data_to_A <= 0;
        // else data_to_A <= reg_f [rs1];

	end
end

assign data_to_B = reg_f[rs2];
assign data_to_A = reg_f[rs1];

endmodule:reg_file