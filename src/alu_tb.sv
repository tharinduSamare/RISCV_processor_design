module alu_tb
import  alu_definitions::*,
		definitions::*;
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
logic [DATA_WIDTH_L-1:0] bus_a, bus_b;
    
Alu alu_dut (
    .bus_a(bus_a),
    .bus_b(bus_b),
    .opSel(opSel),
    .out(alu_out),
    .overflow(overflow),
    .Z(Z)
);

alu_op_unit op_dut (
    .aluOp(aluOp),
    .funct7(funct7),
    .funct3(funct3),
    .opSel,
    .error
);

// initial begin
//     bus_a = 32'd1293;
//     bus_b = 32'd12;

//     aluOp = r_type;
//     funct7 = 7'd0;

//     funct3 = add_sub;
//     #(CLK_PERIOD*2);
//     funct3 = slt;
//     #(CLK_PERIOD*2);
//     funct3 = sltu;
//     #(CLK_PERIOD*2);
//     funct3 = lxor;
//     #(CLK_PERIOD*2);
//     funct3 = lor;
//     #(CLK_PERIOD*2);
//     funct3 = land;
//     #(CLK_PERIOD*2);
//     funct3 = sll;
//     #(CLK_PERIOD*2);
//     funct3 = srl_sra;
//     #(CLK_PERIOD*2);

//     funct7 = 7'd32;
//     funct3 = add_sub;
//     #(CLK_PERIOD*2);
//     funct3 = srl_sra;
//     #(CLK_PERIOD*2);
     


// end
endmodule