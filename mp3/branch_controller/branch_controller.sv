import lc3b_types::*;

module branch_controller (
    /* INPUTS */
    input logic             clk,
    input logic             stall,

    input lc3b_word         stage_IF_ir,
    input lc3b_word         stage_IF_pc,
    input logic             stage_IF_valid,

    input lc3b_opcode       barrier_IF_ID_opcode,
    input logic             barrier_IF_ID_valid,

    input lc3b_opcode       barrier_ID_EX_opcode,
    input logic             barrier_ID_EX_valid,

    input lc3b_word         barrier_EX_MEM_alu,
    input lc3b_word         barrier_EX_MEM_pcn,
    input lc3b_control_word barrier_EX_MEM_control,
    input lc3b_opcode       barrier_EX_MEM_opcode,
    input logic             barrier_EX_MEM_valid,

    input logic             stage_MEM_br_en,

    input lc3b_word         barrier_MEM_WB_mdr,
    input lc3b_control_word barrier_MEM_WB_control,
    input lc3b_opcode       barrier_MEM_WB_opcode,
    input logic             barrier_MEM_WB_valid,

    /* OUTPUTS */
    output lc3b_word        pc_out,
    output lc3b_word        pc_plus2_out,
    output lc3b_pipeline_control_word branch_controller_pipeline_control_request,

    /* debug */
    output logic debug_branch_prediction_correct,
    output logic debug_branch_prediction_incorrect
);

/** CONNECTIONS **/
lc3b_word   branch_address;
lc3b_word   offset9;
lc3b_opcode stage_IF_opcode;
logic       ignore_branch_if_next;

/* BRANCH_WATERFALL_QUEUE */
logic [15:0] branch_waterfall_queue_mispredict_address_in;
logic        branch_waterfall_queue_prediction_in;
logic        branch_waterfall_queue_load;
logic        branch_waterfall_queue_update;
logic        branch_waterfall_queue_correct;
logic [15:0] branch_waterfall_queue_mispredict_address;
logic        branch_waterfall_queue_prediction;

/* BRANCH_PREDICTOR */
logic branch_predictor_update;
logic branch_predictor_update_value;
logic branch_predictor_prediction;

/* PC_MUX */
lc3b_pc_mux_sel pc_mux_sel;
logic [5:0] [15:0] pc_mux_in;
assign pc_mux_in[0] = pc_plus2_out;
assign pc_mux_in[1] = barrier_EX_MEM_alu;
assign pc_mux_in[2] = barrier_EX_MEM_pcn;
assign pc_mux_in[3] = barrier_MEM_WB_mdr;
assign pc_mux_in[4] = branch_address;
assign pc_mux_in[5] = branch_waterfall_queue_mispredict_address;

/** MODULES **/
assign branch_address   = pc_plus2_out + offset9;
assign offset9          = $signed({stage_IF_ir[8:0], 1'b0});
assign pc_plus2_out     = stage_IF_pc + 2;
assign stage_IF_opcode  = lc3b_opcode'(stage_IF_ir[15:12]);

branch_waterfall_queue _branch_waterfall_queue (
    /* INPUTS */
    .clk,
    .stall,

    .mispredict_address_in(branch_waterfall_queue_mispredict_address_in),
    .prediction_in(branch_waterfall_queue_prediction_in),
    .load(branch_waterfall_queue_load),

    .update(branch_waterfall_queue_update),
    .correct(branch_waterfall_queue_correct),

    /* OUTPUTS */
    .mispredict_address(branch_waterfall_queue_mispredict_address),
    .prediction(branch_waterfall_queue_prediction)
);

branch_predictor #(
    .BRANCH_HISTORY_REGISTER_SIZE(3),
    .NUM_PHT_INDEXING_PC_BITS(1),
    .NUM_BHT_INDEXING_PC_BITS(1)
) _branch_predictor (
    /* INPUTS */
    .clk,
    .stall,

    .pc(stage_IF_pc),

    .update(branch_predictor_update),
    .update_value(branch_predictor_update_value),

    /* OUTPUTS */
    .prediction(branch_predictor_prediction)
);

mux #(6, 16) pc_mux (
    /* INPUTS */
    .sel(pc_mux_sel),
    .in(pc_mux_in),

    /* OUTPUTS */
    .out(pc_out)
);

