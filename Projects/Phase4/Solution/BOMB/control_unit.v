module control_unit(input [31:0]Instr,
		output reg [2:0] ALUControl,
		output reg MemtoReg, MemWrite, Branch, BranchN, extendSorZ, ALUSrc, RegDst, RegWrite);
	
	always@(*)
		begin
			MemtoReg = 0;
			MemWrite = 0;
			Branch = 0;
			BranchN = 0;
			extendSorZ = 0;
			ALUSrc = 0;
			RegDst = 0;
			RegWrite = 0;
			ALUControl = 3'b000;
			case(Instr[31:26])
				6'b000000: //r-type 
					begin 
						RegWrite = 1;
						RegDst = 1;
						case(Instr[5:0])
									6'b100000: ALUControl = 3'b000; // add
									6'b100001: ALUControl = 3'b000; // addu
									6'b100010: ALUControl = 3'b001; // sub
									6'b100011: ALUControl = 3'b001; // subu
									6'b100100: ALUControl = 3'b010; // and
									6'b100101: ALUControl = 3'b011; // or
									6'b100110: ALUControl = 3'b100; // xor
									6'b100111: ALUControl = 3'b101; // nor
									6'b101010: ALUControl = 3'b111; // slt
									6'b101011: ALUControl = 3'b110; // sltu
						endcase
					end
				6'b100011: // lw
					begin
						RegWrite = 1;
						ALUSrc = 1;
						MemtoReg = 1;
						extendSorZ = 1;
						ALUControl = 3'b000;
					end
				6'b101011: // sw
					begin
						ALUSrc = 1;
						MemWrite = 1;
						extendSorZ = 1; 
						ALUControl = 3'b000;
					end
				6'b000100: // beq
					begin
						Branch = 1;
						extendSorZ = 1;
						ALUControl = 3'b001;
					end
				6'b000101: // bne
					begin
						BranchN = 1;
						extendSorZ = 1;
						ALUControl = 3'b001;
					end
				6'b001010: // slti
					begin
						RegWrite = 1;
						ALUSrc = 1;
						extendSorZ = 1;
						ALUControl = 3'b111;
					end
				6'b001011: // sltiu
					begin
						RegWrite = 1;
						ALUSrc = 1;
						ALUControl = 3'b110;
					end
				6'b001100: // andi
					begin
						RegWrite = 1;
						ALUSrc = 1;
						ALUControl = 3'b010;
					end
				6'b001101: // ori
					begin
						RegWrite = 1;
						ALUSrc = 1;
						ALUControl = 3'b011;
					end
				6'b001110: //xori
					begin
						RegWrite = 1;
						ALUSrc = 1;
						ALUControl = 3'b100;
					end
				6'b001000: // addi
					begin
						RegWrite = 1;
						ALUSrc = 1;
						extendSorZ = 1;
						ALUControl = 3'b000;
					end
				6'b001001: // addiu
					begin
						RegWrite = 1;
						ALUSrc = 1;
						ALUControl = 3'b000;
					end
			endcase
		end
endmodule


