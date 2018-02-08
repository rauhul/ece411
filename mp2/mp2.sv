import lc3b_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

lc3b_opcode opcode;
logic inst4;
logic inst5;
logic inst11;
logic branch_enable;

logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic load_cc;
logic brmux_sel;
logic [1:0] pcmux_sel;
logic storemux_sel;
logic destmux_sel;
logic [2:0] alumux_sel;
logic [2:0] regfilemux_sel;
logic [1:0] marmux_sel;
logic mdrmux_sel;
lc3b_aluop aluop;

control _control
(
    /* INPUTS */
    /* global->control */
    .clk,

    /* datapath->control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable,

    /* datapath->memory (hijack) */
    .mem_address,

    /* memory->control */
    .mem_resp,

    /* OUTPUTS */
    /* control->data */
    .load_pc,
    .load_ir,
    .load_regfile,
    .load_mar,
    .load_mdr,
    .load_cc,
    .brmux_sel,
    .pcmux_sel,
    .storemux_sel,
    .destmux_sel,
    .alumux_sel,
    .regfilemux_sel,
    .marmux_sel,
    .mdrmux_sel,
    .aluop,

    /* control->memory */
    .mem_read,
    .mem_write,
    .mem_byte_enable
);

datapath _datapath
(
    /* INPUTS */
    .clk,

    /* memory->datapath */
    .mem_rdata,

    /* control->datapath */
    .load_pc,
    .load_ir,
    .load_regfile,
    .load_mar,
    .load_mdr,
    .load_cc,
    .brmux_sel,
    .pcmux_sel,
    .storemux_sel,
    .destmux_sel,
    .alumux_sel,
    .regfilemux_sel,
    .marmux_sel,
    .mdrmux_sel,
    .aluop,

    /* OUTPUTS */
    /* datapath->memory */
    .mem_address,
    .mem_wdata,

    /* datapath->control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable
);

endmodule : mp2
