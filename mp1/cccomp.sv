import lc3b_types::*;

module cccomp
(
    input lc3b_nzp a,
    input lc3b_nzp b,
    output f
);

lc3b_nzp data;
assign data = a & b;
assign f = |data;

endmodule : cccomp