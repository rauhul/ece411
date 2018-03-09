module magic_memory
(
    wishbone.slave ifetch, // instruction fetch stage, assumed to never write
	 wishbone.slave memory // memory stage
);

timeunit 1ns;
timeprecision 1ns;

logic [127:0] mem [0:(2**12)-1];
logic [127:0] wdata;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end


assign ifetch.DAT_S = mem[ifetch.ADR];
assign ifetch.ACK = 1'b1;
assign ifetch.RTY = 1'b0;
assign memory.DAT_S = mem[memory.ADR];
assign memory.ACK = 1'b1;
assign memory.RTY = 1'b0;

enum int unsigned {
    idle,
    busy,
    respond,
	 strobe
} state, next_state;

always_comb
begin
	for (int i = 0; i < 16; i++)
		wdata[i*8 +:8] = memory.SEL[i] ? memory.DAT_M[i*8 +:8] : mem[memory.ADR][i*8 +:8];
end

always @(posedge memory.CLK)
begin
	if (memory.WE)
		mem[memory.ADR] <= wdata;
end

endmodule : magic_memory
