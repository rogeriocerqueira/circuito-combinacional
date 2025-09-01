// -----------------------------------------------------------------------------
// Arquivo:         subtractor_4bit.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Implementação estrutural de um subtrator de 4 bits.
//                  Utiliza a técnica de complemento de dois, implementando
//                  A - B como A + (~B + 1).
//
// Dependências:
//   - adder_4bit.v
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module subtractor_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] D, // D for Difference (D = A - B)
    output borrow
);

    // --- Fios Internos ---

    // Fio para armazenar a versão invertida de B (Complemento de Um)
    wire [3:0] B_inv;
    
    // Fio para o carry de saída do somador interno
    wire adder_cout;

    // --- Lógica Estrutural ---

    // 1. Inverter todos os bits de B. Este é o "Complemento de Um".
    //    Isto é o '~B' da fórmula.
    not inv0 (B_inv[0], B[0]);
    not inv1 (B_inv[1], B[1]);
    not inv2 (B_inv[2], B[2]);
    not inv3 (B_inv[3], B[3]);
    
    // 2. Usar um somador para calcular A + B_inv + 1.
    //    O '+ 1' é injetado através do pino de carry de entrada (cin),
    //    completando assim a operação de "Complemento de Dois".
    adder_4bit sub_adder_inst (
        .A(A),
        .B(B_inv),
        .cin(1'b1), // Fornece o '+ 1' para o complemento de dois
        .S(D),
        .cout(adder_cout)
    );
    
    // 3. Calcular o 'borrow' (empréstimo).
    //    Na subtração usando complemento de dois, um 'borrow' ocorre se
    //    o carry de saída do somador for 0. Portanto, borrow = NOT(cout).
    not borrow_gate (borrow, adder_cout);

endmodule