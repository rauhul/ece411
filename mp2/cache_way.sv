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
    output dirty,
    output hit
);

/* load_type
 *  0: from cpu
 *  1: from memory
 */

lc3b_cache_word data  [7:0];
lc3b_cache_tag  tag   [7:0];
logic           dirty [7:0];
logic           valid [7:0];

assign data_out = data[index];
assign tag_out  = tag[index];
assign dirty    = dirty[index];
assign hit      = valid[index] && (tag_out == tag_in);

initial begin
    for (int i = 0; i < 8; i++) begin
        data[i] = 0;
        tag[i] = 0;
        dirty[i] = 0;
        valid[i] = 0;
    end
end

always_ff @(posedge clk) begin
    if (load) begin
        if (byte_sel[0])
            data[index][7:0] = data_in[7:0];

        if (byte_sel[1])
            data[index][15:8] = data_in[15:8];

        if (byte_sel[2])
            data[index][23:16] = data_in[23:16];

        if (byte_sel[3])
            data[index][31:24] = data_in[31:24];

        if (byte_sel[4])
            data[index][39:32] = data_in[39:32];

        if (byte_sel[5])
            data[index][47:40] = data_in[47:40];

        if (byte_sel[6])
            data[index][55:48] = data_in[55:48];

        if (byte_sel[7])
            data[index][63:56] = data_in[63:56];

        if (byte_sel[8])
            data[index][71:64] = data_in[71:64];

        if (byte_sel[9])
            data[index][79:72] = data_in[79:72];

        if (byte_sel[10])
            data[index][87:80] = data_in[87:80];

        if (byte_sel[11])
            data[index][95:88] = data_in[95:88];

        if (byte_sel[12])
            data[index][103:96] = data_in[103:96];

        if (byte_sel[13])
            data[index][111:104] = data_in[111:104];

        if (byte_sel[14])
            data[index][119:112] = data_in[119:112];

        if (byte_sel[15])
            data[index][127:120] = data_in[127:120];

        valid[index] = 1;
        tag[index] = tag_in;
        dirty[index] = ~load_type;
    end
end

endmodule : cache_way
