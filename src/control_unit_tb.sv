
module control_unit_tb();
timeunit 1ns;
timeprecision 1ps;
    
logic [6:0] opCode;
logic enable;
logic jump, jumpReg, branch, memRead, memWrite, memtoReg, regWrite, aluSrc1; //writeSrc
logic [1:0] aluSrc1, aluSrc2, aluOp;

control_unit dut(.*);

localparam CLK_PERIOD = 10;
logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

initial begin
    enable <=1;
    opCode <= '0;
    @(posedge clk);
    opCode <= 7'b1100011; //branch
    #(CLK_PERIOD);
    @(posedge clk);
    opCode <= 7'b1101111; //J type
    #(CLK_PERIOD);
    opCode <= 7'b0010011; //I type
    #(CLK_PERIOD);
    $stop;
end
endmodule
