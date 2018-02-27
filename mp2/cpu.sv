import lc3b_types::*;

module cpu
(
    /* CPU <-> Cache */
    wishbone.master memory_wishbone
);

/* memory_wishbone */
logic mem_request;
assign memory_wishbone.CYC = mem_request;
assign memory_wishbone.STB = mem_request;

lc3b_word mem_address;
assign memory_wishbone.ADR = mem_address[15:4];

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
lc3b_mem_wmask mem_byte_mask;

cpu_control _cpu_control
(
    /* INPUTS */
    /* global->cpu_control */
    .clk(memory_wishbone.CLK),

    /* cpu_datapath->cpu_control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable,

    /* cpu_datapath->memory (hijack) */
    .mem_address,

    /* memory->cpu_control */
    .mem_resp(memory_wishbone.ACK),

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
    .mem_byte_mask,

    /* cpu_control->memory */
    .mem_request,
    .mem_read_write(memory_wishbone.WE)
);

cpu_datapath _cpu_datapath
(
    /* INPUTS */
    .clk(memory_wishbone.CLK),

    /* memory->cpu_datapath */
    .mem_data_in(memory_wishbone.DAT_S),

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
    .mem_byte_mask,

    /* OUTPUTS */
    /* cpu_datapath->memory */
    .mem_address,
    .mem_data_out(memory_wishbone.DAT_M),
    .mem_byte_sel(memory_wishbone.SEL),

    /* cpu_datapath->cpu_control */
    .opcode,
    .inst4,
    .inst5,
    .inst11,
    .branch_enable
);

endmodule : cpu
