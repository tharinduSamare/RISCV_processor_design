module pcBranchType #(
    parameter REG_COUNT     = 32,
    parameter REG_SIZE      = $clog2(REG_COUNT)
)
(
    input logic                         branch, // from control unit
    input logic [2:0]                   func3,

    input logic signed [31 : 0]         rs1,
    input logic signed [31 : 0]         rs2,

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

    logic   [31:0]  rs1_un;
    logic   [31:0]  rs2_un;
    
    always_comb begin
        if (rs1[31] == 1'b1) begin
            rs1_un = -rs1;
        end
        else begin
            rs1_un = rs1;
        end
        if (rs2[31] == 1'b1) begin
            rs2_un = -rs2;
        end
        else begin
            rs2_un = rs2;
        end
    end

    always_comb begin : check_branch
        /*  
            Depending on the type of branch 
            required comparison is carried out
        */
            if (branch && func3 == BEQ && rs1 == rs2)begin
                branchN = '1;
            end
            else if (branch && func3 == BNE && rs1 != rs2)begin
                branchN = '1;
            end
            else if (branch && func3 == BLT && rs1 < rs2)begin
                branchN = '1;
            end
            else if (branch && func3 == BGE && rs1 >= rs2)begin
                branchN = '1;
            end
            else if (branch && func3 == BLTU && rs1_un < rs2_un)begin
                branchN = '1;
            end
            else if (branch && func3 == BGEU && rs1_un >= rs2_un)begin
                branchN = '1;
            end
            else begin
                branchN = '0;
            end
    end
endmodule