// TODO: add parameter associativity
module cache_l1_controller (
    /* INPUTS */
    input clk,

    /* datapath->controller */
    input hit_0,
    input hit_1,
    input dirty,
    input lru,

    /* input_wishbone->cache */
    input input_wishbone_CYC,
    input input_wishbone_STB,
    input input_wishbone_WE,

    /* output_wishbone->cache */
    input output_wishbone_ACK,
    input output_wishbone_RTY,

    /* OUTPUTS */
    /* controller->datapath */
    output logic cache_way_sel,
    output logic data_source_sel,
    output logic tag_bypass_sel,
    output logic load,
    output logic load_lru,

    /* cache->input_wishbone */
    output logic input_wishbone_ACK,
    output logic input_wishbone_RTY,

    /* cache->output_wishbone */
    output logic output_wishbone_CYC,
    output logic output_wishbone_STB,
    output logic output_wishbone_WE
);

enum int unsigned {
    /* List of states */
    s_idle_hit,
    s_flush,
    s_flush_2,
    s_fetch,
    s_fetch_2
} state, next_state;

always_comb begin : state_actions
    /* Default output assignments */
    cache_way_sel       = 0;
    data_source_sel     = 0;
    tag_bypass_sel      = 0;
    load                = 0;
    load_lru            = 0;

    input_wishbone_ACK  = 0;
    input_wishbone_RTY  = 1;

    output_wishbone_CYC = 0;
    output_wishbone_STB = 0;
    output_wishbone_WE  = 0;

    /* Actions for each state */
    case(state)
        s_idle_hit: begin
            if (input_wishbone_CYC & input_wishbone_STB) begin : memory_request
                if (hit_0 | hit_1) begin : hit
                    // select correct way
                    cache_way_sel = hit_1;
                    // update lru bit
                    load_lru = 1;
                    // set input data source to input_wishbone_DAT_M
                    data_source_sel = 0;
                    // load if cpu_write
                    load = input_wishbone_WE;


                    input_wishbone_ACK = 1;
                    input_wishbone_RTY = 0;

                    output_wishbone_CYC = 0;
                    output_wishbone_STB = 0;
                    output_wishbone_WE  = 0;
                end else begin : miss
                    input_wishbone_ACK = 0;
                    input_wishbone_RTY = 1;

                    output_wishbone_CYC = 1;
                    output_wishbone_STB = 0;
                    output_wishbone_WE  = 0;
                end
            end
        end

        s_flush: begin
            // select the lru
            cache_way_sel = lru;
            // pass the cache_line tag to the output_wishbone_ADR
            tag_bypass_sel = 0;


            input_wishbone_ACK = 0;
            input_wishbone_RTY = 1;

            output_wishbone_CYC = 1;
            output_wishbone_STB = 1;
            output_wishbone_WE  = 1;
        end

        s_flush_2: begin
            input_wishbone_ACK = 0;
            input_wishbone_RTY = 1;

            output_wishbone_CYC = 1;
            output_wishbone_STB = 0;
            output_wishbone_WE  = 1;
        end

        s_fetch: begin
            // select the lru
            cache_way_sel = lru;
            // pass the cpu_address tag to the output_wishbone_ADR
            tag_bypass_sel = 1;
            // set input data source to output_wishbone_DAT_S
            data_source_sel = 1;
            // load if cpu_write
            load = 1;


            input_wishbone_ACK = 0;
            input_wishbone_RTY = 1;

            output_wishbone_CYC = 1;
            output_wishbone_STB = 1;
            output_wishbone_WE  = 0;
        end

        s_fetch_2: begin
            input_wishbone_ACK = 0;
            input_wishbone_RTY = 1;


            output_wishbone_CYC = 1;
            output_wishbone_STB = 0;
            output_wishbone_WE  = 0;
        end
    endcase
end

always_comb begin : next_state_logic
    /* Default next state assignment */
    next_state = state;

    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)
        s_idle_hit: begin
            if (input_wishbone_CYC & input_wishbone_STB) begin : memory_request
                if (~(hit_0 | hit_1)) begin : miss
                    if (~output_wishbone_RTY) begin : downstream_ready
                        if (dirty) begin : dirty_miss
                            next_state = s_flush;
                        end else begin: clean_miss
                            next_state = s_fetch;
                        end
                    end
                end
            end
        end

        s_flush: begin
            if (output_wishbone_ACK == 1)
                next_state = s_flush_2;
        end

        s_flush_2: begin
            if (output_wishbone_ACK == 0)
                next_state = s_fetch;
        end

        s_fetch: begin
            if (output_wishbone_ACK == 1)
                next_state = s_fetch_2;
        end

        s_fetch_2: begin
            if (output_wishbone_ACK == 0)
                next_state = s_idle_hit;
        end
    endcase // state
end

always_ff @(posedge clk) begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_l1_controller
