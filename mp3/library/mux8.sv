module mux8 #(parameter width = 16)
(
    input [2:0] sel,
    input [width-1:0] in000, in001, in010, in011, in100, in101, in110, in111,
    output logic [width-1:0] out
);

always_comb
begin
    case(sel)
    3'b000: out = in000;
    3'b001: out = in001;
    3'b010: out = in010;
    3'b011: out = in011;
    3'b100: out = in100;
    3'b101: out = in101;
    3'b110: out = in110;
    3'b111: out = in111;
    endcase
end

endmodule : mux8