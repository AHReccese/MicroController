module Top_Ph3(input clk,reset);
	
	// Wires and Regs
	wire [31:0] PC,PCPlus4F, InstrF;
	wire StallF;
	reg [31:0] PCF;
	

	wire [31:0] RD1D, RD2D;
	wire [31:0] SignImmD;
	wire [4:0] RsD, RtD, RdD;
	wire [2:0] ALUControlD;
	wire MemtoRegD, MemWriteD, BranchD, BranchND,ALUSrcD, RegDstD, RegWriteD, extendSorZD;
	wire StallD;
	reg [31:0] InstrD ,PCPlus4D;


	wire [31:0] SrcAE, SrcBE, ALUOutE, WriteDataE;
	wire [31:0] ShiftImmE, PCBranchE;
	wire [4:0] WriteRegE;
	wire [1:0] ForwardAE, ForwardBE;
	wire PCSrcE, ZeroE;
	wire FlushE,StallE;
	reg [31:0] SignImmE,PCPlus4E;
	reg [31:0] RD1E, RD2E;
	reg [4:0] RsE, RtE, RdE;
	reg [2:0] ALUControlE;
	reg MemtoRegE, MemWriteE, ALUSrcE, RegDstE,RegWriteE;
	reg BranchE, BranchNE;


	wire [31:0] ReadDataM;
	wire FlushM,StallM;				
	reg [31:0] ALUOutM, WriteDataM;
	reg [4:0] WriteRegM;
	reg RegWriteM, MemtoRegM, MemWriteM;
	
	
	wire [31:0] ResultW;
	wire FlushW,StallW;		 
	reg RegWriteW, MemtoRegW;
	reg [4:0] WriteRegW;
	reg [31:0] ReadDataW, ALUOutW;
	
	reg [31:0] ALUOutBuf, WriteDataBuf;
	reg MemWriteBuf;
	
	wire cacheHit;
	wire MemToCache;
		
	wire [31:0]dmemAddress;
	wire dmemMemWrite;
	wire [31:0]dmemWriteData;
	wire FlushBuf,StallBuf;	
	
	//Hazard Unit
	hazard_unit hazard_unit(.clk(clk),.reset(reset),
							.RsD(RsD), .RtE(RtE), .RtD(RtD), .RsE(RsE), .WriteRegM(WriteRegM), .WriteRegW(WriteRegW), .WriteRegE(WriteRegE),
							.RegWriteE(RegWriteE), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .PCSrcE(PCSrcE), 
							.MemtoRegE(MemtoRegE), .MemtoRegM(MemtoRegM), .MemWriteE(MemWriteE), .MemWriteM(MemWriteM),
							.MemWriteBuf(MemWriteBuf), .cacheHit(cacheHit),
							//.RegDstD(RegDstD), .RegDstE(RegDstE),  
							//.ALUOutM(ALUOutM), 
							.StallF(StallF), .StallD(StallD), .StallE(StallE), .StallM(StallM), .StallW(StallW), .FlushE(FlushE), .FlushM(FlushM), .FlushW(FlushW),
							.ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
							.StallBuf(StallBuf),.MemToCache(MemToCache));
	
	
	// Control Unit
	control_unit control_unit(.Instr(InstrD), .MemtoReg(MemtoRegD), .MemWrite(MemWriteD),
				.Branch(BranchD), .BranchN(BranchND), .ALUControl(ALUControlD),
			    .ALUSrc(ALUSrcD), .RegDst(RegDstD), .RegWrite(RegWriteD), .extendSorZ(extendSorZD));



	// Datapath
	// Fetch
	imem Instruction_Memory(.address(PCF), .read_data(InstrF));
	assign PCPlus4F = PCF + 32'd4;
	assign PC = (PCSrcE) ? PCBranchE : PCPlus4F;

	always@(posedge clk)
		begin
			if (reset)
				PCF <= 0;
			else if (!StallF)
				PCF <= PC;
		end
		
	// FlipFlops between Fetch and Decode
	always@(posedge clk)
		begin
			if (reset| ( PCSrcE && (!StallD) ) )		//flush instruction when branch taken TODO: catch FlushD from hazard unit
				begin
					InstrD <= 0;
					PCPlus4D <= 0;
				end
			else if (!StallD)
				begin
					InstrD <= InstrF;
					PCPlus4D <= PCPlus4F;
				end
		end

	// Decode
		
	assign RsD = InstrD[25:21];
	assign RtD = InstrD[20:16];
	assign RdD = InstrD[15:11];
	
	reg_file reg_file(.clk(clk), .write(RegWriteW) , .RR1(InstrD[25:21]), .RR2(InstrD[20:16]), .WR(WriteRegW),
							  .WD(ResultW), .RD1(RD1D), .RD2(RD2D));	


	
	assign SignImmD = (extendSorZD)?{{16{InstrD[15]}},InstrD[15:0]}:{16'd0,InstrD[15:0]};
	
	// FlipFlops between Decode and Execute
	always@(posedge clk)
		begin
			if ( reset | ( (PCSrcE  | FlushE ) && (!StallE) )	)	//flush instruction when branch taken TODO: catch FlushE from hazard unit
				begin
					// control lines
					RegWriteE <= 0;
					MemtoRegE <= 0;
					MemWriteE <= 0;
					ALUControlE <= 0;
					ALUSrcE <= 0;
					RegDstE <= 0;
					BranchE <= 0;
					BranchNE <= 0;
					// data lines
					RD1E <= 0;
					RD2E <= 0;
					RsE <= 0;
					RtE <= 0;
					RdE <= 0;
					SignImmE <= 0;
					PCPlus4E <= 0;
				end
			else if( !StallE )
				begin
					// control lines
					RegWriteE <= RegWriteD;
					MemtoRegE <= MemtoRegD;
					MemWriteE <= MemWriteD;
					ALUControlE <= ALUControlD;
					ALUSrcE <= ALUSrcD;
					RegDstE <= RegDstD;
					BranchE <= BranchD;
					BranchNE <= BranchND;
					// data lines
					RD1E <= RD1D;
					RD2E <= RD2D;
					RsE <= RsD;
					RtE <= RtD;
					RdE <= RdD;
					SignImmE <= SignImmD;
					PCPlus4E <= PCPlus4D;
				end
		end

	// Execute
	assign PCSrcE = (BranchE & ZeroE ) | ( BranchNE & ( ~ZeroE ) );
	
	assign ShiftImmE = SignImmE << 2;
	assign PCBranchE = ShiftImmE + PCPlus4E;
	assign SrcAE = (ForwardAE==2'b00)?RD1E:(ForwardAE==2'b01)?ResultW:(ForwardAE==2'b10)?ALUOutM:0;
	assign WriteDataE = (ForwardBE==2'b00)?RD2E:(ForwardBE==2'b01)?ResultW:(ForwardBE==2'b10)?ALUOutM:0;
	assign SrcBE = (ALUSrcE)?SignImmE:WriteDataE;
	assign WriteRegE = (RegDstE)?RdE:RtE;
	alu alu(.a(SrcAE), .b(SrcBE), .alu_control(ALUControlE), .result(ALUOutE), .zero(ZeroE));

	// FlipFlops between Execute and Memory
	always@(posedge clk)
		begin
			if (reset | ( FlushM && (!StallM)) )		
				begin
					// control lines
					RegWriteM <= 0;
					MemtoRegM <= 0;
					MemWriteM <= 0;
					// data lines
					ALUOutM <= 0;
					WriteDataM <= 0;
					WriteRegM <= 0;
					
				end
			else if( !StallM )
				begin
					// control lines
					RegWriteM <= RegWriteE;
					MemtoRegM <= MemtoRegE;
					MemWriteM <= MemWriteE;
					// data lines
					ALUOutM <= ALUOutE;
					WriteDataM <= WriteDataE;
					WriteRegM <= WriteRegE;
					
				end
		end
		
	//Buffer 
	always@(posedge clk)
		begin
			if (reset | ( FlushBuf && (!StallBuf)) )		
				begin
					// control lines
					MemWriteBuf <= 0;
					// data lines
					ALUOutBuf <= 0;
					WriteDataBuf <= 0;
				end
			else if( !StallBuf )
				begin
					// control lines
					MemWriteBuf <= MemWriteE;
					// data lines
					ALUOutBuf <= ALUOutE;
					WriteDataBuf <= WriteDataE;
				
				end
		end
	
	
	assign dmemAddress = (MemWriteBuf) ? ALUOutBuf:ALUOutM ;
	assign dmemMemWrite = (MemWriteBuf)? MemWriteBuf:MemWriteM;
	assign dmemWriteData = (MemWriteBuf)? WriteDataBuf:WriteDataM;
	// Memory
	
	memory_cache MemoryWithCache(.clk(clk), .reset(reset), .writeMem(dmemMemWrite), .writeCache(MemWriteM),.MemToCache(MemToCache),
								.address(dmemAddress), .write_data(dmemWriteData),.hit(cacheHit), .read_data(ReadDataM));

	// FlipFlops between Memory and WriteBack
	always@(posedge clk)
		begin
			if (reset | ( FlushW && (!StallW) ) )			
				begin
					// control lines
					RegWriteW <= 0;
					MemtoRegW <= 0;
					// data lines
					ReadDataW <= 0;
					ALUOutW <= 0;
					WriteRegW <= 0;
				end
			else if(!StallW)
				begin
					// control lines
					RegWriteW <= RegWriteM;
					MemtoRegW <= MemtoRegM;
					// data lines
					ReadDataW <= ReadDataM;
					ALUOutW <= ALUOutM;
					WriteRegW <= WriteRegM;
				end
		end

	//WriteBack
	assign ResultW = (MemtoRegW)?ReadDataW:ALUOutW;
	


endmodule 
