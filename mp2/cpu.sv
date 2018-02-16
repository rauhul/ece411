import lc3b_types::*;

module cpu
(
    /* CPU <-> Cache */
    wishbone.master cache_wishbone
);

/* cache_wishbone */
assign cache_wishbone.DAT_M[127:16] = 1'b0;
assign cache_wishbone.SEL[15:2] = 1'b0;

logic mem_read;
logic mem_write;

assign cache_wishbone.CYC = mem_read | mem_write;
assign cache_wishbone.STB = cache_wishbone.CYC;
assign cache_wishbone.WE  = mem_write;

/* datapath <-> control interconnect */
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
    .clk(cache_wishbone.CLK),

    /* cpu_datapath->cpu_control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable,

    /* cpu_datapath->memory (hijack) */
    .mem_address(cache_wishbone.ADR),

    /* memory->cpu_control */
    .mem_resp(cache_wishbone.ACK),

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
    .mem_byte_enable(cache_wishbone.SEL[1:0])
);

cpu_datapath _cpu_datapath
(
    /* INPUTS */
    .clk(cache_wishbone.CLK),

    /* memory->cpu_datapath */
    .mem_rdata(cache_wishbone.DAT_S[15:0]),

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
    .mem_address(cache_wishbone.ADR),
    .mem_wdata(cache_wishbone.DAT_M[15:0]),

    /* cpu_datapath->cpu_control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable
);

endmodule : cpu
