`timescale 1ns / 1ps
module pcBranchLogic_tb();
    logic       clk;
    logic [2:0] funct3;
    logic       branch;
    logic [2:0] branchType;
    logic       takeBranch;

    localparam CLOCK_PERIOD = 20;
    initial begin
        clk <= 0;
            forever begin
                #(CLOCK_PERIOD/2) clk <= ~clk;
            end
    end

    pcBranch dut (
        .funct3(funct3),
        .branch(branch),
        .branchType(branchType),
        .takeBranch(takeBranch)
    );

    typedef enum logic [2:0] {  
        BEQ = 3'b000,
        BNE = 3'b001,
        BLT = 3'b010,
        BLE = 3'b011,
        BGE = 3'b100,
        BLTU = 3'b101,
        BGEU = 3'b111
    } brachn_;

    initial begin
        branch ='1;
        #(CLOCK_PERIOD*2);
        funct3 = BEQ;

        #(CLOCK_PERIOD*2);
        funct3 = BNE;
        
        #(CLOCK_PERIOD*2);
        funct3 = BLT;
        
        #(CLOCK_PERIOD*2);
        funct3 = BLE;

        #(CLOCK_PERIOD*2);
        funct3 = BGE;

        #(CLOCK_PERIOD*2);
        funct3 = BLTU;
        
        #(CLOCK_PERIOD*2);
        funct3 = BGEU;

        #(CLOCK_PERIOD*2);
        $stop;
    end
endmodule
