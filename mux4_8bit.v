module mux4_8bit(
    input [7:0] in0, in1, in2, in3,
    input [1:0] sel,
    output [7:0] out
);
    wire [7:0] w0, w1;

    // Dois mux 2x1 para cada bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_bits
            wire m1, m2;
            assign m1 = (sel[0]) ? in1[i] : in0[i];
            assign m2 = (sel[0]) ? in3[i] : in2[i];
            assign out[i] = (sel[1]) ? m2 : m1;
        end
    endgenerate
endmodule
