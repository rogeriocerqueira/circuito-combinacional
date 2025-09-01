module overflow_logic(
    input [1:0] op,
    input cout, borrow, div_zero,
    output overflow
);
    wire op0, op1;
    assign op0 = op[0];
    assign op1 = op[1];

    // Overflow para cada operação
    wire add_over, sub_over, div_over;
    assign add_over = ~op1 & ~op0 & cout;      // op=00 e cout=1
    assign sub_over = ~op1 & op0 & borrow;     // op=01 e borrow=1
    assign div_over = op1 & op0 & div_zero;    // op=11 e div_zero=1

    assign overflow = add_over | sub_over | div_over;
endmodule
