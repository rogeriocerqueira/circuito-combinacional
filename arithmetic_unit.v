// -----------------------------------------------------------------------------
// Arquivo:         arithmetic_unit.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Módulo de topo (top-level) que integra todos os componentes
//                  aritméticos. Este design é puramente estrutural.
//
// Dependências (precisa dos seguintes arquivos no mesmo projeto/diretório):
//   - adder_4bit.v
//   - subtractor_4bit.v
//   - multiplier_4x4.v
//   - divider_4bit.v
//   - basic_components.v (ou arquivos separados para decoder, mux, etc.)
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module arithmetic_unit(
    input [3:0] A, B,
    input [1:0] op,
    output [7:0] result,
    output zero, 
    output overflow
);

    // --- Fios Internos ---
    
    // Fios para os resultados brutos de cada operação
    wire [3:0] sum, diff;
    wire [7:0] prod;
    wire [3:0] quot, rem;
    
    // Fios para as flags de status de cada operação
    wire cout_add, borrow_sub, div_by_zero;
    
    // Fios para os resultados formatados em 8 bits, prontos para o MUX
    wire [7:0] add_res, sub_res, mul_res, div_res;

    // Fios para a lógica de controle (seleção de operação e flags)
    wire [3:0] sel;
    wire ovf_add, ovf_sub, ovf_div;

    // --- Instanciação dos Módulos Aritméticos ---

    // 1. Somador
    adder_4bit adder_inst (
        .A(A), 
        .B(B), 
        .cin(1'b0), 
        .S(sum), 
        .cout(cout_add)
    );

    // 2. Subtrator
    subtractor_4bit subtractor_inst (
        .A(A), 
        .B(B), 
        .D(diff), 
        .borrow(borrow_sub)
    );

    // 3. Multiplicador
    multiplier_4x4 multiplier_inst (
        .A(A), 
        .B(B), 
        .P(prod)
    );

    // 4. Divisor (implementa divisão inteira)
    divider_4bit divider_inst (
        .dividend(A), 
        .divisor(B), 
        .quotient(quot), 
        .remainder(rem), 
        .div_zero(div_by_zero)
    );

    // --- Lógica de Controle e Seleção (Estrutural) ---

    // 1. Formatar os resultados para o barramento de 8 bits do resultado
    assign add_res = {4'b0000, sum};
    assign sub_res = {4'b0000, diff};
    assign mul_res = prod;
    // Para divisão, a saída combina resto e quociente, como definido anteriormente.
    // O resultado inteiro (quociente) fica nos 4 bits menos significativos.
    assign div_res = {rem, quot}; 

    // 2. Decodificar o sinal 'op' para selecionar a operação
    // (Assume que 'decoder_2to4' está definido em outro arquivo, como basic_components.v)
    decoder_2to4 op_decoder (
        .in(op), 
        .out(sel)
    );

    // 3. Multiplexador 4-para-1 de 8 bits para selecionar o resultado final
    // Implementado com lógica AND-OR, gerada para cada bit do resultado.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : MUX_RESULT_LOGIC
            wire n0, n1, n2, n3;
            and(n0, add_res[i], sel[0]); // Seleciona se op = 00
            and(n1, sub_res[i], sel[1]); // Seleciona se op = 01
            and(n2, mul_res[i], sel[2]); // Seleciona se op = 10
            and(n3, div_res[i], sel[3]); // Seleciona se op = 11
            or(result[i], n0, n1, n2, n3);
        end
    endgenerate

    // 4. Detector de Zero (NOR de 8 bits)
    // A saída é '1' se e somente se todos os bits de 'result' forem '0'.
    // O operador de redução OR (|) cria um OR de todos os bits do vetor.
    assign zero = ~(|result);

    // 5. Detector de Overflow/Erro
    // O erro ocorre se a operação selecionada gerar uma flag de erro.
    and(ovf_add, cout_add,     sel[0]); // Erro se (op==00 E cout_add==1)
    and(ovf_sub, borrow_sub,   sel[1]); // Erro se (op==01 E borrow_sub==1)
    and(ovf_div, div_by_zero,  sel[3]); // Erro se (op==11 E div_by_zero==1)
    or(overflow, ovf_add, ovf_sub, ovf_div);

endmodule