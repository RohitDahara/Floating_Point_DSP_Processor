`timescale 1ns / 1ps

module processor_tb;

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [6:0] seg0;
    wire [6:0] seg1;
    wire [7:0] anode;
    wire [31:0] result;

    // Instantiate processor top module
    processor_new uut (
        .clk(clk),
        .reset(reset),
        .seg0(seg0),
        .seg1(seg1),
        .anode(anode),
        .result(result)
    );

    // Clock generator: 100MHz -> 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset and run sequence
    initial begin
    
        reset = 1;
        #20;
        reset = 0;

        // Run long enough to observe multiple instruction executions
        #1100;
        
    end

endmodule
