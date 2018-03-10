import lc3b_types::*;

module cpu_datapath(
    input clk,

);

//Internal Signals

//Control rom
lc3b_control_word ctrl;

logic [1:0] pcmux_sel;
logic load_pc;
lc3b_word pc_plus2_out;
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word mdr_out;
lc3b_word pcn_out;
stage_IF _stage_IF (
    /* INPUTS */
    .clk,
    .pcmux_sel(pc_mux_sel),
    .load_pc(load_pc),
    .sr1_out(sr1_out),
    .pcn_out(pcn_out),
    .mdr_out(mdr_out),

    /* OUTPUTS */
    .pc_plus2_out(pc_plus2_out),
    .pcmux_out(pcmux_out),
    .pc_out(pc_out)
);


lc3b_word barrier_IF_ID_ir;
lc3b_word barrier_IF_ID_pc;
barrier_IF_ID _barrier_IF_ID (
    /* INPUTS */
    .clk,
    .ir_in(pc_out),
    .pc_in(pc_plus2_out),

    /* OUTPUTS */
    .ir_out(barrier_IF_ID_ir),
    .pc_out(barrier_IF_ID_pc)
);


lc3b_control_word stage_ID_control;
lc3b_control_word stage_ID_sr1;
lc3b_control_word stage_ID_sr2;
stage_ID _stage_ID (
    /* INPUTS */
    .clk(clk),
    .ir_in(barrier_IF_ID_ir),
    .regfile_data_in( ERROR, THESE SHOULD COME FROM WB ),
    .regfile_load_in( ERROR, THESE SHOULD COME FROM WB ),
    .regfile_dest_in( ERROR, THESE SHOULD COME FROM WB ),

    /* OUTPUTS */
    .control_out(stage_ID_control)
    .sr1_out(stage_ID_sr1),
    .sr2_out(stage_ID_sr2)
);


lc3b_control_word barrier_ID_EX_control;
lc3b_word barrier_ID_EX_ir;
lc3b_word barrier_ID_EX_pc;
lc3b_word barrier_ID_EX_sr1;
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


lc3b_control_word barrier_EX_MEM_control;
lc3b_word barrier_EX_MEM_alu_out;
lc3b_word barrier_EX_MEM_ir;
lc3b_word barrier_EX_MEM_pc;
lc3b_word barrier_EX_MEM_pcn;
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
    .alu_out(barrier_EX_MEM_alu_out),
    .ir_out(barrier_EX_MEM_ir),
    .pc_out(barrier_EX_MEM_pc),
    .pcn_out(barrier_EX_MEM_pcn),
    .sr2_out(barrier_EX_MEM_sr2)
);


//Internal signals: outputs of MEM stage
lc3b_word stage_MEM_dcache_out;
lc3b_word stage_MEM_gencc_out;


// STAGE_MEM


//Internal signals: outputs of barrier_MEM_WB
lc3b_cc barrier_MEM_WB_cc;
lc3b_control_word barrier_MEM_WB_control;
lc3b_word barrier_MEM_WB_alu;
lc3b_word barrier_MEM_WB_ir;
lc3b_word barrier_MEM_WB_mdr;
lc3b_word barrier_MEM_WB_pc;
lc3b_word barrier_MEM_WB_pcn;
barrier_MEM_WB _barrier_MEM_WB (
    /* INPUTS */
    .clk,
    .cc_in(stage_MEM_gencc_out),
    .control_in(barrier_EX_MEM_control),
    .alu_in(barrier_EX_MEM_alu_out),
    .ir_in(barrier_EX_MEM_ir),
    .mdr_in(stage_MEM_dcache_out),
    .pc_in(barrier_EX_MEM_pc),
    .pcn_in(barrier_EX_MEM_pcn),

    /* OUTPUTS */
    .cc_out(barrier_MEM_WB_cc),
    .control_out(barrier_MEM_WB_control),
    .alu_out(barrier_MEM_WB_alu),
    .ir_out(barrier_MEM_WB_ir),
    .mdr_out(barrier_MEM_WB_mdr),
    .pc_out(barrier_MEM_WB_pc),
    .pcn_out(barrier_MEM_WB_pcn)
);


lc3b_word regfiledatamux_out;
lc3b_word stage_WB_mux2_out;
lc3b_word stage_WB_control_out;
stage_WB _stage_WB (
    /* INPUTS */
    .clk,
    .pc_in(barrier_MEM_WB_pc),
    .pcn_in(barrier_MEM_WB_pcn),
    .control_in(barrier_MEM_WB_controrl),
    .ir_in(barrier_MEM_WB_ir),
    .mdr_in(barrier_MEM_WB_mdr_out),
    .alu_in(barrier_MEM_WB_alu_out),

    /* OUTPUTS */
    .regfiledatamux_out(regfiledatamux_out),
    .WB_mux2_out(stage_WB_mux2_out),
    .control_out(stage_WB_control_out)
);

endmodule : cpu_datapath
