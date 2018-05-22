module Reg_IF_ID(
		input 		clk,
		input		[7:0] PC,
		input		[31:0] instruction,
		input		valid_PC,
		input		flush,
		input		stall,
		output reg	[7:0] _PC,
		output reg	[31:0] _instruction
);

	initial begin
		_PC = 8'b0;
		_instruction = 32'b0;
	end

	always@(posedge clk)
	begin
		if(stall) begin
			_PC <= _PC;
			_instruction <= _instruction;
		end
		else if(valid_PC && !flush) begin
			_PC <= PC;
			_instruction <= instruction;
		end
		else begin
			_PC <= PC;
			_instruction <= 32'b0;
		end
	end

endmodule
