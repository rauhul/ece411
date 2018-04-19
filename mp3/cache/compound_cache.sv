module compound_cache (
    /* SLAVES */
    wishbone.slave instruction_memory_wishbone,
    wishbone.slave data_memory_wishbone,

    /* MASTERS */
    wishbone.master physical_memory_wishbone,

    /* debug */
    output logic debug_i_cache_hit,
    output logic debug_i_cache_miss,
    output logic debug_d_cache_hit,
    output logic debug_d_cache_miss,
    output logic debug_l2_cache_hit,
    output logic debug_l2_cache_miss
);

logic clk;
assign clk = physical_memory_wishbone.CLK;

wishbone i_cache_memory_wishbone(clk);
wishbone d_cache_memory_wishbone(clk);
wishbone cache_arbiter_memory_wishbone(clk);
wishbone _cache_arbiter_memory_wishbone(clk);
wishbone l2_cache_memory_wishbone(clk);

readonly_cache #(
    .NUM_LINES(8),
    .ASSOCIATIVITY(2)
) i_cache (
    /* SLAVES */
    .input_wishbone(instruction_memory_wishbone),

    /* MASTERS */
    .output_wishbone(i_cache_memory_wishbone),

    /* debug */
    .debug_cache_hit(debug_i_cache_hit),
    .debug_cache_miss(debug_i_cache_miss)
);

cache #(
    .NUM_LINES(8),
    .ASSOCIATIVITY(2)
) d_cache (
    /* SLAVES */
    .input_wishbone(data_memory_wishbone),

    /* MASTERS */
    .output_wishbone(d_cache_memory_wishbone),

    /* debug */
    .debug_cache_hit(debug_d_cache_hit),
    .debug_cache_miss(debug_d_cache_miss)
);

cache_arbiter _cache_arbiter (
    /* SLAVES */
    .input_wishbone0(i_cache_memory_wishbone),
    .input_wishbone1(d_cache_memory_wishbone),

    /* MASTERS */
    .output_wishbone(cache_arbiter_memory_wishbone)
);

barrier_wishbone _barrier_wishbone (
    .clk,

    /* SLAVES */
    .input_wishbone(cache_arbiter_memory_wishbone),

    /* MASTERS */
    .output_wishbone(_cache_arbiter_memory_wishbone)
);

eviction_buffered_cache #(
    .NUM_LINES(8),
    .ASSOCIATIVITY(4)
) l2_cache (
    /* SLAVES */
    .input_wishbone(_cache_arbiter_memory_wishbone),

    /* MASTERS */
    .output_wishbone(l2_cache_memory_wishbone),

    /* debug */
    .debug_cache_hit(debug_l2_cache_hit),
    .debug_cache_miss(debug_l2_cache_miss)
);

barrier_wishbone _barrier_wishbone_2 (
    .clk,

    /* SLAVES */
    .input_wishbone(l2_cache_memory_wishbone),

    /* MASTERS */
    .output_wishbone(physical_memory_wishbone)
);

endmodule : compound_cache
