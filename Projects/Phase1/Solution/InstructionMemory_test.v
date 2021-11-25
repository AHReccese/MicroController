`timescale 10ns/1ns

module InstructionMemory_test();
	//registers
	reg [31:0]Address;
	
	//wires
	wire [31:0]ReadData;
	
	initial 
		begin
			Address <= 32'd0;
			#32;
			Address <= 32'd4;
			#32;
			Address <= 32'd8;
			#32;
			Address <= 32'd12;
			#32;
			Address <= 32'd16;
			#32;
			Address <= 32'd20;
			#32;
			Address <= 32'd24;
			#32;
			Address <= 32'd28;
			#32;
			Address <= 32'd32;
			#32;
			Address <= 32'd36;
			#32;
			Address <= 32'd40;
			#32;
			Address <= 32'd44;
			#32;
			Address <= 32'd48;
			#32;
			Address <= 32'd52;
			#32;
			Address <= 32'd56;
			#32;
			Address <= 32'd60;
			#32;
			Address <= 32'd64;
			#32;
			Address <= 32'd68;
			#32;
		$stop();
		end
  
	InstructionMemory imem(.A(Address), .RD(ReadData));          
endmodule
