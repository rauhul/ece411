import lc3b_types::*;

module branch_predictor #(
    parameter BRANCH_HISTORY_REGISTER_SIZE = 4
) (
    /* INPUTS */
    input logic clk,
    input logic stall,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic prediction
);

localparam integer PATTERN_HISTORY_TABLE_SIZE = 2**BRANCH_HISTORY_REGISTER_SIZE;

logic [BRANCH_HISTORY_REGISTER_SIZE-1:0] branch_history_register;
logic [PATTERN_HISTORY_TABLE_SIZE-1:0] pattern_history_table_update;
logic [PATTERN_HISTORY_TABLE_SIZE-1:0] pattern_history_table_prediction;

demux #(
    PATTERN_HISTORY_TABLE_SIZE,
    1
) update_demux (
    /* INPUTS */
    .sel(branch_history_register),
    .in(update),

    /* OUTPUTS */
    .out(pattern_history_table_update)
);

branch_predictor_2bit #(
    NUM_LINES
) pattern_history_table[PATTERN_HISTORY_TABLE_SIZE-1:0] (
    /* INPUTS */
    .clk,
    .stall,
    .update(pattern_history_table_update),
    .update_value,

    /* OUTPUTS */
    .prediction(pattern_history_table_prediction)
);

mux #(
    PATTERN_HISTORY_TABLE_SIZE,
    1
) prediction_mux (
    /* INPUTS */
    .sel(branch_history_register),
    .in(pattern_history_table_prediction),

    /* OUTPUTS */
    .out(prediction)
);

initial begin
    branch_history_register = 0;
end

always_ff @(posedge clk or negedge rst_n) begin
    if (update && ~stall) begin
        branch_history_register = {branch_history_register[BRANCH_HISTORY_REGISTER_SIZE-2:0], update_value};
    end
end

endmodule : branch_predictor
