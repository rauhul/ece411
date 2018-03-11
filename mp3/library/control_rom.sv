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

    /* ID */
    control_out.regfile_sr1_mux_sel = 0;
    control_out.regfile_sr2_mux_sel = 0;

    /* EX */
    control_out.pc_adder_mux_sel = 0;
    control_out.general_alu_mux_sel = 3'b0;
    control_out.general_alu_op = alu_pass;

    /* MEM */
    control_out.cc_load = 0;
    control_out.cc_gen_mux_sel = 2'b0;
    control_out.internal_mdr_load = 0;
    control_out.data_memory_write_enable = 0;
    control_out.data_memory_addr_mux_sel = 2'b0;
    control_out.data_memory_byte_sel = 2'b0;

    /* WB */
    control_out.regfile_data_mux_sel = 3'b0;
    control_out.regfile_dest_mux_sel = 0;
    control_out.regfile_load = 0;

    /* Assign control signals based on opcode */
    case (opcode)
        /* ALU OPS */
        op_add: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = 0; // sr1
            control_out.regfile_sr2_mux_sel = 0; // sr2

            /* EX */
            if (ir_in[5] == 0)
                control_out.general_alu_mux_sel = 3'b000; // sr2
            else
                control_out.general_alu_mux_sel = 3'b010; // imm5
            control_out.general_alu_op = alu_add; // add

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = 2'b01; // alu

            /* WB */
            control_out.regfile_data_mux_sel = 3'b101; // alu
            control_out.regfile_dest_mux_sel = 0; // dest
            control_out.regfile_load = 1; // load regfile
        end

        op_and: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = 0; // sr1
            control_out.regfile_sr2_mux_sel = 0; // sr2

            /* EX */
            if (ir_in[5] == 0)
                control_out.general_alu_mux_sel = 3'b000; // sr2
            else
                control_out.general_alu_mux_sel = 3'b010; // imm5
            control_out.general_alu_op = alu_and; // and

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = 2'b01; // alu

            /* WB */
            control_out.regfile_data_mux_sel = 3'b101; // alu
            control_out.regfile_dest_mux_sel = 0; // dest
            control_out.regfile_load = 1; // load regfile
        end

        op_not: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = 0; // sr1

            /* EX */
            control_out.general_alu_op = alu_not; // not

            /* MEM */
            control_out.cc_load = 1; // load cc
            control_out.cc_gen_mux_sel = 2'b01; // alu

            /* WB */
            control_out.regfile_data_mux_sel = 3'b101; // alu
            control_out.regfile_dest_mux_sel = 0; // dest
            control_out.regfile_load = 1; // load regfile
        end

        /* DATA MEMORY OPS */
        op_ldr: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = 0; // sr1

            /* EX */
            control_out.general_alu_mux_sel = 3'b100; // offset6_w
            control_out.general_alu_op = alu_add; // add

            /* MEM */
            control_out.cc_load = 1; // loac cc
            control_out.cc_gen_mux_sel = 2'b10; // mdr
            control_out.data_memory_write_enable = 0; // read
            control_out.data_memory_addr_mux_sel = 2'b10; // alu
            control_out.data_memory_byte_sel = 2'b11; // word

            /* WB */
            control_out.regfile_data_mux_sel = 3'b010; // mdr
            control_out.regfile_dest_mux_sel = 0; // dest
            control_out.regfile_load = 1; // load regfile
        end

        op_str: begin
            /* IF */

            /* ID */
            control_out.regfile_sr1_mux_sel = 0; // sr1
            control_out.regfile_sr2_mux_sel = 1; // dest

            /* EX */
            control_out.general_alu_mux_sel = 3'b100; // offset6_w
            control_out.general_alu_op = alu_add; // add

            /* MEM */
            control_out.data_memory_write_enable = 1; // write
            control_out.data_memory_addr_mux_sel = 2'b10; // alu
            control_out.data_memory_byte_sel = 2'b11; // word

            /* WB */
        end

        /* PC CHANGING OPS */
        op_br: begin
            /* IF */

            /* ID */

            /* EX */

            /* MEM */

            /* WB */
        end

        default: begin
            control_out = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end
endmodule : control_rom
