module DMEM(
		input		clk,
		input		[31:0] DMEM_address,
		input		[31:0] DMEM_data_in,
		input		DMEM_mem_write,
		input		DMEM_mem_read,
		output	[31:0] DMEM_data_out
);
	reg [7:0] memory [255:0];
	
	always@(negedge clk)
	begin
		if(DMEM_mem_write)
		begin
			memory[DMEM_address] 	<= DMEM_data_in[31:24];
			memory[DMEM_address+1] 	<= DMEM_data_in[23:16];
			memory[DMEM_address+2] 	<= DMEM_data_in[15: 8];
			memory[DMEM_address+3] 	<= DMEM_data_in[ 7: 0];
		end
	end

	assign DMEM_data_out = (DMEM_mem_read) ?
			{memory[DMEM_address],memory[DMEM_address+1],memory[DMEM_address+2],memory[DMEM_address+3]} : 32'd0;
endmodule
