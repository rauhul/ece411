module cache (
    /* CPU <-> Cache */
    wishbone.slave cpu_wishbone,

    /* Cache <-> Memory */
    wishbone.master memory_wishbone
);

/* cpu_wishbone */
logic cpu_request;
assign cpu_request = cpu_wishbone.CYC & cpu_wishbone.STB;
assign cpu_wishbone.RTY = 1'b0;

/* memory_wishbone */
logic memory_request;
assign memory_wishbone.CYC = memory_request;
assign memory_wishbone.STB = memory_request;

/* datapath <-> control interconnect */
logic cache_way_sel,
logic data_source_sel,
logic tag_bypass_sel,
logic load;
logic load_type;
logic load_lru;

logic hit_0;
logic hit_1;
logic dirty;
logic lru;

/* modules */
cache_datapath _cache_datapath
(
    /* INPUTS */
    /* global->cpu_control */
    .clk(cpu_wishbone.CLK),

    /* cache_control->cache_datapath */
    .cache_way_sel,
    .data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_type,
    .load_lru,

    /* CPU->cache_datapath */
    .cpu_address(cpu_wishbone.ADR),
    .cpu_byte_sel(cpu_wishbone.SEL),
    .cpu_data(cpu_wishbone.DAT_M),

    /* memory->cache_datapath */
    .memory_data_in(memory_wishbone.DAT_S),

    /* OUTPUTS */
    /* cache_datapath->cache_control */
    .hit_0,
    .hit_1,
    .dirty,
    .lru,

    /* cache_datapath->CPU */
    .cpu_data_out(cpu_wishbone.DAT_S),

    /* cache_datapath->memory */
    .memory_address(memory_wishbone.ADR),
    .memory_byte_sel(memory_wishbone.SEL),
    .memory_data_out(memory_wishbone.DAT_M)
);

cache_control _cache_control
(
    /* INPUTS */
    /* global->cpu_control */
    .clk(cpu_wishbone.CLK),

    /* cache_datapath->cache_control */
    .hit_0,
    .hit_1,
    .dirty,
    .lru,

    /* CPU->cache_control */
    .cpu_request,
    .cpu_read_write(cpu_wishbone.WE),

    /* memory->cache_control */
    .memory_response(memory_wishbone.ACK),

    /* OUTPUTS */
    /* cache_control->cache_datapath */
    .cache_way_sel,
    .data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_type,
    .load_lru,

    /* cache_control->CPU */
    .cpu_response(cpu_wishbone.ACK),

    /* cache_control->memory */
    .memory_request,
    .memory_read_write(memory_wishbone.WE)
);

endmodule : cache
