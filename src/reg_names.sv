package reg_names;

    parameter DATA_WIDTH = 32;
    parameter REG_COUNT = 32;
    parameter REG_SIZE = $clog2(REG_COUNT);

    typedef enum logic [4:0] { 
        zero = 5'd0,    //hard-wired zero
        ra = 5'd1,      //return address
        sp = 5'd2,      //stack pointer
        gp = 5'd3,      //global pointer
        tp = 5'd4,      //thread pointer
        t[3] = 5'd5,    //temporary / alt. link register
        s[2] = 5'd8,    //saved register
        a[0:7] = 5'd10, //function args/ return values
        s[2:11] = 5'd18,//saved registers (cont.)
        t[3:6] = 5'd28  //Temporaries (cont.)
    } regName_t;

    /* 
    zero= 5'd0, //hard-wired zero
    ra  = 5'd1, //return address
    sp  = 5'd2, //stack pointer
    gp  = 5'd3, //global pointer
    tp  = 5'd4, //thread pointer
    t0  = 5'd5, //temporary / alt. link register
    t1  = 5'd6, 
    t2  = 5'd7, 
    s0  = 5'd8, //saved register/frame pointer
    s1  = 5'd9, //saved register
    //function args/ return values
    a0  = 5'd10, 
    a1  = 5'd11, 
    a2  = 5'd12, 
    a3  = 5'd13, 
    a4  = 5'd14, 
    a5  = 5'd15, 
    a6  = 5'd16, 
    a7  = 5'd17, 
    //saved registers (cont.)
    s2  = 5'd18, 
    s3  = 5'd19, 
    s4  = 5'd20, 
    s5  = 5'd21, 
    s6  = 5'd22, 
    s7  = 5'd23, 
    s8  = 5'd24, 
    s9  = 5'd25, 
    s10 = 5'd26, 
    s11 = 5'd27, 
    //Temporaries (cont.)
    t3  = 5'd28, 
    t4  = 5'd29, 
    t5  = 5'd30, 
    t6  = 5'd31
    */

endpackage : reg_names
