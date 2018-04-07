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
    input logic [1:0] forward_A_mux_sel,
    input logic [1:0] forward_B_mux_sel,
    input lc3b_word alu_EX_MEM,
    input lc3b_word data_WB,
    input lc3b_word pcn_EX_MEM,

    /* OUTPUTS */
    output lc3b_word alu_out,
    output lc3b_word pcn_out
);

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

logic       [15:0] pc_adder_mux_out;
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

logic       [15:0] alu_mux_out;
logic [4:0] [15:0] alu_mux_in;
assign alu_mux_in[0] = sr2_in;
assign alu_mux_in[1] = imm4;
assign alu_mux_in[2] = imm5;
assign alu_mux_in[3] = offset6_b;
assign alu_mux_in[4] = offset6_w;
mux #(5, 16) alu_mux (
    /* INPUTS */
    .sel(control_in.alu_mux_sel),
    .in(alu_mux_in),

    /* OUTPUTS */
    .out(alu_mux_out)
);

logic       [15:0] forward_A_mux_out;
logic [3:0] [15:0] forward_A_mux_in;
assign forward_A_mux_in[0] = sr1_in;
assign forward_A_mux_in[1] = alu_EX_MEM;
assign forward_A_mux_in[2] = data_WB;
assign forward_A_mux_in[3] = pcn_EX_MEM;
mux #(4, 16) forward_A_mux (
    /* INPUTS */
    .sel(forward_A_mux_sel),
    .in(forward_A_mux_in),

    /* OUTPUTS */
    .out(forward_A_mux_out)
);

logic       [15:0] forward_B_mux_out;
logic [3:0] [15:0] forward_B_mux_in;
assign forward_B_mux_in[0] = alu_mux_out;
assign forward_B_mux_in[1] = alu_EX_MEM;
assign forward_B_mux_in[2] = data_WB;
assign forward_B_mux_in[3] = pcn_EX_MEM;
mux #(4, 16) forward_B_mux (
    /* INPUTS */
    .sel(forward_B_mux_sel),
    .in(forward_B_mux_in),

    /* OUTPUTS */
    .out(forward_B_mux_out)
);

alu _alu (
    /* INPUTS */
    .aluop(control_in.alu_op),
    .a(forward_A_mux_out),
    .b(forward_B_mux_out),

    /* OUTPUTS */
    .f(alu_out)
);

endmodule: stage_EX