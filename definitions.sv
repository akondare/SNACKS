//This file defines the parameters used in the alu
package definitions;
    
typedef enum logic[3:0] {
  CLR = 4'b0000,	
  ADD = 4'b0001,	
  SUB = 4'b0010,
  AND = 4'b0011,	
  OR  = 4'b0100,	
  LD  = 4'b0101,
  ST  = 4'b0110,
  SL  = 4'b0111,
  SR  = 4'b1000,
  SET = 4'b1001,
  BZ  = 4'b1010,
  BNZ = 4'b1011,
  INC = 4'b1100,
  DEC = 4'b1101,
  JMP = 4'b1110,
  ADC = 4'b1111
	} op_code;
	 
endpackage // defintions
