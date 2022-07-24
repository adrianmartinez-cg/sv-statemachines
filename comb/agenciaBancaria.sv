// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

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

  parameter NBITS=4;
  parameter NBITS_SEL=3;
  parameter NCOUNT=4;
  parameter INCR=3;

  logic portaCofre;
  logic relogio;
  logic interruptor; 
  logic alarme;

  // atribuição da entrada da porta do cofre
  // O cofre só pode ser aberto no horario de expediente do banco. 0- Porta fechada , 1 - Porta aberta
  always_comb portaCofre <= SWI[0];
  // entrada do relogio eletronico
  // 0 - Fora do expediente , 1 - horario de expediente
  always_comb relogio <= SWI[1];
  // entrada do interruptor na mesa do gerente
  // 0 - Alarme desativado , 1 - Alarme ativado
  always_comb interruptor <= SWI[2];

  // O cofre só pode ser aberto no horario de expediente do banco, e com o alarme desativado. Caso contrario , vai gerar um sinal sonoro

  always_comb begin
      if(portaCofre) begin
          if(relogio) begin
            if (!interruptor)    alarme <= 0;
            else                 alarme <= 1; 
          end else begin
            alarme <= 1;
          end      
      end else begin
      alarme <= 0;
      end
      SEG[0] <= alarme;
  end

endmodule
