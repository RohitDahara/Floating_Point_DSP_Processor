`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 13:52:30
// Design Name: Clock Divider
// Module Name: clk_div
// Description: Divides 100 MHz clock to 5 MHz
//////////////////////////////////////////////////////////////////////////////////

module clk_div (
    input wire clk_in,      // 100 MHz input clock
    input wire rst,         // Active high synchronous reset
    output reg clk_out      // 5 MHz output clock
);

    parameter DIVISOR = 20;

    reg [4:0] counter = 0;  // Enough bits to count to 19

    always @(posedge clk_in) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIVISOR / 2 - 1)) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
