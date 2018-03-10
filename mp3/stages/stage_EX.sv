module stage_EX (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word sr1_in,
    input lc3b_word sr2_in,

    /* OUTPUTS */
    output lc3b_word alu_out,
    output lc3b_word pcn_out
);

lc3b_word pc_adder_mux2_out;
lc3b_word general_alu_mux8_out;

// TODO: Update sel when the control_word is better defined
mux2 pc_adder_mux2 (
    /* INPUTS */
    .sel(control_in.sel),
    .a( $signed({ir_in[8:0],  1'b0}) ), // PCoffset9
    .b( $signed({ir_in[10:0], 1'b0}) ), // PCoffset11

    /* OUTPUTS */
    .f(pc_adder_mux2_out)
);

adder pc_adder (
    /* INPUTS */
    .a(pc_in),
    .b(pc_adder_mux2_out),

    /* OUTPUTS */
    .f(pcn_out)
);

// TODO: Update sel when the control_word is better defined
mux8 general_alu_mux8 (
    .sel(control_in.sel),
    .in000(sr2_in),
    .in001( $unsigned({ir_in[3:0]})       ), // imm4
    .in010(   $signed({ir_in[4:0]})       ), // imm5
    .in011(   $signed({ir_in[5:0]})       ), // offset6
    .in100(   $signed({ir_in[5:0], 1'b0}) ), // offset6
    .in101('x),
    .in110('x),
    .in111('x),
    .out(general_alu_mux8_out)
);

alu general_alu (
    /* INPUTS */
    .aluop(control_in.aluop),
    .a(sr1_in),
    .b(general_alu_mux8_out),

    /* OUTPUTS */
    .f(alu_out)
);

endmodule: stage_EX