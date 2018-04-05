import lc3b_types::*;

module cpu (
    /* MASTERS */
    wishbone.master instruction_memory_wishbone,
    wishbone.master data_memory_wishbone
);

logic clk;
assign clk = instruction_memory_wishbone.CLK;

/* STALL LOGIC */
logic barrier_IF_ID_valid;
logic barrier_ID_EX_valid;
logic barrier_EX_MEM_valid;
logic barrier_MEM_WB_valid;
lc3b_word barrier_IF_ID_ir;
lc3b_word barrier_ID_EX_ir;
lc3b_word barrier_EX_MEM_ir;
lc3b_word barrier_MEM_WB_ir;

logic branch_controller_stage_IF_stall;
logic barrier_IF_ID_reset;
logic barrier_ID_EX_reset;
logic barrier_EX_MEM_reset;
logic barrier_MEM_WB_reset;
branch_controller i_branch_controller (
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
    .stage_IF_stall(branch_controller_stage_IF_stall),
    .barrier_IF_ID_reset,
    .barrier_ID_EX_reset,
    .barrier_EX_MEM_reset,
    .barrier_MEM_WB_reset
);

logic stage_IF_request_stall;
logic stage_MEM_request_stall;
logic barrier_EX_MEM_stall;
logic barrier_ID_EX_stall;
logic barrier_IF_ID_stall;
logic barrier_MEM_WB_stall;
logic stage_EX_stall;
logic stage_ID_stall;
logic stage_IF_stall;
logic stage_MEM_stall;
logic stage_WB_stall;




stall_controller _stall_controller (
    /* INPUTS */
    .clk,
    .stage_IF_request_stall,
    .stage_MEM_request_stall,

    /* OUTPUTS */
    .barrier_EX_MEM_stall,
    .barrier_ID_EX_stall,
    .barrier_IF_ID_stall,
    .barrier_MEM_WB_stall,
    .stage_EX_stall,
    .stage_ID_stall,
    .stage_IF_stall,
    .stage_MEM_stall,
    .stage_WB_stall
);


/* BRANCH LOGIC */
logic stage_MEM_br_en;
lc3b_control_word barrier_MEM_WB_control;

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

/* BARRIER IF <-> ID */
lc3b_word barrier_IF_ID_ir;
lc3b_word barrier_IF_ID_pc;

/* STAGE ID */
lc3b_reg stage_WB_regfile_dest;
lc3b_word stage_WB_regfile_data;
logic stage_WB_regfile_load;
lc3b_control_word stage_ID_control;
lc3b_word stage_ID_sr1;
lc3b_word stage_ID_sr2;
lc3b_reg sr1;
lc3b_reg sr2;


/* BARRIER ID <-> EX */
lc3b_control_word barrier_ID_EX_control;
lc3b_word barrier_ID_EX_ir;
lc3b_word barrier_ID_EX_pc;
lc3b_word barrier_ID_EX_sr1;
lc3b_word barrier_ID_EX_sr2;

/* STAGE EX */
lc3b_word stage_EX_alu;
lc3b_word stage_EX_pcn;

/* BARRIER EX <-> MEM */
lc3b_control_word barrier_EX_MEM_control;
lc3b_word barrier_EX_MEM_alu;
lc3b_word barrier_EX_MEM_ir;
lc3b_word barrier_EX_MEM_pc;
lc3b_word barrier_EX_MEM_pcn;
lc3b_word barrier_EX_MEM_sr2;

/* STAGE MEM */
// stage_MEM_br_en is defined above branch_logic
lc3b_word stage_MEM_mdr;

/* BARRIER MEM <-> WB */
// barrier_MEM_WB_control is defined above stage_IF
// barrier_MEM_WB_alu is defined above stage_IF
lc3b_word barrier_MEM_WB_ir;
// barrier_MEM_WB_mdr is defined above stage_IF
lc3b_word barrier_MEM_WB_pc;
// barrier_MEM_WB_pcn is defined above stage_IF


/* STAGE IF */
stage_IF _stage_IF (
    /* INPUTS */
    .clk,
    .stall(stage_IF_stall | branch_controller_stage_IF_stall),
    .pc_mux_sel(stage_IF_pc_mux_sel),
    .alu_in(barrier_MEM_WB_alu),
    .mdr_in(barrier_MEM_WB_mdr),
    .pcn_in(barrier_MEM_WB_pcn),

    /* OUTPUTS */
    .ir_out(stage_IF_ir),
    .pc_plus2_out(stage_IF_pc_plus2),
    .request_stall(stage_IF_request_stall),

    /* MEMORY INTERFACE */
    .instruction_memory_wishbone
);


/* BARRIER IF <-> ID */
<<<<<<< HEAD
// barrier_IF_ID_ir is defined above branch_controller
lc3b_word barrier_IF_ID_pc;
=======
>>>>>>> most likely correct forwarding
barrier_IF_ID _barrier_IF_ID (
    /* INPUTS */
    .clk,
    .reset(barrier_IF_ID_reset),
    .stall(barrier_IF_ID_stall),
    .ir_in(stage_IF_ir),
    .pc_in(stage_IF_pc_plus2),

    /* OUTPUTS */
    .ir_out(barrier_IF_ID_ir),
    .pc_out(barrier_IF_ID_pc),
    .valid_out(barrier_IF_ID_valid)
);


