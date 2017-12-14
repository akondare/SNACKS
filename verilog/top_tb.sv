// testbench for sample design
// CSE141L   Fall 2017
module top_tb();

bit clk, reset = 1;
wire done;	  // output from design

top t1(		  // our design itself
  clk,  
  reset,
  done);

always begin
  #5ns clk = 1;
  #5ns clk = 0;
end

initial begin
  t1.dm1.my_memory[0] = 8'b00111111;
  t1.dm1.my_memory[1] = 8'b00111111;

  #20ns reset = 0;
  #5000ns $display("I give up."); 
  $stop;
end
initial
  #50ns wait(done) #40ns $stop;

endmodule
