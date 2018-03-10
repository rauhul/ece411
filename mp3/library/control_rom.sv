import lc3b_types::*;

module control_rom (
    /* INPUTS */
    input lc3b_opcode ir_in,

    /* OUTPUTS */
    output lc3b_control_word control_out
);

lc3b_opcode opcode;
assign opcode = lc3b_opcode'(ir_in[15:12]);

always_comb begin
    /* IF */

    /* ID */
    control_out.regfile_sr1_mux_sel = 1'b0;
    control_out.regfile_sr2_mux_sel = 1'b0;

    /* EX */
    control_out.pc_adder_mux_sel = 1'b0;
    control_out.general_alu_mux_sel = 3'b0;
    control_out.general_alu_op = alu_pass;

    /* MEM */

    /* WB */
    control_out.regfile_data_mux_sel = 1'b0;
    control_out.regfile_dest_mux_sel = 1'b0;
    control_out.regfile_load = 1'b0;

    /* Assign control signals based on opcode */
    case (opcode)
        op_add: begin

        end

        op_and: begin

        end

        default: begin
            control_out = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end
endmodule : control_rom