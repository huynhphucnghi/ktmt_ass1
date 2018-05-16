module EPC(
		input 		[7:0] PC,
		output reg	PC_valid
);

	always@(PC) begin
		PC_valid = (PC[1:0] == 2'b0);	
	end
endmodule
