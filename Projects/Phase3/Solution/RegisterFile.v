`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    RegisterFile
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
module RegisterFile(
input clk,
input WE3,
input [4:0] A1,
input [4:0] A2,
input [4:0] A3,
input [31:0] WD3,
output[31:0] RD1,
output[31:0] RD2
);

reg[31:0] rf_data[0:31];
assign #0.15 RD1 = rf_data[A1];
assign #0.15 RD2 = rf_data[A2];

always@(negedge clk) begin
	if(WE3)
	rf_data[A3] <= WD3;
	rf_data[0] <= 32'h0000_0000;
	end
	
endmodule