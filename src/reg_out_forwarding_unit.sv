module reg_out_forwarding_unit 
    import definitions::*;
#(
    parameter DATA_WIDTH     = 32
)
(
    input logic signed [DATA_WIDTH - 1 : 0]   read1,
    input logic signed [DATA_WIDTH - 1 : 0]   read2,

    input regName_t rs1, rs2,   
    input regName_t rdMeM,
    input logic signed [DATA_WIDTH-1:0] aluOutMeM,
    input logic regWriteMeM,

    output logic signed [DATA_WIDTH-1:0] read1_out, read2_out,
    output logic rs1_forward, rs2_forward
);

    always_comb begin

        // set read1 value
        if (regWriteMeM & (rdMeM != zero) & (rdMeM == rs1)) begin
            read1_out = aluOutMeM; //prev result
            rs1_forward = 1'b1;
        end
        else begin
            read1_out = read1;
            rs1_forward = 1'b0;
        end

        // set read2 value
        if (regWriteMeM & (rdMeM != zero) & (rdMeM == rs2)) begin
            read2_out = aluOutMeM;
            rs2_forward = 1'b1;
        end
        else begin
            read2_out = read2;
            rs2_forward = 1'b0;
        end
    end

endmodule:reg_out_forwarding_unit