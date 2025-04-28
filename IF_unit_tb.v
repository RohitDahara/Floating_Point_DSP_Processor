`timescale 1ns / 1ps

module processor_tb;

    // Inputs to the processor module
    reg clk;
    reg reset;
    wire [31:0] result;
    
    // Instantiate the processor module
    processor_top uut (
        .clk(clk),
        .reset(reset),
        .result(result)
     );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock with a period of 10ns
    end

    // Testbench sequence
    initial begin
        // Initialize inputs
        reset = 1;
        
        // Reset the processor
        #10 reset = 0;

        // Wait for the processor to start executing instructions
        #135;

        $finish;
    end

endmodule
