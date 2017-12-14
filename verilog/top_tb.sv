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
  t1.rf1 = '{default:8'b00}
  t1.dm1 = '{default:8'b00}

  #20ns reset = 0;
  #5000ns $display("I give up."); 
  $stop;
end
initial
  #50ns wait(done) #40ns $stop;

endmodule
