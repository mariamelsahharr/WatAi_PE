/*
 * Copyright (c) 2024 Mariam 
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_pe_mariam #(
    parameter M = 2,
    parameter N = 2,
    parameter input_width = 8,
    parameter output_width = 32
)(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
//internal signals
  //active high reset
    wire rst = ~rst_n;
  //precision mode
    wire [1:0]precision_mode;
  //data in according to parameters
    wire [M-1:0] data_in_1;
    wire [N-1:0] data_in_2;
  //data out according to parameters
    wire [M-1:0][N-1:0][output_width-1:0] data_out;
    //creates an array of MxN PEs with bit size of output_width

    //yapyap assign input data to the data_in_1 and data_in_2
    //idk what signals/values to use but i need signals to instantiate it soooo
    assign data_in_1 = {ui_in, 8'd0};
    assign data_in_2 = {uio_in, 8'd0};


pe_array #(
        .M(M),
        .N(N),
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH)
    ) pe_array_inst (
        .clk(clk),
        .rst(rst),
        .precision_mode(precision_mode),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_out(data_out)
    );

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = 0;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
