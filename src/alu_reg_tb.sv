module alu_reg_tb
// import  alu_definitions::*,
import definitions::*,
        reg_names::*;   
();
timeunit 1ns;
timeprecision 1ps;

localparam ZERO = 2'b00;
localparam ONE = 2'b01;
localparam TWO = 2'b10;
localparam THREE = 2'b11;

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
alu_operation_t opSel;

logic rstN, wen;
regName_t rs1, rs2, rd;
logic [DATA_WIDTH_L-1:0] data_in;
logic [DATA_WIDTH_L-1:0] bus_a, bus_b;
logic [DATA_WIDTH_L-1:0] regOut1,immUEX,regOut2,immIEX,immSEX,pcEX; 
logic [2:0] aluSrc1, aluSrc2;

reg_file reg_dut (
    .clk, 
    .rstN, 
    .wen(wen), 
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd),
    .data_in(data_in),
    .regA_out(regOut1), 
    .regB_out(regOut2) 
);

always_comb begin : ALUIn1Select
    unique case (aluSrc1) 
        ZERO : bus_a = regOut1;
        ONE : bus_a = immUEX;
        TWO : bus_a = 32'd4;
    endcase  
end

always_comb begin : ALUIn2Select
    unique case (aluSrc2) 
        ZERO : bus_b = regOut2;
        ONE : bus_b = immIEX;
        TWO : bus_b = immSEX;
        THREE : bus_b = pcEX;
    endcase
end

alu alu_dut (
    .bus_a,
    .bus_b,
    .opSel,
    .out(alu_out),
    .overflow,
    .Z
);

alu_op op_dut (
    .aluOp(aluOp),
    .funct7(funct7),
    .funct3(funct3),
    .opSel,
    .error
);

logic [4:0] sample;
task write_all_reg();
    @(posedge clk);
    wen = 1;
    rd = rd.first;
    for (int i = 1; i<32; i=i+1) begin
        @(posedge clk);
        if (rd == s0) begin 
            sample = $random;
            data_in = sample;
        end
        else data_in = $random;
        rd = rd.next;
    end
endtask //write_all_reg
/*
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
typedef enum logic [3:0] { 
    add, sub, sll, slt, sltu, xor_op, srl, sra, or_op, and_op
} rtype_inst;

task automatic rInstruction(
    input regName_t dest, src1, src2,
    input rtype_inst instruction
    );
    @(posedge clk);
    {rs1, rs2, rd} <= {src1, src2, dest};
    aluSrc1 <= ZERO;
    aluSrc2 <= ZERO;
    wen <= 1;
    aluOp <= TYPE_R;
    if  (instruction != sub && instruction != sra) begin
        funct7 <= 7'd0;
        case (instruction) 
            add     : funct3 <= 3'd0;
            sll     : funct3 <= 3'd1;
            slt     : funct3 <= 3'd2;
            sltu    : funct3 <= 3'd3;
            xor_op  : funct3 <= 3'd4;
            srl     : funct3 <= 3'd5;
            or_op   : funct3 <= 3'd6;
            and_op  : funct3 <= 3'd7;
        endcase
    end
    else begin
        funct7 <= 7'd32;
        case (instruction)
            sub : funct3 <= 3'd0;
            sra : funct3 <= 3'd5;
        endcase
    end 
    #(CLK_PERIOD*2);

endtask //rInstruction

task automatic iInstruction(
    input regName_t dest, src1,
    input logic [DATA_WIDTH_L-1:0] imm,
    input rtype_inst instruction
);
    @(posedge clk);
    {rs1, rd} <= {src1, dest};
    aluOp <= TYPE_I;
    wen <= 1;
    case (instruction)
        add: funct3 = 3'd0;
        slt: funct3 = 3'd2;
        xor_op:funct3 = 3'd4;
        or_op: funct3 = 3'd6;
        and_op:funct3 = 3'd7;
    endcase 
endtask //iInstruction

initial begin
    rstN <= 1;
    write_all_reg();
    rInstruction(t0, a0, a1, add);
    rInstruction(t1, a0, a1, xor_op);
    rInstruction(t2, s2 ,a0, sub);
    rInstruction(t3, a3 ,s1, sll);
    rInstruction(t4, a4 ,s3, sltu);
    rInstruction(t5, a5 ,s1, srl);
    rInstruction(t6, a6 ,s5, or_op);
    rInstruction(t0, a7 ,s6, and_op);
    
end


endmodule : alu_reg_tb