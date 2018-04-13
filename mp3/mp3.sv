import lc3b_types::*;

module mp3 (
    /* MASTERS */
    wishbone.master physical_memory_wishbone
);

logic clk;
assign clk = physical_memory_wishbone.CLK;

wishbone instruction_memory_wishbone(clk);
wishbone data_memory_wishbone(clk);

logic debug_i_cache_hit;
logic debug_i_cache_miss;
logic debug_d_cache_hit;
logic debug_d_cache_miss;
logic debug_l2_cache_hit;
logic debug_l2_cache_miss;

cpu _cpu (
    /* MASTERS */
    .instruction_memory_wishbone,
    .data_memory_wishbone,

    /* debug */
    .debug_i_cache_hit,
    .debug_i_cache_miss,
    .debug_d_cache_hit,
    .debug_d_cache_miss,
    .debug_l2_cache_hit,
    .debug_l2_cache_miss
);

compound_cache _compound_cache (
    /* SLAVES */
    .instruction_memory_wishbone,
    .data_memory_wishbone,

    /* MASTERS */
    .physical_memory_wishbone,

    /* debug */
    .debug_i_cache_hit,
    .debug_i_cache_miss,
    .debug_d_cache_hit,
    .debug_d_cache_miss,
    .debug_l2_cache_hit,
    .debug_l2_cache_miss
);

endmodule : mp3
