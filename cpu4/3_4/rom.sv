module ROM #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus);

`include "opcodes.h"
		

logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mdr;

assign sysbus = (MDR_bus & (mar < 28)) ? mdr : {WORD_W{1'bZ}};

always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    begin 
    mar <= 0;
    end
  else
    if (load_MAR)
      mar <= sysbus[WORD_W-OP_W-1:0];
  end


always_comb
  begin
  mdr = 0;
  case (mar) //selects instruction from rom. this is the program attempted from testbench
    0: mdr = {`LOAD, 5'd30};
	1: mdr = {`XOR, 5'd17};//Replace xor with add for first part! Then replace xor everywhere else
	2: mdr = {`STORE, 5'd31};
	3: mdr = {`LOAD, 5'd16};
	4: mdr = {`BNE, 5'd15};
	15: mdr = 0;
	16: mdr = 0;
	
    default: mdr = 0;
  endcase
  end
  
endmodule
