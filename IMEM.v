module IMEM(
		input 		clk,
		input 		[7:0] 	IMEM_PC,
		output reg	[31:0]	IMEM_instruction
);
	
	reg [31:0] ram [0:63];

	initial begin
  		$readmemh("rams_init_file.txt", ram);
	end
	always@(negedge clk)
	begin
		IMEM_instruction <= ram[IMEM_PC];
	end

endmodule
