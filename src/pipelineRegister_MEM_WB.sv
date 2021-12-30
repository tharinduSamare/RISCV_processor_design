module pipelineRegister_MEM_WB 
import  definitions::*;
( 
    input logic             clk,
    input logic             rstN,
    // from control unit
    // to writeback stage
    input logic             regWrite_Mem_In,
    input logic             memToRegWrite_Mem_In,

    // other signals to wb stage
    input logic [31 : 0]    readD_Mem_In,
    input logic [31 : 0]    aluOut_Mem_In,
    input regName_t         rd_Mem_In,

    input logic memRead_Mem_In,
    input logic mem_ready_Mem_In,
    
    // from control unit
    // to writeback stage
    output logic             regWrite_Mem_Out,
    output logic             memToRegWrite_Mem_Out,

    // other signals to wb stage
    output logic [31 : 0]    readD_Mem_Out,
    output logic [31 : 0]    aluOut_Mem_Out,
    output regName_t         rd_Mem_Out
);

typedef enum logic{
    mem_read_idle,
    mem_reading
}rd_control_state_t;

rd_control_state_t rd_control_current_state, rd_control_next_state;
regName_t next_rd, hold_rd, hold_rd_next;
logic next_memToRegWrite, hold_memToRegWrite ,hold_memToRegWrite_next;
logic next_regWrite, hold_regWrite, hold_regWrite_next;

always_ff @( posedge clk or negedge rstN ) begin : MEM_WB_REGISTER
    if (~rstN) begin
        // from control unit
        // to writeback stage
        // regWrite_Mem_Out        <=  '0;
        // memToRegWrite_Mem_Out   <=  '0;

        // other signals to wb stage
        readD_Mem_Out           <=  '0;
        aluOut_Mem_Out          <=  '0;
        // rd_Mem_Out              <=  zero;
    end
    else begin
        // from control unit
        // to writeback stage
        // regWrite_Mem_Out        <=  regWrite_Mem_In;
        // memToRegWrite_Mem_Out   <=  memToRegWrite_Mem_In;

        // other signals to wb stage
        readD_Mem_Out           <=  readD_Mem_In;
        aluOut_Mem_Out          <=  aluOut_Mem_In;
        // rd_Mem_Out              <=  rd_Mem_In;
    end
end

always_ff @(posedge clk) begin
    if (~rstN) begin
        rd_control_current_state <= mem_read_idle;

        rd_Mem_Out <= zero;
        hold_rd <= zero;
        
        hold_memToRegWrite <= 1'b0;
        memToRegWrite_Mem_Out <= 1'b0;
        
        regWrite_Mem_Out <=  1'b0;
        hold_regWrite <= 1'b0;

    end
    else begin
        rd_control_current_state <= rd_control_next_state;
        
        rd_Mem_Out <= next_rd;
        hold_rd <= hold_rd_next;
        
        hold_memToRegWrite <= hold_memToRegWrite_next;
        memToRegWrite_Mem_Out <= next_memToRegWrite;

        regWrite_Mem_Out <= next_regWrite;
        hold_regWrite <= hold_regWrite_next;

    end
end

always_comb begin
    rd_control_next_state = rd_control_current_state;

    next_rd = rd_Mem_In;
    hold_rd_next = hold_rd;
    
    hold_memToRegWrite_next = hold_memToRegWrite;
    next_memToRegWrite = memToRegWrite_Mem_In;

    next_regWrite = regWrite_Mem_In;
    hold_regWrite_next = hold_regWrite;

    case (rd_control_current_state)
        mem_read_idle: begin
            if (memRead_Mem_In) begin
                next_rd = zero;
                hold_rd_next = rd_Mem_In;

                next_memToRegWrite = 1'b0;
                hold_memToRegWrite_next = memToRegWrite_Mem_In;

                next_regWrite = 1'b0;
                hold_regWrite_next = regWrite_Mem_In;
                
                rd_control_next_state = mem_reading;
            end
        end

        mem_reading: begin
            next_rd = zero;
            next_memToRegWrite = 1'b0;
            next_regWrite = 1'b0;
            if (mem_ready_Mem_In) begin
                next_rd = hold_rd;
                next_memToRegWrite = hold_memToRegWrite;
                next_regWrite = hold_regWrite;
                rd_control_next_state = mem_read_idle;
            end
        end
    endcase
end
    
endmodule