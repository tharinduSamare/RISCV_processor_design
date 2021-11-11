module alu_reg_tb
import  alu_definitions::*,
		definitions::*,
        reg_names::*;   
();
timeunit 1ns;
timeprecision 1ps;

localparam DATA_WIDTH_L = 32;
localparam CLK_PERIOD = 10;
logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

aluOp_t aluOp;
logic [6:0] funct7; 
logic [2:0] funct3;
logic [DATA_WIDTH_L-1:0] alu_out;
flag_t overflow, Z, error;
operation_t opSel;

logic rstN, wen;
regName_t rs1, rs2, rd;
logic [DATA_WIDTH_L-1:0] data_in;
logic [DATA_WIDTH_L-1:0] bus_a, bus_b;
    

reg_file reg_dut (
    .clk, 
    .rstN, 
    .wen(wen), 
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd),
    .data_in(alu_out),
    .regA_out(bus_a), 
    .regB_out(bus_b) 
);

Alu alu_dut (
    .bus_a,
    .bus_b,
    .opSel,
    .out(alu_out),
    .overflow,
    .Z
);

alu_op_unit op_dut (
    .aluOp(aluOp),
    .funct7(funct7),
    .funct3(funct3),
    .opSel,
    .error
);

/*task write_all_reg(
    // output wen,
    // output [DATA_WIDTH_L-1:0] data_in
    );
    @(posedge clk);
    wen <= 0;
    for (int i = 1; i<32; i=i+1) begin
        @(posedge clk);
        data_in <= $random;
    end
endtask //write_all_reg
*//*
1 - add     rd rs1 rs2 31..25=0  14..12=0 6..2=0x0C 1..0=3
2 - sub     rd rs1 rs2 31..25=32 14..12=0 6..2=0x0C 1..0=3
3 - sll     rd rs1 rs2 31..25=0  14..12=1 6..2=0x0C 1..0=3
4 - slt     rd rs1 rs2 31..25=0  14..12=2 6..2=0x0C 1..0=3
5 - sltu    rd rs1 rs2 31..25=0  14..12=3 6..2=0x0C 1..0=3
6 - xor     rd rs1 rs2 31..25=0  14..12=4 6..2=0x0C 1..0=3
7 - srl     rd rs1 rs2 31..25=0  14..12=5 6..2=0x0C 1..0=3
8 - sra     rd rs1 rs2 31..25=32 14..12=5 6..2=0x0C 1..0=3
9 - or      rd rs1 rs2 31..25=0  14..12=6 6..2=0x0C 1..0=3
10 -and     rd rs1 rs2 31..25=0  14..12=7 6..2=0x0C 1..0=3
*/
/*typedef enum logic [3:0] { 
    add, sub, sll, slt, sltu, xor_op, srl, sra, or_op, and_op
} rtype_inst;

task automatic rInstruction(
    input regName_t dest, src1, src2,
    input rtype_inst instruction
    // output regName_t rs1, rs2, rd, 
    // output aluOp_t aluOp,
    // output logic [6:0] funct7, 
    // output logic [2:0] funct3,
    // output logic wen
    );
    @(posedge clk);
    {rs1, rs2, rd} = {src1, src2, dest};
    wen = 1;
    aluOp = TYPE_R;
    if  (instruction != sub && instruction != sra) begin
        funct7 = 7'd0;
        case (instruction) 
            add     : funct3 = 3'd0;
            sll     : funct3 = 3'd1;
            slt     : funct3 = 3'd2;
            sltu    : funct3 = 3'd3;
            xor_op  : funct3 = 3'd4;
            srl     : funct3 = 3'd5;
            or_op   : funct3 = 3'd6;
            and_op  : funct3 = 3'd7;
        endcase
    end
    else begin
        case (instruction)
            sub : funct3 = 3'd0;
            sra : funct3 = 3'd5;
        endcase
    end 
    #(CLK_PERIOD*2);

endtask //rInstruction

initial begin
    write_all_reg();
    rInstruction(t0, a0, a1, add);
end
*/

endmodule : alu_reg_tb