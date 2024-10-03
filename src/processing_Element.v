module processing_element #(
   parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32,
    parameter REG_FILE_DEPTH = 8, //number of registers in file
    parameter REG_FILE_WIDTH = 3 //bit width of each register
)(
    input wire clk,
    input wire rst,
    input wire [INPUT_WIDTH-1:0] data_in_2,
    input wire [INPUT_WIDTH-1:0] data_in_1,
    output reg [OUTPUT_WIDTH-1:0] data_out
);

reg [OUTPUT_WIDTH-1:0] acc;
 wire sign_bit1 = data_in_1[INPUT_WIDTH-1];
            wire sign_bit2 = data_in_2[INPUT_WIDTH-1];
            localparam LENGTH_EXTEND = OUTPUT_WIDTH - INPUT_WIDTH;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            acc <= {output_width{1'b0}};
            data_out <= {output_width{1'b0}};
        end else begin
        
            //to sign extend we:
            //1. convert the input to signed
            //2. add the sign bit to the rest of the bits, that is (output_Width-input_width) times 
            //ie. if ur output is 16 bits but ur input is 8 bits then u need to add 4 bits to the left
            //those 4 bits are of the same sign
            //check 222 again
            //3. assign the result to the acc

           
            //locaparam is used to define a constant value that can be used in the module, better for compile time
        

        acc <= acc 
            + $signed({{LENGTH_EXTEND{sign_bit1}}, data_in_1}) 
            * $signed({{LENGTH_EXTEND{sign_bit2}}, data_in_2});
            
        end
    end

    always @(posedge clk) begin
        data_out <= acc;
    end
endmodule