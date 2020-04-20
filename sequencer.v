


module sequencer();
	reg [2:0] start_or_stop;
	reg [2:0] read_or_write;
	reg [6:0] adress;
	reg [7:0] data;
	parameter quit_param=100000, cond_param=30000,cond_param_2=128,delay=10000;
	
	//task for  random generation of input values
	task generate_params;  
		begin
			start_or_stop=$urandom%2;						    
			read_or_write=$urandom%2;
			adress=$urandom%128;
			data=$urandom%256;																	
			end	 
	endtask
	
	
endmodule