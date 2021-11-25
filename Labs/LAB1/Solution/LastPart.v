`timescale 1ns/1ns
module multiplier4
#(
	parameter nb = 8 // Number_of_bits ...
)
(
//-----------------------Port directions and deceleration
   input clk,  
   input start,
   input [nb-1:0] A, 
   input [nb-1:0] B, 
   output [2*nb-1:0] finalResult, // there should be at least 2nb bits for the multinational of two signed numbers
   output ready
    );


//------------------------------------------------------

//----------------------------------- register deceleration
reg [nb-1:0] Multiplicand ;
reg [2*nb-1:0]  product;
reg [nb:0]  counter;
reg Cout;
//-------------------------------------------------------

//------------------------------------- wire deceleration
wire product_write_enable;
wire [nb:0] adder_output;
//---------------------------------------------------------

//-------------------------------------- combinational logic
assign product_write_enable =  product[0];
assign ready = ( counter==nb ) ? 1 : 0;
assign finalResult = product;
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)
   if(start) begin
      counter <= 0 ;
       product <= {{nb{1'h0}}, B};
      Multiplicand <= A ;
   end
   else if(! ready) begin
         counter <= counter + 1;
         if(product_write_enable && counter !=nb-1 )begin
        	{Cout , product[2*nb-1:nb-1]}  <= { product[2*nb-1],product[2*nb-1:nb] }+{Multiplicand[nb-1], Multiplicand } ;
			//calculation via SignExtension
			// i know that there is no usage for Cout...
		  product[nb-2:0] <=  product [nb-1:1]; // shifting to right ... ignoring the used digit(LSB...)
	end
        else if(product_write_enable && counter ==nb-1 )begin
        	  {Cout , product[2*nb-1:nb-1]}  <= { product[2*nb-1], product[2*nb-1:nb] } - { Multiplicand[nb-1], Multiplicand } ;
			  // calculate the last arithmetic calculation as subtraction ... (when both are signed ...)
			  //calculation via SignExtension
		  product[nb-2:0] <=  product [nb-1:1]; // shift the input one to right
		
	end
	else 
		 product <=  { product[2*nb-1], product[2*nb-1:1] };
   end 
endmodule
