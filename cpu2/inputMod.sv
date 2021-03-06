module inputMod #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
			    input logic [7:0] sw,
				output logic [3:0] sevSeg0, sevSeg1, 
                inout wire [WORD_W-1:0] sysbus);

//`include "opcodes.h"
		
logic [WORD_W-1:0] mdr; 
logic [WORD_W-OP_W-1:0] mar; 

assign sysbus = (MDR_bus & mar == 5'd30) ? sw: {WORD_W{1'bZ}}; //this tests if the mdr is attempting to access address 30 and if so it will set the bus equa

always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    begin 
    mdr <= 0; //initialise these for 0
    mar <= 0;
	sevSeg0 <= 0;
	sevSeg1 <= 0;
    end
  else
    if (load_MAR)
      mar <= sysbus[WORD_W-OP_W-1:0];
    else if (load_MDR)
      mdr <= sysbus;
    else if (CS & mar == 5'd31)
	  if (R_NW)
        mdr <= {sevSeg0, sevSeg1}; //concatenation
      else
        sevSeg0 <= mdr[3:0]; 
		sevSeg1 <= mdr[7:4]; 
end

endmodule
