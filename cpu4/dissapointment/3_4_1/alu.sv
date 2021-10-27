module ALU #(parameter WORD_W = 8, OP_W = 3)
                   (input logic clock, n_reset, ACC_bus, load_ACC, ALU_ACC, ALU_add, ALU_xor, ALU_sub,
                    inout wire [WORD_W-1:0] sysbus,
                    output logic z_flag);
		    
logic [WORD_W-1:0] acc;

assign sysbus = ACC_bus ? acc : {WORD_W{1'bZ}};
assign z_flag = acc == 0 ? 1'b1 :1'b0;

always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    acc <= 0;
  else
    if (load_ACC)
      if (ALU_ACC)
        begin
        if (ALU_add)
			acc <= acc + sysbus;
        else if (ALU_sub)
			acc <= acc - sysbus;
		 else if (ALU_xor)
			acc <= acc ^ sysbus;
		else if (ALU_enc)
			acc <= acc ^ sysbus;
		else if (ALU_dec)
			acc <= acc ^ sysbus;
        end
      else
        acc <= sysbus;
  end
endmodule
