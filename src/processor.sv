/* 
    module which contain the entire pipeline processor except the memory modules.
    wires are marked with these suffixes

    IF - Instruction Fetch stage
    ID - Instruction Decode stage
    Ex - Execution stage
    Mem- Memory stage
    Wb - Writeback/final stage
    CU - control unit output
    HU - hazard unit output
*/

module processor import definitions::*; #(
    parameter IM_MEM_DEPTH = 256,
    parameter DM_MEM_DEPTH = 4096,
    parameter INSTRUCTION_WIDTH = 32,
    parameter FUNC3_WIDTH = 3,
    parameter DATA_WIDTH = 32
)(
    // with top module
    input logic clk, rstN, startProcess, 
    output logic endProcess,

    // connections between Fetch stage and IRAM
    input logic [INSTRUCTION_WIDTH-1:0]instructionIF,
    output logic [INSTRUCTION_WIDTH-1:0] pcIF,

    // connections between Mem stage and DRAM 
    input logic [DATA_WIDTH-1:0] dMOutMem,
    input logic dMReadyMem,   
    output logic memReadMeM, memWriteMeM, 
    output logic [FUNC3_WIDTH-1:0] func3MeM,
    output logic [DATA_WIDTH-1:0] aluOutMeM,
    output logic [DATA_WIDTH-1:0] rs2DataMeM
);

localparam REG_COUNT = 32;
localparam REG_SIZE = $clog2(REG_COUNT);
localparam OP_CODE_WIDTH = 7;
localparam FUNC7_WIDTH = 7;

///// PC related Wires /////   
logic [INSTRUCTION_WIDTH-1:0] pcIn; 
logic pcWriteHU;
logic [INSTRUCTION_WIDTH-1:0] pcIncIF;
logic [INSTRUCTION_WIDTH-1:0] jumpAddrIF;
logic [INSTRUCTION_WIDTH-1:0] pcID;

///// Branch, Jump wires ///////
logic [INSTRUCTION_WIDTH-1:0] jumpOp1ID;
logic [INSTRUCTION_WIDTH-1:0] jumpOp2ID;
// top 
logic takeBranchIF;
// CU
logic branchCU;
logic jumpCU, jumpRegCU;
// HU
logic branchHU,jumpRegHU;
// B_Type
logic branchSID;
// Hazard
logic pcStallHU;

logic IFIDWriteHU;
logic enableCUHU;

// ID stage wires
logic [INSTRUCTION_WIDTH-1:0] instructionID;
logic [OP_CODE_WIDTH-1:0] opCodeID;
logic [FUNC3_WIDTH-1:0] func3ID;
regName_t rdID;
regName_t rs1ID;
regName_t rs2ID;
logic [FUNC7_WIDTH-1:0] func7ID;

logic memReadID, memWriteID, memtoRegID, regWriteID;

alu_sel1_t aluSrc1ID;
alu_sel2_t aluSrc2ID;
aluOp_t aluOpID; 

// ID stage forwarding wires 
logic [DATA_WIDTH-1:0]rs1ForwardValID, rs2ForwardValID;
logic rs1ForwardID, rs2ForwardID;

// regfile outputs
logic [DATA_WIDTH-1:0] rs1DataID, rs2DataID;

// Immediate wires
logic signed [INSTRUCTION_WIDTH-1:0] immIID, immJID, immBID, immSID, immUID;

// EX stage wires 
logic memReadEX, memWriteEX, memtoRegEX, regWriteEX;
logic [INSTRUCTION_WIDTH-1:0] immIEX, immSEX, immUEX;
logic [FUNC3_WIDTH-1:0] func3EX;
regName_t rdEX;
regName_t rs1EX;
regName_t rs2EX;
logic [FUNC7_WIDTH-1:0] func7EX;
logic [DATA_WIDTH-1:0] rs1DataEX, rs2DataEX;
logic [INSTRUCTION_WIDTH-1:0] pcEX;

// EX stage forwarding wires
forward_mux_t forwardSel1Ex, forwardSel2Ex;
logic [DATA_WIDTH-1:0] forwardOut1Ex, forwardOut2Ex;

// ALU wires
alu_sel1_t aluSrc1EX;
alu_sel2_t aluSrc2EX;
aluOp_t aluOpEX;

alu_operation_t aluOpSelEx;
flag_t overflow, Z,error;
logic [DATA_WIDTH-1:0] aluIn1Ex, aluIn2Ex, aluOutEx;

// memstage wires
logic memtoRegMeM, regWriteMeM;
regName_t rdMeM;

