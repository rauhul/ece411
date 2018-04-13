module eviction_buffer (
    /* INPUTS */
    input clk,
    input logic         load,
    input logic  [11:0] address_in,
    input logic [127:0] evicted_data_in,

    /* OUTPUT */
    output logic  [11:0] address_out,
    output logic [127:0] evicted_data_out
);

logic  [11:0] address;
logic [127:0] evicted_data;

initial begin
    address      = 0;
    evicted_data = 0;
end

always_ff @(posedge clk) begin
    if (load) begin
        address      = address_in;
        evicted_data = evicted_data_in;
    end
end

assign address_out      = address;
assign evicted_data_out = evicted_data;

endmodule : eviction_buffer
