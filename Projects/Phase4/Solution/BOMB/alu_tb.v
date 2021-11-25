module alu_tb ();
	
	integer file,m,i, length;
	integer errors = 0;
	reg [31:0] out;

	reg [31:0] a, b;
	reg [3:0] alu_control;
	wire [31:0] result;
	wire zero;
	
	alu uut (.a(a),.b(b),.alu_control(alu_control),.result(result),.zero(zero));

	initial
	begin
		file = $fopen("test_alu.txt","r");
		if (file!=-1)
		begin
			m=$fscanf (file,"%d\n",length);
			for(i=0;i<length;i=i+1)
			begin
				m=$fscanf(file,"%d,%d,%d,%d\n",alu_control,a,b,out);
				#5
				if (out!=result)
					errors=errors+1;
			end
		end
		$display("number of errors: %d",errors);
		$stop();
	end
	

endmodule
