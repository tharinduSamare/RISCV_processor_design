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
<<<<<<< HEAD

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
<<<<<<< HEAD
<<<<<<< HEAD
=======
    always_comb begin : check_branch
>>>>>>> 7976b3dfae5b02a687b022f3bd9966bcf4017e1e
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 7976b3dfae5b02a687b022f3bd9966bcf4017e1e
        else if (branchType == BLTU && read1 < read2) begin
            branchN = '1;
        end
        else if (branchType == BGEU && read1 >= read2) begin
<<<<<<< HEAD
=======
        else if (branchType == BLTU && rs1_un < rs2_un)begin
            branchN = '1;
        end
        else if (branchType == BGEU && rs1_un >= rs2_un)begin
>>>>>>> 0a17a7d (Bug fixes: fixed the unsigned bug is pcbranchtype module and the name issue in pcSelect)
            branchN = '1;
=======
        if (branch) begin
=======
>>>>>>> 3bb1e50 (Bug fix: fixed the module name issue and changed the condition statement for the branching)
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
<<<<<<< HEAD
>>>>>>> e2cd857 (Add feature: check branch in the module itself)
=======
            branchN = '1;
>>>>>>> 7976b3dfae5b02a687b022f3bd9966bcf4017e1e
        end
        else begin
            branchN = '0;
        end
<<<<<<< HEAD
=======
            else begin
                branchN = '0;
            end
>>>>>>> 3bb1e50 (Bug fix: fixed the module name issue and changed the condition statement for the branching)
=======
>>>>>>> 7976b3dfae5b02a687b022f3bd9966bcf4017e1e
    end
endmodule