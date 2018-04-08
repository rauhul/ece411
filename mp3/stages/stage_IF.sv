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
    output lc3b_pipeline_control_word i_cache_pipeline_control_request,

    /* MEMORY INTERFACE */
    wishbone.master instruction_memory_wishbone
);

lc3b_word pc_out;
lc3b_word pc_mux_out;

logic [3:0] [15:0] pc_mux_in;
assign pc_mux_in[0] = pc_plus2_out;
assign pc_mux_in[1] = alu_in;
assign pc_mux_in[2] = pcn_in;
assign pc_mux_in[3] = mdr_in;
mux #(4, 16) pc_mux (
    /* INPUTS */
    .sel(pc_mux_sel),
    .in(pc_mux_in),

    /* OUTPUTS */
    .out(pc_mux_out)
);

register pc (
    /* INPUTS */
    .clk,
    .load(1'b1),
    .stall(stall | i_cache_pipeline_control_request.active),
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
assign instruction_memory_wishbone.CYC   = 1;
assign instruction_memory_wishbone.STB   = 1;
assign instruction_memory_wishbone.DAT_M = 0;
assign instruction_memory_wishbone.WE    = 0;

always_comb begin
    instruction_memory_wishbone.SEL = 0;
    instruction_memory_wishbone.SEL[pc_out[3:1]*2 +: 2] = 2'b11;
end

assign ir_out = instruction_memory_wishbone.DAT_S[pc_out[3:1]*16 +: 16];

/* i_cache_pipeline_control_request */
assign i_cache_pipeline_control_request.active               = (instruction_memory_wishbone.CYC) & (~instruction_memory_wishbone.ACK | instruction_memory_wishbone.RTY);
assign i_cache_pipeline_control_request.exclusive            = 1;
assign i_cache_pipeline_control_request.barrier_IF_ID_stall  = 1;
assign i_cache_pipeline_control_request.barrier_ID_EX_stall  = 1;
assign i_cache_pipeline_control_request.barrier_EX_MEM_stall = 1;
assign i_cache_pipeline_control_request.barrier_MEM_WB_stall = 1;
assign i_cache_pipeline_control_request.barrier_IF_ID_reset  = 0;
assign i_cache_pipeline_control_request.barrier_ID_EX_reset  = 0;
assign i_cache_pipeline_control_request.barrier_EX_MEM_reset = 0;
assign i_cache_pipeline_control_request.barrier_MEM_WB_reset = 0;
assign i_cache_pipeline_control_request.stage_IF_stall       = 0;
assign i_cache_pipeline_control_request.stage_ID_stall       = 1;
assign i_cache_pipeline_control_request.stage_EX_stall       = 1;
assign i_cache_pipeline_control_request.stage_MEM_stall      = 1;
assign i_cache_pipeline_control_request.stage_WB_stall       = 1;

endmodule : stage_IF
