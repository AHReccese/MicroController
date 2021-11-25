module hazard_unit(input clk, reset,
		 input [4:0] RsD, RtE, RtD, RsE, WriteRegM, WriteRegW,WriteRegE,
		 input RegWriteE,RegWriteM, RegWriteW, PCSrcE,
		 input MemtoRegE,MemtoRegM,MemWriteE,MemWriteBuf,MemWriteM,
		 input cacheHit,
		 //input RegDstD, RegDstE,
	     //input [31:0] ALUOutM,
         output reg StallF, StallD, StallE, StallM,StallW, FlushE,FlushM, FlushW,
		 output reg [1:0] ForwardAE, ForwardBE,
		 output reg StallBuf, MemToCache);
			
	
	reg [1:0] Counter;

	always@(posedge clk)	
		begin
			if (reset)
				Counter <= 0;
			else if ( ( MemtoRegM && (!cacheHit) ) || ( MemWriteM || MemWriteBuf))
				Counter <= Counter+1;
		end

				  
	always@(*)
		begin
			StallF = 1'b0;
			StallD = 1'b0;
			StallE = 1'b0;
			StallM = 1'b0;
			StallW = 1'b0;
			FlushE = 1'b0;
			FlushM = 1'b0;
			FlushW = 1'b0;
			ForwardAE = 2'b00;
			ForwardBE = 2'b00;
			StallBuf = 1'b0;
			MemToCache = 1'b0;
			

			if ((RsE != 0)&&(RsE == WriteRegM)&&(RegWriteM))
				ForwardAE = 2'b10;
			else if ((RsE != 0)&&(RsE == WriteRegW)&&(RegWriteW))
				ForwardAE = 2'b01;
			
			if ((RtE != 0)&&(RtE == WriteRegM)&&(RegWriteM))
				ForwardBE = 2'b10;
			else if ((RtE != 0)&&(RtE == WriteRegW)&&(RegWriteW))
				ForwardBE = 2'b01;

			if ((RsD == RtE || RtD == RtE)&&(MemtoRegE))
				begin
					StallF = 1'b1;
					StallD = 1'b1;
					FlushE = 1'b1;
				end
			
			if ( ( MemtoRegM && (!cacheHit) ) && (Counter != 3) )
				begin	
					StallF = 1'b1;
					StallD = 1'b1;
					StallE = 1'b1;
					StallM = 1'b1;
					StallW = 1'b1;
				end
			
			if ( MemWriteBuf && (Counter != 3) )
				begin
					StallBuf = 1'b1;
				end
				
			if ( ( ( MemtoRegE ) || MemWriteE ) && MemWriteBuf && (Counter != 3) )
				begin
					StallF = 1'b1;
					StallD = 1'b1;
					StallE = 1'b1;
				end
				
			if ( ( MemtoRegM && (!cacheHit) ) && (Counter == 3) )
				begin	
					MemToCache = 1'b1;
				end
				
		end
endmodule

