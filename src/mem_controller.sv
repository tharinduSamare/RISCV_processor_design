module mem_controller 
#(
    MEMORY_DEPTH = 4096, // acts as an circular array. If depth is less than 2**address_width, takes the modulo.
    ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32
)
(
    input logic clk,rstN,write_En,read_En,
    input logic [2:0]func3_in,
    input logic [ADDRESS_WIDTH-1:0]address,
    input logic [DATA_WIDTH-1:0]data_in,
    output logic [DATA_WIDTH-1:0]data_out,
    output logic ready
);

// typedef enum logic[2:0] { 
//     LB  = 3'b000,
//     LH  = 3'b001,
//     LW  = 3'b010,
//     LBU = 3'b100,
//     LHU = 3'b101,
//     NO_READ_0 = 3'b011,
//     NO_READ_1 = 3'b110,
//     NO_READ_2 = 3'b111
// } func3_load_t;

// typedef enum logic[2:0]{
//     SB  = 3'b000,
//     SH  = 3'b001,
//     SW  = 3'b010,
//     NO_STORE_0 = 3'b011,
//     NO_STORE_1 = 3'b100,
//     NO_STORE_2 = 3'b101,
//     NO_STORE_3 = 3'b110,
//     NO_STORE_4 = 3'b111
// } func3_t_store_t;

typedef enum logic[3:0] { 
    LB ,
    LH ,
    LW ,
    LBU,
    LHU,
    SB ,
    SH ,
    SW ,
    NOP
} func3_t;

// func3_t ffff ;
// assing fffff = func3_t'(func3_in);

func3_t func3, func3_reg, func3_next; 
always_comb begin
    if (read_En) begin
        case (func3_in)
            3'b000 : func3 = LB ;
            3'b001 : func3 = LH ;
            3'b010 : func3 = LW ;
            3'b100 : func3 = LBU;
            3'b101 : func3 = LHU;
            default: func3 = NOP ;
        endcase
    end
    else if (write_En) begin
        case (func3_in)
            3'b000 : func3 = SB ;
            3'b001 : func3 = SH ;
            3'b010 : func3 = SW ;
            default: func3 = NOP ;
        endcase
    end
    else begin
        func3 = NOP;
    end
end


localparam MEM_READ_DELAY = 2;
localparam MEM_WRITE_DELAY = 2;

// localparam [2:0]
//     LB  = 3'b000,
//     LH  = 3'b001,
//     LW  = 3'b010,
//     LBU = 3'b100,
//     LHU = 3'b101,
//     SB  = 3'b000, 
//     SH  = 3'b001,
//     SW  = 3'b010;
    

typedef enum logic[3:0] { 
    idle,
    load_0,
    load_1,
    store_0,
    store_1
} state_t;


logic [DATA_WIDTH-1:0]mem_data_out;
logic [DATA_WIDTH-1:0]mem_data_in, mem_data_in_next;

logic [$clog2(MEM_READ_DELAY):0]current_read_delay_count, next_read_delay_count;
logic [$clog2(MEM_WRITE_DELAY):0]current_write_delay_count, next_write_delay_count;

logic [ADDRESS_WIDTH-3:0]address_reg, address_next; // do not include last 2 bits 
logic [1:0]addr_LSB_bits_reg, addr_LSB_bits_next; // last 2 bits of the address used for LHW, LB, SHW, SB etc.
logic current_read_en, next_read_en;
logic current_write_en, next_write_en;

logic [DATA_WIDTH-1:0]data_out_next, data_out_reg;
logic [DATA_WIDTH-1:0]data_in_reg, data_in_next;

state_t current_state, next_state;


logic [DATA_WIDTH-1:0]memory[0:MEMORY_DEPTH-1];

initial begin
    $readmemh("C:\\Xilinx\\SoC_project\\src\\data_mem_init.txt", memory);
    // $readmemh("D:\\ACA\\SEM7_TRONIC_ACA\\17 - Advance Digital Systems\\2020\\assignment_2\\SoC_project\\src\\data_mem_init.txt", memory);
end

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
        addr_LSB_bits_reg <= '0;
        current_read_en <= 1'b0;
        current_write_en <= 1'b0;

        current_read_delay_count <= '0;
        current_write_delay_count <= '0;

        data_in_reg <= '0;
        data_out_reg <= '0;
        mem_data_in <= '0;

        func3_reg <= LW;
    end
    else begin
        current_state   <= next_state;
        address_reg     <= address_next;
        addr_LSB_bits_reg <= addr_LSB_bits_next;
        current_read_en <= next_read_en;
        current_write_en <= next_write_en;

        current_read_delay_count <= next_read_delay_count;
        current_write_delay_count <= next_write_delay_count;

        data_in_reg <= data_in_next;
        data_out_reg <= data_out_next;
        mem_data_in <= mem_data_in_next;

        func3_reg <= func3_next;
    end
end

always_comb begin
    next_state = current_state;
    address_next = address_reg;
    addr_LSB_bits_next = addr_LSB_bits_reg;
    next_read_en = current_read_en;
    next_write_en = current_write_en;

    next_read_delay_count = current_read_delay_count;
    next_write_delay_count = current_write_delay_count;

    data_in_next = data_in_reg;
    data_out_next = data_out_reg;
    mem_data_in_next = mem_data_in;

    func3_next = func3_reg;

    case (current_state)
        idle: begin
            next_write_en = 1'b0;
            if (read_En) begin  // read has high priority
                next_state = load_0;
                address_next = address[ADDRESS_WIDTH-1:2];
                addr_LSB_bits_next = address[1:0];
                next_read_en = 1'b1; 
                next_read_delay_count = '0;  
                func3_next = func3;     
            end
            else if (write_En) begin
                address_next = address[ADDRESS_WIDTH-1:2];
                data_in_next = data_in;
                func3_next = func3;  
                if (func3 == SW) begin  // replace existing memory word
                    next_state = store_1;
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
            case (func3_reg)
                LB: begin
                    data_out_next = DATA_WIDTH'(signed'(mem_data_out[addr_LSB_bits_reg*8 +:8]));
                end
                LH: begin
                    data_out_next = DATA_WIDTH'(signed'(mem_data_out[addr_LSB_bits_reg[1]*16 +:16]));
                end
                LW: begin
                    data_out_next = mem_data_out;
                end
                LBU: begin
                    data_out_next = DATA_WIDTH'(mem_data_out[addr_LSB_bits_reg*8 +:8]);
                end
                LHU: begin
                    data_out_next = DATA_WIDTH'(mem_data_out[addr_LSB_bits_reg[1]*16 +:16]);
                end
                default: begin
                    data_out_next = mem_data_out;  // default = LW
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
            case (func3_reg)
                SB: begin
                    mem_data_in_next = {mem_data_out[DATA_WIDTH-1:8],data_in_reg[7:0]}; // stores the low 8 bits
                end
                SH: begin
                    mem_data_in_next = {mem_data_out[DATA_WIDTH-1:DATA_WIDTH/2],data_in_reg[DATA_WIDTH/2-1:0]}; // stores low 16 bits
                end
                SW: begin
                    mem_data_in_next = data_in_reg;
                end
                default: begin
                    mem_data_in_next = data_in_reg; // default = SW
                end
            endcase
            next_state = idle;
        end
    endcase
end

assign ready = (current_state == idle)? 1'b1:1'b0;
assign data_out = data_out_reg;


endmodule : mem_controller