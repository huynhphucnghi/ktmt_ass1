module LED7HEX(
	output reg 	[6:0] HEX_S, HEX_E, HEX_U,
	input			stall, exception, PC_unvalid,
	input 		clk, rst
	);
	
	parameter [6:0]
		BLANK = 7'b1111111,
		ZERO	= 7'b1000000,
		ONE	= 7'b1111001,
		TWO	= 7'b0100100,
		THREE	= 7'b0110000,
		FOUR	= 7'b0011001,
		FIVE	= 7'b0010010,
		SIX	= 7'b0000001,
		SEVEN	= 7'b1111000,
		EIGHT = 7'b0000000,
		NINE	= 7'b0010000;
		
	parameter [6:0]
		_E 	= 7'b0000110,
		_S 	= 7'b0010010,
		_U 	= 7'b1000001;
	
	always @(posedge clk, negedge rst) begin
		if(!rst) begin
			HEX_S <= BLANK;
			HEX_E <= BLANK;
			HEX_U <= BLANK;
		end
		else begin
			HEX_S <= stall 		? _S : BLANK;
			HEX_E <= exception 	? _E : BLANK;
			HEX_U <= PC_unvalid 	? _U : BLANK;
 		end
	end	
endmodule	
