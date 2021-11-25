`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    Adder
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
module Adder( input [31:0] firstInput , input [31:0] secondInput , output [31:0] out
    );
assign out = firstInput + secondInput ;
endmodule
