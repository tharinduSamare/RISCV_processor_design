module pcBranch(
    input   logic           clk,
    // input   logic           branch,
    input   logic   [31:0]  pcOld,
    input   logic   [31:0]  branchPc,

    output  logic   [31:0]  pcNew
    );

    always_ff @( clk ) begin
        pcNew   <=  pcOld + branchPc;
    end

endmodule: pcBranch