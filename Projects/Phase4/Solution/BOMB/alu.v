module alu(input [31:0] a, b,
           input [2:0] alu_control,
           output reg [31:0] result,
           output wire zero);

	wire [31:0] sum;

	
	assign sum = a + (alu_control[0] ? ~b : b) + alu_control[0];
	
	always @(*)
		begin
			case(alu_control)
				3'b000: result = sum;		//add
				3'b001: result = sum;		//sub
				3'b010: result = a & b;		//and
				3'b011: result = a | b;		//or
				3'b100: result = a ^ b;		//xor
				3'b101: result = ~(a | b);	//nor
				3'b110: result = ( a < b ) ;	//sltu
				3'b111: result = sum[31];	//slt
				default: result = 32'b0;
			endcase

		end

	assign zero = ~(|result);	
endmodule