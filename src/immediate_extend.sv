module immediate_extend 
(
    input logic [31:0]instruction,
    output logic signed [31:0] I_immediate, S_immediate, SB_immediate, U_immediate, UJ_immediate
);

assign I_immediate = 32'(signed'(instruction[31:20]));
assign S_immediate = 32'(signed'({instruction[31:25],instruction[11:7]}));
assign SB_immediate = 32'(signed'({instruction[31],instruction[7], instruction[30:25], instruction[11:8],1'b0}));
assign U_immediate = {instruction[31:12],12'b0};
assign UJ_immediate = 32'(signed'({instruction[31], instruction[19:12], instruction[20],  instruction[30:21],1'b0}));

endmodule : immediate_extend