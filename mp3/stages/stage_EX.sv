import lc3b_types::*;

module stage_EX (
    /* INPUTS */
    input clk,
    input stall,
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

lc3b_word imm4;
lc3b_word imm5;
lc3b_word offset6_b; // byte aligned
lc3b_word offset6_w; // word aligned
lc3b_word offset9;
lc3b_word offset11;

assign imm4    = $unsigned( ir_in[ 3:0]);
assign imm5      = $signed( ir_in[ 4:0]);
assign offset6_b = $signed( ir_in[ 5:0]);
assign offset6_w = $signed({ir_in[ 5:0], 1'b0});
assign offset9   = $signed({ir_in[ 8:0], 1'b0});
assign offset11  = $signed({ir_in[10:0], 1'b0});

logic [1:0] [15:0] pc_adder_mux_in;
assign pc_adder_mux_in[0] = offset9;
assign pc_adder_mux_in[1] = offset11;
mux #(2, 16) pc_adder_mux (
    /* INPUTS */
    .sel(control_in.pc_adder_mux_sel),
    .in(pc_adder_mux_in),

    /* OUTPUTS */
    .out(pc_adder_mux_out)
);

adder pc_adder (
    /* INPUTS */
    .a(pc_in),
    .b(pc_adder_mux_out),

    /* OUTPUTS */
    .f(pcn_out)
);

logic [4:0] [15:0] general_alu_mux_in;
assign general_alu_mux_in[0] = sr2_in;
assign general_alu_mux_in[1] = imm4;
assign general_alu_mux_in[2] = imm5;
assign general_alu_mux_in[3] = offset6_b;
assign general_alu_mux_in[4] = offset6_w;
mux #(5, 16) general_alu_mux (
    /* INPUTS */
    .sel(control_in.general_alu_mux_sel),
    .in(general_alu_mux_in),

    /* OUTPUTS */
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