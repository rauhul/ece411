import lc3b_types::*;

module cpu (
    /* MASTERS */
    wishbone.master instruction_memory_wishbone,
    wishbone.master data_memory_wishbone
);

logic clk;
assign clk = instruction_memory_wishbone.CLK;


/* DATA FORWARDING LOGIC */
lc3b_word barrier_ID_EX_ir;
lc3b_word barrier_EX_MEM_ir;
lc3b_word barrier_MEM_WB_ir;
lc3b_control_word barrier_ID_EX_control;
lc3b_control_word barrier_EX_MEM_control;
lc3b_control_word barrier_MEM_WB_control;
lc3b_forward_mux_sel forward_A_mux_sel;
lc3b_forward_mux_sel forward_B_mux_sel;
forwarding_controller _forwarding_controller (
    /* INPUTS */
    .barrier_ID_EX_opcode(lc3b_opcode'(barrier_ID_EX_ir[15:12])),
    .barrier_EX_MEM_opcode(lc3b_opcode'(barrier_EX_MEM_ir[15:12])),
    .barrier_MEM_WB_opcode(lc3b_opcode'(barrier_MEM_WB_ir[15:12])),
    .barrier_ID_EX_control(barrier_ID_EX_control),
    .barrier_EX_MEM_control(barrier_EX_MEM_control),
    .barrier_MEM_WB_control(barrier_MEM_WB_control),

    /* OUTPUTS */
    .forward_A_mux_sel,
    .forward_B_mux_sel
);


/* STALL LOGIC */
lc3b_pipeline_control_word i_cache_pipeline_control_request;
lc3b_pipeline_control_word d_cache_pipeline_control_request;
lc3b_pipeline_control_word branch_controller_pipeline_control_request;
lc3b_pipeline_control_word pipeline_control_out;
stall_arbiter _stall_arbiter (
    /* INPUTS */
    .i_cache_pipeline_control_request,
    .d_cache_pipeline_control_request,
    .branch_controller_pipeline_control_request,

    /* OUTPUTS */
    .pipeline_control_out
);


/* BRANCH LOGIC */
logic barrier_IF_ID_valid;
logic barrier_ID_EX_valid;
logic barrier_EX_MEM_valid;
logic barrier_MEM_WB_valid;
lc3b_word barrier_IF_ID_ir;
branch_controller _branch_controller (
    /* INPUTS */
    .barrier_IF_ID_valid,
    .barrier_ID_EX_valid,
    .barrier_EX_MEM_valid,
    .barrier_MEM_WB_valid,
    .barrier_IF_ID_opcode(lc3b_opcode'(barrier_IF_ID_ir[15:12])),
    .barrier_ID_EX_opcode(lc3b_opcode'(barrier_ID_EX_ir[15:12])),
    .barrier_EX_MEM_opcode(lc3b_opcode'(barrier_EX_MEM_ir[15:12])),
    .barrier_MEM_WB_opcode(lc3b_opcode'(barrier_MEM_WB_ir[15:12])),

    /* OUTPUTS */
    .branch_controller_pipeline_control_request
);


/* BRANCH LOGIC */
logic stage_MEM_br_en;

lc3b_pc_mux_sel stage_IF_pc_mux_sel;
always_comb begin
    stage_IF_pc_mux_sel = barrier_MEM_WB_control.pc_mux_sel;
    if (barrier_MEM_WB_control.conditional_branch & ~stage_MEM_br_en) begin
        stage_IF_pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;
    end
end


/* STAGE IF */
lc3b_word barrier_MEM_WB_alu;
lc3b_word barrier_MEM_WB_mdr;
lc3b_word barrier_MEM_WB_pcn;
lc3b_word stage_IF_ir;
lc3b_word stage_IF_pc_plus2;
stage_IF _stage_IF (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_IF_stall),
    .pc_mux_sel(stage_IF_pc_mux_sel),
    .alu_in(barrier_MEM_WB_alu),
    .mdr_in(barrier_MEM_WB_mdr),
    .pcn_in(barrier_MEM_WB_pcn),

    /* OUTPUTS */
    .ir_out(stage_IF_ir),
    .pc_plus2_out(stage_IF_pc_plus2),
    .i_cache_pipeline_control_request,

    /* MEMORY INTERFACE */
    .instruction_memory_wishbone
);


/* BARRIER IF <-> ID */
// barrier_IF_ID_ir is defined above branch_controller
lc3b_word barrier_IF_ID_pc;
barrier_IF_ID _barrier_IF_ID (
    /* INPUTS */
    .clk,
    .reset(pipeline_control_out.barrier_IF_ID_reset),
    .stall(pipeline_control_out.barrier_IF_ID_stall),
    .ir_in(stage_IF_ir),
    .pc_in(stage_IF_pc_plus2),

    /* OUTPUTS */
    .ir_out(barrier_IF_ID_ir),
    .pc_out(barrier_IF_ID_pc),
    .valid_out(barrier_IF_ID_valid)
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
    .stall(pipeline_control_out.stage_ID_stall),
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
// barrier_ID_EX_control is defined above forwarding_controller
// barrier_ID_EX_ir is defined above forwarding_controller
lc3b_word barrier_ID_EX_pc;
lc3b_word barrier_ID_EX_sr1;
lc3b_word barrier_ID_EX_sr2;
barrier_ID_EX _barrier_ID_EX (
    /* INPUTS */
    .clk,
    .reset(pipeline_control_out.barrier_ID_EX_reset),
    .stall(pipeline_control_out.barrier_ID_EX_stall),
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


/* STAGE EX */
lc3b_word stage_EX_alu;
lc3b_word stage_EX_pcn;
lc3b_word stage_MEM_regfile_data;
stage_EX _stage_EX (
    /* INPUTS */
    .clk,
    .stall(pipeline_control_out.stage_EX_stall),
    .control_in(barrier_ID_EX_control),
    .ir_in(barrier_ID_EX_ir),
    .pc_in(barrier_ID_EX_pc),
    .sr1_in(barrier_ID_EX_sr1),
    .sr2_in(barrier_ID_EX_sr2),
    .forward_A_mux_sel,
    .forward_B_mux_sel,
    .stage_MEM_regfile_data,
    .stage_WB_regfile_data,

    /* OUTPUTS */
    .alu_out(stage_EX_alu),
    .pcn_out(stage_EX_pcn)
);


/* BARRIER EX <-> MEM */
// barrier_EX_MEM_control is defined above forwarding_controller
lc3b_word barrier_EX_MEM_alu;
// barrier_EX_MEM_ir is defined above forwarding_controller
lc3b_word barrier_EX_MEM_pc;
lc3b_word barrier_EX_MEM_pcn;
lc3b_word barrier_EX_MEM_sr2;
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
    .sr2_in(barrier_ID_EX_sr2),
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


/* STAGE MEM */
// stage_MEM_br_en is defined above branch_logic
lc3b_word stage_MEM_mdr;
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

    /* OUTPUTS */
    .br_en_out(stage_MEM_br_en),
    .mdr_out(stage_MEM_mdr),
    .d_cache_pipeline_control_request,
    .regfile_data_out(stage_MEM_regfile_data),

    /* MEMORY INTERFACE */
    .data_memory_wishbone
);


/* BARRIER MEM <-> WB */
// barrier_MEM_WB_control is defined above forwarding_controller
// barrier_MEM_WB_alu is defined above stage_IF
// barrier_MEM_WB_ir is defined above forwarding_controller
// barrier_MEM_WB_mdr is defined above stage_IF
lc3b_word barrier_MEM_WB_pc;
// barrier_MEM_WB_pcn is defined above stage_IF
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


/* STAGE WB */
// stage_WB_regfile_* are defined above stage_ID
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
