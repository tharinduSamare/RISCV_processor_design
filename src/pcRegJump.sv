module pcJump #(
    parameter BITS          = 32,
    parameter REG_COUNT     = 32,
    parameter REG_SIZE      = $clog2(REG_COUNT)
    )(

    input logic [REG_SIZE : 0]    rs1,
    input logic [BITS : 0]        Jimme,

    output logic [BITS : 0]   pcRegJumpNew
    
);

    logic pcRegJumpNewNext;

    assign pcRegJumpNewNext = rs1 + Jimme; 
    assign pcRegJumpNew     = {pcRegJumpNewNext[31:1],1'b0};   
    
endmodule