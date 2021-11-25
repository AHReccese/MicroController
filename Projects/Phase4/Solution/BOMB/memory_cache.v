module memory_cache(input clk,reset,
					input writeMem, writeCache, MemToCache,
					input [31:0] address,
					input [31:0] write_data,
					output hit,
					output [31:0] read_data);



	wire [31:0]memToCache0;
	wire [31:0]memToCache1;
	wire [31:0]memToCache2;
	wire [31:0]memToCache3;
	wire [31:0]memToCache4;
	wire [31:0]memToCache5;
	wire [31:0]memToCache6;
	wire [31:0]memToCache7;
	wire [31:0]memToCache8;
	wire [31:0]memToCache9;
	wire [31:0]memToCache10;
	wire [31:0]memToCache11;
	wire [31:0]memToCache12;
	wire [31:0]memToCache13;
	wire [31:0]memToCache14;
	wire [31:0]memToCache15;
	
	wire [31:0] readDataCache;
	wire [31:0] readDataMem;

	dmem dmem(.clk(clk),
			.write(writeMem),
			.address(address),
			.write_data(write_data),
			.read_data(readDataMem),
			.read_data_c0(memToCache0), .read_data_c1(memToCache1), .read_data_c2(memToCache2),
			.read_data_c3(memToCache3), .read_data_c4(memToCache4), .read_data_c5(memToCache5),
			.read_data_c6(memToCache6), .read_data_c7(memToCache7),
			.read_data_c8(memToCache8), .read_data_c9(memToCache9), .read_data_c10(memToCache10),
			.read_data_c11(memToCache11), .read_data_c12(memToCache12), .read_data_c13(memToCache13),
			.read_data_c14(memToCache14), .read_data_c15(memToCache15));
		

	cache cache(.clk(clk),.reset(reset),
				.writeD(writeCache),
				.writeM(MemToCache),
				.AdrD(address),
				.writeAdrM(address),
				.writeDataD(write_data), 
				.writeDataM0(memToCache0), .writeDataM1(memToCache1), .writeDataM2(memToCache2),
				.writeDataM3(memToCache3), .writeDataM4(memToCache4), .writeDataM5(memToCache5),
				.writeDataM6(memToCache6), .writeDataM7(memToCache7),
				.writeDataM8(memToCache8), .writeDataM9(memToCache9),
				.writeDataM10(memToCache10), .writeDataM11(memToCache11), .writeDataM12(memToCache12),
				.writeDataM13(memToCache13), .writeDataM14(memToCache14), .writeDataM15(memToCache15),
				
				.hit(hit),
				.readData(readDataCache));
				
				
	assign read_data = hit ? readDataCache : readDataMem;

endmodule
			