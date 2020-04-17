module driver( 
	input wire reset,
	input wire clk,
	output reg sclk,
	output reg  sda,
	input wire [7:0] reg_1,
	input wire [6:0] reg_2,
	input wire [2:0] reg_3,
	input wire [2:0] reg_4
	);
	reg [7:0] state;
	reg [6:0] adr;
	reg [7:0] count;
	parameter adress =27;  

			
	//доабавить состояни идле
	always @(posedge clk) begin
		//sda<=1;
			// $display("clk");
			//#20 $display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d",reg_1,reg_2,reg_3,reg_4);
		if (reset)	begin
			state<=7'h0;
			sda<=1;
			sclk<=1;
		end
		else if (reg_3)begin 
			
			
			case (state)
				
				7: begin //	ideal
					sda<=1;
					state<=0;
					
					end
				
				0:	begin  //start
					sda<=1;
					count<=6;
					state=1;

				end
				
				
				
				1: begin   //adress
					if(reg_2<64) begin
						sda<=adr[count];
						if (count==0) state=2;
						else count<=count-1;
					end
					else if (reg_2<128)	begin
						sda<=reg_2[count];
						if (count==0) state=2;
						else count<=count-1;
					end
					
				end
				
				
				2: begin //read or  write
					if (reg_4==1)
					sda<=1;
					else if(reg_4==0)
					sda<=0;
					state<=3;
				end
				
				
				
				3: begin //data
					if (reg_4<4096) begin
						state<=4;
						count<=7;
					end
					else if (reg_4>=4096) begin 
					// дописать условие  при котором  ждем ack от слейва
					sda<=1;
					state<=4; 
					count<=7;
					end
				end
				
				
				4: begin 
					sda<=reg_1[count];
					if (count==0) state<=5;
					else count<=count-1;
				end
				
				
				5: begin
					state<=6;
				end
				
				6: begin
					sda<=1;
					state<=7;
				end
			
				
	endcase	   
			end
	   end	 
endmodule
	
	
	