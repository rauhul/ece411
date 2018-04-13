module eviction_buffered_cache #(
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
logic tag_bypass_sel;
logic load;
logic load_lru;

logic [ASSOCIATIVITY-1:0] hit;
logic dirty;
logic [$clog2(ASSOCIATIVITY)-1:0] lru;

logic output_data_source_sel;

/* modules */
logic         eviction_buffer_load;
logic  [11:0] cache_datapath_address;
logic [127:0] cache_datapath_data;
logic  [11:0] eviction_buffer_address;
logic [127:0] eviction_buffer_evicted_data;
eviction_buffer _eviction_buffer (
    /* INPUTS */
    .clk,
    .load(eviction_buffer_load),
    .address_in(cache_datapath_address),
    .evicted_data_in(cache_datapath_data),

    /* OUTPUTS */
    .address_out(eviction_buffer_address),
    .evicted_data_out(eviction_buffer_evicted_data)
);

logic       [127:0] output_wishbone_data_mux_out;
logic [1:0] [127:0] output_wishbone_data_mux_in;
assign output_wishbone_data_mux_in[0] = cache_datapath_data;
assign output_wishbone_data_mux_in[1] = eviction_buffer_evicted_data;
mux #(2, 128) output_wishbone_data_mux (
    /* INPUTS */
    .sel(output_data_source_sel),
    .in(output_wishbone_data_mux_in),

    /* OUTPUTS */
    .out(output_wishbone.DAT_M)
);

logic       [11:0] output_wishbone_address_mux_out;
logic [1:0] [11:0] output_wishbone_address_mux_in;
assign output_wishbone_address_mux_in[0] = cache_datapath_address;
assign output_wishbone_address_mux_in[1] = eviction_buffer_address;
mux #(2, 12) output_wishbone_address_mux (
    /* INPUTS */
    .sel(output_data_source_sel),
    .in(output_wishbone_address_mux_in),

    /* OUTPUTS */
    .out(output_wishbone.ADR)
);

cache_datapath #(
    NUM_LINES,
    ASSOCIATIVITY
) _cache_datapath (
    /* INPUTS */
    .clk,

    /* controller->datapath */
    .cache_way_sel,
    .input_data_source_sel,
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
    .hit,
    .dirty,
    .lru,

    /* cache_datapath->CPU */
    .input_wishbone_DAT_S(input_wishbone.DAT_S),

    /* cache_datapath->memory */
    .output_wishbone_ADR(cache_datapath_address),
    .output_wishbone_SEL(output_wishbone.SEL),
    .output_wishbone_DAT_M(cache_datapath_data)
);

eviction_buffered_cache_controller #(
    ASSOCIATIVITY
) _cache_controller (
    /* INPUTS */
    .clk,

    /* datapath->controller */
    .hit,
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
    .input_data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_lru,

    /* controller->eviction_buffer */
    .eviction_buffer_load,
    .output_data_source_sel,

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

endmodule : eviction_buffered_cache
