import lc3b_types::*;

module mp3 (
    /* MASTERS */
    wishbone.master physical_memory_wishbone
);

logic clk;
assign clk = physical_memory_wishbone.CLK;

wishbone instruction_memory_wishbone(clk);
wishbone data_memory_wishbone(clk);

cpu _cpu (
    /* MASTERS */
    .instruction_memory_wishbone,
    .data_memory_wishbone
);

compound_cache _compound_cache (
    /* SLAVES */
    .instruction_memory_wishbone,
    .data_memory_wishbone,

    /* MASTERS */
    .physical_memory_wishbone
);

endmodule : mp3
