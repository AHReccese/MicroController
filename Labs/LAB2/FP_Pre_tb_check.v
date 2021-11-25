  `timescale 1ns/1ns
module FP_Pre_tb_check();
  reg [27:0] a,b;
  wire [28:0] result; 
  reg [28:0]result_p;
  wire [4:0] position; 
  reg[4:0]position_p;
  
  
  integer file1,file2,i,count,error;
  initial begin
	file1 = $fopen("input.hex","r");
	file2 = $fopen("output.hex","r");
	error=0;
	for(i=0 ; i<= 200; i=i+1) begin
		count=$fscanf (file1, "%28b\n", a);
		count=$fscanf (file1, "%28b\n", b);
	
		count=$fscanf (file2, "%29b\n", result_p);
		count=$fscanf (file2, "%5b\n", position_p);
	#10;
		if(result_p===result && position_p === position)
			$write ("True! a=%x , b= %x, result = %x , position= %x\n" , a , b , result , $unsigned(position));
		else begin
			error=error+1;
			$write ("Error ! a=%x , b= %x, result=%x , expected_result = %x , position= %x , expected_position= %x\n" , a , b , result ,result_p, $unsigned(position),$unsigned(position_p));
		end
	end
	if(error==0)
	$write ("No Error !! Great job /n");
	else
	$write ("%d Error Found !!/n",error);
	
	$fclose(file1);
	$fclose(file2);
    $stop;
  end
  
  FP_Pre1 uut( .a(a) , .b(b), .result(result), .position(position) );
  
endmodule

