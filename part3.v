`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 10:35:58 AM
// Design Name: 
// Module Name: part3
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


module part3 # (parameter AWIDTH = 32, BWIDTH = 32)
(
    input clk,
    input signed [AWIDTH-1:0] ar, ai,
    input signed [BWIDTH-1:0] br, bi,
    output signed [AWIDTH+BWIDTH:0] pr, pi
);

    // Pipeline registers for partial products
    reg signed [17:0] ar_low, ar_high, ai_low, ai_high;
    reg signed [17:0] br_low, br_high, bi_low, bi_high;

    reg signed [35:0] p1, p2, p3, p4, p5, p6, p7, p8;
    reg signed [67:0] pr_stage1, pi_stage1;

    // Stage 1: Split inputs and perform partial multiplications
    always @(posedge clk) begin
        ar_low <= ar[16:0];
        ar_high <= ar[31:17];
        ai_low <= ai[16:0];
        ai_high <= ai[31:17];
        br_low <= br[16:0];
        br_high <= br[31:17];
        bi_low <= bi[16:0];
        bi_high <= bi[31:17];

        p1 <= ar_low * br_low;
        p2 <= ar_low * br_high;
        p3 <= ar_high * br_low;
        p4 <= ar_high * br_high;
        p5 <= ai_low * bi_low;
        p6 <= ai_low * bi_high;
        p7 <= ai_high * bi_low;
        p8 <= ai_high * bi_high;
    end

    // Stage 2: Combine partial results for real and imaginary outputs
    always @(posedge clk) begin
        pr_stage1 <= (p4 << 34) + ((p2 + p3) << 17) + p1 - ((p8 << 34) + ((p6 + p7) << 17) + p5);
        pi_stage1 <= ((p2 + p3) << 17) + p1 + ((p6 + p7) << 17) + p5;
    end

    // Stage 3: Final pipeline stage
    reg signed [AWIDTH+BWIDTH:0] pr_int, pi_int;
    always @(posedge clk) begin
        pr_int <= pr_stage1;
        pi_int <= pi_stage1;
    end

    assign pr = pr_int;
    assign pi = pi_int;

endmodule

