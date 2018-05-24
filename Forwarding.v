module Forwarding(
	input 	[4:0] ID_EX_rs,
	input		[4:0] ID_EX_rt,
	input		[4:0] EX_MEM_rd,
	input		[4:0] MEM_WB_rd,
	input		EX_MEM_RegWrite,
	input		MEM_WB_RegWrite,
	input		ID_EX_MemWrite,
	output	[1:0] F1,
	output	[1:0] F2,
	output	[1:0] F3
	// F3 is used to handle this kind of data hazard:
	// addi $s0, $s0, 1
	// sw	  $s0, 0($s1)
);
	assign F1 = (EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs) ? 2'b01 : // 1a.
				((MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs) ? 2'b10 : // MEM/EX
				   	2'b00);
	assign F2 = (EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rt)  ? 2'b01 : // EX/EX
				((MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rt) ? 2'b10 : // MEM/EX
				   	2'b00);
	assign F3 = ID_EX_MemWrite ? (EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rt) ? 2'b01 :
				((MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rt) ? 2'b10 : 2'b00) : 2'b00;
endmodule