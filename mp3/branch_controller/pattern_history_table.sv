module pattern_history_table #(
    parameter PATTERN_HISTORY_TABLE_SIZE = 2
) (
    /* INPUTS */
    input logic clk,
    input logic stall,

    input logic[$clog2(SIZE)-1:0] index,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic prediction
);

/** CONNECTIONS **/
logic [PATTERN_HISTORY_TABLE_SIZE-1:0] branch_predictor_2bit_update;
logic [PATTERN_HISTORY_TABLE_SIZE-1:0] branch_predictor_2bit_prediction;

/** MODULES **/
demux #(
    PATTERN_HISTORY_TABLE_SIZE,
    1
) update_demux (
    /* INPUTS */
    .sel(index),
    .in(update),

    /* OUTPUTS */
    .out(branch_predictor_2bit_update)
);

branch_predictor_2bit _branch_predictor_2bit[PATTERN_HISTORY_TABLE_SIZE-1:0] (
    /* INPUTS */
    .clk,
    .stall,
    .update(branch_predictor_2bit_update),
    .update_value,

    /* OUTPUTS */
    .prediction(branch_predictor_2bit_prediction)
);

mux #(
    PATTERN_HISTORY_TABLE_SIZE,
    1
) prediction_mux (
    /* INPUTS */
    .sel(index),
    .in(branch_predictor_2bit_prediction),

    /* OUTPUTS */
    .out(prediction)
);

endmodule : pattern_history_table
