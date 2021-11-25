`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    06:19:24 06/24/2019 
// Design Name: 	 cache_project
// Module Name:    RAM
// Project Name:   phase4
// Target Devices: 
// Tool versions: 
// Description: 
//	contact me via telegram ID : @AHReccese
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RAM (ReadData, writeData, Reset,readAddress,writeAddress, clk, writeEnable,readEn);
  
  output [7 : 0] ReadData;
  input [7 : 0] writeData;
  input [5 : 0] readAddress,writeAddress;
  input clk  ,writeEnable , readEn , Reset;
  
  reg [7 : 0] Memory [0 : 63];
  integer i;
  assign ReadData =(readEn)? Memory[readAddress]:8'bzzzzzzzz;
  
  always @(posedge clk
	if (Reset) 
		begin
			for(i=0;i<64;i=i+1)
			Memory [i] = 8'b00000000;		
		end 
	else  if (writeEnable)
      Memory [writeAddress] = writeData;
endmodule

