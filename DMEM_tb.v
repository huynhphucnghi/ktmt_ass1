module DMEM_tb;
		reg		clk;
		reg		[31:0] DMEM_address;
		reg		[31:0] DMEM_data_in;
		reg		DMEM_mem_write;
		reg		DMEM_mem_read;
		wire	[31:0] DMEM_data_out;

	DMEM DMEM (clk, DMEM_address, DMEM_data_in, DMEM_mem_write, DMEM_mem_read, DMEM_data_out);
	initial begin
		clk = 0;
	#5	DMEM_address = 32'd20;
		DMEM_data_in = 32'b01001000;
		DMEM_mem_write = 1;
		DMEM_mem_read = 0;
	#10	DMEM_mem_write = 0;
	#20	DMEM_address = 32'd40;
		DMEM_data_in = 32'b01111000;
		DMEM_mem_write = 1;
	#10 	DMEM_mem_write = 0;
	#30	DMEM_address = 32'd20;
		DMEM_mem_read = 1;
	#10	DMEM_mem_read = 0;
	#30	DMEM_address = 32'd40;
		DMEM_mem_read = 1;
	end
	
	always #5 clk = ~clk;
endmodule
		
		
