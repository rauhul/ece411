import lc3b_types::*;

module barrier_IF_ID (
    /* INPUTS */
    input clk,
    input lc3b_word ir_in,
    input lc3b_word pc_in,

    /* OUTPUTS */
    output lc3b_word ir_out,
    output lc3b_word pc_out
);

lc3b_word ir;
lc3b_word pc;

/* INITIAL */
initial begin
    ir = 0;
    pc = 0;
end

/* FF */
always_ff @(posedge clk) begin
    ir = ir_in;
    pc = pc_in;
end

/* COMB */
assign ir_out = ir;
assign pc_out = pc;

endmodule : barrier_IF_ID
