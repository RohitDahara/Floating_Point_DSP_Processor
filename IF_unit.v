`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024
// Design Name: 
// Module Name: instruction_fetch_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: MIPS32 Instruction Fetch Unit
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_2to1 (
    input wire sel,         // Select signal
    input wire [31:0] in0,  // Input 0
    input wire [31:0] in1,  // Input 1
    output wire [31:0] out  // Output
);

    // Output logic
    assign out = (sel) ? in1 : in0;

endmodule


module sign_ex (
    input wire [15:0] in,   // 16-bit input
    output wire [31:0] out  // 32-bit sign-extended output
);

    // Perform sign extension
    assign out = {{16{in[15]}}, in};

endmodule


module adder (
    //input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] out 
);

    assign out = 0 + b;

endmodule

module processor (
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    output wire [31:0] pc_out,  // Program Counter output
    output wire [31:0] instr_out,
    output wire [31:0] Adderout,
    output wire [31:0] a,
    output wire [31:0] b,
    output wire [31:0] c,
    output wire [31:0] Result,
    output wire [31:0] memwrite
);


    wire [31:0] pc, adderout, readData1, readData2, readData3;
    wire [31:0] instruction, readData, muxout, result, sign_out;
    wire [2:0] alu_op;
    wire alusrc, RegWrite, memRead, memWrite, MemToReg;


    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(pc),  
        .pc(pc_out)
    );


    instruction_mem imem_inst (
        .address(pc_out),        
        .instruction(instruction) 
    );
    
    assign instr_out = instruction;

    control_unit cu (
        .opcode(instruction[31:26]),
        .ALUOp(alu_op),
        .RegDst(),
        .ALUSrc(alusrc),
        .MemRead(memRead),
        .MemWrite(memWrite),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg)
    );
    
    Reg_file reg_file(
        .clk(clk),
        .reset(reset),
        .regWrite(RegWrite),
        .writeData(muxout),
        .writeReg(instruction[25:21]),
        .readReg1(instruction[20:16]),
        .readReg2(instruction[15:11]),
        .readReg3(instruction[10:6]),
        .readData1(readData1),
        .readData2(readData2),
        .readData3(readData3)
    );
    
    sign_ex sign_ex(
        .in(instruction[15:0]),
        .out(sign_out)
    );
    
    
    adder add (
        .b(sign_out),
        .out(adderout)
    );
    
    assign Adderout = adderout;
    
    mux_2to1 mux1(
        .sel(MemToReg),
        .in0(result),
        .in1(readData),
        .out(muxout)
    );
    
    
    CombinedFPU fpu (
        .clk(clk),
        .rst(reset),
        .alu_op(alu_op),
        .operand_a(readData1),
        .operand_b(readData2),
        .operand_c(readData3),
        .result(result)
    );
    
    assign a = readData1;
    assign b = readData2;
    assign c = readData3;
    assign Result = result;
    
    data_mem data_mem (
        .clk(clk),
        .memWrite(memWrite),
        .memRead(memRead),
        .address(adderout),
        .writeData(readData2),
        .readData(readData)
        
    );
    
    assign memwrite = muxout;
    
endmodule