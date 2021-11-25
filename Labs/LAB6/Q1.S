		// via lookup table

#include <xc.h>
#include "configbits.c"
    .global main
    .set noreorder
.ent main
    main:
    /*
    la t0,ANSELB
    sw zero,0(t0)
    */
    
    la t0,ANSELA
    sw zero,0(t0)
    
    
    //input and output
    
    la t1,TRISB
    ori t0,zero,0x0000
    sw t0,0(t1)
    
    /*
    la t1,TRISA
    ori t0,zero,0x000f
    sw t0,0(t1)
    */
    
    //la t1,PORTA
    la t2,LATB
    
    //timer
    la s2,T4CON
    lw s3,0x0(s2)
    ori s3,s3,0x8000
    sw s3,0x0(s2)
    
    addi s2,zero,5
    la s3,PR4
    sw s2,0x0(s3)
   
    
    la s4,TMR4
    addiu sp, sp, -40
	addiu t0, zero, 0x0006 /*DIGIT 1*/
	sw t0, 4(sp)
	addiu t0, zero, 0x005b /*DIGIT 2*/
	sw t0, 8(sp)
	addiu t0, zero, 0x004f /*DIGIT 3*/
	sw t0, 12(sp)
	addiu t0, zero, 0x0066 /*DIGIT 4*/
	sw t0, 16(sp)
	addiu t0, zero, 0x006d /*DIGIT 5*/
	sw t0, 20(sp)
	addiu t0, zero, 0x007d /*DIGIT 6*/
	sw t0, 24(sp)
	addiu t0, zero, 0x0007 /*DIGIT 7*/
	sw t0, 28(sp)
	addiu t0, zero, 0x007F /*DIGIT 8*/
	sw t0, 32(sp)
	addiu t0, zero, 0x006F /*DIGIT 9*/
	sw t0, 36(sp)
	addiu t0, zero, 0x003F /*DIGIT 0*/
	sw t0, 0(sp)
    
	loop:
	ori k1,zero,0x8643
	jal func_display
	nop

	j loop 
	nop
    
	// number
	
	
    func_display:
	    add s0,zero,k1

	// first seg
	    andi s4,s0,0x000F
	// delay between number 1_2
	    add  s5, zero, zero
	    
	    ori t7,t7,0x0FFF
	    for1: 
	    beq  s5,  t7, done1
	    nop
	    addi s5,  s5,0x1
		j for1
		nop
	    done1:

	// disply

	    sll k0,s4,2
	    add k0,sp,k0
	    lw k0,0x0(k0)
	    ori k0,k0,0x100
	    sw k0,0x0(t2)



	// seconde seg
	    srl s0,s0,4
	    andi s4,s0,0x000F
	// delay between number 2_3

	    add  s5, zero, zero
	    
	    ori t7,t7,0x0FFF
	    for2: 
	    beq  s5,  t7, done2
	    nop
	    addi s5,  s5,0x1
		j for2
		nop
	    done2:
	    // disply

		sll k0,s4,2
		add k0,sp,k0
		lw k0,0x0(k0)
		ori k0,k0,0x200
		sw k0,0x0(t2)



	// thrid seg
	    srl s0,s0,4
	    andi s4,s0,0x000F
	// delay between number 3_4
	    add  s5, zero, zero
	    
	    ori t7,t7,0x0FFF
	    for3: 
	    beq  s5,  t7, done3
	    nop
	    addi s5,  s5,0x1
		j for3
		nop
	    done3:

	    // disply

		sll k0,s4,2
		add k0,sp,k0
		lw k0,0x0(k0)
		ori k0,k0,0x400
		sw k0,0x0(t2)



	// forth seg
	    srl s0,s0,4
	    andi s4,s0,0x000F
	// delay between number 4_1
	    add  s5, zero, zero
	    
	    ori t7,t7,0x0FFF
	    for4: 
	    beq  s5,  t7, done4
	    nop
	    addi s5,  s5,0x1
		j for4
		nop
	    done4:
	    // disply

		sll k0,s4,2
		add k0,sp,k0
		lw k0,0x0(k0)
		ori k0,k0,0x800
		sw k0,0x0(t2)
	    jr ra
	    nop
		
		
		
    
.end main

	// another implementation for seven seg Data
	// without look up table	
		


# include <xc.h>
# include "configbits.c"
    
    .global main
     
    .set noreorder
    
    
