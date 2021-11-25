`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    06:19:24 06/24/2019 
// Design Name: 	 cache_project
// Module Name:    Top
// Project Name:   phase4
// Target Devices: 
// Tool versions: 
// Description: 
//	contact me via telegram ID : @AHReccese
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top( input clk, input Reset, output  Hit, output [7:0]memOutData);
wire RWB;
reg [1:0] clockSyncer;
wire [5:0] Address;
wire [7:0] Data;

// creates the address and RWB and the Data.

// *** Necessary readMe : look at the structure below 
//							Way0	  										way1
// My syntax = LRU // FIRST BLOCK : DIRTY_BIT VALID_BIT TAG MAIN_DATA //  SECOND BLOCK : DIRTY_BIT VALID_BIT TAG MAIN_DATA;

reg [26:0] cache [7:0]; // has 8 sets which each set contains 2 blocks --> cache with 16 blocks ... Memory
wire [2:0] number_Set;
wire writeEnable;
wire [7:0] ReadData;
wire [7:0] writeData;
wire [5:0] ReadAddress;
wire [5:0] writeAddress;
wire [26:0] takenSet;

assign number_Set=Address[2:0]; // extracts the number of Set.
// in order to simplify the complexity of the code
assign readEnable = !RWB;
assign ReadAddress = Address;  // address 
assign takenSet=cache[number_Set]; // chosen set

// checking Hit : if the three MSB bits match at least one of the addresses exist in takenSet
assign Hit = ({1'b1,Address[5:3]}==takenSet[24:21])||({1'b1,Address[5:3]}==takenSet[11:8]); // creates

assign writeEnable=((!Hit)&&((takenSet[25]&&takenSet[24])||(takenSet[12]&&takenSet[11]))); // first time writing.

// where to write according to LRU --> LRU ? Way1 : Way0
assign writeAddress = (cache[number_Set][26]) ? {cache[number_Set][23:21],number_Set} : {cache[number_Set][10:8],number_Set};

assign writeData=(takenSet[26]?takenSet[20:13]:takenSet[7:0]);
// readEnable is equivalent to readingMode.
assign memOutData=((readEnable)&&(Address[5:3] == cache[number_Set][23:21])&&takenSet[24] )? (cache [number_Set][20:13]) : ((readEnable)&&((Address[5:3] == cache[number_Set][10:8]))&&takenSet[11]) ? (cache [number_Set][7:0] ): ((readEnable) ? ReadData : 0) ;

Processor processor1(clk,clockSyncer[0], RWB, Address, Data);
RAM ram1(ReadData, writeData, Reset,ReadAddress,writeAddress, clk, writeEnable,1'b1);

// written Data ...
integer i;



always @(posedge clk) 
begin 
	if (Reset) // reset All datas in cache
		begin 
			for(i=0;i<8;i=i+1)
			cache[i] <= 27'b0000_0000_0000_0000_0000_0000_000;
			clockSyncer<=2'b00;
		end
	else
		begin
			if (clockSyncer == 0)
				clockSyncer <= 1;
			else if (clockSyncer == 1)
				clockSyncer <= 2;
			
			// lets check readingPart!
			if(readEnable)   // we are gonna read Data.
				begin
					if(takenSet[24]==0) // way1 block has valid value = 0 so it isnt used before --> load from memory
						begin
							cache[number_Set][26:13]<={3'b001,Address[5:3],ReadData}; // syntax : LRU DIRTY_BIT VALID_BIT TAG MAIN_DATA  = 0_0_1_3bitAddress_ReadData
							// LRU bit should be zero because way0 isnt used recently.
						end
					else if(takenSet[11]==0) // way0 block has valid value = 0 so it isnt used before --> load from memory
						begin 
							cache[number_Set][12:0]<={2'b01,Address[5:3],ReadData};  // syntax :  DIRTY_BIT VALID_BIT TAG MAIN_DATA  = 0_1_3bitAddress_ReadData 
							//LRU bit should be 1 because way1 isnt used recently.
							cache[number_Set][26]<=1;
						end
					
					// above block of code checks whether it is first time to use cache or not.
							
						
					else // at least one of the valid bits is 1. way0 or way1 we dont know which one!
						begin
							if(takenSet[23:21]==Address[5:3]) // address matches way0
								begin 
								//LRU bit should be 0 because way0 isnt used recently.
									cache[number_Set][26]<=0; // LRU change 
								end
							else if(takenSet[10:8]==Address[5:3]) // address matches way1
								begin 
								//LRU bit should be 1 because way1 isnt used recently.
									cache[number_Set][26]<=1; // LRU change
								end
								
								
							// none of the addresses matches the blocks so what?
							// miss happens but it is different from the previous Miss occurance How?
							// in this time it isnt first time that we are gonna write into cache but the also
							// we have used it at least once.
							// now we are gonna to load Data from memory into cache.
							
							
							else if(takenSet[26]==1) // LRU is 1 so we are gonna write into  way1
								begin
									// LRU bit should be zero because way0 isnt used recently.
									cache[number_Set][26]<=0; // reversing the LRU
									// no need to change DIRTY_BIT VALID_BIT because they are taken also!
									cache[number_Set][23:13]<={Address[5:3],ReadData}; // loading data from memory
								end
							else
								begin
									// LRU bit should be one because way1 isnt used recently.
									cache[number_Set][26]<=1; // reversing the LRU
									// no need to change DIRTY_BIT VALID_BIT because they are taken also!
									cache[number_Set][10:0]<={Address[5:3],ReadData}; // loading data from memory
								end
						end
				end
					
				
			// let's check writingPart.		
			else if(RWB)
			
				begin
					if(takenSet[24]==0) // way1's valid bit is 0 
						begin
							//LRU bit should be zero because way0 isnt used recently.
							cache[number_Set][26:13]<={3'b011,Address[5:3],Data}; // setting way1's dirty bit to 1;
						end
					else if(takenSet[11]==0) // way0's valid bit is 0
						begin 
							cache[number_Set][12:0]<={2'b11,Address[5:3],Data}; // setting way0's dirty bit to 1;
							//LRU bit should be 1 because way1 isnt used recently.
							cache[number_Set][26]<=1;
						end
						
					else 
					// write mode.
						begin
						
						// checking adresses matches
							if(takenSet[23:21]==Address[5:3])
								begin 
									// write the given data into way1 
									cache[number_Set][23:13]<={Address[5:3],Data};
									// setting dirty bit
									cache[number_Set][25]<=1'b1;
									//LRU bit should be zero because way0 isnt used recently.									
									cache[number_Set][26]<=0;
								end
							else if(takenSet[10:8]==Address[5:3])
								begin 
									// write the given data into way0
									cache[number_Set][10:0]<={Address[5:3],Data};
									// setting dirty bit
									cache[number_Set][12]<=1'b1;
									//LRU bit should be 1 because way1 isnt used recently.									
									cache[number_Set][26]<=1;	
								end
								
						// addresses dont match ...
							else if(takenSet[26]==1)
								begin
									// LRU is one so write on the way1
									cache[number_Set][23:13]<={Address[5:3],Data};
									// setting dirty bit
									cache[number_Set][25]<=1'b1;
									// reversing the LRU
									cache[number_Set][26]<=0;
								end
							else if(takenSet[26]==0)
								begin
									// LRU is 0 so write on the way0
									cache[number_Set][10:0]<={Address[5:3],Data};
									// setting dirty bit
									cache[number_Set][12]<=1;
									// reversing the LRU
									cache[number_Set][26]<=1;
								end
						end
				end
		end
end
endmodule
