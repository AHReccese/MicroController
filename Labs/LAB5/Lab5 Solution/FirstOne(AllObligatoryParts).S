	
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
    
    // turn T4CON counter on
    la t3,T4CON
    lw t4,0(t3)
    ori t4,t4,0x8000
    sw t4,0(t3)
    
    // counter counts from 0 to 5
    
    addi t4,zero,5
    la t3,PR4
    sw t4,0(t3)
    
    
    // temp variable --> if input touched 
    and t3,t3,zero
    
    // timer temp variable for getting input
    
    and t4,t4,zero
    lui t6,0x0000
    ori t6,t6,0xffff
    
    
    la t0,PORTA
    la t1,PORTB // there isnt any need for this because port B isan output
    la t2,LATB
    la t5,TMR4
    
    loop:
	bne t4,t6,continue 
	nop
	// it is debounced ok lets go to read
	lw s0,0(t0)
	// reading from the first input
	andi s0,s0,0x0001

	beq s0,zero,no_input
	nop
	// pushbutton is not clicked! so let go and reset both counters and set previous state! --> for no repeatation
	
	bne t3,zero,stil_pressing
	nop
	// no repeatation for random print !!!
	
	lw t7,0(t5)
	
	
	//  and s2,s2,zero
	//  add s2,s2,7
	//  div t7,s2
	//  mfhi t7
	
	// loading the timer --> gernerating the random number!
	
	addi t7,t7,0x0001
	addi t3,t3,0x0001
	
	// 7seg data
	// reseting the SevenSeg Data's
	// s0 is for finding dice's number.
	
	and s0,s0,zero
	and s1,s1,zero
	
	bne t7,s0,sevenSeg_1
	nop
	// SevenSeg number is zero
	ori s1,s1,0x013f // 0x0000_0001_0011_1111
	
	sevenSeg_1:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_2
	nop
	ori s1,s1,0x0106 // 0x0000_0001_0000_0110
	
	sevenSeg_2:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_3
	nop
	ori s1,s1,0x015b // 0x0000_0001_0101_1011
	
	sevenSeg_3:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_4
	nop
	ori s1,s1,0x014f // 0x0000_0001_0100_1111
	
	sevenSeg_4:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_5
	nop
	ori s1,s1,0x0166 // 0x0000_0001_0110_0110
	
	sevenSeg_5:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_6
	nop
	ori s1,s1,0x016d // 0x0000_0001_0110_1101
	
	sevenSeg_6:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_7
	nop
	ori s1,s1,0x017d // 0x0000_0001_0111_1101

	sevenSeg_7:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_8
	nop
	ori s1,s1,0x //0x0000_0001_0000_0111 
	
	sevenSeg_8:
	addi s0,s0,0x0001
	
	bne t7,s0,sevenSeg_9
	nop
	ori s1,s1,0x //0x0000_0001_0111_1111 
	
	sevenSeg_9:
	addi s0,s0,0x0001
	
	// no need for other numbers just random numbers between [0 & 9]
	// you can add more codes here ...
	nop
	ori s1,s1,0x //0x0000_0001_0110_0111
	    
	
	sw s1,0(t2)
	and t4,t4,zero
	j continue
	nop
	
	no_input:
	and t3,t3,zero
	stil_pressing:
	and t4,t4,zero
	
	// til being debounced !!!
	continue:
	    addi t4,t4,0x0001 
	    
    j loop
    nop
   
.end main
		    
		
		*/
		    