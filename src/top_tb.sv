module top_tb ();

timeunit 1ns;
timeprecision 1ns;

localparam CLK_PERIOD = 20;  // set to the correct value of the FPGA board

logic clk;
initial begin
    clk = 1'b0;
    forever begin
        #(CLK_PERIOD/2);
        clk = ~clk;
    end
end

localparam IM_MEM_DEPTH = 512;
localparam DM_MEM_DEPTH = 4096;

logic rstN, startProcess, endProcess;

top #(.IM_MEM_DEPTH(IM_MEM_DEPTH), .DM_MEM_DEPTH(DM_MEM_DEPTH)) top(.*);

initial begin
    @(posedge clk);
    rstN = 1'b0;
    startProcess = 1'b0;

    @(posedge clk);
    rstN = 1'b1;

    @(posedge clk);
    startProcess = 1'b1;

    @(posedge clk);
    startProcess = 1'b0;

    wait(endProcess);
    repeat(10) @(posedge clk);
    $stop;

end



endmodule: top_tb