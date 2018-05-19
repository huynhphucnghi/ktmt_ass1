module Forwarding(
	input 		ID_EX_rs,
	input		ID_EX_rt,
	input		EX_MEM_rd,
	input		MEM_WB_rd,
	input		EX_MEM_RegWrite,
	input		MEM_WB_RegWrite,
	output		[1:0] F1,
	output			[1:0] F2
);
	assign F1 = (EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs) ? 2'b10 : // 1a.
				((MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs) ? 2'b01 : // MEM/EX
				   	2'b00);
	assign F2 = (EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rt)  ? 2'b10 : // EX/EX
				((MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rt) ? 2'b01 : // MEM/EX
				   	2'b00);
endmodule