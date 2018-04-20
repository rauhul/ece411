module branch_waterfall_queue (
    /* INPUTS */
    input logic clk,

    input logic [15:0] mispredict_address_in,
    input logic prediction_in,

    input logic load_prediction,
    input logic update_predictions,
    input logic correct_prediction,

    /* OUTPUTS */
    output logic [15:0] mispredict_address_out,
    output logic prediction_out
);

localparam integer QUEUE_SIZE = 3;
localparam integer QUEUE_SIZE_BIT_WIDTH = $clog2(QUEUE_SIZE);

logic [QUEUE_SIZE_BIT_WIDTH-1:0] queue_top_ptr;
logic [QUEUE_SIZE_BIT_WIDTH-1:0] queue_top_ptr_up1;
logic [QUEUE_SIZE_BIT_WIDTH-1:0] queue_top_ptr_dn1;
logic [QUEUE_SIZE-1:0]    [15:0] mispredict_address_queue;
logic [QUEUE_SIZE-1:0]     [0:0] prediction_queue;

initial begin
    for (int i = 0; i < QUEUE_SIZE; i++) begin
        mispredict_address_queue[i] = 0;
        prediction_queue[i] = 0;
    end

    queue_top_ptr = 0;
end

assign queue_top_ptr_up1 = queue_top_ptr + 1;
assign queue_top_ptr_dn1 = queue_top_ptr - 1;
assign mispredict_address_out = mispredict_address_queue[0];
assign prediction_out         = prediction_queue[0];

always_ff @(posedge clk) begin
    if (update_predictions & ~correct_prediction) begin
        for (int i = 0; i < QUEUE_SIZE; i++) begin
            mispredict_address_queue[i] = 0;
            prediction_queue[i] = 0;
        end

        queue_top_ptr = 0;

    end else if (update_predictions & correct_prediction & load_prediction) begin
        for (int i = 0; i < QUEUE_SIZE - 1; i++) begin
            if (queue_top_ptr == i) begin
                mispredict_address_queue[i] = mispredict_address_in;
                prediction_queue[i]         = prediction_in;
            end else begin
                mispredict_address_queue[i] = mispredict_address_queue[i + 1];
                prediction_queue[i]         = prediction_queue[i + 1];
            end
        end

        if (queue_top_ptr == QUEUE_SIZE - 1) begin
            mispredict_address_queue[QUEUE_SIZE - 1] = mispredict_address_in;
            prediction_queue[QUEUE_SIZE - 1]         = prediction_in;
        end else begin
            mispredict_address_queue[QUEUE_SIZE - 1] = 0;
            prediction_queue[QUEUE_SIZE - 1]         = 0;
        end

        queue_top_ptr = queue_top_ptr;

    end else if (update_predictions & correct_prediction) begin

        for (int i = 0; i < QUEUE_SIZE - 1; i++) begin
            mispredict_address_queue[i] = mispredict_address_queue[i + 1];
            prediction_queue[i]         = prediction_queue[i + 1];
        end
        mispredict_address_queue[QUEUE_SIZE - 1] = 0;
        prediction_queue[QUEUE_SIZE - 1]         = 0;

        queue_top_ptr = queue_top_ptr_dn1;

    end else if (load_prediction) begin
        mispredict_address_queue[queue_top_ptr] = mispredict_address_in;
        prediction_queue[queue_top_ptr]         = prediction_in;

        queue_top_ptr = queue_top_ptr_up1;
    end
end

endmodule : branch_waterfall_queue
