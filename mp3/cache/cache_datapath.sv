// TODO: WIDTH not supported yet
module cache_datapath #(
    parameter NUM_LINES = 8,     // Min 2, must be power of 2
    parameter ASSOCIATIVITY = 2, // Min 2, must be power of 2
    parameter WIDTH = 128        // Min 2, must be power of 2
) (
    /* INPUTS */
    input clk,

    /* controller->datapath */
    input logic [$clog2(ASSOCIATIVITY)-1:0] cache_way_sel,
    input logic input_data_source_sel,
    input logic tag_bypass_sel,
    input logic load,
    input logic load_lru,

    /* input_wishbone->cache */
    input logic [11:0] input_wishbone_ADR,
    input logic [15:0] input_wishbone_SEL,
    input logic [WIDTH-1:0] input_wishbone_DAT_M,

    /* output_wishbone->cache */
    input logic [WIDTH-1:0] output_wishbone_DAT_S,

    /* OUTPUTS */
    /* datapath->controller */
    output logic [ASSOCIATIVITY-1:0] hit,
    output logic dirty,
    output logic [$clog2(ASSOCIATIVITY)-1:0] lru,

    /* cache_datapath->CPU */
    output logic [WIDTH-1:0] input_wishbone_DAT_S,

    /* cache_datapath->memory */
    output logic [11:0] output_wishbone_ADR,
    output logic [15:0] output_wishbone_SEL,
    output logic [WIDTH-1:0] output_wishbone_DAT_M
);

localparam integer INDEX_WIDTH = $clog2(NUM_LINES);
localparam integer TAG_WIDTH = 12-INDEX_WIDTH;

/* INPUTS */
/** data **/
logic       [WIDTH-1:0] input_data_mux_out;
logic [1:0] [WIDTH-1:0] input_data_mux_in;
assign input_data_mux_in[0] = input_wishbone_DAT_M;
assign input_data_mux_in[1] = output_wishbone_DAT_S;
mux #(
    2, // num input sources
    WIDTH
) input_data_mux (
    /* INPUTS */
    .sel(input_data_source_sel),
    .in(input_data_mux_in),

    /* OUTPUTS */
    .out(input_data_mux_out)
);

/** sel **/
assign output_wishbone_SEL = 16'hFFFF;

logic       [15:0] input_byte_sel_mux_out;
logic [1:0] [15:0] input_byte_sel_mux_in;
assign input_byte_sel_mux_in[0] = input_wishbone_SEL;
assign input_byte_sel_mux_in[1] = output_wishbone_SEL;
mux #(
    2, // num input sources
    16
) input_byte_sel_mux (
    /* INPUTS */
    .sel(input_data_source_sel),
    .in(input_byte_sel_mux_in),

    /* OUTPUTS */
    .out(input_byte_sel_mux_out)
);

/** tag **/
logic [TAG_WIDTH-1:0] tag_in;
assign tag_in = input_wishbone_ADR[TAG_WIDTH+INDEX_WIDTH-1:INDEX_WIDTH];

/** index **/
logic [INDEX_WIDTH-1:0] index;
assign index = input_wishbone_ADR[INDEX_WIDTH-1:0];

/** load **/
logic [ASSOCIATIVITY-1:0] load_demux_out;
demux #(
    ASSOCIATIVITY,
    1
) load_demux (
    /* INPUTS */
    .sel(cache_way_sel),
    .in(load),

    /* OUTPUTS */
    .out(load_demux_out)
);

/* OUTPUTS */
/** data **/
logic                     [WIDTH-1:0] output_data_mux_out;
logic [ASSOCIATIVITY-1:0] [WIDTH-1:0] output_data_mux_in;
mux #(
    ASSOCIATIVITY,
    WIDTH
) output_data_mux (
    /* INPUTS */
    .sel(cache_way_sel),
    .in(output_data_mux_in),

    /* OUTPUTS */
    .out(output_data_mux_out)
);

assign input_wishbone_DAT_S = output_data_mux_out;
assign output_wishbone_DAT_M = output_data_mux_out;

/** tag **/
logic                     [TAG_WIDTH-1:0] tag_mux_out;
logic [ASSOCIATIVITY-1:0] [TAG_WIDTH-1:0] tag_mux_in;
mux #(
    ASSOCIATIVITY,
    TAG_WIDTH
) tag_mux (
    /* INPUTS */
    .sel(cache_way_sel),
    .in(tag_mux_in),

    /* OUTPUTS */
    .out(tag_mux_out)
);

logic       [TAG_WIDTH-1:0] tag_bypass_mux_out;
logic [1:0] [TAG_WIDTH-1:0] tag_bypass_mux_in;
assign tag_bypass_mux_in[0] = tag_mux_out;
assign tag_bypass_mux_in[1] = tag_in;
mux #(
    2,
    TAG_WIDTH
) tag_bypass_mux (
    /* INPUTS */
    .sel(tag_bypass_sel),
    .in(tag_bypass_mux_in),

    /* OUTPUTS */
    .out(tag_bypass_mux_out)
);

assign output_wishbone_ADR = {tag_bypass_mux_out, index};

/** dirty **/
logic                     dirty_mux_out;
logic [ASSOCIATIVITY-1:0] dirty_mux_in;
mux #(
    ASSOCIATIVITY,
    1
) dirty_mux (
    /* INPUTS */
    .sel(lru),
    .in(dirty_mux_in),

    /* OUTPUTS */
    .out(dirty_mux_out)
);

assign dirty = dirty_mux_out;

/*
 * WAYS
 */
cache_way #(
    NUM_LINES
) _cache_way[ASSOCIATIVITY-1:0] (
    /* INPUTS */
    .clk,
    .load(load_demux_out),
    .load_type(input_data_source_sel),
    .byte_sel(input_byte_sel_mux_out),
    .tag_in,
    .index_in(index),
    .data_in(input_data_mux_out),

    /* OUTPUTS */
    .data_out(output_data_mux_in),
    .tag_out(tag_mux_in),
    .dirty_out(dirty_mux_in),
    .hit_out(hit)
);

/*
 * LRU
 */
cache_lru #(
    NUM_LINES,
    ASSOCIATIVITY
) _cache_lru (
    /* INPUTS */
    .clk,
    .mru_in(cache_way_sel),
    .index_in(index),
    .load_in(load_lru),

    /* OUTPUTS */
    .lru_out(lru)
);

endmodule : cache_datapath
