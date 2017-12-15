import definitions::*;

module alu (input  [7:0]           rs_i ,  // operand s
            input  [7:0]           rt_i ,  // operand t
	    input                  ov_i ,  // carry-in
            input  [3:0]       	   op_i	,  // opcode
            output logic [7:0] result_o ,  // result of alu operation
	    output logic  	   ov_o ,  // carry-out 
	    output logic            z_o);  // zero flag

// cast opcode to enum from definitions.sv
op_code    op3; 	     
assign op3 = op_code'(op_i);

// alu execution is fully combinational 
always_comb								  							// no registers, no clocks
  begin
    // default or NOP result
    result_o   = 'd0;                     
    ov_o       = 'd0;
    z_o	       = !(|(rt_i));

  // execute operation based on opcode
  case (op3)   						 
		CLR: result_o = 8'h00;
		ADD: {ov_o, result_o} = rt_i + rs_i;
		SUB: {ov_o, result_o} = rt_i - rs_i;
		AND: result_o = rs_i & rt_i;
		OR: result_o = rs_i | rt_i;
		LD: result_o   = 'd0;
		ST: result_o   = 'd0;
		SL: result_o = rt_i << rs_i;
		SR: result_o = rt_i >> rs_i;
		SET: result_o = rs_i;
		BZ: result_o   = 'd0;
		BNZ: result_o   = 'd0;
		INC: {ov_o, result_o} = rt_i + 9'b000000001;
		DEC: {ov_o, result_o} = rt_i - 9'b000000001;
		JMP: result_o   = 'd0;
		ADC: {ov_o, result_o} = rt_i + ov_i;
		endcase
	end
endmodule 
