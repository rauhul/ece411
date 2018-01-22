import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    /* INPUTS */
    /* global->control */
    input clk,

    /* datapath->control */
    input lc3b_opcode opcode,
    input branch_enable,

    /* memory->control */
    input mem_resp,

    /* OUTPUTS */
    /* control->data */
    output load_pc,
    output load_ir,
    output load_regfile,
    output load_mar,
    output load_mdr,
    output load_cc,
    output pcmux_sel,
    output storemux_sel,
    output alumux_sel,
    output regfilemux_sel,
    output marmux_sel,
    output mdrmux_sel,
    output lc3b_aluop aluop,

    /* control->memory */
    output mem_read
    output mem_write
    output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
    fetch1,
    fetch2,
    fetch3,
    decode,
    s_add,
    s_and,
    s_not,
    br,
    br_taken,
    calc_addr,
    ldr1,
    ldr2,
    str1,
    str2,
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    load_pc         = 1’b0;
    load_ir         = 1’b0;
    load_regfile    = 1’b0;
    load_mar        = 1’b0;
    load_mdr        = 1’b0;
    load_cc         = 1’b0;
    pcmux_sel       = 1’b0;
    storemux_sel    = 1’b0;
    alumux_sel      = 1’b0;
    regfilemux_sel  = 1’b0;
    marmux_sel      = 1’b0;
    mdrmux_sel      = 1’b0;
    aluop           = alu_add;
    mem_read        = 1’b0;
    mem_write       = 1’b0;
    mem_byte_enable = 2’b11;

    /* Actions for each state */
    case(state)

        fetch1: begin
            //MAR←PC;
            marmux_sel = 1;
            load_mar = 1;

            //PC←PC+2;
            pcmux_sel = 0;
            load_pc = 1;
        end

        fetch2: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        fetch3: begin
            // IR←MDR;
            load_ir = 1;
        end

        decode: begin
            // NONE
        end

        s_add: begin
            // DR←A+B;
            storemux_sel = 0;
            alumux_sel = 0;
            aluop = alu_add;
            regfilemux_sel = 0;
            load_cc = 1;
            load_regfile = 1;
        end

        s_and: begin
            // DR←A&B;
            storemux_sel = 0;
            alumux_sel = 0;
            aluop = alu_and;
            regfilemux_sel = 0;
            load_cc = 1;
            load_regfile = 1;
        end

        s_not: begin
            // DR←NOT(A);
            storemux_sel = 0;
            aluop = alu_not;
            regfilemux_sel = 0;
            load_cc = 1;
            load_regfile = 1;
        end

        br: begin
            // NONE
        end

        br_taken: begin
            // PC←PC + SEXT(IR[8:0] « 1);
            pcmux_sel = 1;
            load_pc = 1;
        end

        calc_addr: begin
            // MAR←A + SEXT(IR[5:0] « 1);
            alumux_sel = 1;
            aluop = alu_add;
            marmux_sel = 0;
            load_mar = 1;
        end

        ldr1: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        ldr2: begin
            // DR←MDR;
            regfilemux_sel = 1;
            load_cc = 1;
            load_regfile = 1;
        end

        str1: begin
            // MDR←SR;
            storemux_sel = 1;
            aluop = alu_pass;
            mdrmux_sel = 0;
            load_mdr = 1;
        end

        str2: begin
            // M[MAR]←MDR;
            mem_write = 1;
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

        fetch1: begin
            next_state = fetch2;
        end

        fetch2: begin
            if (mem_resp == 1)
                next_state = fetch3;
        end

        fetch3: begin
            next_state = decode;
        end

        decode: begin
            case(opcode)
            op_add: next_state = s_add;
            op_and: next_state = s_and;
            op_not: next_state = s_not;
            op_br:  next_state = br;
            op_ldr: next_state = calc_addr;
            op_str: next_state = calc_addr;
            default: $display("Unknown opcode");
            endcase
        end

        s_add: begin
            next_state = fetch1;
        end

        s_and: begin
            next_state = fetch1;
        end

        s_not: begin
            next_state = fetch1;
        end

        br: begin
            if (branch_enable == 1)
                next_state = br_taken;
            else
                next_state = fetch1;
        end

        br_taken: begin
            next_state = fetch1;
        end

        calc_addr: begin
            // Should this be a switch?
            if (opcode == op_ldr)
                next_state = ldr1;
            else
                next_state = str1;
        end

        ldr1: begin
            if (mem_resp == 1)
                next_state = ldr2;
        end

        ldr2: begin
            next_state = fetch1;
        end

        str1: begin
            next_state = str2;
        end

        str2: begin
            if (mem_resp == 1)
                next_state = fetch1;
        end

        default: $display("Unknown state");

    endcase // state
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control
