package definitions;

typedef enum bit [1:0] { 
    ADD,
    PASS_S1,
    TYPE_I,
    TYPE_R
} aluOp_t;
    
typedef enum bit [6:0]{
    LTYPE,
    ITYPE,
    AUIPC,
    STYPE,
    RTYPE,
    LUI  ,
    BTYPE,
    JALR ,
    JTYPE,
    NOP
} opCode_t; 

typedef enum bit [1:0] { 
    ZERO,
    ONE,
    TWO,
    THREE
} alu_sel_t;

endpackage:definitions
