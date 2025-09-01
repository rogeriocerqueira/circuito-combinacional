// -----------------------------------------------------------------------------
// Arquivo:         mux2_1_4bit.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Multiplexador 2-para-1 de 4 bits de largura.
//                  Se sel=0, out = a. Se sel=1, out = b.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module mux2_1_4bit(
    input [3:0] a, 
    input [3:0] b,
    input sel,
    output [3:0] out
);
    // Implementação estrutural usando portas lógicas primitivas
    wire [3:0] term_a, term_b;
    wire not_sel;

    not g_not_sel(not_sel, sel);

    and g_anda_0(term_a[0], a[0], not_sel);
    and g_anda_1(term_a[1], a[1], not_sel);
    and g_anda_2(term_a[2], a[2], not_sel);
    and g_anda_3(term_a[3], a[3], not_sel);

    and g_andb_0(term_b[0], b[0], sel);
    and g_andb_1(term_b[1], b[1], sel);
    and g_andb_2(term_b[2], b[2], sel);
    and g_andb_3(term_b[3], b[3], sel);

    or g_or_0(out[0], term_a[0], term_b[0]);
    or g_or_1(out[1], term_a[1], term_b[1]);
    or g_or_2(out[2], term_a[2], term_b[2]);
    or g_or_3(out[3], term_a[3], term_b[3]);

endmodule