module processor import definitions::*; #(
    parameter IM_MEM_DEPTH = 256,
    parameter DM_MEM_DEPTH = 4096,
    parameter INSTRUCTION_WIDTH = 32,
    parameter FUNC3_WIDTH = 3,
    parameter DATA_WIDTH = 32
)(
    // top module
    input logic clk, rstN, startProcess, 
    output logic endProcess,

    // IRAM
    input logic [INSTRUCTION_WIDTH-1:0]instructionIF,
    output logic [INSTRUCTION_WIDTH-1:0] pcIF,

    // DRAM
    input logic [DATA_WIDTH-1:0] dMOutMem,
    input logic dMReadyMem,   
    output logic memReadMeM, memWriteMeM, 
    output logic [FUNC3_WIDTH-1:0] func3MeM,
    output logic [DATA_WIDTH-1:0] aluOutMeM,
    output logic [DATA_WIDTH-1:0] rs2DataMeM
);

// localparam ZERO = 2'b00;
// localparam ONE = 2'b01;
// localparam TWO = 2'b10;
// localparam THREE = 2'b11;

localparam REG_COUNT = 32;
localparam REG_SIZE = $clog2(REG_COUNT);
localparam OP_CODE_WIDTH = 7;
localparam FUNC7_WIDTH = 7;

///// PC related Wires /////   
logic [INSTRUCTION_WIDTH-1:0] pcIn; 
logic pcWrite;

logic [INSTRUCTION_WIDTH-1:0] pcInc;
logic [INSTRUCTION_WIDTH-1:0] jumpAddr;
logic takeBranch;
logic branchCU;

pc PC(
    .rstN,
    .clk,

    .pcIn(pcIn),
    .pcWrite(pcWrite),

    .pcOut(pcIF)
);

pcAdd PC_Adder (
    .pcOld(pcIF),
    .pcNewFour(pcInc)
);

logic branchS;
// PC related Modules //
assign takeBranch = branchCU & branchS;
assign pcIn = (takeBranch) ? jumpAddr : pcInc;
 

///// IF/ID Pipeline Register/////
logic hazardIFIDWrite;
logic flush;
logic [INSTRUCTION_WIDTH-1:0] pcID;

logic [INSTRUCTION_WIDTH-1:0]      instructionID;
logic [OP_CODE_WIDTH-1:0] opCode = instructionID[6:0];
logic [FUNC3_WIDTH-1:0] func3ID  = instructionID[14:12];
regName_t                          rdID;
regName_t                          rs2ID;
regName_t                          rs2ID;
assign                     rdID  = regName_t'(instructionID[11:7]);     
assign                     rs1ID = regName_t'(instructionID[19:15]);     
assign                     rs2ID = regName_t'(instructionID[24:20]);     
logic [FUNC7_WIDTH-1:0] func7ID  = instructionID[31:25];

pipelineRegister_IF_ID IF_ID_Register(
    .clk,
    .rstN,

    .pcIn(pcIF),
    .instructionIn(instructionIF),
    .harzardIF_ID_Write(hazardIFIDWrite),
    .flush(flush),

    .pcOut(pcID),
    .instructionOut(instructionID)
);


///// Control Unit /////
logic jump, jumpReg, memReadID, memWriteID, memtoRegID, regWriteID;
alu_sel_t aluSrc1ID,aluSrc2ID;
aluOp_t aluOpID; //
logic enableCU;

control_unit CU(
    .opCode,
    .startProcess,
    .endProcess,
    
    .enable(enableCU),
    .jump,
    .jumpReg,
    .branch(branchCU),
    .memRead(memReadID),
    .memWrite(memWriteID),
    .memtoReg(memtoRegID),
    .regWrite(regWriteID),
    .aluSrc1(aluSrc1ID),
    .aluSrc2(aluSrc2ID),
    .aluOp(aluOpID)
);


///// Register File /////
logic regWriteWB;
regName_t rdWB;
logic [DATA_WIDTH-1:0] dataInWB;
logic [DATA_WIDTH-1:0] rs1DataID, rs2DataID;

reg_file #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_COUNT(REG_COUNT)
)Reg_File(
    .clk,
    .rstN,

    .wen(regWriteWB),
    .rs1(rs1ID),
    .rs2(rs2ID),
    .rd(rdWB),
    .data_in(dataInWB),

    .regA_out(rs1DataID),
    .regB_out(rs2DataID)
);


