module hazard_unit import definitions::*;
(
    input logic clk, rstN,
    input regName_t rs1ID, rs2ID,
    input regName_t rdEx,
    input logic branchCU,jumpRegCU,
    input logic ID_Ex_MemRead,ID_Ex_MemWrite,mem_ready,regWriteEX,

    output logic IF_ID_write, PC_write, ID_Ex_enable, pcStall, 
    output logic branchHU,jumpRegHU
);

logic mem_op_stall,branch_stall, jumpreg_stall;
logic stall;

typedef enum logic [2:0]{
    idle = 3'd0,
    before_read_mem = 3'd1,
    read_mem = 3'd2,
    before_write_mem = 3'd3,
    write_mem = 3'd4
}state_t;

state_t current_state, next_state;

// assign mem_op_stall = (ID_Ex_MemRead & ((rdEx==rs1ID) | (rdEx == rs2ID)))?1'b1:1'b0;
// assign mem_op_stall = ((current_state != idle) | ID_Ex_MemRead | ID_Ex_MemWrite | takeBranch)?1'b1:1'b0;
assign mem_op_stall = ((current_state != idle) | ID_Ex_MemRead | ID_Ex_MemWrite)?1'b1:1'b0;
assign branch_stall = (regWriteEX & branchCU & rdEx!=0 & ((rs1ID == rdEx)|(rs2ID == rdEx)))? 1'b1:1'b0;
assign jumpreg_stall = (regWriteEX & jumpRegCU  & rdEx!=0 & (rs1ID == rdEx))? 1'b1:1'b0;

assign stall = (mem_op_stall | branch_stall | jumpreg_stall)? 1'b1:1'b0;

assign branchHU = (~branch_stall & branchCU)? 1'b1:1'b0;
assign jumpRegHU = (~jumpreg_stall & jumpRegCU)? 1'b1:1'b0;

assign ID_Ex_enable = (stall)? 1'b0:1'b1;
assign PC_write = (stall)? 1'b0:1'b1;
assign IF_ID_write = (stall)? 1'b0:1'b1;
assign pcStall = (stall)? 1'b1:1'b0;

always_ff @(posedge clk) begin
    if (~rstN)begin
        current_state <= idle;
    end
    else begin
        current_state <= next_state;
    end
end

always_comb begin
    next_state = current_state;

    case (current_state) 
        idle: begin
            if (ID_Ex_MemRead) begin
                next_state = before_read_mem;
            end
            else if (ID_Ex_MemWrite) begin
                next_state = before_write_mem;
            end
        end

        before_read_mem: begin
            if (mem_ready == 1'b0) begin
                next_state = read_mem;
            end
        end
        
        read_mem: begin
            if (mem_ready) begin
                next_state = idle;
            end
        end

        before_write_mem: begin
            if (mem_ready == 1'b0) begin
                next_state = write_mem;
            end
        end
        
        write_mem: begin
            if (mem_ready) begin
                next_state = idle;
            end
        end



    endcase
end

endmodule : hazard_unit