`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 11:06:51 PM
// Design Name: 
// Module Name: part2
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


module part2 # (parameter AWIDTH = 16, BWIDTH = 18)
(
    input clk,
    input signed [AWIDTH-1:0] ar, ai,
    input signed [BWIDTH-1:0] br, bi,
    output signed [AWIDTH+BWIDTH:0] pr, pi
);

    reg signed [AWIDTH-1:0] ai_d, ai_dd;
    reg signed [AWIDTH-1:0] ar_d;
    reg signed [BWIDTH-1:0] bi_d, bi_dd, br_d, br_dd;
    reg signed [AWIDTH+BWIDTH:0] AB, ab, Ab, aB, Ab2, AB2;
    reg signed [AWIDTH+BWIDTH:0] pr_int, pi_int;

    always @(posedge clk)
    begin
        ar_d <= ar;
        ai_d <= ai;
        ai_dd <= ai_d;
        br_d <= br;
        br_dd <= br_d;
        bi_d <= bi;
        bi_dd <= bi_d;
    end


    //
    always @(posedge clk)
    begin
        Ab <= ar_d*bi_d; // Ab
        AB <= ar_d*br_d; // AB
        Ab2 <= Ab; // Push to next stage
        AB2 <= AB;
        
        
        aB <= ai_dd*br_dd; //aB
        ab <= ai_dd*bi_dd; //ab
        pr_int <= AB2-ab; //AB-ab for real part
        pi_int <= Ab2+aB; //Ab+aB for imaginary part
        
    end

    assign pr = pr_int;
    assign pi = pi_int;

endmodule // cault
