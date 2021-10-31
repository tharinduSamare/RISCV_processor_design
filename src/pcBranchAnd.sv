module pcBranchAnd (
    input logic ifBranch, //from the pcBranchType unit
    input logic branchIn, //from the control unit

    output logic branchOut
);
    
    assign branchOut = ifBranch && branchIn;
endmodule