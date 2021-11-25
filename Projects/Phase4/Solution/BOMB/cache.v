module cache(input clk, reset, writeD, writeM,
			input [31:0] AdrD, writeAdrM, writeDataD, writeDataM0, writeDataM1, writeDataM2, writeDataM3, writeDataM4, writeDataM5, writeDataM6, writeDataM7,
			input [31:0] writeDataM8, writeDataM9, writeDataM10, writeDataM11, writeDataM12, writeDataM13, writeDataM14, writeDataM15,
			output hit,
			output [31:0] readData);
	
	
	wire [25:0] setTag;
	
	reg [31:0] cacheData [15:0];
	reg [25:0] cacheTag;
	reg cacheValid;
	
	// offset and tag from address ( when memory wants to read in cache )	
	assign setTag = writeAdrM[31:6];

	// hit 
	assign hit = cacheValid && (AdrD[31:6] == cacheTag);
	
	
	always @(posedge clk)
	begin
		if(reset)
			begin
				cacheValid <= 0;
			end
		else if(writeM)
			begin
				cacheValid <= 1'b1;
				cacheTag <= setTag;
				
				cacheData[0] <= writeDataM0;
				cacheData[1] <= writeDataM1;
				cacheData[2] <= writeDataM2;
				cacheData[3] <= writeDataM3;
				cacheData[4] <= writeDataM4;
				cacheData[5] <= writeDataM5;
				cacheData[6] <= writeDataM6;
				cacheData[7] <= writeDataM7;
				cacheData[8] <= writeDataM8;
				cacheData[9] <= writeDataM9;
				cacheData[10] <= writeDataM10;
				cacheData[11] <= writeDataM11;
				cacheData[12] <= writeDataM12;
				cacheData[13] <= writeDataM13;
				cacheData[14] <= writeDataM14;
				cacheData[15] <= writeDataM15;
			end
		else if(writeD && hit)
			cacheData[AdrD[5:2]] <= writeDataD;
	end
		
	assign readData = cacheData[AdrD[5:2]];
	
	
endmodule

