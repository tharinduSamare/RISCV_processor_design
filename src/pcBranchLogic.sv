module pcBranch(
    input   logic [2:0] funct3,         // to select the type of branch
    input   logic       branch,         // from the control unit
    output  logic [2:0] branchType,
    output  logic       takeBranch      // branch ? 1 : 0
    );

    typedef enum logic [ 2:0 ]{
        BEQ  = 3'b000,
        BNE  = 3'b001,
        BLT  = 3'b100,
        BGE  = 3'b101,
        BLTU = 3'b110,
        BGEU = 3'b111
    } branch_;

    branch_ _;
    always_comb begin : branchLogic
        if (branch) begin
            takeBranch <= '1;    
            if (funct3 == 3'b000) begin
                branchType <= BEQ;
            end
            else if (funct3 == 3'b001) begin
                branchType <= BNE;            
            end
            else if (funct3 == 3'b100) begin
                branchType <= BLT;           
            end
            else if (funct3 == 3'b101) begin
                branchType <= BGE;            
            end
            else if (funct3 == 3'b110) begin
                branchType <= BLTU;            
            end
            else if (funct3 == 3'b111) begin
                branchType <= BGEU;            
            end
        end
        else begin
            takeBranch <= '0;
            branchType <= 3'b000;
        end
    end

endmodule: pcBranch