module mux(o_sda_en,o_scl_en,o_sda,o_scl,o_sda_buff,o_scl_buff);
	input o_sda_en;
	input o_scl_en;
	input o_sda;
	input o_scl;
	output reg [15:0] o_sda_buff;
	output reg [15:0] o_scl_buff;
	integer i,j,data_count;
		assign o_sda_buff=o_sda_en?o_sda:1;	
		assign o_scl_buff=o_scl_en?o_scl:1;

endmodule
