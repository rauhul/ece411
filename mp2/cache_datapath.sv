import lc3b_types::*;

module cache_datapath (
    /* INPUTS */
    /* global->cpu_control */
    input clk,

    /* cache_control->cache_datapath */
    input cacheline_sel,
    input tag_source_sel,
    input load,
    input load_all,
    input load_lru,
    input lru_in,

    /* CPU->cache_datapath */
    input lc3b_word cpu_address,
    input lc3b_word cpu_wdata,
    input lc3b_mem_wmask byte_enable,

    /* memory->cache_datapath */
    input lc3b_cacheline_word mem_rdata,

    /* OUTPUTS */
    /* cache_datapath->cache_control */
    output hit_0,
    output hit_1,
    output hit_any,
    output dirty_out,
    output lru_out

    /* cache_datapath->CPU */
    output lc3b_word cpu_rdata,

    /* cache_datapath->memory */
    output lc3b_word mem_address,
    output lc3b_cacheline_word mem_wdata,

);

assign tag_in = cpu_address[15:4];
assign offset = cpu_address[3:1];

/*
 * LRU
 */
register #(.width(1)) lru
(
    .clk,
    .load(load_lru),
    .in(lru_in),
    .out(lru_out)
);

/*
 * MUXES
 */
lc3b_cacheline_tag tag_source_mux_out;
assign mem_address = {tag_source_mux_out, 4'b0};
mux2 #(.width(12)) tag_source_mux
(
    .sel(tag_source_sel),
    .a(tag_mux_out),
    .b(tag_in),
    .f(tag_source_mux)
);


lc3b_cacheline_tag tag_out_0;
lc3b_cacheline_tag tag_out_1;
lc3b_cacheline_tag tag_mux_out;
mux2 #(.width(12)) tag_mux
(
    .sel(cacheline_sel),
    .a(tag_out_0),
    .b(tag_out_1),
    .f(tag_mux_out)
);


lc3b_word data_out_0;
lc3b_word data_out_1;
mux2 data_mux
(
    .sel(cacheline_sel),
    .a(data_out_0),
    .b(data_out_1),
    .f(cpu_rdata)
);


lc3b_cacheline_word data_all_out_0;
lc3b_cacheline_word data_all_out_1;
mux2 #(.width(128)) data_all_mux
(
    .sel(cacheline_sel),
    .a(tag_out_0),
    .b(tag_out_1),
    .f(mem_wdata)
);


logic dirty_out_0;
logic dirty_out_1;
mux2 #(.width(1)) dirty_mux
(
    .sel(lru_out),
    .a(dirty_out_0),
    .b(dirty_out_1),
    .f(dirty_out)
);


/*
 * DEMUXES
 */

demux2 #(.width(1)) load_demux
(
    .sel(cacheline_sel),
    .f(load),
    .a(load_out_0),
    .b(load_out_1),
);

demux2 #(.width(1)) load_all_demux
(
    .sel(cacheline_sel),
    .f(load_all),
    .a(load_all_out_0),
    .b(load_all_out_1),
);

/*
 * LINES
 */

assign hit_any = hit_0 | hit_1;

cacheline_128 line0
(
    .clk,

    /* Inputs */
    .load(load_out_0),
    .load_all(load_all_out_0),

    .tag_in,
    .offset,

    .byte_enable,
    .data_in(cpu_wdata),
    .data_all_in(mem_rdata),

    /* Outputs */
    .hit(hit_0),
    .dirty_out(dirty_out_0),
    .tag_out(tag_out_0),
    .data_out(data_out_0),
    .data_all_out(data_all_out_0)
);

cacheline_128 line1
(
    .clk,

    /* Inputs */
    .load(load_out_1),
    .load_all(load_all_out_1),

    .tag_in,
    .offset,

    .byte_enable,
    .data_in(cpu_wdata),
    .data_all_in(mem_rdata),

    /* Outputs */
    .hit(hit_1),
    .dirty_out(dirty_out_1),
    .tag_out(tag_out_1),
    .data_out(data_out_1),
    .data_all_out(data_all_out_1)
);


endmodule : cache_datapath