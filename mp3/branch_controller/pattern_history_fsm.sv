import lc3b_types::*;

module pattern_history_fsm (
    /* INPUTS */
    input logic clk,
    input logic stall,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic prediction
);

lc3b_pattern_history_fsm_state state, next_state;

always_comb begin : state_actions
    /* Default output assignments */
    prediction = 'x;

    /* Actions for each state */
     case(state)
        s_taken_2:  prediction = 1;
        s_taken:    prediction = 1;
        s_ntaken:   prediction = 0;
        s_ntaken_2: prediction = 0;
    endcase
end

always_comb begin : next_state_logic
    /* Default next state assignment */
    next_state = state;

    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)
        s_taken_2: begin
            if (update_value) begin
                next_state = s_taken_2;
            end else begin
                next_state = s_taken;
            end
        end

        s_taken: begin
            if (update_value) begin
                next_state = s_taken_2;
            end else begin
                next_state = s_ntaken;
            end
        end

        s_ntaken: begin
            if (update_value) begin
                next_state = s_taken;
            end else begin
                next_state = s_ntaken_2;
            end
        end

        s_ntaken_2: begin
            if (update_value) begin
                next_state = s_ntaken;
            end else begin
                next_state = s_ntaken_2;
            end
        end
    endcase // state
end

always_ff @(posedge clk) begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (update && ~stall) begin
        state <= next_state;
    end
end

endmodule : pattern_history_fsm
