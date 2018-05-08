` ifndef _REG
` define _REG

module REG(
		input 		clk,
		input 			[5:0] REG_address_1,
		input 			[5:0] REG_address_2,
		input 			[5:0] REG_address_wr,
		input		REG_write_1,
		input 			[31:0] REG_data_wb_in1,
		output reg 		[31:0] REG_data_out1,
		output reg 		[31:0] REG_data_out2
);

	reg [31:0] regr [31:0];

	always@(REG_address_1, REG_address_2)
	begin
		REG_data_out1 = (REG_address_1==0) ? 32'b0 : regr[REG_address_1];
		REG_data_out2 = (REG_address_2==0) ? 32'b0 : regr[REG_address_2];
	end

	always@(negedge clk)
	begin
		if (REG_write_1)
			begin
				regr[REG_address_wr] = REG_data_wb_in1;
			end
	end
endmodule


` endif