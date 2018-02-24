import lc3b_types::*;

module mp2
(
    wishbone.master memory_wishbone
);

wishbone cache_wishbone(memory_wishbone.CLK);

cpu _cpu
(
    /* CPU <-> Cache */
    .memory_wishbone(cache_wishbone)
);

cache _cache
(
    /* CPU <-> Cache */
    .cpu_wishbone(cache_wishbone),

    /* Cache <-> Memory */
    .memory_wishbone
);

endmodule : mp2
