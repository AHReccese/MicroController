module reg_file(input clk,
	input write,
	input [4:0] WR,
	input [31:0] WD,
	input [4:0] RR1,
	input [4:0] RR2,
	output wire [31:0] RD1,
	output wire [31:0] RD2);

	reg [31:0] rf_data [0:31];	

	assign RD1 = (RR1==WR && write==1)?WD:rf_data[RR1];
	assign RD2 = (RR2==WR && write==1)?WD:rf_data[RR2];
	
	always @( posedge clk ) 
		begin
			if ( write )
				rf_data[ WR ] <= WD;
			rf_data[0] <= 32'h00000000;
		end
endmodule
