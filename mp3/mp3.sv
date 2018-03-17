import lc3b_types::*;

module mp3 (
    input clk,

    /* MASTERS */
    wishbone.master physical_memory_wishbone
);

wishbone instruction_memory_wishbone(clk);
wishbone data_memory_wishbone(clk);

cpu _cpu (
    .clk,

    /* MASTERS */
    .instruction_memory_wishbone,
    .data_memory_wishbone
);

cache _cache (
    .clk,

    /* SLAVES */
    .instruction_memory_wishbone,
    .data_memory_wishbone,

    /* MASTERS */
    .physical_memory_wishbone
);

endmodule : mp3
