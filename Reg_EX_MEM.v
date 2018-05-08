module Reg_EX_MEM(
		input 		clk,
		input		[1:0] WB,
		input		[2:0] M,		
		input		[7:0] jump_address,
		input		[7:0] ALU_status,
		input		[31:0] ALU_result,
		input		[31:0] write_data,
		input		[4:0] RegDst_address,
		output reg	[1:0] _WB,
		output reg	[2:0] _M,
		output reg	[7:0] _jump_address,
		output reg	[7:0] _ALU_status,
		output reg	[31:0] _ALU_result,
		output reg	[31:0] _write_data,
		output reg	[4:0] _RegDst_address
);

	initial begin
		_WB = 2'b0;
		_M = 3'b0;
		_jump_address = 8'b0;
		_ALU_status = 8'b0;
		_ALU_result = 32'b0;
		_write_data = 32'b0;
		_RegDst_address = 5'b0;
	end

	always@(posedge clk)
	begin
		_WB <= WB;
		_M <= M;
		_jump_address <= jump_address;
		_ALU_status <= ALU_status;
		_ALU_result <= ALU_result;
		_write_data <= write_data;
		_RegDst_address <= RegDst_address;
	end

endmodule
