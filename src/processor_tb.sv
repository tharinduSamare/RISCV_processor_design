class DataMemory #(parameter WIDTH=32, DEPTH=256, MEM_READ_DELAY=0, MEM_WRITE_DELAY=0);

    localparam ADDRESS_WIDTH = $clog2(DEPTH);
    logic signed [WIDTH-1:0]memory[0:DEPTH-1]; // can be initialized with random values
    typedef logic [WIDTH-1:0]  data_t;
    typedef logic [ADDRESS_WIDTH-1:0] addr_t;
    logic [1:0] addr_LSB_bits;
    logic [ADDRESS_WIDTH-3:0]addr_MSB_bits;

    localparam [2:0]
        LB  = 3'b000,
        LH  = 3'b001,
        LW  = 3'b010,
        LBU = 3'b100,
        LHU = 3'b101,
        SB  = 3'b000,
        SH  = 3'b001,
        SW  = 3'b010;

    function new(input string mem_init_file);
        $readmemh(mem_init_file, this.memory);
    endfunction

    task automatic Read_memory(input addr_t addr, ref logic rdEn, input logic [2:0]func3, output data_t value, ref logic clk, output logic mem_ready); 
        repeat(MEM_READ_DELAY) @(posedge clk);
        mem_ready = 1'b0;
        addr_LSB_bits = addr[1:0];
        addr_MSB_bits = addr[ADDRESS_WIDTH-1:2];

        if (rdEn) begin
            case (func3) 
                LB : value = WIDTH'(signed'(this.memory[addr_MSB_bits][addr_LSB_bits*8 +:8]));
                LH : value = WIDTH'(signed'(this.memory[addr_MSB_bits][addr_LSB_bits[1]*16 +:16]));
                LW : value = this.memory[addr_MSB_bits];
                LBU: value = WIDTH'(this.memory[addr_MSB_bits][addr_LSB_bits*8 +:8]);
                LHU: value = WIDTH'(this.memory[addr_MSB_bits][addr_LSB_bits[1]*16 +:16]);
                default: $display("wrong func3 for load data");
            endcase
        end
        mem_ready = 1'b1;
    endtask

    task automatic Write_memory(input addr_t addr, ref logic wrEn, input logic [2:0]func3, input data_t data, ref logic clk,output logic mem_ready);
        repeat(MEM_READ_DELAY) @(posedge clk);
        mem_ready = 1'b0;
        addr_LSB_bits = addr[1:0];
        addr_MSB_bits = addr[ADDRESS_WIDTH-1:2];
        if (wrEn) begin
            case (func3) 
                SB : this.memory[addr_MSB_bits] = WIDTH'(signed'(data[7:0]));
                SH : this.memory[addr_MSB_bits] = WIDTH'(signed'(data[WIDTH/2-1:0]));
                SW : this.memory[addr_MSB_bits] = data;
                default: $display("wrong func3 for store data");
            endcase
        end
        mem_ready = 1'b1;
    endtask

    // function void display_RAM();
    //     foreach(this.memory[i])
    //         $display(i,this.memory[i]);
    // endfunction

    // function data_t get_value(input addr_t addr);
    //     return memory[addr];
    // endfunction

endclass

class InstructionMemory #(parameter WIDTH=32, DEPTH=256, MEM_READ_DELAY=0, MEM_WRITE_DELAY=0);

    localparam ADDRESS_WIDTH = $clog2(DEPTH);
    logic signed [WIDTH-1:0]memory[0:DEPTH-1]; // can be initialized with random values
    typedef logic [WIDTH-1:0]  data_t;
    typedef logic [ADDRESS_WIDTH-1:0] addr_t;
    logic [ADDRESS_WIDTH-3:0]addr_MSB_bits;

    function new(input string mem_init_file);
        $readmemh(mem_init_file, this.memory);
    endfunction

    task automatic Read_memory(input addr_t addr, output data_t value, ref logic clk); 
        repeat(MEM_READ_DELAY) @(posedge clk); 
        addr_MSB_bits = addr[ADDRESS_WIDTH-1:2];
        value = this.memory[addr_MSB_bits];
    endtask

    task automatic Write_memory(input addr_t addr, input data_t data, ref logic wrEn, ref logic clk);
        repeat(MEM_READ_DELAY) @(posedge clk);
        addr_MSB_bits = addr[ADDRESS_WIDTH-1:2];
        if (wrEn) begin
            this.memory[addr_MSB_bits] = data;
        end
    endtask

    // function void display_RAM();
    //     foreach(this.memory[i])
    //         $display(i,this.memory[i]);
    // endfunction

    // function data_t get_value(input addr_t addr);
    //     return memory[addr];
    // endfunction

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

// IRAM
logic [INSTRUCTION_WIDTH-1:0]instructionIF;
logic [INSTRUCTION_WIDTH-1:0] pcIF;

// DRAM
logic [DATA_WIDTH-1:0] dMOutMem;
logic dMReadyMem;   
logic memReadMeM, memWriteMeM; 
logic [FUNC3_WIDTH-1:0] func3MeM;
logic [DATA_WIDTH-1:0] aluOutMeM;
logic [DATA_WIDTH-1:0] rs2DataMeM;

logic dMReadyMem_r,dMReadyMem_w;
assign dMReadyMem = dMReadyMem_r && dMReadyMem_w;
///////////////


processor #(.IM_MEM_DEPTH(IM_MEM_DEPTH), .DM_MEM_DEPTH(DM_MEM_DEPTH), 
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH), .FUNC3_WIDTH(FUNC3_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)) DUT(.*);

DataMemory #(
    .WIDTH(32), 
    .DEPTH(DM_MEM_DEPTH), 
    .MEM_READ_DELAY(DATA_MEM_READ_DELAY), 
    .MEM_WRITE_DELAY(DATA_MEM_WRITE_DELAY)) dataMemory =new(.mem_init_file("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\data_mem_init.txt")
    );
InstructionMemory #(
    .WIDTH(32), 
    .DEPTH(IM_MEM_DEPTH), 
    .MEM_READ_DELAY(INS_MEM_READ_DELAY), 
    .MEM_WRITE_DELAY(INS_MEM_WRITE_DELAY)) insMemory= new(.mem_init_file("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\ins_mem_init.txt")
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
    // startProcess = 1'b0;

    wait(endProcess);
    repeat(10) @(posedge clk);
    $stop;

end

initial begin
    forever begin
        @(posedge clk);
        dataMemory.Read_memory(.addr(aluOutMeM), .rdEn(memReadMeM), .func3(func3MeM), .value(dMOutMem), .clk(clk), .mem_ready(dMReadyMem_r));
    end
end

initial begin
    forever begin
        @(posedge clk);
        dataMemory.Write_memory(.addr(aluOutMeM), .wrEn(memWriteMeM), .func3(func3MeM), .data(rs2DataMeM), .clk(clk), .mem_ready(dMReadyMem_w));
    end
end

initial begin
    forever begin
        #(CLK_PERIOD/10);  // need to read instantaneously, but can not put #(0) in forever loop.
        insMemory.Read_memory(.addr(pcIF), .value(instructionIF), .clk(clk));
    end
end

endmodule: processor_tb