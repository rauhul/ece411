module cache (
    /* SLAVES */
    wishbone.slave instruction_memory_wishbone,
    wishbone.slave data_memory_wishbone,

    /* MASTERS */
    wishbone.master physical_memory_wishbone
);

logic clk;
assign clk = physical_memory_wishbone.CLK;

wishbone i_cache_memory_wishbone(clk);
wishbone d_cache_memory_wishbone(clk);

cache_l1 i_cache (
    /* SLAVES */
    .input_wishbone(instruction_memory_wishbone),

    /* MASTERS */
    .output_wishbone(i_cache_memory_wishbone)
);

cache_l1 d_cache (
    /* SLAVES */
    .input_wishbone(data_memory_wishbone),

    /* MASTERS */
    .output_wishbone(d_cache_memory_wishbone)
);

cache_arbiter _cache_arbiter (
    /* SLAVES */
    .input_wishbone0(i_cache_memory_wishbone),
    .input_wishbone1(d_cache_memory_wishbone),

    /* MASTERS */
    .output_wishbone(physical_memory_wishbone)
);

// cache_l2 _cache_l2 ();

endmodule : cache
