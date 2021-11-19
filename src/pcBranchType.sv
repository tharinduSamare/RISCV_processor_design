module pcBranchType #(
    parameter DATA_WIDTH     = 32
)
(
	 input logic 										 branch,
    input logic signed [DATA_WIDTH - 1 : 0]   read1,
    input logic signed [DATA_WIDTH - 1 : 0]   read2,
    input logic [2:0]                       branchType,

    output logic                        branchN
);

    // typedef enum logic [ 2:0 ]{
    //     BEQ  = 3'b000,
    //     BNE  = 3'b001,
    //     BLT  = 3'b100,
    //     BGE  = 3'b101,
    //     BLTU = 3'b110,
    //     BGEU = 3'b111
    // } branch_;

    // branch_ _;


    logic   [31:0]  read1_un;
    logic   [31:0]  read2_un;
    
    always_comb begin
        if (read1[31] == 1'b1) begin
            read1_un = -read1;
        end
        else begin
            read1_un = read1;
        end
        if (read2[31] == 1'b1) begin
            read2_un = -read2;
        end
        else begin
            read2_un = read2;
        end
    end


    always_comb begin : check_branch
    /*  
        Depending on the type of branch 
        required comparison is carried out
    */
        
            if (branch && branchType == 3'b000 && read1 == read2)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b001 && read1 != read2)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b100 && read1 < read2)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b101 && read1 >= read2)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b110 && read1_un < read2_un)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b111 && read1_un >= read2_un)begin
                branchN = '1;
            end

			  else begin
					branchN = '0;
			  end
    end
endmodule