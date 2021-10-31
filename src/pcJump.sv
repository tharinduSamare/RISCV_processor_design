module pcJump #(
    parameter BITS          = 32
)(
    input logic [BITS:0] pcOld,
    input logic [BITS:0] imme,

    output logic [BITS:0] pcJumpNew
);

    assign pcJumpNew <= pcOld + imme;    
    
endmodule