package alu_definitions;

typedef enum logic [3:0] { 
    ADD,
    SUB,
    AND, OR , XOR,  
    SLL, SRL, SRA,
    SLT, SLTU,     //Less Than
    LUI
} alu_op;


endpackage:alu_definitions