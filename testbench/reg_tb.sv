module reg_tb import reg_names::*;();
timeunit 1ns;
timeprecision 1ps;

localparam DATA_WIDTH = 16;
localparam REG_COUNT = 32;
localparam REG_SIZE = $clog2(REG_COUNT);

logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

logic rstN, wen;
logic [REG_SIZE-1:0] rs1, rs2, rd;
logic [DATA_WIDTH-1:0] data_in;
logic [DATA_WIDTH-1:0] regA_out, regB_out;

reg_file (.*);

task r_type (logic [REG_SIZE-1:0] rs1, logic [REG_SIZE-1:0] rs2, logic [REG_SIZE-1:0] rd);
    @(posedge clk);
    wen <= 1;
 
endtask //r_type


task r_type (logic [REG_SIZE-1:0] rs1, logic [REG_SIZE-1:0] rs2, logic [REG_SIZE-1:0] rd);
    @(posedge clk);
    wen <= 1;
 
endtask //r_type

initial begin
    rstN <= 1;
    wen <= 1;
    data_in <= $random();
    rd  <= a0;


end