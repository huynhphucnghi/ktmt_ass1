module mux2(sel, data0, data1, data_out);

		parameter data_size = 32;
	

		input 		sel;
		input		[data_size-1:0] data0;
		input		[data_size-1:0] data1;
		output reg	[data_size-1:0] data_out;

	always @(data0, data1, sel)
	begin
		if (sel)
			data_out = data1;
		else
			data_out = data0;
	end
	
endmodule

