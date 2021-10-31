module pc(
    input logic                 clk,
    input logic     [31:0]      pcIn, 

    // From hazard unit
    input logic                 pcWrite,

    output logic    [31:0]      pcOut 
    );

    always_ff @(posedge clk ) begin : assignNextAddress
    if (!pcWrite)begin
        pcOut   <= pcIn;
    end
    else begin
        pcOut   <= 32'd0; // find which address to send
    end
    end

endmodule: pc