assign branch_controller_pipeline_control_request.exclusive                    = 0;
assign branch_controller_pipeline_control_request.barrier_IF_ID_stall          = 0;
assign branch_controller_pipeline_control_request.barrier_ID_EX_stall          = 0;
assign branch_controller_pipeline_control_request.barrier_EX_MEM_stall         = 0;
assign branch_controller_pipeline_control_request.barrier_MEM_WB_stall         = 0;
assign branch_controller_pipeline_control_request.barrier_ID_EX_force_sr1_load = 0;
assign branch_controller_pipeline_control_request.barrier_ID_EX_force_sr2_load = 0;
assign branch_controller_pipeline_control_request.stage_IF_stall               = 0;
assign branch_controller_pipeline_control_request.stage_ID_stall               = 0;
assign branch_controller_pipeline_control_request.stage_EX_stall               = 0;
assign branch_controller_pipeline_control_request.stage_MEM_stall              = 0;
assign branch_controller_pipeline_control_request.stage_WB_stall               = 0;

always_comb begin
    branch_controller_pipeline_control_request.active               = 0;
    branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 0;
    branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 0;
    branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 0;
    branch_controller_pipeline_control_request.barrier_MEM_WB_reset = 0;

    debug_branch_prediction_correct   = 0;
    debug_branch_prediction_incorrect = 0;

    pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

    ignore_branch_if_next = 0;

    branch_waterfall_queue_mispredict_address_in = 0;
    branch_waterfall_queue_prediction_in         = 0;
    branch_waterfall_queue_load                  = 0;
    branch_waterfall_queue_update                = 0;
    branch_waterfall_queue_correct               = 0;

    branch_predictor_update       = 0;
    branch_predictor_update_value = 0;

    /* barrier_IF_ID */
    if (barrier_IF_ID_valid && (
        barrier_IF_ID_opcode == op_jmp ||
        barrier_IF_ID_opcode == op_jsr ||
        barrier_IF_ID_opcode == op_trap)) begin
        ignore_branch_if_next = 1;
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
    end

    /* barrier_ID_EX */
    if (barrier_ID_EX_valid && (
        barrier_ID_EX_opcode == op_jmp ||
        barrier_ID_EX_opcode == op_jsr ||
        barrier_ID_EX_opcode == op_trap)) begin
        ignore_branch_if_next = 1;
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;

    end

    /* barrier_EX_MEM */
    if (barrier_EX_MEM_valid && (
        barrier_EX_MEM_opcode == op_jmp ||
        barrier_EX_MEM_opcode == op_jsr ||
        barrier_EX_MEM_opcode == op_trap)) begin
        ignore_branch_if_next = 1;
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;

        if (barrier_EX_MEM_opcode != op_trap) begin
            pc_mux_sel = barrier_EX_MEM_control.pc_mux_sel;
        end
    end

    /* barrier_MEM_WB */
    if (barrier_MEM_WB_valid && barrier_MEM_WB_opcode == op_trap) begin
        ignore_branch_if_next = 1;
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        branch_controller_pipeline_control_request.barrier_MEM_WB_reset = 1;

        pc_mux_sel = barrier_MEM_WB_control.pc_mux_sel;
    end

    /* br */
    if (~ignore_branch_if_next) begin
        if (stage_IF_valid && stage_IF_opcode == op_br) begin
            branch_waterfall_queue_prediction_in = branch_predictor_prediction;

            if (branch_predictor_prediction) begin
                branch_waterfall_queue_mispredict_address_in = pc_plus2_out;
                pc_mux_sel = lc3b_pc_mux_sel_branch_address;
            end else begin
                branch_waterfall_queue_mispredict_address_in = branch_address;
                pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;
            end

            branch_waterfall_queue_load = 1;
        end
    end

    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_br) begin

        if (branch_waterfall_queue_prediction == stage_MEM_br_en) begin
            debug_branch_prediction_correct = 1;
            branch_waterfall_queue_correct = 1;

        end else begin
            debug_branch_prediction_incorrect = 1;
            branch_waterfall_queue_correct = 0;
            pc_mux_sel = lc3b_pc_mux_sel_mispredict_address;

            branch_controller_pipeline_control_request.active               = 1;
            branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
            branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
            branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        end

        branch_predictor_update = 1;
        branch_predictor_update_value = stage_MEM_br_en;
        branch_waterfall_queue_update = 1;
    end
end

endmodule : branch_controller
