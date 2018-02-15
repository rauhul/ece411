import lc3b_types::*;

module register_bank
(
    /* Inputs */
    input clk,
    input load,
    input load_all,
    input lc3b_mem_wmask byte_enable,
    input lc3b_cacheline_offset offset,
    input lc3b_word data_in,
    input lc3b_cacheline_word data_all_in,

    /* Outputs */
    output lc3b_word data_out
    output lc3b_cacheline_word data_all_out
);

assign data_in_high = data_in[15:8];
assign data_in_low  = data_in[7:0];

assign data_out = data[offset*16 +: 16;
assign data_all_out = data;

lc3b_cacheline_word data;

initial begin
    data = 1'b0;
end

always_ff @(posedge clk) begin
    if (load_all) begin
        data = data_all_in;
    end else if (load) begin
        if (byte_enable[1])
            data[offset*16+8 +: 8] = data_in_high;
        if (byte_enable[0])
            data[offset*16+0 +: 8] = data_in_low;
    end
end

endmodule : register
