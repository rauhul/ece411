module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

wishbone instruction_memory_wishbone(clk);
wishbone data_memory_wishbone(clk);

mp3 dut (
    .clk,
    .instruction_memory_wishbone,
    .data_memory_wishbone
);

magic_memory memory (
    .ifetch(instruction_memory_wishbone),
    .memory(data_memory_wishbone)
);

endmodule : mp3_tb