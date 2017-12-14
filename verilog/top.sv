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
  // PC is address of length IW 
  parameter IW = 16;  	             // program counter / instruction pointer
  wire[IW-1:0] PC;                   // pointer to insr. mem

  // instruction driven by InstrRom and used by alu, data-mem, and lut
  wire[   8:0] InstOut;	             // 9-bit machine code from instr ROM

  // ALU operands drive with reg_file 
  wire[   7:0] rt_val,	      // operand 1
               rs_val;	      // operand 2
  // carry-in set to carry_out on posedge and use in alu
  logic ov_i;                 // carry-in

  // Alu outputs drive with alu and use for reg-file
  wire[   7:0] result_o;			// ALU data output
  wire ov_o;                  // carry-out
  wire z_o;                   // zero flag

  // value to write to reg-file driven by Data-Mem
  wire [7:0] DataOut;         // Value out of Mem[DataAddress]

  // carry control
  logic carry_en = 1'b1;      // carry-in bit for addition enabled
  logic carry_clr = reset;            // clears carry 

  // control signals to drive with lut
  logic For_Jump,             // branch to + offset
  logic Back_Jump;            // branch to - offset
  logic wen_i;                // reg-file write-enable for ld's and r-types
  logic[1:0] sel;	      // mux to choose reg-write value
  logic WriteMem;	      // data-mem write-enable for stores
  
  // inputs to drive with control signals
  logic[3:0] write_reg;	      // Reg write to rt or r1
  logic[7:0] write_select;    // Register Write Data Bus
  logic signed[15:0] Offset = 16'b0; // offset for branch/jump

// instantiate IF Unit
IF IF1(
  .For_Jump (For_Jump)  ,     // branch to + "offset"
  .Back_Jump (Back_Jump)	 ,	// branch to - "offset"
  .Offset   (Offset  )	 ,    // offset to branch to
  .Reset    (reset   )	 ,    // PC <= 0
  .Halt     (done    )	 ,    // PC <= PC
  .CLK      (clk     )	 ,    // on positive edge
  .PC       (PC      )        // current instruction memory location to read
  );				 

// instantiate InstROM 
InstROM #(.IW(16)) InstROM1(
  .InstAddress (PC),    // address pointer to read from
  .InstOut (InstOut)	// 9-bit instruction read for address
  );        

// instantiate Register File
reg_file #(.raw(3)) rf1	 (
  .clk		  (clk     	),       // clock (for writes only)
  .rt_addr_i	  (write_reg    ),       // read and write pointer rt
  .wen_i	  (wen_i        ),       // write enable
  .write_data_i	  (write_select ),       // data to be written/loaded 
  .rs_val_o	  (rs_va        ),       // rs read out of reg file
  .rt_val_o       (rt_val       )        // rt read out of reg file
  );


// instantiate ALU
alu alu1(.rs_i     (rs_val       ),  // operand 1	
         .rt_i	   (rt_val       ),  // operand 2
    	 .ov_i     (ov_i         ),  // carry-in 
         .op_i	   (InstOut[7:4] ),  // opcode
         .result_o (result_o     ),  // result
	 .ov_o     (ov_o         ),  // carry-out
	 .z_o      (z_o          )   // zero flag
         );

// instantiate data memory
data_mem dm1(
   .CLK           (clk        ), // write to mem on positive edge       
   .DataAddress   (rs_val     ), // address to read and write to/from
   .ReadMem       (1'b1       ), // mem-read always on		
   .WriteMem      (WriteMem   ), // mem-write enable
   .DataIn        (rt_val     ), // value to store
   .DataOut       (DataOut    )  // value loaded from address of data-mem
);

// drive control signals based on instructions 
assign Offset = Offset + rs_val;
assign done = InstOut == 9'b111111111

// wen_i, WriteMem, For_Jump, Back_Jump, and sel with lut
logic[1:0] dummy;
lut lut1(
  .lut_addr({InstOut[8:4],z_o}),
  .lut_val({dummy,wen_i,WriteMem,For_Jump,Back_Jump,sel})
);

// write_reg and write_select with sel
always_comb begin
write_reg = sel[1] ? InstOut[3:0] : 4'b1;
case(sel) 
  2'b00 : write_select = rt_val;
  2'b01 : write_select = {1'b0,InstOut[6:0]};
  2'b10 : write_select = result_o;
  2'b11 : write_select = DataOut;
end

// carry-in set to carry-out on every posedge if clear is not 1
always_ff @(posedge clk)   
  if(carry_clr==1'b1)
    ov_i <= 1'b0;
  else if(carry_en==1'b1)
    ov_i <= ov_o;

endmodule
