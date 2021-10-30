module pcAdd(
    input   logic   [31:0]  pcOld,

    output  logic   [31:0]  pcNewFour
    );

    assign pcNewFour = pcOld + 3'd4;

endmodule: pcAdd