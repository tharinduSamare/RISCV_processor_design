module pcAdd(
    input   logic   [31:0]  pcOld,

    output  logic   [31:0]  pcNewFour
    );

    // increment pc by 4
    assign pcNewFour = pcOld + 32'd4;

endmodule: pcAdd