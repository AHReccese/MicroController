# include <xc.h>
# include "configbits.c"
    
    .global main
     
    .set noreorder
    
    
.ent main
    
    main:
   	
     // Second Question
     		
      // set pb[0:7] as input pins for p[0:3] as number a and p[7:4] as number b
    la t0,ANSELB
    sw zero,0(t0)
    
    // we set PB[0:7] for input and PB[8:15] for output
    ori t1,zero,0x00FF
    la t0,TRISB
    sw t1,0(t0)
    // getting input and output address
    la t1,PORTB
    la t2,LATB
    
    loop:
	lw t0,0(t1)
	andi t0,t0,0x00ff  // extracting data
	andi t3,t0,0x000F  // extracting data
	andi t4,t0,0x00F0  // extracting data
	sll t3,t3,8  // shifting to an equal_value level!
	sll t4,t4,4 // shifting to an equal_value level!
	add t5,t3,t4  // add :)!
	
	lui s0,0x0000  // checking if there is need to repair --> comparing via 9!
	ori s0,s0,0x0900 // checking if there is need to repair --> comparing via 9! 
	sltu t6,s0,t5 // is it 9 less than it?!
	beq t6,zero,noNeedToRepair  // repair checkup...
	lui s0,0x0000 // repair
	ori s0,s0,0x0600 // repair
	add t5,s0,t5  // repair
	
	noNeedToRepair: 
	    or t0,t0,t5 // why actually!?
	    sw t0,0(t2)
    j loop
    nop
.end main    