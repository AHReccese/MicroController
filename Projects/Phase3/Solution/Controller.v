`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    Controller
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
module Controller(


input [5:0] op,
input [5:0] funct,

output MemtoReg,
output MemWrite,
output ALUSrc,
output RegDst,
output RegWrite,
output SgnZero,
output [2:0]ALUOP,
output [1:0]Branch


    );

reg [10:0] outs;

always@(*)
begin
case(op)

  6'b100011: outs=11'b1_0_00_000_1_0_1_0;
  6'b101011: outs=11'b1_1_00_000_1_0_0_0;
  6'b000100: outs=11'b0_0_01_001_0_0_0_0;
  6'b000101: outs=11'b0_0_10_001_0_0_0_0;
  6'b001100: outs=11'b0_0_00_010_1_0_1_1;
  6'b001101: outs=11'b0_0_00_011_1_0_1_1;
  6'b001110: outs=11'b0_0_00_100_1_0_1_1;
  6'b001000: outs=11'b0_0_00_000_1_0_1_0;
  6'b001001: outs=11'b0_0_00_000_1_0_1_1;
  6'b001010: outs=11'b0_0_00_110_1_0_1_0;
  6'b001011: outs=11'b0_0_00_111_1_0_1_0;
  
  6'b000000:
			case(funct)
			 6'b100000: outs=11'b0_0_00_000_0_1_1_1;
			 6'b100001: outs=11'b0_0_00_000_0_1_1_1;
			 6'b100010: outs=11'b0_0_00_001_0_1_1_1;
			 6'b100011: outs=11'b0_0_00_001_0_1_1_1;
			 
			 
			 6'b100100: outs=11'b0_0_00_010_0_1_1_1;
			 6'b100101: outs=11'b0_0_00_011_0_1_1_1;
			 6'b101000: outs=11'b0_0_00_100_0_1_1_1;
			 //6'b100110: outs=11'b0_0_00_100_0_1_1_1;
			 //6'b100111: outs=11'b0_0_00_101_0_1_1_1;
			
			 6'b101010: outs=11'b0_0_00_110_0_1_1_1;
			 6'b101011: outs=11'b0_0_00_111_0_1_1_1;
			 default:outs=11'b0_0_00_000_0_1_0_1;
			 endcase
  default:outs=11'b1_0_00_001_0_1_0_1; 
endcase  
end

// extracting Data from register	
	
assign MemtoReg = outs[10];

assign MemWrite = outs[9];

assign Branch = outs[8:7];

assign ALUOP = outs[6:4];

assign ALUSrc = outs[3];

assign RegDst = outs[2];

assign RegWrite = outs[1];

assign SgnZero = outs[0];

				
				
endmodule
