module testbench_skeleton();

timeunit 10ns;			// Time scale for delays. 
							// #1 -> 10ns
							
timeprecision 1ns;		// Time precision for delays. 
							// #1.12345 - > 11.2345ns -> 11ns (delays are rounded to the nearest 'timeprecision')
							
// Put internal wires and registers here:
logic Clk;

// Instantiate modules and connect them here:


// Initialize the clock
initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 
// Toggle the clock after every 'timeunit' has passed
// A timeunit of 5ns gives a 100MHz clock
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

// The unit tests happen here:
initial begin: TEST_VECTORS

end						

endmodule : testbench_skeleton