module reg_file_tb ();

	reg clk = 0;
	reg write;
	reg [4:0] WR;
	reg [31:0] WD;
	reg [4:0] RR1;
	reg [4:0] RR2;
	wire [31:0] RD1;
	wire [31:0] RD2;

	
	reg [31:0] out1,out2;

	integer file, n, i, length,error=0;
	
	reg_file uut (clk,write,WR,WD,RR1,RR2,RD1,RD2);

	always#5 clk=~clk;

	initial
	begin
		file = $fopen ("test_regfile.txt", "r");
		if (file != -1)
		begin
			n=$fscanf (file,"%d\n",length);
			for (i=0;i<length;i=i+1)
			begin
				n = $fscanf (file,  "%b,%d,%d,%d,%d,%d,%d",write,WR,WD,RR1,out1,RR2,out2);
				@(posedge clk);
				if (out1!=RD1 || out2!=RD2)
					error=error+1; 
			end
		end
		$display("number of errors: %d",error);
		$stop();	
	end


endmodule


