`timescale 1ns/1ns

module FP_Pre_tb2();
	
	//Clock Generation:
	reg clk = 1'b1;
	always @(clk)
		clk <= #5 ~clk;
	
	parameter No_of_tests = 1000;
	
	//Inputs to the module:
	reg [26:0] A;
	reg [5:0] B;
	reg [26:0] C;
	reg Sticky;
	reg [9:0] No_of_Errors;
	integer file, i, go_on;
	
	
	initial begin
	  go_on = 0;
		No_of_Errors = 10'h000;
		file = $fopen("FP_Pre2.hex", "r");
		
		if (file == 'bx) begin
			$write("Unable to read the input file. Add the given hex file to your project.");
			$stop;
		end
		else go_on=1;
		
		for (i = 1; i < No_of_tests; i = i+1) begin

			$fscanf(file, "%b\t%d\t%b\t%b\n", A, B, C, Sticky);
			#10 //wait for stability
			if ((C != uut.result) || (Sticky != uut.sticky_bit)) begin
			  No_of_Errors = No_of_Errors + 1;
				$write("\n \Error: Inputs A = %7h, B = %2d, Expected Ouputs: C = %4h, Sticky = %1b -- Got Result = %4h, Sticky = %1b", A, B, C, Sticky, uut.result, uut.sticky_bit);
				if (Sticky != uut.sticky_bit)
					$write(" -- Wrong Sticky bit");
			end
	
		end
		if ((No_of_Errors == 0) && (go_on == 1))
		    $write ("\n\nGood Job! No errors found.");
		else if (go_on == 1)
		    $write ("\n\n%d Total Erorrs", No_of_Errors);
		$stop;
	end
	
	//module instantiation:
	FP_Pre2 uut (.a(A) , .b(B) , .sticky_bit() , .result());
	
endmodule
