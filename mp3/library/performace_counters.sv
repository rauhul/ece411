import lc3b_types::*;

module performace_counters (
    /* INPUTS */
    input clk,
    input logic data_memory_access,
    input logic data_memory_write_enable,
    input logic [15:0] data_memory_address,
    input lc3b_pipeline_control_word main_pipeline_control,

    /* OUTPUTS */
    output logic data_memory_access_cancel,
    output logic [15:0] data_memory_data_out
);

/* BRANCH PREDICTIONS */
/* 16'hFFE6 */ logic [15:0] predictions_correct;
/* 16'hFFE8 */ logic [15:0] predictions_incorrect;

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
    predictions_correct   = 0;
    predictions_incorrect = 0;

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


task update_register (
    input logic [15:0] register,
    input logic [15:0] address,
    input logic incrementer
);

if (data_memory_access & data_memory_write_enable & (data_memory_address == address))
    register = 0;
else if (incrementer)
    register += 1;

endtask : update_register


always_ff @(posedge clk) begin
    /* BRANCH PREDICTIONS */

    /* CACHE ACCESSES */

    /* STAGE STALL */
    update_register(stage_IF_stalls,  16'hFFF6, main_pipeline_control.stage_IF_stall);
    update_register(stage_ID_stalls,  16'hFFF8, main_pipeline_control.stage_ID_stall);
    update_register(stage_EX_stalls,  16'hFFFA, main_pipeline_control.stage_EX_stall);
    update_register(stage_MEM_stalls, 16'hFFFC, main_pipeline_control.stage_MEM_stall);
    update_register(stage_WB_stalls,  16'hFFFE, main_pipeline_control.stage_WB_stall);
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
                16'hFFE6 : data_memory_data_out = predictions_correct;
                16'hFFE8 : data_memory_data_out = predictions_incorrect;

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
            endcase
        end
    end
end

endmodule : performace_counters
