`timescale 10ns/1ns

module RegisterFile_test();
	//registers
	reg clk;
	reg WriteEnable;
	reg [31:0]WriteData;
	
	reg [4:0]Address1;
	reg [4:0]Address2;
	reg [4:0]Address3;
	
	//wires
	wire [31:0]ReadData1;
	wire [31:0]ReadData2;
	
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
			Address3 <= 5'd0;
			WriteData <= 32'd20;
			@(posedge clk);
			Address3 <= 5'd2;
			WriteData <= 32'd40;
			@(posedge clk);
			Address3 <= 5'd4;
			WriteData <= 32'd80;
			@(posedge clk);
			Address3 <= 5'd8;
			WriteData <= 32'd160;
			@(posedge clk);
			Address3 <= 5'd16;
			WriteData <= 32'd320;
			@(posedge clk);
			Address3 <= 5'd31;
			WriteData <= 32'd640;
			@(posedge clk);
			WriteEnable <= 0;
			#32;
			Address1 <= 5'd0;
			Address2 <= 5'd2;
			#32;
			Address1 <= 5'd4;
			Address2 <= 5'd8;
			#32;
			Address1 <= 5'd16;
			Address2 <= 5'd31;
			#32;
		$stop();
		end
  
	RegisterFile regfile(.clk(clk), .A1(Address1), .A2(Address2),
						 .A3(Address3), .WD3(WriteData), .WE3(WriteEnable),
						 .RD1(ReadData1), .RD2(ReadData2));          
endmodule



