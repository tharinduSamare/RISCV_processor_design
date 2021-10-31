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
logic [INSTRUCTION_WIDTH-1:0] jumpOp1;
logic [INSTRUCTION_WIDTH-1:0] jumpOp2;
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

// pc mux //
assign takeBranch = branchCU & branchS;
assign pcIn = (takeBranch) ? jumpAddr : pcInc;
assign jumpOp1 = (jumpReg) ? rs1DataID : pcID;
assign jumpAddr = jumpOp1 + jumpOp2;

always_comb begin : BranchImm
    if(jumpReg) jumpOp2 = immIID;
    else if(jump) jumpOp2 = immUJ;
    else if(branch) jumpOp2 = immSB;
    else jumpOp2 = '0;
end

 
/// Branch Type Select Module /////
logic branchS;
logic [2:0] func3ID = instructionID[14:12];
pcBranchType #(
    .DATA_WIDTH(DATA_WIDTH)
) BranchTypeSelection (
    .read1(rs1DataID),
    .read2(rs2DataID),
    .branchType(func3ID),
    .branchN(branchS)
);

// // Extender Module /////
logic signed [INSTRUCTION_WIDTH-1:0] immIID;
logic signed [INSTRUCTION_WIDTH-1:0] immUJ;
logic signed [INSTRUCTION_WIDTH-1:0] immSB;
//     input logic [31:0]instruction,
//     output logic signed [31:0] I_immediate, S_immediate, SB_immediate, U_immediate, UJ_immediate
// immediate_extend(
//     .instruction()
// );

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
logic [INSTRUCTION_WIDTH-1:0] instructionID;

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
logic [OP_CODE_WIDTH-1:0] opCode = instructionID[31:25];
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
logic [REG_SIZE-1:0] rs1ID = instructionID[19:15];
logic [REG_SIZE-1:0] rs2ID = instructionID[24:20];
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


///// ID/EX Pipeline Register /////

    // // other signals to exe stage
    // input logic [7 : 0]     func7_IDIn,
    // input logic [2 : 0]     func3_IDIn,
    // input logic [15 : 0]    read1_IDIn,
    // input logic [15 : 0]    read2_IDIn,
    
    // input logic [31 : 0]    I_imme_IDIn,
    // input logic [31 : 0]    S_imme_IDIn,
    // input logic [31 : 0]    U_imme_IDIn,

    // input logic [4 : 0]     rd_IDIn,
    // input logic [4 : 0]     rs1_IDIn,
    // input logic [4 : 0]     rs2_IDIn,

    
    // //pipelined outputs
    // //to execution stage
    // output logic [1:0]      aluSrc_ID1Out,
    // output logic [1:0]      aluSrc2_IDOut,
    // output logic [1:0]      aluOp_IDOut,

    
    // // to memory stage
    // output logic             memWrite_IDOut,
    // output logic             memRead_IDOut,
    
    // // to writeback stage
    // output logic             regWrite_IDOut,
    // output logic             memToRegWrite_IDOut,

    // // other signals to exe stage
    // output logic [7 : 0]    func7_IDOut,
    // output logic [2 : 0]    func3_IDOut,
    // output logic [15 : 0]   read1_IDOut,
    // output logic [15 : 0]   read2_IDOut,
    
    // output logic [31 : 0] I_imme_IDOut,
    // output logic [31 : 0] S_imme_IDOut,
    // output logic [31 : 0] U_imme_IDOut,

    // output logic [4 : 0] rd_IDOut,
    // output logic [4 : 0] rs1_IDOut,
    // output logic [4 : 0] rs2_IDOut
// pipilineRegister_ID_EX ID_EX_Register(
//     .aluSrc1_IDIn(aluSrc1ID),
//     .aluSrc2_IDIn(aluSrc2ID),
//     .aluOp_IDIn(aluOpID),

//     .memWrite_IDIn(memWriteID),
//     .memRead_IDIn(memReadID),
//     .regWrite_IDIn(regWriteID),
//     .memToRegWrite_IDIn(memtoRegID),

// );
endmodule
