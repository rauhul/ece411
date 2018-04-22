import lc3b_types::*;

module stage_MEM (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,
    input lc3b_word sr2_in,

    /* debug */
    input logic debug_branch_prediction_correct,
    input logic debug_branch_prediction_incorrect,

    input logic debug_i_cache_hit,
    input logic debug_i_cache_miss,
    input logic debug_d_cache_hit,
    input logic debug_d_cache_miss,
    input logic debug_l2_cache_hit,
    input logic debug_l2_cache_miss,

    input logic debug_stage_IF_stall,
    input logic debug_stage_ID_stall,
    input logic debug_stage_EX_stall,
    input logic debug_stage_MEM_stall,
    input logic debug_stage_WB_stall,

    /* OUTPUTS */
    output logic br_en_out,
    output lc3b_word mdr_out,
    output lc3b_pipeline_control_word d_cache_pipeline_control_request,
    output lc3b_word regfile_data_out,

    /* MEMORY INTERFACE */
    wishbone.master data_memory_wishbone
);

logic     internal_MDR_load;
lc3b_word internal_mdr_out;

lc3b_data_memory_addr_mux_sel data_memory_addr_mux_sel;
lc3b_word                     data_memory_addr_mux_out;
logic                         data_memory_wishbone_WE;

lc3b_word trapvect8;
assign    trapvect8 = $unsigned({ir_in[7:0], 1'b0});

/* CC */
logic [1:0] cc_input_mux_sel;
register #(2) cc_sel (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .stall,
    .in(control_in.cc_gen_mux_sel),

    /* OUTPUTS */
    .out(cc_input_mux_sel)
);

logic [3:0] [15:0] cc_input_mux_in;
register #(16) cc_pcn (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .stall,
    .in(pcn_in),

    /* OUTPUTS */
    .out(cc_input_mux_in[0])
);

register #(16) cc_alu (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .stall,
    .in(alu_in),

    /* OUTPUTS */
    .out(cc_input_mux_in[1])
);

register #(16) cc_mdr (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .stall,
    .in(mdr_out),

    /* OUTPUTS */
    .out(cc_input_mux_in[2])
);

register #(16) cc_sr2 (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .stall,
    .in(sr2_in),

    /* OUTPUTS */
    .out(cc_input_mux_in[3])
);

logic [15:0] cc_input_mux_out;
mux #(4, 16) cc_input_mux (
    /* INPUTS */
    .sel(cc_input_mux_sel),
    .in(cc_input_mux_in),

    /* OUTPUTS */
    .out(cc_input_mux_out)
);

lc3b_cc cc_out;
gencc cc_gen (
    /* INPUTS */
    .in(cc_input_mux_out),

    /* OUTPUTS */
    .out(cc_out)
);

assign br_en_out = |(cc_out & ir_in[11:9]);

/* PERFORMANCE COUNTERS */
logic        data_memory_access_cancel;
logic [15:0] data_memory_data_out;
performace_counters _performace_counters (
    /* INPUTS */
    .clk,
    .data_memory_access(control_in.data_memory_access),
    .data_memory_write_enable(control_in.data_memory_write_enable),
    .data_memory_address(data_memory_addr_mux_out),

    /* debug */
    .debug_branch_prediction_correct,
    .debug_branch_prediction_incorrect,

    .debug_i_cache_hit,
    .debug_i_cache_miss,
    .debug_d_cache_hit,
    .debug_d_cache_miss,
    .debug_l2_cache_hit,
    .debug_l2_cache_miss,

    .debug_stage_IF_stall,
    .debug_stage_ID_stall,
    .debug_stage_EX_stall,
    .debug_stage_MEM_stall,
    .debug_stage_WB_stall,

    /* OUTPUTS */
    .data_memory_access_cancel,
    .data_memory_data_out
);

/* MEMORY INTERFACE */
logic request_stall;
mem_access_controller _mem_access_controller (
    /* INPUTS */
    .clk,
    .stall,
    .control_in,
    .ir_in,
    .data_memory_wishbone_ACK(data_memory_wishbone.ACK),
    .data_memory_wishbone_RTY(data_memory_wishbone.RTY),

    /* OUTPUTS */
    .data_memory_addr_mux_sel,
    .data_memory_wishbone_WE,
    .internal_MDR_load,
    .request_stall
);

