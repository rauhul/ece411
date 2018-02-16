module mp2_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

wishbone memory_wishbone(clk);

mp2 dut
(
    .memory_wishbone
);

physical_memory memory
(
    .wb(memory_wishbone)
);

endmodule : mp2_tb
