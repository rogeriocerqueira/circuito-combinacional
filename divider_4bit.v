// -----------------------------------------------------------------------------
// Arquivo:         divider_4bit.v
// Projeto:         Unidade Aritmética de 4 bits (AU)
// Descrição:       Implementação estrutural completa de um divisor 4x4.
//                  Ele "desenrola" o algoritmo de divisão com restauração
//                  instanciando 4 células de divisão em cascata.
//
// Dependências:
//   - restoring_divider_cell.v
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module divider_4bit(
    input [3:0] dividend,
    input [3:0] divisor,
    output [3:0] quotient,
    output [3:0] remainder,
    output div_zero
);

    // --- Fios Internos ---
    // Fios para os restos parciais que conectam cada estágio
    wire [3:0] rem_from_stage3;
    wire [3:0] rem_from_stage2;
    wire [3:0] rem_from_stage1;
    
    // Fios para os bits individuais do quociente gerados em cada estágio
    wire q3, q2, q1, q0;

    // --- Lógica Estrutural ---

    // 1. Detector de divisão por zero (saída é 1 se o divisor for 0000)
    //    Implementado como uma porta NOR de 4 entradas.
    assign div_zero = ~(divisor[3] | divisor[2] | divisor[1] | divisor[0]);
    
    // 2. Cascata de 4 estágios de divisão.
    //    O processo começa com o bit mais significativo (MSB) do dividendo.
    
    // Estágio 3: Processa o bit dividend[3]
    // O resto inicial é 0.
    restoring_divider_cell cell3 (
        .partial_rem_in(4'b0000), 
        .dividend_bit(dividend[3]), 
        .divisor(divisor), 
        .partial_rem_out(rem_from_stage3), 
        .quotient_bit(q3)
    );
    
    // Estágio 2: Processa o bit dividend[2]
    // O resto de entrada é a saída do estágio anterior.
    restoring_divider_cell cell2 (
        .partial_rem_in(rem_from_stage3), 
        .dividend_bit(dividend[2]), 
        .divisor(divisor), 
        .partial_rem_out(rem_from_stage2), 
        .quotient_bit(q2)
    );
    
    // Estágio 1: Processa o bit dividend[1]
    restoring_divider_cell cell1 (
        .partial_rem_in(rem_from_stage2), 
        .dividend_bit(dividend[1]), 
        .divisor(divisor), 
        .partial_rem_out(rem_from_stage1), 
        .quotient_bit(q1)
    );
    
    // Estágio 0: Processa o bit dividend[0] (LSB)
    // A saída de resto deste estágio final é o resto da divisão.
    restoring_divider_cell cell0 (
        .partial_rem_in(rem_from_stage1), 
        .dividend_bit(dividend[0]), 
        .divisor(divisor), 
        .partial_rem_out(remainder), 
        .quotient_bit(q0)
    );

    // 3. Monta o resultado final do quociente a partir dos bits gerados
    assign quotient = {q3, q2, q1, q0};

endmodule