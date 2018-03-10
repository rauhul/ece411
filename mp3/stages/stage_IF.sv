import lc3b_types::*;

module stage_IF (
    /* INPUTS */
    input clk,
    input logic [1:0] pc_mux_sel,
    input lc3b_word mdr_in,
    input lc3b_word pcn_in,
    input lc3b_word sr1_in,

    /* OUTPUTS */
    output lc3b_word
    output lc3b_word ir_out,
    output lc3b_word pc_out,
    output lc3b_word pc_plus2_out,

    /* MEMORY INTERFACE */
    wishbone.master instruction_memory_wishbone
);

mux4 pc_mux (
    /* INPUTS */
    .sel(pc_mux_sel),
    .a(pc_plus2_out),
    .b(sr1_in),
    .c(pcn_in),
    .d(mdr_in),

    /* OUTPUTS */
    .f(pcmux_out)
);

register pc (
    /* INPUTS */
    .clk,
    .load(1'b1),
    .in(pcmux_out),

    /* OUTPUTS */
    .out(pc_out)
);

plus2 pc_plus2 (
    /* INPUTS */
    .in(pc_out),

    /* OUTPUTS */
    .out(pc_plus2_out)
);

// these signals can be x for now
assign instruction_memory_wishbone.ADR   = pc_out[15:4];
assign instruction_memory_wishbone.CYC   = 'x;
assign instruction_memory_wishbone.DAT_M = 'x;
assign instruction_memory_wishbone.SEL   = 'x;
assign instruction_memory_wishbone.STB   = 'x;
assign instruction_memory_wishbone.WE    = 'x;

assign ir_out = instruction_memory_wishbone.DAT_S[pc[3:1]*16 +: 16];

endmodule : stage_IF
