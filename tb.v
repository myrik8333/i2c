												  									  
`timescale 1ns / 1ps

module test;
  
	reg reset;	
	tri1 scl;
	 reg clk;
	reg sda;	
	wire [15:0] parallel_data_output_by_slave;	 
	reg [7:0] i_data;
	reg  [6:0] i_adress;
	integer serial_data_red_from_slave; 
	//flag for monitor
	reg flag;
	reg o_sda_buff;
	reg o_scl_buff;
	reg [7:0] output_data;
	reg [7:0] output_data_1;
	reg [15:0] data_to_compare;
	wire o_sda, o_scl, o_sda_en,o_scl_en;
		 sequencer sequencer();
		driver driver(scl,sda,reset,i_data,i_adress,flag);
									
	
		i2c is1(
		.clk(clk),
		.sda(driver.sda),
		.scl(driver.sclk),
		.out(parallel_data_output_by_slave),
		.rst(driver.rst),
		.adress(driver.i_adress),
		.data(sequencer.i_data),
		.o_sda(o_sda),
		.o_scl(o_scl),
		.o_sda_en(o_sda_en),
		.o_scl_en(o_scl_en)
		);
	   	mux mux(is1.o_sda_en,is1.o_scl_en,is1.o_sda,is1.o_scl,o_sda_buff,o_scl_buff);
		monitor monitor(is1.out,mux.o_sda,mux.o_scl,is1.o_scl_en,is1.o_sda_en,output_data,output_data_1,data_to_compare);
		scoreboard scoreboard(monitor.o_sda_flag, monitor.o_scl_flag, sequencer.adress_flag, sequencer.read_or_write,sequencer.data,sequencer.data1,monitor.output_data,monitor.output_data_1,monitor.data_to_compare,sequencer.start_or_stop, sequencer.i_data,sequencer.ackn_behavior_flag);
		initial begin
			clk = 0;
 			forever #50 clk = ~clk;
 		end 
		
		initial begin 
		driver.reset;
		repeat(100000) begin
			sequencer.generate_params;
			//#20 $display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d adress, %d half_period", sequencer.start_or_stop, sequencer.read_or_write, sequencer.data, sequencer.adress,sequencer.half_period,sequencer.ackn_behavior_flag);
			driver.send(sequencer.start_or_stop,sequencer.read_or_write,sequencer.data,sequencer.data1,sequencer.adress,sequencer.half_period,sequencer.ackn_behavior_flag);
			scoreboard.display;
			end
		end	 
		initial begin
			forever begin
				@(posedge sequencer.start_or_stop)
					monitor.read_data;
			end
		end
		//initial begin
		//	forever begin
		//		scoreboard.display;
		//	end
		//end
			
			
endmodule

