// TODO: add paramater associativity
module cache_set_controller (
    /* INPUTS */
    /* global->cpu_control */
    input clk,

    /* cache_set->cache_set_controller */
    input hit_0,
    input hit_1,
    input dirty,
    input lru,

    /* CPU->cache_set_controller */
    input cpu_request,
    input cpu_read_write,

    /* memory->cache_set_controller */
    input memory_response,

    /* OUTPUTS */
    /* cache_set_controller->cache_set */
    output logic cache_way_sel,
    output logic data_source_sel,
    output logic tag_bypass_sel,
    output logic load,
    output logic load_lru,

    /* cache_set_controller->CPU */
    output logic cpu_response,

    /* cache_set_controller->memory */
    output logic memory_request,
    output logic memory_read_write
);

enum int unsigned {
    /* List of states */
    s_idle_hit,
    s_flush,
    s_flush_2,
    s_fetch,
    s_fetch_2
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    cache_way_sel     = 0;
    data_source_sel   = 0;
    tag_bypass_sel    = 0;
    load              = 0;
    load_lru          = 0;

    cpu_response      = 0;
    memory_request    = 0;
    memory_read_write = 0;

    /* Actions for each state */
    case(state)
        s_idle_hit: begin
            if (cpu_request & (hit_0 | hit_1)) begin
                // select correct way
                cache_way_sel = hit_1;
                // update lru bit
                load_lru = 1;
                // set input data source to cpu
                data_source_sel = 0;
                // load if cpu_write
                load = cpu_read_write;
                // repond to request
                cpu_response = 1;
            end
        end

        s_flush: begin
            // select the lru
            cache_way_sel = lru;
            // pass the cache_line tag to the memory_address
            tag_bypass_sel = 0;
            // signal a memory write request
            memory_request = 1;
            memory_read_write = 1;
        end

        s_flush_2: begin

        end

        s_fetch: begin
            // select the lru
            cache_way_sel = lru;
            // pass the cpu_address tag to the memory_address
            tag_bypass_sel = 1;
            // set input data source to memory
            data_source_sel = 1;
            // load if cpu_write
            load = 1;
            // signal a memory read request
            memory_request = 1;
            memory_read_write = 0;
        end

        s_fetch_2: begin

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
            if (cpu_request & ~(hit_0 | hit_1)) begin
                if (dirty)
                    next_state = s_flush;
                else
                    next_state = s_fetch;
            end
        end

        s_flush: begin
            if (memory_response == 1)
                next_state = s_flush_2;
        end

        s_flush_2: begin
            if (memory_response == 0)
                next_state = s_fetch;
        end

        s_fetch: begin
            if (memory_response == 1)
                next_state = s_fetch_2;
        end

        s_fetch_2: begin
            if (memory_response == 0)
                next_state = s_idle_hit;
        end
    endcase // state
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end


endmodule : cache_set_controller