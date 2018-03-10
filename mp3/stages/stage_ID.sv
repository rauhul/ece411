import lc3b_types::*;

module stage_ID (
    /* INPUTS */
    input clk,
    input lc3b_word ir_in,
    input lc3b_word regfile_data_in,
    input lc3b_word regfile_load_in,
    input lc3b_reg regfile_dest_in,

    /* OUTPUTS */
    output lc3b_control_word control_out,
    output lc3b_word sr1_out,
    output lc3b_word sr2_out
);

lc3b_word regfile_sr1_mux2_out;
lc3b_word regfile_sr2_mux2_out;

control_rom rom (
    .opcode(ir_in[15:12]),
    .ctrl(control_out)
);

// TODO: Update sel when the control_word is better defined
mux2 #(.width(3)) regfile_sr1_mux2 (
    /* INPUTS */
    .sel(ERROR),
    .a(ir_in[8:6]),  // sr1
    .b(ir_in[11:9]), // dest

    /* OUTPUTS */
    .f(regfile_sr1_mux2_out)
);

// TODO: Update sel when the control_word is better defined
mux2 #(.width(3)) regfile_sr2_mux2 (
    /* INPUTS */
    .sel(ERROR),
    .a(ir_in[2:0]),  // sr2
    .b(ir_in[11:9]), // dest

    /* OUTPUTS */
    .f(regfile_sr2_mux2_out)
);

regfile _regfile (
    /* INPUTS */
    .clk,
    .load(regfile_load_in),
    .in(regfile_data_in),
    .src_a(regfile_sr1_mux2_out),
    .src_b(regfile_sr2_mux2_out),
    .dest(regfile_dest_in),

    /* OUTPUTS */
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);

endmodule : stage_ID
