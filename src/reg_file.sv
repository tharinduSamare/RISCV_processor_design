// `include "reg_names.sv"
// import reg_names::*;

module reg_file #(
    parameter DATA_WIDTH = 32,
    parameter REG_COUNT = 32,
    parameter REG_SIZE = $clog2(REG_COUNT)
)(
    input  logic clk, rstN, wen, 
    input  logic [REG_SIZE-1:0] rs1, rs2, rd,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] regA_out, regB_out 
);

logic [DATA_WIDTH-1:0] reg_x [REG_COUNT-1:0];

// logic [REG_COUNT-1:0] ren_sel1, ren_sel2; 
logic [REG_COUNT-1:0] wen_sel;

logic [DATA_WIDTH-1:0] data_to_A, data_to_B;
logic [DATA_WIDTH-1:0] write_data;

always_comb begin : write
    reg_x [0] <= 16'h0;
    for (int i = 1; i<32; i=i+1) begin
        if (wen_sel[i]==1)  reg_x [rd] <= write_data;    
    end
end

always_ff @( posedge clk or negedge rstN) begin : synch_reg_write
    if (~rstN) begin: reset
        write_data <= 16'h0; //DATA_WIDTH
        wen_sel    <= 32'h073fc00f; //write everything except pointers and saved registers 
    end
    else begin : sel_en
        write_data  <= data_in;
        wen_sel     <= (wen) ? (1 << rd) : 32'h0;
    end
end

always_comb begin : read
    data_to_A <= reg_x [rs1];
    data_to_B <= reg_x [rs2];
end



/* Using reg_d module
always_ff @( posedge clk or negedge rstN ) begin : synch_reg
    if (~rstN) begin: reset
    //reset conditions
    end
    else begin : sel_en
        ren_sel <= 1 << rs1;
        ren_sel <= 1 << rs2;
        wen_sel <= (wen) ? (1 << rd) : 32'h0;
    end
end


reg_d REG (
    .clk, .rstN,
    .ren(ren_sel[0]),
    .wen(wen_sel[0]),
    .data_in(16'b0),
    .data_out(reg_x[i])
)

genvar i;
generate
    for (i=1;i<32;i=i+1) begin : gen_reg
        reg_d REG (
            .clk, .rstN,
            .ren(ren_sel[i]),
            .wen(wen_sel[i]),
            .data_in(write_data),
            .data_out(reg_x[i])
        );
    end
endgenerate
*/

assign regA_out = data_to_A;
assign regB_out = data_to_B;

endmodule:reg_file