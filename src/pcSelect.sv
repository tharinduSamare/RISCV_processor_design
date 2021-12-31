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

    /*  
        Select the pc to be used for the next instruction
        depending on the following conditions:
        - pcSelect = 1
            If branch or jump is to be taken
        - pcStall = 1
            if it is required to stall the pipeline
        else
            pcOut = pc + 4
    */
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