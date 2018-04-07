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
    output lc3b_forward_mux_sel forward_A_mux_sel,
    output lc3b_forward_mux_sel forward_B_mux_sel
);

// EX to EX forwarding
logic stage_EX_to_stage_EX_sr1;
logic stage_EX_to_stage_EX_sr2;

// MEM to EX forwarding
logic stage_MEM_to_stage_EX_sr1;
logic stage_MEM_to_stage_EX_sr2;

always_comb begin
    forward_A_mux_sel = lc3b_forward_mux_sel_pass;
    forward_B_mux_sel = lc3b_forward_mux_sel_pass;

    // EX to EX forwarding
    stage_EX_to_stage_EX_sr1 =
        barrier_EX_MEM_control.regfile_load &
        barrier_ID_EX_control.requires_sr1 &
        barrier_ID_EX_control.regfile_sr1 == barrier_EX_MEM_control.regfile_dest;

    stage_EX_to_stage_EX_sr2 =
        barrier_EX_MEM_control.regfile_load &
        barrier_ID_EX_control.requires_sr2 &
        barrier_ID_EX_control.regfile_sr2 == barrier_EX_MEM_control.regfile_dest;

    if (stage_EX_to_stage_EX_sr1) begin
        forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    end

    if (stage_EX_to_stage_EX_sr2) begin
        forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    end

    // MEM to EX forwarding
    stage_MEM_to_stage_EX_sr1 =
        barrier_MEM_WB_control.regfile_load &
        barrier_ID_EX_control.requires_sr1 &
        barrier_ID_EX_control.regfile_sr1 == barrier_MEM_WB_control.regfile_dest;
    stage_MEM_to_stage_EX_sr2 =
        barrier_MEM_WB_control.regfile_load &
        barrier_ID_EX_control.requires_sr2 &
        barrier_ID_EX_control.regfile_sr2 == barrier_MEM_WB_control.regfile_dest;

    if (stage_MEM_to_stage_EX_sr1) begin
        forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    end

    if (stage_MEM_to_stage_EX_sr2) begin
        forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    end

    // case (barrier_ID_EX_opcode)
    //     /* ALU OPS */
    //     op_add : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load)begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_and : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     //op_lea: begin
    //     //end

    //     op_not : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_shf : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     /* DATA MEMORY OPS */
    //     /* LOAD */
    //     op_ldb : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_ldi : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_ldr : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     /* STORE */
    //     op_stb : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load)begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_sti : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load)begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_str : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load)begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
    //                 forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     /* PC CHANGING OPS */
    //     //op_br: begin
    //     //end

    //     op_jmp : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     op_jsr : begin
    //         if (barrier_MEM_WB_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
    //             end
    //         end
    //         if (barrier_EX_MEM_control.regfile_load) begin
    //             if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
    //                 forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
    //             end
    //         end
    //     end

    //     //op_trap: begin
    //     //end
    //     default : begin
    //         //control_out = 0; /* Unknown opcode, set control word to zero */
    //     end
    // endcase
end

endmodule : forwarding_controller
