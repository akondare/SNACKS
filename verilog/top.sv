// Create Date:     2017.11.05
// Latest rev date: 2017.11.06
// Created by:      J Eldon
// Design Name:     CSE141L
// Module Name:     top (top of sample microprocessor design) 

import definitions::*;
module top(
  input clk,  
        reset,
  output logic done
);
  // Instruction Fetch 
  // Inputs
  parameter IW = 16;				         // program counter / instruction pointer
  logic              For_Jump,       // branch to + offset
                     Back_Jump;		   // branch to - offset
  logic signed[15:0] Offset = 16'b0; // offset for branch/jump
  wire[IW-1:0] PC;                   // pointer to insr. mem
  // Outputs
  wire[   8:0] InstOut;				       // 9-bit machine code from instr ROM

  // ALU 
  // Inputs
  wire[   7:0] rt_val,			  // operand 1
               rs_val;		  	// operand 2
  logic ov_i;                 // carry-in
  // Outputs
  wire[   7:0] result_o;			// ALU data output
  wire ov_o;                  // carry-out
  wire z_o;                   // zero flag

  // control signals
  logic Halt;
  logic wen_i;                // reg file write enable for ld's and r-types
  logic carry_en = 1'b1;      // carry-in bit for addition enabled
  logic carry_clr;            // clears carry 
  logic rf_sel;			          // Register Write MUX

  // inputs for various components
  logic WriteMem;
  logic[7:0] DataAddress;     // Data Memory Address
  wire [7:0] DataOut;         // Value out of Mem[DataAddress]
  logic[7:0] rf_select;       // Register Write Data Bus

// instantiate IF Unit
IF IF1(
  .For_Jump (For_Jump)  ,     // branch to + "offset"
  .Back_Jump (Back_Jump)	 ,	// branch to - "offset"
  .Offset   (Offset  )	 ,    // offset to branch to
  .Reset    (reset   )	 ,    // PC <= 0
  .Halt     (Halt    )	 ,    // PC <= PC
  .CLK      (clk     )	 ,    // on positive edge
  .PC       (PC      )        // current instruction memory location to read
  );				 

// instantiate InstROM 
InstROM #(.IW(16)) InstROM1(
  .InstAddress (PC),	        // address pointer to read from
  .InstOut (InstOut));        // 9-bit instruction read for address

// instantiate Register File
reg_file #(.raw(3)) rf1	 (
  .clk		        (clk  	 	     ),       // clock (for writes only)
  .rt_addr_i	    (InstOut[3:0]  ),       // read and write pointer rt
  .wen_i		      (wen_i 		     ),       // write enable
  .write_data_i	  (rf_select     ),       // data to be written/loaded 
  .func_i         (InstOut[8]    ),       // function call is being made
  .rs_val_o	      (rs_val	       ),       // rs read out of reg file
  .rt_val_o		    (rt_val	       )        // rt read out of reg file
  );


// instantiate ALU
alu alu1(.rs_i     (rs_val       ),  // operand 1	
         .rt_i	   (rt_val       ),	 // operand 2
    	   .ov_i     (ov_i         ),	 // carry-in 
         .op_i	   (InstOut[7:4] ),	 // opcode
         .result_o (result_o     ),  // result
		     .ov_o     (ov_o         ),  // carry-out
		     .z_o      (z_o          )   // zero flag
         );

// instantiate data memory
data_mem dm1(
   .CLK           (clk        ), // write to mem on positive edge       
   .DataAddress   (DataAddress), // address to read and write to/from
   .ReadMem       (1'b1       ), // mem-read always on		
   .WriteMem      (WriteMem   ), // mem-write enable
   .DataIn        (rs_val     ), // value to store
   .DataOut       (DataOut    )  // value loaded from address of data-mem
);

// drive control signals based on instructions 
op_code op; 
assign op = op_code'(InstOut[7:4]);
always_comb begin
  DataAddress = rt_val;
  carry_clr = reset;   // clear carry on program reset
  For_Jump = InstOut[8]&&(((InstOut[7:4]==4'hA)&&z_o)||((InstOut[7:4]==4'hB)&&(!z_o)));  
  Back_Jump = InstOut[8]&&(InstOut[7:4]==4'hE); 
  case(op)
    CLR: wen_i = 1'b0;
    ST: wen_i = 1'b0;
    BZ: wen_i = 1'b0;
    BNZ: wen_i = 1'b0;
    JMP: wen_i = 1'b0;
    default: wen_i = 1'b1;
  endcase

  WriteMem = InstOut[8:4]==5'b10110; 
  Halt = InstOut==9'b111111111;
  rf_sel = InstOut[8:4]==5'b10101;
  rf_select = rf_sel? DataOut : result_o;	// choose between dataMem and aluOut
  done = Halt;
  Offset = rs_val + 16'b0;
  end

// carry-in set to carry-out on every posedge if clear is not 1
always_ff @(posedge clk)   
  if(carry_clr==1'b1)
    ov_i <= 1'b0;
  else if(carry_en==1'b1)
    ov_i <= ov_o;

endmodule
