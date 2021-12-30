module pipelineRegister_IF_ID( 
    // ========================== //
    //           Input            //
    // ========================== //
    input logic             clk,
    input logic             rstN,
	input logic 		    startProcess,
    
    input logic [31 : 0]    pcIn,
    input logic [31 : 0]    instructionIn,

    input logic             harzardIF_ID_Write,
    input logic             IF_flush,

    // ========================== //
    //          Output            //
    // ========================== //
    output logic [31 : 0]   pcOut,
    output logic [31 : 0]   instructionOut
);

    // define states for the state machine
    typedef enum logic [2:0] {    
        idle,
        waiting,
        working
    } state_t;
    state_t current_state;

    logic [1:0] counter;

    // IF-ID state machine
    always_ff @(posedge clk) begin
        if (~rstN) begin
            current_state <= idle;
            counter <= 0;
        end
        else begin
            case (current_state)
            /*  
                Keep the state at idle till 
                startProcess is asserted
            */
                idle: begin
                    if (startProcess) begin
                        current_state <= waiting;
                        counter <= counter + 1'b1;
                    end
                    else begin
                        current_state <= idle;
                        counter <= 0;
                    end
                end

            /*  
                After startProcess is asserted,
                wait for 2 clock cycles before
                reading the instruction from the
                memory
            */
                waiting: begin
                    if (counter == 2'd2) begin
                        current_state <= working;
                        counter <= counter;
                    end
                    else begin
                        current_state <= waiting;
                        counter <= counter + 1;
                    end
                end

                /* 
                    Read the instruction from the memory
                    and forward it to the decode stage 
                */
                working: begin
                    current_state <= working;
                end
            endcase
        end
    end


    always_ff @( posedge clk or negedge rstN ) begin : IF_ID_REGISTER
        if (~rstN) begin
            pcOut               <=      '0;
            instructionOut      <=      {25'b0, 7'b0010011}; // addi x0 x0 0
        end
        else begin
            /*  
                In case of branch flush the pipeline register
            */
            if (IF_flush && (current_state == working)) begin //flush
                pcOut               <=      '0;
                instructionOut      <=      {25'b0, 7'b0010011}; // addi x0 x0 0
            end

            /* 
                In case of a stall keep the current pc and instruction
            */
            else if (~harzardIF_ID_Write && (current_state == working)) begin //retain
                pcOut               <=      pcOut;
                instructionOut      <=      instructionOut;
            end

            /*  
                Else read the instruction from the memory
                for the current pc
            */
            else begin
                pcOut               <=      pcIn;
                instructionOut      <=      instructionIn;
                end
		end
    end
endmodule