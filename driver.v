module driver( 
	output reg sclk,
	tri1 sda,
	//output reg reset;
	);
	parameter adress =7'h27;  
	//parameter delay=50;
	reg rst;
	reg [7:0] data_from_slave;
	task reset;
	   begin
		   sclk=1;
		   release sda;
		   rst=1'b1;
	   	end
	   endtask
	   
	   
	   
	   task send;
	   	input [2:0] start_or_stop, read_or_write;
		input [7:0] data;
		input [6:0] adress;
		input [5:0] delay;
		input [2:0] ackn_behavior_flag;
		 #20 $display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d",start_or_stop, read_or_write, data, adress);
	   	begin
			integer adr_count=7;
			integer data_count=8;
			integer i,j;
			   	force sda=1;
				sclk<=1;
			if(start_or_stop) begin
				
				//start conditions
				start(delay);
				
				//adress sending 
				adress_send(adress,delay);
				//read or  write acces
				read_write(read_or_write,delay);
				//ackn
				acknowledge(delay);
				//так как запись при 0
				if (read_or_write==0) begin
					data_wr(data,delay);
				end	 
				else if(read_or_write==1) begin
				 	data_rd(data_from_slave,ackn_behavior_flag,delay);
				end
				//stop
				stop(delay);	  
			end
			 
		end
	   	endtask
	
		   
	task acknowledge;
	input [2:0] delay;
		begin
			#delay release sda;
			#delay sclk=1;
			#delay sclk=0;
		end
	endtask	
	
	task no_acknowledge;
	input [2:0] delay;
		begin
			#delay sclk=1;
			#delay sclk=0;
		end
	endtask
	
	task adress_send;
	input [6:0]adress;
	input [5:0]delay;
	begin 
		integer adr_count=7;
		integer i;
		for (i=0;i<7;i=i+1) begin
			#delay force sda=adress[adr_count];
			adr_count=adr_count-1;
			#delay sclk=1;
			#delay sclk=0;
		end				
	end
	endtask
	
	
	task start;
	input [5:0] delay;
	//input start_or_stop;
		begin
				#delay force sda = 0;
				#delay sclk = 0;	 		
		end
	endtask
	
	task stop;
	input [5:0] delay;
		begin
			#delay force sda = 0;
			#delay  sclk = 1;
			#delay release sda;
			#delay;		
		end
	endtask
	
	task read_write;
	input [2:0] read_or_write;
	input [5:0] delay;
		begin
			#delay force  sda=read_or_write;
			#delay sclk=1;
			#delay sclk=0;
		end
	endtask
	
	
	task data_wr;
	input [7:0] data;
	input [2:0] delay;
	integer data_count;
	integer j;
	begin
		data_count=7;
		for(j=0;j<8;j=j+1) begin
			#delay force sda=data[data_count];
			data_count=data_count-1;	  
			#delay sclk=1;				   
			#delay sclk=0;				
		end
		acknowledge(delay);
	end
	endtask
	
	
	task data_rd;
	output [7:0] data_from_slave;
	input [2:0] ackn_behavior_flag;
	input [5:0] delay;
	integer data_count;
	integer j;
	begin
		data_count=7;
		for(j=0;j<8;j=j+1) begin
			#delay sclk=1;
			data_from_slave[data_count]=sda;
			data_count=data_count-1;
			#delay sclk=0;	
		end
		//no_ackn
		if (ackn_behavior_flag)
			no_acknowledge(delay);
		else 
			acknowledge(delay);	
	end
	endtask
	
	
	
	
endmodule
	
	
	