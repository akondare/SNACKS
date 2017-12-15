// Create Date:    17:44:49 2012.16.02 
// Latest rev:     2017.10.26
// Design Name:    CSE141L
// Module Name:    IF 

// generic program counter
module IF #(parameter PCW=16)(
  input              For_Jump,    // branch to pc + "offset"
                     Back_Jump,		// branch by pc - "offset"
  input signed[PCW-1:0] Offset,
  input Reset,
  input Halt,
  input CLK,
  output logic[PCW-1:0] PC             // pointer to insr. mem
  );
	 
  always @(posedge CLK)
	if(Reset)                 // reset to 0 and hold there
	  PC <= 'b0;
	else if(Halt)	          // freeze pc
	  PC <= PC;						
  	else if(For_Jump)         // jump to pc + offset
	  PC <= PC + Offset;
	else if(Back_Jump)	  // jump to pc - offset
	  PC <= PC - Offset;
	else		      	  // normal advance thru program
	  PC <= PC+16'b1;

endmodule
