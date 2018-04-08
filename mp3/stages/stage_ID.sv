import lc3b_types::*;

module stage_ID (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_word ir_in,
    input lc3b_reg regfile_dest_in,
    input lc3b_word regfile_data_in,
    input logic regfile_load_in,

    // forwarding
    input lc3b_forward_ID_mux_sel forward_ID_A_mux_sel,
    input lc3b_forward_ID_mux_sel forward_ID_B_mux_sel,
    input lc3b_word stage_WB_regfile_data,

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

logic [15:0] regfile_sr1;
logic [15:0] regfile_sr2;
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
    .sr1_out(regfile_sr1),
    .sr2_out(regfile_sr2)
);


// forwarding
logic [1:0] [15:0] forward_ID_A_mux_in;
assign forward_ID_A_mux_in[0] = regfile_sr1;
assign forward_ID_A_mux_in[1] = stage_WB_regfile_data;
mux #(2, 16) forward_A_mux (
    /* INPUTS */
    .sel(forward_ID_A_mux_sel),
    .in(forward_ID_A_mux_in),

    /* OUTPUTS */
    .out(sr1_out)
);

logic [1:0] [15:0] forward_ID_B_mux_in;
assign forward_ID_B_mux_in[0] = regfile_sr2;
assign forward_ID_B_mux_in[1] = stage_WB_regfile_data;
mux #(2, 16) forward_B_mux (
    /* INPUTS */
    .sel(forward_ID_B_mux_sel),
    .in(forward_ID_B_mux_in),

    /* OUTPUTS */
    .out(sr2_out)
);

endmodule : stage_ID
