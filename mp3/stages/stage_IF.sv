import lc3b_types::*;

module stage_IF (
   /* INPUTS */
   input clk,
	input logic [1:0] pcmux_sel,
	input logic load_pc,
	input lc3b_word sr1_out,
	input lc3b_word pcn_out,
	input lc3b_word mdr_out,
   /* OUTPUTS */

	output lc3b_word pc_plus2_out,
	output lc3b_word pc_out
	
);

//Internal Signals
lc3b_word pc_out_internal;
lc3b_word pc_plus2_out_internal;

assign pc_out = pc_out_internal;
assign pc_plus2_out = pc_plus2_out_internal;

mux4 pcmux
(
	.sel(pumux_sel),
	.a(pc_plus2_out_internal),
	.b(sr1_out),
	.c(pcn_out),
	.d(mdr_out),
	.f(pcmux_out)
);

register pc
(
	.clk,
	.load(load_pc),
	.in(pcmux_out),
	.out(pc_out_internal)
)

plus2 pc_plus2
(
	.in(pc_out_internal),
	.out(pc_plus2_out_internal)
)

endmodule: stage_IF
