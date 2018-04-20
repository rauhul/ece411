import lc3b_types::*;

module cpu (
    /* MASTERS */
    wishbone.master instruction_memory_wishbone,
    wishbone.master data_memory_wishbone,

    /* debug */
    input logic debug_i_cache_hit,
    input logic debug_i_cache_miss,
    input logic debug_d_cache_hit,
    input logic debug_d_cache_miss,
    input logic debug_l2_cache_hit,
    input logic debug_l2_cache_miss
);

logic clk;
assign clk = instruction_memory_wishbone.CLK;

/** CONNECTIONS **/
/* STALL_ARBITER */
lc3b_pipeline_control_word  pipeline_control_out;

/* FORWARDING_CONTROLLER */
lc3b_forward_ID_mux_sel     forward_ID_A_mux_sel;
lc3b_forward_ID_mux_sel     forward_ID_B_mux_sel;
lc3b_forward_EX_mux_sel     forward_EX_A_mux_sel;
lc3b_forward_EX_mux_sel     forward_EX_B_mux_sel;
lc3b_pipeline_control_word  forwarding_controller_pipeline_control_request;

/* BRANCH_CONTROLLER */
lc3b_pipeline_control_word  branch_controller_pipeline_control_request;
lc3b_word                   branch_controller_pc;
lc3b_word                   branch_controller_pc_plus2;
logic                       debug_branch_prediction_correct;
logic                       debug_branch_prediction_incorrect;

/* STAGE_IF */
lc3b_word                   stage_IF_ir;
lc3b_word                   stage_IF_pc;
logic                       stage_IF_valid;
lc3b_pipeline_control_word  i_cache_pipeline_control_request;

/* BARRIER_IF_ID */
lc3b_word                   barrier_IF_ID_ir;
lc3b_word                   barrier_IF_ID_pc;
logic                       barrier_IF_ID_valid;

/* STAGE_ID */
lc3b_control_word           stage_ID_control;
lc3b_word                   stage_ID_sr1;
lc3b_word                   stage_ID_sr2;

/* BARRIER_ID_EX */
lc3b_control_word           barrier_ID_EX_control;
lc3b_word                   barrier_ID_EX_ir;
lc3b_word                   barrier_ID_EX_pc;
lc3b_word                   barrier_ID_EX_sr1;
lc3b_word                   barrier_ID_EX_sr2;
logic                       barrier_ID_EX_valid;

/* STAGE_EX */
lc3b_word                   stage_EX_alu;
lc3b_word                   stage_EX_pcn;
lc3b_word                   stage_EX_sr2;

/* BARRIER_EX_MEM */
lc3b_control_word           barrier_EX_MEM_control;
lc3b_word                   barrier_EX_MEM_alu;
lc3b_word                   barrier_EX_MEM_ir;
lc3b_word                   barrier_EX_MEM_pc;
lc3b_word                   barrier_EX_MEM_pcn;
lc3b_word                   barrier_EX_MEM_sr2;
logic                       barrier_EX_MEM_valid;

/* STAGE_MEM */
logic                       stage_MEM_br_en;
lc3b_word                   stage_MEM_mdr;
lc3b_word                   stage_MEM_regfile_data;
lc3b_pipeline_control_word  d_cache_pipeline_control_request;

/* BARRIER_MEM_WB */
lc3b_control_word           barrier_MEM_WB_control;
lc3b_word                   barrier_MEM_WB_alu;
lc3b_word                   barrier_MEM_WB_ir;
lc3b_word                   barrier_MEM_WB_mdr;
lc3b_word                   barrier_MEM_WB_pc;
lc3b_word                   barrier_MEM_WB_pcn;
logic                       barrier_MEM_WB_valid;

/* STAGE_WB */
lc3b_reg                    stage_WB_regfile_dest;
lc3b_word                   stage_WB_regfile_data;
logic                       stage_WB_regfile_load;

/** MODULES **/
stall_arbiter _stall_arbiter (
    /* INPUTS */
    .i_cache_pipeline_control_request,
    .d_cache_pipeline_control_request,
    .branch_controller_pipeline_control_request,
    .forwarding_controller_pipeline_control_request,

    /* OUTPUTS */
    .pipeline_control_out
);

