import lc3b_types::*;

// TODO: add paramaters for width and num lines
module cache_way (
    /* INPUTS */
    input clk,
    input load,
    input load_type,
    input [15:0] byte_sel,
    input lc3b_cache_tag tag_in,
    input lc3b_cache_index index,
    input lc3b_cache_word data_in,

    /* OUTPUTS */
    output lc3b_cache_tag tag_out,
    output lc3b_cache_word data_out,
    output dirty_out,
    output hit_out
);

/* load_type
 *  0: from cpu
 *  1: from memory
 */

lc3b_cache_word _data  [7:0];
lc3b_cache_tag  _tag   [7:0];
logic           _dirty [7:0];
logic           _valid [7:0];

assign data_out  = _data[index];
assign tag_out   = _tag[index];
assign dirty_out = _dirty[index];
assign hit_out   = _valid[index] && (tag_out == tag_in);

initial begin
    for (int i = 0; i < 8; i++) begin
        _data[i]  = 0;
        _tag[i]   = 0;
        _dirty[i] = 0;
        _valid[i] = 0;
    end
end

always_ff @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 16; i++) begin
            if (byte_sel[i]) begin
                _data[index][i*8 +: 8] = data_in[i*8 +: 8];
            end
        end

        _valid[index] = 1;
        _tag[index]   = tag_in;
        _dirty[index] = ~load_type;
    end
end

endmodule : cache_way
