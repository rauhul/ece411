import lc3b_types::*;

module mp2
(
    wishbone.master wb
);

logic mem_resp;
lc3b_word mem_rdata;
logic mem_read;
logic mem_write;
lc3b_mem_wmask mem_byte_enable;
lc3b_word mem_address;
lc3b_word mem_wdata;

cpu _cpu
(
    .clk(wb.CLK),

    /* Cache -> CPU */
    .mem_resp,
    .mem_rdata,

    /* CPU -> Cache */
    .mem_read,
    .mem_write,
    .mem_byte_enable,
    .mem_address,
    .mem_wdata
);

cache _cache
(
    .clk(wb.CLK),

    /* CPU -> Cache */
    .mem_read,
    .mem_write,
    .mem_byte_enable,
    .mem_address,
    .mem_wdata,

    /* Cache -> CPU */
    .mem_resp,
    .mem_rdata,

    /* Cache <-> Memory */
    .wb
);

endmodule : mp2
