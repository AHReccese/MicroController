
`timescale 1ns/1ns

module Pipeline__tb;
   integer file;
   reg clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 1;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 0;
   end

   initial
      $readmemh("isort32.hex", ACA_MIPS.InstructionMemory.imem);

   parameter end_pc = 32'h80;
 
   integer i;
   always @(ACA_MIPS.PCF)
      if(ACA_MIPS.PCF == end_pc) begin
         for(i=0; i<96; i=i+1) begin
            $write("%x ", ACA_MIPS.DataMemory.dmem[32+i]); // 32+ for iosort32
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         $stop;
      end
      
   MIPS_3 ACA_MIPS(
      .clk(clk),
      .reset(reset)
   );


endmodule

