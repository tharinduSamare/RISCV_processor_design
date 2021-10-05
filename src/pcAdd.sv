module pcAdd(
    input   logic   [31:0]  pcOld,

    output  logic   [31:0]  pcNew
    );

    assign pcNew = pcOld + 3'd4;

endmodule: pcAdd