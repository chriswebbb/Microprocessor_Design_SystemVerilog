module RAM #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus);

//`include "opcodes.h"
		
logic [WORD_W-1:0] mdr;
logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mem [0:(1<<(WORD_W-OP_W-1))-9]; //top half of address range
//logic [WORD_W-1:0] mem [0:11]; //top half of address range

// the 

int i;

assign sysbus = (MDR_bus & (mar > 21) & (mar < 30)) ? mdr : {WORD_W{1'bZ}};

always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    begin 
    mdr <= 0;
    mar <= 0;
	mem[WORD_W-OP_W-10] <= {OP_W, `ooo};
	mem[WORD_W-OP_W-9] <= {OP_W, `iii};
	mem[WORD_W-OP_W-8] <= {OP_W, `yyy};
	mem[WORD_W-OP_W-7] <= {OP_W, `ttt};
	mem[WORD_W-OP_W-6] <= {OP_W, `mmm};
	mem[WORD_W-OP_W-5] <= {OP_W, `mmm};
	mem[WORD_W-OP_W-4] <= {OP_W, `vvv};
	mem[WORD_W-OP_W-3] <= {OP_W, `kkk};
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
