module physical_memory (
    wishbone.slave wb
);

timeunit 1ns;
timeprecision 1ns;

parameter DELAY_MEM = 200;

logic [127:0] mem             [0:(2**12)-1];
logic [ 11:0] internal_address             ;
logic [127:0] data, wdata;
logic         ready, resp;

/* Initialize memory contents from memory.lst file */
initial
    begin
        $readmemh("memory.lst", mem);
    end

assign wb.ACK   = resp;
assign wb.RTY   = wb.STB & wb.CYC & (!resp);
assign wb.DAT_S = data;

enum int unsigned {
    idle,
    busy,
    respond,
    strobe
} state, next_state;

always_comb begin
    for (int i = 0; i < 16; i++)
        wdata[i*8+:8] = wb.SEL[i]?wb.DAT_M[i*8+:8] : mem[internal_address][i*8 +:8];

    /* Default */
    data       = 128'bX;
    next_state = state;
    resp       = 1'b0;
    case(state)
        idle : begin
            if (wb.CYC & wb.STB)
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
            if ((wb.ADR == internal_address) && (!wb.WE))
                data = mem[internal_address];
        end
        strobe : begin
            if ((wb.STB == 0) || (wb.CYC == 0))
                next_state = idle;
        end
        default : next_state = idle;
    endcase
end

always @(posedge wb.CLK) begin
    case(state)
        idle : begin
            if (wb.CYC & wb.STB) begin
                internal_address <= wb.ADR;
                ready            <= #DELAY_MEM 1;
            end
        end

        respond : begin
            //bad things happen if you change the address in the middle of the transaction
            if ((wb.ADR == internal_address) && wb.WE)
                mem[internal_address] <= wdata;
            ready <= 0;
        end

        default : ;
    endcase
end

always_ff @(posedge wb.CLK) begin : next_state_assignment
    state <= next_state;
end

endmodule : physical_memory
