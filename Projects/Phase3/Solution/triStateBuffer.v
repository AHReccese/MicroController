`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    triStateBuffer
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
module triStateBuffer #(parameter WIDTH = 8)
(input clk, reset, enable, input [WIDTH-1:0] inp, output reg [WIDTH-1:0] out);
// it is a bus of triState buffers so the input is a bus.
// and also it returns 0 instead of High ampedance (Z) --> different from triStateBuffer
always @(posedge clk,posedge reset) 
begin
	if(reset)
		begin  
			out <= 0;
		end 
	else 
		if (enable == 1'b1)
		begin
			out <= inp; 	
		end
end  
endmodule

