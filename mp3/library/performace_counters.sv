import lc3b_types::*;

module performace_counters (
    /* INPUTS */
    input clk,
    input logic data_memory_access,
    input logic data_memory_write_enable,
    input logic [15:0] data_memory_address,

    /* debug */
    input logic debug_branch_prediction_correct,
    input logic debug_branch_prediction_incorrect,

    input logic debug_i_cache_hit,
    input logic debug_i_cache_miss,
    input logic debug_d_cache_hit,
    input logic debug_d_cache_miss,
    input logic debug_l2_cache_hit,
    input logic debug_l2_cache_miss,

    input logic debug_stage_IF_stall,
    input logic debug_stage_ID_stall,
    input logic debug_stage_EX_stall,
    input logic debug_stage_MEM_stall,
    input logic debug_stage_WB_stall,

    /* OUTPUTS */
    output logic data_memory_access_cancel,
    output logic [15:0] data_memory_data_out
);

/* BRANCH PREDICTIONS */
/* 16'hFFE6 */ logic [15:0] branch_predictions_correct;
/* 16'hFFE8 */ logic [15:0] branch_predictions_incorrect;

/* CACHE ACCESSES */
/* 16'hFFEA */ logic [15:0] i_cache_hits;
/* 16'hFFEC */ logic [15:0] i_cache_misses;
/* 16'hFFEE */ logic [15:0] d_cache_hits;
/* 16'hFFF0 */ logic [15:0] d_cache_misses;
/* 16'hFFF2 */ logic [15:0] l2_cache_hits;
/* 16'hFFF4 */ logic [15:0] l2_cache_misses;

/* STAGE STALL */
/* 16'hFFF6 */ logic [15:0] stage_IF_stalls;
/* 16'hFFF8 */ logic [15:0] stage_ID_stalls;
/* 16'hFFFA */ logic [15:0] stage_EX_stalls;
/* 16'hFFFC */ logic [15:0] stage_MEM_stalls;
/* 16'hFFFE */ logic [15:0] stage_WB_stalls;

initial begin
    /* BRANCH PREDICTIONS */
    branch_predictions_correct   = 0;
    branch_predictions_incorrect = 0;

    /* CACHE ACCESSES */
    i_cache_hits          = 0;
    i_cache_misses        = 0;
    d_cache_hits          = 0;
    d_cache_misses        = 0;
    l2_cache_hits         = 0;
    l2_cache_misses       = 0;

    /* STAGE STALL */
    stage_IF_stalls       = 0;
    stage_ID_stalls       = 0;
    stage_EX_stalls       = 0;
    stage_MEM_stalls      = 0;
    stage_WB_stalls       = 0;
end

always_ff @(posedge clk) begin
    /* BRANCH PREDICTIONS */
    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFE6))
        branch_predictions_correct = 0;
    else if (debug_branch_prediction_correct)
        branch_predictions_correct += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFE8))
        branch_predictions_incorrect = 0;
    else if (debug_branch_prediction_incorrect)
        branch_predictions_incorrect += 1'b1;

    /* CACHE ACCESSES */
    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFEA))
        i_cache_hits = 0;
    else if (debug_i_cache_hit)
        i_cache_hits += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFEC))
        i_cache_misses = 0;
    else if (debug_i_cache_miss)
        i_cache_misses += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFEE))
        d_cache_hits = 0;
    else if (debug_d_cache_hit)
        d_cache_hits += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFF0))
        d_cache_misses = 0;
    else if (debug_d_cache_miss)
        d_cache_misses += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFF2))
        l2_cache_hits = 0;
    else if (debug_l2_cache_hit)
        l2_cache_hits += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFF4))
        l2_cache_misses = 0;
    else if (debug_l2_cache_miss)
        l2_cache_misses += 1'b1;

    /* STAGE STALL */
    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFF6))
        stage_IF_stalls = 0;
    else if (debug_stage_IF_stall)
        stage_IF_stalls += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFF8))
        stage_ID_stalls = 0;
    else if (debug_stage_ID_stall)
        stage_ID_stalls += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFFA))
        stage_EX_stalls = 0;
    else if (debug_stage_EX_stall)
        stage_EX_stalls += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFFC))
        stage_MEM_stalls = 0;
    else if (debug_stage_MEM_stall)
        stage_MEM_stalls += 1'b1;

    if (data_memory_access & data_memory_write_enable & (data_memory_address == 16'hFFFE))
        stage_WB_stalls = 0;
    else if (debug_stage_WB_stall)
        stage_WB_stalls += 1'b1;
end

always_comb begin
     data_memory_access_cancel = 0;
     data_memory_data_out      = 0;

     if (data_memory_access) begin
        if (16'hFFE6 <= data_memory_address) begin
            data_memory_access_cancel = 1;
        end

        if (~data_memory_write_enable) begin
            case (data_memory_address)
                /* BRANCH PREDICTIONS */
                16'hFFE6 : data_memory_data_out = branch_predictions_correct;
                16'hFFE8 : data_memory_data_out = branch_predictions_incorrect;

                /* CACHE ACCESSES */
                16'hFFEA : data_memory_data_out = i_cache_hits;
                16'hFFEC : data_memory_data_out = i_cache_misses;
                16'hFFEE : data_memory_data_out = d_cache_hits;
                16'hFFF0 : data_memory_data_out = d_cache_misses;
                16'hFFF2 : data_memory_data_out = l2_cache_hits;
                16'hFFF4 : data_memory_data_out = l2_cache_misses;

                /* STAGE STALL */
                16'hFFF6 : data_memory_data_out = stage_IF_stalls;
                16'hFFF8 : data_memory_data_out = stage_ID_stalls;
                16'hFFFA : data_memory_data_out = stage_EX_stalls;
                16'hFFFC : data_memory_data_out = stage_MEM_stalls;
                16'hFFFE : data_memory_data_out = stage_WB_stalls;

                default : ;
            endcase
        end
    end
end

endmodule : performace_counters
