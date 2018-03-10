module stage_MEM (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word ir_in,
    input lc3b_word sr2_in,
    input lc3b_word alu_in,

    /* OUTPUTS */
    output cc_out,
    output lc3b_control_word control_out,
    output lc3b_word ir_out,
    output lc3b_word mdr_out,
    output lc3b_word alu_out
);

mux4 gencc_in_mux
(
	.sel(gencc_in_mux_sel),
	.a(alu_in),
	.b(sr2_in),
	.c(),			//cache?
	.d('x),
	.f(gencc_in_mux_out)
);

gencc _gencc
(
	.in(gencc_in_mux_out),
	.out(cc_out)
);

mux2 dcache_data_in_mux
(
	.sel(),	//control_word
	.a(sr2_in), 
	.b(),	//sr2 shift8
	.f()
);

mux4 dcache_addr_mux
(
	.sel(),	//control_word
	.a(),	//zext
	.b(alu_in),
	.c(),	//mdr wire?
	.d('x),
	.f()
);



endmodule: stage_MEM