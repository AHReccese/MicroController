`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    PipeLine
// Project Name:   phase3
// Target Devices: 
// Tool versions: 
// Description: 
//	contact me via telegram: @AHReccese
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Pipeline (
	input clk,
	input reset
	);
	
	//wires and regs
	wire [31:0] pcnext;
	wire [31:0] pc;
	wire [31:0] instrF;
	wire [31:0] pcplus4F;
	reg [31:0] instrD;
	reg [4:0] writeregW;
	wire [31:0] resultW;
	reg regwriteW;
	wire [31:0] regfile_RD1;
	wire [31:0] regfile_RD2;
	wire [31:0] srcaE;
	wire [31:0] srcbE;
	reg [2:0] alucontrolE;
	wire [31:0] aluoutE;
	wire [31:0] writedataE;
	reg [31:0] signimmE;
	reg  alusrcE;
	reg regdstE;
	reg [4:0] RtE;
	reg [4:0] RdE;
	wire [4:0] writeregE;
	wire [31:0] signimmD;
	wire sgnzeroD;
	wire [31:0] pcbranchD;
	reg [31:0] aluoutM;
	reg [31:0] writedataM;
	reg memwriteM;
	wire [31:0] readdataM;
	reg [31:0] aluoutW;
	reg [31:0] readdataW;
	reg memtoregW;
	
	reg [31:0] pcplus4D;
	reg [4:0] writeregM;
	wire [2:0] alucontrolD;
	wire memtoregD;
	wire memwriteD;
	wire alusrcD;
	wire regdstD;
	wire regwriteD;
	reg regwriteE;
	reg memtoregE;
	reg memwriteE;
	reg regwriteM;
	reg memtoregM;
	reg [4:0] RsE;
	reg [31:0] regfile_RD_E1;
	reg [31:0] regfile_RD_E2;
	wire [1:0] ForwardAE;
	wire [1:0] ForwardBE;
	wire StallF;
	wire StallD;
	wire FlushE;
	wire [1:0] branchD;
	reg [1:0] branchE;
	wire zeroE;
	wire pcsrcE;
	reg [31:0] pcbranchE;

	always@(posedge clk)
	begin
		
		if (StallD == 1'b0)
		begin
			if (pcsrcE == 1'b1)
				instrD <= 32'b0;
			else
			begin
			instrD <= instrF;
			pcplus4D <= pcplus4F;
			end
		end
		
		if ((FlushE == 1'b0) && (pcsrcE == 1'b0))
		begin
			signimmE <= signimmD;
			RtE <= instrD[20:16];
			RdE <= instrD[15:11];
			RsE <= instrD[25:21];
			
			regfile_RD_E1 <= regfile_RD1;
			regfile_RD_E2 <= regfile_RD2;
		
			
			branchE <= branchD;
			pcbranchE <= pcbranchD;
			regwriteE <= regwriteD;
			memtoregE <= memtoregD;
			memwriteE <= memwriteD;
			alucontrolE <= alucontrolD;
			alusrcE <= alusrcD;
			regdstE <= regdstD;
		end
		else
		begin
			signimmE <= 32'b0;
			RtE <= 5'b0;
			RdE <= 5'b0;
			RsE <= 5'b0;
			regfile_RD_E2 <= 32'b0;
			regfile_RD_E1 <= 32'b0;
			branchE <= 2'b0;
			pcbranchE <= 32'b0;
			regwriteE <= 1'b0;
			memtoregE <= 1'b0;
			memwriteE <= 1'b0;
			alucontrolE <= 1'b0;
			alusrcE <= 1'b0;
			regdstE <= 1'b0;
		end
		
		
		writeregM <= writeregE;
		writedataM <= writedataE;
		aluoutM <= aluoutE;
		regwriteM <= regwriteE;
		memtoregM <= memtoregE;
		memwriteM <= memwriteE;
		writeregW <= writeregM;
		readdataW <= readdataM;
		aluoutW <= aluoutM;
		regwriteW <= regwriteM;
		memtoregW <= memtoregM;
		
	end
	
		Mux2_1 #(32) srcbmux(writedataE, signimmE, alusrcE, srcbE);
		Mux2_1  #(5) wrmux(RtE, RdE, regdstE, writeregE);
		SignExtend se(instrD[15:0], sgnzeroD, signimmD);
		Mux2_1  #(32) resmux(aluoutW, readdataW, memtoregW, resultW);
		Mux2_1  #(32) pcbrmux(pcplus4F, pcbranchE, pcsrcE, pcnext);
		assign srcaE = (ForwardAE == 2'b10) ? aluoutM : ((ForwardAE == 2'b01) ? resultW : regfile_RD_E1);
		assign writedataE = (ForwardBE == 2'b10) ? aluoutM : ((ForwardBE == 2'b01) ? resultW : regfile_RD_E2);
		assign pcsrcE = ((branchE == 2'b01) && (zeroE == 1'b1)) ? 1'b1 : (((branchE == 2'b10) && (zeroE == 1'b0)) ? 1'b1 : 1'b0);
		triStateBuffer #(32) pcreg(clk, reset,!StallF, pcnext, pc); 
		Adder pcadd1(pc, 32'b100, pcplus4F); 
		RegisterFile rf(clk, regwriteW, instrD[25:21], instrD[20:16], writeregW, resultW, regfile_RD1, regfile_RD2);

		ALU alu(srcaE, srcbE, alucontrolE, aluoutE, zeroE);
		assign pcbranchD = (signimmD << 2) +  pcplus4D;

		InstructionMemory imem(pc,instrF); 
		DataMemory dmem(clk, memwriteM, aluoutM, writedataM, readdataM);
		HazardUnit h(instrD[25:21],instrD[20:16],RsE,RtE,writeregM,writeregW,regwriteM,regwriteW,memtoregE,ForwardAE,ForwardBE,FlushE,StallD,StallF);
		Controller c(instrD[31:26], instrD[5:0], memtoregD, memwriteD,  alusrcD, regdstD, regwriteD, sgnzeroD, alucontrolD,branchD);
		
	
endmodule
	