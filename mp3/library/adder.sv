import lc3b_types::*;

module adder (
    /* INPUTS */
    input lc3b_word a,
    input lc3b_word b,

    /* OUTPUTS */
    output lc3b_word f
);

assign f = a + b;

endmodule : adder
