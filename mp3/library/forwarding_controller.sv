import lc3b_types::*;

module forwarding_controller (
    // input lc3b_opcode barrier_ID_EX_opcode,
    // input lc3b_opcode barrier_EX_MEM_opcode,
    // input lc3b_opcode barrier_MEM_WB_opcode,

    // input lc3b_control_word barrier_ID_EX_control,
    // input lc3b_control_word barrier_EX_MEM_control,
    // input lc3b_control_word barrier_MEM_WB_control,

    input lc3b_word ir_curr,
    input lc3b_word ir_EX_MEM,
    input lc3b_word ir_MEM_WB,
    input lc3b_reg sr1,
    input lc3b_reg sr2,

    output logic [1:0] forward_A,
    output logic [1:0] forward_B
);

lc3b_opcode opcode_curr;
lc3b_opcode opcode_EX_MEM;
lc3b_opcode opcode_MEM_WB;
lc3b_reg DR_EX_MEM ;
lc3b_reg DR_MEM_WB ;
assign opcode_curr   = lc3b_opcode'(ir_curr[15:12]);
assign opcode_EX_MEM = lc3b_opcode'(ir_EX_MEM[15:12]);
assign opcode_MEM_WB = lc3b_opcode'(ir_MEM_WB[15:12]);
assign DR_EX_MEM     = ir_EX_MEM[11:9];
assign DR_MEM_WB     = ir_MEM_WB[11:9];

/* forward_A is for sr1 and forward_B is for sr2*/
/* 2'b00 - no forwarding */
/* 2'b01 - forward data from EX_MEM */
/* 2'b10 - forward data from MEM_WB */

/* flags indicating if the two previous instructions has dest register*/
logic EX_MEM_has_DR;
logic MEM_WB_has_DR;

always_comb begin
    forward_A     = 2'b00;
    forward_B     = 2'b00;
    EX_MEM_has_DR = 0;
    MEM_WB_has_DR = 0;
    if(opcode_EX_MEM == op_add || opcode_EX_MEM == op_and || opcode_EX_MEM == op_ldb || opcode_EX_MEM == op_ldi || opcode_EX_MEM == op_ldr || opcode_EX_MEM == op_lea ||
        opcode_EX_MEM == op_not || opcode_EX_MEM == op_shf) begin
        EX_MEM_has_DR = 1;
    end
    if(opcode_MEM_WB == op_add || opcode_MEM_WB == op_and || opcode_MEM_WB == op_ldb || opcode_MEM_WB == op_ldi || opcode_MEM_WB == op_ldr || opcode_MEM_WB == op_lea ||
        opcode_MEM_WB == op_not || opcode_MEM_WB == op_shf) begin
        MEM_WB_has_DR = 1;
    end
    /* Assign control signals based on opcode */
    case (opcode_curr)
        /* ALU OPS */
        op_add : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
                if(DR_MEM_WB == sr2) begin
                    forward_B = 2'b10;
                end
            end
            if(EX_MEM_has_DR)begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
                if(DR_EX_MEM == sr2) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_B = 2'b11;
                    else forward_B = 2'b01;
                end
            end
        end

        op_and : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
                if(DR_MEM_WB == sr2) begin
                    forward_B = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
                if(DR_EX_MEM == sr2) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_B = 2'b11;
                    else forward_B = 2'b01;
                end
            end
        end

        //op_lea: begin
        //end

        op_not : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        op_shf : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        /* DATA MEMORY OPS */
        /* LOAD */
        op_ldb : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        op_ldi : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        op_ldr : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        /* STORE */
        op_stb : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
                if(DR_MEM_WB == sr2) begin
                    forward_B = 2'b10;
                end
            end
            if(EX_MEM_has_DR)begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
                if(DR_EX_MEM == sr2) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_B = 2'b11;
                    else forward_B = 2'b01;
                end
            end
        end

        op_sti : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
                if(DR_MEM_WB == sr2) begin
                    forward_B = 2'b10;
                end
            end
            if(EX_MEM_has_DR)begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
                if(DR_EX_MEM == sr2) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_B = 2'b11;
                    else forward_B = 2'b01;
                end
            end
        end

        op_str : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
                if(DR_MEM_WB == sr2) begin
                    forward_B = 2'b10;
                end
            end
            if(EX_MEM_has_DR)begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
                if(DR_EX_MEM == sr2) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_B = 2'b11;
                    else forward_B = 2'b01;
                end
            end
        end

        /* PC CHANGING OPS */
        //op_br: begin
        //end

        op_jmp : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        op_jsr : begin
            if(MEM_WB_has_DR) begin
                if(DR_MEM_WB == sr1) begin
                    forward_A = 2'b10;
                end
            end
            if(EX_MEM_has_DR) begin
                if(DR_EX_MEM == sr1) begin
                    if(opcode_EX_MEM == op_lea)
                        forward_A = 2'b11;
                    else forward_A = 2'b01;
                end
            end
        end

        //op_trap: begin
        //end
        default : begin
            //control_out = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end

endmodule : forwarding_controller
