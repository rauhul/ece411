module cache_arbiter (
    /* SLAVES */
    wishbone.slave input_wishbone0,
    wishbone.slave input_wishbone1,

    /* MASTERS */
    wishbone.master output_wishbone
);



endmodule : cache_arbiter
