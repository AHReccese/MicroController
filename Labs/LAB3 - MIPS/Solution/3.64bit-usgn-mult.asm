lui $t9,0x1001
lw $t0,0($t9)
lw $t1,4($t9)

lw $t2,8($t9)
lw $t3,0xC($t9)

multu $t0,$t2
mflo $t4
mfhi $t5

multu $t1,$t2
mflo $s0
mfhi $s7
multu $t0,$t3
mflo $s1
mfhi $s6

addu $t5,$t5,$s0
sltu $s0,$t5,$s0
addu $t5,$t5,$s1
sltu $s1,$t5,$s1

multu $t1,$t3
mflo $t6
mfhi $t7

addu $t6,$t6,$s0
sltu $s0,$t6,$s0
addu $t6,$t6,$s1
sltu $s1,$t6,$s1
addu $t6,$t6,$s7
sltu $s7,$t6,$s7
addu $t6,$t6,$s6
sltu $s6,$t6,$s6

addu $t7,$t7,$s0
addu $t7,$t7,$s1
addu $t7,$t7,$s6
addu $t7,$t7,$s7

sw $t4,0x10($t9)
sw $t5,0x14($t9)
sw $t6,0x18($t9)
sw $t7,0x1C($t9)
