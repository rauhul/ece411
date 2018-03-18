import lc3b_types::*;

module mem_access_controller (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word ir_in,

    /* OUTPUTS */
    output lc3b_data_memory_addr_mux_sel data_memory_addr_mux_sel,
    output logic data_memory_write_enable,
    output logic internal_MDR_load,
    output logic request_stall
);

lc3b_opcode opcode;
assign opcode = lc3b_opcode'(ir_in[15:12]);

enum int unsigned {
    /* List of states */
    s_mem_access_1,
    s_mem_access_2
} state, next_state;


always_comb begin : state_actions
    /* Default output assignments */
    data_memory_addr_mux_sel = control_in.data_memory_addr_mux_sel;
    data_memory_write_enable = control_in.data_memory_write_enable;
    internal_MDR_load = 0;
    request_stall = 0;

    /* Actions for each state */
    case(state)

        s_mem_access_1: begin
            if (opcode == op_ldi || opcode == op_sti) begin
                data_memory_write_enable = 0;
                internal_MDR_load = 1;
                request_stall = 1;
            end
        end

        s_mem_access_2: begin
            data_memory_addr_mux_sel = lc3b_data_memory_addr_mux_sel_internal_mdr;
        end

    endcase
end

always_comb begin : next_state_logic
    /* Default next state assignment */
    next_state = state;

    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)

        s_mem_access_1: begin
            if (opcode == op_ldi || opcode == op_sti)
                next_state = s_mem_access_2;
        end

        s_mem_access_2: begin
            next_state = s_mem_access_1;
        end

    endcase // state
end

always_ff @(posedge clk) begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : mem_access_controller