// `include "definitions.sv"
module pcBranchType 
    import definitions::*;
#(
    parameter DATA_WIDTH     = 32
)
(
    /* 
        Inputs
    */
	input logic 							  branch,       // branch signal from the control unit
    input logic signed [DATA_WIDTH - 1 : 0]   read1,
    input logic signed [DATA_WIDTH - 1 : 0]   read2,    
    input logic [2:0]                         branchType,   // func3

    input logic signed [DATA_WIDTH-1:0] read1_forward_val, read2_forward_val,
    input logic read1_forward, read2_forward,

    /*  
        Output
    */
    output logic                        branchN
);

    logic [31:0] read1_out, read2_out;

    /*  
        if there is a dependency obtain the values from
        the data forwarding unit
    */
    always_comb begin
        if (read1_forward) begin
            read1_out = read1_forward_val;
        end
        else begin
            read1_out = read1;
        end
        if (read2_forward) begin
            read2_out = read2_forward_val;
        end
        else begin
            read2_out = read2;
        end
    end

    logic   [31:0]  read1_un;
    logic   [31:0]  read2_un;
    
    // assign the unsigned values for BLTU & BGEU
    always_comb begin : blockName
        read1_un = unsigned'(read1_out);
        read2_un = unsigned'(read2_out);
    end

    always_comb begin : check_branch
    /*  
        Depending on the type of branch 
        required comparison is carried out
    */   
        if (branch && branchType == 3'b000 && read1_out == read2_out)begin
            branchN = '1;   //BEQ
        end
        else if (branch && branchType == 3'b001 && read1_out != read2_out)begin
            branchN = '1;   // BNE
        end
        else if (branch && branchType == 3'b100 && read1_out < read2_out)begin
            branchN = '1;   // BLT
        end
        else if (branch && branchType == 3'b101 && read1_out >= read2_out)begin
            branchN = '1;   // BGE
        end
        else if (branch && branchType == 3'b110 && read1_un < read2_un)begin
            branchN = '1;   // BLTU
        end
        else if (branch && branchType == 3'b111 && read1_un >= read2_un)begin
            branchN = '1;   // BGEU
        end
        else begin
            branchN = '0;   // no branch
        end
    end
endmodule