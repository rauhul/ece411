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

/* CONTROL WORD TYPES */
/* IF TYPES */
typedef enum bit [2:0] {
    lc3b_pc_mux_sel_pc_plus2,
    lc3b_pc_mux_sel_alu,
    lc3b_pc_mux_sel_pcn,
    lc3b_pc_mux_sel_mdr,
    lc3b_pc_mux_sel_branch_address,
    lc3b_pc_mux_sel_mispredict_address
} lc3b_pc_mux_sel;

/* ID TYPES */

/* EX TYPES */
typedef enum bit {
    lc3b_pc_adder_mux_sel_offset9,
    lc3b_pc_adder_mux_sel_offset11
} lc3b_pc_adder_mux_sel;

typedef enum bit [2:0] {
    lc3b_alu_mux_sel_sr2,
    lc3b_alu_mux_sel_imm4,
    lc3b_alu_mux_sel_imm5,
    lc3b_alu_mux_sel_offset6_b,
    lc3b_alu_mux_sel_offset6_w,
    lc3b_alu_mux_sel_x1,
    lc3b_alu_mux_sel_x2,
    lc3b_alu_mux_sel_x3
} lc3b_alu_mux_sel;

typedef enum bit [3:0] {
    lc3b_alu_op_add,
    lc3b_alu_op_and,
    lc3b_alu_op_not,
    lc3b_alu_op_pass,
    lc3b_alu_op_sll,
    lc3b_alu_op_srl,
    lc3b_alu_op_sra
} lc3b_alu_op;

/* MEM TYPES */
typedef enum bit [1:0] {
    lc3b_cc_gen_mux_sel_pcn,
    lc3b_cc_gen_mux_sel_alu,
    lc3b_cc_gen_mux_sel_mdr,
    lc3b_cc_gen_mux_sel_sr2
} lc3b_cc_gen_mux_sel;

typedef enum bit [1:0] {
    lc3b_data_memory_addr_mux_sel_trapvect8,
    lc3b_data_memory_addr_mux_sel_alu,
    lc3b_data_memory_addr_mux_sel_internal_mdr,
    lc3b_data_memory_addr_mux_sel_x1
} lc3b_data_memory_addr_mux_sel;

/* WB TYPES */
typedef enum bit [1:0] {
    lc3b_regfile_data_mux_sel_pc,
    lc3b_regfile_data_mux_sel_pcn,
    lc3b_regfile_data_mux_sel_mdr,
    lc3b_regfile_data_mux_sel_alu
} lc3b_regfile_data_mux_sel;

/* CONTROL WORD */
typedef struct packed {
    /* IF */
    lc3b_pc_mux_sel pc_mux_sel;

    /* ID */
    logic requires_sr1;
    logic requires_sr2;
    lc3b_reg regfile_sr1;
    lc3b_reg regfile_sr2;

    /* EX */
    lc3b_pc_adder_mux_sel pc_adder_mux_sel;
    lc3b_alu_mux_sel alu_mux_sel;
    lc3b_alu_op alu_op;

    /* MEM */
    logic cc_load;
    lc3b_cc_gen_mux_sel cc_gen_mux_sel;
    logic data_memory_access;
    logic data_memory_write_enable;
    lc3b_data_memory_addr_mux_sel data_memory_addr_mux_sel;
    logic data_memory_word_align;

    /* WB */
    lc3b_regfile_data_mux_sel regfile_data_mux_sel;
    lc3b_reg regfile_dest;
    logic regfile_load;

} lc3b_control_word;

/* INSTRUCTION TYPES */
typedef enum bit [3:0] {
    op_rti  = 4'b1000,

    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_shf  = 4'b1101,

    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,

    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_trap = 4'b1111
} lc3b_opcode;

/* FOWARDING */
typedef enum bit [1:0] {
    lc3b_forward_EX_mux_sel_pass,
    lc3b_forward_EX_mux_sel_stage_MEM_regfile_data,
    lc3b_forward_EX_mux_sel_stage_WB_regfile_data
} lc3b_forward_EX_mux_sel;

typedef enum bit {
    lc3b_forward_ID_mux_sel_pass,
    lc3b_forward_ID_mux_sel_stage_WB_regfile_data
} lc3b_forward_ID_mux_sel;

typedef struct packed {
    logic active;
    logic exclusive;

    /* BARRIER STALL */
    logic barrier_IF_ID_stall;
    logic barrier_ID_EX_stall;
    logic barrier_EX_MEM_stall;
    logic barrier_MEM_WB_stall;

    /* BARRIER RESET */
    logic barrier_IF_ID_reset;
    logic barrier_ID_EX_reset;
    logic barrier_EX_MEM_reset;
    logic barrier_MEM_WB_reset;

    /* BARRIER FORCE LOAD */
    logic barrier_ID_EX_force_sr1_load;
    logic barrier_ID_EX_force_sr2_load;

    /* STAGE STALL */
    logic stage_IF_stall;
    logic stage_ID_stall;
    logic stage_EX_stall;
    logic stage_MEM_stall;
    logic stage_WB_stall;

} lc3b_pipeline_control_word;

/* BRANCH PREDICTION */
typedef enum int unsigned {
    /* List of states */
    s_taken_2,
    s_taken,
    s_ntaken,
    s_ntaken_2
} lc3b_pattern_history_fsm_state;

endpackage : lc3b_types

