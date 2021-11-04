module data_forwarding #(
    parameter DATA_WIDTH = 32,
    parameter REG_SIZE = 5
) (
    //input  logic [DATA_WIDTH-1   :0] mem_regWrite, wb_regWrite,
    input  logic mem_regWrite, wb_regWrite,
    input  logic [REG_SIZE-1     :0] mem_rd, wb_rd,
    input  logic [REG_SIZE-1     :0] ex_rs1, ex_rs2,
    output logic [1:0] df_mux1, df_mux2
);
logic wb_fwd1,  wb_fwd2;
logic mem_fwd1, mem_fwd2;

always_comb begin : d_fwd_mem
    wb_fwd1  <= wb_regWrite  && (wb_rd  != 0) && (wb_rd  == ex_rs1);
    wb_fwd2  <= wb_regWrite  && (wb_rd  != 0) && (wb_rd  == ex_rs2);
    mem_fwd1 <= mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs1);
    mem_fwd2 <= mem_regWrite && (mem_rd != 0) && (mem_rd == ex_rs2);
    /*
    if      only mem stage instruction rd correspond to ex_stage instruction rs: mux <= 1
    else if only wb stage instruction rd correspond to ex_stage instruction rs: mux <= 2
    else if       both           rd correspond to ex_stage instruction rs: mux <= 1 (i.e. the most recent)
    */
    if (mem_fwd1) df_mux1 <= 2'b01;
    else begin
        if (wb_fwd1) df_mux1 <= 2'b10;
        else df_mux1 <= 2'b00;
    end
    if (mem_fwd2) df_mux2 <= 2'b01;
    else begin
        if (wb_fwd2) df_mux2 <= 2'b10;
        else df_mux2 <= 2'b00;
    end
end
//data forward from wb stage
// if (wb_regWrite && (wb_rd != 0) && !(mem_regWrite &&  mem_rd != 0 && mem_rd == ex_rs1) && (wb_rd == ex_rs1)) df_mux1 <= 2'b10;
// if (wb_regWrite && (wb_rd != 0) && !(mem_regWrite &&  mem_rd != 0 && mem_rd == ex_rs2) && (wb_rd == ex_rs2)) df_mux2 <= 2'b10;

//data forward from mem stage
// if (mem_regWrite && (mem_rd != 0) && !(wb_regWrite && wb_rd != 0 && wb_rd == ex_rs1)) && (mem_rd == ex_rs1)) df_mux1 <= 2'b01;
// if (mem_regWrite && (mem_rd != 0) && !(wb_regWrite && wb_rd != 0 && wb_rd == ex_rs2)) && (mem_rd == ex_rs2)) df_mux2 <= 2'b01;    
endmodule: data_forwarding