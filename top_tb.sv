// testbench for sample design
// CSE141L   Fall 2017
module top_tb();

bit clk, reset = 1;
logic [1:0] pMux = 2'b10;
wire done;	  // output from design

top t1(		  // our design itself
  clk,  
  reset,
  pMux,
  done);

always begin
  #5ns clk = 1;
  #5ns clk = 0;
end

initial begin
  t1.dm1.my_memory[1] = 8'b01111100;
  t1.dm1.my_memory[2] = 8'b00010001;

  t1.dm1.my_memory[64] = 8'b11101010;
  t1.dm1.my_memory[65] = 8'b00000100;

  t1.dm1.my_memory[128] = 8'b01111010;
  t1.dm1.my_memory[129] = 8'b11101000;
  t1.dm1.my_memory[130] = 8'b01001110;
  t1.dm1.my_memory[131] = 8'b11000101;

  #20ns reset = 0;
  #5000ns $display("I give up."); 

  $stop;
end
initial
  #50ns wait(done) #40ns $stop;
  //$display("%b_%b_%b", t1.dm1.my_memory[5][7], t1.dm1.my_memory[5][6:2],{t1.dm1.my_memory[6][1:0],t1.dm1.my_memory[6]});
endmodule
