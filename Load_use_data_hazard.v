module Load_use_data_hazard(
	input 		[4:0] IF_ID_rs, IF_ID_rt,
	input 		[4:0] ID_EX_rt,
	input			ID_EX_mem_read,
	output 	 	load_hazard_signal
);

	assign load_hazard_signal = ID_EX_mem_read && 
							(IF_ID_rs == ID_EX_rt || IF_ID_rt == ID_EX_rt);
	
endmodule