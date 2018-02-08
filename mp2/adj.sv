import lc3b_types::*;

/*
 * SEXT[offset-n << 1]
 */
module adj #(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out
);

assign out = $signed({in, 1'b0});

endmodule : adj
