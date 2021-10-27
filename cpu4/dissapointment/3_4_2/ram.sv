/////////////////////////////////////////////////////////////////////
// Design unit: RAM
//            :
// File name  : ram.sv
//            :
// Description: Synchronous RAM for basic processor
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Mark Zwolinski
//            : School of Electronics and Computer Science
//            : University of Southampton
//            : Southampton SO17 1BJ, UK
//            : mz@ecs.soton.ac.uk
//
// Revision   : Version 1.0 05/08/08
//            : Version 1.1 17/12/13
//            : Version 1.2 12/12/14 Only map top half of address range
/////////////////////////////////////////////////////////////////////
/*
	Modified by original source
	Author:		Alex Mansfield
	
	Licence:	As stated above
*/

module RAM #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus);

`include "opcodes.h"
		
logic [WORD_W-1:0] mdr;
logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mem [0:(1<<(WORD_W-OP_W-1))-9]; //top half of address range
//logic [WORD_W-1:0] mem [0:11]; //top half of address range

// the 

int i;

assign sysbus = (MDR_bus & (mar > 21) & (mar < 30)) ? mdr : {WORD_W{1'bZ}};

always_ff @(posedge clock, negedge n_reset)
	/* mem[22] <= 8'b00001111;
	mem[23] <= 8'b00001001;
	mem[24] <= 8'b00011001;
	mem[25] <= 8'b00010100;
	mem[26] <= 8'b00001101;
	mem[27] <= 8'b00001101;
	mem[28] <= 8'b00010110;
	mem[29] <= 8'b00001011; */
  begin
  if (~n_reset)
    begin 
    mdr <= 0;
    mar <= 0;
    end
  else
    if (load_MAR)
      mar <= sysbus[WORD_W-OP_W-1:0]; 
    else if (load_MDR)
      mdr <= sysbus;
    else if ((CS & mar[WORD_W-OP_W-1]) & mar[WORD_W-OP_W-1:0] < 30)
      if (R_NW)
        mdr <= mem[mar[WORD_W-OP_W-2:0]];
      else
        mem[mar[WORD_W-OP_W-2:0]] <= mdr;
		
  end


endmodule