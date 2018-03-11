import lc3b_types::*;

module mp3 (
    /* INPUTS */
    input clk,

    /* OUTPUTS */

    /* MEMORY INTERFACE */
    wishbone.master instruction_memory_wishbone,
    wishbone.master data_memory_wishbone
);

cpu _cpu (
    .clk,
    .instruction_memory_wishbone,
    .data_memory_wishbone
);

// caches will go here

endmodule
