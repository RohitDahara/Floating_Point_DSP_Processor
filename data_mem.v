`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 11:49:01
// Design Name: 
// Module Name: data_mem
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 11:49:01
// Design Name: 
// Module Name: data_mem
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

module data_mem (
    input wire clk,                 // Clock signal
    input wire memWrite,            // Memory write enable
    input wire memRead,             // Memory read enable
    input wire [31:0] address,      // Memory address
    input wire [31:0] writeData,    // Data to be written
    output reg [31:0] readData      // Data to be read
);

    // Memory array (4KB, assuming 32-bit words)
    reg [31:0] memory [0:31];  // 32 memory locations, each 32 bits wide

    // Initialize all memory locations to zero at the start of simulation
    initial begin
        memory[0]  = 32'h00000000;  
        memory[1]  = 32'b01000000011000000000000000000000;  //3.5
        memory[2]  = 32'b01000000101001100110011001100110;  //5.2
        memory[3]  = 32'b01000000000001100110011001100110;  //2.1
        memory[4]  = 32'b00111111100000000000000000000000;  //1.0
        memory[5]  = 32'b01000000000011010111000010100100;  //2.21
        memory[6]  = 32'b00111111100000000000000000000000;  //1.0
        memory[7]  = 32'h00000007;
        memory[8]  = 32'h00000008;
        memory[9]  = 32'h00000009;
        memory[10] = 32'h0000000A;
        memory[11] = 32'h0000000B;
        memory[12] = 32'h0000000C;
        memory[13] = 32'h0000000D;
        memory[14] = 32'h0000000E;
        memory[15] = 32'h0000000F;
        memory[16] = 32'h00000000;
        memory[17] = 32'h00000000;
        memory[18] = 32'h00000000;
        memory[19] = 32'h00000000;
        memory[20] = 32'h00000000;
        memory[21] = 32'h00000000;
        memory[22] = 32'h00000000;
        memory[23] = 32'h00000000;
        memory[24] = 32'h00000000;
        memory[25] = 32'h00000000;
        memory[26] = 32'h00000000;
        memory[27] = 32'h00000000;
        memory[28] = 32'h00000000;
        memory[29] = 32'h00000000;
        memory[30] = 32'h00000000;
        memory[21] = 32'h00000000;
    
    end

    // Write operation (on rising edge of clk)
    always @(posedge clk) begin
        if (memWrite) begin
            memory[address[4:0]] <= writeData;  // Write to memory location specified by the address
        end
    end

    // Read operation (combinational)
    always @(*) begin
        if (memRead) begin
            readData = memory[address[4:0]];  // Read from memory location specified by the address
        end else begin
            readData = 32'b0;  // Default value when no read is happening
        end
    end

endmodule

