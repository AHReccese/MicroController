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
    lui t6,0x000f
    ori t6,t6,0xffff
    
    
    la t0,PORTA
    la t1,PORTB // there isnt any need for this because port B isan output
    la t2,LATB
    la t5,TMR4
    
    //s0 is the output result ...
    // and it is zero first!
    
    and s0,s0,zero
    
    loop:
    
	bne t4,t6,continue 
	nop
	
	//look if there is any button pressed!
	lw s1,0(t0)
	beq s1,1,addLedFromInput
	nop
	j addLed
	nop
	
	addLedFromInput:
	srl s0,s0,1
	ori s0,s0,0x0080 // 0000_0000_1000_0000
	j write
	nop
	
	addLed:
	sll s2,s0,31
	srl s2,s2,31
	beq s2,1,createCycle 
	nop
	srl s0,s0,1
	j write
	nop
	
	createCycle:
	// shift the LSB --> it goes to MSB
	srl s0,s0,1
	// Going
	ori s0,s0,0x0080 // 0000_0000_1000_0000
	// Gone
	
	write:
	sll s0,s0,8
	sw s0,0(t2)
	srl s0,s0,8
	//reset counter
	and t4,t4,zero
	j loop
	nop
	
	continue:
	    addi t4,t4,0x0001 
	    
    j loop
    nop
   
.end main
		
		*/
		
		