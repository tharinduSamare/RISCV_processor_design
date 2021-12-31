module immediate_extend 
(
    input logic [31:7]instruction,
    output logic signed [31:0] I_immediate, S_immediate, SB_immediate, U_immediate, UJ_immediate
);

// instructoin     |    31    |30         20|19           12|    11     |      10       |4             1|     0     |
// I_immediate  => |                — inst[31] —                        |  inst[30:25]  | inst[24:21]   | inst[20]  |
// S_immediate  => |                — inst[31] —                        |  inst[30:25]  | inst[11:8]    |  inst[7]  | 
// SB_immediate => |            — inst[31] —                | inst[7]   |  inst[30:25]  | inst[11:8]    |     0     | 
// U_immediate  => | inst[31] | inst[30:20] | inst[19:12]   |                        — 0 —                          |
// UJ_immediate => |     — inst[31] —       | inst[19:12]   | inst[20] | inst[30:25]    | inst[24:21]   |     0     | 

assign I_immediate = 32'(signed'(instruction[31:20]));
assign S_immediate = 32'(signed'({instruction[31:25],instruction[11:7]}));
assign SB_immediate = 32'(signed'({instruction[31],instruction[7], instruction[30:25], instruction[11:8],1'b0}));
assign U_immediate = 32'(signed'({instruction[31:12],12'b0}));
assign UJ_immediate = 32'(signed'({instruction[31], instruction[19:12], instruction[20],  instruction[30:21],1'b0}));

endmodule : immediate_extend