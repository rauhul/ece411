import lc3b_types::*;

module cache_arbiter (
    /* SLAVES */
    wishbone.slave input_wishbone0,
    wishbone.slave input_wishbone1,

    /* MASTERS */
    wishbone.master output_wishbone
);

logic clk;
assign clk = output_wishbone.CLK;

/* input_wishbone0 has priority */
enum int unsigned {
    /* List of owners */
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
    case(owner)

        o_none: begin
            if (input_wishbone0.CYC) // input0 requests ownership
                input_wishbone0.RTY = 0;
            else if (input_wishbone1.CYC) // input1 requests ownership
                input_wishbone1.RTY = 0;
        end

        o_input0: begin
            output_wishbone.DAT_M = input_wishbone0.DAT_M;
            output_wishbone.CYC   = input_wishbone0.CYC;
            output_wishbone.STB   = input_wishbone0.STB;
            output_wishbone.WE    = input_wishbone0.WE;
            output_wishbone.SEL   = input_wishbone0.SEL;
            output_wishbone.ADR   = input_wishbone0.ADR;

            input_wishbone0.DAT_S = output_wishbone.DAT_S;
            input_wishbone0.ACK   = output_wishbone.ACK;
            input_wishbone0.RTY   = 0;

            input_wishbone1.DAT_S = 128'bx;
            input_wishbone1.ACK   = 0;
            input_wishbone1.RTY   = 1;
        end

        o_input1: begin
            output_wishbone.DAT_M = input_wishbone1.DAT_M;
            output_wishbone.CYC   = input_wishbone1.CYC;
            output_wishbone.STB   = input_wishbone1.STB;
            output_wishbone.WE    = input_wishbone1.WE;
            output_wishbone.SEL   = input_wishbone1.SEL;
            output_wishbone.ADR   = input_wishbone1.ADR;

            input_wishbone0.DAT_S = 128'bx;
            input_wishbone0.ACK   = 0;
            input_wishbone0.RTY   = 1;

            input_wishbone1.DAT_S = output_wishbone.DAT_S;
            input_wishbone1.ACK   = output_wishbone.ACK;
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
