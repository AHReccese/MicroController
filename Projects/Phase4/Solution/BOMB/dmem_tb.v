module dmem_tb ();

	reg clk = 0;
	reg write;
	reg [31:0] address;
	reg [31:0] write_data;
	wire [31:0] read_data;

	
	reg [31:0] out;

	integer file, n, i, length,error=0;
	
	dmem uut (clk,write,address,write_data,read_data);

	always#5 clk=~clk;

	initial
	begin
		file = $fopen ("test_dmem.txt", "r");
		if (file != -1)
		begin
			n=$fscanf (file,"%d\n",length);
			for (i=0;i<length;i=i+1)
			begin
				n = $fscanf (file,  "%b,%d,%d,%d",write,address,write_data,out);
				@(posedge clk);
				if (out!=read_data)
					error=error+1; 
			end
		end
		$display("number of errors: %d",error);
		$stop();	
	end


endmodule

