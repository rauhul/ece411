module cache_control (
    /* INPUTS */
    /* global->cpu_control */
    input clk,

    /* cache_datapath->cache_control */
    input hit_0,
    input hit_1,
    input hit_any,
    input dirty_out,
    input lru_out,

    /* CPU->cache_control */
    input cpu_read,
    input cpu_write,

    /* memory->cache_control */
    input mem_resp,

    /* OUTPUTS */
    /* cache_control->cache_datapath */
    output logic cacheline_sel,
    output logic tag_source_sel,
    output logic load,
    output logic load_all,
    output logic load_lru,
    output logic lru_in,

    /* cache_control->CPU */
    output logic cpu_resp,

    /* cache_control->memory */
    output logic mem_read,
    output logic mem_write
);

logic cpu_req;
assign cpu_req = cpu_read | cpu_write;

enum int unsigned {
    /* List of states */
    s_idle_hit,
    s_write_back,
    s_read_in
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    cacheline_sel   = 1'b0;
    tag_source_sel  = 1'b0;
    load            = 1'b0;
    load_all        = 1'b0;
    load_lru        = 1'b0;
    lru_in          = 1'b0;
    cpu_resp        = 1'b0;
    mem_write       = 1'b0;
    mem_read        = 1'b0;

    /* Actions for each state */
    case(state)
        s_idle_hit: begin
            if ((cpu_req == 1) && (hit_any == 1)) begin
                if (hit_0 == 1) begin
                    cacheline_sel = 1'b0;
                    lru_in = 1'b1;
                end else begin
                    cacheline_sel = 1'b1;
                    lru_in = 1'b0;
                end

                load_lru = 1'b1;
                cpu_resp = 1'b1;

                if (cpu_write == 1) begin
                    load = 1'b1;
                end
            end
        end

        s_write_back: begin
            cacheline_sel = lru_out;
            tag_source_sel = 1'b0;
            mem_write = 1'b1;
        end

        s_read_in: begin
            cacheline_sel = lru_out;
            tag_source_sel = 1'b1;
            load_all = 1'b1;
            mem_read = 1'b1;
        end
    endcase
end

always_comb
begin : next_state_logic
    /* Default next state assignment */
    next_state = state;

    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)
        s_idle_hit: begin
            if ((cpu_req == 1) && (hit_any == 0)) begin
                if (dirty_out == 1) begin
                    next_state = s_write_back;
                end else begin
                    next_state = s_read_in;
                end
            end
        end

        s_write_back: begin
            if (mem_resp == 1)
                next_state = s_read_in;
        end

        s_read_in: begin
            if (mem_resp == 1)
                next_state = s_idle_hit;
        end
    endcase // state
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end


endmodule : cache_control