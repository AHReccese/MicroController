`define imem_len 7 //imem input length must be 30 (32-2) but have been reduced for reducing simulation time

module imem(input [31:0] address,
	output [31:0] read_data);

	reg [31:0] mem_data [0 : (1 << `imem_len)-1];
	
	assign read_data = mem_data[ address[ ( `imem_len + 1 ) : 2 ] ];
endmodule
