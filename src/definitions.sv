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
 JTYPE = 7'b1101111
} opCode_t;

typedef enum logic [1:0] { 
    ADD,
    PASS_S1,
    TYPE_I,
    TYPE_R
} aluOp;
    
endpackage
