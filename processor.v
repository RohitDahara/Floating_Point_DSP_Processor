module processor_new(
    input wire clk,
    input wire reset,
    output wire [6:0] seg0,
    output wire [6:0] seg1,
    output wire [7:0] anode,
    output wire [31:0] result
);
    wire [31:0] Result;
    reg [31:0] LatchedResult = 0;

    wire clk_o;

    // Clock divider for processor (5 MHz assumed)
    clk_div clk_div_inst (
        .clk_in(clk),
        .rst(reset),
        .clk_out(clk_o)
    );

    // Floating-point DSP processor
    processor processor_inst (
        .clk(clk_o),
        .reset(reset),
        .Result(Result)
    );

    assign result = Result;

    // 10 second delay counter (@ 5 MHz = 50_000_000 cycles)
    reg [31:0] delay_counter = 0;
    parameter DELAY_COUNT = 32'd50_000_000;

    always @(posedge clk_o or posedge reset) begin
        if (reset) begin
            delay_counter <= 0;
            LatchedResult <= 0;
        end else begin
            if (delay_counter >= DELAY_COUNT) begin
                delay_counter <= 0;
                LatchedResult <= Result;
            end else begin
                delay_counter <= delay_counter + 1;
            end
        end
    end

    // Use LatchedResult for display
    hex_display display_inst (
        .clk(clk),  // For display multiplexing
        .hex_value(LatchedResult),
        .seg0(seg0),
        .seg1(seg1),
        .anode(anode)
    );

endmodule


module hex_display (
    input clk,
    input [31:0] hex_value,
    output reg [6:0] seg0,
    output reg [6:0] seg1,
    output reg [7:0] anode
);
    // 7-segment decoder
    function [6:0] seg7;
        input [3:0] digit;
        begin
            case (digit)
                4'h0: seg7 = 7'b1000000;
                4'h1: seg7 = 7'b1111001;
                4'h2: seg7 = 7'b0100100;
                4'h3: seg7 = 7'b0110000;
                4'h4: seg7 = 7'b0011001;
                4'h5: seg7 = 7'b0010010;
                4'h6: seg7 = 7'b0000010;
                4'h7: seg7 = 7'b1111000;
                4'h8: seg7 = 7'b0000000;
                4'h9: seg7 = 7'b0010000;
                4'hA: seg7 = 7'b0001000;
                4'hB: seg7 = 7'b0000011;
                4'hC: seg7 = 7'b1000110;
                4'hD: seg7 = 7'b0100001;
                4'hE: seg7 = 7'b0000110;
                4'hF: seg7 = 7'b0001110;
                default: seg7 = 7'b1111111;
            endcase
        end
    endfunction

    reg [19:0] counter = 0;
    wire [2:0] digit_sel = counter[18:16];

    always @(posedge clk) begin
        counter <= counter + 1;

        // Defaults to avoid X values
        anode <= 8'b11111111;
        seg0 <= 7'b1111111;
        seg1 <= 7'b1111111;

        case (digit_sel)
            3'd0: begin anode[0] <= 1'b0; seg0 <= seg7(hex_value[19:16]); end
            3'd1: begin anode[1] <= 1'b0; seg0 <= seg7(hex_value[23:20]); end
            3'd2: begin anode[2] <= 1'b0; seg0 <= seg7(hex_value[27:24]); end
            3'd3: begin anode[3] <= 1'b0; seg0 <= seg7(hex_value[31:28]); end
            3'd4: begin anode[4] <= 1'b0; seg1 <= seg7(hex_value[3:0]); end
            3'd5: begin anode[5] <= 1'b0; seg1 <= seg7(hex_value[7:4]); end
            3'd6: begin anode[6] <= 1'b0; seg1 <= seg7(hex_value[11:8]); end
            3'd7: begin anode[7] <= 1'b0; seg1 <= seg7(hex_value[15:12]); end
        endcase
    end
endmodule
