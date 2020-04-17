


module i2c(sda,scl,out);
	
	inout sda;
	input scl;
	output [7:0]out;
	
	parameter adress=7'h27;
	
	
	
	//logic for start  or stop conditions
	
	wire start_stop;
	wire sda_background;
	integer i;
	
	assign sda_background = (~scl | start_stop) ? sda : sda_background;
	assign start_stop = ~scl ? 1'b0:(sda^sda_background);
	
	
	reg working;
	
	
	always @(negedge scl or posedge start_stop)
		if(start_stop) working<=1'b0;
			
		else if (~sda) working <=1'b1;
			
		reg [3:0] cnt;
		
		wire bit_data=~cnt[3];
		wire bit_ack=cnt[3];
		
		
		reg data_flag;
		
		
		
		
		always @(negedge scl or negedge working) 
			
			if (~working) begin
				cnt=4'h7; 
				data_flag=1'b0;
				end
			else begin
			
					if(bit_ack)	begin
						cnt=4'h7;
						data_flag=1'b1;
					end	
					else
						cnt=cnt-4'h1;
					
			end
		reg adr_match, op_read, got_ACK;	
		reg adr_flag=~data_flag;
		reg [7:0] i2c_buff;
		reg sda_buff;
		reg got_ack;
		reg [7:0] mem;
		
		
		
		always @(posedge scl)
			sda_buff<=sda;	 
		
		wire op_write = ~op_read;
		
		
		always @(negedge scl or negedge working)
			
			if (~working) begin
				op_read<=1'b0;
				adr_flag<=1'b1;
				got_ack<=1'b0;
			end		
			else begin 			
				for (i=7;i>0;i=i-1)
					if (adr_flag&cnt==i&sda_buff!=adress[i-1])
						adr_match<=0;
		
				if(adr_flag &cnt==0) op_read <= sda_buff;
				
				if(bit_ack) got_ack <= ~sda_buff;

    			if(adr_match & bit_data & data_flag & op_write) mem[cnt] <= sda_buff;  
			end
	wire mem_bit_low = ~mem[cnt[2:0]];
	wire SDA_assert_low = adr_match & bit_data & data_flag & op_read & mem_bit_low & got_ack;
	wire SDA_assert_ACK = adr_match & bit_ack & (adr_flag | op_write);
	wire SDA_low = SDA_assert_low | SDA_assert_ACK;
	assign sda = SDA_low ? 1'b0 : 1'bz;

	assign out = mem;
endmodule
	
	
	
	
	
			
	
	