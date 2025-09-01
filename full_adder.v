// -----------------------------------------------------------------------------
// Arquivo:         full_adder.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Implementação estrutural de um somador completo de 1 bit.
//                  Soma três bits de entrada (a, b, cin) e produz uma soma (s)
//                  e um transporte de saída (cout).
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module full_adder(
    input a, 
    input b, 
    input cin,
    output s, 
    output cout
);

    // Fios internos para os resultados intermediários das portas lógicas
    wire w1, w2, w3;
    
    // A lógica da soma é (a XOR b) XOR cin
    xor g1_xor_s1 (w1, a, b);
    xor g2_xor_s2 (s, w1, cin);
    
    // A lógica do transporte de saída é ((a XOR b) AND cin) OR (a AND b)
    and g3_and_c1 (w2, w1, cin);
    and g4_and_c2 (w3, a, b);
    or  g5_or_cout (cout, w2, w3);

endmodule