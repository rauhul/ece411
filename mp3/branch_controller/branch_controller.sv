import lc3b_types::*;

module branch_controller (
    /* INPUTS */
    input logic clk,
    input logic branch_prediction,

    input lc3b_word         stage_IF_ir,
    input lc3b_word         stage_IF_pc,
    input logic             stage_IF_valid,

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
    output lc3b_word pc_out,
    output lc3b_word pc_plus2_out,
    output lc3b_pipeline_control_word branch_controller_pipeline_control_request,

    /* debug */
    output logic debug_branch_prediction_correct,
    output logic debug_branch_prediction_incorrect
);

lc3b_word branch_address;
lc3b_word offset9;
assign offset9 = $signed({stage_IF_ir[8:0], 1'b0});
assign branch_address = pc_plus2_out + offset9;

lc3b_opcode stage_IF_opcode;
assign stage_IF_opcode = lc3b_opcode'(stage_IF_ir[15:12]);

assign pc_plus2_out = stage_IF_pc + 2;

logic [15:0] mispredict_address_in;
logic        prediction_in;
logic        load_prediction;
logic        update_predictions;
logic        correct_prediction;
logic [15:0] mispredict_address_out;
logic        prediction_out;
branch_waterfall_queue _branch_waterfall_queue (
    /* INPUTS */
    .clk,
    .mispredict_address_in,
    .prediction_in,
    .load_prediction,
    .update_predictions,
    .correct_prediction,

    /* OUTPUTS */
    .mispredict_address_out,
    .prediction_out
);

lc3b_pc_mux_sel pc_mux_sel;
logic [5:0] [15:0] pc_mux_in;
assign pc_mux_in[0] = pc_plus2_out;
assign pc_mux_in[1] = barrier_EX_MEM_alu;
assign pc_mux_in[2] = barrier_EX_MEM_pcn;
assign pc_mux_in[3] = barrier_MEM_WB_mdr;
assign pc_mux_in[4] = branch_address;
assign pc_mux_in[5] = mispredict_address_out;

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


    mispredict_address_in = 0;
    prediction_in         = 0;
    load_prediction       = 0;
    update_predictions    = 0;
    correct_prediction    = 0;

    /* br */
    if (stage_IF_valid && stage_IF_opcode == op_br) begin
        prediction_in = branch_prediction;
        if (branch_prediction) begin
            mispredict_address_in = pc_plus2_out;
            pc_mux_sel = lc3b_pc_mux_sel_branch_address;
        end else begin
            mispredict_address_in = branch_address;
            pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;
        end

        load_prediction = 1;
    end

    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_br) begin
        if (prediction_out == stage_MEM_br_en) begin
            debug_branch_prediction_correct = 1;
            correct_prediction = 1;
            pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

        end else begin
            debug_branch_prediction_incorrect = 1;
            correct_prediction = 0;
            pc_mux_sel = lc3b_pc_mux_sel_mispredict_address;

            branch_controller_pipeline_control_request.active               = 1;
            branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
            branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
            branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        end

        update_predictions = 1;
    end

    /* jmp */
    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_jmp) begin
        pc_mux_sel = barrier_EX_MEM_control.pc_mux_sel;

        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end

    /* jsr */
    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_jsr) begin
        pc_mux_sel = barrier_EX_MEM_control.pc_mux_sel;

        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end

    /* trap */
    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_trap) begin
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end

    /* trap */
    if (barrier_MEM_WB_valid && barrier_MEM_WB_opcode == op_trap) begin
        pc_mux_sel = barrier_MEM_WB_control.pc_mux_sel;

        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        branch_controller_pipeline_control_request.barrier_MEM_WB_reset = 1;
    end
end

endmodule : branch_controller
