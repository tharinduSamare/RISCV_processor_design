module pcAdd(
    input   logic           clk,
    input   logic   [31:0]  pcOld,

    output  logic   [31:0]  pcNew
    );

    always_ff @( clk ) begin : incrementPc
        pcNew   <= pcOld + 3'd4;
    end

endmodule: pcAdd