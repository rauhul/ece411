module cache_control (
    /* INPUTS */
    /* global->cpu_control */
    input clk,

    /* cache_datapath->cache_control */
    input hit_0,
    input hit_1,
    input dirty,
    input lru,

    /* CPU->cache_control */
    input cpu_request,
    input cpu_read_write,

    /* memory->cache_control */
    input memory_response,

    /* OUTPUTS */
    /* cache_control->cache_datapath */
    output logic cache_way_sel,
    output logic data_source_sel,
    output logic tag_bypass_sel,
    output logic load,
    output logic load_type,
    output logic load_lru,

    /* cache_control->CPU */
    output logic cpu_response,

    /* cache_control->memory */
    output logic memory_request,
    output logic memory_read_write
);

enum int unsigned {
    /* List of states */
    s_idle_hit,
    s_write_back,
    s_write_back_2,
    s_read_in,
    s_read_in_2
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    cache_way_sel       = 0;
    data_source_sel     = 0;
    tag_bypass_sel      = 0;
    load                = 0;
    load_type           = 0;
    load_lru            = 0;

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

        s_write_back: begin
            // select the lru
            cache_way_sel = lru;
            // pass the cache_line tag to the memory_address
            tag_bypass_sel = 0;
            // signal a memory write request
            memory_request = 1;
            memory_read_write = 1;
        end

        s_write_back_2: begin

        end

        s_read_in: begin
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

        s_read_in_2: begin

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
            if (cpu_req & ~(hit_0 | hit_1)) begin
                if (dirty)
                    next_state = s_write_back;
                else
                    next_state = s_read_in;
            end
        end

        s_write_back: begin
            if (memory_response == 1)
                next_state = s_write_back_2;
        end

        s_write_back_2: begin
            if (memory_response == 0)
                next_state = s_read_in;
        end

        s_read_in: begin
            if (memory_response == 1)
                next_state = s_read_in_2;
        end

        s_read_in_2: begin
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


endmodule : cache_control