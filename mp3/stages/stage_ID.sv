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

logic       [2:0] regfile_sr1_mux_out;
logic [1:0] [2:0] regfile_sr1_mux_in;
assign regfile_sr1_mux_in[0] = ir_in[ 8:6]; // sr1
assign regfile_sr1_mux_in[1] = ir_in[11:9]; // dest
mux #(2, 3) regfile_sr1_mux (
    /* INPUTS */
    .sel(control_out.regfile_sr1_mux_sel),
    .in(regfile_sr1_mux_in),  // sr1

    /* OUTPUTS */
    .out(regfile_sr1_mux_out)
);

logic       [2:0] regfile_sr2_mux_out;
logic [1:0] [2:0] regfile_sr2_mux_in;
assign regfile_sr2_mux_in[0] = ir_in[ 2:0]; // sr2
assign regfile_sr2_mux_in[1] = ir_in[11:9]; // dest
mux #(2, 3) regfile_sr2_mux (
    /* INPUTS */
    .sel(control_out.regfile_sr2_mux_sel),
    .in(regfile_sr2_mux_in),

    /* OUTPUTS */
    .out(regfile_sr2_mux_out)
);

regfile _regfile (
    /* INPUTS */
    .clk,
    .load(regfile_load_in),
    .stall,
    .in(regfile_data_in),
    .src_a(regfile_sr1_mux_out),
    .src_b(regfile_sr2_mux_out),
    .dest(regfile_dest_in),

    /* OUTPUTS */
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);

endmodule : stage_ID
