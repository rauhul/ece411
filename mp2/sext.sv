import lc3b_types::*;

/*
 * SEXT[offset-n]
 */
module sext #(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out
);

assign out = $signed(in);

endmodule : sext
