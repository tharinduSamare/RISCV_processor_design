module pcSelect(
    /*  
        control signals
    */
    input   logic           pcSelect,  

    /*  
        Corresponding pc signals
    */
    input   logic   [31:0]  pcAdd,
    input   logic   [31:0]  pcBranch,

    /*  
        Ouput
    */
    output  logic   [31:0]  pcOut
    );   

    
    always_comb begin : pcSelectBlock 
        if (pcSelect) begin
            pcOut <= pcBranch;
        end
        else begin
            pcOut <= pcAddl;
        end
    end

endmodule