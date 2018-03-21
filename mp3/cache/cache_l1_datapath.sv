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
// data
logic [127:0] data_in_mux_out;
logic [1:0] [127:0] data_in_mux_in;
assign data_in_mux_in[0] = input_wishbone_DAT_M;
assign data_in_mux_in[1] = output_wishbone_DAT_S;
mux #(2, 128) data_in_mux (
    /* INPUTS */
    .sel(data_source_sel),
    .in(data_in_mux_in),

    /* OUTPUTS */
    .out(data_in_mux_out)
);

// sel
assign output_wishbone_SEL = 16'hFFFF;

logic [15:0] byte_sel_mux_out;
logic [1:0] [15:0] byte_sel_mux_in;
assign byte_sel_mux_in[0] = input_wishbone_SEL;
assign byte_sel_mux_in[1] = output_wishbone_SEL;
mux #(2, 16) byte_sel_mux (
    /* INPUTS */
    .sel(data_source_sel),
    .in(byte_sel_mux_in),

    /* OUTPUTS */
    .out(byte_sel_mux_out)
);

// tag
lc3b_cache_tag tag_in;
assign tag_in = input_wishbone_ADR[11:3];

// index
lc3b_cache_index index;
assign index = input_wishbone_ADR[2:0];


/* output muxes */
// data
lc3b_cache_word data_0;
lc3b_cache_word data_1;

lc3b_cache_word data_out_mux_out;
logic [1:0] [127:0] data_out_mux_in;
assign data_out_mux_in[0] = data_0;
assign data_out_mux_in[1] = data_1;
mux #(2, 128) data_out_mux (
    /* INPUTS */
    .sel(cache_way_sel),
    .in(data_out_mux_in),

    /* OUTPUTS */
    .out(data_out_mux_out)
);

assign input_wishbone_DAT_S = data_out_mux_out;
assign output_wishbone_DAT_M = data_out_mux_out;

// tag
lc3b_cache_tag tag_0;
lc3b_cache_tag tag_1;

logic [8:0] tag_mux_out;
logic [1:0] [8:0] tag_mux_in;
assign tag_mux_in[0] = tag_0;
assign tag_mux_in[1] = tag_1;
mux #(2, 9) tag_mux (
    /* INPUTS */
    .sel(cache_way_sel),
    .in(tag_mux_in),

    /* OUTPUTS */
    .out(tag_mux_out)
);

logic [8:0] tag_bypass_mux_out;
logic [1:0] [8:0] tag_bypass_mux_in;
assign tag_bypass_mux_in[0] = tag_mux_out;
assign tag_bypass_mux_in[1] = tag_in;
mux #(2, 9) tag_bypass_mux (
    /* INPUTS */
    .sel(tag_bypass_sel),
    .in(tag_bypass_mux_in),

    /* OUTPUTS */
    .out(tag_bypass_mux_out)
);

assign output_wishbone_ADR = {tag_bypass_mux_out, index};

// dirty
logic dirty_0;
logic dirty_1;

logic dirty_mux_out;
logic [1:0] dirty_mux_in;
assign dirty_mux_in[0] = dirty_0;
assign dirty_mux_in[1] = dirty_1;
mux #(2, 1) dirty_mux (
    /* INPUTS */
    .sel(lru),
    .in(dirty_mux_in),

    /* OUTPUTS */
    .out(dirty_mux_out)
);

assign dirty = dirty_mux_out;

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
    .byte_sel(byte_sel_mux_out),
    .tag_in,
    .index,
    .data_in(data_in_mux_out),

    /* OUTPUTS */
    .tag_out(tag_0),
    .data_out(data_0),
    .dirty_out(dirty_0),
    .hit_out(hit_0)
);

cache_way cache_way_1 (
    /* INPUTS */
    .clk,
    .load(load_1),
    .load_type(data_source_sel),
    .byte_sel(byte_sel_mux_out),
    .tag_in,
    .index,
    .data_in(data_in_mux_out),

    /* OUTPUTS */
    .tag_out(tag_1),
    .data_out(data_1),
    .dirty_out(dirty_1),
    .hit_out(hit_1)
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
