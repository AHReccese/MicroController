lui $t9,0x1001
lw $t0,0($t9)
lw $t1,4($t9)

lw $t2,8($t9)
lw $t3,0xC($t9)

addu $t4,$t0,$t2
add $t5,$t1,$t3
sltu $t6,$t4,$t0
add $t5,$t5,$t6

sw $t4,0x10($t9)
sw $t5,0x14($t9)