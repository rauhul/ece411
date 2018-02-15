module mp2_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

wishbone wb(clk);

mp2 dut(wb);

physical_memory memory(wb);

endmodule : mp2_tb
