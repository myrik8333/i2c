module monitor(o_data,o_sda,o_scl,o_scl_en,o_sda_en,output_data,output_data_1,data_to_compare);
input [15:0] o_data;
input o_sda;
input o_scl;
input o_scl_en;
input o_sda_en;
output reg [7:0] output_data;
output reg [7:0] output_data_1;
output reg [15:0] data_to_compare;

task read_data;
integer i,j,data_counter;
begin
	data_to_compare<=o_data;
	data_counter=15;
	for	(i=0;i<8;i++) begin
		output_data_1[i]<=o_data[data_counter];
		data_counter=data_counter-1;	
	end	   
	for	(i=0;i<8;i++) begin
		output_data[i]<=o_data[data_counter];
		data_counter=data_counter-1;	
	end
end

endtask
	
endmodule
