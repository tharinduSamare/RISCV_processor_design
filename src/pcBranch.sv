module pcBranch (
    input [31:0] pcOld,
    input [31:0] imme,

    output [31:0] pcBranchNew
);

    assign pcBranchNew <= pcOld + imme;    
    
endmodule