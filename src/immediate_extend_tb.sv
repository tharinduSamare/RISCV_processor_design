module immediate_extend_tb();

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

logic [31:0]instruction;
logic signed [31:0] I_immediate, S_immediate, SB_immediate, U_immediate, UJ_immediate;

immediate_extend dut(.*);

initial begin
    for (int i=0;i<10;i++) begin
        @(posedge clk);
        instruction = $random();
        #(CLK_PERIOD/2);
        $display("instruction = %b", instruction);
        $display("I_immediate = %b", I_immediate);
        $display("S_immediate = %b", S_immediate);
        $display("SB_immediate = %b", SB_immediate);
        $display("U_immediate = %b", U_immediate);
        $display("UJ_immediate = %b\n", UJ_immediate);
    end
    $stop;
end

endmodule : immediate_extend_tb