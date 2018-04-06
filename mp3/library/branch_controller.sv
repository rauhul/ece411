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
    output logic stage_IF_stall,
    output logic barrier_IF_ID_reset,
    output logic barrier_ID_EX_reset,
    output logic barrier_EX_MEM_reset,
    output logic barrier_MEM_WB_reset
);

`define opcode_changes_pc(opcode) \
( opcode == op_br || opcode == op_jmp || opcode == op_jsr || opcode == op_trap )

always_comb begin

    stage_IF_stall       = 0;
    barrier_IF_ID_reset  = 0;
    barrier_ID_EX_reset  = 0;
    barrier_EX_MEM_reset = 0;
    barrier_MEM_WB_reset = 0;

    if (`opcode_changes_pc(barrier_IF_ID_opcode) & barrier_IF_ID_valid) begin
        stage_IF_stall       = 1;
        barrier_IF_ID_reset  = 1;
    end

    if (`opcode_changes_pc(barrier_ID_EX_opcode) & barrier_ID_EX_valid) begin
        stage_IF_stall       = 1;
        barrier_IF_ID_reset  = 1;
        barrier_ID_EX_reset  = 1;
    end

    if (`opcode_changes_pc(barrier_EX_MEM_opcode) & barrier_EX_MEM_valid) begin
        stage_IF_stall       = 1;
        barrier_IF_ID_reset  = 1;
        barrier_ID_EX_reset  = 1;
        barrier_EX_MEM_reset = 1;
    end

    if (`opcode_changes_pc(barrier_MEM_WB_opcode) & barrier_MEM_WB_valid) begin
        barrier_ID_EX_reset  = 1;
        barrier_EX_MEM_reset = 1;
        barrier_MEM_WB_reset = 1;
    end

end

endmodule : branch_controller
