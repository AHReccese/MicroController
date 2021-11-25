		    
		
		/*
#include <xc.h>
#include "configbits.c"
    
    .global main
    .set noreorder
    
.ent main
   main: 
    
    // use all A,B ports as digital
    
    la t0,ANSELA
    sw zero,0(t0)
    la t0,ANSELB
    sw zero,0(t0)
    
    // set All As for input and set All Bs for output
    
    ori t1,zero,0xffff
    la t0,TRISA
    sw t1,0(t0)
    
    ori t1,zero,0x0000
    la t0,TRISB
    sw t1,0(t0)
    
    //	turn T4CON counter on
    //	la t3,T4CON
    //	lw t4,0(t3)
    //	ori t4,t4,0x8000
    //	sw t4,0(t3)
    // counter counts from 0 to 5
    
    //addi t4,zero,5
    //la t3,PR4
    //sw t4,0(t3)
    
    
    // digit_level
    and s0,s0,zero
    addi s0,s0,8 // digit level from right(mathematicly) --> hashtomin ragham az samt rast
    // student_id consists 8 digits ...
    
    // timer temp variable for delta t
    // t4 counts til reach t6
    and t4,t4,zero
    lui t6,0x000f
    ori t6,t6,0xffff
    
    //la t0,PORTA
    // there is no need to readFrom input
    la t1,PORTB // there isnt any need for this because port B isan output
    la t2,LATB
    //la t5,TMR4
   
    loop:
    
	bne t4,t6,continue 
	nop
	// delta gone go next
	
	beq s0,8,sevenSeg_9
	nop
	beq s0,7,sevenSeg_6
	nop
	beq s0,6,sevenSeg_1
	nop
	beq s0,5,sevenSeg_0
	nop
	beq s0,4,sevenSeg_1
	nop
	beq s0,3,sevenSeg_6
	nop
	beq s0,2,sevenSeg_3
	nop
	beq s0,1,sevenSeg_5
	nop
	
	sevenSeg_9:
	ori s1,s1,0x0167 // 0x0000_0001_0110_0111
	j writeMe
	nop
     
	sevenSeg_6:
	ori s1,s1,0x017d // 0x0000_0001_0111_1101
	j writeMe
	nop
     
	sevenSeg_1:
	ori s1,s1,0x0106 // 0x0000_0001_0000_0110
	j writeMe
	nop
     
	sevenSeg_0:
	ori s1,s1,0x013f // 0x0000_0001_0011_1111
	j writeMe
	nop
     
	//sevenSeg_1:
	//ori s1,s1,0x017d // 0x0000_0001_0111_1101
	//j writeMe
	//nop
     
	//sevenSeg_6:
	//ori s1,s1,0x017d // 0x0000_0001_0111_1101
	//j writeMe
	//nop
     
	sevenSeg_3:
	ori s1,s1,0x014f // 0x0000_0001_0100_1111
	j writeMe
	nop
     
	sevenSeg_5:
	ori s1,s1,0x016d // 0x0000_0001_0110_1101
	j writeMe
	nop
     
	// if it reaches here so one digit is showed so t4 should be reset
	    writeMe: 
		sw s1,0(t2)
		and s1,s1,zero
		// one level shift to write
		addi s0,s0,-1
		// checking the reset point
		beq s0,0,reset
		nop
		j noreset
		nop
		    reset:
		    ori s0,s0,0x0009
		    
		// reset counter in order to recount (delta_time) --> delta t!
		noreset:
		and t4,t4,zero
	continue:
	    addi t4,t4,0x0001 
	    
    j loop
    nop
   
.end main
		    
		*/