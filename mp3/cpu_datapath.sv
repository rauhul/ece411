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
lc3b_word barrier_IF_ID_pc_out;
lc3b_word barrier_IF_ID_ir_out;
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word mdr_out;
lc3b_word pcn_out;


controlrom controlrom
(
	.opcode(ir_out[15:12]),
	.imm5(ir_out_IF_ID[5]),
	.pc(pc_out_IF_ID),
	.ctrl(ctrl)
)

stage_IF
(
   /* INPUTS */
   .clk,
	.pcmux_sel(pc_mux_sel),
	.load_pc(load_pc),
	.sr1_out(sr1_out),
	.pcn_out(pcn_out),
	.mdr_out(mdr_out),
   /* OUTPUTS */

	output lc3b_word .pc_plus2_out(pc_plus2_out),
	output lc3b_word .pcmux_out(pcmux_out),
	output lc3b_word .pc_out(pc_out)
	
);

barrier_IF_ID barrier_IF_ID
(
    /* INPUTS */
    .clk,
    .ir_in(pc_out),
    .pc_in(pc_plus2_out),
	 
    /* OUTPUTS */
    .ir_out(ir_out),
    .pc_out(pc_out_IF_ID)
);

lc3b_control_word barrier_ID_EX_control;
lc3b_word barrier_ID_EX_ir;
lc3b_word barrier_ID_EX_pc;
lc3b_word barrier_ID_EX_sr1;
lc3b_word barrier_ID_EX_sr2;

barrier_ID_EX _barrier_ID_EX (
    /* INPUTS */
    .clk,
    .control_in(control_in),
    .ir_in(ir_in),
    .pc_in(pc_in),
    .sr1_in(sr1_in),
    .sr2_in(sr2_in),

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
    .control_out(control_out),
    .alu_out(alu_out),
    .ir_out(ir_out),
    .pc_out(pc_out),
    .pcn_out(pcn_out),
    .sr2_out(sr2_out)
);



barrier_MEM_WB _barrier_MEM_WB (
    /* INPUTS */
    .clk,
    .cc_in(cc_in),
    .control_in(control_in),
    .alu_in(alu_in),
    .ir_in(ir_in),
    .mdr_in(mdr_in),
    .pc_in(pc_in),
    .pcn_in(pcn_in),

    /* OUTPUTS */
    .cc_out(cc_out),
    .control_out(control_out),
    .alu_out(alu_out),
    .ir_out(ir_out),
    .mdr_out(mdr_out),
    .pc_out(pc_out),
    .pcn_out(pcn_out)
);


endmodule : cpu_datapath
