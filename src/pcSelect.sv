module pcSelect(
    /*  
        control signals
    */
    input   logic           jump_,
    input   logic           jumpReg,  
    input   logic           takeBranch,  

    /*  
        Corresponding pc signals
    */
    input   logic   [31:0]  pcAdd,
    input   logic   [31:0]  pcJump,
    input   logic   [31:0]  pcRegJump,
    input   logic   [31:0]  pcBranch,

    /*  
        Ouput
    */
    output  logic   [31:0]  pcOut
    );   

    
    always_comb begin : pcSelectBlock 
        if (!jump_ && !jumpReg && !takeBranch) begin
            pcOut <= pcAdd;
        end
        else if (jump_ && !jumpReg && !takeBranch) begin
            pcOut <= pcJump;      
        end
        else if (!jump_ && jumpReg && !takeBranch) begin
            pcOut <= pcRegJump;     
        end
        else if (!jump_ && !jumpReg && takeBranch) begin
            pcOut <= pcBranch;   
        end
    end

endmodule