/// Branching Modules /////
logic [INSTRUCTION_WIDTH-1:0] jumpOp1;
logic [INSTRUCTION_WIDTH-1:0] jumpOp2;


logic signed [INSTRUCTION_WIDTH-1:0] immIID, immJ, immB, immSID, immUID;

pcBranchType #(
    .DATA_WIDTH(DATA_WIDTH)
) BranchTypeSelection (
    .read1(rs1DataID),
    .read2(rs2DataID),
    .branchType(func3ID),

    .branchN(branchS)
);

assign jumpOp1 = (jumpReg) ? rs1DataID : pcID;
always_comb begin : BranchImm
    if(jumpReg) jumpOp2 = immIID;
    else if(jump) jumpOp2 = immJ;
    else if(branchCU) jumpOp2 = immB;
    else jumpOp2 = '0;
end
assign jumpAddr = jumpOp1 + jumpOp2;


///// Extender Module /////


immediate_extend immediate_extend(
    .instruction(instructionID),

    .I_immediate(immIID),
    .S_immediate(immSID),
    .SB_immediate(immB),
    .U_immediate(immUID),
    .UJ_immediate(immJ)
);

logic memReadEX, memWriteEX, memtoRegEX, regWriteEX;
logic [REG_SIZE-1:0] rdEX;
////// Hazard Unit //////
hazard_unit Hazard_Unit(
    .clk,
    .rstN,

    .IF_ID_rs1(rs1ID),
    .IF_ID_rs2(rs2ID),
    .ID_Ex_rd(rdEX),
    .ID_Ex_MemRead(memReadEX), 
    .ID_Ex_MemWrite(memWriteEX),
    .mem_ready(dMReadyMem),

    .IF_ID_write(hazardIFIDWrite),
    .PC_write(pcWrite),
    .ID_Ex_enable(enableCU)
);

///// ID/EX Pipeline Register /////
alu_sel_t aluSrc1EX,aluSrc2EX;
aluOp_t aluOpEX;

logic [INSTRUCTION_WIDTH-1:0] immIEX, immSEX, immUEX;
<<<<<<< HEAD

=======
>>>>>>> main
logic [FUNC3_WIDTH-1:0] func3EX;
regName_t rdEX;
regName_t rs1EX;
regName_t rs2EX;
logic [FUNC7_WIDTH-1:0] func7EX;
logic [DATA_WIDTH-1:0] rs1DataEX, rs2DataEX;
logic [INSTRUCTION_WIDTH-1:0] pcEX;

pipelineRegister_ID_EX ID_EX_Register(
    .clk,
    .rstN,

    .pcIn(pcID),
    .aluSrc1_IDIn(aluSrc1ID),
    .aluSrc2_IDIn(aluSrc2ID),
    .aluOp_IDIn(aluOpID),

    .memWrite_IDIn(memWriteID),
    .memRead_IDIn(memReadID),
    .regWrite_IDIn(regWriteID),
    .memToRegWrite_IDIn(memtoRegID),

    .func7_IDIn(func7ID),
    .func3_IDIn(func3ID),
    .read1_IDIn(rs1DataID),
    .read2_IDIn(rs2DataID),

    .I_imme_IDIn(immIID),
    .S_imme_IDIn(immSID),
    .U_imme_IDIn(immUID),

    .rd_IDIn(rdID),
    .rs1_IDIn(rs1ID),
    .rs2_IDIn(rs2ID),

    .pcOut(pcEX),
    .aluSrc1_IDOut(aluSrc1EX),
    .aluSrc2_IDOut(aluSrc2EX),
    .aluOp_IDOut(aluOpEX),

    .memWrite_IDOut(memWriteEX),
    .memRead_IDOut(memReadEX),
    .regWrite_IDOut(regWriteEX),
    .memToRegWrite_IDOut(memtoRegEX),

    .func7_IDOut(func7EX),
    .func3_IDOut(func3EX),
    .read1_IDOut(rs1DataEX),
    .read2_IDOut(rs2DataEX),

    .I_imme_IDOut(immIEX),
    .S_imme_IDOut(immSEX),
    .U_imme_IDOut(immUEX),

    .rd_IDOut(rdEX),
    .rs1_IDOut(rs1EX),
    .rs2_IDOut(rs2EX)

);


logic memtoRegMeM, regWriteMeM;
logic [REG_SIZE-1:0] rdMeM;
///// Data Forwarding Units /////
logic [1:0] forwardSel1, forwardSel2;
logic [DATA_WIDTH-1:0] forwardOut1, forwardOut2;

