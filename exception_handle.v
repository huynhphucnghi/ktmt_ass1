module exception_handle(
		input 		[7:0] ALU_status,
		input		[4:0] RegDst_address,
		input		mem_read, mem_write,
		input 	reg_write,
		input		Exception,
		output reg	disable_signal
);
	
	always@(*)
	begin
		disable_signal = ALU_status[6] || ALU_status[2] || 
						(reg_write && RegDst_address == 5'b0) ||
						((mem_read||mem_write) && ALU_status[3]) || Exception;
	end

endmodule
