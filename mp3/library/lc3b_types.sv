package lc3b_types;

/* MP3 */
typedef logic [15:0] lc3b_word;
typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_cc;

typedef logic [10:0] lc3b_offset11;
typedef logic  [8:0] lc3b_offset9;
typedef logic  [7:0] lc3b_trapvect8;
typedef logic  [5:0] lc3b_offset6;
typedef logic  [4:0] lc3b_imm5;
typedef logic  [3:0] lc3b_imm4;

typedef enum bit [3:0] {
    alu_add,
    alu_and,
    alu_not,
    alu_pass,
    alu_sll,
    alu_srl,
    alu_sra
} lc3b_aluop;

/* CONTROL WORD TYPES */
/* IF TYPES */

/* ID TYPES */
typedef enum bit {
    lc3b_regfile_sr1_mux_sel_sr1,
    lc3b_regfile_sr1_mux_sel_dest
} lc3b_regfile_sr1_mux_sel;

typedef enum bit {
    lc3b_regfile_sr2_mux_sel_sr2,
    lc3b_regfile_sr2_mux_sel_dest
} lc3b_regfile_sr2_mux_sel;

/* EX TYPES */

/* MEM TYPES */
typedef enum bit [1:0] {
    lc3b_cc_gen_mux_sel_pcn,
    lc3b_cc_gen_mux_sel_alu,
    lc3b_cc_gen_mux_sel_mdr,
    lc3b_cc_gen_mux_sel_sr2
} lc3b_cc_gen_mux_sel;

/* WB TYPES */

/* CONTROL WORD */
typedef struct packed {
    /* IF */
    logic branch;

    /* ID */
    lc3b_regfile_sr1_mux_sel regfile_sr1_mux_sel;
    lc3b_regfile_sr2_mux_sel regfile_sr2_mux_sel;

    /* EX */
    logic pc_adder_mux_sel;
    logic [2:0] general_alu_mux_sel;
    lc3b_aluop general_alu_op;

    /* MEM */
    logic cc_load;
    lc3b_cc_gen_mux_sel cc_gen_mux_sel;
    logic br_en_load;
    logic internal_mdr_load;
    logic data_memory_write_enable;
    logic [1:0] data_memory_addr_mux_sel;
    logic [1:0] data_memory_byte_sel;

    /* WB */
    logic [2:0] regfile_data_mux_sel;
    logic regfile_dest_mux_sel;
    logic regfile_load;

} lc3b_control_word;

/* INSTRUCTION TYPES */

typedef enum bit [3:0] {
    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_rti  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

/* OLD */
typedef logic  [7:0] lc3b_byte;
typedef logic  [1:0] lc3b_mem_wmask;

typedef logic [127:0] lc3b_cache_word;
// ADDR: {[15:7] tag, [6:4] index, [3:0] offset }
typedef logic [8:0] lc3b_cache_tag;
typedef logic [2:0] lc3b_cache_index;
typedef logic [3:0] lc3b_cache_offset;


endpackage : lc3b_types
