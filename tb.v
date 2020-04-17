												  									  
`timescale 1ns / 1ps

module test;
  
	reg reset;	
	tri1 scl;
	 reg clk;
	tri1 sda;
	reg Sda;
	reg [7:0] reg_1;
	reg [6:0] reg_2;
	reg  reg_3;
	reg  reg_4;
	  	 
	
	
	wire [7:0] parallel_data_output_by_slave;	 

	integer serial_data_red_from_slave; 
	   

		 sequencer sequencer();
		driver driver(reset,clk,scl,Sda,sequencer.data,27,sequencer.start_or_stop, sequencer.read_or_write);
									
		
		i2c is1(
		.sda(sda),
		.scl(driver.sclk),
		.out(parallel_data_output_by_slave)
		);
	
		
		
		initial begin 
		clk=0;
		reset=1;
		#100
		reset=0;
		end	 
		
		
		initial begin
			forever begin
				#20 clk=~clk;  
				force sda=driver.sda;
				force scl=driver.sclk;
				//$display("clk");	   
				$display("start_or_stop , %d, read_or_write, %d, adress, %d,sda, %d,sda1,%d,scl,%d",driver.reg_1,driver.reg_2,driver.reg_3,driver.sda,is1.sda,driver.sclk);
		   end	 
		  
		 end
	
	 
      
		
		
	

		
endmodule

