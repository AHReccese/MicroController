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

    
    la t0,ANSELB
    sw zero,0(t0)
    
    
    la t0,ANSELA
    sw zero,0(t0)
    
    
    //input and output
    
    la t1,TRISB
    ori t0,zero,0x0000
    sw t0,0(t1)
    
    
    la t1,TRISA
    ori t0,zero,0x000f
    sw t0,0(t1)
    
    
    la t1,PORTA
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
    
	add  t3, zero, zero
	add  s6, zero, zero
	add k1,zero,zero
	add  s7, zero, zero
	loop:
	
	
	
	lw s0,0x0(t1)
	bne zero,s0,counter
	nop
	
	jal func_display
	nop
	
	j loop
	nop
	
	counter:
	    
	// timer 1s
	    
	    
	    
	    
	    ori t8,zero,0x0009
	    for0: 
	    
	    
	    
	    ori t9,zero,0x0009
	    for10: 
	    
	    
	    
	    ori t4,t4,0x001f
	    for20: 
	    lw s0,0x0(t1)
	    bne zero,s0,loop
	    nop
	    
	    jal func_display
	    nop
	   
	    beq  t3,  t4, done20
	    nop
	    addi t3,  t3,0x1
		j for20
		nop
	    done20:
	    add  t3, zero, zero
	    addi k1,k1,1
    
	    beq  s7,t9,done10
	    nop
	    addi s7,s7,0x1
	    
	    j for10
	    nop
	    done10:
	    add  s7, zero, zero
	    andi k1,k1,0xFFF0
	    addi k1,k1,0x10
	    
	    
	    beq  s6,t8,done0
	    nop
	    addi s6,s6,0x1
	   
	    
	    
	    j for0
	    nop
	    done0:
	    add  s6, zero, zero
	    andi k1,k1,0xFF00
	    addi k1,k1,0x100
	    
	   
	 
	    //jal func_display
	    //nop

	    lw s0,0x0(t1)
	    bne zero,s0,loop
	    nop	

	    j counter 
	    nop
    
	
   	
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
