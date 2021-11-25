`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    SignExtend
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
module SignExtend(
input [15:0] gonnaSignExtend,
input sgnZero,
output [31:0] signExtended
    );

assign signExtended = (sgnZero == 1'b0 ) ? {gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
													      gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend[15],
														  gonnaSignExtend}
													  : {16'b0000_0000_0000_0000,gonnaSignExtend};  

endmodule
