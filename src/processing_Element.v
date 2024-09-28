module processing_element(
    input wire clk,
    input wire rst,
    input wire [15:0] data_in_2,
    input wire [15:0] data_in_1,
    output wire [31:0] data_out
);

reg [31:0] acc ;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            acc <= 32'b0;
            data_out <= 32'b0;
        end else begin
            acc <= acc + $signed(data_in_1) + $signed(data_in_2);
            data_out <= acc;
        end
    end




endmodule
