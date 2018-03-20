module mux #(
    parameter WIDTH = 16,     // Min 1
    parameter NUM_INPUTS = 2  // Min 2
) (
    /* INPUTS */
    input logic [NUM_INPUTS-1:0] [WIDTH-1:0] a,
    input logic [clogb2(NUM_INPUTS)-1:0] sel,

    /* OUTPUTS */
    output logic [WIDTH -1:0] y
);

assign y = a >> (sel * WIDTH);

endmodule : mux
