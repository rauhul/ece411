module physical_memory
(
    wishbone.slave wb
);

timeunit 1ns;
timeprecision 1ns;

parameter DELAY_MEM = 200;

logic [127:0] mem [0:(2**12)-1];
logic [11:0] internal_address;
logic [127:0] data;
logic ready, resp;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

assign wb.ACK = resp;
assign wb.RTY = wb.STB & wb.CYC & (!resp);
assign wb.DAT_S = data;

enum int unsigned {
    idle,
    busy,
    respond
} state, next_state;

always @(posedge wb.CLK)
begin
    /* Default */
    resp = 1'b0;
	 data = 128'bX;

    next_state = state;

    case(state)
        idle: begin
            if (wb.CYC & wb.STB) begin
                next_state = busy;
					 internal_address = wb.ADR[15:4];
                ready <= #DELAY_MEM 1;
            end
        end

        busy: begin
            if (ready == 1) begin
                next_state = respond;
            end
        end

        respond: begin
		      //bad things happen if you change the address in the middle of the transaction
		      if (wb.ADR[15:4] == internal_address) begin
                if (wb.WE) begin
                    mem[internal_address] = wb.DAT_M;
                end else begin
					     data = mem[internal_address];
					 end
                resp = 1;
		      end
            ready <= 0;
            next_state = idle;
        end

        default: next_state = idle;
    endcase
end

always_ff @(posedge wb.CLK)
begin : next_state_assignment
    state <= next_state;
end

endmodule : physical_memory
