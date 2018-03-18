module barrier_wishbone_slave (
    /* INPUTS */
    input clk,

    input logic [127:0] DAT_S_in,
    input logic ACK_in,
    input logic RTY_in,

    /* OUTPUTS */
    output logic [127:0] DAT_S_out,
    output logic ACK_out,
    output logic RTY_out
);

logic [127:0] DAT_S;
logic ACK;
logic RTY;

initial begin
    DAT_S = 0;
    ACK = 0;
    RTY = 0;
end

always_ff @(posedge clk) begin
    DAT_S = DAT_S_in;
    ACK = ACK_in;
    RTY = RTY_in;
end

assign DAT_S_out = DAT_S;
assign ACK_out = ACK;
assign RTY_out = RTY;

endmodule : barrier_wishbone_slave
