module pcJump (
    input [4:0] rs1,
    input [31:0] imme,

    output [31:0] pcRegJumpNew
);

    logic pcRegJumpNewNext;

    assign pcRegJumpNewNext = rs1 + imme; 
    assign pcRegJumpNew     = {pcRegJumpNewNext[31:1],1'b0};   
    
endmodule