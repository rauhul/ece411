module barrier_wishbone_master (
    /* INPUTS */
    input clk,

    input logic [127:0] DAT_M_in,
    input logic CYC_in,
    input logic STB_in,
    input logic WE_in,
    input logic [15:0] SEL_in,
    input logic [11:0] ADR_in,

    /* OUTPUTS */
    output logic [127:0] DAT_M_out,
    output logic CYC_out,
    output logic STB_out,
    output logic WE_out,
    output logic [15:0] SEL_out,
    output logic [11:0] ADR_out
);

logic [127:0] DAT_M;
logic CYC;
logic STB;
logic WE;
logic [15:0] SEL;
logic [11:0] ADR;

initial begin
    DAT_M = 0;
    CYC = 0;
    STB = 0;
    WE = 0;
    SEL = 0;
    ADR = 0;
end

always_ff @(posedge clk) begin
    DAT_M = DAT_M_in;
    CYC = CYC_in;
    STB = STB_in;
    WE = WE_in;
    SEL = SEL_in;
    ADR = ADR_in;
end

assign DAT_M_out = DAT_M;
assign CYC_out = CYC;
assign STB_out = STB;
assign WE_out = WE;
assign SEL_out = SEL;
assign ADR_out = ADR;

endmodule : barrier_wishbone_master
