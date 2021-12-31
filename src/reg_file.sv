/*
This Register_file module is implemented in the DECODE stage
*/
module reg_file 
    import definitions::*;
#(
    parameter DATA_WIDTH = 32
)
(
    input  logic clk, rstN, wen, 
    input  regName_t rs1, rs2, rd,                  //Get register address to read/write
    input  logic [DATA_WIDTH-1:0] data_in,          //Get write data
    input logic process_done,                       // To save register file values after the process finish
    output logic [DATA_WIDTH-1:0] regA_out, regB_out//Output read data
);

logic [DATA_WIDTH-1:0] reg_f [0:REG_COUNT-1];

//Reset registers: everything except pointers and saved registers -> Uncomment below
// logic [REG_COUNT-1:0] wen_sel= 32'h073fc00f; 

//Reset all registers -> Uncomment below
logic [REG_COUNT-1:0] wen_sel= 32'hffffffff;  

logic [DATA_WIDTH-1:0] data_to_A, data_to_B;

//Assign read data value to wires 
assign regA_out = data_to_A;
assign regB_out = data_to_B;

// Register write during the first half of the cycle 
always_ff @(negedge clk) begin : write  
	if (rstN == 0) begin    //Reset Register file
        for (int i = 0; i<32; i=i+1) begin
            if (wen_sel[i]==1)  reg_f [i] <= 32'd0;    
        end
        reg_f[2] <= 32'hff0;  //4080 th address of the data memory, stack pointer
	end
	else begin  //Write Register
		if (wen) begin
            if (rd == 0) reg_f [rd] <= 0; //error - can't write to zero
            else reg_f [rd] <= data_in; 
        end
	end
end

//Assign read data to output
assign data_to_B = reg_f[rs2];
assign data_to_A = reg_f[rs1];

// write the final register file content to a text file
always_ff @( posedge clk ) begin 
    if (process_done)
        $writememh("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\reg_file_final.txt", reg_f);
end

endmodule:reg_file