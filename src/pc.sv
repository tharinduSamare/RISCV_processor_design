module pc(
    input logic                 clk,
    input logic                 rstN,
    input logic     [31:0]      pcIn, 
    input logic                 startProcess,

    // From hazard unit
    input logic                 pcWrite,

    output logic    [31:0]      pcOut 
    );

    always_ff @(posedge clk  or negedge rstN) begin : assignNextAddress
        if (~rstN) begin
            pcOut <= '0;
        end 
        else begin
            if (pcWrite && startProcess)begin
                pcOut   <= pcIn;
            end
            // else begin
            //     pcOut   <= pcOut;
            // end
        end
    end

endmodule: pc