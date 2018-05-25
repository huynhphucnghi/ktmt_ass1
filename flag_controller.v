module flag_controller(
	clk, flag_rst, flag_250ns, flag_42us, flag_100us, flag_1640us, flag_4100us, flag_15000us, flag_2s
);
	input clk, flag_rst;
	output	flag_250ns,
				flag_42us,
				flag_100us,
				flag_1640us,
				flag_4100us,
				flag_15000us,
				flag_2s;


	reg 	flag_250ns	= 1'b0,
			flag_42us	= 1'b0,
			flag_100us	= 1'b0,
			flag_1640us	= 1'b0,
			flag_4100us	= 1'b0,
			flag_15000us= 1'b0,
			flag_2s		= 1'b0;

	reg [31:0] cnt_timer = 0;
	
	// For 50Mhz clock => 1 cycle = 20ns 
	parameter [31:0] t_40ns 	= 2;
	parameter [31:0] t_250ns 	= 13;
	parameter [31:0] t_42us 	= 2016;
	parameter [31:0] t_100us 	= 4800;
	parameter [31:0] t_1640us 	= 78720;
	parameter [31:0] t_4100us 	= 196800;
	parameter [31:0] t_15000us	= 720000;
	parameter [31:0] t_2s		= 100000000;
	
//	parameter [31:0] t_40ns 	= 1;
//	parameter [31:0] t_250ns 	= 1;
//	parameter [31:0] t_42us 	= 1;
//	parameter [31:0] t_100us 	= 1;
//	parameter [31:0] t_1640us 	= 1;
//	parameter [31:0] t_4100us 	= 1;
//	parameter [31:0] t_15000us	= 1;
//	parameter [31:0] t_2s		= 100;
	
	always @(posedge clk) begin
		if(flag_rst) begin
			flag_250ns			<=	1'b0;
			flag_42us			<=	1'b0;
			flag_100us			<=	1'b0;
			flag_1640us			<=	1'b0;
			flag_4100us			<=	1'b0;
			flag_15000us    	<=	1'b0;
			flag_2s		    	<=	1'b0;
			cnt_timer	<=	31'b0;
		end
		else begin
			if(cnt_timer>=t_250ns) begin			
				flag_250ns	<=	1'b1;
			end
			else begin			
				flag_250ns	<=	flag_250ns;
			end
			//----------------------------
			if(cnt_timer>=t_42us) begin			
				flag_42us	<=	1'b1;
			end
			else begin			
				flag_42us	<=	flag_42us;
			end
			//----------------------------
			if(cnt_timer>=t_100us) begin			
				flag_100us	<=	1'b1;
			end
			else begin			
				flag_100us	<=	flag_100us;
			end
			//----------------------------
			if(cnt_timer>=t_1640us) begin			
				flag_1640us	<=	1'b1;
			end
			else begin			
				flag_1640us	<=	flag_1640us;
			end
			//----------------------------
			if(cnt_timer>=t_4100us) begin			
				flag_4100us	<=	1'b1;
			end
			else begin			
				flag_4100us	<=	flag_4100us;
			end
			//----------------------------
			if(cnt_timer>=t_15000us) begin			
				flag_15000us	<=	1'b1;
			end
			else begin			
				flag_15000us	<=	flag_15000us;
			end
			//----------------------------
			if(cnt_timer>=t_2s) begin			
				flag_2s	<=	1'b1;
			end
			else begin			
				flag_2s	<=	flag_2s;
			end
			//----------------------------
			cnt_timer	<= cnt_timer + 1;
		end
	end
	
endmodule