`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 13:54:48
// Design Name: 
// Module Name: clk_div_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_div_tb(

    );
    reg clk_in_tb = 0;
    reg rst_tb = 1;
    wire clk_out_tb;

    // Instantiate the clk_div module
    clk_div  uut (
        .clk_in(clk_in_tb),
        .rst(rst_tb),
        .clk_out(clk_out_tb)
    );

    // Generate 100 MHz clock -> 10 ns period (toggle every 5 ns)
    always #5 clk_in_tb = ~clk_in_tb;
    
    
    initial begin
    
        // Reset for first few cycles
        #20;
        rst_tb = 0;

        // Run simulation for 500 ns
        #500;

    end

endmodule
