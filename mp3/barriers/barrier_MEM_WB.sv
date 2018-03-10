module barrier_MEM_WB (
    /* INPUTS */
    input clk,
    input lc3b_cc cc_in,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word mdr_in,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,

    /* OUTPUTS */
    output lc3b_cc cc_out,
    output lc3b_control_word control_out,
    output lc3b_word alu_out,
    output lc3b_word ir_out,
    output lc3b_word mdr_out,
    output lc3b_word pc_out,
    output lc3b_word pcn_out
);

lc3b_cc cc;
lc3b_control_word control;
lc3b_word alu;
lc3b_word ir;
lc3b_word mdr;
lc3b_word pc;
lc3b_word pcn;

/* INITIAL */
initial begin
    cc      = 0;
    control = 0;
    alu     = 0;
    ir      = 0;
    mdr     = 0;
    pc      = 0;
    pcn     = 0;
end

/* CLOCK */
always_ff @(posedge clk) begin
    cc      = cc_in;
    control = control_in;
    alu     = alu_in;
    ir      = ir_in;
    mdr     = mdr_in;
    pc      = pc_in;
    pcn     = pcn_in;
end

/* ALWAYS */
assign cc_out      = cc;
assign control_out = control;
assign alu_out     = alu;
assign ir_out      = ir;
assign mdr_out     = mdr;
assign pc_out      = pc;
assign pcn_out     = pcn;

endmodule : barrier_MEM_WB
