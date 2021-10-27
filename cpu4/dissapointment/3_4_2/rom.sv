module ROM #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus);

`include "opcodes.h"
		

logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mdr;


assign sysbus = (MDR_bus & (mar <= 0) & (mar < 22)) ? mdr : {WORD_W{1'bZ}};

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
    0: mdr = {`LOAD, 5'd22};
	1: mdr = {`XOR, 5'd30};
	2: mdr = {`STORE, 5'd22};
	3: mdr = {`LOAD, 5'd23};
	4: mdr = {`XOR, 5'd30};
	5: mdr = {`STORE, 5'd23};
	6: mdr = {`LOAD, 5'd24};
	7: mdr = {`XOR, 5'd30};
	8: mdr = {`STORE, 5'd24};
	9: mdr = {`LOAD, 5'd25};
	10: mdr = {`XOR, 5'd30};
	11: mdr = {`STORE, 5'd25};
	12: mdr = {`LOAD, 5'd26};
	13: mdr = {`XOR, 5'd30};
	14: mdr = {`STORE, 5'd26};
	15: mdr = {`LOAD, 5'd27};
	16: mdr = {`XOR, 5'd30};
	17: mdr = {`STORE, 5'd27};
	18: mdr = {`LOAD, 5'd28};
	19: mdr = {`XOR, 5'd30};
	20: mdr = {`STORE, 5'd28};
	21: mdr = {`BNE, 5'd22};
	
    default: mdr = 0;
  endcase
  end
  
endmodule
