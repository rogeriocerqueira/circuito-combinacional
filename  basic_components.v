// -----------------------------------------------------------------------------
// Arquivo:         basic_components.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Uma biblioteca de componentes de hardware estruturais,
//                  pequenos e reutilizáveis, que formam a base para os
//                  módulos mais complexos da Unidade Aritmética.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

// =============================================================================
// MÓDULO: Decodificador 2-para-4
// DESCRIÇÃO: Converte uma entrada de 2 bits em uma saída "one-hot" de 4 bits.
// USADO EM:   arithmetic_unit.v (para selecionar a operação)
// =============================================================================
module decoder_2to4(
    input [1:0] in,
    output [3:0] out
);
    // Lógica combinacional direta para cada saída
    assign out[0] = ~in[1] & ~in[0]; // Ativo quando in = 2'b00
    assign out[1] = ~in[1] &  in[0]; // Ativo quando in = 2'b01
    assign out[2] =  in[1] & ~in[0]; // Ativo quando in = 2'b10
    assign out[3] =  in[1] &  in[0]; // Ativo quando in = 2'b11
endmodule


// =============================================================================
// MÓDULO: Multiplexador 2-para-1 de 4 bits de largura
// DESCRIÇÃO: Seleciona entre duas entradas de 4 bits (a ou b) com base no
//            sinal de seleção (sel).
// USADO EM:   restoring_divider_cell.v
// =============================================================================
module mux2_1_4bit(
    input [3:0] a, 
    input [3:0] b,
    input sel,
    output [3:0] out
);
    wire [3:0] term_a, term_b;
    wire not_sel;

    not g_not_sel(not_sel, sel);

    // Lógica para habilitar a passagem da entrada 'a' quando sel=0
    and g_anda_0(term_a[0], a[0], not_sel);
    and g_anda_1(term_a[1], a[1], not_sel);
    and g_anda_2(term_a[2], a[2], not_sel);
    and g_anda_3(term_a[3], a[3], not_sel);

    // Lógica para habilitar a passagem da entrada 'b' quando sel=1
    and g_andb_0(term_b[0], b[0], sel);
    and g_andb_1(term_b[1], b[1], sel);
    and g_andb_2(term_b[2], b[2], sel);
    and g_andb_3(term_b[3], b[3], sel);

    // Combina os termos para formar a saída final
    or g_or_0(out[0], term_a[0], term_b[0]);
    or g_or_1(out[1], term_a[1], term_b[1]);
    or g_or_2(out[2], term_a[2], term_b[2]);
    or g_or_3(out[3], term_a[3], term_b[3]);
endmodule


// =============================================================================
// MÓDULO: Meio Somador (Half Adder)
// DESCRIÇÃO: Soma dois bits (a, b) e produz uma soma (s) e um transporte (cout).
// USADO EM:   multiplier_4x4.v
// =============================================================================
module half_adder(
    input a, 
    input b,
    output s, 
    output cout
);
    // Implementação estrutural padrão
    xor g1_xor (s, a, b);
    and g2_and (cout, a, b);
endmodule


// =============================================================================
// MÓDULO: Somador Completo (Full Adder)
// DESCRIÇÃO: Soma três bits (a, b, cin) e produz uma soma (s) e um transporte (cout).
// USADO EM:   adder_4bit.v, multiplier_4x4.v
// NOTA:       Poderia estar em seu próprio arquivo (full_adder.v), mas é
//             comum agrupá-lo com o half_adder.
// =============================================================================
module full_adder(
    input a, 
    input b, 
    input cin,
    output s, 
    output cout
);
    wire w1, w2, w3;
    
    // Lógica da soma: (a XOR b) XOR cin
    xor g1_xor_s1 (w1, a, b);
    xor g2_xor_s2 (s, w1, cin);
    
    // Lógica do transporte: ((a XOR b) AND cin) OR (a AND b)
    and g3_and_c1 (w2, w1, cin);
    and g4_and_c2 (w3, a, b);
    or  g5_or_cout (cout, w2, w3);
endmodule