module imem_tb ();
	
	reg [31:0] address;
	wire [31:0] read_data;

	
	reg [31:0] out;

	integer file, n, i,error=0;
	
	imem uut (address,read_data);

	initial
	begin
		file = $fopen ("test_imem.txt", "r");
		if (file != -1)
		begin
			for (i=0;i<64;i=i+1)
			begin
				n = $fscanf (file,  "%h",out);
				address = i << 2;
				#5
				if (out!=read_data)
					error=error+1; 
			end
		end
		$display("number of errors: %d",error);
		$stop();	
	end


endmodule
