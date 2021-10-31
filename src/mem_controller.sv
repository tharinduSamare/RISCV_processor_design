module mem_controller 
#(
    MEMORY_DEPTH = 4096, // acts as an circular array. If depth is less than 2**address_width, takes the modulo.
    ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32
)
(
    input logic clk,rstN,write_En,read_En,
    input logic [2:0]func3,
    input logic [ADDRESS_WIDTH-1:0]address,
    input logic [DATA_WIDTH-1:0]data_in,
    output logic [DATA_WIDTH-1:0]data_out,
    output logic ready
);

// typedef enum [2:0]logic { 
//     LB  = 3'b000,
//     LH  = 3'b001,
//     LW  = 3'b010,
//     LBU = 3'b100,
//     LHU = 3'b101
// } func3_load_t;

// typedef enum [2:0]logic
//     SB  = 3'b000,
//     SH  = 3'b001,
//     SW  = 3'b010
// } func3_t_store_t;

localparam MEM_READ_DELAY = 2;
localparam MEM_WRITE_DELAY = 2;

localparam [3:0]
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101,
    SB  = 3'b000,
    SH  = 3'b001,
    SW  = 3'b010;
    

typedef enum [3:0]logic { 
    idle,
    load_0,
    load_1,
    store_0,
    store_1
} state_t;

logic [DATA_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];

logic [DATA_WIDTH-1:0]mem_data_out;
logic [DATA_WIDTH-1:0]mem_data_in, mem_data_in_next;

logic [$clog2(MEM_READ_DELAY)-1:0]current_read_delay_count, next_read_delay_count;
logic [$clog2(MEM_WRITE_DELAY)-1:0]current_write_delay_count, next_write_delay_count;

logic [ADDRESS_WIDTH-1:0]address_reg, address_next;
logic current_read_en, next_read_en;
logic current_write_en, next_write_en;

logic [DATA_WIDTH-1:0]data_out_next;
logic [DATA_WIDTH-1:0]data_in_reg, data_in_next;

state_t [2:0]current_state, next_state;

always_ff @(posedge clk) begin
    if (current_write_en) begin
        memory[address_reg] <= mem_data_in;
    end
    else if (current_read_en) begin
        mem_data_out <= memory[address_reg];
    end
end

always_ff @(posedge clk) begin
    if (!rstN) begin
        current_state <= idle;
        address_reg  <= '0;
        current_read_en <= 1'b0;
        current_write_en <= 1'b0;

        current_read_delay_count <= '0;
        current_write_delay_count <= '0;

        data_in_reg <= '0;
    end
    else begin
        current_state   <= next_state;
        address_reg     <= address_next;
        current_read_en <= next_read_en;
        current_write_en <= next_write_en;

        current_read_delay_count <= next_read_delay_count;
        current_write_delay_count <= next_write_delay_count;

        data_in_reg <= data_in_next;
    end
end

always_comb begin
    next_state = current_state;
    address_next = address_reg;
    next_read_en = current_read_en;
    next_write_en = current_write_en;

    next_read_delay_count = current_read_delay_count;
    next_write_delay_count = current_write_delay_count;

    data_in_next = data_in_reg;

    case (current_state)
        idle: begin
            if (read_En) begin  // read has high priority
                next_state = load_0;
                address_next = address;
                next_read_en = 1'b1; 
                next_read_delay_count = '0;          
            end
            else if (write_En) begin
                address_next = address;
                data_in_next = data_in;
                if (func3 == SW) begin  // replace existing memory word
                    next_state = store_3;
                    next_write_en = 1'b1;
                    next_write_delay_count = '0;
                end
                else begin // read existing memory word and replace only the required part
                    next_state = store_0;
                    next_read_en = 1'b1;
                    next_read_delay_count = '0;
                end
            end
        end

        load_0: begin
            next_read_en = 1'b0;
            next_read_delay_count = current_read_delay_count + 1'b1;
            if (current_read_delay_count >= MEM_READ_DELAY) begin
                next_state = load_1;
            end
        end

        load_1: begin
            case (func3)
                LB: begin
                    data_out_next = DATA_WIDTH'(signed'(mem_data_out[7:0]));
                end
                LH: begin
                    data_out_next = DATA_WIDTH'(signed'(mem_data_out[DATA_WIDTH/2-1:0]));
                end
                LW: begin
                    data_out_next = mem_data_out;
                end
                LBU: begin
                    data_out_next = DATA_WIDTH'(mem_data_out[7:0]);
                end
                LHU: begin
                    data_out_next = DATA_WIDTH'(mem_data_out[DATA_WIDTH/2-1:0]);
                end
            endcase
            next_state = idle;
        end

        store_0: begin
            next_read_en = 1'b0;
            next_write_delay_count = current_write_delay_count + 1'b1;
            if (current_write_delay_count >= MEM_WRITE_DELAY) begin
                next_state = store_1;
            end
        end

        store_1: begin
            next_write_en = 1'b1;
            case (func3)
                SB: begin
                    mem_data_in_next = {mem_data_out[DATA_WIDTH-1:8],data_in_reg[7:0]};
                end
                SH: begin
                    mem_data_in_next = {mem_data_out[DATA_WIDTH-1:DATA_WIDTH/2],data_in_reg[DATA_WIDTH/2-1:0]};
                end
                SW: begin
                    mem_data_in_next = data_in_reg;
                end
            endcase
            next_state = idle;
        end
    endcase
end

assign ready = (current_state == idle)? 1'b1:1'b0;

endmodule : mem_controller