module cache_lru #(
    parameter ASSOCIATIVITY = 2, // Min 2, must be power of 2
    parameter NUM_LINES = 2      // Min 2, must be power of 2
) (
    /* INPUTS */
    input clk,
    input logic [$clog2(ASSOCIATIVITY)-1:0] mru_in, // compact form representation
    input logic [$clog2(NUM_LINES)-1:0] index_in,
    input logic load_in,

    /* OUTPUTS */
    output logic [$clog2(ASSOCIATIVITY)-1:0] lru_out // compact form representation
);

// mru expanded form representation
logic [$clog2(NUM_LINES)-1:0] [ASSOCIATIVITY-1:0] mru_efr;

// mru_in expanded form representation
logic [ASSOCIATIVITY-1:0] mru_in_efr;

// mru_out expanded form representation
logic [ASSOCIATIVITY-1:0] mru_out_efr;


initial begin
    for (int i = 0; i < 8; i++)
        mru_efr[i] = 0;
end


// DECODE mru_in efr -> cfr
always_comb begin


end

// ENCODE lru_out (mru) efr -> cfr
always_comb begin
    lru_out[$clog2(ASSOCIATIVITY)-1] = ~mru_efr[index_in][ASSOCIATIVITY-2];
    int base = (ASSOCIATIVITY-2)-1;
    for (int i = $clog2(ASSOCIATIVITY)-2; i >= 0; i--) begin
        lru_out[i] = ~mru_efr[base - lru_out[$clog2(ASSOCIATIVITY)-1:i+1]];
        base -= 2**($clog2(ASSOCIATIVITY)-1-i);
    end
end

always_ff @(posedge clk) begin : load_logic
    if (load_in) begin
        mru_efr[index_in] = mru_in_efr;
    end
end

// always_comb begin
//     mru_out_efr = mru_efr[index_in];
// end

endmodule : cache_lru
