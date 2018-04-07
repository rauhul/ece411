import lc3b_types::*;

module stage_ID (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_word ir_in,
    input lc3b_reg regfile_dest_in,
    input lc3b_word regfile_data_in,
    input logic regfile_load_in,

    /* OUTPUTS */
    output lc3b_control_word control_out,
    output lc3b_word sr1_out,
    output lc3b_word sr2_out
);

control_rom _control_rom (
    /* INPUTS */
    .ir_in,

    /* OUTPUTS */
    .control_out
);

regfile _regfile (
    /* INPUTS */
    .clk,
    .load(regfile_load_in),
    .stall,
    .in(regfile_data_in),
    .sr1(control_out.regfile_sr1),
    .sr2(control_out.regfile_sr2),
    .dest(regfile_dest_in),

    /* OUTPUTS */
    .sr1_out,
    .sr2_out
);

endmodule : stage_ID
