module part3 #(
    parameter AWIDTH = 32, 
    parameter BWIDTH = 32
)(
    input clk,
    input signed [127:0] complex_in,  // Combined input: 128 bits for ar, ai, br, bi
    output signed [127:0] complex_out  // Combined output: 128 bits for pr, pi
);

// Extract the individual parts from the combined input vector
wire signed [AWIDTH-1:0] ar, ai, br, bi;
assign ar = complex_in[127:96];   // Real part of the first complex number
assign ai = complex_in[95:64];    // Imaginary part of the first complex number
assign br = complex_in[63:32];    // Real part of the second complex number
assign bi = complex_in[31:0];     // Imaginary part of the second complex number

// Split the inputs into two parts (16 bits each)
wire signed [15:0] ar_hi, ar_lo, ai_hi, ai_lo;
wire signed [15:0] br_hi, br_lo, bi_hi, bi_lo;

assign ar_hi = ar[31:16];  // Most significant 16 bits of ar
assign ar_lo = ar[15:0];   // Least significant 16 bits of ar
assign ai_hi = ai[31:16];  // Most significant 16 bits of ai
assign ai_lo = ai[15:0];   // Least significant 16 bits of ai
assign br_hi = br[31:16];  // Most significant 16 bits of br
assign br_lo = br[15:0];   // Least significant 16 bits of br
assign bi_hi = bi[31:16];  // Most significant 16 bits of bi
assign bi_lo = bi[15:0];   // Least significant 16 bits of bi

// Pipeline registers for intermediate values
reg signed [AWIDTH+BWIDTH-1:0] pr_reg, pi_reg;
reg signed [AWIDTH+BWIDTH-1:0] pr_pipeline [0:2], pi_pipeline [0:2]; // 3 pipeline stages

// DSP slice operations for partial products
wire signed [31:0] p1_real, p2_real, p1_imag, p2_imag;
wire signed [31:0] p3_real, p4_real, p3_imag, p4_imag;

// Real part: (ar_hi * br_hi) - (ai_hi * bi_hi) + (ar_lo * br_lo) - (ai_lo * bi_lo)
DSP_slice dsp1 (
    .a(ar_hi), .b(br_hi), .result(p1_real)
);

DSP_slice dsp2 (
    .a(ai_hi), .b(bi_hi), .result(p2_real)
);

DSP_slice dsp3 (
    .a(ar_lo), .b(br_lo), .result(p3_real)
);

DSP_slice dsp4 (
    .a(ai_lo), .b(bi_lo), .result(p4_real)
);

// Imaginary part: (ar_hi * bi_hi) + (ai_hi * br_hi) + (ar_lo * bi_lo) + (ai_lo * br_lo)
DSP_slice dsp5 (
    .a(ar_hi), .b(bi_hi), .result(p1_imag)
);

DSP_slice dsp6 (
    .a(ai_hi), .b(br_hi), .result(p2_imag)
);

DSP_slice dsp7 (
    .a(ar_lo), .b(bi_lo), .result(p3_imag)
);

DSP_slice dsp8 (
    .a(ai_lo), .b(br_lo), .result(p4_imag)
);

// Addition of partial results (need to handle shifts)
always @(posedge clk) begin
    // Combine the results of the DSP slices
    pr_pipeline[0] <= p1_real - p2_real + p3_real - p4_real;
    pi_pipeline[0] <= p1_imag + p2_imag + p3_imag + p4_imag;

    // 2nd pipeline stage
    pr_pipeline[1] <= pr_pipeline[0];
    pi_pipeline[1] <= pi_pipeline[0];

    // 3rd pipeline stage
    pr_pipeline[2] <= pr_pipeline[1];
    pi_pipeline[2] <= pi_pipeline[1];

    // Final outputs
    pr_reg <= pr_pipeline[2];
    pi_reg <= pi_pipeline[2];
end

// Combine real and imaginary outputs into a single 128-bit vector
assign complex_out = {pr_reg, pi_reg};

endmodule

// DSP slice model 
module DSP_slice (
    input signed [15:0] a,
    input signed [15:0] b,
    output signed [31:0] result
);
assign result = a * b;
endmodule
