`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 11:06:51 PM
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


module part3(
    input clk,
    input signed [31:0] ar, ai,
    input signed [31:0] br, bi,
    output reg signed [63:0] pr, pi
);
    reg signed [15:0] arh, aih, brh, bih; 
    reg signed [16:0] arl, ail, brl, bil;
    
    reg signed [32:0] arh_brh, arh_brl, arl_brh, arl_brl; //A*B results
    reg signed [32:0] aih_bih, aih_bil, ail_bih, ail_bil; //a*b results
    reg signed [32:0] arh_bih, arh_bil, arl_bih, arl_bil; //A*b results
    reg signed [32:0] aih_brh, aih_brl, ail_brh, ail_brl; //a*B results
    
//    reg signed [63:0] ar_br1, ar_br2, ar_br3;  // For ar * br
//    reg signed [63:0] ai_bi1, ai_bi2, ai_bi3;  // For ai * bi
//    reg signed [63:0] ar_bi1, ar_bi2, ar_bi3;  // For ar * bi
//    reg signed [63:0] ai_br1, ai_br2, ai_br3;  // For ai * br
    
//    reg signed [63:0] arh_brh_shift, arh_brl_shift, arl_brh_shift, arl_brl_shift; //A*B results
//    reg signed [63:0] aih_bih_shift, aih_bil_shift, ail_bih_shift, ail_bil_shift; //a*b results
//    reg signed [63:0] arh_bih_shift, arh_bil_shift, arl_bih_shift, arl_bil_shift; //A*b results
//    reg signed [63:0] aih_brh_shift, aih_brl_shift, ail_brh_shift, ail_brl_shift; //a*B results
    
    reg signed [63:0] ar_br, ai_bi, ar_bi, ai_br; //A,B,a,b resuls
    
    
    // Perform the multiplication
    always@(posedge clk) begin
        arh <= ar[31:16]; //Assign the low and high register values
        arl <= {1'b0,ar[15:0]};
        aih <= ai[31:16];
        ail <= {1'b0,ai[15:0]};
        brh <= br[31:16];
        brl <= {1'b0,br[15:0]};
        bih <= bi[31:16];
        bil <= {1'b0,bi[15:0]};
        
        //A*B
        arh_brh <= arh*brh;
        arh_brl <= arh*brl;
        arl_brh <= arl*brh;
        arl_brl <= arl*brl;
        //a*b
        aih_bih <= aih*bih; 
        aih_bil <= aih*bil; 
        ail_bih <= ail*bih; 
        ail_bil <= ail*bil; 
        //A*b
        arh_bih <= arh*bih; 
        arh_bil <= arh*bil;
        arl_bih <= arl*bih; 
        arl_bil <= arl*bil; 
        //a*B
        aih_brh <= aih*brh; 
        aih_brl <= aih*brl; 
        ail_brh <= ail*brh; 
        ail_brl <= ail*brl;
//        pr <= ail*brh;
//        pi <= aih*brl;
    end
   
    always @(posedge clk) begin
    
        /*arh_brh_shift <= arh_brh << 32;  // Bits [63:32]
        arh_brl_shift <= arh_brl << 16;  // Bits [47:16]
        arl_brh_shift <= arl_brh << 16;  // Bits [47:16]
        arl_brl_shift <= arl_brl;        // Bits [31:0] (no shift needed)
        
        // Shifted partial products for ai * bi
        aih_bih_shift <= aih_bih << 32;  // Bits [63:32]
        aih_bil_shift <= aih_bil << 16;  // Bits [47:16]
        ail_bih_shift <= ail_bih << 16;  // Bits [47:16]
        ail_bil_shift <= ail_bil;        // Bits [31:0]
        
        // Shifted partial products for ar * bi
        arh_bih_shift <= arh_bih << 32;  // Bits [63:32]
        arh_bil_shift <= arh_bil << 16;  // Bits [47:16]
        arl_bih_shift <= arl_bih << 16;  // Bits [47:16]
        arl_bil_shift <= arl_bil;        // Bits [31:0]
        
        // Shifted partial products for ai * br
        aih_brh_shift <= aih_brh << 32;  // Bits [63:32]
        aih_brl_shift <= aih_brl << 16;  // Bits [47:16]
        ail_brh_shift <= ail_brh << 16;  // Bits [47:16]
        ail_brl_shift <= ail_brl;        // Bits [31:0]
        
        ar_br1 <= arh_brh_shift + arh_brl_shift;       // Step 1: arh_brh << 32 + arh_brl << 16
        ar_br2 <= ar_br1 + arl_brh_shift;              // Step 2: + arl_brh << 16
        ar_br3 <= ar_br2 + arl_brl_shift;              // Step 3: + arl_brl (no shift)
        
        // ai * bi
        ai_bi1 <= aih_bih_shift + aih_bil_shift;       // Step 1: aih_bih << 32 + aih_bil << 16
        ai_bi2 <= ai_bi1 + ail_bih_shift;              // Step 2: + ail_bih << 16
        ai_bi3 <= ai_bi2 + ail_bil_shift;              // Step 3: + ail_bil (no shift)
        
        // ar * bi
        ar_bi1 <= arh_bih_shift + arh_bil_shift;       // Step 1: arh_bih << 32 + arh_bil << 16
        ar_bi2 <= ar_bi1 + arl_bih_shift;              // Step 2: + arl_bih << 16
        ar_bi3 <= ar_bi2 + arl_bil_shift;              // Step 3: + arl_bil (no shift)
        
        // ai * br
        ai_br1 <= aih_brh_shift + aih_brl_shift;       // Step 1: aih_brh << 32 + aih_brl << 16
        ai_br2 <= ai_br1 + ail_brh_shift;              // Step 2: + ail_brh << 16
        ai_br3 <= ai_br2 + ail_brl_shift;*/
        
        ar_br <= (arh_brh << 32) + (arh_brl << 16) +
                 (arl_brh << 16) + (arl_brl);
        ai_bi <= (aih_bih << 32) + (aih_bil << 16) +
                 (ail_bih << 16) + (ail_bil);
        ar_bi <= (arh_bih << 32) + (arh_bil << 16) +
                 (arl_bih << 16) + (arl_bil);
        ai_br <= (aih_brh << 32) + (aih_brl << 16) +
                 (ail_brh << 16) + (ail_brl);
        pr <= ar_br - ai_bi;
        pi <= ar_bi + ai_br;
    end
endmodule
