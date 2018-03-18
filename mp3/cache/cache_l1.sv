// TODO: add parameter associativity
module cache_l1 (
    /* SLAVES */
    wishbone.slave input_wishbone,

    /* MASTERS */
    wishbone.master output_wishbone
);

/* input_wishbone */
logic cpu_request;
assign cpu_request = input_wishbone.CYC & input_wishbone.STB;
assign input_wishbone.RTY = 1'b0;

/* output_wishbone */
logic memory_request;
assign output_wishbone.CYC = memory_request;
assign output_wishbone.STB = memory_request;

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
cache_set _cache_set (
    /* INPUTS */
    /* global->cpu_control */
    .clk(input_wishbone.CLK),

    /* cache_control->cache_datapath */
    .cache_way_sel,
    .data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_lru,

    /* CPU->cache_datapath */
    .cpu_address(input_wishbone.ADR),
    .cpu_byte_sel(input_wishbone.SEL),
    .cpu_data_in(input_wishbone.DAT_M),

    /* memory->cache_datapath */
    .memory_data_in(output_wishbone.DAT_S),

    /* OUTPUTS */
    /* cache_datapath->cache_control */
    .hit_0,
    .hit_1,
    .dirty,
    .lru,

    /* cache_datapath->CPU */
    .cpu_data_out(input_wishbone.DAT_S),

    /* cache_datapath->memory */
    .memory_address(output_wishbone.ADR),
    .memory_byte_sel(output_wishbone.SEL),
    .memory_data_out(output_wishbone.DAT_M)
);

cache_set_controller _cache_set_controller (
    /* INPUTS */
    /* global->cpu_control */
    .clk(input_wishbone.CLK),

    /* cache_datapath->cache_control */
    .hit_0,
    .hit_1,
    .dirty,
    .lru,

    /* CPU->cache_control */
    .cpu_request,
    .cpu_read_write(input_wishbone.WE),

    /* memory->cache_control */
    .memory_response(output_wishbone.ACK),

    /* OUTPUTS */
    /* cache_control->cache_datapath */
    .cache_way_sel,
    .data_source_sel,
    .tag_bypass_sel,
    .load,
    .load_lru,

    /* cache_control->CPU */
    .cpu_response(input_wishbone.ACK),

    /* cache_control->memory */
    .memory_request,
    .memory_read_write(output_wishbone.WE)
);

endmodule : cache
