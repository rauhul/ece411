module cache_lru #(
    parameter ASSOCIATIVITY = 2, // Min 2, must be power of 2
    parameter NUM_LINES = 2      // Min 2, must be power of 2
) (
    /* INPUTS */
    input clk,
    input logic [$clog2(ASSOCIATIVITY)-1:0] mru_in,
    input logic [$clog2(NUM_LINES)-1:0] index_in,
    input logic load_in,

    /* OUTPUTS */
    output logic [$clog2(ASSOCIATIVITY)-1:0] lru_out
);

// glossary:
// cfr: compact form representation
// efr: expanded form representation

logic [NUM_LINES-1:0] [ASSOCIATIVITY-2:0] mru_efr;
initial begin
    for (int i = 0; i < NUM_LINES; i++)
        mru_efr[i] = 0;
end


// mru_in (cfr) -> mru_in_efr, mru_efr_load
// used so the generate loop does not go out of bounds
logic [ASSOCIATIVITY-2:0] mru_in_efr;
logic [ASSOCIATIVITY-2:0] mru_efr_load;

genvar m;
generate

    // E D C B A 9 8 7 6 5 4 3 2 1 0  : m
    // 0 1 2 3 4 5 6 7 8 9 A B C D E  : (ASSOCIATIVITY-2)-m
    // 2 3 4 5 6 7 8 9 A B C D E F 10 : (ASSOCIATIVITY-2)-m+2
    // 1 2 2 3 3 3 3 4 4 4 4 4 4 4 4  : clog2((ASSOCIATIVITY-2)-m+1)
    // 3 2 2 1 1 1 1 0 0 0 0 0 0 0 0  : clog2(ASSOCIATIVITY) - clog2((ASSOCIATIVITY-2)-m+1)

    for (m = ASSOCIATIVITY-2; m >= 0; m--) begin: gen_mru_in
        assign mru_in_efr[m] = mru_in[$clog2(ASSOCIATIVITY) - $clog2((ASSOCIATIVITY-2)-m+2)];
    end


    //// get value of bottom bit in mru, mru[2:<this>]
    //   E        D        C        B        A        9        8        7        6        5        4        3        2        1        0
    // mru[2:3] mru[2:2] mru[2:2] mru[2:1] mru[2:1] mru[2:1] mru[2:1] mru[2:0] mru[2:0] mru[2:0] mru[2:0] mru[2:0] mru[2:0] mru[2:0] mru[2:0]
    //   x        0        1        00       01       10       11       000      001      010      011      100      101      110      111

    // E D C B A 9 8 7 6 5 4 3 2 1 0  : m
    // x 2 2 1 1 1 1 0 0 0 0 0 0 0 0  : clog2(ASSOCIATIVITY) - clog2((ASSOCIATIVITY-2)-m+1)

    //// map m to desried output
    // x 0 1 2 3 4 5 6 7 8 9 A B C D  : (ASSOCIATIVITY-2)-m-1
    // x    0    1    2    3    4    5    6    7    8    9    A    B    C    D  : (ASSOCIATIVITY-2)-m-1 (base16)
    // x 0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101  : (ASSOCIATIVITY-2)-m-1 (base2)
    // x    0    1   00   01   10   11  000  001  010  011  100  101  110  111  : desired output (base2)
    // x    0    1    0    1    2    3    0    1    2    3    4    5    6    7  : desired output (base16)

    /* python implementation
    import math

    def clog2(x):
        return math.ceil(math.log2(x))

    ASSOCIATIVITY = 16
    for m in range(ASSOCIATIVITY-3,-1,-1):
        m_0 = (ASSOCIATIVITY-2)-m
        m_2 = clog2(m_0+2)-1
        s = 2**m_2 - 2
        o = m_0-s-1
        print("mru_in[", clog2(ASSOCIATIVITY)-2, ":", clog2(ASSOCIATIVITY) - clog2((ASSOCIATIVITY-2)-m+2), "] == ", o)
    */

    assign mru_efr_load[ASSOCIATIVITY-2] = 1;
    for (m = (ASSOCIATIVITY-2)-1; m >= 0; m--) begin: gen_mru_load
        localparam integer m_0 = (ASSOCIATIVITY-2)-m;
        localparam integer m_2 = $clog2(m_0+2)-1;
        localparam integer sub = 2**m_2 - 2;
        localparam integer out = m_0-sub-1;

        always_comb begin
            mru_efr_load[m] = 0;
            if ( mru_in[$clog2(ASSOCIATIVITY)-2:$clog2(ASSOCIATIVITY) - $clog2((ASSOCIATIVITY-2)-m+2)] == out ) begin
                mru_efr_load[m] = 1;
            end
        end
    end
endgenerate

always_ff @(posedge clk) begin : mru_load
    if (load_in) begin
        for (int i = ASSOCIATIVITY-2; i >= 0; i--) begin
            if (mru_efr_load[i]) begin
                mru_efr[index_in][i] = mru_in_efr[i];
            end
        end
    end
end


// mru_efr -> lru_out (cfr)
// lru_cfr_z_ext_1 is used so the generate loop does not go out of bounds
logic [$clog2(ASSOCIATIVITY):0] lru_cfr_z_ext_1;
assign lru_cfr_z_ext_1[$clog2(ASSOCIATIVITY)] = 0;

genvar l;
generate
    for (l = $clog2(ASSOCIATIVITY)-1; l >= 0; l--) begin: gen_lru_out
        localparam integer base = (ASSOCIATIVITY-2) - (2**($clog2(ASSOCIATIVITY)-1-l) - 1);
        assign lru_cfr_z_ext_1[l] = ~mru_efr[index_in][base - lru_cfr_z_ext_1[$clog2(ASSOCIATIVITY):l+1]];
    end
endgenerate

assign lru_out = lru_cfr_z_ext_1[$clog2(ASSOCIATIVITY)-1:0];

endmodule : cache_lru
