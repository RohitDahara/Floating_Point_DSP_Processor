`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024
// Design Name: 
// Module Name: register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: MIPS32 Register File with 3 Read Ports and 1 Write Port
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Reg_file (
    input wire clk,                      // Clock signal
    input wire reset,                    // Reset signal
    input wire regWrite,                 // Write enable
    input wire [4:0] writeReg,           // Destination register index
    input wire [31:0] writeData,         // Data to be written
    input wire [4:0] readReg1,           // First read register index
    input wire [4:0] readReg2,           // Second read register index
    input wire [4:0] readReg3,           // 4th read register index
    output wire [31:0] readData1,        // Data read from the first register
    output wire [31:0] readData2,        // Data read from the second register
    output wire [31:0] readData3  // Data read from the 4th register
);

    // 32 general-purpose registers (32-bit each)
    reg [31:0] registers [0:31];
    integer i;

    // Read operations (combinational logic)
    assign readData1 = registers[readReg1];
    assign readData2 = registers[readReg2];
    assign readData3 = registers[readReg3];
    
    // Write operation (synchronous with clock)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0
            registers[0] <= 32'b0;
            registers[1] <= 32'b0;
            registers[2] <= 32'b0;
            registers[3] <= 32'b0;
            registers[4] <= 32'b0;
            registers[5] <= 32'b0;
            registers[6] <= 32'b0;
            registers[7] <= 32'b0;
            registers[8] <= 32'b0;
            registers[9] <= 32'b0;
            registers[10] <= 32'b0;
            registers[11] <= 32'b0;
            registers[12] <= 32'b0;
            registers[13] <= 32'b0;
            registers[14] <= 32'b0;
            registers[15] <= 32'b0;
            registers[16] <= 32'b0;
            registers[17] <= 32'b0;
            registers[18] <= 32'b0;
            registers[19] <= 32'b0;
            registers[20] <= 32'b0;
            registers[21] <= 32'b0;
            registers[22] <= 32'b0;
            registers[23] <= 32'b0;
            registers[24] <= 32'b0;
            registers[25] <= 32'b0;
            registers[26] <= 32'b0;
            registers[27] <= 32'b0;
            registers[28] <= 32'b0;
            registers[29] <= 32'b0;
            registers[30] <= 32'b0;
            registers[31] <= 32'b0;
            
            
        end else if (regWrite) begin
            // Write data to the specified register
            registers[writeReg] <= writeData;
        end
    end

endmodule
