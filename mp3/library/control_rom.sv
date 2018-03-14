import lc3b_types::*;

module control_rom (
    /* INPUTS */
    input lc3b_word ir_in,

    /* OUTPUTS */
    output lc3b_control_word control_out
);

lc3b_opcode opcode;
assign opcode = lc3b_opcode'(ir_in[15:12]);

always_comb begin
    /* IF */
    control_out.branch = 0;

    /* ID */
    control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;
    control_out.regfile_sr2_mux_sel = lc3b_regfile_sr2_mux_sel_sr2;

    /* EX */
    control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset9;
    control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_sr2;
    control_out.general_alu_op = lc3b_alu_op_pass;

    /* MEM */
    control_out.cc_load = 0;
    control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;
    control_out.br_en_load = 0;
    control_out.internal_mdr_load = 0;
    control_out.data_memory_write_enable = 0;
    control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
    control_out.data_memory_byte_sel = lc3b_data_memory_byte_sel_none;

    /* WB */
    control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
    control_out.regfile_dest_mux_sel = lc3b_regfile_dest_mux_sel_dest;
    control_out.regfile_load = 0;

    /* Assign control signals based on opcode */
    case (opcode)
        /* ALU OPS */
        op_add: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;
            control_out.regfile_sr2_mux_sel = lc3b_regfile_sr2_mux_sel_sr2;

            /* EX */
            if (ir_in[5] == 0)
                control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_sr2;
            else
                control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_imm5;
            control_out.general_alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest_mux_sel = lc3b_regfile_dest_mux_sel_dest;
            control_out.regfile_load = 1; // load regfile
        end

        op_and: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;
            control_out.regfile_sr2_mux_sel = lc3b_regfile_sr2_mux_sel_sr2;

            /* EX */
            if (ir_in[5] == 0)
                control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_sr2;
            else
                control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_imm5;
            control_out.general_alu_op = lc3b_alu_op_and;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest_mux_sel = lc3b_regfile_dest_mux_sel_dest;
            control_out.regfile_load = 1; // load regfile
        end

        op_not: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;

            /* EX */
            control_out.general_alu_op = lc3b_alu_op_not;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest_mux_sel = lc3b_regfile_dest_mux_sel_dest;
            control_out.regfile_load = 1; // load regfile
        end

        op_shf: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;

            /* EX */
            control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_imm4;
            if (ir_in[4] == 0)
                control_out.general_alu_op = lc3b_alu_op_sll;
            else
                if (ir_in[5] == 0)
                    control_out.general_alu_op = lc3b_alu_op_srl;
                else
                    control_out.general_alu_op = lc3b_alu_op_sra;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest_mux_sel = lc3b_regfile_dest_mux_sel_dest;
            control_out.regfile_load = 1; // load regfile
        end

        /* DATA MEMORY OPS */
        /* LOAD */
        op_ldr: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;

            /* EX */
            control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_offset6_w;
            control_out.general_alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.cc_load = 1; // loac cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_mdr;
            control_out.data_memory_write_enable = 0; // read
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_byte_sel = lc3b_data_memory_byte_sel_both;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_mdr;
            control_out.regfile_dest_mux_sel = lc3b_regfile_dest_mux_sel_dest;
            control_out.regfile_load = 1; // load regfile
        end

        // op_lea: begin
        //     /* IF */

        //     /* ID */

        //     /* EX */
        //     control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset9;

        //     /* MEM */
        //     control_out.cc_load = 1; // loac cc
        //     control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_mdr;
        //     control_out.data_memory_write_enable = 0;

        //     /* WB */
        //     control_out.regfile_data_mux_sel = 3'b0;
        //     control_out.regfile_dest_mux_sel = 0;
        //     control_out.regfile_load = 0;
        // end

        /* STORE */
        op_str: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = lc3b_regfile_sr1_mux_sel_sr1;
            control_out.regfile_sr2_mux_sel = lc3b_regfile_sr2_mux_sel_dest;

            /* EX */
            control_out.general_alu_mux_sel = lc3b_general_alu_mux_sel_offset6_w;
            control_out.general_alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.data_memory_write_enable = 1; // write
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_byte_sel = lc3b_data_memory_byte_sel_both;

            /* WB */
        end

        /* PC CHANGING OPS */
        op_br: begin
            /* IF */
            control_out.branch = 1; // branch

            /* ID */

            /* EX */
            control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset9;

            /* MEM */
            control_out.br_en_load = 1; // load branch enable

            /* WB */
        end

        default: begin
            control_out = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end
endmodule : control_rom
