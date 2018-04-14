import lc3b_types::*;

module branch_controller (

    /* INPUTS */
    input logic clk,
    input logic branch_prediction,

    input lc3b_word pc_in,
    input lc3b_word alu_in,
    input lc3b_word mdr_in,
    input lc3b_word pcn_in,

    input logic barrier_IF_ID_valid,
    input logic barrier_ID_EX_valid,
    input logic barrier_EX_MEM_valid,
    input logic barrier_MEM_WB_valid,
    input lc3b_opcode barrier_IF_ID_opcode,
    input lc3b_opcode barrier_ID_EX_opcode,
    input lc3b_opcode barrier_EX_MEM_opcode,
    input lc3b_opcode barrier_MEM_WB_opcode,

    input logic stage_MEM_br_en,
    input lc3b_control_word barrier_MEM_WB_control,

    /* OUTPUTS */
    output logic pc_out,
    output logic pc_plus2_out,
    output lc3b_pipeline_control_word branch_controller_pipeline_control_request
);

lc3b_pc_mux_sel pc_mux_sel;
always_comb begin
    pc_mux_sel = barrier_MEM_WB_control.pc_mux_sel;
    if (barrier_MEM_WB_control.conditional_branch & ~stage_MEM_br_en) begin
        pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;
    end
end

plus2 pc_plus2 (
    /* INPUTS */
    .in(pc_in),

    /* OUTPUTS */
    .out(pc_plus2_out)
);

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
    .out(pc_out)
);




`define opcode_changes_pc(opcode) \
( opcode == op_br || opcode == op_jmp || opcode == op_jsr || opcode == op_trap )

assign branch_controller_pipeline_control_request.exclusive                    = 0;
assign branch_controller_pipeline_control_request.barrier_IF_ID_stall          = 0;
assign branch_controller_pipeline_control_request.barrier_ID_EX_stall          = 0;
assign branch_controller_pipeline_control_request.barrier_EX_MEM_stall         = 0;
assign branch_controller_pipeline_control_request.barrier_MEM_WB_stall         = 0;
assign branch_controller_pipeline_control_request.barrier_ID_EX_force_sr1_load = 0;
assign branch_controller_pipeline_control_request.barrier_ID_EX_force_sr2_load = 0;
assign branch_controller_pipeline_control_request.stage_ID_stall               = 0;
assign branch_controller_pipeline_control_request.stage_EX_stall               = 0;
assign branch_controller_pipeline_control_request.stage_MEM_stall              = 0;
assign branch_controller_pipeline_control_request.stage_WB_stall               = 0;

always_comb begin
    branch_controller_pipeline_control_request.active               = 0;
    branch_controller_pipeline_control_request.stage_IF_stall       = 0;
    branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 0;
    branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 0;
    branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 0;
    branch_controller_pipeline_control_request.barrier_MEM_WB_reset = 0;

    if (`opcode_changes_pc(barrier_IF_ID_opcode) & barrier_IF_ID_valid) begin
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.stage_IF_stall       = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
    end

    if (`opcode_changes_pc(barrier_ID_EX_opcode) & barrier_ID_EX_valid) begin
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.stage_IF_stall       = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
    end

    if (`opcode_changes_pc(barrier_EX_MEM_opcode) & barrier_EX_MEM_valid) begin
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.stage_IF_stall       = 1;
        branch_controller_pipeline_control_request.barrier_IF_ID_reset  = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
    end

    if (`opcode_changes_pc(barrier_MEM_WB_opcode) & barrier_MEM_WB_valid) begin
        branch_controller_pipeline_control_request.active               = 1;
        branch_controller_pipeline_control_request.barrier_ID_EX_reset  = 1;
        branch_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        branch_controller_pipeline_control_request.barrier_MEM_WB_reset = 1;
    end

end

endmodule : branch_controller
