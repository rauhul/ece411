module stage_WB (
    /* INPUTS */
    input clk,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,
    input lc3b_control_word control_in,
    input lc3b_word ir_in,
    input lc3b_word mdr_in,
    input lc3b_word alu_in,
    /* OUTPUTS */
    output lc3b_word regfiledatamux_out,
    output lc3b_word WB_mux2_out,   //shouldn't it be 3 bits cus it goes into dest of regfile?
    output lc3b_control_word control_out
);

//Internal signals
lc3b_word mdr_low_zext8_out;
lc3b_word mdr_high_zext8_out;

mux2 WB_mux2(
    .sel(control_in.WB_mux2_sel),
    .a(ir_in),
    .b(16'h0007),
    .f(WB_mux2_out)
)

zext8 mdr_low_zext8(
    .in(mdr_in[7:0])
    .out(mdr_low_zext8_out)
)

zext8 mdr_high_zext8(
    .in(mdr_in[15:8]),
    .out(mdr_high_zext8_out)
)
mux8 regfiledatamux(
    .sel(control_in.regfiledatamux_sel),
    .in000(pc_in),
    .in001(pcn_in),
    .in010(mdr_in),
    .in011(mdr_low_zext8_out),
    .in100(mdr_high_zext8_out),
    .in101(alu_in),
    .in110(16'b0),
    .in111(16'b0)
)




endmodule: stage_WB