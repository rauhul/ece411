import lc3b_types::*;

// TODO: add parameter associativity
module cache_l1_datapath (
    /* INPUTS */
    input clk,

    /* controller->datapath */
    input cache_way_sel,
    input data_source_sel,
    input tag_bypass_sel,
    input load,
    input load_lru,

    /* input_wishbone->cache */
    input [11:0] input_wishbone_ADR,
    input [15:0] input_wishbone_SEL,
    input lc3b_cache_word input_wishbone_DAT_M,

    /* output_wishbone->cache */
    input lc3b_cache_word output_wishbone_DAT_S,

    /* OUTPUTS */
    /* datapath->controller */
    output logic hit_0,
    output logic hit_1,
    output logic dirty,
    output logic lru,

    /* cache_datapath->CPU */
    output lc3b_cache_word input_wishbone_DAT_S,

    /* cache_datapath->memory */
    output [11:0] output_wishbone_ADR,
    output [15:0] output_wishbone_SEL,
    output lc3b_cache_word output_wishbone_DAT_M
);

/*
 * MUXES
 */
/* input muxes */
lc3b_cache_word data_in;
mux2 #(.width(128)) data_in_mux
(
    .sel(data_source_sel),
    .a(input_wishbone_DAT_M),
    .b(output_wishbone_DAT_S),
    .f(data_in)
);

assign output_wishbone_SEL = 16'hFFFF;

logic [15:0] byte_sel;
mux2 #(.width(16)) byte_sel_mux
(
    .sel(data_source_sel),
    .a(input_wishbone_SEL),
    .b(output_wishbone_SEL),
    .f(byte_sel)
);

lc3b_cache_tag tag_in;
assign tag_in = input_wishbone_ADR[11:3];

lc3b_cache_index index;
assign index = input_wishbone_ADR[2:0];

/* output muxes */
lc3b_cache_word data_0;
lc3b_cache_word data_1;
lc3b_cache_word data_out;
assign input_wishbone_DAT_S = data_out;
assign output_wishbone_DAT_M = data_out;
mux2 #(.width(128)) data_mux
(
    .sel(cache_way_sel),
    .a(data_0),
    .b(data_1),
    .f(data_out)
);

lc3b_cache_tag tag_0;
lc3b_cache_tag tag_1;
lc3b_cache_tag tag_out;
mux2 #(.width(9)) tag_mux
(
    .sel(cache_way_sel),
    .a(tag_0),
    .b(tag_1),
    .f(tag_out)
);

lc3b_cache_tag tag_bypass_mux_out;
assign output_wishbone_ADR = {tag_bypass_mux_out, index};
mux2 #(.width(9)) tag_bypass_mux
(
    .sel(tag_bypass_sel),
    .a(tag_out),
    .b(tag_in),
    .f(tag_bypass_mux_out)
);

logic dirty_0;
logic dirty_1;
mux2 #(.width(1)) dirty_mux
(
    .sel(lru),
    .a(dirty_0),
    .b(dirty_1),
    .f(dirty)
);

/*
 * DEMUXES
 */
 /* load */
logic load_0;
logic load_1;
demux2 #(.width(1)) load_demux
(
    .sel(cache_way_sel),
    .f(load),
    .a(load_0),
    .b(load_1)
);

/*
 * WAYS
 */
cache_way cache_way_0 (
    /* INPUTS */
    .clk,
    .load(load_0),
    .load_type(data_source_sel),
    .byte_sel,
    .tag_in,
    .index,
    .data_in,

    /* OUTPUTS */
    .tag_out(tag_0),
    .data_out(data_0),
    .dirty(dirty_0),
    .hit(hit_0)
);

cache_way cache_way_1 (
    /* INPUTS */
    .clk,
    .load(load_1),
    .load_type(data_source_sel),
    .byte_sel,
    .tag_in,
    .index,
    .data_in,

    /* OUTPUTS */
    .tag_out(tag_1),
    .data_out(data_1),
    .dirty(dirty_1),
    .hit(hit_1)
);

/* lru */
logic lru_arr [7:0];
assign lru = lru_arr[index];

initial begin
    for (int i = 0; i < 8; i++) begin
        lru_arr[i] = 0;
    end
end

always_ff @(posedge clk) begin
    if (load_lru) begin
        lru_arr[index] = ~cache_way_sel;
    end
end

endmodule : cache_l1_datapath
