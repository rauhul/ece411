import lc3b_types::*;

module cpu (
    /* INPUTS */
    input clk,

    /* OUTPUTS */

    /* MEMORY INTERFACE */
    wishbone.master instruction_memory_wishbone,
    wishbone.master data_memory_wishbone
);


/* STAGE IF */
lc3b_word barrier_ID_EX_sr1;
lc3b_word barrier_EX_MEM_pcn;
lc3b_word barrier_MEM_WB_mdr;
lc3b_word stage_IF_ir;
lc3b_word stage_IF_pc_plus2;
stage_IF _stage_IF (
    /* INPUTS */
    .clk,
    .pc_mux_sel(),
    .mdr_in(barrier_MEM_WB_mdr),
    .pcn_in(barrier_EX_MEM_pcn),
    .sr1_in(barrier_ID_EX_sr1),

    /* OUTPUTS */
    .ir_out(stage_IF_ir),
    .pc_plus2_out(stage_IF_pc_plus2),

    /* MEMORY INTERFACE */
    .instruction_memory_wishbone
);


/* BARRIER IF <-> ID */
lc3b_word barrier_IF_ID_ir;
lc3b_word barrier_IF_ID_pc;
barrier_IF_ID _barrier_IF_ID (
    /* INPUTS */
    .clk,
    .ir_in(stage_IF_ir),
    .pc_in(stage_IF_pc_plus2),

    /* OUTPUTS */
    .ir_out(barrier_IF_ID_ir),
    .pc_out(barrier_IF_ID_pc)
);


/* STAGE ID */
lc3b_reg stage_WB_regfile_dest;
lc3b_word stage_WB_regfile_data;
logic stage_WB_regfile_load;
lc3b_control_word stage_ID_control;
lc3b_word stage_ID_sr1;
lc3b_word stage_ID_sr2;
stage_ID _stage_ID (
    /* INPUTS */
    .clk,
    .ir_in(barrier_IF_ID_ir),
    .regfile_dest_in(stage_WB_regfile_dest),
    .regfile_data_in(stage_WB_regfile_data),
    .regfile_load_in(stage_WB_regfile_load),

    /* OUTPUTS */
    .control_out(stage_ID_control),
    .sr1_out(stage_ID_sr1),
    .sr2_out(stage_ID_sr2)
);


/* BARRIER ID <-> EX */
lc3b_control_word barrier_ID_EX_control;
lc3b_word barrier_ID_EX_ir;
lc3b_word barrier_ID_EX_pc;
// barrier_ID_EX_sr1 is defined above stage_IF
lc3b_word barrier_ID_EX_sr2;
barrier_ID_EX _barrier_ID_EX (
    /* INPUTS */
    .clk,
    .control_in(stage_ID_control),
    .ir_in(barrier_IF_ID_ir),
    .pc_in(barrier_IF_ID_pc),
    .sr1_in(stage_ID_sr1),
    .sr2_in(stage_ID_sr2),

    /* OUTPUTS */
    .control_out(barrier_ID_EX_control),
    .ir_out(barrier_ID_EX_ir),
    .pc_out(barrier_ID_EX_pc),
    .sr1_out(barrier_ID_EX_sr1),
    .sr2_out(barrier_ID_EX_sr2)
);


/* STAGE EX */
lc3b_word stage_EX_alu;
lc3b_word stage_EX_pcn;
stage_EX _stage_EX (
    /* INPUTS */
    .clk,
    .control_in(barrier_ID_EX_control),
    .ir_in(barrier_ID_EX_ir),
    .pc_in(barrier_ID_EX_pc),
    .sr1_in(barrier_ID_EX_sr1),
    .sr2_in(barrier_ID_EX_sr2),

    /* OUTPUTS */
    .alu_out(stage_EX_alu),
    .pcn_out(stage_EX_pcn)
);


/* BARRIER EX <-> MEM */
lc3b_control_word barrier_EX_MEM_control;
lc3b_word barrier_EX_MEM_alu;
lc3b_word barrier_EX_MEM_ir;
lc3b_word barrier_EX_MEM_pc;
// barrier_EX_MEM_pcn is defined above stage_IF
lc3b_word barrier_EX_MEM_sr2;
barrier_EX_MEM _barrier_EX_MEM (
    /* INPUTS */
    .clk,
    .control_in(barrier_ID_EX_control),
    .alu_in(stage_EX_alu),
    .ir_in(barrier_ID_EX_ir),
    .pc_in(barrier_ID_EX_pc),
    .pcn_in(stage_EX_pcn),
    .sr2_in(barrier_ID_EX_sr2),

    /* OUTPUTS */
    .control_out(barrier_EX_MEM_control),
    .alu_out(barrier_EX_MEM_alu),
    .ir_out(barrier_EX_MEM_ir),
    .pc_out(barrier_EX_MEM_pc),
    .pcn_out(barrier_EX_MEM_pcn),
    .sr2_out(barrier_EX_MEM_sr2)
);


/* STAGE MEM */
lc3b_cc stage_MEM_cc;
lc3b_word stage_MEM_mdr;
stage_MEM _stage_MEM (
    /* INPUTS */
    .clk,
    .control_in(barrier_EX_MEM_control),
    .alu_in(barrier_EX_MEM_alu),
    .ir_in(barrier_EX_MEM_ir),
    .sr2_in(barrier_EX_MEM_sr2),

    /* OUTPUTS */
    .cc_out(stage_MEM_cc),
    .mdr_out(stage_MEM_mdr),

    /* MEMORY INTERFACE */
    .data_memory_wishbone
);


/* BARRIER MEM <-> WB */
lc3b_cc barrier_MEM_WB_cc;
lc3b_control_word barrier_MEM_WB_control;
lc3b_word barrier_MEM_WB_alu;
lc3b_word barrier_MEM_WB_ir;
// barrier_MEM_WB_mdr is defined above stage_IF
lc3b_word barrier_MEM_WB_pc;
lc3b_word barrier_MEM_WB_pcn;
barrier_MEM_WB _barrier_MEM_WB (
    /* INPUTS */
    .clk,
    .control_in(barrier_EX_MEM_control),
    .alu_in(barrier_EX_MEM_alu),
    .ir_in(barrier_EX_MEM_ir),
    .mdr_in(stage_MEM_mdr),
    .pc_in(barrier_EX_MEM_pc),
    .pcn_in(barrier_EX_MEM_pcn),

    /* OUTPUTS */
    .control_out(barrier_MEM_WB_control),
    .alu_out(barrier_MEM_WB_alu),
    .ir_out(barrier_MEM_WB_ir),
    .mdr_out(barrier_MEM_WB_mdr),
    .pc_out(barrier_MEM_WB_pc),
    .pcn_out(barrier_MEM_WB_pcn)
);


/* STAGE WB */
// stage_WB_regfile_* are defined above stage_ID
stage_WB _stage_WB (
    /* INPUTS */
    .clk,
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
