module stall_controller (
    /* INPUTS */
    input clk,
    input stage_IF_request_stall,
    input stage_MEM_request_stall,

    /* OUTPUTS */
    output logic barrier_IF_ID_stall,
    output logic barrier_ID_EX_stall,
    output logic barrier_EX_MEM_stall,
    output logic barrier_MEM_WB_stall,
    output logic stage_IF_stall,
    output logic stage_ID_stall,
    output logic stage_EX_stall,
    output logic stage_MEM_stall,
    output logic stage_WB_stall
);

always_comb begin
    /* Default output assignments */
    barrier_IF_ID_stall  = 0;
    barrier_ID_EX_stall  = 0;
    barrier_EX_MEM_stall = 0;
    barrier_MEM_WB_stall = 0;
    stage_IF_stall       = 0;
    stage_ID_stall       = 0;
    stage_EX_stall       = 0;
    stage_MEM_stall      = 0;
    stage_WB_stall       = 0;

    if (stage_IF_request_stall) begin
        barrier_IF_ID_stall  = 1;
        barrier_ID_EX_stall  = 1;
        barrier_EX_MEM_stall = 1;
        barrier_MEM_WB_stall = 1;
        stage_ID_stall       = 1;
        stage_EX_stall       = 1;
        stage_MEM_stall      = 1;
        stage_WB_stall       = 1;
    end else if (stage_MEM_request_stall) begin
        barrier_IF_ID_stall  = 1;
        barrier_ID_EX_stall  = 1;
        barrier_EX_MEM_stall = 1;
        barrier_MEM_WB_stall = 1;
        stage_IF_stall       = 1;
        stage_ID_stall       = 1;
        stage_EX_stall       = 1;
        stage_WB_stall       = 1;
    end
end

endmodule : stall_controller
