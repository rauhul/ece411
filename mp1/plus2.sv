module plus2 #(parameter width = 16)
(
    input [width-1:0] in,
    output logic [width-1:0] out
);

assign out = in + 4'h1;

endmodule : plus2
