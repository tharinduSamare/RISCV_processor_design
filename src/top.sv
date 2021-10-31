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


///// PC Module /////   
logic [INSTRUCTION_WIDTH-1:0] pcIn; 
logic pcWrite;
logic [INSTRUCTION_WIDTH-1:0] pcIF;
logic [INSTRUCTION_WIDTH-1:0] pcInc;
logic [INSTRUCTION_WIDTH-1:0] jumpAddr;

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

// mux PC_Select (
//     .dataIn(pcInc, jumpAddr),
//     .dataOut(pcIn)
// );


///// IM /////
// logic [ADDRESS_WIDTH-1:0]address,
logic [INSTRUCTION_WIDTH-1:0]instructionIF;
// ins_memory #(
//     INSTRUCTION_WIDTH = INSTRUCTION_WIDTH,
//     MEMORY_DEPTH = IM_MEM_DEPTH
// ) IM (

// );


///// IF/ID Pipeline Register/////
logic harzardIF_ID_Write;
logic flush;
logic [INSTRUCTION_WIDTH-1:0] pcID;
logic [INSTRUCTION_WIDTH-1:0] instructionID;

pipilineRegister_IF_ID IF_ID_Register(
    .pcIn(pcIF),
    .instructionIn(instructionIF),
    .harzardIF_ID_Write(harzardIF_ID_Write),
    .flush(flush),
    .pcOut(pcID),
    .instructionOut(instructionID)
);


///// Control Unit /////
logic [OP_CODE_WIDTH-1:0] opCode = instructionID[31:25];
logic jump, jumpReg, branch, memReadID, memWriteID, memtoRegID, regWriteID;
logic [1:0] aluSrc1ID,aluSrc2ID;
logic [1:0] aluOpID;

control_unit CU(
    .opCode,
    .jump,
    .jumpReg,
    .branch,
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
logic [REG_SIZE-1:0] rs1ID = instructionID[19:15];
logic [REG_SIZE-1:0] rs2ID = instructionID[24:20];
logic [REG_SIZE-1:0] rdWB;
logic [DATA_WIDTH-1:0] dataInWB;
logic [DATA_WIDTH-1:0] rs1DataID, rs2DataID;

reg_file Reg_File(
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

//// Extender Module /////
    // input logic [31:0]instruction,
    // output logic signed [31:0] I_immediate, S_immediate, SB_immediate, U_immediate, UJ_immediate
// immediate_extend(
//     .instruction()
// );
endmodule
