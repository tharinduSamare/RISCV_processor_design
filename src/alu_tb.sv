module alu_tb
// import  alu_definitions::*,
import 	definitions::*;
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
alu_operation_t opSel;
logic [DATA_WIDTH_L-1:0] bus_a, bus_b;
    
alu alu_dut (
    .bus_a(bus_a),
    .bus_b(bus_b),
    .opSel(opSel),
    .out(alu_out),
    .overflow(overflow),
    .Z(Z)
);

alu_op op_dut (
    .aluOp(aluOp),
    .funct7(funct7),
    .funct3(funct3),
    .opSel,
    .error
);

localparam logic [2:0]  // RISCV-32I alu operations
    add_sub = 3'd0,
    sll     = 3'd1,
    slt     = 3'd2,
    sltu    = 3'd3,
    lxor    = 3'd4,
    srl_sra = 3'd5,
    lor     = 3'd6,
    land    = 3'd7;
localparam logic [2:0]
    mul     = 3'd0,
    mulh    = 3'd1,
    mulhsu  = 3'd2,
    mulhu   = 3'd3,
    div     = 3'd4,
    divu    = 3'd5,
    rem     = 3'd6,
    remu    = 3'd7;

initial begin
    // bus_a = 32'b1000_0111_0001_1000_1100;
    bus_a = 32'b11111111111111111111011010100000;
    // bus_a = 32'd134;
    // bus_b = 32'd12;
    bus_b = 32'b11111111111111111111111111110100;

    aluOp = TYPE_R;
    funct7 = 7'd1;

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