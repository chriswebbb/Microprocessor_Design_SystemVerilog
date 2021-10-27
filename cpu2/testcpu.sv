module TestCPU;

parameter int WORD_W = 8, OP_W = 3;

logic  clock, n_reset;
logic [6:0] disp0, disp1, disp2, disp3;
logic [7:0] sw;

`include "opcodes.h"

CPU #(.WORD_W(WORD_W), .OP_W(OP_W)) c1 (.*);

initial
begin
n_reset = 1'b1;
sw = 8'b0;
#1ns n_reset = 1'b0;
#2ns n_reset = 1'b1;

#2ns sw = 8'd2;
#200ns sw = 8'd3;
end

initial
clock = 0;
always
#5ns clock = ~clock;

endmodule