// writeback wires
logic regWriteWB;
regName_t rdWB;
logic [DATA_WIDTH-1:0] dataInWB;
logic memtoRegWB;
logic [DATA_WIDTH-1:0] aluOutWB;
logic [DATA_WIDTH-1:0] dMOutWB;


///// Instruction decode ////
assign opCodeID = instructionID[6:0];
assign func3ID  = instructionID[14:12];
assign rdID  = regName_t'(instructionID[11:7]);     
assign rs1ID = regName_t'(instructionID[19:15]);     
assign rs2ID = regName_t'(instructionID[24:20]);     
assign func7ID  = instructionID[31:25];


// PC related Modules //
pc PC(
    .rstN,
    .clk,

    .pcIn(pcIn),
    .pcWrite(pcWriteHU),

    .pcOut(pcIF),
    .startProcess(startProcess)
);

pcAdd PC_Adder (
    .pcOld(pcIF),
    .pcNewFour(pcIncIF)
);

///// IF/ID Pipeline Register/////
pipelineRegister_IF_ID IF_ID_Register(
    .clk,
    .rstN,
    .startProcess(startProcess),

    .pcIn(pcIF),
    .instructionIn(instructionIF),
    .harzardIF_ID_Write(IFIDWriteHU),
    .IF_flush(takeBranchIF),

    .pcOut(pcID),
    .instructionOut(instructionID)
);

///// control unit //////
control_unit CU(
    .opCodeID,
    .enable(enableCUHU),

    .endProcess,
    .jump(jumpCU),
    .jumpReg(jumpRegCU),
    .branch(branchCU),
    .memRead(memReadID),
    .memWrite(memWriteID),
    .memtoReg(memtoRegID),
    .regWrite(regWriteID),
    .aluSrc1(aluSrc1ID),
    .aluSrc2(aluSrc2ID),
    .aluOp(aluOpID)
);

///// register file /////
reg_file #(
    .DATA_WIDTH(DATA_WIDTH)
) Reg_File (
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

//// data forwarding,  branch - mem stage ////
reg_out_forwarding_unit #(.DATA_WIDTH(DATA_WIDTH)) reg_out_forward(
    .read1(rs1DataID),
    .read2(rs2DataID),

    .rs1(rs1ID), .rs2(rs2ID),   
    .rdMeM(rdMeM),
    .aluOutMeM(aluOutMeM),
    .regWriteMeM(regWriteMeM),
 
    .read1_out(rs1ForwardValID), .read2_out(rs2ForwardValID),
    .rs1_forward(rs1ForwardID), .rs2_forward(rs2ForwardID)
);

//// branch detection module ////////
pcBranchType #(
    .DATA_WIDTH(DATA_WIDTH)
) BranchTypeSelection (
    .branch(branchCU),
    .read1(rs1DataID),
    .read2(rs2DataID),
    .branchType(func3ID),

    .read1_forward_val(rs1ForwardValID), .read2_forward_val(rs2ForwardValID),
    .read1_forward(rs1ForwardID), .read2_forward(rs2ForwardID),

    .branchN(branchSID)
);

/// Branching Modules /////
// jump opcode 1 and jump opcode 2 selection
assign jumpOp1ID = (jumpRegCU) ? ((rs1ForwardID)? rs1ForwardValID: rs1DataID): pcID;
always_comb begin : BranchImm
    if(jumpRegCU) jumpOp2ID = immIID;
    else if(jumpCU) jumpOp2ID = immJID;
    else if(branchCU) jumpOp2ID = immBID;
    else jumpOp2ID = '0;
end

// jump address
assign jumpAddrIF = jumpOp1ID + jumpOp2ID;

///// Immediate Extender Module /////
immediate_extend immediate_extend(
    .instruction(instructionID[31:7]),
    .I_immediate(immIID),
    .S_immediate(immSID),
    .SB_immediate(immBID),
    .U_immediate(immUID),
    .UJ_immediate(immJID)
);

////// Hazard Unit //////
// control the pipeline by stalling, freezing when it is necessary
hazard_unit Hazard_Unit(
    .clk,
    .rstN,

    .rs1ID(rs1ID),
    .rs2ID(rs2ID),
    .rdEx(rdEX),
    .ID_Ex_MemRead(memReadEX), 
    .ID_Ex_MemWrite(memWriteEX),
    .mem_ready(dMReadyMem),
    .regWriteEX(regWriteEX),
    .branchCU(branchCU),
    .jumpRegCU(jumpRegCU),

    .branchHU(branchHU),
    .jumpRegHU(jumpRegHU),
    .IF_ID_write(IFIDWriteHU),
    .PC_write(pcWriteHU),
    .ID_Ex_enable(enableCUHU),
    .pcStall(pcStallHU) 
);

