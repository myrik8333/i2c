module driver( 
	output reg sclk,
	output reg sda,
	output reg rst,
	output reg [7:0] i_data,
	output reg  [6:0] i_adress,
	output reg flag
	);
	//adress =7'h27;  
	//parameter delay=50;
	///reg rst;	
	reg [15:0] data_from_slave;
	
	
	task reset;
	begin  
		
		i_adress=7'h27;
		sclk=1;	
		flag<=0;
		sda=1;
		rst=1'b1; 	
	end
	endtask
	   
	   
	   task send;
	   	input [2:0] start_or_stop, read_or_write;
		input [7:0] data;
		input [7:0] data1;
		input [6:0] adress;
		input [5:0] delay;
		input [2:0] ackn_behavior_flag;
		 //#20 $display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d",start_or_stop, read_or_write, data, adress);
	   	begin
			integer adr_count=7;
			integer data_count=8;
			integer i,j;  
			//sync(delay);
			#delay rst=1'b0;
			i_data=$urandom%256;
			  	sda=1;
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
				//��� ��� ������ ��� 0
				if (read_or_write==0) begin
					data_wr(data,data1,delay);
				end	 
				else if(read_or_write==1) begin
				 	data_rd(data_from_slave,ackn_behavior_flag,delay);
				end
				//stop	
				flag<=1;
				#delay;
				flag<=0;
				stop(delay);
						
			end
			 
		end
	   	endtask
	
		   
	task acknowledge;
	input [5:0] delay;
		begin
			#delay;
			#delay sclk=1;
			#delay sclk=0;
		end
	endtask	
	
	task no_acknowledge;
	input [5:0] delay;
		begin
			#delay sclk=1;
			#delay sclk=0;
		end
	endtask
	
	task master_acknowledge; 
	input [5:0] delay;
	begin  
		#delay sda=0;
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
			#delay sda=adress[adr_count];
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
				#delay sda = 0;
				#delay sclk = 0;	 		
		end
	endtask
	
	task stop;
	input [5:0] delay;
		begin
			#delay sda = 0;
			#delay  sclk = 1;
			#delay;	
		end
	endtask
	
	task read_write;
	input [2:0] read_or_write;
	input [5:0] delay;
		begin
			#delay sda=read_or_write;
			#delay sclk=1;
			#delay sclk=0;
		end
	endtask
	
	
	task data_wr;
	input [7:0] data;
	input [7:0] data1;
	input [5:0] delay;
	integer data_count;
	integer j;
	begin
		data_count=7;
		for(j=0;j<8;j=j+1) begin
			#delay sda=data[data_count];
			data_count=data_count-1;	  
			#delay sclk=1;				   
			#delay sclk=0;				
		end	
		acknowledge(delay);
		data_count=7;
		for(j=0;j<8;j=j+1) begin
			#delay sda=data1[data_count];
			data_count=data_count-1;	  
			#delay sclk=1;				   
			#delay sclk=0;				
		end
		acknowledge(delay);
	end
	endtask
	
	
	task data_rd;
	output [15:0] data_from_slave;
	input [2:0] ackn_behavior_flag;
	input [5:0] delay;
	integer data_count;
	integer j;
	begin
		data_count=15;
		for(j=0;j<8;j=j+1) begin
			#delay sclk=1;
			//data_from_slave[data_count]=sda;
			data_count=data_count-1;
			#delay sclk=0;	
		end
			acknowledge(delay);	
		
		for(j=0;j<8;j=j+1) begin
			#delay sclk=1;
			//data_from_slave[data_count]=sda;
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
	
	
	