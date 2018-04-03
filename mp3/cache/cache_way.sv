module cache_way #(
    parameter NUM_LINES = 2, // Min 2, must be power of 2
    parameter WIDTH = 128    // Min 2, must be power of 2
) (
    /* INPUTS */
    input clk,
    input logic load,
    input logic load_type,
    input logic [15:0] byte_sel,
    input logic [12-$clog2(NUM_LINES)-1:0] tag_in,
    input logic [$clog2(NUM_LINES)-1:0] index_in,
    input logic [WIDTH-1:0] data_in,

    /* OUTPUTS */
    output logic [12-$clog2(NUM_LINES)-1:0] tag_out,
    output logic [WIDTH-1:0] data_out,
    output logic dirty_out,
    output logic hit_out
);

localparam integer INDEX_WIDTH = $clog2(NUM_LINES);
localparam integer TAG_WIDTH = 12-INDEX_WIDTH;

/* load_type
 *  0: from cpu
 *  1: from memory
 */

logic [NUM_LINES-1:0] [WIDTH-1:0]     data;
logic [NUM_LINES-1:0] [TAG_WIDTH-1:0] tag;
logic [NUM_LINES-1:0]                 dirty;
logic [NUM_LINES-1:0]                 valid;

assign data_out  =  data[index_in];
assign tag_out   =   tag[index_in];
assign dirty_out = dirty[index_in];
assign hit_out   = valid[index_in] && (tag_out == tag_in);

initial begin
    for (int i = 0; i < NUM_LINES; i++) begin
        data[i]  = 0;
        tag[i]   = 0;
        dirty[i] = 0;
        valid[i] = 0;
    end
end

always_ff @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 16; i++) begin
            if (byte_sel[i]) begin
                data[index_in][i*8 +: 8] = data_in[i*8 +: 8];
            end
        end

        valid[index_in] = 1;
        tag[index_in]   = tag_in;
        dirty[index_in] = ~load_type;
    end
end

endmodule : cache_way
