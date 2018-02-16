import lc3b_types::*;

module cacheline_128 (
    input clk,

    /* Inputs */
    input load,
    input load_all,

    input lc3b_cacheline_tag tag_in,
    input lc3b_cacheline_offset offset,

    input lc3b_mem_wmask byte_enable,
    input lc3b_word data_in,
    input lc3b_cacheline_word data_all_in,

    /* Outputs */
    output hit,
    output dirty_out,
    output lc3b_cacheline_tag tag_out,
    output lc3b_word data_out,
    output lc3b_cacheline_word data_all_out
);


/*
 * TAG
 */

register #(.width(12)) tag
(
    .clk,
    .load(load_all),
    .in(tag_in),
    .out(tag_out)
);


/*
 * VALID
 */

logic valid_out;

register #(.width(1)) valid
(
    .clk,
    .load(load_all),
    .in(1'b1),
    .out(valid_out)
);


/*
 * HIT
 */

assign tag_hit = tag_out == tag_in;
assign hit = tag_hit & valid_out;


/*
 * DIRTY BIT
 */

// LOAD and LOAD all should never be asserted together
assign dirty_bit_load = load | load_all;
assign dirty_bit_load_val = load;

register #(.width(1)) dirty
(
    .clk,
    .load(dirty_bit_load),
    .in(dirty_bit_load_val),
    .out(dirty_out)
);


/*
 * REGISTER BANK
 */

register_bank _register_bank
(
    /* Inputs */
    .clk,
    .load,
    .load_all,
    .byte_enable,
    .offset,
    .data_in,
    .data_all_in,

    /* Outputs */
    .data_out,
    .data_all_out
);

endmodule