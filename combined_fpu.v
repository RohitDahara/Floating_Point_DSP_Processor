`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2025
// Design Name: 
// Module Name: CombinedFPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Floating Point ALU with Add, Sub, Mul, Div and MAC operations
// 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module CombinedFPU (
    input wire clk,
    input wire rst,
    input wire [2:0] alu_op,    // ALU operation select (includes MAC)
    input wire [31:0] operand_a,
    input wire [31:0] operand_b,
    input wire [31:0] operand_c, // For MAC accumulate (only used for MAC operation)
    output wire [31:0] result
);

    // Intermediate signals for operation results
    wire [31:0] add_result, sub_result, mul_result, div_result, mac_result;
    reg [31:0] result_reg;

    // ALU Operation selection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result_reg <= 32'b0;
        end else begin
            case (alu_op)
                3'b000: result_reg <= add_result;
                3'b001: result_reg <= sub_result;
                3'b010: result_reg <= mul_result;
                3'b011: result_reg <= div_result;
                3'b111: result_reg <= mac_result;
                default: result_reg <= 32'b0;
            endcase
        end
    end

    // Instantiate floating-point operation modules
    fp_adder add_module (
        .clk(clk),
        .rst(rst),
        .a(operand_a),
        .b(operand_b),
        .result(add_result)
    );

    fp_subtractor sub_module (
        .clk(clk),
        .rst(rst),
        .a(operand_a),
        .b(operand_b),
        .result(sub_result)
    );

    fp_multiplier mul_module (
        .clk(clk),
        .rst(rst),
        .a(operand_a),
        .b(operand_b),
        .result(mul_result)
    );

    fp_divider div_module (
        .clk(clk),
        .rst(rst),
        .a(operand_a),
        .b(operand_b),
        .result(div_result)
    );

    fp_mac mac_module (
        .clk(clk),
        .rst(rst),
        .a(operand_a),
        .b(operand_b),
        .acc(operand_c),
        .result(mac_result)
    );

    assign result = result_reg;

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Floating-Point Adder
//////////////////////////////////////////////////////////////////////////////////
module fp_adder (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

    // Internal signals
    reg [7:0] exp_a, exp_b;
    reg [23:0] mant_a, mant_b;
    reg sign_a, sign_b;
    reg [7:0] exp_diff;
    reg [23:0] aligned_a, aligned_b;
    reg [7:0] exp_common;
    reg [24:0] sum_mant;
    reg result_sign;

    // Decompose inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_a <= 0; sign_b <= 0;
            exp_a <= 0; exp_b <= 0;
            mant_a <= 0; mant_b <= 0;
        end else begin
            sign_a <= a[31];
            sign_b <= b[31];
            exp_a <= a[30:23];
            exp_b <= b[30:23];
            mant_a <= {1'b1, a[22:0]};
            mant_b <= {1'b1, b[22:0]};
        end
    end

    // Align exponents
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            aligned_a <= 0;
            aligned_b <= 0;
            exp_common <= 0;
        end else begin
            if (exp_a > exp_b) begin
                exp_diff <= exp_a - exp_b;
                aligned_a <= mant_a;
                aligned_b <= mant_b >> exp_diff;
                exp_common <= exp_a;
            end else begin
                exp_diff <= exp_b - exp_a;
                aligned_a <= mant_a >> exp_diff;
                aligned_b <= mant_b;
                exp_common <= exp_b;
            end
        end
    end

    // Add mantissas (check signs and perform addition/subtraction)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_mant <= 0;
            result_sign <= 0;
        end else begin
            if (sign_a == sign_b) begin
                sum_mant <= aligned_a + aligned_b;
                result_sign <= sign_a;
            end else begin
                if (aligned_a >= aligned_b) begin
                    sum_mant <= aligned_a - aligned_b;
                    result_sign <= sign_a;
                end else begin
                    sum_mant <= aligned_b - aligned_a;
                    result_sign <= sign_b;
                end
            end
        end
    end

    // Normalize and pack result
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
        end else begin
            // Normalize the result if necessary
            if (sum_mant[24]) begin
                sum_mant <= sum_mant >> 1;
                exp_common <= exp_common + 1;
            end else begin
                // Shift left until the leading bit is 1 or until exp_common becomes zero
                if (!sum_mant[23] && exp_common > 0) begin
                    sum_mant <= sum_mant << 1;
                    exp_common <= exp_common - 1;
                end
            end
            result <= {result_sign, exp_common, sum_mant[22:0]};
        end
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
// Floating-Point Subtractor (Similar to Adder)
//////////////////////////////////////////////////////////////////////////////////
module fp_subtractor (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

    // Internal signals (similar to fp_adder)
    reg [7:0] exp_a, exp_b;
    reg [23:0] mant_a, mant_b;
    reg sign_a, sign_b;
    reg [7:0] exp_diff;
    reg [23:0] aligned_a, aligned_b;
    reg [7:0] exp_common;
    reg [24:0] diff_mant;
    reg result_sign;

    // Decompose inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_a <= 0; sign_b <= 0;
            exp_a <= 0; exp_b <= 0;
            mant_a <= 0; mant_b <= 0;
        end else begin
            sign_a <= a[31];
            sign_b <= b[31];
            exp_a <= a[30:23];
            exp_b <= b[30:23];
            mant_a <= {1'b1, a[22:0]};
            mant_b <= {1'b1, b[22:0]};
        end
    end

    // Align exponents
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            aligned_a <= 0;
            aligned_b <= 0;
            exp_common <= 0;
        end else begin
            if (exp_a > exp_b) begin
                exp_diff <= exp_a - exp_b;
                aligned_a <= mant_a;
                aligned_b <= mant_b >> exp_diff;
                exp_common <= exp_a;
            end else begin
                exp_diff <= exp_b - exp_a;
                aligned_a <= mant_a >> exp_diff;
                aligned_b <= mant_b;
                exp_common <= exp_b;
            end
        end
    end

    // Subtract mantissas (check signs and perform addition/subtraction)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            diff_mant <= 0;
            result_sign <= 0;
        end else begin
            if (sign_a == sign_b) begin
                diff_mant <= aligned_a - aligned_b;
                result_sign <= sign_a;
            end else begin
                if (aligned_a >= aligned_b) begin
                    diff_mant <= aligned_a + aligned_b;
                    result_sign <= sign_a;
                end else begin
                    diff_mant <= aligned_b + aligned_a;
                    result_sign <= sign_b;
                end
            end
        end
    end

    // Normalize and pack result
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
        end else begin
            // Normalize the result if necessary
            if (diff_mant[24]) begin
                diff_mant <= diff_mant >> 1;
                exp_common <= exp_common + 1;
            end else begin
                // Shift left until the leading bit is 1 or until exp_common becomes zero
                if (!diff_mant[23] && exp_common > 0) begin
                    diff_mant <= diff_mant << 1;
                    exp_common <= exp_common - 1;
                end
            end
            result <= {result_sign, exp_common, diff_mant[22:0]};
        end
    end

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Floating-Point Multiplier
//////////////////////////////////////////////////////////////////////////////////
module fp_multiplier (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

    // Internal signals
    reg [7:0] exp_a, exp_b;
    reg [23:0] mant_a, mant_b;
    reg sign_a, sign_b;
    reg [47:0] product_mant;
    reg [7:0] product_exp;
    reg result_sign;

    // Decompose inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_a <= 0; sign_b <= 0;
            exp_a <= 0; exp_b <= 0;
            mant_a <= 0; mant_b <= 0;
        end else begin
            sign_a <= a[31];
            sign_b <= b[31];
            exp_a <= a[30:23];
            exp_b <= b[30:23];
            mant_a <= {1'b1, a[22:0]};
            mant_b <= {1'b1, b[22:0]};
        end
    end

    // Multiply mantissas and add exponents
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_mant <= 0;
            product_exp <= 0;
            result_sign <= 0;
        end else begin
            product_mant <= mant_a * mant_b;
            product_exp <= exp_a + exp_b - 8'h7F; // Subtract bias (127 for IEEE-754 single precision)
            result_sign <= sign_a ^ sign_b; // XOR the signs for the result
        end
    end

    // Normalize and pack result
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
        end else begin
            if (product_mant[47]) begin
                product_mant <= product_mant >> 1;
                product_exp <= product_exp + 1;
            end else begin
                while (!product_mant[46] && product_exp > 0) begin
                    product_mant <= product_mant << 1;
                    product_exp <= product_exp - 1;
                end
            end
            result <= {result_sign, product_exp, product_mant[46:24]};
        end
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
// Floating-Point Divider
//////////////////////////////////////////////////////////////////////////////////
module fp_divider (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);

    // Internal signals
    reg [7:0] exp_a, exp_b;
    reg [23:0] mant_a, mant_b;
    reg sign_a, sign_b;
    reg [47:0] quotient_mant;
    reg [7:0] quotient_exp;
    reg result_sign;

    // Decompose inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_a <= 0; sign_b <= 0;
            exp_a <= 0; exp_b <= 0;
            mant_a <= 0; mant_b <= 0;
        end else begin
            sign_a <= a[31];
            sign_b <= b[31];
            exp_a <= a[30:23];
            exp_b <= b[30:23];
            mant_a <= {1'b1, a[22:0]};
            mant_b <= {1'b1, b[22:0]};
        end
    end

    // Divide mantissas and subtract exponents
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient_mant <= 0;
            quotient_exp <= 0;
            result_sign <= 0;
        end else begin
            quotient_mant <= mant_a / mant_b;
            quotient_exp <= exp_a - exp_b + 8'h7F; // Add bias (127 for IEEE-754 single precision)
            result_sign <= sign_a ^ sign_b; // XOR the signs for the result
        end
    end

    // Normalize and pack result
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
        end else begin
            if (quotient_mant[47]) begin
                quotient_mant <= quotient_mant >> 1;
                quotient_exp <= quotient_exp + 1;
            end else begin
                while (!quotient_mant[46] && quotient_exp > 0) begin
                    quotient_mant <= quotient_mant << 1;
                    quotient_exp <= quotient_exp - 1;
                end
            end
            result <= {result_sign, quotient_exp, quotient_mant[46:24]};
        end
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
// Floating-Point Multiply-Accumulate (MAC)
//////////////////////////////////////////////////////////////////////////////////
module fp_mac (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    input [31:0] acc, // Accumulator input
    output reg [31:0] result
);

    // Internal signals
    wire [31:0] mul_result;
    wire [31:0] add_result;

    // Instantiate multiplier and adder
    fp_multiplier mul_module (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .result(mul_result)
    );

    fp_adder add_module (
        .clk(clk),
        .rst(rst),
        .a(mul_result),
        .b(acc),
        .result(add_result)
    );

    // Output is the result of add operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
        end else begin
            result <= add_result;
        end
    end

endmodule
