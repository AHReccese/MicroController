BifromBCD:
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	andi $s0, $a0, 0xf
	andi $s1, $a0, 0xf0
	andi $s2, $a0, 0xf00
	andi $s3, $a0, 0xf000
	srl $a0, $a0, 16
	andi $s4, $a0, 0xf
	andi $s5, $a0, 0xf0
	andi $s6, $a0, 0xf00
	andi $s7, $a0, 0xf000
	
	srl $s1, $s1, 3
	srl $s2, $s2, 6
	srl $s3, $s3, 9
	srl $s5, $s5, 3
	srl $s6, $s6, 6
	srl $s7, $s7, 9
	
	addiu $t1, $0, 5
	addiu $t2, $0, 25
	addiu $t3, $0, 125
	addiu $t4, $0, 625
	addiu $t5, $0, 3125
	addiu $t6, $0, 15625
	addiu $t7, $0, 12589
	lui $t7,1
	
	addu $v0, $0, $s0
	
	multu $s1, $t1
	mflo $s1
	addu $v0, $v0, $s1
	
	multu $s2, $t2
	mflo $s2
	addu $v0, $v0, $s2
	
	multu $s3, $t3
	mflo $s3
	addu $v0, $v0, $s3
	
	multu $s4, $t4
	mflo $s4
	addu $v0, $v0, $s4
	
	multu $s5, $t5
	mflo $s5
	addu $v0, $v0, $s5
	
	multu $s6, $t6
	mflo $s6
	addu $v0, $v0, $s6
	
	multu $s7, $t7
	mflo $s7
	addu $v0, $v0, $s7
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra
