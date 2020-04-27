
module scoreboard(rw,data,data1,output_data,output_data_1,data_to_compare,start_or_stop,i_data,ackn_behavior_flag);
input [2:0] rw;
input [2:0] ackn_behavior_flag;
input [2:0] start_or_stop;
input [7:0] data;
input [7:0] data1;
input [7:0] output_data;
input [7:0] output_data_1;
input [15:0] data_to_compare;
input [15:0] i_data;


task display;
begin	 
		//writing  first  part  of  data
		if(start_or_stop&&rw==0&&data==output_data)
			$display("No error in first  data, while writing first data-pack %d, %d",data,output_data);
		else if(start_or_stop&&rw==0&&data!=output_data)
			$display("error in first  data, while writing first data-pack %d, %d",data,output_data);
		
			
			
		//writing second part of  data 	
		if(start_or_stop&&rw==0&&data1==output_data_1)
			$display("No error in first  data, while writing second data-pack %d, %d",data1,output_data_1);
		else if(start_or_stop&&rw==0&&data1!=output_data_1)
			$display("error in first  data, while writing second data-pack%d, %d",data1,output_data_1);
		
		
		
		//normal acknowledge while reading	
		if (ackn_behavior_flag==1&&start_or_stop&&rw==1&&data_to_compare==i_data)
			$display("No error in data, while reading data-pack");
		else if	(ackn_behavior_flag==1&&start_or_stop&&rw==1&&data_to_compare!=i_data)
			$display("error in data, while reading data-pack %d, %d",i_data,data_to_compare);
		
		//wrong acknowledge while reading	
		if (ackn_behavior_flag==0&&start_or_stop&&rw==1&&data_to_compare==i_data)
			$display("something wrong with acknowledge behavior of i2c slave %d, %d",i_data,data_to_compare);		
		else if	(ackn_behavior_flag==0&&start_or_stop&&rw==1&&data_to_compare!=i_data)
			$display("normal behavior with bad avknowledge %d, %d",i_data,data_to_compare);	
		
	
	end


endtask
endmodule
