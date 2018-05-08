module IMEM(
		input 		clk,
		input 		[7:0] 	IMEM_PC,
		output reg	[31:0]	IMEM_instruction
);
	reg [31:0] instruction [7:0];

	always@(negedge clk)
	begin
		IMEM_instruction <= instruction[IMEM_PC];
	end

endmodule
