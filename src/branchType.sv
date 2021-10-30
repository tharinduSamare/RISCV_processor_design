module branchType #(
    parameter DATA_WIDTH    = 16,
    parameter REG_COUNT     = 32,
    parameter REG_SIZE      = $clog2(REG_COUNT)
)
(
    input logic signed [REG_SIZE-1:0]   rs1,
    input logic signed [REG_SIZE-1:0]   rs2,
    input logic [2:0]                   brachType,

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
        if (branchType == BEQ && rs1 == rs2)begin
            branchN = '1;
        end
        else if (branchType == BNE && rs1 != rs2)begin
            branchN = '1;
        end
        else if (branchType == BLT && rs1 < rs2)begin
            branchN = '1;
        end
        else if (branchType == BGE && rs1 >= rs2)begin
            branchN = '1;
        end
        else if (branchType == BLTU && (Unsigned)'((32)'rs1) < (Unsigned)'((32)'rs2))begin
            branchN = '1;
        end
        else if (branchType == BGEU && (Unsigned)'((32)'rs1) >= (Unsigned)'((32)'rs2))begin
            branchN = '1;
        end
        else begin
            branchN = '0;
        end
    end
endmodule