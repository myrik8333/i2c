


module sequencer();
	reg [2:0] start_or_stop;
	reg [2:0] read_or_write;
	reg [6:0] adress;
	reg [7:0] data;
	reg [2:0] hold_the_line;
	integer i;
	parameter quit_param=100000, cond_param=30000,cond_param_2=128,delay_param=1000;
	integer delay;
	initial begin
		for (i=0;i<quit_param;i=i+1) begin
			delay=$urandom%delay_param;
			start_or_stop=$urandom%2;
			#10
			read_or_write=$urandom%2;
			adress=$urandom%cond_param_2;
			#10
			data=$urandom%cond_param;
			#50
			//$display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d",start_or_stop,read_or_write,adress,data);
			#delay;
		end
		
	end
endmodule