`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 11:06:51 PM
// Design Name: 
// Module Name: part1
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


module part1 # (parameter AWIDTH = 16, BWIDTH = 18)
(
    input clk,
    input signed [AWIDTH-1:0] ar, ai,
    input signed [BWIDTH-1:0] br, bi,
    output signed [AWIDTH+BWIDTH:0] pr, pi
);

    reg signed [AWIDTH-1:0] ai_d, ai_dd, ai_ddd, ai_dddd;
    reg signed [AWIDTH-1:0] ar_d, ar_dd, ar_ddd, ar_dddd;
    reg signed [BWIDTH-1:0] bi_d, bi_dd, bi_ddd, br_d, br_dd, br_ddd;
    reg signed [AWIDTH:0] addcommon;
    reg signed [BWIDTH:0] addr, addi;
    reg signed [AWIDTH+BWIDTH:0] mult0, multr, multi, pr_int, pi_int;
    reg signed [AWIDTH+BWIDTH:0] common, commonr1, commonr2;

    always @(posedge clk)
    begin
        ar_d <= ar;
        ar_dd <= ar_d;
        ar_ddd <= ar_dd;
        ar_dddd <= ar_ddd;
        ai_d <= ai;
        ai_dd <= ai_d;
        ai_ddd <= ai_dd;
        ai_dddd <= ai_ddd;
        br_d <= br;
        br_dd <= br_d;
        br_ddd <= br_dd;
        bi_d <= bi;
        bi_dd <= bi_d;
        bi_ddd <= bi_dd;
    end

    always @(posedge clk)
    begin
        addcommon <= ar_d - ai_d;  // (a - b)
        mult0 <= addcommon * bi_dd;  // (a - b) * d = ad - bd
        common <= mult0;
    end

    // Real product
    always @(posedge clk)
    begin
        ar_ddd <= ar_dd;
        ar_dddd <= ar_ddd;
        addr <= br_ddd - bi_ddd;  // (c - d)
        multr <= addr * ar_dddd;  // (c - d) * a = ac - ad
        commonr1 <= common;
        pr_int <= multr + commonr1;  // ac - bd
    end

    // Imaginary product
    always @(posedge clk)
    begin
        ai_ddd <= ai_dd;
        ai_dddd <= ai_ddd;
        addi <= br_ddd + bi_ddd;
        multi <= addi * ai_dddd;
        commonr2 <= common;
        pi_int <= multi + commonr2;
    end

    assign pr = pr_int;
    assign pi = pi_int;

endmodule // cault

