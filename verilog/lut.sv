module lut(
  input[5:0] lut_addr,
  output logic[3:0] lut_val);

op_code op;
assign op = op_code'(lut_addr[4:1]);
logic[1:0] branch = 
always_comb begin
  if (lut_addr[5]) begin
    case(op)
	CLR: lut_val = 8'h100010;
	ADD: lut_val = 8'h100010;
	SUB: lut_val = 8'h100010;
	AND: lut_val = 8'h100010;
	OR:  lut_val = 8'h100010;
	LD:  lut_val = 8'h100011;
	ST:  lut_val = 8'h010000;
	SL:  lut_val = 8'h100010;
	SR:  lut_val = 8'h100010;
	SET: lut_val = 8'h100010;
	BZ:  lut_val = {4'b0,lut_addr[0],3'b000}; 
	BNZ: lut_val = {4'b0,!(lut_addr[0]),3'b000}; 
	INC: lut_val = 8'h100010;
	DEC: lut_val = 8'h100010;
	JMP: lut_val = 8'h000100;
	JMP: lut_val = 8'h100010;
	ADC: {ov_o, result_o} = rt_i + ov_i;
    endcase
    end 
  else
    lut_val = {7'b10000,lut_addr[4]};
end

endmodule
