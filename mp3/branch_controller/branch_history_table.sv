module branch_history_table #(
    parameter BRANCH_HISTORY_REGISTER_SIZE = 4,
    parameter BRANCH_HISTORY_TABLE_SIZE = 4
) (
    input logic clk,
    input logic stall,

    input logic[$clog2(BRANCH_HISTORY_TABLE_SIZE)-1:0] index,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic [BRANCH_HISTORY_REGISTER_SIZE-1:0] history
);

/** CONNECTIONS **/
logic [BRANCH_HISTORY_TABLE_SIZE-1:0]                                    branch_history_register_update;
logic [BRANCH_HISTORY_TABLE_SIZE-1:0] [BRANCH_HISTORY_REGISTER_SIZE-1:0] branch_history_register_history;

/** MODULES **/
demux #(
    BRANCH_HISTORY_TABLE_SIZE,
    1
) update_demux (
    /* INPUTS */
    .sel(index),
    .in(update),

    /* OUTPUTS */
    .out(branch_history_register_update)
);

branch_history_register #(
    BRANCH_HISTORY_REGISTER_SIZE
) _branch_history_register[BRANCH_HISTORY_TABLE_SIZE-1:0] (
    /* INPUTS */
    .clk,
    .stall,
    .update(branch_history_register_update),
    .update_value,

    /* OUTPUTS */
    .history(branch_history_register_history)
);

mux #(
    BRANCH_HISTORY_TABLE_SIZE,
    BRANCH_HISTORY_REGISTER_SIZE
) prediction_mux (
    /* INPUTS */
    .sel(index),
    .in(branch_history_register_history),

    /* OUTPUTS */
    .out(history)
);

endmodule : branch_history_table
