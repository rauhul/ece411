import lc3b_types::*;

module datapath
(
    /* INPUTS */
    /* global->datapath */
    input clk,

    /* memory->datapath */
    input lc3b_word mem_rdata,

    /* control->datapath */
    input load_pc,
    input load_ir,
    input load_regfile,
    input load_mar,
    input load_mdr,
    input load_cc,
    input pcmux_sel,
    input storemux_sel,
    input [1:0] alumux_sel,
    input regfilemux_sel,
    input marmux_sel,
    input mdrmux_sel,
    input lc3b_aluop aluop,

    /* OUTPUTS */
    /* datapath->memory */
    output lc3b_word mem_address,
    output lc3b_word mem_wdata,

    /* datapath->control */
    output lc3b_opcode opcode,
    output inst5,
    output branch_enable
);


/*
 * Internal Signals
 */
lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg storemux_out;
lc3b_word sr1_out;
lc3b_word sr2_out;
lc3b_imm5 imm5;
lc3b_word sext5_out;
lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_word pcmux_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alu_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;

/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .f(pcmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

plus2 pc_plus2
(
    .in(pc_out),
    .out(pc_plus2_out)
);

alu br_add
(
    .aluop(alu_add),
    .a(pc_out),
    .b(adj9_out),
    .f(br_add_out)
);

adj #(.width(9)) adj9
(
    .in(offset9),
    .out(adj9_out)
);


/*
 * Memory
 */
mux2 marmux
(
    .sel(marmux_sel),
    .a(alu_out),
    .b(pc_out),
    .f(marmux_out)
);

register mar
(
    .clk,
    .load(load_mar),
    .in(marmux_out),
    .out(mem_address)
);

mux2 mdrmux
(
    .sel(mdrmux_sel),
    .a(alu_out),
    .b(mem_rdata),
    .f(mdrmux_out)
);

register mdr
(
    .clk,
    .load(load_mdr),
    .in(mdrmux_out),
    .out(mem_wdata)
);


/*
 * Register File
 */
ir _ir
(
    .clk,
    .load(load_ir),
    .in(mem_wdata),
    .opcode,
    .inst5,
    .dest,
    .src1(sr1),
    .src2(sr2),
    .imm5,
    .offset6,
    .offset9
);

mux2 #(.width(3)) storemux
(
    .sel(storemux_sel),
    .a(sr1),
    .b(dest),
    .f(storemux_out)
);

regfile _regfile
(
    .clk,
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(storemux_out),
    .src_b(sr2),
    .dest,
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);

mux2 regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
    .f(regfilemux_out)
);


/*
 * ALU
 */
adj #(.width(6)) adj6
(
    .in(offset6),
    .out(adj6_out)
);

sext #(.width(5)) sext5
(
    .in(imm5),
    .out(sext5_out)
);

mux4 alumux
(
    .sel(alumux_sel),
    .a(sr2_out),
    .b(adj6_out),
    .c(sext5_out),
    .d(16'bx),
    .f(alumux_out)
);

alu _alu
(
    .aluop,
    .a(sr1_out),
    .b(alumux_out),
    .f(alu_out)
);


/*
 * CC
 */
gencc _gencc
(
    .in(regfilemux_out),
    .out(gencc_out)
);

register #(.width(3)) cc
(
    .clk,
    .load(load_cc),
    .in(gencc_out),
    .out(cc_out)
);

cccomp _cccomp
(
    .a(dest),
    .b(cc_out),
    .f(branch_enable)
);

endmodule : datapath
