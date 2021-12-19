module pc(
    input logic                 clk,
    input logic                 rstN,
    input logic     [31:0]      pcIn, 
    input logic                 startProcess,

    // From hazard unit
    input logic                 pcWrite,

    output logic    [31:0]      pcOut 
    );

    typedef enum logic {
        idle = 1'b0,
        working = 1'b1
    } state_t;
    state_t current_state;

    always_ff @(posedge clk) begin
        if (~rstN) begin
            current_state <= idle;
        end
        else if (startProcess) begin
            current_state <= working;
        end
    end

    always_ff @(posedge clk  or negedge rstN) begin : assignNextAddress
        if (~rstN) begin
            pcOut <= '0;
        end 
        else begin
            if (pcWrite && (current_state == working))begin
                pcOut   <= pcIn;
            end
        end
    end

endmodule: pc