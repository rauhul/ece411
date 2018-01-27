import lc3b_types::*;

module mp1
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
logic inst5;
logic branch_enable;

logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic load_cc;
logic pcmux_sel;
logic storemux_sel;
logic alumux_sel;
logic regfilemux_sel;
logic marmux_sel;
logic mdrmux_sel;
lc3b_aluop aluop;


control _control
(
    /* INPUTS */
    /* global->control */
    .clk,

    /* datapath->control */
    .opcode,
    .inst5,
    .branch_enable,

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
    .pcmux_sel,
    .storemux_sel,
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
    .pcmux_sel,
    .storemux_sel,
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
    .inst5,
    .branch_enable
);

endmodule : mp1
