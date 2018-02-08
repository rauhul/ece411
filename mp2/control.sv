import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    /* INPUTS */
    /* global->control */
    input clk,

    /* datapath->control */
    input lc3b_opcode opcode,
    input inst4,
    input inst5,
    input inst11,
    input branch_enable,

    /* datapath->memory (hijack) */
    input lc3b_word mem_address,

    /* memory->control */
    input mem_resp,

    /* OUTPUTS */
    /* control->data */
    output logic load_pc,
    output logic load_ir,
    output logic load_regfile,
    output logic load_mar,
    output logic load_mdr,
    output logic load_cc,
    output logic brmux_sel,
    output logic [1:0] pcmux_sel,
    output logic storemux_sel,
    output logic destmux_sel,
    output logic [2:0] alumux_sel,
    output logic [2:0] regfilemux_sel,
    output logic [1:0] marmux_sel,
    output logic mdrmux_sel,
    output lc3b_aluop aluop,

    /* control->memory */
    output logic mem_read,
    output logic mem_write,
    output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    /* List of states */
    s_fetch1,
    s_fetch2,
    s_fetch3,
    s_decode,

    /* simple ops */
    s_add,
    s_and,
    s_not,
    s_shf,

    /* jumps */
    s_br,
    s_br_taken,
    s_jmp,
    s_jsr,
    s_lea,

    /* mem access */
    s_calc_addr_b,
    s_ldb1,
    s_ldb2,
    s_stb1,
    s_stb2,

    s_calc_addr_w,
    s_ldi1,
    s_ldi2,
    s_ldi3,
    s_ldi4,
    s_sti1,
    s_sti2,
    s_sti3,
    s_sti4,
    s_ldr1,
    s_ldr2,
    s_str1,
    s_str2,

    /* other */
    s_trap1,
    s_trap2,
    s_trap3

} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    load_pc         = 1'b0;
    load_ir         = 1'b0;
    load_regfile    = 1'b0;
    load_mar        = 1'b0;
    load_mdr        = 1'b0;
    load_cc         = 1'b0;
    brmux_sel       = 1'b0;
    pcmux_sel       = 2'b00;
    storemux_sel    = 1'b0;
    destmux_sel     = 1'b0;
    alumux_sel      = 3'b000;
    regfilemux_sel  = 3'b000;
    marmux_sel      = 2'b00;
    mdrmux_sel      = 1'b0;
    aluop           = alu_add;
    mem_read        = 1'b0;
    mem_write       = 1'b0;
    mem_byte_enable = 2'b11;

    /* Actions for each state */
    case(state)

        s_fetch1: begin
            //MAR←PC;
            marmux_sel = 2'b01;
            load_mar = 1;

            //PC←PC+2;
            pcmux_sel = 2'b00;
            load_pc = 1;
        end

        s_fetch2: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_fetch3: begin
            // IR←MDR;
            load_ir = 1;
        end

        s_decode: begin
            // NONE
        end

        /* simple ops */
        s_add: begin
            // DR←A+B;
            // DR←A+sext(imm5);
            storemux_sel = 0;
            if (inst5 == 0)
                alumux_sel = 3'b000;
            else
                alumux_sel = 3'b001;
            aluop = alu_add;
            regfilemux_sel = 3'b000;
            load_cc = 1;
            load_regfile = 1;
        end

        s_and: begin
            // DR←A&B;
            // DR←A&sext(imm5);
            storemux_sel = 0;
            if (inst5 == 0)
                alumux_sel = 3'b000;
            else
                alumux_sel = 3'b001;
            aluop = alu_and;
            regfilemux_sel = 3'b000;
            load_cc = 1;
            load_regfile = 1;
        end

        s_not: begin
            // DR←NOT(A);
            storemux_sel = 0;
            aluop = alu_not;
            regfilemux_sel = 3'b000;
            load_cc = 1;
            load_regfile = 1;
        end

        s_shf: begin
            // DR←       SR«imm4;
            // DR←   [0],SR»imm4;
            // DR←SR[15],SR»imm4;

            storemux_sel = 0;
            alumux_sel = 3'b011;
            if (inst4 == 0)
                aluop = alu_sll;
            else
                if (inst5 == 0)
                    aluop = alu_srl;
                else
                    aluop = alu_sra;
            regfilemux_sel = 3'b000;
            load_cc = 1;
            load_regfile = 1;
        end

        /* jumps */
        s_br: begin
            // NONE
        end

        s_br_taken: begin
            // PC←PC+SEXT(IR[8:0]«1);
            brmux_sel = 0;
            pcmux_sel = 2'b01;
            load_pc = 1;
        end

        s_jmp: begin
            // PC←SR1;
            pcmux_sel = 2'b10;
            load_pc = 1;
        end

        s_jsr: begin
            // R7←PC;
            // PC←SR1;
            // PC←PC+SEXT(IR[10:0]«1);
            regfilemux_sel = 3'b011; // sel pc
            destmux_sel = 1; // sel R7
            load_regfile = 1; // load reg

            brmux_sel = 1;
            if (inst11 == 0)
                pcmux_sel = 2'b10;
            else
                pcmux_sel = 2'b01;
            load_pc = 1;
        end

        s_lea: begin
            // DR←PC+SEXT(IR[8:0]«1);
            brmux_sel = 0;
            regfilemux_sel = 3'b010;
            load_cc = 1;
            load_regfile = 1;
        end

        /* mem access */
        s_calc_addr_b: begin
            // MAR←A+SEXT(IR[5:0]);
            alumux_sel = 3'b100;
            aluop = alu_add;
            marmux_sel = 2'b00;
            load_mar = 1;
        end

        s_ldb1: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_ldb2: begin
            // DR←MDR_L;
            // DR←MDR_U;
            if (mem_address[0] == 0)
                regfilemux_sel = 3'b100;
            else
                regfilemux_sel = 3'b101;
            load_cc = 1;
            load_regfile = 1;
        end

        s_stb1: begin
            storemux_sel = 1;
            alumux_sel = 3'b101; //8 bit shift
            if (mem_address[0] == 0)
                aluop = alu_pass;
            else
                aluop = alu_sll;
            mdrmux_sel = 0;
            load_mdr = 1;
        end

        s_stb2: begin
            mem_write = 1;
            if (mem_address[0] == 0)
                mem_byte_enable = 2'b01;
            else
                mem_byte_enable = 2'b10;
        end

        s_calc_addr_w: begin
            // MAR←A+SEXT(IR[5:0]«1);
            alumux_sel = 3'b010;
            aluop = alu_add;
            marmux_sel = 2'b00;
            load_mar = 1;
        end

        s_ldi1: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_ldi2: begin
            // MAR←MDR;
            marmux_sel = 2'b10;
            load_mar = 1;
        end

        s_ldi3: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_ldi4: begin
            // DR←MDR;
            regfilemux_sel = 3'b001;
            load_cc = 1;
            load_regfile = 1;
        end

        s_sti1: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_sti2: begin
            // MAR←MDR;
            marmux_sel = 2'b10;
            load_mar = 1;
        end

        s_sti3: begin
            // MDR←SR;
            storemux_sel = 1;
            aluop = alu_pass;
            mdrmux_sel = 0;
            load_mdr = 1;
        end

        s_sti4: begin
            // M[MAR]←MDR;
            mem_write = 1;
        end

        s_ldr1: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_ldr2: begin
            // DR←MDR;
            regfilemux_sel = 3'b001;
            load_cc = 1;
            load_regfile = 1;
        end

        s_str1: begin
            // MDR←SR;
            storemux_sel = 1;
            aluop = alu_pass;
            mdrmux_sel = 0;
            load_mdr = 1;
        end

        s_str2: begin
            // M[MAR]←MDR;
            mem_write = 1;
        end

        /* other */
        s_trap1: begin
            // R7←PC;
            destmux_sel = 1;
            load_regfile = 1;
            regfilemux_sel = 3'b011;
            // MAR←ZEXT(trapvect8«1);
            marmux_sel = 2'b11;
            load_mar = 1;
        end

        s_trap2: begin
            // MDR←M[MAR];
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end

        s_trap3: begin
            // PC←MDR
            pcmux_sel = 2'b11;
            load_pc = 1;
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

        s_fetch1: begin
            next_state = s_fetch2;
        end

        s_fetch2: begin
            if (mem_resp == 1)
                next_state = s_fetch3;
        end

        s_fetch3: begin
            next_state = s_decode;
        end

        s_decode: begin
            case(opcode)
            op_add: next_state = s_add;
            op_and: next_state = s_and;
            op_not: next_state = s_not;
            op_shf: next_state = s_shf;

            op_br:  next_state = s_br;
            op_jmp: next_state = s_jmp;
            op_jsr: next_state = s_jsr;
            op_lea: next_state = s_lea;

            op_ldb: next_state = s_calc_addr_b;
            op_stb: next_state = s_calc_addr_b;
            op_ldi: next_state = s_calc_addr_w;
            op_sti: next_state = s_calc_addr_w;
            op_ldr: next_state = s_calc_addr_w;
            op_str: next_state = s_calc_addr_w;

            op_trap: next_state = s_trap1;
            default: $display("Unknown opcode");
            endcase
        end

        /* simple ops */
        s_add: begin
            next_state = s_fetch1;
        end

        s_and: begin
            next_state = s_fetch1;
        end

        s_not: begin
            next_state = s_fetch1;
        end

        s_shf: begin
            next_state = s_fetch1;
        end

        /* jumps */
        s_br: begin
            if (branch_enable == 1)
                next_state = s_br_taken;
            else
                next_state = s_fetch1;
        end

        s_br_taken: begin
            next_state = s_fetch1;
        end

        s_jmp: begin
            next_state = s_fetch1;
        end

        s_jsr: begin
            next_state = s_fetch1;
        end

        s_lea: begin
            next_state = s_fetch1;
        end

        /* mem access */
        s_calc_addr_b: begin
            if (opcode == op_ldb)
                next_state = s_ldb1;
            else
                next_state = s_stb1;
        end

        s_ldb1: begin
            if (mem_resp == 1)
                next_state = s_ldb2;
        end

        s_ldb2: begin
            next_state = s_fetch1;
        end

        s_stb1: begin
            next_state = s_stb2;
        end

        s_stb2: begin
            if (mem_resp == 1)
                next_state = s_fetch1;
        end

        s_calc_addr_w: begin
            if (opcode == op_ldr)
                next_state = s_ldr1;
            else if (opcode == op_str)
                next_state = s_str1;
            else if (opcode == op_ldi)
                next_state = s_ldi1;
            else
                next_state = s_sti1;
        end

        s_ldi1: begin
            if (mem_resp == 1)
                next_state = s_ldi2;
        end

        s_ldi2: begin
            next_state = s_ldi3;
        end

        s_ldi3: begin
            if (mem_resp == 1)
                next_state = s_ldi4;
        end

        s_ldi4: begin
            next_state = s_fetch1;
        end

        s_sti1: begin
            if (mem_resp == 1)
                next_state = s_sti2;
        end

        s_sti2: begin
            next_state = s_sti3;
        end

        s_sti3: begin
            next_state = s_sti4;
        end

        s_sti4: begin
            if (mem_resp == 1)
                next_state = s_fetch1;
        end

        s_ldr1: begin
            if (mem_resp == 1)
                next_state = s_ldr2;
        end

        s_ldr2: begin
            next_state = s_fetch1;
        end

        s_str1: begin
            next_state = s_str2;
        end

        s_str2: begin
            if (mem_resp == 1)
                next_state = s_fetch1;
        end

        /* other */
        s_trap1: begin
            next_state = s_trap2;
        end

        s_trap2: begin
            if (mem_resp == 1)
                next_state = s_trap3;
        end

        s_trap3: begin
            next_state = s_fetch1;
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
