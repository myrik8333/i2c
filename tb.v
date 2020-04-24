												  									  
`timescale 1ns / 1ps

module test;
  
	reg reset;	
	tri1 scl;
	 reg clk;
	tri1 sda;	
	wire [7:0] parallel_data_output_by_slave;	 
	reg [7:0] i_data;
	reg  [6:0] i_adress;
	integer serial_data_red_from_slave; 
	   

		 sequencer sequencer();
		driver driver(scl,sda,reset,i_data,i_adress);
									
		
		i2c is1(
		.clk(clk),
		.sda(sda),
		.scl(driver.sclk),
		.out(parallel_data_output_by_slave),
		.rst(driver.rst),
		.adress(driver.i_adress),
		.data(driver.i_data)
		);
	
		
		initial begin
 			clk = 0;
 			forever #50 clk = ~clk;
 		end 
		
		initial begin 
		driver.reset;
		repeat(100000) begin
			sequencer.generate_params;
			#20 $display("start_or_stop , %d, read_or_write, %d, adress, %d,data, %d adress, %d half_period", sequencer.start_or_stop, sequencer.read_or_write, sequencer.data, sequencer.adress,sequencer.half_period,sequencer.ackn_behavior_flag);
			driver.send(sequencer.start_or_stop,sequencer.read_or_write,sequencer.data,sequencer.adress,sequencer.half_period,sequencer.ackn_behavior_flag);
			end
		end	 
		
		
endmodule

