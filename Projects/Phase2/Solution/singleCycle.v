`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SharifUniversity
// Engineer: AmirHoseinRostami
// 
// Create Date:    19:16:41 05/08/2019 
// Design Name:    AHReccese
// Module Name:    SingleCycle 
// Project Name:   phase2
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MIPS(
input clk,
input reset
    );
	 
wire [31:0] firstPC;
wire [31:0] address;
wire [31:0] readData;
wire regwrite;
wire [4:0] writereg;
wire regdst;
wire zero;
wire memtoreg;
wire memwrite;
wire pcsrc;
wire [2:0]aluop;
wire alusrc;
wire sgnzero;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] srca;
wire [31:0] srcb;
wire [31:0] signimm;
wire [31:0] aluresult;
wire zeroAlu;
wire [31:0] dataMemoryReadData;
wire [31:0] registerFileWD3;
wire [31:0] pcbranchIn;
wire [31:0] pcbranchOut;
wire PCSrc;
wire [31:0] pcplus;

assign firstPC = (pcsrc == 0) ? pcplus : pcbranchOut;
// PC prim ...

PC pc(.clk(clk),.reset(reset),.nxt_pc(firstPC),.out(address));
InstructionMemory instructionMemory(.A(address),.RD(readData));

assign registerFileWD3 = (memtoreg == 0)? aluresult : dataMemoryReadData;
// wd3 completed via othermodules...

assign writereg = (regdst == 0) ? readData[20:16] : readData[15:11];
RegisterFile registerFile(.clk(clk),.A1(readData[25:21]),.A2(readData[20:16]),.A3(writereg),.WE3(regwrite),.WD3(registerFileWD3),.RD1(readData1),.RD2(readData2));

assign srcb = ( alusrc == 0 ) ? readData2 : signimm;
// creating srcB 
ALU alu(.SrcA(readData1),.SrcB(srcb),.ALUControl(aluop),.ALUResult(aluresult),.Zero(zeroAlu));
DataMemory dataMemory(.clk(clk),.WE(memwrite),.A(aluresult),.WD(readData2),.RD(dataMemoryReadData));

// zero ... completed by aluzero
Controller controller(.op(readData[31:26]),.funct(readData[5:0]),.zero(zeroAlu),.MemtoReg(memtoreg),.MemWrite(memwrite),.PCSrc(pcsrc),.ALUOP(aluop),.ALUSrc(alusrc),.RegDst(regdst),.RegWrite(regwrite),.SgnZero(sgnzero));

// have not use SGNzero

SignExtend signextend(.gonnaSignExtend(readData[15:0]),.sgnZero(sgnzero),.signExtended(signimm));
Shifter shifter(.in(signimm),.out(pcbranchIn));
// pc + 4 = address + 4
// pc is output of PC module as you see above ...
// pc plus = pcOutput + 4
assign pcplus = address + 4;
assign pcbranchOut = pcbranchIn + pcplus;
// before PC module mux ...


endmodule



module PC(

input clk,
input reset,
input [31:0] nxt_pc,
output reg [31:0]out
    );

always@(posedge clk)
begin

	if(reset) 
	begin
	out <= 32'h0000_0000;
	end
	
	else
	begin
	out <= nxt_pc;
	end
	
end

endmodule







module InstructionMemory(

input [31:0] A,
output [31:0] RD
);
	 
reg [31:0] RAM [1023:0];
//initial begin
//$readmemh("memfile.dat",RAM);
//end
assign RD = RAM[A[31:2]];

endmodule




module DataMemory(
input clk,
input WE,
input [31:0] A,
input [31:0] WD,
output [31:0] RD
);

reg [31:0] RAM[1023:0];
assign RD = RAM[A[31:2]];

always @(posedge clk)
	if(WE)
	RAM[A[31:2]] <= WD;
	
endmodule


module RegisterFile(
input clk,
input [4:0] A1,
input [4:0] A2,
input [4:0] A3,
input WE3,
input [31:0] WD3,
output[31:0] RD1,
output[31:0] RD2
);

reg[31:0] rf_data[0:31];
assign RD1 = rf_data[A1];
assign RD2 = rf_data[A2];

always@(posedge clk) begin
	if(WE3)
	rf_data[A3] <= WD3;
	rf_data[0] <= 32'h0000_0000;
	end
	
endmodule


module ALU(
input [31:0]SrcA,
input [31:0]SrcB,
input [2:0]ALUControl,
output[31:0]ALUResult,
output Zero
);

assign ALUResult = ( ALUControl == 3'b000 ) ? SrcA + SrcB :
						 ( ALUControl == 3'b001 ) ? SrcA - SrcB :
						 ( ALUControl == 3'b010 ) ? SrcA & SrcB :
						 ( ALUControl == 3'b011 ) ? SrcA | SrcB :
						 ( ALUControl == 3'b100 ) ? SrcA ^ SrcB :
						 ( ALUControl == 3'b101 ) ? ~(SrcA | SrcB) :
						 ( ALUControl == 3'b110 ) ? $signed(SrcA) < $signed(SrcB):
						 ( ALUControl == 3'b111 ) ? SrcA < SrcB : 32'h00000000;
					
assign Zero = ( ALUResult == 32'h00000000 )? 1 : 0;

endmodule 




module Controller(
input [5:0] op,
input [5:0] funct,
input zero,

output MemtoReg,
output MemWrite,
output PCSrc,
output [2:0]ALUOP,

output ALUSrc,
output RegDst,
output RegWrite,
output SgnZero

    );

reg [9:0] outs;

always@(*)
begin
casex(op)

  6'b100011: outs=10'b1_0_0_000_1_0_1_1;
  6'b101011: outs=10'b0_1_0_000_1_0_0_1;
  6'b000100: outs={2'b00,zero,7'b001_0101};
  6'b000101: outs={2'b00,~zero,7'b001_0101};
  6'b001100: outs=10'b0_0_0_010_1_0_1_0;
  6'b001101: outs=10'b0_0_0_011_1_0_1_0;
  6'b001110: outs=10'b0_0_0_100_1_0_1_0;
  6'b001000: outs=10'b0_0_0_000_1_0_1_1;
  6'b001001: outs=10'b0_0_0_000_1_0_1_0;
  6'b001010: outs=10'b0_0_0_110_1_0_1_1;
  6'b001011: outs=10'b0_0_0_111_1_0_1_0;
  
  6'b000000:
			casex(funct)
			 12'b000000100000: outs=10'b0_0_0_000_0_1_1_0;
			 12'b000000100001: outs=10'b0_0_0_000_0_1_1_0;
			 12'b000000100010: outs=10'b0_0_0_001_0_1_1_0;
			 12'b000000100011: outs=10'b0_0_0_001_0_1_1_0;
			 12'b000000100100: outs=10'b0_0_0_010_0_1_1_0;
			 12'b000000100101: outs=10'b0_0_0_011_0_1_1_0;
			 12'b000000100110: outs=10'b0_0_0_100_0_1_1_0;
			 12'b000000100111: outs=10'b0_0_0_101_0_1_1_0;
			 12'b000000101010: outs=10'b0_0_0_110_0_1_1_0;
			 12'b000000101011: outs=10'b0_0_0_111_0_1_1_0;
			 default:outs=10'b0_0_0_000_0_0_0_0;
			 endcase
  default:outs=10'b0_0_0_000_0_0_0_0; 
endcase  
end

// extracting Data from register	
	
assign MemtoReg = outs[9];

assign MemWrite = outs[8];

assign PCSrc = outs[7];

assign ALUOP = outs[6:4];

assign ALUSrc = outs[3];

assign RegDst = outs[2];

assign RegWrite = outs[1];

assign SgnZero = outs[0];

				
				
endmodule



module SignExtend(
input [15:0] gonnaSignExtend,
input sgnZero,
output [31:0] signExtended
    );

assign signExtended = (sgnZero == 1'b1 ) ? {signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
													      signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  signExtended[15],
														  gonnaSignExtend}
													  : {16'b0000_0000_0000_0000,gonnaSignExtend};  

endmodule



module Shifter(
input [31:0] in,
output [31:0] out
    );

assign out = in * 4;

endmodule




