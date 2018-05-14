module REG_tb;
		reg 		clk;
		reg 			[4:0] REG_address_1;
		reg 			[4:0] REG_address_2;
		reg 			[4:0] REG_address_wr;
		reg		REG_write_1;
		reg 			[31:0] REG_data_wb_in1;
		wire 		[31:0] REG_data_out1;
		wire 		[31:0] REG_data_out2;

	REG REG(clk, REG_address_1, REG_address_2, REG_address_wr, REG_write_1, REG_data_wb_in1,REG_data_out1, REG_data_out2);

	initial begin
		clk = 0;
		REG_write_1 = 0;
		REG_address_1 = 0;
		REG_address_2 = 0;
		REG_address_wr = 0;
	#10	REG_write_1 = 1;
		REG_address_wr = 5'd20;
		REG_data_wb_in1 = 32'b1001000;
	#10 	REG_address_wr = 5'd40;
		REG_data_wb_in1 = 32'b1111000;
	#10	REG_write_1 = 0;
		REG_address_1 = 5'd20;
		REG_address_2 = 5'd40;
	end

	always #5 clk = ~clk;
endmodule