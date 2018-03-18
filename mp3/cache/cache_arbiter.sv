import lc3b_types::*;

module cache_arbiter (
    input clk,

    /* SLAVES */
    wishbone.slave input_wishbone0,
    wishbone.slave input_wishbone1,

    /* MASTERS */
    wishbone.master output_wishbone
);

logic [127:0] input_wishbone0_DAT_M;
logic input_wishbone0_CYC;
logic input_wishbone0_STB;
logic input_wishbone0_WE;
logic [15:0] input_wishbone0_SEL;
logic [11:0] input_wishbone0_ADR;

barrier_wishbone_master _input_wishbone0 (
    /* INPUTS */
    .clk,
    .DAT_M_in(input_wishbone0.DAT_M),
    .CYC_in(input_wishbone0.CYC),
    .STB_in(input_wishbone0.STB),
    .WE_in(input_wishbone0.WE),
    .SEL_in(input_wishbone0.SEL),
    .ADR_in(input_wishbone0.ADR),

    /* OUTPUTS */
    .DAT_M_out(input_wishbone0_DAT_M),
    .CYC_out(input_wishbone0_CYC),
    .STB_out(input_wishbone0_STB),
    .WE_out(input_wishbone0_WE),
    .SEL_out(input_wishbone0_SEL),
    .ADR_out(input_wishbone0_ADR)
);

logic [127:0] input_wishbone1_DAT_M;
logic input_wishbone1_CYC;
logic input_wishbone1_STB;
logic input_wishbone1_WE;
logic [15:0] input_wishbone1_SEL;
logic [11:0] input_wishbone1_ADR;

barrier_wishbone_master _input_wishbone1 (
    /* INPUTS */
    .clk,
    .DAT_M_in(input_wishbone1.DAT_M),
    .CYC_in(input_wishbone1.CYC),
    .STB_in(input_wishbone1.STB),
    .WE_in(input_wishbone1.WE),
    .SEL_in(input_wishbone1.SEL),
    .ADR_in(input_wishbone1.ADR),

    /* OUTPUTS */
    .DAT_M_out(input_wishbone1_DAT_M),
    .CYC_out(input_wishbone1_CYC),
    .STB_out(input_wishbone1_STB),
    .WE_out(input_wishbone1_WE),
    .SEL_out(input_wishbone1_SEL),
    .ADR_out(input_wishbone1_ADR)
);

logic [127:0] output_wishbone_DAT_S;
logic output_wishbone_ACK;
logic output_wishbone_RTY;

barrier_wishbone_slave _output_wishbone (
    /* INPUTS */
    .clk,
    .DAT_S_in(output_wishbone.DAT_S),
    .ACK_in(output_wishbone.ACK),
    .RTY_in(output_wishbone.RTY),

    /* OUTPUTS */
    .DAT_S_out(output_wishbone_DAT_S),
    .ACK_out(output_wishbone_ACK),
    .RTY_out(output_wishbone_RTY)
);

/* input_wishbone0 has priority */
enum int unsigned {
    /* List of states */
    o_none,
    o_input0,
    o_input1
} owner, next_owner;

always_comb begin : owner_actions
    /* Default output assignments */
    output_wishbone.DAT_M = 128'bx;
    output_wishbone.CYC   = 0;
    output_wishbone.STB   = 0;
    output_wishbone.WE    = 0;
    output_wishbone.SEL   = 0;
    output_wishbone.ADR   = 0;

    input_wishbone0.DAT_S = 128'bx;
    input_wishbone0.ACK   = 0;
    input_wishbone0.RTY   = 1;

    input_wishbone1.DAT_S = 128'bx;
    input_wishbone1.ACK   = 0;
    input_wishbone1.RTY   = 1;

    /* Actions for each owner */
    case(state)

        o_none: begin
            if (input_wishbone0.CYC) // input0 requests ownership
                input_wishbone0.RTY = 0;
            else if (input_wishbone1.CYC) // input1 requests ownership
                input_wishbone1.RTY = 0;
        end

        o_input0: begin
            output_wishbone.DAT_M = input_wishbone0_DAT_M;
            output_wishbone.CYC   = input_wishbone0_CYC;
            output_wishbone.STB   = input_wishbone0_STB;
            output_wishbone.WE    = input_wishbone0_WE;
            output_wishbone.SEL   = input_wishbone0_SEL;
            output_wishbone.ADR   = input_wishbone0_ADR;

            input_wishbone0.DAT_S = output_wishbone_DAT_S;
            input_wishbone0.ACK   = output_wishbone_ACK;
            input_wishbone0.RTY   = 0;

            input_wishbone1.DAT_S = 128'bx;
            input_wishbone1.ACK   = 0;
            input_wishbone1.RTY   = 1;
        end

        o_input1: begin
            output_wishbone.DAT_M = input_wishbone1_DAT_M;
            output_wishbone.CYC   = input_wishbone1_CYC;
            output_wishbone.STB   = input_wishbone1_STB;
            output_wishbone.WE    = input_wishbone1_WE;
            output_wishbone.SEL   = input_wishbone1_SEL;
            output_wishbone.ADR   = input_wishbone1_ADR;

            input_wishbone0.DAT_S = 128'bx;
            input_wishbone0.ACK   = 0;
            input_wishbone0.RTY   = 1;

            input_wishbone1.DAT_S = output_wishbone_DAT_S;
            input_wishbone1.ACK   = output_wishbone_ACK;
            input_wishbone1.RTY   = 0;
        end

    endcase
end

always_comb begin : next_owner_logic
    /* Default next owner assignment */
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

endmodule : cache_arbiter
