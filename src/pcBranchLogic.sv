module pcBranch(
    input   logic [2:0] funct3,
    input   logic       branch,
    output  logic [2:0] branchType,
    output  logic       takeBranch
    );

    typedef enum logic [ 2:0 ]{
        BEQ,
        BNE,
        BLT,
        BLE,
        BGE,
        BLTU,
        BGEU
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
            else if (funct3 == 3'b010) begin
                branchType <= BLT;           
            end
            else if (funct3 == 3'b011) begin
                branchType <= BLE;            
            end
            else if (funct3 == 3'b100) begin
                branchType <= BGE;            
            end
            else if (funct3 == 3'b101) begin
                branchType <= BLTU;            
            end
            else if (funct3 == 3'b111) begin
                branchType <= BGEU;            
            end
        end
        else begin
            takeBranch <= '0;
        end
    end

endmodule: pcBranch