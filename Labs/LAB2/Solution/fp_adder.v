`timescale 1ns/1ns
module fp_adder(
//-----------------------Port directions and deceleration
   input [31:0] a, 
   input [31:0] b,
   output [31:0] s
    );

//----------------------1.reconstructing fraction, exponent, sign and hidden bit & 2.if E == 0 & 3.adding guard and round
wire [7:0] Exp_a, Exp_b;
wire [25:0] Frac_a, Frac_b;
wire sign_a, sign_b;

wire [7:0] ex1 ; 
wire [7:0] ex2 ; 
wire [25:0] f1;
wire [25:0] f2;
wire [7:0] ext ; 
wire [7:0] shift;
wire s1 ;
wire [26:0] adder_op1;
wire [26:0] adder_op2;
wire [28:0]ab_value;
wire [28:0] rounded;
wire [28:0] result;
wire [7:0]  ex_result;
wire [54:0] tempi ;
wire [54:0] tempi2 ; 
wire borrow ;
wire [28:0]b_adder;
wire add_sub ;
wire signt;
wire [28:0]norm;
wire [7:0]ex_norm;

assign ex1 = (a[30:23]!=0) ? a[30:23] : 1;
assign ex2 = (b[30:23]!=0) ? b[30:23] : 1;
assign f1 = (a[30:23]!=0) ? {1'b1,a[22:0],2'b00} : {1'b0,a[22:0],2'b00};
assign f2 = (b[30:23]!=0) ? {1'b1,b[22:0],2'b00} : {1'b0,b[22:0],2'b00};
assign shift = (ex1 >= ex2) ? ex1 - ex2 : ex2 - ex1;
assign borrow = (ex1>ex2 || (ex1==ex2 && f1>=f2)) ? 0 : 1 ; 
assign ext =(borrow) ? ex2 : ex1 ;
assign tempi = (borrow)? { 2'b00 , f1 , 27'b 0} : {2'b00 , f2, 27'b0};
assign tempi2 = tempi >> shift ; 
assign s1 = (tempi2[26:0]!=0) ? 1 : 0;
assign add_sub = ~(a[31] ^ b[31]) ;
assign adder_op1 = (borrow) ? {2'b00,f1>>shift,s1} : {2'b00,f2>>shift,s1} ;
assign adder_op2 = (borrow) ? {2'b00,f2,1'b0} : {2'b00,f1,1'b0} ;
assign b_adder = (add_sub) ? adder_op1 + adder_op2 : adder_op2 - adder_op1 ;  
assign ab_value = (b_adder[28]) ? ~b_adder+1 : b_adder ;
normalize m1 (ext,ab_value,norm,ex_norm);


assign Exp_a = (a[30:23]!=0) ? a[30:23] : 1;
assign Exp_b = (b[30:23]!=0) ? b[30:23] : 1;
assign Frac_a = (a[30:23]!=0) ? {1'b1,a[22:0],2'b00} : {1'b0,a[22:0],2'b00};
assign Frac_b = (b[30:23]!=0) ? {1'b1,b[22:0],2'b00} : {1'b0,b[22:0],2'b00};
assign sign_a = a[31];
assign sign_b = b[31];

//---------------------4.determining bigger number
wire [26:0] maxF;
wire [25:0] temp_minF;
wire [7:0] maxE, minE;
wire maxS, minS;
wire [7:0] shift_1;

assign maxF = (a[30:0] > b[30:0])? {Frac_a,1'b0}: {Frac_b,1'b0};
assign maxE = (a[30:0] > b[30:0])? Exp_a: Exp_b;
assign maxS = (a[30:0] > b[30:0])? sign_a: sign_b;
assign temp_minF = (a[30:0] > b[30:0])? Frac_b: Frac_a;
assign minE = (a[30:0] > b[30:0])? Exp_b: Exp_a;
assign minS = (a[30:0] > b[30:0])? sign_b: sign_a;
assign shift_1 = (Exp_a >= Exp_b) ? Exp_a - Exp_b : Exp_b - Exp_a;

//---------------------5.sticky
wire [49:0] temp;
wire sticky;
wire [26:0] minF;

assign temp = (shift_1 == 0)? {temp_minF,24'b0}: ({temp_minF,24'b0} >> shift_1); 
assign sticky = |(temp[23:0]);
assign minF = {temp[49:24], sticky};
//--------------------6,7.add or subtract
wire addnsub;
wire [27:0] adder_output;

assign addnsub = sign_a ^ sign_b;
assign adder_output = (addnsub)? maxF - minF: maxF + minF;

//--------------------8.normalaizing

wire [7:0] temp_shift_2;
wire [4:0]shift_2;
wire [7:0] temp_exp_out_1;
wire [26:0] temp_frac_out_1;

assign temp_shift_2 = (adder_output[27]!=0)? 0:
		   (adder_output[26]!=0)? 0:
		   (adder_output[25]!=0)? 1:
		   (adder_output[24]!=0)? 2:
		   (adder_output[23]!=0)? 3:
		   (adder_output[22]!=0)? 4:
		   (adder_output[21]!=0)? 5:
		   (adder_output[20]!=0)? 6:
		   (adder_output[19]!=0)? 7:
		   (adder_output[18]!=0)? 8:
		   (adder_output[17]!=0)? 9:
		   (adder_output[16]!=0)? 10:
		   (adder_output[15]!=0)? 11:
		   (adder_output[14]!=0)? 12:
		   (adder_output[13]!=0)? 13:
		   (adder_output[12]!=0)? 14:
		   (adder_output[11]!=0)? 15:
		   (adder_output[10]!=0)? 16:
		   (adder_output[9]!=0)? 17:
		   (adder_output[8]!=0)? 18:
		   (adder_output[7]!=0)? 19:
		   (adder_output[6]!=0)? 20:
		   (adder_output[5]!=0)? 21:
		   (adder_output[4]!=0)? 22:
		   (adder_output[3]!=0)? 23:
		   (adder_output[2]!=0)? 24:
		   (adder_output[1]!=0)? 25:
		   (adder_output[0]!=0)? 26: maxE;

assign temp_exp_out_1 = (adder_output[27]!=0)? maxE + 1'b1:
                        (adder_output[26]!=0)? maxE:
                        (maxE > temp_shift_2)? maxE - temp_shift_2: 0;

assign shift_2 = (maxE > temp_shift_2)? temp_shift_2: maxE - 1'b1;

assign temp_frac_out_1 = (adder_output[27])? {adder_output[27:2],(adder_output[1] | adder_output[0])}:
                         (adder_output[26])? adder_output[26:0]:
	                 (temp_shift_2 == 0)? 0: adder_output[26:0] << shift_2;

//------------------10.rounding
wire [24:0] temp_frac_out_2;

assign temp_frac_out_2 = (temp_frac_out_1[2] == 0)? temp_frac_out_1[26:3]:
                         (temp_frac_out_1[1] | temp_frac_out_1[0])? temp_frac_out_1[26:3] + 1'b1:
                         (temp_frac_out_1[3] == 0)? temp_frac_out_1[26:3]: temp_frac_out_1[26:3] + 1'b1;
//------------------11.normalaizing
wire [7:0] exp_out;
wire [22:0] frac_out;
wire sign_out;

assign exp_out = (temp_frac_out_2[24])? temp_exp_out_1 + 1'b1: temp_exp_out_1;
assign frac_out = (temp_frac_out_2[24])? temp_frac_out_2[23:1]: temp_frac_out_2[22:0];
assign sign_out = ({exp_out,frac_out} == 0)? 0: maxS;
//------------------------

assign s = {sign_out, exp_out, frac_out};

endmodule

module normalize(input[7:0]ext,input[28:0]ab_value,output [28:0]result,output [7:0]ex_norm);
assign ex_norm = (ab_value[28]) ? ext+2 : 
(ab_value[27]) ? ext+1 :
 (ab_value[26]) ? ext+0 :  
 (ab_value[25]) ? (ext>=1) ? ext-1 
 : 0 : (ab_value[24]) ? (ext>=2) ? ext-2 
 : 0 : (ab_value[23]) ? (ext>=3) ? ext-3 
 : 0 : (ab_value[22]) ? (ext>=4) ? ext-4
 : 0 : (ab_value[21]) ? (ext>=5) ? ext-5 
 : 0 : (ab_value[20]) ? (ext>=6) ? ext-6 
 : 0 : (ab_value[19]) ? (ext>=7) ? ext-7 
 : 0 : (ab_value[18]) ? (ext>=8) ? ext-8 
 : 0 : (ab_value[17]) ? (ext>=9) ? ext-9 
 : 0 : (ab_value[16]) ? (ext>=10) ? ext-10
 : 0 : (ab_value[15]) ? (ext>=11) ? ext-11
 : 0 : (ab_value[14]) ? (ext>=12) ? ext-12
 : 0 : (ab_value[13]) ? (ext>=13) ? ext-13
 : 0 : (ab_value[12]) ? (ext>=14) ? ext-14
 : 0 : (ab_value[11]) ? (ext>=15) ? ext-15
 : 0 : (ab_value[10]) ? (ext>=16) ? ext-16
 : 0 : (ab_value[9]) ? (ext>=17) ? ext-17
 : 0 : (ab_value[8]) ? (ext>=18) ? ext-18
 : 0 : (ab_value[7]) ? (ext>=19) ? ext-19
 : 0 : (ab_value[6]) ? (ext>=20) ? ext-20
 : 0 : (ab_value[5]) ? (ext>=21) ? ext-21
 : 0 : (ab_value[4]) ? (ext>=22) ? ext-22
 : 0 : (ab_value[3]) ? (ext>=23) ? ext-23 : 0 : 0;
assign result = (ab_value[28]) ? ab_value>>2 
: (ab_value[27]) ? ab_value>>1 
: (ab_value[26]) ? ab_value 
:  (ab_value[25]) ? ab_value<<1 
: (ab_value[24]) ? ab_value<<2 
: (ab_value[23]) ? ab_value<<3 
: (ab_value[22]) ? ab_value<<4 
: (ab_value[21]) ? ab_value<<5 
: (ab_value[20]) ? ab_value<<6 
: (ab_value[19]) ? ab_value<<7 
: (ab_value[18]) ? ab_value<<8 
: (ab_value[17]) ? ab_value<<9 
: (ab_value[16]) ? ab_value<<10 
: (ab_value[15]) ? ab_value<<11 
: (ab_value[14]) ? ab_value<<12 
: (ab_value[13]) ? ab_value<<13 
: (ab_value[12]) ? ab_value<<14 
: (ab_value[11]) ? ab_value<<15 
: (ab_value[10]) ? ab_value<<16 
: (ab_value[9]) ? ab_value<<17 
: (ab_value[8]) ? ab_value<<18 
: (ab_value[7]) ? ab_value<<19 
: (ab_value[6]) ? ab_value<<20 
: (ab_value[5]) ? ab_value<<21
 : (ab_value[4]) ? ab_value<<22
 : (ab_value[3]) ? ab_value<<23 : 0;
endmodule


module shifter(input[26:0] a,input [5:0]b ,output sticky_bit,output [26:0] result
    );
		
assign result[26:0] = a>>b[5:0];

assign sticky_bit =   							( b == 1 ) ? a[0] :
 							( b == 2 ) ? a[0]|a[1] :
 							( b == 3 ) ? a[0]|a[1]|a[2] :
 							( b == 4 ) ? a[0]|a[1]|a[2]|a[3] :
 							( b == 5 ) ? a[0]|a[1]|a[2]|a[3]|a[4]:
 							( b == 6 ) ? a[0]|a[1]|a[2]|a[3]|a[4]|a[5] :
 							( b == 7 ) ? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6] :
 							( b == 8 ) ? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7] :
 							( b == 9 ) ? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8] :
 							( b == 10) ? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9] :
 							( b == 11) ? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10] :
 							( b == 12 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11] :
 							( b == 13 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12] :
 							( b == 14 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13] :
 							( b == 15 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14] :
 							( b == 16 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15] :
 							( b == 17 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16] :
 							( b == 18 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17] :
 							( b == 19 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18] :
 							( b == 20 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19] :
 							( b == 21 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20] :
 							( b == 22 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21] :
 							( b == 23 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22] :
 							( b == 24 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23] :
 							( b == 25 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24] :
 							( b == 26 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25] :
 							( b == 27 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25]|a[26] :
 							( b == 28 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25]|a[26] :
 							( b == 29 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25]|a[26] :
 							( b == 30 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25]|a[26] :
 							( b == 31 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25]|a[26] :
 							( b == 32 )? a[0]|a[1]|a[2]|a[3]|a[4]|a[5]|a[6]|a[7]|a[8]|a[9]|a[10]|a[11]|a[12]|a[13]|a[14]|a[15]|a[16]|a[17]|a[18]|a[19]|a[20]|a[21]|a[22]|a[23]|a[24]|a[25]|a[26] : 0;
 								
endmodule


module secureAdd(input[27:0] a,input[27:0] b,output[28:0] result,output [4:0] position
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

