import lc3b_types::*;

module cccomp
(
    input lc3b_cc a,
    input lc3b_cc b,
    output f
);

lc3b_cc data;
assign data = a & b;
assign f = |data;

endmodule : cccomp