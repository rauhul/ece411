module cache (
    /* CPU <-> Cache */
    wishbone.slave cache_wishbone,

    /* Cache <-> Memory */
    wishbone.master memory_wishbone
);

/* cache_wishbone */
assign cache_wishbone.DAT_S[127:16] = 1'b0;
assign cache_wishbone.RTY = 1'b0;

logic cpu_req;
logic cpu_read;
logic cpu_write;

assign cpu_req = cache_wishbone.STB & cache_wishbone.CYC;
assign cpu_read = cpu_req & (~cache_wishbone.WE);
assign cpu_write = cpu_req & cache_wishbone.WE;


/* memory_wishbone */
assign memory_wishbone.SEL = 16'hFFFF;

logic mem_read;
logic mem_write;

assign memory_wishbone.CYC = mem_read | mem_write;
assign memory_wishbone.STB = memory_wishbone.CYC;
assign memory_wishbone.WE  = mem_write;


/* datapath <-> control interconnect */
logic cacheline_sel;
logic tag_source_sel;
logic load;
logic load_all;
logic load_lru;
logic lru_in;

logic hit_0;
logic hit_1;
logic hit_any;
logic dirty_out;
logic lru_out;


/* modules */
cache_datapath _cache_datapath (
    /* INPUTS */
    /* global->cpu_control */
    .clk(cache_wishbone.CLK),

    /* cache_control->cache_datapath */
    .cacheline_sel,
    .tag_source_sel,
    .load,
    .load_all,
    .load_lru,
    .lru_in,

    /* CPU->cache_datapath */
    .cpu_address(cache_wishbone.ADR),
    .cpu_wdata(cache_wishbone.DAT_M[15:0]),
    .byte_enable(cache_wishbone.SEL[1:0]),

    /* memory->cache_datapath */
    .mem_rdata(memory_wishbone.DAT_S),

    /* OUTPUTS */
    /* cache_datapath->cache_control */
    .hit_0,
    .hit_1,
    .hit_any,
    .dirty_out,
    .lru_out,

    /* cache_datapath->CPU */
    .cpu_rdata(cache_wishbone.DAT_S[15:0]),

    /* cache_datapath->memory */
    .mem_address(memory_wishbone.ADR),
    .mem_wdata(memory_wishbone.DAT_M)
);

cache_control _cache_control (
    /* INPUTS */
    /* global->cpu_control */
    .clk(cache_wishbone.CLK),

    /* cache_datapath->cache_control */
    .hit_0,
    .hit_1,
    .hit_any,
    .dirty_out,
    .lru_out,

    /* CPU->cache_control */
    .cpu_read,
    .cpu_write,

    /* memory->cache_control */
    .mem_resp(memory_wishbone.ACK),

    /* OUTPUTS */
    /* cache_control->cache_datapath */
    .cacheline_sel,
    .tag_source_sel,
    .load,
    .load_all,
    .load_lru,
    .lru_in,

    /* cache_control->CPU */
    .cpu_resp(cache_wishbone.ACK),

    /* cache_control->memory */
    .mem_read,
    .mem_write
);

endmodule