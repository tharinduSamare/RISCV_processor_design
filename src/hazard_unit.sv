module hazard_unit
(
    input logic clk, rstN,
    input logic [4:0] IF_ID_rs1, IF_ID_rs2,
    input logic [4:0] ID_Ex_rd,
    input logic takeBranch,
    input logic ID_Ex_MemRead,ID_Ex_MemWrite,mem_ready,
    output logic IF_ID_write, PC_write, ID_Ex_enable, pcStall

);

logic stall;

typedef enum logic [2:0]{
    idle = 3'd0,
    before_read_mem = 3'd1,
    read_mem = 3'd2,
    before_write_mem = 3'd3,
    write_mem = 3'd4
}state_t;

state_t current_state, next_state;

typedef enum logic [1:0]{
    branch_idle = 2'b0,
    branch_0 = 2'b1,
    branch_1 = 2'd2
} branch_state_t;

branch_state_t current_branch_state, next_branch_state;

// assign stall = (ID_Ex_MemRead & ((ID_Ex_rd==IF_ID_rs1) | (ID_Ex_rd == IF_ID_rs2)))?1'b1:1'b0;
// assign stall = ((current_state != idle) | ID_Ex_MemRead | ID_Ex_MemWrite | takeBranch)?1'b1:1'b0;
assign stall = ((current_state != idle) | ID_Ex_MemRead | ID_Ex_MemWrite)?1'b1:1'b0;

assign ID_Ex_enable = (stall == 1'b0)? 1'b1:1'b0;
assign PC_write = (stall == 1'b0)? 1'b1:1'b0;
// assign IF_ID_write = ((stall == 1'b1) | (takeBranch == 1'b1 & (current_branch_state == branch_idle)) )? 1'b0:1'b1;
assign IF_ID_write = ((stall == 1'b1) | (takeBranch == 1'b1) )? 1'b0:1'b1;
assign pcStall = (stall == 1'b1)? 1'b1:1'b0;

always_ff @(posedge clk) begin
    if (~rstN)begin
        current_state <= idle;
        current_branch_state <= branch_idle;
    end
    else begin
        current_state <= next_state;
        current_branch_state <= next_branch_state;
    end
end

always_comb begin
    next_branch_state = current_branch_state;
    case (current_branch_state)
        branch_idle : begin
            if (takeBranch) begin
                next_branch_state = branch_0;
            end
        end
        branch_0: begin
            next_branch_state =branch_idle;
        end
        branch_1 : begin
            next_branch_state = branch_idle;
        end

    endcase
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