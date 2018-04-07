import lc3b_types::*;

module regfile (
    /* INPUTS */
    input clk,
    input load,
    input stall,
    input lc3b_word in,
    input lc3b_reg sr1,
    input lc3b_reg sr2,
    input lc3b_reg dest,

    /* OUTPUTS */
    output lc3b_word sr1_out,
    output lc3b_word sr2_out
);

lc3b_word data [7:0];

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial begin
    for (int i = 0; i < $size(data); i++)
        data[i] = 16'b0;
end

always_ff @(posedge clk) begin
    if (load & ~stall) begin
        data[dest] = in;
    end
end

always_comb begin
    sr1_out = data[sr1];
    sr2_out = data[sr2];
end

endmodule : regfile