.ent main
    
    main:
   				
	j loop
	nop
	
    loop:		
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
    
    
	lw t0,0(t1)
	andi t0,t0,0x00ff  // extracting data
	andi t3,t0,0x000F  // extracting data
	andi t4,t0,0x00F0  // extracting data
	
	// make two digits equal_value.
	sll t3,t3,4
	
	srl t3,t3,4
	srl t4,t4,4
	
	mult t3,t4
	mflo t6
	div t6,10
	mflo t6 // kharej ghesmat
	mfhi t7 // baghi mandeh
	
	// in order to show on LED bus.
	// this part is for turning   
	//sll t6,t6,4
	//or t0,t6,t7
	//sw t0,0(t2)

	// t6 and t7 is ready
	
	// switch Case
	addi s0,zero,0
	beq s0,t6,L0
	nop
	addi s0,zero,1
	beq s0,t6,L1
	nop
	addi s0,zero,2
	beq s0,t6,L2
	nop
	addi s0,zero,3
	beq s0,t6,L3
	nop
	addi s0,zero,4
	beq s0,t6,L4
	nop
	addi s0,zero,5
	beq s0,t6,L5
	nop
	addi s0,zero,6
	beq s0,t6,L6
	nop
	addi s0,zero,7
	beq s0,t6,L7
	nop
	addi s0,zero,8
	beq s0,t6,L8
	nop
	addi s0,zero,9
	beq s0,t6,L9
	nop
	
    contin1:
	// switch Case
	addi s0,zero,0
	beq s0,t7,L00
	nop
	addi s0,zero,1
	beq s0,t7,L11
	nop
	addi s0,zero,2
	beq s0,t7,L22
	nop
	addi s0,zero,3
	beq s0,t7,L33
	nop
	addi s0,zero,4
	beq s0,t7,L44
	nop
	addi s0,zero,5
	beq s0,t7,L55
	nop
	addi s0,zero,6
	beq s0,t7,L66
	nop
	addi s0,zero,7
	beq s0,t7,L77
	nop
	addi s0,zero,8
	beq s0,t7,L88
	nop
	addi s0,zero,9
	beq s0,t7,L99
	nop
	
    contin2:
    
	la t3,ANSELB
	sw zero,0(t3)
	
	ori t4,zero,0x0000
        la t3,TRISB
        sw t4,0(t3)
	
	la t3,LATB
	sw s5,0(t3)
	
	// these are for delays
	nop
	
	sw t1,0(t3)
	
	// these are for delays
	nop
	
	
    j loop
    nop
	
    // MSB BCD digit conver to sevenSeg DATA
 L0: 
    addi s5,zero,0b0000010000111111
    j contin1
    nop
 L1:
    addi s5,zero,0b0000010000000110
    j contin1
    nop
 L2:
    addi s5,zero,0b0000010001011011
    j contin1
    nop
 L3:
    addi s5,zero,0b0000010001001111
    j contin1
    nop
 L4:
    addi s5,zero,0b0000010001100110
    j contin1
    nop
 L5:  
    addi s5,zero,0b0000010001101101
    j contin1
    nop
 L6:   
    addi s5,zero,0b0000010001111101
    j contin1
    nop
 L7:   
    addi s5,zero,0b0000010000000111
    j contin1
    nop
 L8:    
    addi s5,zero,0b0000010001111111
    j contin1
    nop
 L9:
    addi s5,zero,0b0000010001101111
    j contin1
    nop
    
    
    // LSB BCD digit convert to sevenSeg DATA
 L00: 
    addi t1,zero,0b0000000100111111
    j contin2
    nop
 L11:
    addi t1,zero,0b0000000100000110
    j contin2
    nop
 L22:
    addi t1,zero,0b0000000101011011
    j contin2
    nop
 L33:
    addi t1,zero,0b0000000101001111
    j contin2
    nop
 L44:
    addi t1,zero,0b0000000101100110
    j contin2
    nop
 L55:  
    addi t1,zero,0b0000000101101101
    j contin2
    nop
 L66:  
    addi t1,zero,0b0000000101111101
    j contin2
    nop
 L77:   
    addi t1,zero,0b0000000100000111
    j contin2
    nop
 L88:    
    addi t1,zero,0b0000000101111111
    j contin2
    nop
 L99:
    addi t1,zero,0b0000000101101111
    j contin2
    nop
       	
.end main
     
     
