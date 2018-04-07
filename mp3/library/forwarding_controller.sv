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

/* flags indicating if the two previous instructions has dest register*/
logic barrier_EX_MEM_has_DR;
logic barrier_MEM_WB_has_DR;

always_comb begin
    forward_A_mux_sel     = lc3b_forward_mux_sel_pass;
    forward_B_mux_sel     = lc3b_forward_mux_sel_pass;
    barrier_EX_MEM_has_DR = 0;
    barrier_MEM_WB_has_DR = 0;

    if (barrier_EX_MEM_opcode == op_add || barrier_EX_MEM_opcode == op_and || barrier_EX_MEM_opcode == op_ldb || barrier_EX_MEM_opcode == op_ldi || barrier_EX_MEM_opcode == op_ldr || barrier_EX_MEM_opcode == op_lea ||
        barrier_EX_MEM_opcode == op_not || barrier_EX_MEM_opcode == op_shf) begin
        barrier_EX_MEM_has_DR = 1;
    end

    if (barrier_MEM_WB_opcode == op_add || barrier_MEM_WB_opcode == op_and || barrier_MEM_WB_opcode == op_ldb || barrier_MEM_WB_opcode == op_ldi || barrier_MEM_WB_opcode == op_ldr || barrier_MEM_WB_opcode == op_lea ||
        barrier_MEM_WB_opcode == op_not || barrier_MEM_WB_opcode == op_shf) begin
        barrier_MEM_WB_has_DR = 1;
    end

    case (barrier_ID_EX_opcode)
        /* ALU OPS */
        op_add : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR)begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_and : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        //op_lea: begin
        //end

        op_not : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_shf : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        /* DATA MEMORY OPS */
        /* LOAD */
        op_ldb : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_ldi : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_ldr : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        /* STORE */
        op_stb : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR)begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_sti : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR)begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_str : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR)begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr2) begin
                    forward_B_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        /* PC CHANGING OPS */
        //op_br: begin
        //end

        op_jmp : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        op_jsr : begin
            if (barrier_MEM_WB_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_WB_regfile_data;
                end
            end
            if (barrier_EX_MEM_has_DR) begin
                if (barrier_MEM_WB_control.regfile_dest == barrier_ID_EX_control.regfile_sr1) begin
                    forward_A_mux_sel = lc3b_forward_mux_sel_stage_MEM_regfile_data;
                end
            end
        end

        //op_trap: begin
        //end
        default : begin
            //control_out = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end

endmodule : forwarding_controller
