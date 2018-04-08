import lc3b_types::*;

module branch_controller (
    /* INPUTS */
    input logic barrier_IF_ID_valid,
    input logic barrier_ID_EX_valid,
    input logic barrier_EX_MEM_valid,
    input logic barrier_MEM_WB_valid,
    input lc3b_opcode barrier_IF_ID_opcode,
    input lc3b_opcode barrier_ID_EX_opcode,
    input lc3b_opcode barrier_EX_MEM_opcode,
    input lc3b_opcode barrier_MEM_WB_opcode,

    /* OUTPUTS */
    output lc3b_pipeline_control_word branch_controller_pipeline_control_request
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
