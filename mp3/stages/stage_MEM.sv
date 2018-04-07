import lc3b_types::*;

module stage_MEM (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,
    input lc3b_word sr2_in,

    /* OUTPUTS */
    output logic br_en_out,
    output lc3b_word mdr_out,
    output logic request_stall,
    output lc3b_word regfile_data_out,

    /* MEMORY INTERFACE */
    wishbone.master data_memory_wishbone
);

lc3b_cc cc_out;
lc3b_cc cc_gen_out;
lc3b_word cc_gen_mux_out;

logic internal_MDR_load;
lc3b_word internal_mdr_out;

lc3b_data_memory_addr_mux_sel data_memory_addr_mux_sel;
lc3b_word data_memory_addr_mux_out;
logic data_memory_wishbone_WE;

lc3b_word trapvect8;
assign trapvect8 = $unsigned({ir_in[7:0], 1'b0});

logic br_en_in;
assign br_en_in = |(cc_out & ir_in[11:9]);

/* CC */
logic [3:0] [15:0] cc_gen_mux_in;
assign cc_gen_mux_in[0] = pcn_in;
assign cc_gen_mux_in[1] = alu_in;
assign cc_gen_mux_in[2] = mdr_out;
assign cc_gen_mux_in[3] = sr2_in;
mux #(4, 16) cc_gen_mux (
    /* INPUTS */
    .sel(control_in.cc_gen_mux_sel),
    .in(cc_gen_mux_in),

    /* OUTPUTS */
    .out(cc_gen_mux_out)
);

gencc cc_gen (
    /* INPUTS */
    .in(cc_gen_mux_out),

    /* OUTPUTS */
    .out(cc_gen_out)
);

register #(.width(3)) cc (
    /* INPUTS */
    .clk,
    .load(control_in.cc_load),
    .stall,
    .in(cc_gen_out),

    /* OUTPUTS */
    .out(cc_out)
);

register #(.width(1)) br_en (
    /* INPUTS */
    .clk,
    .load(control_in.br_en_load),
    .stall,
    .in(br_en_in),

    /* OUTPUTS */
    .out(br_en_out)
);

/* MEMORY INTERFACE */
mem_access_controller _mem_access_controller (
    /* INPUTS */
    .clk,
    .stall,
    .control_in,
    .ir_in,
    .data_memory_wishbone_ACK(data_memory_wishbone.ACK),
    .data_memory_wishbone_RTY(data_memory_wishbone.RTY),

    /* OUTPUTS */
    .data_memory_addr_mux_sel,
    .data_memory_wishbone_WE,
    .internal_MDR_load,
    .request_stall
);

logic [2:0] [15:0] data_memory_addr_mux_in;
assign data_memory_addr_mux_in[0] = trapvect8;
assign data_memory_addr_mux_in[1] = alu_in;
assign data_memory_addr_mux_in[2] = internal_mdr_out;
mux #(3, 16) data_memory_addr_mux (
    /* INPUTS */
    .sel(data_memory_addr_mux_sel),
    .in(data_memory_addr_mux_in),

	 /* OUTPUTS */
    .out(data_memory_addr_mux_out)
);

assign data_memory_wishbone.ADR = data_memory_addr_mux_out[15:4];
assign data_memory_wishbone.CYC = control_in.data_memory_access;
assign data_memory_wishbone.STB = control_in.data_memory_access;
assign data_memory_wishbone.WE = data_memory_wishbone_WE;

always_comb begin
    /* select */
    data_memory_wishbone.SEL = 0;
    if (control_in.data_memory_word_align) begin
        data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = 2'b11;
    end else begin
        if (data_memory_addr_mux_out[0]) begin // high byte
            data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = 2'b10;
        end else begin // low byte
            data_memory_wishbone.SEL[data_memory_addr_mux_out[3:1]*2 +: 2] = 2'b01;
        end
    end

    /* data in */
    data_memory_wishbone.DAT_M = 0;
    if (control_in.data_memory_word_align) begin
        data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = sr2_in;
    end else begin
        if (data_memory_addr_mux_out[0]) begin // high byte
            data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = {sr2_in[7:0], 8'b0};
        end else begin // low byte
            data_memory_wishbone.DAT_M[data_memory_addr_mux_out[3:1]*16 +: 16] = {8'b0, sr2_in[7:0]};
        end
    end

    /* data out */
    mdr_out = 0;
    if (control_in.data_memory_word_align) begin
        mdr_out = data_memory_wishbone.DAT_S[data_memory_addr_mux_out[3:1]*16 +: 16];
    end else begin
        mdr_out[7:0] = data_memory_wishbone.DAT_S[data_memory_addr_mux_out[3:0]*8 +: 8];
    end
end

register internal_mdr (
    /* INPUTS */
    .clk,
    .load(internal_MDR_load),
    .stall,
    .in(mdr_out),

    /* OUTPUTS */
    .out(internal_mdr_out)
);


/* FORWARDING LOGIC */
// should be identical to WB regfile_data_mux, without mdr
logic [3:0] [15:0] regfile_data_mux_in;
assign regfile_data_mux_in[0] = pc_in;
assign regfile_data_mux_in[1] = pcn_in;
assign regfile_data_mux_in[2] = 16'bx;
assign regfile_data_mux_in[3] = alu_in;
mux #(4, 16) regfile_data_mux (
    /* INPUTS */
    .sel(control_in.regfile_data_mux_sel),
    .in(regfile_data_mux_in),

    /* OUTPUTS */
    .out(regfile_data_out)
);

endmodule: stage_MEM