/* d_cache_pipeline_control_request */
assign d_cache_pipeline_control_request.active                       = request_stall & ~data_memory_access_cancel;
assign d_cache_pipeline_control_request.exclusive                    = 1;
assign d_cache_pipeline_control_request.barrier_IF_ID_stall          = 1;
assign d_cache_pipeline_control_request.barrier_ID_EX_stall          = 1;
assign d_cache_pipeline_control_request.barrier_EX_MEM_stall         = 1;
assign d_cache_pipeline_control_request.barrier_MEM_WB_stall         = 1;
assign d_cache_pipeline_control_request.barrier_IF_ID_reset          = 0;
assign d_cache_pipeline_control_request.barrier_ID_EX_reset          = 0;
assign d_cache_pipeline_control_request.barrier_EX_MEM_reset         = 0;
assign d_cache_pipeline_control_request.barrier_MEM_WB_reset         = 0;
assign d_cache_pipeline_control_request.barrier_ID_EX_force_sr1_load = 0;
assign d_cache_pipeline_control_request.barrier_ID_EX_force_sr2_load = 0;
assign d_cache_pipeline_control_request.stage_IF_stall               = 1;
assign d_cache_pipeline_control_request.stage_ID_stall               = 1;
assign d_cache_pipeline_control_request.stage_EX_stall               = 1;
assign d_cache_pipeline_control_request.stage_MEM_stall              = 0;
assign d_cache_pipeline_control_request.stage_WB_stall               = 1;

logic [2:0] [15:0] data_memory_addr_mux_in;
assign data_memory_addr_mux_in[0] = trapvect8;
assign data_memory_addr_mux_in[1] = alu_in;
assign data_memory_addr_mux_in[2] = internal_mdr_out;
mux #(3, 16) data_memory_addr_mux (
    /* INPUTS */
    .sel(data_memory_addr_mux_sel),
    .in(data_memory_addr_mux_in),

	 /* OUTPUTS */
    .out(data_memory_addr_mux_out)
);

assign data_memory_wishbone.ADR = data_memory_addr_mux_out[15:4];
assign data_memory_wishbone.CYC = control_in.data_memory_access & ~data_memory_access_cancel;
assign data_memory_wishbone.STB = control_in.data_memory_access & ~data_memory_access_cancel;
assign data_memory_wishbone.WE = data_memory_wishbone_WE;

always_comb begin
    /* select */
    data_memory_wishbone.SEL = 0;
    if (control_in.data_memory_word_align) begin
        data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = 2'b11;
    end else begin
        if (data_memory_addr_mux_out[0]) begin // high byte
            data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = 2'b10;
        end else begin // low byte
            data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = 2'b01;
        end
    end

    /* data in */
    data_memory_wishbone.DAT_M = 0;
    if (control_in.data_memory_word_align) begin
        data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = sr2_in;
    end else begin
        if (data_memory_addr_mux_out[0]) begin // high byte
            data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = {sr2_in[7:0], 8'b0};
        end else begin // low byte
            data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = {8'b0, sr2_in[7:0]};
        end
    end

    /* data out */
    mdr_out = 0;
    if (data_memory_access_cancel) begin
        mdr_out = data_memory_data_out;
    end else begin
        if (control_in.data_memory_word_align) begin
            mdr_out = data_memory_wishbone.DAT_S[data_memory_addr_mux_out[3:1]*16 +: 16];
        end else begin
            mdr_out[7:0] = data_memory_wishbone.DAT_S[data_memory_addr_mux_out[3:0]*8 +: 8];
        end
    end
end

register internal_mdr (
    /* INPUTS */
    .clk,
    .load(internal_MDR_load),
    .stall,
    .in(mdr_out),

    /* OUTPUTS */
    .out(internal_mdr_out)
);


/* FORWARDING LOGIC */
// should be identical to WB regfile_data_mux, without mdr
logic [3:0] [15:0] regfile_data_mux_in;
assign regfile_data_mux_in[0] = pc_in;
assign regfile_data_mux_in[1] = pcn_in;
assign regfile_data_mux_in[2] = 16'bx;
assign regfile_data_mux_in[3] = alu_in;
mux #(4, 16) regfile_data_mux (
    /* INPUTS */
    .sel(control_in.regfile_data_mux_sel),
    .in(regfile_data_mux_in),

    /* OUTPUTS */
    .out(regfile_data_out)
);

endmodule: stage_MEM
