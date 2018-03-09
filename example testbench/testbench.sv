module testbench();

timeunit 10ns;			// Time scale for delays.
							// #1 -> 10ns

timeprecision 1ns;		// Time precision for delays.
							// #1.12345 - > 11.2345ns -> 11ns (delays are rounded to the nearest 'timeprecision')

// Put internal wires and registers here:
integer ErrorCnt = 0;
logic Clk;
logic A;
logic B;
logic F;

// Instantiate modules and connect them here:
xor2 xor_gate(
	.a(A),
	.b(B),
	.f(F)
);

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
// A = 0, B = 0 -> F = 0
A = 0;
B = 0;
#2 if(F != 0)
		ErrorCnt++;

// A = 1, B = 0 -> F = 1
#2 A = 1;
#2 if(F != 1)
		ErrorCnt++;

// A = 0, B = 1 -> F = 1
#2 A = 0;
	B = 1;
#2 if(F != 1)
		ErrorCnt++;

// A = 1, B = 1 -> F = 0
#2 A = 1;
#2 if(F != 0)
		ErrorCnt++;

// Print error messages
if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);

end

endmodule : testbench