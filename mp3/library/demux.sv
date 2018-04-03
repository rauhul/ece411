module demux #(
    parameter NUM_OUTPUTS = 2, // Min 2
    parameter WIDTH       = 16 // Min 1
) (
    /* INPUTS */
    input logic [$clog2(NUM_OUTPUTS)-1:0] sel,
    input logic [WIDTH-1:0] in,

    /* OUTPUTS */
    output logic [NUM_OUTPUTS-1:0] [WIDTH-1:0] out
);

always_comb begin
    out = 0;
    out[sel] = in;
end

endmodule : demux
