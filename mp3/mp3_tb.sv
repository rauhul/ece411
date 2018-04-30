module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

/* Clock generator */
logic clk;
initial clk = 0;
always #5 clk = ~clk;

wishbone physical_memory_wishbone(clk);

mp3 dut (
    .physical_memory_wishbone
);

physical_memory memory (
    .physical_memory_wishbone
);

endmodule : mp3_tb