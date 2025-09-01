// -----------------------------------------------------------------------------
// Arquivo:         adder_4bit.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Implementação estrutural de um somador de 4 bits do tipo
//                  "Ripple-Carry Adder".
//
// Dependências:
//   - full_adder.v
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module adder_4bit(
    input [3:0] A, 
    input [3:0] B,
    input cin,
    output [3:0] S,
    output cout
);

    // Fios internos para conectar o carry_out de um somador
    // ao carry_in do próximo.
    wire c1, c2, c3;
    
    // Estágio 0: Soma os bits menos significativos (LSB)
    // O carry de entrada (cin) do módulo entra aqui.
    full_adder fa0 (
        .a(A[0]), 
        .b(B[0]), 
        .cin(cin), 
        .s(S[0]), 
        .cout(c1)
    );
    
    // Estágio 1: Soma o segundo par de bits
    // O carry de entrada é o carry de saída do estágio anterior (c1).
    full_adder fa1 (
        .a(A[1]), 
        .b(B[1]), 
        .cin(c1), 
        .s(S[1]), 
        .cout(c2)
    );
    
    // Estágio 2: Soma o terceiro par de bits
    full_adder fa2 (
        .a(A[2]), 
        .b(B[2]), 
        .cin(c2), 
        .s(S[2]), 
        .cout(c3)
    );
    
    // Estágio 3: Soma os bits mais significativos (MSB)
    // O carry de saída deste estágio é o carry de saída final do somador.
    full_adder fa3 (
        .a(A[3]), 
        .b(B[3]), 
        .cin(c3), 
        .s(S[3]), 
        .cout(cout)
    );

endmodule