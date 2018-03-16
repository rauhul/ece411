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
    output logic regfile_load_out
);

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
    .in101(alu_in),

    /* OUTPUTS */
    .out(regfile_data_out)
);

assign regfile_load_out = control_in.regfile_load;

endmodule: stage_WB
