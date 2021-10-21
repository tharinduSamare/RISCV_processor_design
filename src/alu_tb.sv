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

logic [DATA_WIDTH-1:0] read1, read2, write, imm, b_current;

logic aluSrc2;
logic [1:0] aluOp;
logic [6:0] funct7; 
logic [2:0] funct3;
logic [DATA_WIDTH-1:0] out;
logic overflow, Z;
logic [3:0] opSel_current;


alu_mux2 mux (
    .aluSrc2(aluSrc2),
    .imm(imm),
    .read2(read2),
    .bus_b(b_current)
);
    
alu alu (
    .bus_a(read1),
    .bus_b(b_current),
    .opSel(opSel_current),
    .out(out),
    .overflow(overflow),
    .Z(Z)
);

alu_op op (
    .aluOp(aluOp),
    .funct7(funct7),
    .funct3(funct3),
    .opSel(opSel_current)
);

typedef enum logic [2:0] { //12-14 in ISA
    add_sub = 3'd0,
    sll     = 3'd1,
    slt     = 3'd2,
    sltu    = 3'd3,
    lxor    = 3'd4,
    srl_sra = 3'd5,
    lor     = 3'd6,
    land    = 3'd7
} funct3_op;

    
typedef enum logic [1:0] { 
    i_type = 2'b11, 
    r_type = 2'b10, 
    u_type = 2'b01,
    no_op  = 2'b00
} ins_type;

initial begin
    read1 = 32'd1293;
    read2 = 32'd12;

    aluSrc2 = 0;
    aluOp = r_type;
    funct7 = 7'd0;

    funct3 = add_sub;
    #(CLK_PERIOD*2);
    funct3 = slt;
    #(CLK_PERIOD*2);
    funct3 = sltu;
    #(CLK_PERIOD*2);
    funct3 = lxor;
    #(CLK_PERIOD*2);
    funct3 = lor;
    #(CLK_PERIOD*2);
    funct3 = land;
    #(CLK_PERIOD*2);
    funct3 = sll;
    #(CLK_PERIOD*2);
    funct3 = srl_sra;
    #(CLK_PERIOD*2);

    funct7 = 7'd32;
    funct3 = add_sub;
    #(CLK_PERIOD*2);
    funct3 = srl_sra;
    #(CLK_PERIOD*2);
     


end
endmodule