data_forwarding #(
    .DATA_WIDTH(DATA_WIDTH),
    .REG_SIZE(REG_SIZE)
) Data_Forward_Unit(
    .mem_regWrite(regWriteMeM),
    .wb_regWrite(regWriteWB),
    .mem_rd(rdMeM),
    .wb_rd(rdWB),
    .ex_rs1(rs1EX),
    .ex_rs2(rs2EX),

    .df_mux1(forwardSel1),
    .df_mux2(forwardSel2)
);

always_comb begin : DataForward1
    unique case (forwardSel1) 
        ZERO : forwardOut1 = rs1DataEX;
        ONE : forwardOut1 = aluOutMeM;
        TWO : forwardOut1 = dataInWB;
endcase
end

always_comb begin : DataForward2
    unique case (forwardSel2) 
        ZERO : forwardOut2 = rs2DataEX;
        ONE : forwardOut2 = aluOutMeM;
        TWO : forwardOut2 = dataInWB;
endcase
end


///// Alu Modules /////
logic [3:0] aluOpSel;
logic overflow, Z;
logic [DATA_WIDTH-1:0] aluIn1, aluIn2, aluOutEx;

alu_op #(
    .DATA_WIDTH(DATA_WIDTH)
) ALU_OpSelect(
    .aluOp(aluOpEX),
    .funct7(func7EX),
    .funct3(func3EX),

    .opSel(aluOpSel)
);

alu #(
    .DATA_WIDTH(DATA_WIDTH)
) ALU (
    .bus_a(aluIn1),
    .bus_b(aluIn2),
    .opSel(aluOpSel),

    .out(aluOutEx),
    .overflow,
    .Z
);

// assign forward1Out = rs1DataEX;
// assign forward2Out = rs2DataEX;

always_comb begin : ALUIn1Select
    unique case (aluSrc1EX) 
        ZERO : aluIn1 = forwardOut1;
        ONE : aluIn1 = immUEX;
        TWO : aluIn1 = 32'd4;
endcase  
end

always_comb begin : ALUIn2Select
    unique case (aluSrc2EX) 
        ZERO : aluIn2 = forwardOut2;
        ONE : aluIn2 = immIEX;
        TWO : aluIn2 = immSEX;
        THREE : aluIn2 = pcEX;
endcase
end


///// EX/MEM Pipeline Register /////
logic memtoRegMeM, regWriteMeM;
regName_t rdMeM;

pipelineRegister_EX_MEM EX_MEM_Register (
    .clk,
    .rstN,

    .memWrite_EX_IN(memWriteEX),
    .memRead_EX_IN(memReadEX),
    .regWrite_EX_IN(regWriteEX),
    .memToRegWrite_EX_IN(memtoRegEX),
    .func3_EX_IN(func3EX),
    .aluOut_EX_IN(aluOutEx),
    .aluSrc2_EX_IN(forwardOut2),//(rs2DataEX),
    .rd_EX_IN(rdEX),

    .memWrite_EX_Out(memWriteMeM),
    .memRead_EX_Out(memReadMeM),
    .regWrite_EX_Out(regWriteMeM),
    .memToRegWrite_EX_Out(memtoRegMeM),
    .func3_EX_Out(func3MeM),
    .aluOut_EX_Out(aluOutMeM),
    .aluSrc2_EX_Out(rs2DataMeM),
    .rd_EX_Out(rdMeM)
);


///// Mem/WB Pipeline Register /////
logic memtoRegWB;
logic [DATA_WIDTH-1:0] aluOutWB;
logic [DATA_WIDTH-1:0] dMOutWB;

pipelineRegister_MEM_WB MEM_WB_Register (
    .clk,
    .rstN,

    .regWrite_Mem_In(regWriteMeM),
    .memToRegWrite_Mem_In(memtoRegMeM),
    .readD_Mem_In(dMOutMem),
    .aluOut_Mem_In(aluOutMeM),
    .rd_Mem_In(rdMeM),

    .regWrite_Mem_Out(regWriteWB),
    .memToRegWrite_Mem_Out(memtoRegWB),
    .readD_Mem_Out(dMOutWB),
    .aluOut_Mem_Out(aluOutWB),
    .rd_Mem_Out(rdWB)

);

//// RegFile Data /////
assign dataInWB = memtoRegWB ? dMOutWB : aluOutWB;

endmodule : processor
