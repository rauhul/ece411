module physical_memory (
    wishbone.slave physical_memory_wishbone
);

timeunit 1ns;
timeprecision 1ns;

parameter DELAY_MEM = 200;

logic [127:0] mem             [0:(2**12)-1];
logic [ 11:0] internal_address             ;
logic [127:0] data, wdata;
logic         ready, resp;

/* Initialize memory contents from memory.lst file */
initial begin
    $readmemh("memory.lst", mem);
end

assign physical_memory_wishbone.ACK   = resp;
assign physical_memory_wishbone.RTY   = physical_memory_wishbone.STB & physical_memory_wishbone.CYC & (!resp);
assign physical_memory_wishbone.DAT_S = data;

enum int unsigned {
    idle,
    busy,
    respond,
    strobe
} state, next_state;

always_comb begin
    for (int i = 0; i < 16; i++)
        wdata[i*8+:8] = physical_memory_wishbone.SEL[i] ? physical_memory_wishbone.DAT_M[i*8+:8] : mem[internal_address][i*8 +:8];

    /* Default */
    data       = 128'bX;
    next_state = state;
    resp       = 1'b0;
    case(state)
        idle : begin
            if (physical_memory_wishbone.CYC & physical_memory_wishbone.STB)
                next_state = busy;
        end
        busy : begin
            if (ready == 1)
                next_state = respond;
        end
        respond : begin
            next_state = strobe;
            resp       = 1'b1;
            //bad things happen if you change the address in the middle of the transaction
            if ((physical_memory_wishbone.ADR == internal_address) && (!physical_memory_wishbone.WE))
                data = mem[internal_address];
        end
        strobe : begin
            if ((physical_memory_wishbone.STB == 0) || (physical_memory_wishbone.CYC == 0))
                next_state = idle;
        end
        default : next_state = idle;
    endcase
end

always @(posedge physical_memory_wishbone.CLK) begin
    case(state)
        idle : begin
            if (physical_memory_wishbone.CYC & physical_memory_wishbone.STB) begin
                internal_address <= physical_memory_wishbone.ADR;
                ready            <= #DELAY_MEM 1;
            end
        end

        respond : begin
            //bad things happen if you change the address in the middle of the transaction
            if ((physical_memory_wishbone.ADR == internal_address) && physical_memory_wishbone.WE)
                mem[internal_address] <= wdata;
            ready <= 0;
        end

        default : ;
    endcase
end

always_ff @(posedge physical_memory_wishbone.CLK) begin : next_state_assignment
    state <= next_state;
end

endmodule : physical_memory
