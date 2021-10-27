/////////////////////////////////////////////////////////////////////
// Design unit: TestCPU
//            :
// File name  : testcpu.sv
//            :
// Description: Simple testbench for basic processor
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
//            : Version 1.2 19/12/17
/////////////////////////////////////////////////////////////////////

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

sw = 8'b00001111;
#180ns sw = 8'b00001001;
#180ns sw = 8'b00011001;
#180ns sw = 8'b00010100;
#180ns sw = 8'b00001101;
#180ns sw = 8'b00001101;
#180ns sw = 8'b00010110;
#180ns sw = 8'b00001011;
#200ns sw = 8'd3;
end

initial
clock = 0;
always
#5ns clock = ~clock;

endmodule