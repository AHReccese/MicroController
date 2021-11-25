`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    InstructionMemory
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
module InstructionMemory(

input [31:0] A,
output [31:0] RD
);
	 
reg [31:0] RAM [1023:0];
//initial begin
//$readmemh("memfile.dat",RAM);
//end
assign #0.25 RD = RAM[A[31:2]];

endmodule

