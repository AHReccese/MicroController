`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:15:30 03/05/2019 
// Design Name: 
// Module Name:    Prelab 
// Project Name: 
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
module FP_Pre1(input[27:0] a,input[27:0] b,output[28:0] result,output [4:0] position
    );
wire [28:0] raw_result;
wire [28:0] raw_result_2;

wire [27:0] comp_a;
wire [27:0] comp_b;

	 // sign extending ...
	 
assign comp_a[27:0] = ( a[27] == 1 ) ? (~{1'b0,a[26:0]})+1'b1 : a[27:0];
assign comp_b[27:0] = ( b[27] == 1 ) ? (~{1'b0,b[26:0]})+1'b1 : b[27:0];

assign raw_result[28:0] = {comp_a[27],comp_a[27:0]} + {comp_b[27],comp_b[27:0]};

assign raw_result_2[28:0] = ( raw_result[28] == 1 ) ? {1'b1,~raw_result[27:0]+1'b1} : raw_result[28:0] ;

assign result[28:0] = {raw_result_2[28],{raw_result_2[27:0] << 5'b11011 - position[4:0]}};

assign position[4:0] =(raw_result_2[27] == 1)? 5'b11011:
							(raw_result_2[26] == 1) ? 5'b11010:
							(raw_result_2[25] == 1) ? 5'b11001:
							(raw_result_2[24] == 1) ?	5'b11000:
							(raw_result_2[23] == 1) ? 5'b10111:
							(raw_result_2[22] == 1) ? 5'b10110:
							(raw_result_2[21] == 1) ? 5'b10101:
							(raw_result_2[20] == 1) ? 5'b10100:
							(raw_result_2[19] == 1) ? 5'b10011:
							(raw_result_2[18] == 1) ? 5'b10010:
							(raw_result_2[17] == 1) ? 5'b10001:
							(raw_result_2[16] == 1) ? 5'b10000:
							(raw_result_2[15] == 1) ? 5'b01111:
							(raw_result_2[14] == 1) ? 5'b01110:
							(raw_result_2[13] == 1) ? 5'b01101:
							(raw_result_2[12] == 1) ? 5'b01100:
							(raw_result_2[11] == 1) ? 5'b01011:
							(raw_result_2[10] == 1) ? 5'b01010:
							(raw_result_2[9] == 1)  ? 5'b01001:	
							(raw_result_2[8] == 1) ? 5'b01000:
							(raw_result_2[7] == 1) ?5'b00111:
							(raw_result_2[6] == 1) ?5'b00110:
							(raw_result_2[5] == 1) ?5'b00101:
							(raw_result_2[4] == 1) ?5'b00100:
							(raw_result_2[3] == 1) ?5'b00011:
							(raw_result_2[2] == 1) ?5'b00010:
							(raw_result_2[1] == 1) ?5'b00001:
							(raw_result_2[0] == 1) ?5'b00000: 5'b00000;

endmodule
