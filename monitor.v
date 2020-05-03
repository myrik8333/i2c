module monitor(o_data,o_sda,o_scl,o_scl_en,o_sda_en,output_data,output_data_1,data_to_compare,data_to_compare_1);
input [15:0] o_data;
input o_sda;
input o_scl;
input o_scl_en;
input o_sda_en;
reg o_scl_flag, o_sda_flag;
output reg [7:0] output_data;
output reg [7:0] output_data_1;
output reg [15:0] data_to_compare,data_to_compare_1;

task read_data;
integer i,j,data_counter;
begin 
	
	data_to_compare<=o_data;
	data_counter=15;
	if (o_scl==1&&o_sda==0) begin 
		for	(i=0;i<8;i=i+1) begin
			output_data_1[i]<=o_sda;
			data_counter=data_counter-1;	
		end	   
		for	(i=0;i<8;i=i+1) begin
			output_data[i]<=o_sda;
			data_counter=data_counter-1;	
		end
	end
	
		

	
end

endtask
	
endmodule
