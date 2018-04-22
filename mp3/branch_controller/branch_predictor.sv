module branch_predictor #(
    parameter BRANCH_HISTORY_REGISTER_SIZE = 4,
    parameter NUM_PHT_INDEXING_PC_BITS = 3,
    parameter NUM_BHT_INDEXING_PC_BITS = 2
) (
    /* INPUTS */
    input logic clk,
    input logic stall,

    input logic [15:0] pc,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic prediction
);

localparam integer PATTERN_HISTORY_TABLE_SIZE = 2**BRANCH_HISTORY_REGISTER_SIZE;
localparam integer NUM_PATTERN_HISTORY_TABLES = 2**NUM_PHT_INDEXING_PC_BITS;
localparam integer BRANCH_HISTORY_TABLE_SIZE  = 2**NUM_BHT_INDEXING_PC_BITS;

/** CONNECTIONS **/
logic [NUM_PHT_INDEXING_PC_BITS-1:0]     pattern_history_table_sel;
logic [NUM_BHT_INDEXING_PC_BITS-1:0]     branch_history_table_sel;
logic [NUM_PATTERN_HISTORY_TABLES-1:0]   pattern_history_table_update;
logic [NUM_PATTERN_HISTORY_TABLES-1:0]   pattern_history_table_prediction;
logic [BRANCH_HISTORY_REGISTER_SIZE-1:0] branch_history_table_history;

/** MODULES **/
assign pattern_history_table_sel = pc[NUM_PHT_INDEXING_PC_BITS-1+4:4];
assign branch_history_table_sel  = pc[NUM_BHT_INDEXING_PC_BITS-1+2:2];

branch_history_table #(
    BRANCH_HISTORY_REGISTER_SIZE,
    BRANCH_HISTORY_TABLE_SIZE
) _branch_history_table (
    /* INPUTS */
    .clk,
    .stall,
    .index(branch_history_table_sel),
    .update,
    .update_value,

    /* OUTPUTS */
    .history(branch_history_table_history)
);

demux #(
    NUM_PATTERN_HISTORY_TABLES,
    1
) update_demux (
    /* INPUTS */
    .sel(pattern_history_table_sel),
    .in(update),

    /* OUTPUTS */
    .out(pattern_history_table_update)
);

pattern_history_table #(
    PATTERN_HISTORY_TABLE_SIZE
) _pattern_history_table[NUM_PATTERN_HISTORY_TABLES-1:0] (
    /* INPUTS */
    .clk,
    .stall,
    .index(branch_history_table_history),
    .update(pattern_history_table_update),
    .update_value,

    /* OUTPUTS */
    .prediction(pattern_history_table_prediction)
);

mux #(
    NUM_PATTERN_HISTORY_TABLES,
    1
) prediction_mux (
    /* INPUTS */
    .sel(pattern_history_table_sel),
    .in(pattern_history_table_prediction),

    /* OUTPUTS */
    .out(prediction)
);

endmodule : branch_predictor
