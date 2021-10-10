//`include "definitions.sv"
//import definitions::*;
module L1_cache import definitions::*;
#(
    parameter WORD_LENGTH = 4,  // length of a register in bytes (32 bit -> 4  64 bit -> 8)
    parameter CACHE_WIDTH = 4,  // number of words in a row
    parameter DEPTH = 256, //number of rows 
    parameter ADDRESS_WIDTH = $clog2(DEPTH * CACHE_WIDTH * WORD_LENGTH) // byte addressable
)
(
    input logic clk,
    input mem_operation_t mem_operation,
    input logic [ADDRESS_WIDTH-1:0]address,
    input logic [WORD_LENGTH*8-1:0]data_in,
    output logic [WORD_LENGTH*8-1:0]data_out,
    output logic stall
);

//use little endian byte order
// ex:- cache with 4 words in a raw (word size is 32 bits (4 bytes)) 

// |------------------3---------------||-----------------2----------------||------------------1---------------||-----------------0----------------|
// | |------||------||------||------| || |------||------||------||------| || |------||------||------||------| || |------||------||------||------| |
// | |  3   ||  2   ||  1   ||  0   | || |  3   ||  2   ||  1   ||  0   | || |  3   ||  2   ||  1   ||  0   | || |  3   ||  2   ||  1   ||  0   | |
// | |------||------||------||------| || |------||------||------||------| || |------||------||------||------| || |------||------||------||------| |
// |----------------------------------||----------------------------------||----------------------------------||----------------------------------|



logic [ADDRESS_WIDTH-1:0] reg_address;

logic [$clog2(DEPTH)-1:0] raw, reg_raw;  // to find the raw in the memory
logic [$clog2(CACHE_WIDTH)-1:0] word_no, reg_word_no; // the word in one cache line
logic [1:0]byte_no, reg_byte_no; // byte in the word

logic [WORD_LENGTH*8-1:0]raw_data_out;

assign {raw,word_no,byte_no} = address;

logic [7:0]L1_cache_memory[0:DEPTH-1][CACHE_WIDTH-1:0][WORD_LENGTH-1:0];

always_ff @(posedge clk) begin

    reg_raw <= raw;
    reg_word_no <= word_no;
    reg_byte_no <= byte_no;

    if (mem_operation == str_byte) begin
        L1_cache_memory[raw][word_no][byte_no] <= data_in[7:0];
    end
    else if (mem_operation == str_half_word) begin
        for (int i=0;i<WORD_LENGTH/2;i++) begin
            L1_cache_memory[raw][word_no][byte_no+i] <= data_in[8*i+7 -: 8];
        end
    end
    else if (mem_operation == str_word) begin
        for(int i=0;i<WORD_LENGTH;i++) begin
            L1_cache_memory[raw][word_no][byte_no+i] <= data_in[8*i+7 -: 8];
        end
    end
end

assign raw_data_out = {>>{L1_cache_memory[raw][word_no][0+:WORD_LENGTH]}}; //stream the array to a single vector

always_comb begin
    data_out = raw_data_out;
    unique case (mem_operation)
        ld_byte_s: begin
            data_out = (WORD_LENGTH*8)'(signed'(raw_data_out[7:0]));
        end

        ld_byte_u: begin
            data_out = (WORD_LENGTH*8)'(unsigned'(raw_data_out[7:0]));
        end

        ld_half_word_s: begin
            if (reg_byte_no == 0) begin // sends the lower harf word
                data_out = (WORD_LENGTH*8)'(signed'(raw_data_out[WORD_LENGTH*8/2-1:0]));
            end
            else begin // sends the upper half word
                data_out = (WORD_LENGTH*8)'(signed'(raw_data_out[WORD_LENGTH*8-1:WORD_LENGTH*8/2]));
            end
        end

        ld_half_word_u: begin
            if (reg_byte_no == 0) begin // sends the lower harf word
                data_out = (WORD_LENGTH*8)'(unsigned'(raw_data_out[WORD_LENGTH*8/2-1:0]));
            end
            else begin // sends the upper half word
                data_out = (WORD_LENGTH*8)'(unsigned'(raw_data_out[WORD_LENGTH*8-1:WORD_LENGTH*8/2]));
            end
        end

        ld_word: begin
            data_out = raw_data_out;
        end

        default: data_out = raw_data_out;

    endcase
end

endmodule : L1_cache