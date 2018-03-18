// TODO: add parameter associativity
module cache_l1 (
    /* SLAVES */
    wishbone.slave input_wishbone,

    /* MASTERS */
    wishbone.master output_wishbone
);

logic clk;
assign clk = input_wishbone.CLK;

/* set <-> set_controller */
logic cache_way_sel;
logic data_source_sel;
logic tag_bypass_sel;
logic load;
logic load_lru;

logic hit_0;
logic hit_1;
logic dirty;
logic lru;

/* modules */
cache_l1_datapath _cache_l1_datapath (
    /* INPUTS */
    .clk,

    /* controller->datapath */
    .cache_way_sel,
    .data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_lru,

    /* input_wishbone->cache */
    .input_wishbone_ADR(input_wishbone.ADR),
    .input_wishbone_SEL(input_wishbone.SEL),
    .input_wishbone_DAT_M(input_wishbone.DAT_M),

    /* output_wishbone->cache */
    .output_wishbone_DAT_S(output_wishbone.DAT_S),

    /* OUTPUTS */
    /* datapath->controller */
    .hit_0,
    .hit_1,
    .dirty,
    .lru,

    /* cache_datapath->CPU */
    .input_wishbone_DAT_S(input_wishbone.DAT_S),

    /* cache_datapath->memory */
    .output_wishbone_ADR(output_wishbone.ADR),
    .output_wishbone_SEL(output_wishbone.SEL),
    .output_wishbone_DAT_M(output_wishbone.DAT_M)
);

cache_l1_controller _cache_l1_controller (
    /* INPUTS */
    .clk,

    /* datapath->controller */
    .hit_0,
    .hit_1,
    .dirty,
    .lru,

    /* input_wishbone->cache */
    .input_wishbone_CYC(input_wishbone.CYC),
    .input_wishbone_STB(input_wishbone.STB),
    .input_wishbone_WE(input_wishbone.WE),

    /* output_wishbone->cache */
    .output_wishbone_ACK(output_wishbone.ACK),
    .output_wishbone_RTY(output_wishbone.RTY),

    /* OUTPUTS */
    /* controller->datapath */
    .cache_way_sel,
    .data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_lru,

    /* cache->input_wishbone */
    .input_wishbone_ACK(input_wishbone.ACK),
    .input_wishbone_RTY(input_wishbone.RTY),

    /* cache->output_wishbone */
    .output_wishbone_CYC(output_wishbone.CYC),
    .output_wishbone_STB(output_wishbone.STB),
    .output_wishbone_WE(output_wishbone.WE)
);


endmodule : cache_l1
