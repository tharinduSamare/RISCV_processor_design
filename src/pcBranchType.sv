module pcBranchType 
    import definitions::*;
#(
    parameter DATA_WIDTH     = 32
)
(
	input logic 							  branch,
    input logic signed [DATA_WIDTH - 1 : 0]   read1,
    input logic signed [DATA_WIDTH - 1 : 0]   read2,
    input logic [2:0]                       branchType,

    input regName_t rs1, rs2,   
    input regName_t rdEX, rdMeM,
    input logic signed [DATA_WIDTH-1:0] aluOutEx, aluOutMeM,
    input logic regWriteEX, regWriteMeM,

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

    logic [31:0] read1_out, read2_out;
    always_comb begin

        // set read1 value
        if (regWriteEX & (rdEX != zero ) & (rdEX == rs1)) begin
            read1_out = aluOutEx;
        end
        else if (regWriteMeM & (rdMeM != zero) & (rdMeM == rs1)) begin
            read1_out = aluOutMeM;
        end
        else begin
            read1_out = read1;
        end

        // set read2 value
        if (regWriteEX & (rdEX != zero) & (rdEX == rs2)) begin
            read2_out = aluOutEx;
        end
        else if (regWriteMeM & (rdMeM != zero) & (rdMeM == rs2)) begin
            read2_out = aluOutMeM;
        end
        else begin
            read2_out = read2;
        end
    end



    logic   [31:0]  read1_un;
    logic   [31:0]  read2_un;
    
    always_comb begin : blockName
        read1_un = unsigned'(read1_out);
        read2_un = unsigned'(read2_out);
    end

    // always_comb begin
    //     if (read1[31] == 1'b1) begin
    //         read1_un = -read1_out;
        
    //     end
    //     else begin
    //         read1_un = read1_out;
    //     end
    //     if (read2[31] == 1'b1) begin
    //         read2_un = -read2_out;  
    //     end
    //     else begin
    //         read2_un = read2_out;
    //     end
    // end


    always_comb begin : check_branch
    /*  
        Depending on the type of branch 
        required comparison is carried out
    */
        
            if (branch && branchType == 3'b000 && read1_out == read2_out)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b001 && read1_out != read2_out)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b100 && read1_out < read2_out)begin
                branchN = '1;
            end
            else if (branch && branchType == 3'b101 && read1_out >= read2_out)begin
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