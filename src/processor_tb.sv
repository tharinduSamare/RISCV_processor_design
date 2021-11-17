class Memory #(parameter WIDTH=32, DEPTH=256, MEM_READ_DELAY=0, MEM_WRITE_DELAY=0);

    localparam ADDRESS_WIDTH = $clog2(DEPTH);
    logic signed [WIDTH-1:0]memory[0:DEPTH-1]; // can be initialized with random values
    typedef logic [WIDTH-1:0]  data_t;
    typedef logic [ADDRESS_WIDTH-1:0] addr_t;

    function new(input string mem_init_file);
        $readmemh(mem_init_file, this.memory);
    endfunction

    task Read_memory(input addr_t addr, ref logic rdEn, output data_t value, ref logic clk, output logic mem_ready); 
        repeat(MEM_READ_DELAY) @(posedge clk);
        mem_ready = 1'b0;
        if (rdEn) begin
            value = this.memory[addr];
        end
        mem_ready = 1'b1;
    endtask

    task Write_memory(input addr_t addr, input data_t data, ref logic wrEn, ref logic clk);
        repeat(MEM_READ_DELAY) @(posedge clk);
        if (wrEn) begin
            this.memory[addr] = data;
        end
    endtask

    function void display_RAM();
        foreach(this.memory[i])
            $display(i,this.memory[i]);
    endfunction

    function data_t get_value(input addr_t addr);
        return memory[addr];
    endfunction

endclass

///////////////////////////////////////////////////////////////////////

module processor_tb();

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

localparam IM_MEM_DEPTH = 256;
localparam DM_MEM_DEPTH = 4096;
localparam DATA_MEM_READ_DELAY = 3;
localparam DATA_MEM_WRITE_DELAY = 4;
localparam INS_MEM_READ_DELAY = 0;
localparam INS_MEM_WRITE_DELAY = 0;

localparam INSTRUCTION_WIDTH = 32;
localparam FUNC3_WIDTH = 3;
localparam DATA_WIDTH = 32;

logic rstN, startProcess,endProcess;

processor #(.IM_MEM_DEPTH(IM_MEM_DEPTH), .DM_MEM_DEPTH(DM_MEM_DEPTH), 
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH), .FUNC3_WIDTH(FUNC3_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)) DUT(.*);

Memory #(
    .WIDTH(32), 
    .DEPTH(DM_MEM_DEPTH), 
    .MEM_READ_DELAY(DATA_MEM_READ_DELAY), 
    .MEM_WRITE_DELAY(DATA_MEM_WRITE_DELAY)) dataMemory =new(.mem_init_file("data_mem_init.txt")
    );
Memory #(
    .WIDTH(32), 
    .DEPTH(IM_MEM_DEPTH), 
    .MEM_READ_DELAY(INS_MEM_READ_DELAY), 
    .MEM_WRITE_DELAY(INS_MEM_WRITE_DELAY)) insMemory= new(.mem_init_file("insMem.txt")
    );

// dataMemory = new(.mem_init_file("dataMem.txt"));
// insMemory = new(.mem_init_file("insMem.txt"));

initial begin
    @(posedge clk);  // initialize everything
    rstN = 1'b0;
    startProcess = 1'b0;
    @(posedge clk);
    rstN = 1'b1;

    @(posedge clk); // startProcess the processor
    startProcess = 1'b1;
    @(posedge clk);
    startProcess = 1'b0;

    wait(endProcess);
    repeat(10) @(posedge clk);
    $stop;

end

endmodule: processor_tb