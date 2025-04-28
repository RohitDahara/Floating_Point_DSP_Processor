`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024
// Design Name: 
// Module Name: program_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: MIPS32 Program Counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module program_counter (
    input wire clk,            // Clock signal
    input wire reset,          // Reset signal
    input wire [31:0] next_pc, // Next program counter value
    output reg [31:0] pc       // Current program counter value
);

    // On the rising edge of the clock, update the PC
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h00000000; // Reset PC to 0
        end else begin
            pc <= pc + 4;      // Update PC with the next value
        end
    end

endmodule
