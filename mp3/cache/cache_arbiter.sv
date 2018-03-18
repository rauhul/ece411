module cache_arbiter (
    input clk,

    /* SLAVES */
    wishbone.slave input_wishbone0,
    wishbone.slave input_wishbone1,

    /* MASTERS */
    wishbone.master output_wishbone
);

register #(.width(12)) address (
    /* INPUTS */
    .clk,
    .load(load_address),
    .stall(0),
    .in(address_in),

    /* OUTPUTS */
    .out(address_out)
);

register #(.width(128)) data (
    /* INPUTS */
    .clk,
    .load(load_data),
    .stall(0),
    .in(data_in),

    /* OUTPUTS */
    .out(data_out)
);

wishbone owner_wishbone(clk);

/* input_wishbone0 has priority */
enum int unsigned {
    /* List of states */
    o_none,
    o_input0,
    o_input1
} owner, next_owner;

always_comb begin : owner_actions
    /* Default output assignments */
    owner_wishbone.DAT_M = 128'bx;
    owner_wishbone.CYC   = 0;
    owner_wishbone.STB   = 0;
    owner_wishbone.WE    = 0;
    owner_wishbone.SEL   = 0;
    owner_wishbone.ADR   = 0;

    /* owner_wishbone outputs */
    input_wishbone0.DAT_S = 128'x;
    input_wishbone0.ACK = 0;
    input_wishbone0.RTY = 0;

    input_wishbone1.DAT_S = 128'x;
    input_wishbone1.ACK = 0;
    input_wishbone1.RTY = 0;

    /* Actions for each owner */
    case(state)

        o_none: begin
            // nothing
        end

        o_input0: begin
            owner_wishbone.DAT_M = input_wishbone0.DAT_M;
            owner_wishbone.CYC   = input_wishbone0.CYC;
            owner_wishbone.STB   = input_wishbone0.STB;
            owner_wishbone.WE    = input_wishbone0.WE;
            owner_wishbone.SEL   = input_wishbone0.SEL;
            owner_wishbone.ADR   = input_wishbone0.ADR;

            input_wishbone1.RTY = 1;
        end

        o_input1: begin
            owner_wishbone.DAT_M = input_wishbone0.DAT_M;
            owner_wishbone.CYC   = input_wishbone0.CYC;
            owner_wishbone.STB   = input_wishbone0.STB;
            owner_wishbone.WE    = input_wishbone0.WE;
            owner_wishbone.SEL   = input_wishbone0.SEL;
            owner_wishbone.ADR   = input_wishbone0.ADR;

            input_wishbone0.RTY = 1;
        end

    endcase
end

always_comb begin : next_owner_logic
    /* Default next state assignment */
    next_owner = owner;

    /* Next owner information and conditions (if any)
     * for transitioning between owners */
    case(owner)
        o_none: begin
            if (input_wishbone0.CYC) // input0 requests ownership
                next_owner = o_input0;
            else if (input_wishbone1.CYC) // input1 requests ownership
                next_owner = o_input1;
        end

        o_input0: begin
            if (~input_wishbone0.CYC) begin // input0 relinquishes ownership
                if (input_wishbone1.CYC) // input1 requests ownership
                    next_owner = o_input1;
                else
                    next_owner = o_none;
            end
        end

        o_input1: begin
            if (~input_wishbone1.CYC) begin // input1 relinquishes ownership
                if (input_wishbone0.CYC) // input0 requests ownership
                    next_owner = o_input0;
                else
                    next_owner = o_none;
            end
        end

    endcase // owner
end

always_ff @(posedge clk) begin: next_owner_assignment
    /* Assignment of next owner on clock edge */
    owner <= next_owner;
end

enum int unsigned {
    /* List of states */
    s_idle,
    s_flush,
    s_fetch
} state, next_state;

always_comb begin : state_actions
    /* Default output assignments */
    output_wishbone.DAT_M = 128'x;
    output_wishbone.STB = 0;
    output_wishbone.WE = 0;
    output_wishbone.SEL = 0;
    output_wishbone.ADR = 0;

    /* Actions for each state */
    case(state)

        s_idle: begin
            // nothing
        end

        s_flush: begin
            output_wishbone.DAT_M = 128'x;
            output_wishbone.STB = 0;
            output_wishbone.WE = 0;
            output_wishbone.SEL = 0;
            output_wishbone.ADR = 0;

            input_wishbone0.DAT_S = 128'x;
            input_wishbone0.ACK = 0;
            input_wishbone0.RTY = 1;
        end

        s_fetch: begin

        end

    endcase
end

always_comb begin : next_state_logic
    /* Default next state assignment */
    next_state = state;

    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)

        s_idle: begin
            if (input_wishbone0.CYC & input_wishbone0.STB) begin
                if (input_wishbone0.WE)
                    next_state = s_flush_0;
                else
                    next_state = s_fetch_0;
            end else if (input_wishbone1.CYC & input_wishbone1.STB) begin
                if (input_wishbone1.WE)
                    next_state = s_flush_1;
                else
                    next_state = s_fetch_1;
            end
        end

        s_flush_0: begin
            if (input_wishbone0.CYC) begin // continue working with input_wishbone0

            end else begin // transition to new or no owner
                if (input_wishbone1.CYC & input_wishbone1.STB) begin



            end
        end

        s_fetch_0: begin

        end

        s_flush_1: begin

        end

        s_fetch_1: begin

        end

    endcase // state
end

always_ff @(posedge clk) begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_arbiter

/*
    logic [127:0] DAT_M, DAT_S;
    logic ACK, CYC, STB, RTY, WE;
    logic [11:0] ADR;
    logic [15:0] SEL;

    modport master (
        input DAT_S, CLK, ACK, RTY,
        output DAT_M, CYC, STB, WE, SEL, ADR
    );

    modport slave (
        input DAT_M, CLK, CYC, STB, WE, SEL, ADR,
        output DAT_S, ACK, RTY
    );
*/