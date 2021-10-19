module alu_tb();
timeunit 1ns;
timeprecision 1ps;

localparam DATA_WIDTH = 32;
localparam CLK_PERIOD = 10;
logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

logic [DATA_WIDTH-1:0] read1;
logic [DATA_WIDTH-1:0] read2;
logic [DATA_WIDTH-1:0] write;

logic aluSrc2;
logic [1:0] aluOp;
logic [6:0] funct7; 
logic [2:0] funct3;
logic [DATA_WIDTH-1:0] out;
logic overflow, Z;

initial begin
    read1 = 32'd10;
    read2 = 32'd12;

    aluSrc2 = 1;
    aluOp = 2'b10;
    funct7 = 7'd0;
    funct3 = 3'd0;

    repeat


end