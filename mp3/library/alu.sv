import lc3b_types::*;

module alu
(
    input lc3b_alu_op aluop,
    input lc3b_word a, b,
    output lc3b_word f
);

always_comb
begin
    case (aluop)
        lc3b_alu_op_add: f = a + b;
        lc3b_alu_op_and: f = a & b;
        lc3b_alu_op_not: f = ~a;
        lc3b_alu_op_pass: f = a;
        lc3b_alu_op_sll: f = a << b;
        lc3b_alu_op_srl: f = a >> b;
        lc3b_alu_op_sra: f = $signed(a) >>> b;
        default: $display("Unknown aluop");
    endcase
end

endmodule : alu
