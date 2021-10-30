module hazard_unit
(
    input logic clk, rstN,
    input logic [3:0] IF_ID_rs1, IF_ID_rs2,
    input logic [3:0] ID_Ex_rd,
    input logic ID_Ex_MemRead,mem_ready,
    output logic IF_ID_write, PC_write, ID_Ex_enable

);






endmodule : hazard_unit