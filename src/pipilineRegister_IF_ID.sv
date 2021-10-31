module pipilineRegister_IF_ID(
    input logic [31 : 0] pcIn,
    input logic [31 : 0] instructionIn,

    input logic harzardIF_ID_Write,
    input logic flush,

    output logic [31 : 0] pcOut,
    output logic [31 : 0] instructionOut
);

endmodule