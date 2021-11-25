`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    17:14:24 06/21/2019 
// Design Name: 	 pipe_line_project.
// Module Name:    ALU 
// Project Name:   phase3
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
module ALU( A, B, ALUControl, ALUResult, Zero);

	input   [2:0]   ALUControl; // control bits for ALU operation
	input   [31:0]  A, B;	    // inputs

	output  reg [31:0]  ALUResult;	// answer
	output  reg Zero;	    // Zero=1 if ALUResult == 0

    always @(ALUControl,A,B)
    begin
		case (ALUControl)
			
			0: // ADD
				ALUResult <= A + B;

			1: // SUB
				ALUResult <= A + (~B + 1);

			2: // AND
				ALUResult <= A & B;

			3: // OR
				ALUResult <= A | B;

			4: // XOR
				ALUResult <= A ^ B;

			5: // NOR
				ALUResult <= ~(A | B);

			6: begin // SLT
				if (A[31] != B[31]) begin
					if (A[31] > B[31]) begin
						ALUResult <= 1;
					end else begin
						ALUResult <= 0;
					end
				end else begin
					if (A < B)
					begin
						ALUResult <= 1;
					end
					else
					begin
						ALUResult <= 0;
					end
				end
			end
			
			
			7: // SLTU
				ALUResult <= A < B;
			
			
		endcase
	end


	always @(ALUResult) begin
		if (ALUResult == 0) begin
			Zero <= 1;
		end else begin
			Zero <= 0;
		end
	
	end

endmodule


