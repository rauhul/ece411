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
logic [PATTERN_HISTORY_TABLE_SIZE-1:0] pattern_history_fsm_update;
logic [PATTERN_HISTORY_TABLE_SIZE-1:0] pattern_history_fsm_prediction;

/** MODULES **/
demux #(
    PATTERN_HISTORY_TABLE_SIZE,
    1
) update_demux (
    /* INPUTS */
    .sel(index),
    .in(update),

    /* OUTPUTS */
    .out(pattern_history_fsm_update)
);

pattern_history_fsm _pattern_history_fsm[PATTERN_HISTORY_TABLE_SIZE-1:0] (
    /* INPUTS */
    .clk,
    .stall,
    .update(pattern_history_fsm_update),
    .update_value,

    /* OUTPUTS */
    .prediction(pattern_history_fsm_prediction)
);

mux #(
    PATTERN_HISTORY_TABLE_SIZE,
    1
) prediction_mux (
    /* INPUTS */
    .sel(index),
    .in(pattern_history_fsm_prediction),

    /* OUTPUTS */
    .out(prediction)
);

/* generate
    genvar i;
    for (i = 0; i < PATTERN_HISTORY_TABLE_SIZE; i++) begin : gen_initial_state_assignment
        initial begin
            int j = i % 4;

            if (j == 0)
                _pattern_history_fsm[i].state = s_taken_2;
            else if (j == 1)
                _pattern_history_fsm[i].state = s_taken;
            else if (j == 2)
                _pattern_history_fsm[i].state = s_ntaken;
            else
                _pattern_history_fsm[i].state = s_ntaken_2;
        end
    end
endgenerate */

endmodule : pattern_history_table
