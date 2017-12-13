module lut(
  input[5:0] lut_addr,
  output logic[3:0] lut_val);

always_comb case(lut_addr)
  // bz and zero flag or bnz and no zero flag
  6'h110101:	 lut_val = 4'b0;
  6'h110110:	 lut_val = 4'b0;
  // jump 
  6'h111100:	 lut_val = 4'b0;
  6'h111101:	 lut_val = 4'b0;
  6'h1:	 lut_val = 4'b1;
  6'h2:	 lut_val = 4'b0;
  6'h3:	 lut_val = 4'b1;
  default: lut_val = 4'b1;
endcase

endmodule