`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024
// Design Name: 
// Module Name: instruction_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: MIPS32 Instruction Memory
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module instruction_mem (
    input wire [31:0] address,          // Program Counter
    output reg [31:0] instruction  // Instruction to be fetched
);

    reg [31:0] memory [0:255];   
    
    
    // Read the instruction from memory based on PC
    always @(*) begin
        instruction = memory[address[7:0]];  // Use lower 10 bits of PC as the address index
    end

    // Initialize instruction memory with some test instructions
    initial begin
        // Load some test instructions (MIPS instructions for example)
        memory[0]  = 32'h00000000;  //NOP
        memory[4]  = 32'b10001100001000010000000000000001;  // lw 
        memory[8]  = 32'b10001100010000100000000000000010;  // lw 
        memory[12] = 32'b10001100011000110000000000000011;  // lw 
        memory[16] = 32'b10001100100001000000000000000100;  // lw
        memory[20] = 32'b10001100101001010000000000000101;  // lw
        memory[24] = 32'b10001100110001100000000000000110;  // lw
        //memory[28] = 32'b00010001001000010010000000000000;  // mul
        //memory[32] = 32'b00010001010000100010100000000000;  // mul
        //memory[36] = 32'b00010001011000110011000000000000;  // mul
        //memory[40] = 32'b00000001100010010101000000000000;  // add
        //memory[44] = 32'b00000001101011000101000000000000;  // add
        
        memory[28] = 32'b11111101000000010010000000000000;  // mac
        memory[32] = 32'b11111101001000100010101000000000;  // mac
        memory[36] = 32'b11111101010000110011001001000000;  // mac
        memory[40] = 32'h00000000;
        //memory[44] = 32'h10000000;
        memory[44] = 32'b10101101010010100000000000001010;  //sw
        //memory[48] = 32'b10001101110010100000000000001010;  //lw
        
        //memory[20] = 32'h00000000;  //NOP
        //memory[24] = 32'b10101100110010000000000000010000;  // sw $4, 8($0)
        //memory[24]  = 32'b10001100000001000000000000000000;  // sw $4, 8($0)
        //memory[28]  = 32'b10001100101000000000000000000000;  //NOP
        //memory[28] = 32'b10001110000100000000000000010000;  //NOP
        //memory[32]   = 32'h00000000;  //NOP
        //memory[36]  = 32'h00000000;  //NOP
    end

endmodule
