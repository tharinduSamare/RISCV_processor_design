module pc(
    input logic                 clk,
    input logic     [31:0]      pcIn, 

    output logic    [31:0]      pcOut 
    );

    always_ff @(posedge clk ) begin : assignNextAddress
        pcOut   <= pcIn;
    end

endmodule: pc