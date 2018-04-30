import lc3b_types::*;

module control_rom (
    /* INPUTS */
    input lc3b_word ir_in,

    /* OUTPUTS */
    output lc3b_control_word control_out
);

lc3b_opcode opcode;
assign      opcode = lc3b_opcode'(ir_in[15:12]);

lc3b_reg dest;
assign   dest = ir_in[11:9];
lc3b_reg sr1;
assign   sr1  = ir_in[ 8:6];
lc3b_reg sr2;
assign   sr2  = ir_in[ 2:0];
lc3b_reg r7;
assign   r7   = 3'b111;

always_comb begin
    /* IF */
    control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

    /* ID */
    control_out.requires_sr1 = 0;
    control_out.requires_sr2 = 0;
    control_out.regfile_sr1  = 0;
    control_out.regfile_sr2  = 0;

    /* EX */
    control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset9;
    control_out.alu_mux_sel = lc3b_alu_mux_sel_sr2;
    control_out.alu_op = lc3b_alu_op_pass;

    /* MEM */
    control_out.cc_load = 0;
    control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;
    control_out.data_memory_access = 0;
    control_out.data_memory_write_enable = 0;
    control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
    control_out.data_memory_word_align = 0;

    /* WB */
    control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
    control_out.regfile_dest = 0;
    control_out.regfile_load = 0;

    /* Assign control signals based on opcode */
    case (opcode)
        /* ALU OPS */
        op_add: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;
            control_out.regfile_sr2 = sr2;

            /* EX */
            if (ir_in[5] == 0) begin
                control_out.requires_sr2 = 1;
                control_out.alu_mux_sel = lc3b_alu_mux_sel_sr2;
            end else begin
                control_out.requires_sr2 = 0;
                control_out.alu_mux_sel = lc3b_alu_mux_sel_imm5;
            end
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1; // load regfile
        end

        op_and: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;
            control_out.regfile_sr2 = sr2;

            /* EX */
            if (ir_in[5] == 0) begin
                control_out.requires_sr2 = 1;
                control_out.alu_mux_sel = lc3b_alu_mux_sel_sr2;
            end else begin
                control_out.requires_sr2 = 0;
                control_out.alu_mux_sel = lc3b_alu_mux_sel_imm5;
            end
            control_out.alu_op = lc3b_alu_op_and;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1; // load regfile
        end

        op_lea: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */

            /* EX */
            control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset9;

            /* MEM */
            control_out.cc_load = 1;
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_pcn;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_pcn;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1;
        end

        op_not: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.alu_op = lc3b_alu_op_not;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1; // load regfile
        end

        op_shf: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_imm4;
            if (ir_in[4] == 0)
                control_out.alu_op = lc3b_alu_op_sll;
            else
                if (ir_in[5] == 0)
                    control_out.alu_op = lc3b_alu_op_srl;
                else
                    control_out.alu_op = lc3b_alu_op_sra;

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_alu;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_alu;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1; // load regfile
        end

        /* DATA MEMORY OPS */
        /* LOAD */
        op_ldb: begin
            /* IF */

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_offset6_b;
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.cc_load = 1;
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_mdr;
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 0;
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_word_align = 0;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_mdr;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1;
        end

        op_ldi: begin
            /* IF */

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_offset6_w;
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.cc_load = 1;
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_mdr;
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 0;
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_word_align = 1;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_mdr;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1;
        end

        op_ldr: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_offset6_w;
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.cc_load = 1; // loac cc
            control_out.cc_gen_mux_sel = lc3b_cc_gen_mux_sel_mdr;
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 0; // read
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_word_align = 1;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_mdr;
            control_out.regfile_dest = dest;
            control_out.regfile_load = 1; // load regfile
        end

        /* STORE */
        op_stb: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.requires_sr2 = 1;
            control_out.regfile_sr1 = sr1;
            control_out.regfile_sr2 = dest;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_offset6_b;
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 1;
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_word_align = 0;

            /* WB */
        end

        op_sti: begin
            /* IF */

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.requires_sr2 = 1;
            control_out.regfile_sr1 = sr1;
            control_out.regfile_sr2 = dest;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_offset6_w;
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 1;
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_word_align = 1;

            /* WB */
        end

        op_str: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pc_plus2;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.requires_sr2 = 1;
            control_out.regfile_sr1 = sr1;
            control_out.regfile_sr2 = dest;

            /* EX */
            control_out.alu_mux_sel = lc3b_alu_mux_sel_offset6_w;
            control_out.alu_op = lc3b_alu_op_add;

            /* MEM */
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 1; // write
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_alu;
            control_out.data_memory_word_align = 1;

            /* WB */
        end

        /* PC CHANGING OPS */
        op_br: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_pcn;

            /* ID */

            /* EX */
            control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset9;

            /* MEM */

            /* WB */
        end

        op_jmp: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_alu;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.alu_op = lc3b_alu_op_pass;

            /* MEM */

            /* WB */
        end

        op_jsr: begin
            /* IF */
            if (ir_in[11] == 0)
                control_out.pc_mux_sel = lc3b_pc_mux_sel_alu;
            else
                control_out.pc_mux_sel = lc3b_pc_mux_sel_pcn;

            /* ID */
            control_out.requires_sr1 = 1;
            control_out.regfile_sr1 = sr1;

            /* EX */
            control_out.pc_adder_mux_sel = lc3b_pc_adder_mux_sel_offset11;
            control_out.alu_op = lc3b_alu_op_pass;

            /* MEM */

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_pc;
            control_out.regfile_dest = r7;
            control_out.regfile_load = 1;
        end

        op_trap: begin
            /* IF */
            control_out.pc_mux_sel = lc3b_pc_mux_sel_mdr;

            /* ID */

            /* EX */

            /* MEM */
            control_out.data_memory_access = 1;
            control_out.data_memory_write_enable = 0;
            control_out.data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_trapvect8;
            control_out.data_memory_word_align = 1;

            /* WB */
            control_out.regfile_data_mux_sel = lc3b_regfile_data_mux_sel_pc;
            control_out.regfile_dest = r7;
            control_out.regfile_load = 1;
        end

        default: begin
            control_out = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end
endmodule : control_rom
