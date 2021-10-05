module pcSelect(
    input   logic           clk,
    input   logic           jump_,
    input   logic           jumpReg,    
    input   logic   [31:0]  pcAdd,
    input   logic   [31:0]  pcJump,
    input   logic   [31:0]  pcBranch,

    output  logic   [31:0]  pcOut,
    );

    logic   [31:0]  pcOutNext,

    typedef enum logic { 2:0 }{
        pcAdd,
        pcJump,
        pcBranch   
    } pcStates;

    pcStates currentPcState, nextPcState;
    
    always_ff @( posedge clk or negedge rstN ) begin 
        if(!rstN) begin
            currentPcState  <= pcAdd;
            pcOut           <= 32'd1;
        end
        else begin
            currentPcState  <= nextPcState;
            pcOut           <= pcOutNext;
        end
    end

    always_comb begin
        
        nextPcState <= currentPcState;
        
        case (currentPcState)
            pcAdd: begin
                if(jump_ && !jumpReg)begin
                    nextPcState     <= pcJump;
                end
                else if (!jump_ && jumpReg) begin
                    nextPcState     <= pcBranch;
                end
                else begin
                    pcOutNext       <= pcAdd;
                end
            end

            pcJump: begin
                if(!jump_ && !jumpReg)begin
                    nextPcState     <= pcAdd;
                end
                else if (!jump_ && jumpReg) begin
                    nextPcState     <= pcBranch;
                end
                else begin
                    pcOutNext       <= pcJump;
                end
            end 

            pcBranch: begin
                if(!jump_ && !jumpReg)begin
                    nextPcState     <= pcAdd;
                end
                else if (jump_ && !jumpReg) begin
                    pcOutNext       <= pcJump;
                end
                else begin
                    nextPcState     <= pcBranch;
                end
            end 
            
        endcase
    
    end

endmodule