module top #(
    parameter IM_MEM_DEPTH = 256
)(
    input logic clk, rstN
);

localparam INSTRUCTION_WIDTH = 32;
localparam DATA_WIDTH = 32;
localparam REG_COUNT = 32;
localparam ADDRESS_WIDTH = $clog2(IM_MEM_DEPTH);
localparam REG_SIZE = $clog2(REG_COUNT);
localparam OP_CODE_WIDTH = 7;
localparam FUNC7_WIDTH = 7;
localparam FUNC3_WIDTH = 3;


///// PC related Wires /////   
logic [INSTRUCTION_WIDTH-1:0] pcIn; 
logic pcWrite;
logic [INSTRUCTION_WIDTH-1:0] pcIF;
logic [INSTRUCTION_WIDTH-1:0] pcInc;
logic [INSTRUCTION_WIDTH-1:0] jumpAddr;
logic takeBranch;

pc PC(
    .clk(clk),
    .pcIn(pcIn),
    .pcWrite(pcWrite),
    .pcOut(pcIF)
);

pcAdd PC_Adder (
    .pcOld(pcIF),
    .pcNewFour(pcInc)
);


// PC related Modules //
assign takeBranch = branchCU & branchS;
assign pcIn = (takeBranch) ? jumpAddr : pcInc;


///// IRAM /////
logic [INSTRUCTION_WIDTH-1:0]instructionIF;

ins_memory #(
    .INSTRUCTION_WIDTH (INSTRUCTION_WIDTH),
    .MEMORY_DEPTH (IM_MEM_DEPTH)
) IRAM (
    .address(pcIF),
    .instruction(instructionIF)
);
 

///// IF/ID Pipeline Register/////
logic harzardIF_ID_Write;
logic flush;
logic [INSTRUCTION_WIDTH-1:0] pcID;

logic [INSTRUCTION_WIDTH-1:0]      instructionID;
logic [OP_CODE_WIDTH-1:0] opCode = instructionID[6:0];
logic [REG_SIZE-1:0] rdID        = instructionID[11:7];
logic [FUNC3_WIDTH-1:0] func3ID  = instructionID[14:12];
logic [REG_SIZE-1:0] rs1ID       = instructionID[19:15];
logic [REG_SIZE-1:0] rs2ID       = instructionID[24:20];
logic [FUNC7_WIDTH-1:0] func7ID  = instructionID[31:25];

pipilineRegister_IF_ID IF_ID_Register(
    .clk,
    .pcIn(pcIF),
    .instructionIn(instructionIF),
    .harzardIF_ID_Write(harzardIF_ID_Write),
    .flush(flush),
    .pcOut(pcID),
    .instructionOut(instructionID)
);


///// Control Unit /////
logic jump, jumpReg, branchCU, memReadID, memWriteID, memtoRegID, regWriteID;
logic [1:0] aluSrc1ID,aluSrc2ID;
logic [1:0] aluOpID;

control_unit CU(
    .opCode,
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
logic [REG_SIZE-1:0] rdWB;
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
logic branchS;

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
logic signed [INSTRUCTION_WIDTH-1:0] immIID, immJ, immB, immSID, immUID;

immediate_extend(
    .instruction(instructionID),
    .I_immediate(immIID),
    .S_immediate(immSID),
    .SB_immediate(immB),
    .U_immediate(immUID),
    .UJ_immediate(immJ)
);




///// ID/EX Pipeline Register /////
logic [1:0] aluSrc1EX,aluSrc2EX;
logic [1:0] aluOpEX;
logic memReadEX, memWriteEX, memtoRegEX, regWriteEX;
logic [INSTRUCTION_WIDTH-1:0] immIEX, immSEX, immUEX;
logic [REG_SIZE-1:0] rdEX;
logic [FUNC3_WIDTH-1:0] func3EX;
logic [REG_SIZE-1:0] rs1EX;
logic [REG_SIZE-1:0] rs2EX;
logic [FUNC7_WIDTH-1:0] func7EX;
logic [DATA_WIDTH-1:0] rs1DataEX, rs2DataEX;
logic [INSTRUCTION_WIDTH-1:0] pcEX;

pipilineRegister_ID_EX ID_EX_Register(
    .clk,

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


///// Alu Modules /////
logic [3:0] aluOpSel;
logic overflow, Z;
logic [DATA_WIDTH-1:0] forward1Out, forward2Out, aluIn1, aluIn2, aluOutEx;

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

assign forward1Out = rs1DataEX;
assign forward2Out = rs2DataEX;

always_comb begin : ALUIn1Select
    unique case (aluSrc1EX) 
        2'b00 : aluIn1 = forward1Out;
        2'b01 : aluIn1 = immUEX;
        2'b10 : aluIn1 = 32'd4;
endcase
    
end

always_comb begin : ALUIn2Select
    unique case (aluSrc2EX) 
        2'b00 : aluIn2 = forward2Out;
        2'b01 : aluIn2 = immIEX;
        2'b10 : aluIn2 = immSEX;
        2'b11 : aluIn2 = pcEX;
endcase
end


endmodule
