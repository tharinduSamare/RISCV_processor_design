module pcSelect(
    /*  
        control signals
    */
    input   logic           pcSelect, 
    input   logic           pcStall, 

    /*  
        Corresponding pc signals
    */
    input   logic   [31:0]  pcAdd,
    input   logic   [31:0]  pcBranch,
    input   logic   [31:0]  pcOld,

    /*  
        Ouput
    */
    output  logic   [31:0]  pcOut
    );   

    
    always_comb begin : pcSelectBlock 
        if (pcSelect) begin
            pcOut <= pcBranch;
        end
        else if (pcStall) begin
            pcOut <= pcOld;            
        end
        else begin
            pcOut <= pcAdd;
        end
    end

endmodule