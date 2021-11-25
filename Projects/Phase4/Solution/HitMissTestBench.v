`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sharif University
// Engineer: AmirHoseinRostami
// 
// Create Date:    6:19:24 06/24/2019 
// Design Name: 	 cache_project
// Module Name:    HitMissTestBench
// Project Name:   phase4
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
module HitMissTestBench();

integer i;

/*-----------------------------------------------------------------------------------------------
    				  Wires and registers
-------------------------------------------------------------------------------------------------*/
reg  clock, reset;								// clock , reset register
wire Hit;
wire [7:0]memData;
/*-----------------------------------------------------------------------------------------------
    				  Generating Reset and Clock
-------------------------------------------------------------------------------------------------*/
initial  				// meghdar dahi avalie reset va clock 
     begin
	clock = 1'b0 ;
     end

always 					// sakhtan clock be dore 20ns 
     begin
	#5 clock = 1 ;
	#5 clock = 0 ;
     end

	 
initial                                                
begin                                                  
    reset=1;
	@(posedge clock);
	reset=0;
	@(posedge clock);
	for(i=0;i<100;i=i+1)begin
		@(posedge clock);
		#1;
		if(Hit == 1)
		$display("Hit\n");
		else if(Hit == 0 )
		$display("Miss\n");
	end
	$stop;
	
end
                                          
                       
Top T1(.clk(clock),.Reset(reset),.Hit(Hit),.memOutData(memData));
                                                
endmodule

