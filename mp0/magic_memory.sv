/*
 * Magic memory
 */
module magic_memory
(
    input clk,

    /* Port A */
    input read,
    input write,
    input [1:0] wmask,
    input [15:0] address,
    input [15:0] wdata,
    output logic resp,
    output logic [15:0] rdata
);

timeunit 1ns;
timeprecision 1ns;

logic [7:0] mem [0:2**($bits(address))-1];
logic [15:0] internal_address;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

/* Calculate internal address */
assign internal_address = {address[15:1], 1'b0};

/* Read */
always_comb
begin : mem_read
    rdata = {mem[internal_address+1], mem[internal_address]};
end : mem_read

/* Write */
always @(posedge clk)
begin : mem_write
    if (write)
    begin
        if (wmask[1])
        begin
            mem[internal_address+1] = wdata[15:8];
        end

        if (wmask[0])
        begin
            mem[internal_address] = wdata[7:0];
        end
    end
end : mem_write

/* Magic memory responds immediately */
assign resp = read | write;

endmodule : magic_memory
