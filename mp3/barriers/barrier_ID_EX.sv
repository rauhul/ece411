import lc3b_types::*;

module barrier_ID_EX (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word sr1_in,
    input lc3b_word sr2_in,

    /* OUTPUTS */
    output lc3b_control_word control_out,
    output lc3b_word ir_out,
    output lc3b_word pc_out,
    output lc3b_word sr1_out,
    output lc3b_word sr2_out
);

lc3b_control_word control;
lc3b_word ir;
lc3b_word pc;
lc3b_word sr1;
lc3b_word sr2;

/* INITIAL */
initial begin
    control = 0;
    ir      = 0;
    pc      = 0;
    sr1     = 0;
    sr2     = 0;
end

/* CLOCK */
always_ff @(posedge clk) begin
    control = control_in;
    ir      = ir_in;
    pc      = pc_in;
    sr1     = sr1_in;
    sr2     = sr2_in;
end

/* ALWAYS */
assign control_out = control;
assign ir_out = ir;
assign pc_out = pc;
assign sr1_out = sr1;
assign sr2_out = sr2;

endmodule: barrier_ID_EX
