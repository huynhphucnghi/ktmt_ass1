module IMEM(
		input		[31:0]	PC,
		input 		clk,
		input		[31:0]	write_data,
		input		write_enb,
		output reg	[31:0]	IMEM_instruction
);
	
	reg [31:0] ram [0:63];

	initial begin
	  $readmemh("mem.hex", ram);
	end
	
	always@(posedge clk)
	begin
		IMEM_instruction <= ram[PC];
	end

endmodule