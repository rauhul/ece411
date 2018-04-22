import lc3b_types::*;

module forwarding_controller (
    /* INPUTS */
    input lc3b_opcode barrier_ID_EX_opcode,
    input lc3b_opcode barrier_EX_MEM_opcode,
    input lc3b_opcode barrier_MEM_WB_opcode,
    input lc3b_control_word barrier_ID_EX_control,
    input lc3b_control_word barrier_EX_MEM_control,
    input lc3b_control_word barrier_MEM_WB_control,

    /* OUTPUTS */
    output lc3b_forward_ID_mux_sel forward_ID_A_mux_sel,
    output lc3b_forward_ID_mux_sel forward_ID_B_mux_sel,
    output lc3b_forward_EX_mux_sel forward_EX_A_mux_sel,
    output lc3b_forward_EX_mux_sel forward_EX_B_mux_sel,
    output lc3b_pipeline_control_word forwarding_controller_pipeline_control_request
);

// EX_MEM to EX forwarding
logic barrier_EX_MEM_to_stage_EX_sr1;
logic barrier_EX_MEM_to_stage_EX_sr2;

// MEM_WB to EX forwarding
logic barrier_MEM_WB_to_stage_EX_sr1;
logic barrier_MEM_WB_to_stage_EX_sr2;

// STALL upstream if EX_MEM is load
logic barrier_EX_MEM_is_load;

always_comb begin

    forwarding_controller_pipeline_control_request.active                       = 0;
    forwarding_controller_pipeline_control_request.exclusive                    = 0;
    forwarding_controller_pipeline_control_request.barrier_IF_ID_stall          = 0;
    forwarding_controller_pipeline_control_request.barrier_ID_EX_stall          = 0;
    forwarding_controller_pipeline_control_request.barrier_EX_MEM_stall         = 0;
    forwarding_controller_pipeline_control_request.barrier_MEM_WB_stall         = 0;
    forwarding_controller_pipeline_control_request.barrier_IF_ID_reset          = 0;
    forwarding_controller_pipeline_control_request.barrier_ID_EX_reset          = 0;
    forwarding_controller_pipeline_control_request.barrier_EX_MEM_reset         = 0;
    forwarding_controller_pipeline_control_request.barrier_MEM_WB_reset         = 0;
    forwarding_controller_pipeline_control_request.barrier_ID_EX_force_sr1_load = 0;
    forwarding_controller_pipeline_control_request.barrier_ID_EX_force_sr2_load = 0;
    forwarding_controller_pipeline_control_request.stage_IF_stall               = 0;
    forwarding_controller_pipeline_control_request.stage_ID_stall               = 0;
    forwarding_controller_pipeline_control_request.stage_EX_stall               = 0;
    forwarding_controller_pipeline_control_request.stage_MEM_stall              = 0;
    forwarding_controller_pipeline_control_request.stage_WB_stall               = 0;

    forward_ID_A_mux_sel = lc3b_forward_ID_mux_sel_pass;
    forward_ID_B_mux_sel = lc3b_forward_ID_mux_sel_pass;
    forward_EX_A_mux_sel = lc3b_forward_EX_mux_sel_pass;
    forward_EX_B_mux_sel = lc3b_forward_EX_mux_sel_pass;

    // EX_MEM to EX forwarding
    barrier_EX_MEM_to_stage_EX_sr1 =
        barrier_EX_MEM_control.regfile_load &
        barrier_ID_EX_control.requires_sr1 &
        barrier_ID_EX_control.regfile_sr1 == barrier_EX_MEM_control.regfile_dest;

    barrier_EX_MEM_to_stage_EX_sr2 =
        barrier_EX_MEM_control.regfile_load &
        barrier_ID_EX_control.requires_sr2 &
        barrier_ID_EX_control.regfile_sr2 == barrier_EX_MEM_control.regfile_dest;

    if (barrier_EX_MEM_to_stage_EX_sr1) begin
        forward_EX_A_mux_sel = lc3b_forward_EX_mux_sel_stage_MEM_regfile_data;
    end

    if (barrier_EX_MEM_to_stage_EX_sr2) begin
        forward_EX_B_mux_sel = lc3b_forward_EX_mux_sel_stage_MEM_regfile_data;
    end

    // MEM_WB to EX forwarding
    barrier_MEM_WB_to_stage_EX_sr1 =
       ~barrier_EX_MEM_to_stage_EX_sr1 &
        barrier_MEM_WB_control.regfile_load &
        barrier_ID_EX_control.requires_sr1 &
        barrier_ID_EX_control.regfile_sr1 == barrier_MEM_WB_control.regfile_dest;
    barrier_MEM_WB_to_stage_EX_sr2 =
       ~barrier_EX_MEM_to_stage_EX_sr2 &
        barrier_MEM_WB_control.regfile_load &
        barrier_ID_EX_control.requires_sr2 &
        barrier_ID_EX_control.regfile_sr2 == barrier_MEM_WB_control.regfile_dest;

    if (barrier_MEM_WB_to_stage_EX_sr1) begin
        forward_EX_A_mux_sel = lc3b_forward_EX_mux_sel_stage_WB_regfile_data;
    end

    if (barrier_MEM_WB_to_stage_EX_sr2) begin
        forward_EX_B_mux_sel = lc3b_forward_EX_mux_sel_stage_WB_regfile_data;
    end

    // STALL upstream if EX_MEM is load
    barrier_EX_MEM_is_load =
        barrier_EX_MEM_control.data_memory_access &
       ~barrier_EX_MEM_control.data_memory_write_enable;

    if (barrier_EX_MEM_is_load & (barrier_EX_MEM_to_stage_EX_sr1 | barrier_EX_MEM_to_stage_EX_sr2)) begin
        forwarding_controller_pipeline_control_request.active               = 1;
        forwarding_controller_pipeline_control_request.barrier_IF_ID_stall  = 1;
        forwarding_controller_pipeline_control_request.barrier_ID_EX_stall  = 1;
        forwarding_controller_pipeline_control_request.barrier_EX_MEM_reset = 1;
        forwarding_controller_pipeline_control_request.stage_IF_stall       = 1;
        forwarding_controller_pipeline_control_request.stage_EX_stall       = 1;

        if (barrier_MEM_WB_to_stage_EX_sr1) begin
            forwarding_controller_pipeline_control_request.barrier_ID_EX_force_sr1_load = 1;
            forward_ID_A_mux_sel = lc3b_forward_ID_mux_sel_stage_WB_regfile_data;
        end

        if (barrier_MEM_WB_to_stage_EX_sr2) begin
            forwarding_controller_pipeline_control_request.barrier_ID_EX_force_sr2_load = 1;
            forward_ID_B_mux_sel = lc3b_forward_ID_mux_sel_stage_WB_regfile_data;
        end
    end

end

endmodule : forwarding_controller
