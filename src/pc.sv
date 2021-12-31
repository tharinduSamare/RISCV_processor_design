module pc(
    input logic                 clk,            // input clock
    input logic                 rstN,           // input reset
    input logic     [31:0]      pcIn,           // input new program counter
    input logic                 startProcess,   // input start process

    // From hazard unit
    input logic                 pcWrite,        // input control to write new program counter

    output logic    [31:0]      pcOut           // output current program counter
    );

    // define states for the state machine
    typedef enum logic {    
        idle = 1'b0,
        working = 1'b1
    } state_t;
    state_t current_state;

    // assign the current state
    always_ff @(posedge clk) begin
        if (~rstN) begin
            current_state <= idle;
        end
        else if (startProcess) begin
            current_state <= working;
        end
    end

    // assign the pc depending on the state and control signal
    always_ff @(posedge clk  or negedge rstN) begin : assignNextAddress
        if (~rstN) begin  // asynchronous reset
            pcOut <= '0;
        end 
        else begin
            if (pcWrite && (current_state == working))begin
                pcOut   <= pcIn;
            end
        end
    end

endmodule: pc