module DMEM(
		input		clk,
		input		[31:0] DMEM_address,
		input		[31:0] DMEM_data_in,
		input		DMEM_mem_write,
		input		DMEM_mem_read,
		output	[31:0] DMEM_data_out
);
	reg [31:0] memory [255:0];
	
	always@(negedge clk)
	begin
		if(DMEM_mem_write)
		begin
			memory[DMEM_address] 	<= DMEM_data_in;
		end
	end

	assign DMEM_data_out = (DMEM_mem_read) ? memory[DMEM_address] : 32'd0;
endmodule
