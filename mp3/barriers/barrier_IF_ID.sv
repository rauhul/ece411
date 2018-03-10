module barrier_IF_ID (
    /* INPUTS */
    input clk,
    input lc3b_word pc_in,
    input lc3b_word ir_in,

    /* OUTPUTS */
    output lc3b_word pc_out,
    output lc3b_word ir_out
);

lc3b_word pc;
lc3b_word ir;

/* INITIAL */
initial begin
    pc = 16'b0;
    ir = 16'b0;
end

/* CLOCK */
always_ff @(posedge clk) begin
    pc = pc_in;
    ir = ir_in;
end

/* ALWAYS */
assign pc_out = pc;
assign ir_out = ir;

endmodule: barrier_IF_ID