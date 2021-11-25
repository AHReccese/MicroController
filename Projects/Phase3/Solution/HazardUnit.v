`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    DataHazard
// Project Name:   phase3
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module HazardUnit (
	input [4:0] RsD,
	input [4:0] RtD,
	input [4:0] RsE,
	input [4:0] RtE,
	
	input [4:0] WriteRegM,
	input [4:0] WriteRegW,
	
	input RegWriteM,
	input RegWriteW,
	
	input MemtoRegE,
	
	output reg [1:0] ForwardAE,
	output reg [1:0] ForwardBE,
	
	output FlushE,
	output StallD,
	output StallF
);
	wire lwstall;
	
	assign lwstall = (((RsD === RtE) || (RtD === RtE)) && MemtoRegE);
	assign StallF = (lwstall===1'b1);
	assign StallD = (lwstall===1'b1);
	assign FlushE = (lwstall===1'b1);
	
	always@(*)
	begin
		//ForwardAE
		if ((RsE !== 5'b0) && (RsE === WriteRegM) && (RegWriteM === 1'b1))
			ForwardAE = 2'b10;
		else
		if ((RsE !== 5'b0) && (RsE === WriteRegW) && (RegWriteW === 1'b1))
			ForwardAE = 2'b01;
		else
			ForwardAE = 2'b00;
			
		//ForwardBE
		if ((RtE !== 5'b0) && (RtE === WriteRegM) && (RegWriteM === 1'b1)) 
			ForwardBE = 2'b10;
		else
		if ((RtE !== 5'b0) && (RtE === WriteRegW) && (RegWriteW === 1'b1))
			ForwardBE = 2'b01;
		else
			ForwardBE = 2'b00;
	end
	
endmodule
			
		
	