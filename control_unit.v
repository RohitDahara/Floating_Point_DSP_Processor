`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 13:08:37
// Design Name: 
// Module Name: control_unit
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


module control_unit (
    input [5:0] opcode,    // 6-bit opcode
    output reg [2:0] ALUOp,    // 3-bit ALUOp
    output reg RegDst,     // RegDst control signal
    output reg ALUSrc,     // ALUSrc control signal
    output reg MemRead,    // MemRead control signal
    output reg MemWrite,   // MemWrite control signal
    output reg RegWrite,   // RegWrite control signal
    output reg MemToReg    // MemToReg control signal
);

    always @(*) begin
        // Default values for all signals
        ALUOp = 3'b000;
        RegDst = 0;
        ALUSrc = 0;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        MemToReg = 0;
        
        case (opcode)
            6'b000000: begin // addition
                ALUOp = 3'b000;  // Default ALU operation (addition)
                RegDst = 1;      // Use rd as the destination register
                ALUSrc = 0;      // Second operand is from a register
                MemRead = 0;     // No memory read
                MemWrite = 0;    // No memory write
                RegWrite = 1;    // Write the result to a register
                MemToReg = 0;    // Data comes from ALU
            end
            6'b000010: begin // subtraction
                ALUOp = 3'b001;  // Default ALU operation (addition)
                RegDst = 1;      // Use rd as the destination register
                ALUSrc = 0;      // Second operand is from a register
                MemRead = 0;     // No memory read
                MemWrite = 0;    // No memory write
                RegWrite = 1;    // Write the result to a register
                MemToReg = 0;    // Data comes from ALU
            end
            6'b000100: begin // multiply
                ALUOp = 3'b010;  // Default ALU operation (addition)
                RegDst = 1;      // Use rd as the destination register
                ALUSrc = 0;      // Second operand is from a register
                MemRead = 0;     // No memory read
                MemWrite = 0;    // No memory write
                RegWrite = 1;    // Write the result to a register
                MemToReg = 0;    // Data comes from ALU
            end
            6'b000110: begin // division
                ALUOp = 3'b011;  // Default ALU operation (addition)
                RegDst = 1;      // Use rd as the destination register
                ALUSrc = 0;      // Second operand is from a register
                MemRead = 0;     // No memory read
                MemWrite = 0;    // No memory write
                RegWrite = 1;    // Write the result to a register
                MemToReg = 0;    // Data comes from ALU
            end
            6'b100011: begin // lw (load word)
                ALUOp = 3'b000;  // ALU performs address calculation (addition)
                RegDst = 0;      // Destination register is rt
                ALUSrc = 1;      // Second operand is an immediate value
                MemRead = 1;     // Memory read
                MemWrite = 0;    // No memory write
                RegWrite = 1;    // Write data to register
                MemToReg = 1;    // Data comes from memory
            end
            6'b101011: begin // sw (store word)
                ALUOp = 3'b000;  // ALU performs address calculation
                RegDst = 0;      // No register destination (not writing to register)
                ALUSrc = 1;      // Second operand is an immediate value
                MemRead = 0;     // No memory read
                MemWrite = 1;    // Memory write
                RegWrite = 0;    // No register write
                MemToReg = 0;    // No data from memory
            end
            6'b111111: begin // mac (multiply-accumulate)
                ALUOp = 3'b111;  // Custom ALU operation for multiply-accumulate
                RegDst = 1;      // Destination register is rd
                ALUSrc = 0;      // Second operand is from a register
                MemRead = 0;     // No memory read
                MemWrite = 0;    // No memory write
                RegWrite = 1;    // Write result to register
                MemToReg = 0;    // Data comes from ALU
            end
            default: begin
                // Default case if opcode is invalid (or unused)
                ALUOp = 3'b000;
                RegDst = 0;
                ALUSrc = 0;
                MemRead = 0;
                MemWrite = 0;
                RegWrite = 0;
                MemToReg = 0;
            end
        endcase
    end

endmodule

/*
module mux_1(
    input wire [31:0] in0,  // 26-bit Input 0
    input wire [31:0] in1,  // 26-bit Input 1
    input wire Alusrc,         // Select signal
    output wire [31:0] out  // 26-bit MUX output
);

    // Assign output based on select signal
    assign out = (Alusrc) ? in1 : in0;

endmodule
*/

