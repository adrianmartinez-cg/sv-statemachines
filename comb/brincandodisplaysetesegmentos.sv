// Pedro Adrian Pereira Martinez
// Brincando com display de sete segmentos

parameter divide_by=50000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI, // chaves pretas
           output logic [NBITS_TOP-1:0] LED, // display Led
           output logic [NBITS_TOP-1:0] SEG, // display de 7 segmentos
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b, // display Lcd
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
  end
   
  // os parametros abaixo correspondem aos segmentos que temos que ativar para mostrar os numeros corretos
  // foram descobertos fazendo testes com a atribuicao SEG <= SWI  
  parameter NUM_0 = 'b00111111 ;
  parameter NUM_1 = 'b00000110 ;
  parameter NUM_2 = 'b01011011 ;
  parameter NUM_3 = 'b01001111 ;
  parameter NUM_4 = 'b01100110 ;
  parameter NUM_5 = 'b01101101 ;
  parameter NUM_6 = 'b01111101 ;
  parameter NUM_7 = 'b00000111 ;
  parameter NUM_8 = 'b01111111 ;
  parameter NUM_9 = 'b01101111 ;
  parameter NUM_A = 'b01110111 ;
  parameter NUM_B = 'b01111100 ;
  parameter NUM_C = 'b00111001 ;
  parameter NUM_D = 'b01011110 ;
  parameter NUM_E = 'b01111001 ;
  parameter NUM_F = 'b01110001 ;
  
  // para entrada a partir de 16 , mostra as letras 
  parameter CAPITAL_A = NUM_A      ; // para entrada igual a 16
  parameter SMALL_B = NUM_B        ; 
  parameter CAPITAL_C = NUM_C      ;
  parameter SMALL_C = 'b01011000   ;
  parameter SMALL_D = NUM_D        ;
  parameter CAPITAL_E = NUM_E      ;
  parameter CAPITAL_F = NUM_F      ;
  parameter SMALL_G = NUM_9        ;
  parameter CAPITAL_H = 'b01110110 ;
  parameter SMALL_H = 'b01110100   ;
  parameter SMALL_I = 'b00000100   ;
  parameter CAPITAL_I = 'b00000110 ;
  parameter CAPITAL_J = 'b00011110 ;
  parameter CAPITAL_L = 'b00111000 ;
  parameter SMALL_N = 'b01010100   ;
  parameter CAPITAL_O = NUM_0      ;
  parameter SMALL_O = 'b01011100   ;
  parameter CAPITAL_P = 'b01110011 ;
  parameter SMALL_Q = 'b01100111   ;
  parameter SMALL_R = 'b01010000   ;
  parameter CAPITAL_S = NUM_5      ;
  parameter SMALL_T = 'b01111000   ;
  parameter CAPITAL_U = 'b00111110 ;
  parameter SMALL_U = 'b00011100   ;
  parameter SMALL_Y = 'b01101110   ;
  parameter SYMBOL = 'b01100011    ; // para entrada igual a 41
  
  parameter NBITS_INPUT = 6; // numero de bits necessarios para representar todos os simbolos (42)

  logic [NBITS_INPUT-1:0] displaySymbols; // corresponde a entrada para representar os simbolos no display 

  // atribuição da entrada n 
  always_comb displaySymbols <= SWI[NBITS_INPUT - 1:0];

  // atribuição da saída
  always_comb begin
     case(displaySymbols)
         0: SEG <= NUM_0; // representa os numeros de 0 a 15
         1: SEG <= NUM_1;
         2: SEG <= NUM_2;
         3: SEG <= NUM_3;
         4: SEG <= NUM_4;
         5: SEG <= NUM_5;
         6: SEG <= NUM_6;
         7: SEG <= NUM_7;
         8: SEG <= NUM_8;
         9: SEG <= NUM_9;
         10: SEG <= NUM_A;
         11: SEG <= NUM_B;
         12: SEG <= NUM_C;
         13: SEG <= NUM_D;
         14: SEG <= NUM_E;
         15: SEG <= NUM_F;
         16: SEG <= CAPITAL_A;  // comeca a representar as letras a partir de 16
         17: SEG <= SMALL_B;
         18: SEG <= CAPITAL_C;
         19: SEG <= SMALL_C;
         20: SEG <= SMALL_D;
         21: SEG <= CAPITAL_E;
         22: SEG <= CAPITAL_F;
         23: SEG <= SMALL_G;
         24: SEG <= CAPITAL_H;
         25: SEG <= SMALL_H;
         26: SEG <= SMALL_I;
         27: SEG <= CAPITAL_I;
         28: SEG <= CAPITAL_J;
         29: SEG <= CAPITAL_L;
         30: SEG <= SMALL_N;
         31: SEG <= CAPITAL_O;
         32: SEG <= SMALL_O;
         33: SEG <= CAPITAL_P;
         34: SEG <= SMALL_Q;
         35: SEG <= SMALL_R;
         36: SEG <= CAPITAL_S;
         37: SEG <= SMALL_T;
         38: SEG <= CAPITAL_U;
         39: SEG <= SMALL_U;
         40: SEG <= SMALL_Y;
         41: SEG <= SYMBOL;
         default: SEG <= NUM_0;
     endcase
     lcd_a[NBITS_INPUT-1:0] <= displaySymbols;  // mostra a entrada no lcd_a
  end
endmodule
