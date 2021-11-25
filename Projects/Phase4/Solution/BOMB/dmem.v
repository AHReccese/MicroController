`timescale 1ns/1ns
`define dmem_len 12 //imem input length must be 30 (32-2) but have been reduced for reducing simulation time

module dmem(input clk,
	input write,
	input [31:0] address,
	input [31:0] write_data,
	output [31:0] read_data,
	//data line for cache
	output [31:0] read_data_c0, read_data_c1, read_data_c2, read_data_c3, read_data_c4, read_data_c5, read_data_c6, read_data_c7,
	output [31:0] read_data_c8, read_data_c9, read_data_c10, read_data_c11, read_data_c12, read_data_c13, read_data_c14, read_data_c15);

	reg [31:0] mem_data [0 : (1 << `dmem_len)-1];

	wire write_d;
	wire [31:0] address_d;
	wire [31:0] write_data_d;
	
	wire [31:0]block_address;
	
	assign #30 write_d = write;
	assign #30 address_d = address;
	assign #30 write_data_d = write_data;
	
	assign read_data = mem_data[ address_d[( `dmem_len + 1 ):2] ];
	
	
	assign block_address = {address_d[31:6],6'b0};
	
	assign read_data_c0 = mem_data[ block_address[( `dmem_len + 1 ):2] ];
	assign read_data_c1 = mem_data[ block_address[( `dmem_len + 1 ):2] + 1 ];
	assign read_data_c2 = mem_data[ block_address[( `dmem_len + 1 ):2] + 2 ];
	assign read_data_c3 = mem_data[ block_address[( `dmem_len + 1 ):2] + 3 ];
	assign read_data_c4 = mem_data[ block_address[( `dmem_len + 1 ):2] + 4 ];
	assign read_data_c5 = mem_data[ block_address[( `dmem_len + 1 ):2] + 5 ];
	assign read_data_c6 = mem_data[ block_address[( `dmem_len + 1 ):2] + 6 ];
	assign read_data_c7 = mem_data[ block_address[( `dmem_len + 1 ):2] + 7 ];
	assign read_data_c8 = mem_data[ block_address[( `dmem_len + 1 ):2] + 8 ];
	assign read_data_c9 = mem_data[ block_address[( `dmem_len + 1 ):2] + 9 ];
	assign read_data_c10 = mem_data[ block_address[( `dmem_len + 1 ):2] + 10 ];
	assign read_data_c11 = mem_data[ block_address[( `dmem_len + 1 ):2] + 11 ];
	assign read_data_c12 = mem_data[ block_address[( `dmem_len + 1 ):2] + 12 ];
	assign read_data_c13 = mem_data[ block_address[( `dmem_len + 1 ):2] + 13 ];
	assign read_data_c14 = mem_data[ block_address[( `dmem_len + 1 ):2] + 14 ];
	assign read_data_c15 = mem_data[ block_address[( `dmem_len + 1 ):2] + 15 ];	

	always @( posedge clk )
		begin
			if ( write_d )
				mem_data[ address_d[( `dmem_len + 1 ):2] ] <= write_data_d;
		end	
endmodule
