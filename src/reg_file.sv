//`include "reg_names.sv"
//import reg_names::*;

module reg_file #(
    parameter DATA_WIDTH = 16,
    parameter REG_COUNT = 32,
    parameter REG_SIZE = $clog2(REG_COUNT)
)(
    input  logic clk, rstN, wen, 
    input  logic [REG_SIZE-1:0] rs1, rs2, rd,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] regA_out, regB_out 
);

logic [DATA_WIDTH-1:0] d_reg [0:REG_COUNT-1];

logic [0:REG_COUNT-1] ren_sel1, ren_sel2, wen_sel;

logic [DATA_WIDTH-1:0] data_to_A, data_to_B;
logic [DATA_WIDTH-1:0] write_data;

always_comb begin : write
    if (wen_sel == 32'd1) d_reg [0] <= write_data;
    else begin
    for (int i = 1; i<32; i=i+1) begin
        if (i == wen_sel) begin
            d_reg [rd] <= write_data;    
        end
    end
    end
end

always_comb begin : read
    data_to_A       <= d_reg [ren_sel1];
    data_to_B       <= d_reg [ren_sel2];    
end

always_ff @( posedge clk or negedge rstN) begin : synch_reg
    if (~rstN) begin: reset
        write_data <= 16'h0; //DATA_WIDTH
        wen_sel    <= 32'h073fc00f; //write everything except pointers and saved registers 
    end
    else begin : sel_en
        write_data  <= data_in;
        ren_sel1    <= rs1;
        ren_sel2    <= rs2;
        wen_sel     <= (wen) ? (1 << rd) : 32'h0;
    end
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
    .data_in(write_data),
    .data_out(32'b0)
)

genvar i;
generate
    for (i=1;i<32;i=i+1) begin : gen_reg
        reg_d REG (
            .clk, .rstN,
            .ren(ren_sel[i]),
            .wen(wen_sel[i]),
            .data_in(write_data),
            .data_out(d_reg[i])
        );
    end
endgenerate
*/

assign regA_out = data_to_A;
assign regB_out = data_to_B;

endmodule:reg_file