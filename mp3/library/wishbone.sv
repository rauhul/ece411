interface wishbone (input wire CLK);

// DAT_M represents DAT_O on master side, and
// DAT_I on slave side; vice versa for DAT_S
logic [127:0] DAT_M, DAT_S;
logic ACK, CYC, STB, RTY, WE;
logic [11:0] ADR;
logic [15:0] SEL;

modport master (
    input DAT_S, CLK, ACK, RTY,
    output DAT_M, CYC, STB, WE, SEL, ADR
);

modport slave (
    input DAT_M, CLK, CYC, STB, WE, SEL, ADR,
    output DAT_S, ACK, RTY
);

endinterface : wishbone
