import lc3b_types::*;

module mp2
(
    wishbone.master wb
);

cpu _cpu
(
    .clk(wb.CLK),

    /* Memory signals */
    .mem_resp,
    .mem_rdata,
    .mem_read,
    .mem_write,
    .mem_byte_enable,
    .mem_address,
    .mem_wdata
);

// cache _cache
// (

// );

endmodule : mp2
