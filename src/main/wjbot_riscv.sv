package wjbot_riscv;
	string proj_root = "/home/wonjongbot/WJBOT-RISCV/";
	typedef enum logic[6:0] {r_type_op=7'b0110011, i_type_alu_op=7'b0010011, lw_op=7'b0000011, sw_op=7'b0100011, beq_op=7'b1100011, jal_op=7'b1101111} opcodetype;
endpackage