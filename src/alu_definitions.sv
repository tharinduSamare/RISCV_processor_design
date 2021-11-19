package alu_definitions;

// parameter DATA_WIDTH = 32;

typedef enum logic { LOW, HIGH } flag_t;

typedef enum logic [3:0] { 
    ADD, SUB,
    SLT, SLTU,
    SLL, SRL, SRA,
    AND, OR , XOR,  
    FWD
} alu_operation_t;


endpackage:alu_definitions