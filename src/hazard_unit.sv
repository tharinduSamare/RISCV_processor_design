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
    idle = 3'd0, // memory is idle
    before_read_mem = 3'd1, // before memory load operation
    read_mem = 3'd2, // during memory load operation
    before_write_mem = 3'd3, // before memory store operation
    write_mem = 3'd4 // during memory store operation
}mem_stall_state_t;

mem_stall_state_t current_mem_stall_state, next_mem_stall_state;

assign mem_op_stall = ((current_mem_stall_state != idle) | ID_Ex_MemRead | ID_Ex_MemWrite)?1'b1:1'b0;   // stall if memory read / memory write happens.
assign branch_stall = (branchCU & regWriteEX &  rdEx!=0 & ((rs1ID == rdEx)|(rs2ID == rdEx)))? 1'b1:1'b0; // stall during branching if there are data dependencies.
assign jumpreg_stall = (jumpRegCU  & regWriteEX &  rdEx!=0 & (rs1ID == rdEx))? 1'b1:1'b0; // stall during jump operation if there are data dependencies.

assign stall = (mem_op_stall | branch_stall | jumpreg_stall)? 1'b1:1'b0; // stall the pipeline if any of the above reasons satisfied.

assign branchHU = (~branch_stall & branchCU)? 1'b1:1'b0; // send branch control signal to muxes.
assign jumpRegHU = (~jumpreg_stall & jumpRegCU)? 1'b1:1'b0; // send jump control signal to muxes.

assign ID_Ex_enable = (stall)? 1'b0:1'b1;
assign pcStall = (stall)? 1'b1:1'b0;
assign PC_write = (stall)? 1'b0:1'b1;
assign IF_ID_write = (stall)? 1'b0:1'b1;

// handle stalls during memory operations
always_ff @(posedge clk) begin
    if (~rstN)begin
        current_mem_stall_state <= idle;
    end
    else begin
        current_mem_stall_state <= next_mem_stall_state;
    end
end

always_comb begin
    next_mem_stall_state = current_mem_stall_state;

    case (current_mem_stall_state) 
        idle: begin
            if (ID_Ex_MemRead) begin // identify memory read at execution stage
                next_mem_stall_state = before_read_mem;
            end
            else if (ID_Ex_MemWrite) begin // identify memory write at execution stage
                next_mem_stall_state = before_write_mem;
            end
        end

        before_read_mem: begin // wait until memory read starts
            if (mem_ready == 1'b0) begin
                next_mem_stall_state = read_mem;
            end
        end
        
        read_mem: begin // wait during memory read operation
            if (mem_ready) begin
                next_mem_stall_state = idle;
            end
        end

        before_write_mem: begin // wait until memory write start
            if (mem_ready == 1'b0) begin
                next_mem_stall_state = write_mem;
            end
        end
        
        write_mem: begin // wait during memory write 
            if (mem_ready) begin
                next_mem_stall_state = idle;
            end
        end

    endcase
end

endmodule : hazard_unit