import lc3b_types::*;

module stage_MEM (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word sr2_in,

    /* OUTPUTS */
    output lc3b_cc cc_out,
    output lc3b_word mdr_out,

    /* MEMORY INTERFACE */
    wishbone.master data_memory_wishbone
);

lc3b_cc gencc_out;
lc3b_word gencc_mux_out;
lc3b_word internal_mdr_out;
lc3b_word data_memory_addr_mux_out;

lc3b_word trapvect8;
assign trapvect8 = $unsigned({ir_in[7:0], 1'b0});

/* CC */
mux4 gencc_mux (
    /* INPUTS */
    .sel(control_in.gencc_in_mux_sel),
    .a(alu_in),
    .b(mdr_out),
    .c(sr2_in),
    .d(16'bx),

    /* OUTPUTS */
    .f(gencc_mux_out)
);

gencc _gencc (
    /* INPUTS */
    .in(gencc_mux_out),

    /* OUTPUTS */
    .out(gencc_out)
);

register #(.width(3)) cc (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .in(gencc_out),

    /* OUTPUTS */
    .out(cc_out)
);


/* MEMORY INTERFACE */
mux4 data_memory_addr_mux (
    /* INPUTS */
    .sel(control_in.data_memory_addr_mux_sel),
    .a(trapvect8),
    .b(alu_in),
    .c(internal_mdr_out),
    .d(16'bx),
	 
	 /* OUTPUTS */
    .f(data_memory_addr_mux_out)
);

// these signals can be x for now
assign data_memory_wishbone.ADR = data_memory_addr_mux_out[15:4];
assign data_memory_wishbone.CYC = 'x;
assign data_memory_wishbone.STB = 'x;
assign data_memory_wishbone.WE = control_in.data_memory_write_enable;

always_comb begin
    data_memory_wishbone.SEL = 16'b0;
    data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = control_in.data_memory_byte_sel;

    data_memory_wishbone.DAT_M = 'x;
    data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = sr2_in;
end

assign mdr_out = data_memory_wishbone.DAT_S[data_memory_addr_mux_out[3:1]*16 +: 16];

register internal_mdr (
    /* INPUTS */
    .clk,
    .load(control_in.internal_mdr_load),
    .in(mdr_out),

    /* OUTPUTS */
    .out(internal_mdr_out)
);

endmodule: stage_MEM
