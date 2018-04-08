import lc3b_types::*;

module stall_arbiter (

    /* INPUTS */
    input lc3b_pipeline_control_word i_cache_pipeline_control_request,
    input lc3b_pipeline_control_word d_cache_pipeline_control_request,
    input lc3b_pipeline_control_word branch_controller_pipeline_control_request,
    input lc3b_pipeline_control_word forwarding_controller_pipeline_control_request,

    /* OUTPUTS */
    output lc3b_pipeline_control_word pipeline_control_out
);

logic lock;

always_comb begin
    pipeline_control_out = 0;
    lock = 0;

    if (~lock & i_cache_pipeline_control_request.active) begin
        lock = i_cache_pipeline_control_request.exclusive;
        if (i_cache_pipeline_control_request.exclusive) begin
            pipeline_control_out = i_cache_pipeline_control_request;
        end else begin
            pipeline_control_out = pipeline_control_out | i_cache_pipeline_control_request;
        end
    end

    if (~lock & d_cache_pipeline_control_request.active) begin
        lock = d_cache_pipeline_control_request.exclusive;
        if (d_cache_pipeline_control_request.exclusive) begin
            pipeline_control_out = d_cache_pipeline_control_request;
        end else begin
            pipeline_control_out = pipeline_control_out | d_cache_pipeline_control_request;
        end
    end

    if (~lock & branch_controller_pipeline_control_request.active) begin
        lock = branch_controller_pipeline_control_request.exclusive;
        if (branch_controller_pipeline_control_request.exclusive) begin
            pipeline_control_out = branch_controller_pipeline_control_request;
        end else begin
            pipeline_control_out = pipeline_control_out | branch_controller_pipeline_control_request;
        end
    end

    if (~lock & forwarding_controller_pipeline_control_request.active) begin
        lock = forwarding_controller_pipeline_control_request.exclusive;
        if (forwarding_controller_pipeline_control_request.exclusive) begin
            pipeline_control_out = forwarding_controller_pipeline_control_request;
        end else begin
            pipeline_control_out = pipeline_control_out | forwarding_controller_pipeline_control_request;
        end
    end
end

endmodule : stall_arbiter