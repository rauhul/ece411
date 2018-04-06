import lc3b_types::*;

module barrier_EX_MEM (
    /* INPUTS */
    input clk,
    input reset,
    input stall,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,
    input lc3b_word sr2_in,
    input logic valid_in,

    /* OUTPUTS */
    output lc3b_control_word control_out,
    output lc3b_word alu_out,
    output lc3b_word ir_out,
    output lc3b_word pc_out,
    output lc3b_word pcn_out,
    output lc3b_word sr2_out,
    output logic valid_out
);

lc3b_control_word control;
lc3b_word alu;
lc3b_word ir;
lc3b_word pc;
lc3b_word pcn;
lc3b_word sr2;
logic valid;

/* INITIAL */
initial begin
    control = 0;
    alu     = 0;
    ir      = 0;
    pc      = 0;
    pcn     = 0;
    sr2     = 0;
    valid   = 0;
end

/* FF */
always_ff @(posedge clk) begin
    if (~stall) begin
        if (reset) begin
            control = 0;
            alu     = 0;
            ir      = 0;
            pc      = 0;
            pcn     = 0;
            sr2     = 0;
            valid   = 0;
        end else begin
            control = control_in;
            alu     = alu_in;
            ir      = ir_in;
            pc      = pc_in;
            pcn     = pcn_in;
            sr2     = sr2_in;
            valid   = valid_in;
        end
    end
end

/* COMB */
assign control_out = control;
assign alu_out     = alu;
assign ir_out      = ir;
assign pc_out      = pc;
assign pcn_out     = pcn;
assign sr2_out     = sr2;
assign valid_out   = valid;

endmodule : barrier_EX_MEM
