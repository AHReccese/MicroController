# include <xc.h>
# include "configbits.c"
    
    .global main
     
    .set noreorder
    
    
.ent main
    
    main:
    	
     // First Question another implementation
     // use all B pins as digital (16bits)
     la t0,ANSELB
     sw zero,0(t0)
     
     // set PB[0:7] as input and PB[8:15] for output
     ori t1,zero,0x00ff
     
     la t0,TRISB
     sw t1,0(t0)
     
     la t1,PORTB
     la t2,LATB
     
     loop:
     
     lw t0,0(t1)
     sll t0,t0,8
     sw t0,0(t2)
    j loop
    nop
	
.end main    