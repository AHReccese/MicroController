`timescale 1ns/1ns
module multiplier2(
//-----------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output [15:0] finalResult,
   output ready
    );

//------------------------------------------------------

//----------------------------------- register deceleration
reg [7:0] Multiplicand ;
reg [15:0]  product;
reg [3:0]  counter;
//-------------------------------------------------------

//------------------------------------- wire deceleration
wire product_write_enable;
wire [8:0] adder_output;
//---------------------------------------------------------

//-------------------------------------- combinational logic
assign product_write_enable =  product[0];
assign ready = counter[3];
assign finalResult = product;
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
       product <= {8'h00, B};
      Multiplicand <= A ;
   end

   else if(! ready) begin
         counter <= counter + 1;
         if(product_write_enable)begin
        	  product[15:7]  <=  product  [15:8]+ Multiplicand  ;  // initializing the final result ...
		  product[6:0] <=  product [7:1]; // ignoring the LSB ...
		
	end
	else 
		 product <=  product >> 1; // shift the product one to right
		
   end 
endmodule
