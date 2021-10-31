module pcBranchType #(
    parameter DATA_WIDTH     = 32
)
(
    input logic signed [DATA_WIDTH - 1 : 0]   read1,
    input logic signed [DATA_WIDTH - 1 : 0]   read2,
    input logic [2:0]                   branchType,

    output logic                        branchN
);

typedef enum logic [ 2:0 ]{
        BEQ  = 3'b000,
        BNE  = 3'b001,
        BLT  = 3'b100,
        BGE  = 3'b101,
        BLTU = 3'b110,
        BGEU = 3'b111
    } branch_;

    branch_ _;
    always_comb begin : check_branch
    /*  
        Depending on the type of branch 
        required comparison is carried out
    */
        if (branchType == BEQ && read1 == read2)begin
            branchN = '1;
        end
        else if (branchType == BNE && read1 != read2)begin
            branchN = '1;
        end
        else if (branchType == BLT && read1 < read2)begin
            branchN = '1;
        end
        else if (branchType == BGE && read1 >= read2)begin
            branchN = '1;
        end
        else if (branchType == BLTU && read1 < read2) begin
            branchN = '1;
        end
        else if (branchType == BGEU && read1 >= read2) begin
            branchN = '1;
        end
        else begin
            branchN = '0;
        end
    end
endmodule