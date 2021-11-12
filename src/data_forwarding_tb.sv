module data_forwarding_tb
    import reg_names::*;();
timeunit 1ns;
timeprecision 1ps;

localparam DATA_WIDTH = 32;
localparam REG_SIZE = 5;
localparam CLK_PERIOD = 10;
logic clk;
initial begin
    clk = 0;
    forever begin
    #(CLK_PERIOD/2);
    clk <= ~clk;
    end
end

logic mem_regWrite, wb_regWrite;
regName_t mem_rd, wb_rd;
regName_t ex_rs1, ex_rs2;
logic [1:0] df_mux1, df_mux2;

data_forwarding df_unit (
    .mem_regWrite(mem_regWrite),
    .wb_regWrite(wb_regWrite),
    .mem_rd(mem_rd),
    .wb_rd(wb_rd),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .df_mux1(df_mux1),
    .df_mux2(df_mux2)
);

// typedef struct {
//     regName_t dest, src1, src2,
//     logic regWrite    
// } inst_t;

// inst_t inst_1, inst_2, inst_3;
// inst_1 <= '{dest:t1, src1:a0, src2:s1, regWrite:1'b1};
// inst_2 <= '{dest:t2, src1:t0, src2:t1, regWrite:1'b1};
// inst_3 <= '{dest:t3, src1:t0, src2:t1, regWrite:1'b1};

// task automatic inst_begin(
//     input inst_t instruction1, instruction2, instruction3
// );
//     wb_rd <= instruction1[0];
//     wb_regWrite <= instruction1[3];
//     mem_rd <= instruction2[0];
//     mem_regWrite <= instruction2[3];
//     ex_rs1 <= instruction3[2];
//     ex_rs2 <= instruction3[3];
// endtask //instructions

// // instruction_set = {{t1, a0, a1}, {t2, t0, t1}, {t3, t0, t1}};

// function automatic regName_t rand_reg (r);
//     r = r.first;
//     int j = $random;
//     for (int i = 1; i<j; i=i+1) begin
//         r = r.next;
//     end;
//     return r;
// endfunction: rand_reg

logic [4:0] a, b, c, d;

task automatic random_reg();
    wb_rd = wb_rd.first; mem_rd =  mem_rd.first;  ex_rs1 = ex_rs1.first; ex_rs2 = ex_rs2.first;
    for (int i = 1; i<a; i=i+1) begin
        wb_rd = wb_rd.next;
    end
    for (int i = 1; i<b; i=i+1) begin
        mem_rd = mem_rd.next;
    end
    for (int i = 1; i<c; i=i+1) begin
        ex_rs1 = ex_rs1.next;
    end
    for (int i = 1; i<d; i=i+1) begin
        ex_rs2 = ex_rs2.next;
    end
endtask //automatic

initial begin
    // inst_begin(inst_t.randomize(), inst_t.randomize(), inst_t.randomize());
    repeat (150) begin
    mem_regWrite <= $random;
    wb_regWrite <= $random;
    a <= $random;
    b <= $random;
    c <= $random;
    d <= $random;
    random_reg();
    #(CLK_PERIOD*2);
    end
end

endmodule: data_forwarding_tb