import lc3b_types::*;

module branch_predictor (
    /* INPUTS */
    input logic clk,
    input logic stall,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic prediction
);

enum int unsigned {
    /* List of states */
    s_taken_2,
    s_taken,
    s_ntaken,
    s_ntaken_2
} state, next_state;

always_comb begin : state_actions
    /* Default output assignments */
    prediction = 'x;

    /* Actions for each state */
     case(state)
        s_taken_2: begin
            prediction = 1;
        end

        s_taken: begin
            prediction = 1;
        end

        s_ntaken: begin
            prediction = 0;
        end

        s_ntaken_2: begin
            prediction = 0;
        end
    endcase
end

always_comb begin : next_state_logic
    /* Default next state assignment */
    next_state = state;

    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)
        s_taken_2: begin
            if (update) begin
                if (update_value) begin
                    next_state = s_taken_2;
                end else begin
                    next_state = s_taken;
                end
            end
        end

        s_taken: begin
            if (update) begin
                if (update_value) begin
                    next_state = s_taken_2;
                end else begin
                    next_state = s_ntaken;
                end
            end
        end

        s_ntaken: begin
            if (update) begin
                if (update_value) begin
                    next_state = s_taken;
                end else begin
                    next_state = s_ntaken_2;
                end
            end
        end

        s_ntaken_2: begin
            if (update) begin
                if (update_value) begin
                    next_state = s_ntaken;
                end else begin
                    next_state = s_ntaken_2;
                end
            end
        end
    endcase // state
end

always_ff @(posedge clk) begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (~stall) begin
        state <= next_state;
    end
end

endmodule : branch_predictor
