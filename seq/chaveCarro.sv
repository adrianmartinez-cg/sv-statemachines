// Pedro Adrian Pereira Martinez
// Chave do carro
// Utilizar o conceito de deslocamento lógico para criar um circuito sequencial de um chip para 
// ligar um carro

parameter divide_by=100000000;  // divisor do clock de referência
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

  parameter KEY_VALUE = 'b1101;
  parameter NBITS_STREAM = 4;
  parameter LSB = 0;

  logic reset, E,S
  logic [NBITS_STREAM-1:0] stream;

  always_comb reset <= SWI[0];
  always_comb E <= SWI[1];

  always_ff @(posedge clk_2) begin 
    if(reset) begin 
        stream <= KEY_VALUE;
        S <= 0;
    end else begin
        if(E) begin 
            stream <= stream >> 1;
            S <= stream[LSB];
        end   
    end
  end
  
  always_comb LED[7] <= S;


endmodule
