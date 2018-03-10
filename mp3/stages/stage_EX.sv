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

lc3b_word pc_adder_mux_out;
lc3b_word general_alu_mux_out;

mux2 pc_adder_mux (
    /* INPUTS */
    .sel(control_in.pc_adder_mux_sel),
    .a( $signed({ir_in[8:0],  1'b0}) ), // PCoffset9
    .b( $signed({ir_in[10:0], 1'b0}) ), // PCoffset11

    /* OUTPUTS */
    .f(pc_adder_mux_out)
);

adder pc_adder (
    /* INPUTS */
    .a(pc_in),
    .b(pc_adder_mux_out),

    /* OUTPUTS */
    .f(pcn_out)
);

mux8 general_alu_mux (
    .sel(control_in.general_alu_mux_sel),
    .in000(sr2_in),
    .in001( $unsigned({ir_in[3:0]})       ), // imm4
    .in010(   $signed({ir_in[4:0]})       ), // imm5
    .in011(   $signed({ir_in[5:0]})       ), // offset6
    .in100(   $signed({ir_in[5:0], 1'b0}) ), // offset6
    .in101('x),
    .in110('x),
    .in111('x),
    .out(general_alu_mux_out)
);

alu general_alu (
    /* INPUTS */
    .aluop(control_in.general_alu_op),
    .a(sr1_in),
    .b(general_alu_mux_out),

    /* OUTPUTS */
    .f(alu_out)
);

endmodule: stage_EX