/* STAGE ID */
stage_ID _stage_ID (
    /* INPUTS */
    .clk,
    .stall(stage_ID_stall),
    .ir_in(barrier_IF_ID_ir),
    .regfile_dest_in(stage_WB_regfile_dest),
    .regfile_data_in(stage_WB_regfile_data),
    .regfile_load_in(stage_WB_regfile_load),

    /* OUTPUTS */
    .control_out(stage_ID_control),
    .sr1_data(stage_ID_sr1),
    .sr2_data(stage_ID_sr2),
	 .sr1(sr1),
	 .sr2(sr2)
);

lc3b_reg sr1_out;
lc3b_reg sr2_out;
/* BARRIER ID <-> EX */
<<<<<<< HEAD
lc3b_control_word barrier_ID_EX_control;
// barrier_ID_EX_ir is defined above branch_controller
lc3b_word barrier_ID_EX_pc;
lc3b_word barrier_ID_EX_sr1;
lc3b_word barrier_ID_EX_sr2;
=======
>>>>>>> most likely correct forwarding
barrier_ID_EX _barrier_ID_EX (
    /* INPUTS */
    .clk,
    .reset(barrier_ID_EX_reset),
    .stall(barrier_ID_EX_stall),
    .control_in(stage_ID_control),
    .ir_in(barrier_IF_ID_ir),
    .pc_in(barrier_IF_ID_pc),
<<<<<<< HEAD
    .sr1_in(stage_ID_sr1),
    .sr2_in(stage_ID_sr2),
    .valid_in(barrier_IF_ID_valid),
=======
    .sr1_data_in(stage_ID_sr1),
    .sr2_data_in(stage_ID_sr2),
	 .sr1_in(sr1),
	 .sr2_in(sr2),
>>>>>>> most likely correct forwarding

    /* OUTPUTS */
    .control_out(barrier_ID_EX_control),
    .ir_out(barrier_ID_EX_ir),
    .pc_out(barrier_ID_EX_pc),
<<<<<<< HEAD
    .sr1_out(barrier_ID_EX_sr1),
    .sr2_out(barrier_ID_EX_sr2),
    .valid_out(barrier_ID_EX_valid)
=======
    .sr1_data_out(barrier_ID_EX_sr1),
    .sr2_data_out(barrier_ID_EX_sr2),
	 .sr1_out(sr1_out),
	 .sr2_out(sr2_out)
>>>>>>> most likely correct forwarding
);

/* FORWARDING LOGIC */
logic [1:0] forward_A;
logic [1:0] forward_B;

forwarding_controller _forwarding_controller(
	 .ir_curr(barrier_ID_EX_ir),
    .ir_EX_MEM(barrier_EX_MEM_ir),
	 .ir_MEM_WB(barrier_MEM_WB_ir),
	 .sr1(sr1_out),
	 .sr2(sr2_out),
	 .forward_A,
	 .forward_B
);

/* STAGE EX */
stage_EX _stage_EX (
    /* INPUTS */
    .clk,
    .stall(stage_EX_stall),
    .control_in(barrier_ID_EX_control),
    .ir_in(barrier_ID_EX_ir),
    .pc_in(barrier_ID_EX_pc),
    .sr1_in(barrier_ID_EX_sr1),
    .sr2_in(barrier_ID_EX_sr2),
	 .forward_A,
	 .forward_B,
	 .data_EX_MEM(barrier_EX_MEM_alu),
	 .data_WB(stage_WB_regfile_data),

    /* OUTPUTS */
    .alu_out(stage_EX_alu),
    .pcn_out(stage_EX_pcn)
);


/* BARRIER EX <-> MEM */
<<<<<<< HEAD
lc3b_control_word barrier_EX_MEM_control;
lc3b_word barrier_EX_MEM_alu;
// barrier_EX_MEM_ir is defined above branch_controller
lc3b_word barrier_EX_MEM_pc;
lc3b_word barrier_EX_MEM_pcn;
lc3b_word barrier_EX_MEM_sr2;
=======
>>>>>>> most likely correct forwarding
barrier_EX_MEM _barrier_EX_MEM (
    /* INPUTS */
    .clk,
    .reset(barrier_EX_MEM_reset),
    .stall(barrier_EX_MEM_stall),
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
stage_MEM _stage_MEM (
    /* INPUTS */
    .clk,
    .stall(stage_MEM_stall),
    .control_in(barrier_EX_MEM_control),
    .alu_in(barrier_EX_MEM_alu),
    .ir_in(barrier_EX_MEM_ir),
    .pcn_in(barrier_EX_MEM_pcn),
    .sr2_in(barrier_EX_MEM_sr2),

    /* OUTPUTS */
    .br_en_out(stage_MEM_br_en),
    .mdr_out(stage_MEM_mdr),
    .request_stall(stage_MEM_request_stall),

    /* MEMORY INTERFACE */
    .data_memory_wishbone
);


/* BARRIER MEM <-> WB */
<<<<<<< HEAD
// barrier_MEM_WB_control is defined above stage_IF
// barrier_MEM_WB_alu is defined above stage_IF
// barrier_MEM_WB_ir is defined above branch_controller
// barrier_MEM_WB_mdr is defined above stage_IF
lc3b_word barrier_MEM_WB_pc;
// barrier_MEM_WB_pcn is defined above stage_IF
=======
>>>>>>> most likely correct forwarding
barrier_MEM_WB _barrier_MEM_WB (
    /* INPUTS */
    .clk,
    .reset(barrier_MEM_WB_reset),
    .stall(barrier_MEM_WB_stall),
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
    .stall(stage_WB_stall),
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
