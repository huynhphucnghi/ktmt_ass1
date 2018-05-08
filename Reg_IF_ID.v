` ifndef _Reg_IF_ID
` define _Reg_IF_ID

module Reg_IF_ID(
		input 		clk,
		input		[7:0] PC,
		input		[31:0] instruction,
		output reg	[7:0] _PC,
		output reg	[31:0] _instruction
);

	initial begin
		_PC = 8'b0;
		_instruction = 32'b0;
	end

	always@(posedge clk)
	begin
		_PC <= PC;
		_instruction <= instruction;
	end

endmodule

` endif