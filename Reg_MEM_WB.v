` ifndef _Reg_MEM_WB
` define _Reg_MEM_WB

module Reg_ID_EX(
		input 		clk,
		input		[1:0] WB,
		input		[31:0] read_data,
		input		[31:0] ALU_result,
		input		[4:0] RegDst_address,
		output reg	[1:0] _WB,
		output reg	[31:0] _read_data,
		output reg	[31:0] _ALU_result,
		output reg	[4:0] _RegDst_address
);

	initial begin
		_WB = 2'b0;
		_ALU_result = 32'b0;
		_read_data = 32'b0;
		_RegDst_address = 5'b0;
	end

	always@(posedge clk)
	begin
		_WB <= WB;
		_ALU_result <= ALU_result;
		_read_data <= read_data;
		_RegDst_address <= RegDst_address;
	end

endmodule

` endif