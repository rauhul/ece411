module barrier_wishbone (
    input clk,

    /* SLAVES */
    wishbone.slave input_wishbone,

    /* MASTERS */
    wishbone.master output_wishbone
);

barrier_wishbone_master _barrier_wishbone_master (
    .clk,

    /* INPUT */
    .DAT_M_in(input_wishbone.DAT_M),
    .CYC_in(input_wishbone.CYC),
    .STB_in(input_wishbone.STB),
    .WE_in(input_wishbone.WE),
    .SEL_in(input_wishbone.SEL),
    .ADR_in(input_wishbone.ADR),

    /* OUTPUT */
    .DAT_M_out(output_wishbone.DAT_M),
    .CYC_out(output_wishbone.CYC),
    .STB_out(output_wishbone.STB),
    .WE_out(output_wishbone.WE),
    .SEL_out(output_wishbone.SEL),
    .ADR_out(output_wishbone.ADR)
);

barrier_wishbone_slave _barrier_wishbone_slave (
    .clk,

    /* INPUT */
    .DAT_S_in(output_wishbone.DAT_S),
    .ACK_in(output_wishbone.ACK),
    .RTY_in(output_wishbone.RTY),

    /* OUTPUT */
    .DAT_S_out(input_wishbone.DAT_S),
    .ACK_out(input_wishbone.ACK),
    .RTY_out(input_wishbone.RTY)
);

endmodule : barrier_wishbone
