import lc3b_types::*;

module stage_ID
(
	input clk,
	input lc3b_word ir_word,

	input lc3b_word regfilemux_out,

	output lc3b_word sr1_out, sr2_out,
	output lc3b_control_word control_out
);

lc3b_reg storemux_out;
lc3b_reg destmux_out;

control_rom rom
(
	.opcode(ir_word[15:12]),
	.ctrl(control_out)
);

regfile _regfile
(
	.clk(clk),
	.load(control.load_regfile), //update with controlword
	.in(regfilemux_out),	//needs info from wb...i think
	.src_a(ir_word[8:6]),	//sr1
	.src_b(storemux_out),
	.dest(destmux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);

mux2 #(.width(3)) storemux
(
	.sel(control.storemux_sel),	//update with controlword
	.a(ir_word[2:0]),	//sr2
	.b(ir_word[11:9]),	//dest
	.f(storemux_out)
);

mux2 #(.width(3)) destmux
(
    .sel(control.destmux_sel),	//update with controlword
    .a(ir_word[11:9]),	//dest
    .b(3'b111),
    .f(destmux_out)
);



endmodule : stage_ID