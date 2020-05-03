
module scoreboard(o_sda_en,o_scl_en,adress_flag,rw,data,data1,output_data,output_data_1,data_to_compare,start_or_stop,i_data,ackn_behavior_flag);
input [2:0] adress_flag;
input [2:0] rw;
input [2:0] ackn_behavior_flag;
input [2:0] start_or_stop;
input [7:0] data;
input [7:0] data1;
input [7:0] output_data;
input [7:0] output_data_1;
input [15:0] data_to_compare;
input [15:0] i_data;
input o_sda_en;
input o_scl_en;

task display;
begin	 
	if (start_or_stop) begin
		if(rw)
			display_rd;
		else if (rw==0)
			display_wr;
		
	end
	
	end
	
endtask	



task display_wr;
begin
		if(adress_flag==0&&rw==0&&data==output_data)
			$display("error in first  data, while adress missmatch %d, %d",data,output_data);
		else if(adress_flag==0&&rw==0&&data!=output_data)
			$display("normal behavior, while adress missmatch %d, %d",data,output_data);
		
			
			
		//writing second part of  data 	
		if(adress_flag==0&&rw==0&&data1==output_data_1)
			$display("error in second  data, while adress missmatch %d, %d",data1,output_data_1);
		else if(adress_flag==0&&rw==0&&data1!=output_data_1)
			$display("normal behavior(second data), while adress missmatch %d, %d",data1,output_data_1);
			
			
			
			if(adress_flag==1&&rw==0&&data==output_data)
			$display("normal behavior, while adress match (first data) %d, %d",data,output_data);
		else if(adress_flag==1&&rw==0&&data!=output_data)
			$display("error adress matching, first data missmatching %d, %d",data,output_data);
		
			
			
		//writing second part of  data 	
		if(adress_flag==1&&rw==0&&data1==output_data_1)
			$display("normal behavior, while adress match (second data) %d, %d",data1,output_data_1);
		else if(adress_flag==1&&rw==0&&data1!=output_data_1)
			$display("error adress matching, second data missmatching %d, %d",data1,output_data_1);
end
endtask

task display_rd;
begin	
			//while adress  match
		//normal acknowledge while reading	
		if (adress_flag==1&&ackn_behavior_flag==1&&rw==1&&data_to_compare==i_data)
			$display("No error in data, while reading data-pack, adress matching,normal acknowledge");
		else if	(adress_flag==1&&ackn_behavior_flag==1&&rw==1&&data_to_compare!=i_data)
			$display("error in data,adress matching, while reading data-pack, normal acknowlege %d, %d",i_data,data_to_compare);
		
		//wrong acknowledge while reading	
		if (adress_flag==1&&ackn_behavior_flag==0&&rw==1&&data_to_compare==i_data)
			$display("adress matching, something wrong with acknowledge behavior of i2c slave,bad acknowledge behavior %d, %d",i_data,data_to_compare);		
		else if	(adress_flag==1&&ackn_behavior_flag==0&&rw==1&&data_to_compare!=i_data)
			$display("adressmatching, normal behavior with bad avknowledge, bad acknowledge behavior %d, %d",i_data,data_to_compare);	
		
			
			//while adress missmatch
		//normal acknowledge while reading
		if (adress_flag==0&&ackn_behavior_flag==1&&rw==1&&data_to_compare==i_data)
			$display("adress missmatching, data matching error in data,while reading,normal acknowledge");
		else if	(adress_flag==0&&ackn_behavior_flag==1&&rw==1&&data_to_compare!=i_data)
			$display("adress missmatching, data missmatching,no error, while reading data-pack, normal acknowledge %d, %d",i_data,data_to_compare);
		
		//wrong acknowledge while reading	
		if (adress_flag==0&&ackn_behavior_flag==0&&rw==1&&data_to_compare==i_data)
			$display("adress missmatching, something wrong with acknowledge behavior of i2c slave %d, %d",i_data,data_to_compare);		
		else if	(adress_flag==0&&ackn_behavior_flag==0&&rw==1&&data_to_compare!=i_data)
			$display("adress missmatching, normal behavior with bad avknowledge %d, %d",i_data,data_to_compare);
		
end
endtask

endmodule
