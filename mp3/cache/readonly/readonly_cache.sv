module readonly_cache #(
    parameter NUM_LINES = 8,    // Min 2, must be power of 2
    parameter ASSOCIATIVITY = 2 // Min 2, must be power of 2
) (
    /* SLAVES */
    wishbone.slave input_wishbone,

    /* MASTERS */
    wishbone.master output_wishbone,

    /* debug */
    output logic debug_cache_hit,
    output logic debug_cache_miss
);

logic clk;
assign clk = input_wishbone.CLK;

/* set <-> set_controller */
logic [$clog2(ASSOCIATIVITY)-1:0] cache_way_sel;
logic input_data_source_sel;
logic load;
logic load_lru;
logic input_wishbone_DAT_S_x;

logic [ASSOCIATIVITY-1:0] hit;
logic [$clog2(ASSOCIATIVITY)-1:0] lru;

/* modules */
readonly_cache_datapath #(
    NUM_LINES,
    ASSOCIATIVITY
) _cache_datapath (
    /* INPUTS */
    .clk,

    /* controller->datapath */
    .cache_way_sel,
    .input_data_source_sel,
    .load,
    .load_lru,
    .input_wishbone_DAT_S_x,

    /* input_wishbone->cache */
    .input_wishbone_ADR(input_wishbone.ADR),
    .input_wishbone_SEL(input_wishbone.SEL),

    /* output_wishbone->cache */
    .output_wishbone_DAT_S(output_wishbone.DAT_S),

    /* OUTPUTS */
    /* datapath->controller */
    .hit,
    .lru,

    /* cache_datapath->CPU */
    .input_wishbone_DAT_S(input_wishbone.DAT_S),

    /* cache_datapath->memory */
    .output_wishbone_ADR(output_wishbone.ADR),
    .output_wishbone_SEL(output_wishbone.SEL),
    .output_wishbone_DAT_M(output_wishbone.DAT_M)
);

readonly_cache_controller #(
    ASSOCIATIVITY
) _cache_controller (
    /* INPUTS */
    .clk,

    /* datapath->controller */
    .hit,
    .lru,

    /* input_wishbone->cache */
    .input_wishbone_CYC(input_wishbone.CYC),
    .input_wishbone_STB(input_wishbone.STB),

    /* output_wishbone->cache */
    .output_wishbone_ACK(output_wishbone.ACK),
    .output_wishbone_RTY(output_wishbone.RTY),

    /* OUTPUTS */
    /* controller->datapath */
    .cache_way_sel,
    .input_data_source_sel,
    .load,
    .load_lru,
    .input_wishbone_DAT_S_x,

    /* cache->input_wishbone */
    .input_wishbone_ACK(input_wishbone.ACK),
    .input_wishbone_RTY(input_wishbone.RTY),

    /* cache->output_wishbone */
    .output_wishbone_CYC(output_wishbone.CYC),
    .output_wishbone_STB(output_wishbone.STB),
    .output_wishbone_WE(output_wishbone.WE),

    /* debug */
    .debug_cache_hit,
    .debug_cache_miss
);

endmodule : readonly_cache
