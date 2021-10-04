package definitions;

typedef enum logic [2:0] {
    ld_byte_s,
    ld_byte_u,
    ld_half_word_s,
    ld_half_word_u,
    ld_word,
    str_byte,
    str_half_word,
    str_word
} mem_operation_t;


endpackage : definitions