forwarding_controller _forwarding_controller (
    /* INPUTS */
    .barrier_ID_EX_opcode(lc3b_opcode'(barrier_ID_EX_ir[15:12])),
    .barrier_EX_MEM_opcode(lc3b_opcode'(barrier_EX_MEM_ir[15:12])),
    .barrier_MEM_WB_opcode(lc3b_opcode'(barrier_MEM_WB_ir[15:12])),
    .barrier_ID_EX_control,
    .barrier_EX_MEM_control,
    .barrier_MEM_WB_control,

    /* OUTPUTS */
    .forward_ID_A_mux_sel,
    .forward_ID_B_mux_sel,
    .forward_EX_A_mux_sel,
    .forward_EX_B_mux_sel,
    .forwarding_controller_pipeline_control_request
);

branch_controller _branch_controller (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_IF_stall | i_cache_pipeline_control_request.active),

    .stage_IF_ir,
    .stage_IF_pc,
    .stage_IF_valid,

    .barrier_IF_ID_opcode(lc3b_opcode'(barrier_IF_ID_ir[15:12])),
    .barrier_IF_ID_valid,

    .barrier_ID_EX_opcode(lc3b_opcode'(barrier_ID_EX_ir[15:12])),
    .barrier_ID_EX_valid,

    .barrier_EX_MEM_alu,
    .barrier_EX_MEM_pcn,
    .barrier_EX_MEM_control,
    .barrier_EX_MEM_opcode(lc3b_opcode'(barrier_EX_MEM_ir[15:12])),
    .barrier_EX_MEM_valid,

    .stage_MEM_br_en,

    .barrier_MEM_WB_mdr,
    .barrier_MEM_WB_control,
    .barrier_MEM_WB_opcode(lc3b_opcode'(barrier_MEM_WB_ir[15:12])),
    .barrier_MEM_WB_valid,

    /* OUTPUTS */
    .pc_out(branch_controller_pc),
    .pc_plus2_out(branch_controller_pc_plus2),
    .branch_controller_pipeline_control_request,

    /* debug */
    .debug_branch_prediction_correct,
    .debug_branch_prediction_incorrect
);

stage_IF _stage_IF (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_IF_stall),
    .pc_in(branch_controller_pc),

    /* OUTPUTS */
    .ir_out(stage_IF_ir),
    .pc_out(stage_IF_pc),
    .valid_out(stage_IF_valid),
    .i_cache_pipeline_control_request,

    /* MEMORY INTERFACE */
    .instruction_memory_wishbone
);

barrier_IF_ID _barrier_IF_ID (
    /* INPUTS */
    .clk,
    .reset(pipeline_control_out.barrier_IF_ID_reset),
    .stall(pipeline_control_out.barrier_IF_ID_stall),
    .ir_in(stage_IF_ir),
    .pc_in(branch_controller_pc_plus2),
    .valid_in(stage_IF_valid),

    /* OUTPUTS */
    .ir_out(barrier_IF_ID_ir),
    .pc_out(barrier_IF_ID_pc),
    .valid_out(barrier_IF_ID_valid)
);

stage_ID _stage_ID (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_ID_stall),
    .ir_in(barrier_IF_ID_ir),
    .regfile_dest_in(stage_WB_regfile_dest),
    .regfile_data_in(stage_WB_regfile_data),
    .regfile_load_in(stage_WB_regfile_load),
    .forward_ID_A_mux_sel,
    .forward_ID_B_mux_sel,
    .stage_WB_regfile_data,

    /* OUTPUTS */
    .control_out(stage_ID_control),
    .sr1_out(stage_ID_sr1),
    .sr2_out(stage_ID_sr2)
);

barrier_ID_EX _barrier_ID_EX (
    /* INPUTS */
    .clk,
    .reset(pipeline_control_out.barrier_ID_EX_reset),
    .stall(pipeline_control_out.barrier_ID_EX_stall),
    .force_sr1_load(pipeline_control_out.barrier_ID_EX_force_sr1_load),
    .force_sr2_load(pipeline_control_out.barrier_ID_EX_force_sr2_load),
    .control_in(stage_ID_control),
    .ir_in(barrier_IF_ID_ir),
    .pc_in(barrier_IF_ID_pc),
    .sr1_in(stage_ID_sr1),
    .sr2_in(stage_ID_sr2),
    .valid_in(barrier_IF_ID_valid),

    /* OUTPUTS */
    .control_out(barrier_ID_EX_control),
    .ir_out(barrier_ID_EX_ir),
    .pc_out(barrier_ID_EX_pc),
    .sr1_out(barrier_ID_EX_sr1),
    .sr2_out(barrier_ID_EX_sr2),
    .valid_out(barrier_ID_EX_valid)
);

stage_EX _stage_EX (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_EX_stall),
    .control_in(barrier_ID_EX_control),
    .ir_in(barrier_ID_EX_ir),
    .pc_in(barrier_ID_EX_pc),
    .sr1_in(barrier_ID_EX_sr1),
    .sr2_in(barrier_ID_EX_sr2),
    .forward_EX_A_mux_sel,
    .forward_EX_B_mux_sel,
    .stage_MEM_regfile_data,
    .stage_WB_regfile_data,

    /* OUTPUTS */
    .alu_out(stage_EX_alu),
    .pcn_out(stage_EX_pcn),
    .sr2_out(stage_EX_sr2)
);

barrier_EX_MEM _barrier_EX_MEM (
    /* INPUTS */
    .clk,
    .reset(pipeline_control_out.barrier_EX_MEM_reset),
    .stall(pipeline_control_out.barrier_EX_MEM_stall),
    .control_in(barrier_ID_EX_control),
    .alu_in(stage_EX_alu),
    .ir_in(barrier_ID_EX_ir),
    .pc_in(barrier_ID_EX_pc),
    .pcn_in(stage_EX_pcn),
    .sr2_in(stage_EX_sr2),
    .valid_in(barrier_ID_EX_valid),

    /* OUTPUTS */
    .control_out(barrier_EX_MEM_control),
    .alu_out(barrier_EX_MEM_alu),
    .ir_out(barrier_EX_MEM_ir),
    .pc_out(barrier_EX_MEM_pc),
    .pcn_out(barrier_EX_MEM_pcn),
    .sr2_out(barrier_EX_MEM_sr2),
    .valid_out(barrier_EX_MEM_valid)
);

stage_MEM _stage_MEM (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_MEM_stall),
    .control_in(barrier_EX_MEM_control),
    .alu_in(barrier_EX_MEM_alu),
    .ir_in(barrier_EX_MEM_ir),
    .pc_in(barrier_EX_MEM_pc),
    .pcn_in(barrier_EX_MEM_pcn),
    .sr2_in(barrier_EX_MEM_sr2),

    /* debug */
    .debug_branch_prediction_correct,
    .debug_branch_prediction_incorrect,

    .debug_i_cache_hit,
    .debug_i_cache_miss,
    .debug_d_cache_hit,
    .debug_d_cache_miss,
    .debug_l2_cache_hit,
    .debug_l2_cache_miss,

    .debug_stage_IF_stall(pipeline_control_out.stage_IF_stall),
    .debug_stage_ID_stall(pipeline_control_out.stage_ID_stall),
    .debug_stage_EX_stall(pipeline_control_out.stage_EX_stall),
    .debug_stage_MEM_stall(pipeline_control_out.stage_MEM_stall),
    .debug_stage_WB_stall(pipeline_control_out.stage_WB_stall),

    /* OUTPUTS */
    .br_en_out(stage_MEM_br_en),
    .mdr_out(stage_MEM_mdr),
    .d_cache_pipeline_control_request,
    .regfile_data_out(stage_MEM_regfile_data),

    /* MEMORY INTERFACE */
    .data_memory_wishbone
);

barrier_MEM_WB _barrier_MEM_WB (
    /* INPUTS */
    .clk,
    .reset(pipeline_control_out.barrier_MEM_WB_reset),
    .stall(pipeline_control_out.barrier_MEM_WB_stall),
    .control_in(barrier_EX_MEM_control),
    .alu_in(barrier_EX_MEM_alu),
    .ir_in(barrier_EX_MEM_ir),
    .mdr_in(stage_MEM_mdr),
    .pc_in(barrier_EX_MEM_pc),
    .pcn_in(barrier_EX_MEM_pcn),
    .valid_in(barrier_EX_MEM_valid),

    /* OUTPUTS */
    .control_out(barrier_MEM_WB_control),
    .alu_out(barrier_MEM_WB_alu),
    .ir_out(barrier_MEM_WB_ir),
    .mdr_out(barrier_MEM_WB_mdr),
    .pc_out(barrier_MEM_WB_pc),
    .pcn_out(barrier_MEM_WB_pcn),
    .valid_out(barrier_MEM_WB_valid)
);

stage_WB _stage_WB (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_WB_stall),
    .control_in(barrier_MEM_WB_control),
    .alu_in(barrier_MEM_WB_alu),
    .ir_in(barrier_MEM_WB_ir),
    .mdr_in(barrier_MEM_WB_mdr),
    .pc_in(barrier_MEM_WB_pc),
    .pcn_in(barrier_MEM_WB_pcn),

    /* OUTPUTS */
    .regfile_dest_out(stage_WB_regfile_dest),
    .regfile_data_out(stage_WB_regfile_data),
    .regfile_load_out(stage_WB_regfile_load)
);

endmodule : cpu
