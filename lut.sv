import definitions::*;

module lut(
  input[5:0] lut_addr,
  output logic[5:0] lut_val);

logic[3:0] opbits;
assign opbits = lut_addr[4:1];
op_code op;
assign op = op_code'(opbits);
always_comb begin
  if (lut_addr[5]) begin
    case(op)
	CLR: lut_val = 6'b100010;
	ADD: lut_val = 6'b100010;
	SUB: lut_val = 6'b100010;
	AND: lut_val = 6'b100010;
	OR:  lut_val = 6'b100010;
	LD:  lut_val = 6'b100011;
	ST:  lut_val = 6'b010000;
	SL:  lut_val = 6'b100010;
	SR:  lut_val = 6'b100010;
	SET: lut_val = 6'b100010;
	BZ:  lut_val = {2'b00,lut_addr[0],3'b000}; 
	BNZ: lut_val = {2'b00,!(lut_addr[0]),3'b000}; 
	INC: lut_val = 6'b100010;
	DEC: lut_val = 6'b100010;
	JMP: lut_val = 6'b000100;
	ADC: lut_val = 6'b100010;
    endcase
    end 
  else
    lut_val = {5'b10000,lut_addr[4]};
end

endmodule
