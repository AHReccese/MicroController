`timescale 10ns/1ns

module DataMemory_test();
	//registers
	reg clk;
	reg WriteEnable;
	reg [31:0]WriteData;
	reg [31:0]Address;
	
	//wires
	wire [31:0]ReadData;
	
	initial
		begin
			clk = 0;
		end
  
	always
		begin
			#10 clk <= ~clk;  
		end
    
	initial 
		begin
			WriteEnable <= 1;
			Address <= 32'd64;
			WriteData <= 32'd45;
			@(posedge clk);
			Address <= 32'd128;
			WriteData <= 32'd100;
			@(posedge clk);
			WriteEnable <= 0;
			Address <= 32'd64;
			#32;
			Address <= 32'd128;
			#38;
		$stop();
		end
  
	DataMemory dmem(.clk(clk), .WE(WriteEnable), .A(Address), .WD(WriteData), .RD(ReadData));          
endmodule


