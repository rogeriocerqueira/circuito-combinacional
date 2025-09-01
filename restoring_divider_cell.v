// -----------------------------------------------------------------------------
// Arquivo:         restoring_divider_cell.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Implementa um único estágio do algoritmo de divisão com
//                  restauração.
// Dependências:
//   - subtractor_4bit.v
//   - mux2_1_4bit.v
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module restoring_divider_cell(
    input [3:0] partial_rem_in,  // Resto parcial da etapa anterior
    input dividend_bit,        // Novo bit do dividendo a ser processado
    input [3:0] divisor,
    output [3:0] partial_rem_out, // Novo resto parcial para a próxima etapa
    output quotient_bit       // Bit do quociente gerado nesta etapa
);
    wire [3:0] shifted_rem;
    wire [3:0] diff;
    wire borrow;
    
    // 1. Desloca o resto parcial para a esquerda e insere o novo bit do dividendo.
    assign shifted_rem = {partial_rem_in[2:0], dividend_bit};
    
    // 2. Tenta subtrair o divisor do resto deslocado.
    subtractor_4bit sub_inst (
        .A(shifted_rem), 
        .B(divisor), 
        .D(diff), 
        .borrow(borrow)
    );
    
    // 3. O bit do quociente é 1 se a subtração foi bem-sucedida (sem borrow).
    not q_bit_gate(quotient_bit, borrow);
    
    // 4. Seleciona o próximo resto. Se houve borrow (borrow=1), a subtração
    //    falhou e devemos "restaurar" o valor, usando o resto antes da
    //    subtração (shifted_rem). Se não houve borrow (borrow=0), usamos o
    //    resultado da subtração (diff).
    mux2_1_4bit rem_mux (
        .a(diff),           // Seleciona se borrow = 0
        .b(shifted_rem),    // Seleciona se borrow = 1
        .sel(borrow), 
        .out(partial_rem_out)
    );
endmodule