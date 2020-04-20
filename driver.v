module driver( 
	output reg sclk,
	tri1 sda,
	);
	parameter adress =7'h27;  
	parameter delay=50;
	
	
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
		 #20 $display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d",start_or_stop, read_or_write, data, 27);
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
					#delay release sda;
					#delay sclk=1;
					#delay sclk=0;
					for(j=0;j<8;j=j+1) begin
						#delay force sda=data[data_count];
						data_count=data_count-1;
						#delay sclk=1;
						#delay sclk=0;
						
					end
					//ackn_again
					#delay release sda;
					#delay sclk=1;
					#delay sclk=0;
					//stop
					#delay force sda = 0;
					#delay  sclk = 1;
					#delay release sda;
					#delay;	
					  
			end
			 
		end
	   	endtask
	   
	   
endmodule
	
	
	