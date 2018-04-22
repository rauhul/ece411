import lc3b_types::*;

module pattern_history_table #(
    parameter PATTERN_HISTORY_TABLE_SIZE = 2
) (
    /* INPUTS */
    input logic clk,
    input logic stall,

    input logic[$clog2(PATTERN_HISTORY_TABLE_SIZE)-1:0] index,

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

genvar i;
for (i = 0; i < PATTERN_HISTORY_TABLE_SIZE; i++) begin
    initial begin
        int j = i % 4;

        if (j == 0)
            _branch_predictor_2bit[i].state = s_taken_2;
        else if (j == 1)
            _branch_predictor_2bit[i].state = s_taken;
        else if (j == 2)
            _branch_predictor_2bit[i].state = s_ntaken;
        else
            _branch_predictor_2bit[i].state = s_ntaken_2;

        $display("initial: %0d", _branch_predictor_2bit[i].state);
    end
end

endmodule : pattern_history_table

