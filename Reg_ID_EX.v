` ifndef _Reg_ID_EX
` define _Reg_ID_EX

module Reg_ID_EX(
		input 		clk,
		input		[1:0] WB,
		input		[2:0] M,
		input		[2:0] EX,
		input		[7:0] PC,
		input		[31:0] instruction,
		input		[31:0] reg1, reg2, sign_extend,
		input		[5:0] funct,
		input		[4:0] rt, rd,
		output reg	[1:0] _WB,
		output reg	[2:0] _M,
		output reg	[2:0] _EX,
		output reg	[7:0] _PC,
		output reg	[31:0] _instruction,
		output reg	[31:0] _reg1, _reg2, _sign_extend,
		output reg	[5:0] _funct,
		output reg	[4:0] _rt, _rd
);

	initial begin
		_WB = 2'b0;
		_M = 3'b0;
		_EX = 3'b0;
		_PC = 8'b0;
		_instruction = 32'b0;
		_reg1 = 32'b0; _reg2 = 32'b0;
		_sign_extend = 32'b0;
		_funct = 6'b0;
		_rt = 5'b0; _rd = 5'b0;
	end

	always@(posedge clk)
	begin
		_WB <= WB;
		_M <= M;
		_EX <= EX;
		_PC <= PC;
		_instruction <= instruction;
		_reg1 <= reg1; _reg2 <= reg2;
		_sign_extend <= sign_extend;
		_funct <= funct;
		_rt <= rt; _rd <= rd;
	end

endmodule

` endif