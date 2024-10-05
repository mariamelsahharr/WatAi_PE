module processing_element #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 32,
    parameter MEM_DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(MEM_DEPTH)
)(
    input wire clk,
    input wire rst,
    input wire [INPUT_WIDTH-1:0] input_data,  // Input data (activation or weight)
    input wire [INPUT_WIDTH-1:0] weight,      // Weight input
    output reg [OUTPUT_WIDTH-1:0] result,     // Output result
    
    // Control signals
    input wire write_weight,            // Signal to write weight to memory
    input wire use_stored_weight,       // Signal to use weight from memory
    input wire [ADDR_WIDTH-1:0] mem_addr, // Memory address for read/write
    input wire end_operation,           // Signal to start a new operation
    input wire store_result             // Signal to store result in memory
);

reg [OUTPUT_WIDTH-1:0] local_memory [0:MEM_DEPTH-1];
reg [OUTPUT_WIDTH-1:0] acc;
reg op_ctrl;

always @(posedge clk or posedge rst) begin

    if (rst) begin
        for (int i = 0; i < MEM_DEPTH; i = i + 1) begin
            local_memory[i] <= {OUTPUT_WIDTH{1'b0}};
        end

        acc <= {OUTPUT_WIDTH{1'b0}};
        result <= {OUTPUT_WIDTH{1'b0}};
        op_ctrl <= 1'b0;
    //reset everything

    end else begin
        // Write weight to memory if requested
        if (write_weight) begin
            local_memory[mem_addr] <= {{(OUTPUT_WIDTH-INPUT_WIDTH){weight[INPUT_WIDTH-1]}}, weight};
        end

        // Perform multiplication and accumulation
        if (end_operation || !op_ctrl) begin
            if (use_stored_weight) begin
                acc <= $signed(input_data) * $signed(local_memory[mem_addr]);

            end else begin

                acc <= $signed(input_data) * $signed({{(OUTPUT_WIDTH-INPUT_WIDTH){weight[INPUT_WIDTH-1]}}, weight});
            end

            op_ctrl <= 1'b1;
            //done with it

        end else begin
            if (use_stored_weight) begin
                acc <= acc + ($signed(input_data) * $signed(local_memory[mem_addr]));
            end else begin
                acc <= acc + ($signed(input_data) * $signed({{(OUTPUT_WIDTH-INPUT_WIDTH){weight[INPUT_WIDTH-1]}}, weight}));
            end
        end

        // Update result and reset operation status
        if (end_operation) begin
            result <= acc;
            op_ctrl <= 1'b0;
        end
    end
end

endmodule