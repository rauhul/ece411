module cache_lru #(
    parameter NUM_LINES = 8,     // Min 2, must be power of 2
    parameter ASSOCIATIVITY = 2  // Min 2, must be power of 2
) (
    /* INPUTS */
    input clk,
    input logic [$clog2(ASSOCIATIVITY)-1:0] mru_in, // cfr
    input logic [$clog2(NUM_LINES)-1:0] index_in,
    input logic load_in,

    /* OUTPUTS */
    output logic [$clog2(ASSOCIATIVITY)-1:0] lru_out // cfr
);

localparam integer CFR_H_BIT = $clog2(ASSOCIATIVITY)-1;
localparam integer EFR_H_BIT = ASSOCIATIVITY-2;

// glossary:
// cfr: compact form representation
// efr: expanded form representation

logic [NUM_LINES-1:0] [EFR_H_BIT:0] mru_efr;
initial begin
    for (int i = 0; i < NUM_LINES; i++)
        mru_efr[i] = 0;
end

genvar i;

// mru_in (cfr) -> mru_in_efr
logic [EFR_H_BIT:0] mru_in_efr;
generate

    // E D C B A 9 8 7 6 5 4 3 2 1 0  : i
    // 0 1 2 3 4 5 6 7 8 9 A B C D E  : EFR_H_BIT-i
    // 2 3 4 5 6 7 8 9 A B C D E F 10 : EFR_H_BIT-i+2
    // 1 2 2 3 3 3 3 4 4 4 4 4 4 4 4  : clog2(EFR_H_BIT-i+1)
    // 3 2 2 1 1 1 1 0 0 0 0 0 0 0 0  : CFR_H_BIT - clog2(EFR_H_BIT-i+1) + 1

    for (i = EFR_H_BIT; i >= 0; i--) begin: gen_mru_in
        assign mru_in_efr[i] = mru_in[CFR_H_BIT - $clog2(EFR_H_BIT-i+2) + 1];
    end
endgenerate


// mru_in (cfr) -> mru_efr_load
logic [EFR_H_BIT:0] mru_efr_load;
generate

    //// get value of bottom bit in mru, mru[2:<this>]
    //   E        D        C        B        A        9        8        7        6        5        4        3        2        1        0
    // mru[3:4] mru[3:3] mru[3:3] mru[3:2] mru[3:2] mru[3:2] mru[3:2] mru[3:1] mru[3:1] mru[3:1] mru[3:1] mru[3:1] mru[3:1] mru[3:1] mru[3:1]
    //   x        0        1        00       01       10       11       000      001      010      011      100      101      110      111

    // E D C B A 9 8 7 6 5 4 3 2 1 0  : i
    // x 3 3 2 2 2 2 1 1 1 1 1 1 1 1  : CFR_H_BIT - clog2(EFR_H_BIT-i+1) + 2

    //// map i to desried output
    // x 0 1 2 3 4 5 6 7 8 9 A B C D  : EFR_H_BIT-i-1
    // x    0    1    2    3    4    5    6    7    8    9    A    B    C    D  : EFR_H_BIT-i-1 (base16)
    // x 0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100 1101  : EFR_H_BIT-i-1 (base2)
    // x    0    1   00   01   10   11  000  001  010  011  100  101  110  111  : desired output (base2)
    // x    0    1    0    1    2    3    0    1    2    3    4    5    6    7  : desired output (base16)

    /* python implementation
    import math

    def clog2(x):
        return math.ceil(math.log2(x))

    ASSOCIATIVITY = 16
    for i in range(ASSOCIATIVITY-3,-1,-1):
        i_0 = EFR_H_BIT-i
        i_2 = clog2(i_0+2)-1
        s = 2**i_2 - 2
        o = i_0-s-1
        print("mru_in[", clog2(ASSOCIATIVITY)-2, ":", clog2(ASSOCIATIVITY) - clog2(EFR_H_BIT-i+2), "] == ", o)
    */

    assign mru_efr_load[EFR_H_BIT] = 1;
    for (i = EFR_H_BIT-1; i >= 0; i--) begin: gen_mru_load
        localparam integer i_0 = EFR_H_BIT-i;
        localparam integer i_2 = $clog2(i_0+2)-1;
        localparam integer sub = 2**i_2 - 2;
        localparam integer out = i_0-sub-1;

        assign mru_efr_load[i] = mru_in[CFR_H_BIT:CFR_H_BIT - $clog2(EFR_H_BIT-i+2) + 2] == out;
    end
endgenerate

always_ff @(posedge clk) begin : mru_load
    if (load_in) begin
        for (int i = EFR_H_BIT; i >= 0; i--) begin
            if (mru_efr_load[i]) begin
                mru_efr[index_in][i] = mru_in_efr[i];
            end
        end
    end
end


// mru_efr -> lru_out (cfr)
generate
    assign lru_out[CFR_H_BIT] = ~mru_efr[index_in][EFR_H_BIT];

    for (i = CFR_H_BIT-1; i >= 0; i--) begin: gen_lru_out
        localparam integer base = EFR_H_BIT - (2**(CFR_H_BIT-i) - 1);
        assign lru_out[i] = ~mru_efr[index_in][base - lru_out[CFR_H_BIT:i+1]];
    end
endgenerate

endmodule : cache_lru
