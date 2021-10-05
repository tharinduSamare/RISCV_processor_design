module pcJump (
    input [31:0] pcOld,
    input [31:0] imme,

    output [31:0] pcJumpNew
);

    assign pcJumpNew <= pcOld + imme;    
    
endmodule