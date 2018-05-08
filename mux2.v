

module mux2(sel, data, data_out);

parameter 
	data_size = 32,
	data_num = 2,
	sel_size = 1;
	

		input 		[sel_size-1:0] sel;
		input		[data_size:0][data_num-1:0] data;
		output reg	[data_size:0] data_out;

	always @(data[data_num-1:0], sel)
	begin
		data_out <= data[sel];
	end
	
endmodule

