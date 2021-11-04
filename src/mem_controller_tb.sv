module mem_controller_tb();

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

localparam [2:0]
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101,
    SB  = 3'b000,
    SH  = 3'b001,
    SW  = 3'b010;

localparam MEMORY_DEPTH = 4096;
localparam ADDRESS_WIDTH = 32;
localparam DATA_WIDTH = 32;

logic rstN,write_En,read_En;
logic [2:0]func3_in;
logic [ADDRESS_WIDTH-1:0]address;
logic [DATA_WIDTH-1:0]data_in;
logic [DATA_WIDTH-1:0]data_out;
logic ready;

mem_controller #(.MEMORY_DEPTH(MEMORY_DEPTH), .ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(.*);

logic [2:0]read_operatoins[0:4] = '{LB, LH, LW, LBU, LHU};
logic [2:0]write_operations[0:2] = '{SB, SH, SW};

initial begin
    @(posedge clk);
    rstN = 1'b0;
    write_En = 1'b0;
    read_En = 1'b0;
    func3_in = LB;
    address = '0;
    data_in = '0;

    @(posedge clk);
    rstN = 1'b1;

    foreach (read_operatoins[i]) begin   // test for read operations

        @(posedge clk);
        read_En = 1'b1;
        func3_in = read_operatoins[i];
        address = ADDRESS_WIDTH'(i);

        @(posedge clk);
        read_En = 1'b0;

        @(posedge clk);
        wait(ready);
        repeat(5) @(posedge clk);
    end

    foreach (write_operations[i]) begin   // test for write operations

        @(posedge clk);
        write_En = 1'b1;
        func3_in = write_operations[i];
        address = ADDRESS_WIDTH'(i);
        data_in = $random();

        @(posedge clk);
        write_En = 1'b0;
        
        @(posedge clk);
        wait(ready);
        repeat(5) @(posedge clk);
    end

    $stop;
end

endmodule : mem_controller_tb