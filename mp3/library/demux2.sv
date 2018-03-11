module demux2 #(parameter width = 16)
(
    input sel,
    input [width-1:0] f,
    output logic [width-1:0] a, b
);

always_comb
begin
    if (sel == 0) begin
        a = f;
        b = 1'b0;
    end else begin
        a = 1'b0;
        b = f;
    end
end

endmodule : demux2