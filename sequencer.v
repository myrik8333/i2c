


module sequencer();
	reg [2:0] start_or_stop;
	reg [2:0] read_or_write;
	reg [6:0] adress;
	reg [7:0] data;
	reg [7:0] data1;
	reg [2:0] ackn_behavior_flag; 
	reg [2:0] adress_flag;
	reg [2:0] reset;
	reg [15:0] i_data;
	parameter real_adress=7'h27;
	parameter bad_adress=7'h32;
	parameter quit_param=100000, cond_param=30000,cond_param_2=128,delay=10000;
	reg[5:0] half_period;
	//task for  random generation of input values
	task generate_params;  
	begin	
			
			half_period=$urandom%64;
			start_or_stop=$urandom%2;						    
			read_or_write=$urandom%2;
			ackn_behavior_flag=$urandom%2;
			adress_flag=$urandom%2;
			reset=$urandom%2;
			if (adress_flag)
				adress=real_adress;
			else
				adress=bad_adress;
	
			//adress=$urandom%128;
			data=$urandom%256;
			data1=$urandom%256;
			i_data=$urandom%256;
			end	 
	endtask
	
	
endmodule