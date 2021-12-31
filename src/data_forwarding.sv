/*
This module forwards the output of MEMORY (MEM) 
and WRITEBACK (WB) stages to (EX) EXECUTE stage
in the case of a data dependency
*/
module data_forwarding 
    import definitions::*;
#(
    parameter DATA_WIDTH = 32
) (
    input  logic mem_regWrite, wb_regWrite,
    input  regName_t mem_rd, wb_rd,
    input  regName_t ex_rs1, ex_rs2,
    output forward_mux_t df_mux1, df_mux2
);

logic wb_fwd1,  wb_fwd2;
logic mem_fwd1, mem_fwd2;

always_comb begin : d_fwd_mem
    //Set WriteBack_Forward high 
    //if WB stage instruction regwrite is high
    //and there is a data dependecy between 
    //instructions in WB and EX stage
    wb_fwd1  = wb_regWrite  && (wb_rd  != 0) && (wb_rd  == ex_rs1); //For bus A
    wb_fwd2  = wb_regWrite  && (wb_rd  != 0) && (wb_rd  == ex_rs2); //For bus B

    //Set Mem_Forward high 
    //if MEM stage instruction regwrite is high 
    //and there is a data dependecy between 
    //instructions in MEM and EX stage
    mem_fwd1 = mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs1); //For bus A
    mem_fwd2 = mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs2); //For bus B

    /*
    if      only MEM stage instruction has a data dependency then rs: mux <= 1
    else if only WB stage instruction has a data dependency then rs: mux <= 2
    else if both stages have a data dependency then rs: mux <= 1 (i.e. the most recent)
    */
    //For bus A
    if (mem_fwd1) df_mux1 = MUX_MEM; //2'b01;
    else begin
        if (wb_fwd1) df_mux1 = MUX_WB; //2'b10;
        else df_mux1 = MUX_REG; //2'b00;
    end
    //For bus B
    if (mem_fwd2) df_mux2 = MUX_MEM; //2'b01;
    else begin
        if (wb_fwd2) df_mux2 = MUX_WB; //2'b10;
        else df_mux2 = MUX_REG; //2'b00;
    end
end
endmodule: data_forwarding