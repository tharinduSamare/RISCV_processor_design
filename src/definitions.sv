package definitions;

typedef enum logic [6:0] { 
 LTYPE = 7'b0000011,
 ITYPE = 7'b0010011,
 AUIPC = 7'b0010111,
 STYPE = 7'b0100011,
 RTYPE = 7'b0110011,
 LUI   = 7'b0110111,
 BTYPE = 7'b1100011,
 JALR  = 7'b1100111,
 JTYPE = 7'b1101111,
 ERROR
} opCode_t;

typedef enum logic [1:0] { 
    DEF_ADD,
    PASS_S1,
    TYPE_I,
    TYPE_R
} aluOp_t;
    
parameter REG_COUNT = 32;
parameter REG_SIZE = $clog2(REG_COUNT);

// typedef enum logic [4:0] { 
//         zero = 5'd0,    //hard-wired zero
//         ra = 5'd1,      //return address
//         sp = 5'd2,      //stack pointer
//         gp = 5'd3,      //global pointer
//         tp = 5'd4,      //thread pointer
//         t[3] = 5'd5,    //temporary / alt. link register
//         s[2] = 5'd8,    //saved register
//         a[0:7] = 5'd10, //function args/ return values
//         s[2:11] = 5'd18,//saved registers (cont.)
//         t[3:6] = 5'd28  //Temporaries (cont.)
//  } regName_t;

typedef enum logic [4:0] {
    zero = 5'd0,
    x[1:31] = 5'd1
} regName_t;   

// typedef enum bit [1:0] { 
//     ZERO,
//     ONE,
//     TWO,
//     THREE
// } alu_sel_t;

typedef enum logic [1:0] { 
    MUX_FORWARD1,
    MUX_UTYPE,
    MUX_INC
} alu_sel1_t;

typedef enum logic [1:0] { 
    MUX_FORWARD2,
    MUX_ITYPE,
    MUX_STYPE,
    MUX_PC
} alu_sel2_t;

typedef enum logic [1:0] { 
    MUX_REG,
    MUX_MEM,
    MUX_WB
} forward_mux_t;

typedef enum logic { LOW, HIGH } flag_t;

typedef enum logic [4:0] { 
    ADD, SUB,
    SLT, SLTU,
    SLL, SRL, SRA,
    AND, OR , XOR,  
    FWD,
    MUL, MULH, MULHSU, MULHU,
    DIV, DIVU, REM, REMU
} alu_operation_t;

endpackage:definitions