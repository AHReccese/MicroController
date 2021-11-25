#include <xc.h>
#include "configbits.c"
    .global main
    .set noreorder
.ent main
    main:
	
	// 3_1
	la t0,ANSELB
	sw zero,0(t0)
	la t0,ANSELA
	sw zero,0(t0)
	
	ori t1,zero,0xf000
	la t0,TRISB
	sw t1,0(t0)
	
	ori t1,zero,0
	la t0,TRISA
	sw t1,0(t0)
	
	addi sp,sp,-40
	addi t0,zero,0x3f //0
	sw t0, 0(sp)
	addi t0,zero,0x06 //1
	sw t0, 4(sp)
	addi t0,zero,0x5b //2
	sw t0, 8(sp)
	addi t0,zero,0x4f //3
	sw t0, 12(sp)
	addi t0,zero,0x66 //4
	sw t0, 16(sp)
	addi t0,zero,0x6d //5
	sw t0, 20(sp)
	addi t0,zero,0x7d //6
	sw t0, 24(sp)
	addi t0,zero,0x07 //7
	sw t0, 28(sp)
	addi t0,zero,0x7f //8
	sw t0, 32(sp)
	addi t0,zero,0x6f //9
	sw t0, 36(sp)

	la a0,LATA
	la a1,LATB
	la a3,PORTB
	
	ori t0,zero,0x001f
	la t1,CNPDA
	sw t0,0(t1)
	
	addi s1,zero,1
	ori s2,zero,0xf000
	addi k1,zero,50
	
	loop:
	    // soton 1
	    addi s0,zero,1
	    sw s0,0(a0)
	    ///// delayyyyyyyy/////
	    addi t7,zero,0
	    loop6:
	    addi t7,t7,1
	    bne t7,0x000f,loop6
	    nop
	    /////////////////////
	    lw s3,0(a3)
	    and s3,s3,s2
	    srl s3,s3,12
	    
	    // 1
	    addi s7,zero,1
	    beq s3,s1,loop_stable
	    nop
	    
	    // 4
	    srl s3,s3,1
	    addi s7,zero,4
	    beq s3,s1,loop_stable
	    nop
	    
	    // 7
	    srl s3,s3,1
	    addi s7,zero,7
	    beq s3,s1,loop_stable
	    nop
	    
	    // soton 2
	    addi s0,zero,2
	    sw s0,0(a0)
	    ///// delayyyyyyyy/////
	    addi t7,zero,0
	    loop7:
	    addi t7,t7,1
	    bne t7,0x000f,loop7
	    nop
	    /////////////////////
	    lw s3,0(a3)
	    and s3,s3,s2
	    srl s3,s3,12
	    
	    // 2
	    addi s7,zero,2
	    beq s3,s1,loop_stable
	    nop
	    
	    // 5
	    srl s3,s3,1
	    addi s7,zero,5
	    beq s3,s1,loop_stable
	    nop
	    
	    // 8
	    srl s3,s3,1
	    addi s7,zero,8
	    beq s3,s1,loop_stable
	    nop
	    
	    // 0
	    srl s3,s3,1
	    addi s7,zero,0
	    beq s3,s1,loop_stable
	    nop
	    
	    // soton 3
	    addi s0,zero,4
	    sw s0,0(a0)
	    ///// delayyyyyyyy/////
	    addi t7,zero,0
	    loop8:
	    addi t7,t7,1
	    bne t7,0x000f,loop8
	    nop
	    /////////////////////
	    lw s3,0(a3)
	    and s3,s3,s2
	    srl s3,s3,12
	    
	    // 3
	    addi s7,zero,3
	    beq s3,s1,loop_stable
	    nop
	    
	    // 6
	    srl s3,s3,1
	    addi s7,zero,6
	    beq s3,s1,loop_stable
	    nop
	    
	    // 9
	    srl s3,s3,1
	    addi s7,zero,9
	    beq s3,s1,loop_stable
	    nop
	    
	    
	j loop
	nop
	    
	loop_stable:
	///// delayyyyyyyy/////
	addi t7,zero,0
	loop9:
	addi t7,t7,1
	bne t7,0x0fff,loop9
	nop
	/////////////////////
	lw s3,0(a3)
	and s3,s3,s2
	srl s3,s3,12
	
	beq s3,zero,loop_stable_2
	nop
	addi s8,s7,0
	jal func7seg
	nop
	j loop_stable
	nop
	
	loop_stable_2:
	///// delayyyyyyyy/////
	addi t7,zero,0
	loop10:
	addi t7,t7,1
	bne t7,0x0fff,loop10
	nop
	/////////////////////
	lw s3,0(a3)
	and s3,s3,s2
	srl s3,s3,12
	
	loopp:
	beq s3,s1,loop
	nop
	addi s8,s7,0
	jal func7seg
	nop
	j loop_stable_2
	nop
	
	
	func7seg:
    	addi t1,zero,4 
	addi t6,zero,1
	addi t2,zero,0	   
	sll t5,t1,5	   
	
	loop7seg:
	
	addi t7,zero,0
	loop5:
	addi t7,t7,1
	bne t7,0x0fff,loop5
	nop
	
	
	addi t3,zero,0xf 
	add t0,zero,s8
	multu t1,t2
	mflo t6
	sllv t3,t3,t6	    
	and t0,t0,t3	    
	srlv t0,t0,t6	    
	
	multu t0,t1	     
	mflo t0
	add t0,t0,sp
	lw t0,0(t0)
	
	sll t5,t5,1	    
	or t0,t0,t5
	
	sw t0,0(a1)
	addi t2,t2,1
	
	bne t2,t1,loop7seg
	nop
	
	addi k0,k0,1
	bne k1,k0,func7seg
	nop
	
	addi k0,zero,0
	jr ra
	nop
	
	// 3_2
	la t0,ANSELB
	sw zero,0(t0)
	la t0,ANSELA
	sw zero,0(t0)
	
	ori t1,zero,0xf000
	la t0,TRISB
	sw t1,0(t0)
	
	ori t1,zero,0
	la t0,TRISA
	sw t1,0(t0)
	
	addi sp,sp,-40
	addi t0,zero,0x3f //DIGIT 0
	sw t0, 0(sp)
	addi t0,zero,0x06 //DIGIT 1
	sw t0, 4(sp)
	addi t0,zero,0x5b //DIGIT 2
	sw t0, 8(sp)
	addi t0,zero,0x4f //DIGIT 3
	sw t0, 12(sp)
	addi t0,zero,0x66 //DIGIT 4
	sw t0, 16(sp)
	addi t0,zero,0x6d //DIGIT 5
	sw t0, 20(sp)
	addi t0,zero,0x7d //DIGIT 6
	sw t0, 24(sp)
	addi t0,zero,0x07 //DIGIT 7
	sw t0, 28(sp)
	addi t0,zero,0x7f //DIGIT 8
	sw t0, 32(sp)
	addi t0,zero,0x6f //DIGIT 9
	sw t0, 36(sp)

	la a0,LATA
	la a1,LATB
	la a3,PORTB
	
	ori t0,zero,0x001f
	la t1,CNPDA
	sw t0,0(t1)
	
	addi s1,zero,1
	ori s2,zero,0xf000
	addi k1,zero,50
	
	loop:
	    // coloum 1
	    addi s0,zero,1
	    sw s0,0(a0)
	    
	    addi t7,zero,0
	    loop4:
	    addi t7,t7,1
	    bne t7,0x000f,loop4
	    nop
	    
	    lw s3,0(a3)
	    and s3,s3,s2
	    srl s3,s3,12
	    
	    // 1
	    addi s7,zero,1
	    beq s3,s1,loop_stable
	    nop
	    
	    // 4
	    srl s3,s3,1
	    addi s7,zero,4
	    beq s3,s1,loop_stable
	    nop
	    
	    // 7
	    srl s3,s3,1
	    addi s7,zero,7
	    beq s3,s1,loop_stable
	    nop
	    
	    // coloum 2
	    addi s0,zero,2
	    sw s0,0(a0)
	    
	    addi t7,zero,0
	    loop5:
	    addi t7,t7,1
	    bne t7,0x000f,loop5
	    nop
	    
	    lw s3,0(a3)
	    and s3,s3,s2
	    srl s3,s3,12
	    
	    // 2
	    addi s7,zero,2
	    beq s3,s1,loop_stable
	    nop
	    
	    // 5
	    srl s3,s3,1
	    addi s7,zero,5
	    beq s3,s1,loop_stable
	    nop
	    
	    // 8
	    srl s3,s3,1
	    addi s7,zero,8
	    beq s3,s1,loop_stable
	    nop
	    
	    // 0
	    srl s3,s3,1
	    addi s7,zero,0
	    beq s3,s1,loop_stable
	    nop
	    
	    // coloum 3
	    addi s0,zero,4
	    sw s0,0(a0)
	    
	    addi t7,zero,0
	    loop6:
	    addi t7,t7,1
	    bne t7,0x000f,loop6
	    nop
	    
	    lw s3,0(a3)
	    and s3,s3,s2
	    srl s3,s3,12
	    
	    // 3
	    addi s7,zero,3
	    beq s3,s1,loop_stable
	    nop
	    
	    // 6
	    srl s3,s3,1
	    addi s7,zero,6
	    beq s3,s1,loop_stable
	    nop
	    
	    // 9
	    srl s3,s3,1
	    addi s7,zero,9
	    beq s3,s1,loop_stable
	    nop
	    
	    
	j loop
	nop
	    
	loop_stable:
    
	addi t7,zero,0
	loop7:
	addi t7,t7,1
	bne t7,0x0fff,loop7
	nop
	
	lw s3,0(a3)
	and s3,s3,s2
	srl s3,s3,12
	
	beq s3,zero,loop_stable_2
	nop
	or s8,s8,s7
	jal func7seg
	nop
	j loop_stable
	nop
	
	loop_stable_2:
	addi t7,zero,0
	loop8:
	addi t7,t7,1
	bne t7,0x0fff,loop8
	nop
	
	lw s3,0(a3)
	and s3,s3,s2
	srl s3,s3,12
	addi s0,zero,0x001f
	sw s0,0(a0)
	addi s4,zero,2
	addi s5,zero,4
	addi s6,zero,8
	addi k0,zero,1
	
	beq s3,s4,loop_shift
	nop
	
	beq s3,s5,loop_shift
	nop
	
	beq s3,s6,loop_shift
	nop
	
	beq s3,k0,loop_shift
	nop
	
	or s8,s8,s7
	jal func7seg
	nop
	j loop_stable_2
	nop
	
	loop_shift:
	sll s8,s8,4
	j loop
	nop
	
	func7seg:
    	addi t1,zero,4   
	addi t6,zero,1	
	addi t2,zero,0	    
	sll t5,t1,5	    

	loop7seg:

	addi t7,zero,0
	oskol:
	addi t7,t7,1
	bne t7,0x0fff,oskol
	nop
	
	
	addi t3,zero,0xf    
	add t0,zero,s8  
	multu t1,t2
	mflo t6
	sllv t3,t3,t6	
	and t0,t0,t3	   
	srlv t0,t0,t6	   
	
	multu t0,t1	   
	mflo t0
	add t0,t0,sp
	lw t0,0(t0)
	
	sll t5,t5,1	   
	or t0,t0,t5
	
	sw t0,0(a1)
	addi t2,t2,1
	
	bne t2,t1,loop7seg
	nop
	
	addi k0,k0,1
	bne k1,k0,func7seg
	nop
	
	addi k0,zero,0
	jr ra
	nop
	
    
	// Q3 key pad all togather ...
	
	  
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
    
    
    
    
    /*
   // Question number 3
    
#include <xc.h>
#include "configbits.c"
    
    .global main
    
    .set noreorder
    
.ent main
   main: 
    
 // use all A,B ports as digital(they are 16 bits...)
 la t0,ANSELA
 sw zero ,0(t0)
 la t0,ANSELB
 sw zero,0(t0)
 
 // set RAs as input
 ori t1,zero,0xffff
 la t0,TRISA
 sw t1,0(t0)
 
 // set RBs as output
 ori t1,zero,0x0000
 la t0,TRISB
 sw t1,0(t0)
 
 
// make A pull down
 ori t1,zero,0x001f
 la t0,CNPDA
 sw t1,0(t0)
    
ori t1,zero,0xf000
la t0,CNPDB
sw t1,0(t0) 

 
// set sevenSeg Look up table

addiu sp,sp,-44
 
    addiu t0,zero,0x003f // Digit 0 
    sw t0,0(sp)
    
    addiu t0,zero,0x0006 // Digit 1 
    sw t0,4(sp)
    
    addiu t0,zero,0x005b // Digit 2 
    sw t0,8(sp)
    
    addiu t0,zero,0x004f // Digit 3 
    sw t0,12(sp)
    
    addiu t0,zero,0x0066 // Digit 4 
    sw t0,16(sp)
    
    addiu t0,zero,0x006d // Digit 5 
    sw t0,20(sp)
    
    addiu t0,zero,0x007d // Digit 6 
    sw t0,24(sp)
    
    addiu t0,zero,0x0007 // Digit 7 
    sw t0,28(sp)
    
    addiu t0,zero,0x007f // Digit 8 
    sw t0,32(sp)
    
    addiu t0,zero,0x006f // Digit 9 
    sw t0,36(sp)
    
    addiu t0,zero,0x0000 // off 
    sw t0,40(sp)
    
    
    // timer tmp for getting input ...
 and t4,t4,zero
 lui t6,0x0000
 ori t6,t6,0x00ff
 
 // tmp if input touched
 and t3,t3,zero
 
 // t8 = output
 ori t8,zero,0xAAAA
 
 // state of led
 addi s4,zero,0x0004
 and s5,s5,zero
 
 ori t1,zero,0xf000
 la t0,LATB
 sw t1,0(t0)
 
 
 la t0,PORTA
 la t1,PORTB
 la t2,LATB
 
 // debouncing
 loop:
    
    bne t4,t6,continue
    nop
    and t4,t4,zero
    
    // read and compile
    sw t1,0(t0)
    ori t1,zero,0xffff
    la t0,TRISA
    sw t1,0(t0)
    ori t1,zero,0x0000
    la t0,TRISB
    sw t1,0(t0)
    
    ori t1,zero,0xf000
    la t0,LATB
    sw t1,0(t0)
    
    la t0,PORTA
    la t1,PORTB
 
    lw s0,0(t0)
    andi s0,s0,0x001f
    
    beq s0,zero,c1
    nop
    
    bne t3,zero,continue
    nop
    
    addi t3,zero,1
    
    // check keypad and save BCD Number in t8
    
    lw a0,0(t0)
    ori a1,zero,0x0800
    
    ll:
    sll a1,a1,1
    or t1,zero,a1
    la t0,LATB
    sw t1,0(t0)
    
    la t0,PORTA
    la t1,PORTB
    
    lw s7,0(t0)
    beq s7,zero,ll
    nop
    
    andi a0,a0,0x001f
    andi a1,a1,0xf000
    srl a1,a1,12
    
    jal Keypad
    nop
    
    //....
    add s5,zero,3
    bne v1,s5,cccc1
    nop
    addi t8,zero,0xAAA0
    addi s4,zero,0x0000
    j cccc2
 
    cccc1:
	
	andi s5,t8,0xf000
	ori s7,zero,0xA000
	bne s5,s7,cccc2
	nop
	
	and s5,s5,zero
	bne v1,s5,cccc3
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0001
	j cccc2
	nop 
	
    cccc3:
	
	add s5,s5,1
	bne v1,s5,cccc4
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0002
	j cccc2
	nop
	
    cccc4:
    
	add s5,s5,1
	bne v1,s5,cccc5
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0003
	j cccc2
	nop
	
    cccc5:
	    
	add s5,s5,3
	bne v1,s5,cccc6
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0004
	j cccc2
	nop
	
    cccc6:
	
	add s5,s5,1
	bne v1,s5,cccc7
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0005
	j cccc2
	nop
	
    cccc7:
	
	add s5,s5,1
	bne v1,s5,cccc8
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0006
	j cccc2
	nop
	
    cccc8:
    
	add s5,s5,3
	bne v1,s5,cccc9
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0007
	j cccc2
	nop
	
    cccc9:
	
	add s5,s5,1
	bne v1,s5,cccc10
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0008
	j cccc2
	nop
	
    cccc10:
	
	add s5,s5,1
	bne v1,s5,cccc11
	nop
	sllv t8,t8,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0009
	j cccc2
	nop
	
    cccc11:
	
	add s5,s5,4
	bne v1,s5,cccc12
	nop
	sllv s4,zero,s4
	addi s4,zero,0x0004
	ori t8,t8,0x0000
	j cccc2
	nop
	
    cccc12:
    cccc2:
    
	j continue
	nop
    
    c1:
	and t3,t3,zero
    
    continue:
	addi t4,t4,1
    // show t8(time)
        add a0,t8,zero
	jal SEG
	nop
	
    j loop
    nop
    
    Keypad:
    
    // input a0 for 5 bit A and a1 for 4 bit B
    // 0 base output number in v1
    
	and v0,v0,zero
	and v1,v1,zero
    
	andi v0,a1,0x0002
	beq v0,zero,ccc1
	nop
	addi v1,v1,5
    
    ccc1:
    
	andi v0,a1,0x0004
	beq v0,zero,ccc2
	nop
	addi v1,v1,10
    
    ccc2:
    
	andi v0,a1,0x0008
	beq v0,zero,ccc3
	nop
	addi v1,v1,15
    
    ccc3:
    
	andi v0,a0,0x0002
	beq v0,zero,ccc4
	nop
	addi v1,v1,1
    
    ccc4:
    
	andi v0,a0,0x0004
	beq v0,zero,ccc5
	nop
	addi v1,v1,2
    
    ccc5:
    
	andi v0,a0,0x0008
	beq v0,zero,ccc6
	nop
	addi v1,v1,3
    
    ccc6:
    
	andi v0,a0,0x0010
	beq v0,zero,ccc7
	nop
	addi v1,v1,4
    
    ccc7:
    
	jr ra
	nop
    
    
    SEG:
	// set show delay
	and s6,s6,zero
	lui s7,0x0000
	ori s7,s7,0x00ff
	
	// set input it should be BCD
	
	add a1,a0,zero
	and k0,k0,zero
	ori k0,zero,0x1532
	bne a0,k0,lll
	nop
	sw v0,0(t2)
	
	
	// SevenSeg check number 1
	andi v0,a1,0x000f
	sll v0,v0,2
	add v0,v0,sp
	lw v0,0x0(v0)
	ori v0,v0,0x0180
	sw v0,0(t2)
	j llll
	nop
	
    lll:
	// check sevenSeg number 1
	andi v0,a1,0x000f
	sll v0,v0,2
	add v0,v0,sp
	lw v0,0x0(v0)
	ori v0,v0,0x0100
	sw v0,0(t2)
	
    llll:
    
	cc1:
	    beq s6,s7,cc2
	    nop
		addi s6,s6,1
		j cc1
		nop
	cc2:
	
	// 7Seg check number 2
	    srl a1,a1,4
	    andi v0,a1,0x000f
	    sll v0,v0,2
	    add v0,v0,sp
	    lw v0,0x0(v0)
	    ori v0,v0,0x0200
	    sw v0,0(t2)	
	    and s6,s6,zero
	    
	cc3:
	    beq s6,s7,cc4
	    nop
	    addi s6,s6,1
	    j cc3
	
	// check seven Seg number 3
	cc4:    
	    srl a1,a1,4
	    andi v0,a1,0x000f
	    sll v0,v0,2
	    add v0,v0,sp
	    lw v0,0x0(v0)
	    ori v0,v0,0x0400
	    sw v0,0(t2)
	
	    and s6,s6,zero
	    
	cc5:
	    beq s6,s7,cc6
	    nop
	    addi s6,s6,1
	    j cc5
	    nop
	    
	cc6:
	
	//check seven Seg number 4
	    srl a1,a1,4
	    andi v0,a1,0x000f
	    sll v0,v0,2
	    add v0,v0,sp
	    lw v0,0x0(v0)
	    ori v0,v0,0x0800
	    sw v0,0(t2)
	
	    and s6,s6,zero
	cc7:
	    beq s6,s7,cc8
	    nop
	    addi s6,s6,1
	    j cc7
	    nop
	    
	cc8:
	jr ra
	nop
	
    
    
.end main