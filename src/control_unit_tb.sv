
module control_unit_tb import definitions::*;();
timeunit 1ns;
timeprecision 1ps;
    
logic [6:0] opCode;

logic enable, startProcess, endProcess, error;

logic jump, jumpReg, branch, memRead, memWrite, memtoReg, regWrite;

alu_sel_t aluSrc1, aluSrc2;
aluOp_t aluOp;

control_unit dut(.*);

opCode_t opCodeEnum;

always_comb begin : opcodeConversion
    case (opCodeEnum)
        LTYPE:opCode = 7'b0000011;
        ITYPE:opCode = 7'b0010011;
        AUIPC:opCode = 7'b0010111;
        STYPE:opCode = 7'b0100011;
        RTYPE:opCode = 7'b0110011;
        LUI  :opCode = 7'b0110111;  
        BTYPE:opCode = 7'b1100011;
        JALR :opCode = 7'b1100111; 
        JTYPE:opCode = 7'b1101111;
        ERROR:opCode = 7'b1111111;
    endcase   
end


localparam CLK_PERIOD = 10;
logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

initial begin
    @(posedge clk);
    enable <= '0;
    startProcess <= '1;

    #(CLK_PERIOD);
    enable <= '1;
    // opCode <= 7'b1100011; //branch
    opCodeEnum <= BTYPE;

    #(CLK_PERIOD);
    // opCode <= 7'b1101111; //J type
    opCodeEnum <= JTYPE;

    #(CLK_PERIOD);
    // opCode <= 7'b0010011; //I type
    opCodeEnum <= ITYPE;
    #(CLK_PERIOD);
    opCodeEnum <= ITYPE;
    #(CLK_PERIOD);
    opCodeEnum <= ITYPE;
    #(CLK_PERIOD);
    opCodeEnum <= ITYPE;
    #(CLK_PERIOD);   
    $stop;
end
endmodule
