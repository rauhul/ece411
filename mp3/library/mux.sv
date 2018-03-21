module mux #(
    parameter NUM_INPUTS = 2, // Min 2
    parameter WIDTH      = 16 // Min 1
) (
    /* INPUTS */
    input logic [$clog2(NUM_INPUTS)-1:0] sel,
    input logic [NUM_INPUTS-1:0] [WIDTH-1:0] in,

    /* OUTPUTS */
    output logic [WIDTH-1:0] out
);

assign out = in[sel];

endmodule : mux
