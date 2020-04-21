module driver( 
	output reg sclk,
	tri1 sda,
	);
	parameter adress =7'h27;  
	//parameter delay=50;
	
	
	   task rst; 
	   begin
		   sclk=1;
		   release sda;
		   
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
			   	release sda;
				sclk<=1;
			if(start_or_stop) begin
				
				//start conditions
				#delay force sda = 0;
				#delay sclk = 0;
				
				//adress sending 
				
				
					data_count=7;
					for (i=0;i<7;i=i+1) begin
						#delay force sda=adress[adr_count];
						adr_count=adr_count-1;
						#delay sclk=1;
						#delay sclk=0;
					end	  
					//read or  write acces
					#delay force  sda=read_or_write;
					#delay sclk=1;
					#delay sclk=0;
					//ackn
					acknowledge(delay);
					//так как запись при 0
					if (read_or_write==0) begin
						for(j=0;j<8;j=j+1) begin
							#delay force sda=data[data_count];
							data_count=data_count-1;	  
							#delay sclk=1;				   
							#delay sclk=0;
							
						end
						acknowledge(delay);
					end	 
					else if(read_or_write==1) begin
					 	data_count=7;
						for(j=0;j<8;j=j+1) begin
							#delay sclk=1;
							data[data_count]=sda;
							data_count=data_count-1;
							#delay sclk=0;
							
						end
						//no_ackn
						if (ackn_behavior_flag)
							no_acknowledge(delay);
						else 
							acknowledge(delay);
					end
					//stop
					#delay force sda = 0;
					#delay  sclk = 1;
					#delay release sda;
					#delay;	
					  
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
	   
endmodule
	
	
	