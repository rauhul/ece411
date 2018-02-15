import lc3b_types::*;

module cpu
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

cpu_control _cpu_control
(
    /* INPUTS */
    /* global->cpu_control */
    .clk,

    /* cpu_datapath->cpu_control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable,

    /* cpu_datapath->memory (hijack) */
    .mem_address,

    /* memory->cpu_control */
    .mem_resp,

    /* OUTPUTS */
    /* cpu_control->data */
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

    /* cpu_control->memory */
    .mem_read,
    .mem_write,
    .mem_byte_enable
);

cpu_datapath _cpu_datapath
(
    /* INPUTS */
    .clk,

    /* memory->cpu_datapath */
    .mem_rdata,

    /* cpu_control->cpu_datapath */
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
    /* cpu_datapath->memory */
    .mem_address,
    .mem_wdata,

    /* cpu_datapath->cpu_control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable
);

endmodule : mp2
