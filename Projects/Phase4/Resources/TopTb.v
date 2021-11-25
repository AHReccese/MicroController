
`timescale 1 ns/ 1 ps
module TopTb();

integer i,HitNum = 0;

/*-----------------------------------------------------------------------------------------------
    				  Wires and registers
-------------------------------------------------------------------------------------------------*/
reg  clock, reset;								// clock , reset register
wire Hit;
wire [7:0]MemSysOut;
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
	for(i=0;i<100;i=i+1)begin
		@(posedge clock);
		#1;
		HitNum=HitNum+Hit;
		$display("Memory Out: %d\n", MemSysOut);
	end
	$display("The Number of Hits is: %d", HitNum);
	$stop;
	
end    
                                          
                       
Top T1(.Clk(clock),.Reset(reset),.Hit(Hit),.MemSysOut(MemSysOut));
                                                
endmodule

