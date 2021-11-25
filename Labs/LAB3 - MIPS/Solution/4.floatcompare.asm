lui $t9,0x1001
lw $t0,0($t9)
lw $t1,4($t9)

lui $s7,0x8000

and $s0,$t0,$s7
and $s1,$t1,$s7

beq $s0,$s1,L1
	beq $s0,$zero,L11
		sw $t0,4($t9)
		sw $t1,0($t9)
		j d1
		L11: sw $t1,4($t9)
		sw $t0,0($t9)
		j d1
	L1: beq $s0,$zero,L12
		sltu $s2,$t0,$t1
		beq $s2,$zero,L21
			sw $t1,4($t9)
			sw $t0,0($t9)
			j d1
			L21: sw $t0,4($t9)
			sw $t1,0($t9)
			j d1
		L12: sltu $t0,$t1,$s2
		beq $s2,$zero,L22
			sw $t0,4($t9)
			sw $t1,0($t9)
			j d1
			L22: sw $t1,4($t9)
			sw $t0,0($t9)
			d1: