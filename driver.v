module driver( 
	input wire reset,
	input wire clk,
	output reg sclk,
	output reg  sda,
	input wire [7:0] reg_1,
	input wire [6:0] reg_2,
	input wire  reg_3,
	input wire  reg_4
	);
	reg [7:0] state;
	reg [6:0] adr;
	reg [7:0] count;
	parameter adress =7'h27;  
	localparam idle=0;
	localparam start=1;
	localparam adress_send=2;
	localparam rw=3;
	localparam wack=4;
	localparam data_send=5;
	localparam wack_2=6;
	localparam 	stop=7;

	always @(posedge clk) begin
		if (reset==1) begin
				sclk<=1;
		end
		else begin
			if((state==idle)||(state==start)||(state==stop)) begin
			 	sclk<=1;
			
			end
			else begin 
				sclk<=~sclk;
			end
		
		end
	
	
	end
	
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
		else begin 
			
			
			case (state)
				//состояние подтянутое
				idle: begin //	ideal
					sda<=1;
					if(reg_3==1)
						state<=start;
					
					end
				//старт
				start:	begin  //start
					sda<=1;
					count<=6;
					state<=adress_send;

				end
				
				 //посылка  адресса
				//в половине случаев промахнется адрессом, в  остальных попадет
				adress_send: begin   //adress
					if(reg_2<64) begin
						sda<=adr[count];
						if (count==0) state<=rw;
						else count<=count-1;
					end
					else if (reg_2>=64)	begin
						sda<=reg_2[count];
						if (count==0) state=rw;
						else count<=count-1;
					end
					
				end
				
				//чтение или  запись
				rw: begin //read or  write
					if (reg_4==1)
						sda<=1;
					else sda<=0;
					state<=wack;
				end
				//подтверждение
				wack: begin //wack 
					state<=data_send;
					count<=7;
				end
				
				//посылаем данные
				data_send: begin //data
					sda<=reg_1[count];
					if (count==0) state<=wack_2;
					else count<=count-1;
				end	
				//подтверждение
				wack_2: begin
					state<=stop;
				end
				// стоп
				stop: begin
					sda<=1;
					state<=idle;
				end
			
				
	endcase	   
			end
	   end	 
endmodule
	
	
	