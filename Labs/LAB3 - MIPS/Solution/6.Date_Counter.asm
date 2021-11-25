Date_Counter:
	addi $t0, $a2, -1300
	addiu $t1, $0, 4
	addiu $t2, $0, 365
	divu $t0, $t1
	mflo $t3
	mfhi $t4
	beq $t4, $0, KY
		addiu $t3, $t3, 1
    KY: multu $t0, $t2
	mflo $v0
	addi $a0, $a0, -1
	addu $v0, $v0, $a0
	addu $v0, $v0, $t3
	
	addiu $t0, $0, 7
	sltu $t1, $a1, $t0
	bne $t1, $0, SM
		addi $t1, $0, 30
		addi $t0, $a1, -7
		multu $t0, $t1
		mflo $t0
		addu $v0, $v0, $t0
		addiu $v0, $v0, 186
		jr $ra
    SM: 	addi $t1, $0, 31
		addi $a1, $a1, -1
		multu $t1, $a1
		mflo $t0
		addu $v0, $v0, $t0
		jr $ra