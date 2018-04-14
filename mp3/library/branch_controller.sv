import lc3b_types::*;

module branch_controller (
    /* INPUTS */
    input logic clk,
    input logic branch_prediction,

    input lc3b_word         stage_IF_pc,

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
    output lc3b_pipeline_control_word branch_controller_pipeline_control_request
);

lc3b_pc_mux_sel pc_mux_sel;

plus2 pc_plus2 (
    /* INPUTS */
    .in(stage_IF_pc),

    /* OUTPUTS */
    .out(pc_plus2_out)
);

logic [3:0] [15:0] pc_mux_in;
assign pc_mux_in[0] = pc_plus2_out;
assign pc_mux_in[1] = barrier_EX_MEM_alu;
assign pc_mux_in[2] = barrier_EX_MEM_pcn;
assign pc_mux_in[3] = barrier_MEM_WB_mdr;
mux #(4, 16) pc_mux (
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

    pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_br) begin
        if (branch_prediction != stage_MEM_br_en) begin
            pc_mux_sel = barrier_EX_MEM_control.pc_mux_sel;

            branch_controller_pipeline_control_request.active               = 1;
            branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
            branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
            branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        end
    end

    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_jmp) begin
        pc_mux_sel = barrier_EX_MEM_control.pc_mux_sel;

        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end

    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_jsr) begin
        pc_mux_sel = barrier_EX_MEM_control.pc_mux_sel;

        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end

    if (barrier_EX_MEM_valid && barrier_EX_MEM_opcode == op_trap) begin
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end


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
