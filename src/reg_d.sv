module reg_d (
    input  clk, rstN, wen, ren,
    input  [15:0] data_in,
    output [15:0] data_out
);

logic [15:0] data;

initial begin
    data <= 16'b0;
end

always_ff @( posedge clk or negedge rstN) begin : reg_operation
    if (~rstN) begin: reset
        data_out <= 0;
    end
    else begin 
        if      (wen)   data      <= data_in;
        else if (ren)   data_out  <= data;
    end
end 

endmodule:reg_d