//// select the address to set the input of the next PC value
assign takeBranchIF = (jumpCU | jumpRegHU | (branchHU & branchSID));
// if PC stall, hold the current PC address
assign pcIn = (takeBranchIF) ? jumpAddrIF : (pcStallHU)? pcIF : pcIncIF;

///// ID/EX Pipeline Register /////
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

//// data forwarding unit ////
// check for the dependencies and send selection signals the forwarding muxes
data_forwarding #(
    .DATA_WIDTH(DATA_WIDTH)
) Data_Forward_Unit(
    .mem_regWrite(regWriteMeM),
    .wb_regWrite(regWriteWB),
    .mem_rd(rdMeM),
    .wb_rd(rdWB),
    .ex_rs1(rs1EX),
    .ex_rs2(rs2EX),

    .df_mux1(forwardSel1Ex),
    .df_mux2(forwardSel2Ex)
);

//// forwarding mux 1 ////
always_comb begin : DataForward1
     case (forwardSel1Ex) 
        MUX_REG : forwardOut1Ex = rs1DataEX;
        MUX_MEM : forwardOut1Ex = aluOutMeM;
        MUX_WB : forwardOut1Ex = dataInWB;
	  default : forwardOut1Ex = rs1DataEX;
endcase
end

//// forwarding mux 1 ////
always_comb begin : DataForward2
     case (forwardSel2Ex) 
        MUX_REG : forwardOut2Ex = rs2DataEX;
        MUX_MEM : forwardOut2Ex = aluOutMeM;
        MUX_WB : forwardOut2Ex = dataInWB;
		  default : forwardOut2Ex = rs2DataEX;
endcase
end


//// alu operation selection unit ////
alu_op ALU_OpSelect(
    .aluOp(aluOpEX),
    .funct7(func7EX),
    .funct3(func3EX),

    .opSel(aluOpSelEx),
    .error(error)
);


//// alu input selection mux ////
always_comb begin : ALUIn1Select //input port 1
    case (aluSrc1EX) 
        MUX_FORWARD1 : aluIn1Ex = forwardOut1Ex;
        MUX_UTYPE : aluIn1Ex = immUEX;
        MUX_INC : aluIn1Ex = 32'd4;
		  default : aluIn1Ex = forwardOut1Ex;
endcase  
end

always_comb begin : ALUIn2Select //input port 2
    unique case (aluSrc2EX) 
        MUX_FORWARD2 : aluIn2Ex = forwardOut2Ex;
        MUX_ITYPE : aluIn2Ex = immIEX;
        MUX_STYPE : aluIn2Ex = immSEX;
        MUX_PC : aluIn2Ex = pcEX;
        default: aluIn2Ex = forwardOut2Ex;
endcase
end


//// ALU unit ////
alu #(
    .DATA_WIDTH(DATA_WIDTH)
) ALU (
    .bus_a(aluIn1Ex),
    .bus_b(aluIn2Ex),
    .opSel(aluOpSelEx),

    .out(aluOutEx),
    .overflow(overflow),
    .Z(Z)
);


///// EX/MEM Pipeline Register  /////
pipelineRegister_EX_MEM EX_MEM_Register (
    .clk,
    .rstN,

    .memWrite_EX_IN(memWriteEX),
    .memRead_EX_IN(memReadEX),
    .regWrite_EX_IN(regWriteEX),
    .memToRegWrite_EX_IN(memtoRegEX),
    .func3_EX_IN(func3EX),
    .aluOut_EX_IN(aluOutEx),
    .aluSrc2_EX_IN(forwardOut2Ex),
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
pipelineRegister_MEM_WB MEM_WB_Register (
    .clk,
    .rstN,

    .regWrite_Mem_In(regWriteMeM),
    .memToRegWrite_Mem_In(memtoRegMeM),
    .readD_Mem_In(dMOutMem),
    .aluOut_Mem_In(aluOutMeM),
    .rd_Mem_In(rdMeM),
    .memRead_Mem_In(memReadMeM),
    .mem_ready_Mem_In(dMReadyMem),

    .regWrite_Mem_Out(regWriteWB),
    .memToRegWrite_Mem_Out(memtoRegWB),
    .readD_Mem_Out(dMOutWB),
    .aluOut_Mem_Out(aluOutWB),
    .rd_Mem_Out(rdWB)

);


//// RegFile Data in /////
assign dataInWB = memtoRegWB ? dMOutWB : aluOutWB; //either from alu or memory

endmodule : processor
