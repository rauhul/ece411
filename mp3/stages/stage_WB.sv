import lc3b_types::*;

module stage_WB (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word mdr_in,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,

    /* OUTPUTS */
    output lc3b_reg regfile_dest_out,
    output lc3b_word regfile_data_out,
    output lc3b_word regfile_load_out
);

lc3b_word mdr_low_in;
lc3b_word mdr_high_in;
assign mdr_low_in  = $unsigned({mdr_in[ 7:0]});
assign mdr_high_in = $unsigned({mdr_in[15:8]});

mux2 #(.width(3)) regfile_dest_mux (
    /* INPUTS */
    .sel(control_in.regfile_dest_mux_sel),
    .a(ir_in[11:9]), // dest
    .b(3'b111),      // R7

    /* OUTPUTS */
    .f(regfile_dest_out)
);

mux8 regfile_data_mux (
    /* INPUTS */
    .sel(control_in.regfile_data_mux_sel),
    .in000(pc_in),
    .in001(pcn_in),
    .in010(mdr_in),
    .in011(mdr_low_in),
    .in100(mdr_high_in),
    .in101(alu_in),
    .in110(16'bx),
    .in111(16'bx),

    /* OUTPUTS */
    .out(regfile_data_out)
);

assign regfile_load_out = control_in.regfile_load;

endmodule: stage_WB
