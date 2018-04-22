module branch_history_register #(
    parameter BRANCH_HISTORY_REGISTER_SIZE = 4
) (
    input logic clk,
    input logic stall,

    input logic update,
    input logic update_value,

    /* OUTPUTS */
    output logic [BRANCH_HISTORY_REGISTER_SIZE-1:0] history
);

logic [BRANCH_HISTORY_REGISTER_SIZE-1:0] in;
logic [BRANCH_HISTORY_REGISTER_SIZE-1:0] data;

assign in = {data[BRANCH_HISTORY_REGISTER_SIZE-2:0], update_value};

initial begin
    data = 0;
end

always_ff @(posedge clk) begin
    if (update & ~stall)
        data = in;
end

always_comb begin
    history = data;
end

endmodule : branch_history_register
