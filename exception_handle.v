module exception_handle(
		input 		[7:0] ALU_status,
		input		[4:0] RegDst_address,
		input		mem_read, mem_write,
		output reg	disable_signal
);
	
	always@(*)
	begin
		disable_signal = ALU_status[6] || ALU_status[2] || 
						RegDst_address == 5'b0 ||
						((mem_read||mem_write) && ALU_status[3]);
	end

endmodule
