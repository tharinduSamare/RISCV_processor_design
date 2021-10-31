package alu_definitions;

typedef enum logic [3:0] { 
    ADD, SUB,
    SLT, SLTU,
    SLL, SRL, SRA,
    AND, OR , XOR,  
    LUI, AUIPC
} alu_op;


endpackage:alu_definitions