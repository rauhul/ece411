import lc3b_types::*;

module stage_IF (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_pc_mux_sel pc_mux_sel,
    input lc3b_word alu_in,
    input lc3b_word mdr_in,
    input lc3b_word pcn_in,

    /* OUTPUTS */
    output lc3b_word ir_out,
    output lc3b_word pc_plus2_out,
    output logic request_stall,

    /* MEMORY INTERFACE */
    wishbone.master instruction_memory_wishbone
);

lc3b_word pc_out;
lc3b_word pc_mux_out;

mux4 pc_mux (
    /* INPUTS */
    .sel(pc_mux_sel),
    .a(pc_plus2_out),
    .b(alu_in),
    .c(pcn_in),
    .d(mdr_in),

    /* OUTPUTS */
    .f(pc_mux_out)
);

register pc (
    /* INPUTS */
    .clk,
    .load(1'b1),
    .stall,
    .in(pc_mux_out),

    /* OUTPUTS */
    .out(pc_out)
);

plus2 pc_plus2 (
    /* INPUTS */
    .in(pc_out),

    /* OUTPUTS */
    .out(pc_plus2_out)
);

assign instruction_memory_wishbone.ADR   = pc_out[15:4];
assign instruction_memory_wishbone.CYC   = ~stall;
assign instruction_memory_wishbone.STB   = ~instruction_memory_wishbone.ACK;
assign instruction_memory_wishbone.DAT_M = 0;
assign instruction_memory_wishbone.WE    = 0;

always_comb begin
    instruction_memory_wishbone.SEL = 0;
    instruction_memory_wishbone.SEL[pc_out[3:1]*2 +: 2] = 2'b11;
end

assign ir_out = instruction_memory_wishbone.DAT_S[pc_out[3:1]*16 +: 16];

assign request_stall = (instruction_memory_wishbone.CYC) & (~instruction_memory_wishbone.ACK | instruction_memory_wishbone.RTY);

endmodule : stage_IF
