module data_forwarding_tb();
timeunit 1ns;
timeprecision 1ps;

localparam DATA_WIDTH = 32;
localparam REG_SIZE = 5;
localparam CLK_PERIOD = 10;
logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

logic mem_regWrite, wb_regWrite;
logic [REG_SIZE-1:0] mem_rd, wb_rd;
logic [REG_SIZE-1:0] ex_rs1, ex_rs2;
logic [1:0] df_mux1, df_mux2;

data_forwarding df_unit (
    .mem_regWrite(mem_regWrite),
    .wb_regWrite(wb_regWrite),
    .mem_rd(mem_rd),
    .wb_rd(wb_rd),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .df_mux1(df_mux1),
    .df_mux2(df_mux2)
);

initial begin
    ex_rs1 = 5'd2;
    ex_rs2 = 5'd3;

    mem_rd = 5'd3;
    wb_rd = 5'd2;

    mem_regWrite = 1'b1;
    wb_regWrite = 1'b1;
end

endmodule: data_forwarding_tb