module hazard_unit_tb();

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

localparam MEM_WRITE_DELAY = 4;
localparam MEM_READ_DELAY = 5;

logic rstN;
logic [3:0] IF_ID_rs1, IF_ID_rs2;
logic [3:0] ID_Ex_rd;
logic ID_Ex_MemRead,ID_Ex_MemWrite,mem_ready;
logic IF_ID_write, PC_write, ID_Ex_enable;

hazard_unit DUT(.*);

initial begin
    @(posedge clk);
    rstN <= 1'b0;
    ID_Ex_MemWrite = 1'b0;
    ID_Ex_MemRead = 1'b0;
    mem_ready = 1'b1;
    @(posedge clk);
    rstN <= 1'b1;
    @(posedge clk);
    read_memory();

    repeat(5) @(posedge clk);
    write_memory();

    repeat(5) @(posedge clk);

    $stop;

end

task automatic read_memory ();
    @(posedge clk);
    ID_Ex_MemRead = 1'b1;  // load instruction is at execution state
    @(posedge clk);  // load instruction is at memory read state
    ID_Ex_MemRead = 1'b0;
    @(posedge clk); // memory start read operation by resetting mem_ready
    mem_ready = 1'b0;

    repeat(MEM_READ_DELAY) @(posedge clk);
    mem_ready = 1'b1;

endtask

task automatic write_memory ();
    @(posedge clk);
    ID_Ex_MemWrite= 1'b1;  // store instruction is at execution state
    @(posedge clk);  // store instruction is at memory read state
    ID_Ex_MemWrite = 1'b0;
    @(posedge clk); // memory start write operation by resetting mem_ready
    mem_ready = 1'b0;

    repeat(MEM_WRITE_DELAY) @(posedge clk);
    mem_ready = 1'b1;

endtask

endmodule: hazard_unit_tb