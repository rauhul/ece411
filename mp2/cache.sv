module cache (
    input clk,

    /* CPU -> Cache */
    input mem_read,
    input mem_write,
    input lc3b_mem_wmask mem_byte_enable,
    input lc3b_word mem_address,
    input lc3b_word mem_wdata,

    /* Cache -> CPU */
    output mem_resp,
    output lc3b_word mem_rdata,

    /* Cache <-> Memory */
    wishbone.master wb
);

endmodule