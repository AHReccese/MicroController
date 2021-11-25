`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    Mux2_1
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
module Mux2_1 #(parameter WIDTH = 8)
(input  [WIDTH-1:0] inp_ZeroSentical, inp_OneSentical, input senticalSignal, output [WIDTH-1:0] out);
assign out = senticalSignal ? inp_OneSentical : inp_ZeroSentical; 
endmodule


