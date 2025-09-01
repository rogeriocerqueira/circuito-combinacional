// -----------------------------------------------------------------------------
// Arquivo:         multiplier_4x4.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Implementação estrutural de um multiplicador 4x4 do tipo
//                  "Array Multiplier".
//
// Dependências:
//   - full_adder.v
//   - half_adder.v (Meio-somador, necessário para a primeira soma de cada linha)
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

// É uma boa prática colocar o Meio-Somador em seu próprio arquivo
// ou em um arquivo de componentes básicos. Se não o fez, pode incluí-lo aqui.
// module half_adder(input a, b, output s, cout);
//     xor(s, a, b);
//     and(cout, a, b);
// endmodule


module multiplier_4x4(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P // P for Product
);

    // --- Etapa 1: Geração de Produtos Parciais ---
    // Matriz 4x4 de portas AND para gerar todos os p_ij = A[i] & B[j]
    wire p00, p01, p02, p03;
    wire p10, p11, p12, p13;
    wire p20, p21, p22, p23;
    wire p30, p31, p32, p33;

    and g_p00(p00, A[0], B[0]); and g_p01(p01, A[0], B[1]); and g_p02(p02, A[0], B[2]); and g_p03(p03, A[0], B[3]);
    and g_p10(p10, A[1], B[0]); and g_p11(p11, A[1], B[1]); and g_p12(p12, A[1], B[2]); and g_p13(p13, A[1], B[3]);
    and g_p20(p20, A[2], B[0]); and g_p21(p21, A[2], B[1]); and g_p22(p22, A[2], B[2]); and g_p23(p23, A[2], B[3]);
    and g_p30(p30, A[3], B[0]); and g_p31(p31, A[3], B[1]); and g_p32(p32, A[3], B[2]); and g_p33(p33, A[3], B[3]);

    // O bit menos significativo do produto é direto, sem somas.
    assign P[0] = p00;
    
    // --- Etapa 2: Matriz de Somadores ---
    
    // Fios para as saídas de soma (S) e transporte (C) de cada linha de somadores
    wire s11, s12, s13, c11, c12, c13;
    wire s21, s22, s23, c21, c22, c23;
    
    // -- LINHA 1 de Somadores: Soma o 1º e 2º produtos parciais --
    //   p10   p01
    half_adder ha1(p10, p01, P[1], c11);
    
    //   p20   p11   c11
    full_adder fa12(p20, p11, c11, s11, c12);
    
    //   p30   p21   c12
    full_adder fa13(p30, p21, c12, s12, c13);
    
    //   0   p31   c13
    full_adder fa14(1'b0, p31, c13, s13, c_final_linha1);


    // -- LINHA 2 de Somadores: Soma o resultado da Linha 1 com o 3º produto parcial --
    //   s11   p02
    half_adder ha2(s11, p02, P[2], c21);
    
    //   s12   p12   c21
    full_adder fa22(s12, p12, c21, s21, c22);
    
    //   s13   p22   c22
    full_adder fa23(s13, p22, c22, s22, c23);
    
    // c_final_linha1 p32 c23
    full_adder fa24(c_final_linha1, p32, c23, s23, c_final_linha2);

    
    // -- LINHA 3 de Somadores: Soma o resultado da Linha 2 com o 4º produto parcial --
    //   s21   p03
    half_adder ha3(s21, p03, P[3], c31);
    
    //   s22   p13   c31
    full_adder fa32(s22, p13, c31, P[4], c32);
    
    //   s23   p23   c32
    full_adder fa33(s23, p23, c32, P[5], c33);
    
    // c_final_linha2 p33 c33
    full_adder fa34(c_final_linha2, p33, c33, P[6], P[7]);

endmodule