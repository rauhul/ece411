import lc3b_types::*;

module barrier_IF_ID (
    /* INPUTS */
    input clk,
    input reset,
    input stall,
    input lc3b_word ir_in,
    input lc3b_word pc_in,

    /* OUTPUTS */
    output lc3b_word ir_out,
    output lc3b_word pc_out,
    output logic valid_out
);

`define instruction_is_not_NOP(instruction) \
(|instruction)

lc3b_word ir;
lc3b_word pc;
logic valid;

/* INITIAL */
initial begin
    ir    = 0;
    pc    = 0;
    valid = 0;
end

/* FF */
always_ff @(posedge clk) begin
    if (~stall) begin
        if (reset) begin
            ir    = 0;
            pc    = 0;
            valid = 0;
        end else begin
            ir    = ir_in;
            pc    = pc_in;
            valid = `instruction_is_not_NOP(ir_in);
        end
    end
end

/* COMB */
assign ir_out    = ir;
assign pc_out    = pc;
assign valid_out = valid;

endmodule : barrier_IF_ID
