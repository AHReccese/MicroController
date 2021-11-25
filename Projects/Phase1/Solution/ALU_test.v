`timescale 10ns/1ns

module ALU_test();
	//registers
	reg [31:0]SrcA;
	reg [31:0]SrcB;
	reg [2:0]ALUControl;
	
	//wires
	wire Zero;
	wire [31:0]ALUResult;
	 
	
	initial 
		begin
			SrcA <= 32'd25;
			SrcB <= 32'd100;
			ALUControl <= 3'b000;//add
			#32;
			SrcA <= 32'd333;
			SrcB <= 32'd1024;
			ALUControl <= 3'b001;//sub
			#32;
			SrcA <= 32'hf0f0;
			SrcB <= 32'h0f0f;
			ALUControl <= 3'b010;//and
			#32;
			SrcA <= 32'ha0a0;
			SrcB <= 32'h5f5f;
			ALUControl <= 3'b011;//or
			#32;
			SrcA <= 32'h1212;
			SrcB <= 32'h3232;
			ALUControl <= 3'b100;//xor
			#32;
			SrcA <= 32'h2222;
			SrcB <= 32'h2222;
			ALUControl <= 3'b101;//nor
			#32;
			SrcA <= 32'hf345;
			SrcB <= 32'h7354;
			ALUControl <= 3'b110;//slt
			#32;
			SrcA <= 32'hf123;
			SrcB <= 32'h7811;
			ALUControl <= 3'b111;//sltu
			#32;
		$stop();
		end
  
	ALU alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .Zero(Zero));     
endmodule
