import lc3b_types::*;

module stage_WB (
    /* INPUTS */
    input clk,
    input stall,
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

logic [1:0] [2:0] regfile_dest_mux_in;
assign regfile_dest_mux_in[0] = ir_in[11:9]; // dest
assign regfile_dest_mux_in[1] = 3'b111;      // R7
mux #(2, 3) regfile_dest_mux (
    /* INPUTS */
    .sel(control_in.regfile_dest_mux_sel),
    .in(regfile_dest_mux_in),

    /* OUTPUTS */
    .out(regfile_dest_out)
);

logic [3:0] [15:0] regfile_data_mux_in;
assign regfile_data_mux_in[0] = pc_in;
assign regfile_data_mux_in[1] = pcn_in;
assign regfile_data_mux_in[2] = mdr_in;
assign regfile_data_mux_in[3] = alu_in;
mux #(4, 16) regfile_data_mux (
    /* INPUTS */
    .sel(control_in.regfile_data_mux_sel),
    .in(regfile_data_mux_in),

    /* OUTPUTS */
    .out(regfile_data_out)
);

assign regfile_load_out = control_in.regfile_load;

endmodule: stage_WB
