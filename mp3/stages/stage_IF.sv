import lc3b_types::*;

module stage_IF (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_word pc_in,

    /* OUTPUTS */
    output lc3b_word ir_out,
    output lc3b_word pc_out,
    output logic valid_out,
    output lc3b_pipeline_control_word i_cache_pipeline_control_request,

    /* MEMORY INTERFACE */
    wishbone.master instruction_memory_wishbone
);

register pc (
    /* INPUTS */
    .clk,
    .load(1'b1),
    .stall(stall | i_cache_pipeline_control_request.active),
    .in(pc_in),

    /* OUTPUTS */
    .out(pc_out)
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
assign valid_out = |ir_out; // instruction_is_not_NOP

/* i_cache_pipeline_control_request */
assign i_cache_pipeline_control_request.active                       = (instruction_memory_wishbone.CYC) & (~instruction_memory_wishbone.ACK | instruction_memory_wishbone.RTY);
assign i_cache_pipeline_control_request.exclusive                    = 1;
assign i_cache_pipeline_control_request.barrier_IF_ID_stall          = 1;
assign i_cache_pipeline_control_request.barrier_ID_EX_stall          = 1;
assign i_cache_pipeline_control_request.barrier_EX_MEM_stall         = 1;
assign i_cache_pipeline_control_request.barrier_MEM_WB_stall         = 1;
assign i_cache_pipeline_control_request.barrier_IF_ID_reset          = 0;
assign i_cache_pipeline_control_request.barrier_ID_EX_reset          = 0;
assign i_cache_pipeline_control_request.barrier_EX_MEM_reset         = 0;
assign i_cache_pipeline_control_request.barrier_MEM_WB_reset         = 0;
assign i_cache_pipeline_control_request.barrier_ID_EX_force_sr1_load = 0;
assign i_cache_pipeline_control_request.barrier_ID_EX_force_sr2_load = 0;
assign i_cache_pipeline_control_request.stage_IF_stall               = 0;
assign i_cache_pipeline_control_request.stage_ID_stall               = 1;
assign i_cache_pipeline_control_request.stage_EX_stall               = 1;
assign i_cache_pipeline_control_request.stage_MEM_stall              = 1;
assign i_cache_pipeline_control_request.stage_WB_stall               = 1;

endmodule : stage_IF
